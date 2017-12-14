local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local T = Class:derive("Transform")

function T:new(x, y, rotation)
    self.pos = Vector2(x or 0, y or 0)
    self.rotation = rotation or 0
    
    self.enabled = true
    self.started = true
end

return T