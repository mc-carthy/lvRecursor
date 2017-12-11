local Class = require("lib.Class")

local pow = math.pow
local sqrt = math.sqrt

local V = Class:derive("Vector2")

function V:new(x, y)
    self.x = x or 0
    self.y = y or 0
end

function V.multiply(vec, scal)
    return V(vec.x * scal, vec.y * scal)
end

function V:magnitude()
    return sqrt(pow(self.x, 2) + pow(self.y, 2))
end

function V.normalised(vec)
    local mag = V.magnitude(vec)
    return V(vec.x / mag, vec.y / mag)
end


return V