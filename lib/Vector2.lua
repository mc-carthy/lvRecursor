local Class = require("lib.Class")

local pow = math.pow
local sqrt = math.sqrt

local V = Class:derive("Vector2")

function V:new(x, y)
    self.x = x or 0
    self.y = y or 0
end

function V.add(vec1, vec2)
    return V(vec1.x + vec2.x, vec1.y + vec2.y)
end

function V.subtract(vec1, vec2)
    return V(vec1.x - vec2.x, vec1.y - vec2.y)
end

function V.multiply(vec, scal)
    return V(vec.x * scal, vec.y * scal)
end

function V.divide(vec, scal)
    assert(scal ~= 0, "Error, cannot divide by zero.")
    return V(vec.x / scal, vec.y / scal)
end

function V:magnitude()
    return sqrt(pow(self.x, 2) + pow(self.y, 2))
end

function V.normalised(vec)
    local mag = V.magnitude(vec)
    return V(vec.x / mag, vec.y / mag)
end

function V:normalise()
    local mag = self:magnitude()
    self.x = self.x / mag
    self.y = self.y / mag
end


return V