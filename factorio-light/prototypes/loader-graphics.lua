-- Adapted from Krastorio 2, LGPL-3.0. See THIRD_PARTY.md.
local loader_graphics = {}

--- @param tint data.Color
--- @return data.LoaderStructure
function loader_graphics.structure(tint)
  return {
    direction_in = {
      sheets = {
        {
          filename = "__factorio-light-space-age__/graphics/loaders/kr-loader.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          y = 85,
          scale = 0.5,
        },
        {
          filename = "__factorio-light-space-age__/graphics/loaders/kr-loader-mask.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          y = 85,
          scale = 0.5,
          tint = tint,
        },
        {
          filename = "__factorio-light-space-age__/graphics/loaders/kr-loader-rust.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          y = 85,
          scale = 0.5,
        },
      },
    },
    direction_out = {
      sheets = {
        {
          filename = "__factorio-light-space-age__/graphics/loaders/kr-loader.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          scale = 0.5,
        },
        {
          filename = "__factorio-light-space-age__/graphics/loaders/kr-loader-mask.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          scale = 0.5,
          tint = tint,
        },
        {
          filename = "__factorio-light-space-age__/graphics/loaders/kr-loader-rust.png",
          priority = "extra-high",
          shift = { 0.15625, 0.0703125 },
          width = 106,
          height = 85,
          scale = 0.5,
        },
      },
    },
  }
end

loader_graphics.structure_render_layer = "object"

return loader_graphics
