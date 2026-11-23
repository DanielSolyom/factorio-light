-- Platform storage and robot logistics use the normal engine behavior.
data.raw.container["steel-chest"].surface_conditions = nil
data.raw.roboport.roboport.surface_conditions = nil
for _, name in ipairs({"active-provider-chest", "passive-provider-chest", "storage-chest",
  "buffer-chest", "requester-chest"}) do
  data.raw["logistic-container"][name].surface_conditions = nil
end
