local Class = require("lib.Class")

local pow = math.pow
local sqrt = math.sqrt

local V = Class:derive("Vector3")

function V:new(x, y, z)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function V.cross(a, b)
    if a[z] == nil and b[z] == nil then
        return V(0, 0, a.x * b.y - a.y * b.x)
    else
        return V(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
    end
end

return V