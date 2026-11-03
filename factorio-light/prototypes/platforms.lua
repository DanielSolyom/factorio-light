-- Explicitly requested storage. Logistic chests store items even without robots.
data.raw.container["wooden-chest"].surface_conditions = nil
data.raw.container["iron-chest"].surface_conditions = nil
data.raw.container["steel-chest"].surface_conditions = nil
data.raw["logistic-container"]["active-provider-chest"].surface_conditions = nil
data.raw["logistic-container"]["passive-provider-chest"].surface_conditions = nil
data.raw["logistic-container"]["storage-chest"].surface_conditions = nil
data.raw["logistic-container"]["buffer-chest"].surface_conditions = nil
data.raw["logistic-container"]["requester-chest"].surface_conditions = nil
