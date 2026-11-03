require("prototypes.fixed-stats")
require("prototypes.gleba")
require("prototypes.platforms")
require("prototypes.loaders")
require("prototypes.barrels")

-- Remove the pistol itself, not merely its recipe from the crafting menu.
data.raw.gun.pistol = nil
data.raw.recipe.pistol = nil
data.raw.recipe["submachine-gun"].enabled = true
local effects = data.raw.technology.military.effects
for i = #effects, 1, -1 do
  if effects[i].type == "unlock-recipe" and effects[i].recipe == "submachine-gun" then
    table.remove(effects, i)
  end
end
