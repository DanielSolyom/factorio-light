"""Recreate the original typographic thumbnail (optional: requires Pillow)."""
from pathlib import Path
import math
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
image = Image.new('RGB', (600, 600), '#111c24')
draw = ImageDraw.Draw(image)
font_path = '/usr/share/fonts/google-noto-vf/NotoSans[wght].ttf'

def font(size):
    result = ImageFont.truetype(font_path, size)
    result.set_variation_by_name('Bold')
    return result

for x in range(0, 601, 30):
    draw.line((x, 0, x, 600), fill='#192730', width=1)
for y in range(0, 601, 30):
    draw.line((0, y, 600, y), fill='#192730', width=1)
draw.rectangle((35, 35, 43, 285), fill='#edbf54')
draw.text((62, 40), 'FACTORIO', font=font(63), fill='#e8eeeb')
draw.text((54, 100), 'LIGHT', font=font(142), fill='#edbf54')
draw.text((62, 268), 'LESS GRIND. MORE FACTORY.', font=font(23), fill='#aebdc0')
# An original, schematic conveyor circuit with a central gear.
draw.line((65, 412, 198, 412), fill='#49726c', width=48)
draw.line((400, 412, 535, 412), fill='#49726c', width=48)
for x in [75, 125, 175, 415, 465, 515]:
    draw.line((x, 393, x+15, 412, x, 431), fill='#8fd5b8', width=6)
for angle in range(0, 360, 45):
    points = []
    for delta, radius in [(-13, 79), (-13, 103), (13, 103), (13, 79)]:
        a = math.radians(angle+delta)
        points.append((300+math.cos(a)*radius, 412+math.sin(a)*radius))
    draw.polygon(points, fill='#edbf54')
draw.ellipse((217, 329, 383, 495), fill='#edbf54')
draw.ellipse((253, 365, 347, 459), fill='#111c24')
draw.line((281, 412, 296, 427, 324, 396), fill='#8fd5b8', width=10)
draw.text((191, 546), 'SPACE AGE / 2.1', font=font(25), fill='#aebdc0')
image.save(ROOT / 'factorio-light/thumbnail.png', optimize=True)
