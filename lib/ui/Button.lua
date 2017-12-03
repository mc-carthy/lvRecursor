local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Button = Class:derive("Button")

local function colour(r, g, b, a)
    return {r, g, b, a or 255}
end

local function grey(level, a)
    return {level, level, level, a or 255}
end

function Button:new(x, y, width, height)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height

    -- Button colours
    self.normal = colour(191, 31, 31, 191)
    self.highlight = colour(191, 31, 31, 255)
    self.pressed = colour(255, 31, 31, 255)
    self.disabled = grey(127, 255)
end

-- Set the button's left-most x location at a given value
function Button:left(x)
    self.pos.x = x + self.width / 2
end

-- Set the button's top-most y location at a given value
function Button:top(y)
    self.pos.y = y + self.height / 2
end

function Button:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.normal)
    love.graphics.rectangle("fill", self.pos.x - self.width / 2, self.pos.y - self.height / 2, self.width, self.height, 4, 4)
    love.graphics.setColor(r, g, b, a)
    love.graphics.print("New", self.pos.x - 20, self.pos.y - 10)
end

return Button