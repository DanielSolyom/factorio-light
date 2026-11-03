-- Ordinary storage and the complete vanilla railway work on platforms.
data.raw.container["wooden-chest"].surface_conditions = nil
data.raw.container["iron-chest"].surface_conditions = nil
data.raw.container["steel-chest"].surface_conditions = nil

-- Keep these overrides explicit; logistic chests retain vanilla restrictions.
data.raw["straight-rail"]["straight-rail"].surface_conditions = nil
data.raw["half-diagonal-rail"]["half-diagonal-rail"].surface_conditions = nil
data.raw["curved-rail-a"]["curved-rail-a"].surface_conditions = nil
data.raw["curved-rail-b"]["curved-rail-b"].surface_conditions = nil
data.raw["rail-ramp"]["rail-ramp"].surface_conditions = nil
data.raw["rail-support"]["rail-support"].surface_conditions = nil
data.raw["elevated-straight-rail"]["elevated-straight-rail"].surface_conditions = nil
data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].surface_conditions = nil
data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].surface_conditions = nil
data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].surface_conditions = nil
data.raw.locomotive.locomotive.surface_conditions = nil
data.raw["cargo-wagon"]["cargo-wagon"].surface_conditions = nil
data.raw["fluid-wagon"]["fluid-wagon"].surface_conditions = nil
data.raw["artillery-wagon"]["artillery-wagon"].surface_conditions = nil
data.raw["train-stop"]["train-stop"].surface_conditions = nil
data.raw["rail-signal"]["rail-signal"].surface_conditions = nil
data.raw["rail-chain-signal"]["rail-chain-signal"].surface_conditions = nil
