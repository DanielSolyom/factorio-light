"""Publish only an archive whose digest matches the successful QA report.

FACTORIO_API_KEY is read from the environment. Never log credentials or upload URLs.
Uses the official Mod Portal publish/upload/details APIs and Python's stdlib.
"""
import hashlib
import json
import os
import re
from pathlib import Path
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
API = "https://mods.factorio.com/api"


def api_key():
    token = os.environ.get("FACTORIO_API_KEY", "").strip()
    if not token or any(ord(char) < 33 or ord(char) > 126 for char in token):
        raise ValueError("FACTORIO_API_KEY must contain only the API key value, without internal whitespace or control characters")
    return token


def request(url, fields=None, token=None, file=None):
    headers = {"User-Agent": "Factorio-Light-release/1.0"}
    if token:
        headers["Authorization"] = "Bearer " + token
    payload = None
    if file:
        boundary = "FactorioLight" + uuid.uuid4().hex
        parts = []
        for key, value in fields or []:
            parts.append(f'--{boundary}\r\nContent-Disposition: form-data; name="{key}"\r\n\r\n{value}\r\n'.encode())
        parts.extend([
            f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="{file.name}"\r\nContent-Type: application/zip\r\n\r\n'.encode(),
            file.read_bytes(), f"\r\n--{boundary}--\r\n".encode()])
        payload = b"".join(parts)
        headers["Content-Type"] = f"multipart/form-data; boundary={boundary}"
    elif fields is not None:
        payload = urllib.parse.urlencode(fields).encode()
        headers["Content-Type"] = "application/x-www-form-urlencoded"
    req = urllib.request.Request(url, data=payload, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            result = json.load(response)
    except urllib.error.HTTPError as error:
        # HTTP status is useful; the request URL may contain an upload secret.
        try:
            details = json.load(error)
        except (ValueError, UnicodeDecodeError):
            details = {}
        message = str(details.get("message", ""))
        if token:
            message = message.replace(token, "[redacted]")
        message = re.sub(r"https?://\S+", "[redacted URL]", message)
        code = details.get("error", "")
        suffix = f": {code} {message}" if code or message else ""
        raise RuntimeError(f"Mod Portal returned HTTP {error.code}{suffix}") from None
    if result.get("error"):
        raise RuntimeError(f"Mod Portal API error: {result['error']}")
    return result


def verified_archive(path, report_path):
    report = json.loads(report_path.read_text())
    assert report["status"] == "passed", "QA report did not pass"
    assert report["package"] == path.name, "QA report belongs to another archive"
    assert report["sha256"] == hashlib.sha256(path.read_bytes()).hexdigest(), "Archive changed after QA"
    with ZipFile(path) as archive:
        names = archive.namelist()
        info_paths = [n for n in names if n.endswith("/info.json")]
        assert len(info_paths) == 1
        info = json.loads(archive.read(info_paths[0]))
    assert info["name"] == "factorio-light-space-age" and info["version"] == report["mod_version"]
    return info


def update_details(name, token):
    config = json.loads((ROOT / "portal.json").read_text())
    description = (ROOT / config["description_file"]).read_text()
    fields = [("mod", name)]
    keys = ["title", "summary", "category", "license", "homepage", "source_url"]
    fields += [(key, config[key]) for key in keys]
    fields += [("description", description)]
    fields += [("tags", tag) for tag in config["tags"]]
    assert request(f"{API}/v2/mods/edit_details", fields, token).get("success"), "Page update failed"
    # The public API may briefly serve the previous page after a successful edit.
    for attempt in range(5):
        remote = request(f"{API}/mods/{name}/full")
        mismatches = []
        if remote["description"].strip() != description.strip():
            mismatches.append("description")
        for key in keys:
            actual = remote["license"]["id"] if key == "license" else remote[key]
            if actual != config[key]:
                mismatches.append(key)
        if set(remote["tags"]) != set(config["tags"]):
            mismatches.append("tags")
        if not mismatches:
            return remote
        if attempt < 4:
            time.sleep(2 ** attempt)
    raise AssertionError("Published page differs: " + ", ".join(mismatches))


def publish(path, report_path):
    info = verified_archive(path, report_path)
    token = api_key()
    config = json.loads((ROOT / "portal.json").read_text())
    try:
        existing = request(f"{API}/mods/{info['name']}/full")
    except RuntimeError as error:
        if not str(error).startswith("Mod Portal returned HTTP 404"):
            raise
        existing = None
    releases = existing.get("releases", []) if existing else []
    if info["version"] not in {r["version"] for r in releases}:
        endpoint = "releases/init_upload" if existing else "init_publish"
        result = request(f"{API}/v2/mods/{endpoint}", [("mod", info["name"])], token)
        url = result["upload_url"]
        parsed = urllib.parse.urlparse(url)
        assert parsed.scheme == "https", "Non-HTTPS upload URL"
        fields = [("description", (ROOT / config["description_file"]).read_text()),
                  ("category", config["category"]), ("license", config["license"]),
                  ("source_url", config["source_url"])] if not existing else []
        assert request(url, fields, file=path).get("success"), "Upload failed"
        print(f"Published {info['name']} {info['version']}")
    else:
        release = next(r for r in releases if r["version"] == info["version"])
        assert release.get("sha1") == hashlib.sha1(path.read_bytes()).hexdigest(), "Portal version already exists with a different archive"
        print("Identical version already uploaded; synchronizing page")
    remote = update_details(info["name"], token)
    release = next(r for r in remote["releases"] if r["version"] == info["version"])
    assert release["sha1"] == hashlib.sha1(path.read_bytes()).hexdigest(), "Published archive differs"
    print(f"Verified https://mods.factorio.com/mod/{info['name']}")


if __name__ == "__main__":
    if sys.argv[1:] == ["--details-only"]:
        info = json.loads((ROOT / "factorio-light/info.json").read_text())
        update_details(info["name"], api_key())
        print(f"Verified updated page: https://mods.factorio.com/mod/{info['name']}")
    elif sys.argv[1:] == ["--preflight"]:
        token = api_key()
        info = json.loads((ROOT / "factorio-light/info.json").read_text())
        try:
            request(f"{API}/mods/{info['name']}/full")
            endpoint = "releases/init_upload"
        except RuntimeError as error:
            if not str(error).startswith("Mod Portal returned HTTP 404"):
                raise
            endpoint = "init_publish"
        result = request(f"{API}/v2/mods/{endpoint}", [("mod", info["name"])], token)
        assert "upload_url" in result
        print("Mod Portal upload authorization verified")
    else:
        publish(Path(sys.argv[1]), Path(sys.argv[2]))
