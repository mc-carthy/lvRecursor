local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Button = Class:derive("Button")

local function colour(r, g, b, a)
    return {r, g, b, a or 255}
end

local function grey(level, a)
    return {level, level, level, a or 255}
end

function Button:new(x, y, width, height, label)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height
    self.label = label
    
    -- Button colours
    self.normal = colour(191, 31, 31, 191)
    self.highlight = colour(191, 31, 31, 255)
    self.pressed = colour(255, 31, 31, 255)
    self.disabled = grey(127, 255)
    
    self.colour = self.normal
end

local function mouse_in_bounds(self, mx ,my) 
    return mx >= self.pos.x - self.width / 2 and mx <= self.pos.x + self.width / 2 and
           my >= self.pos.y - self.height / 2 and my <= self.pos.y + self.height / 2
end

-- Set the button's left-most x location at a given value
function Button:left(x)
    self.pos.x = x + self.width / 2
end

-- Set the button's top-most y location at a given value
function Button:top(y)
    self.pos.y = y + self.height / 2
end

function Button:update(dt)
    -- TODO Consider caching the mouse position elsewhere
    x, y = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)
    local in_bounds = mouse_in_bounds(self, x, y)

    if in_bounds and not left_click then
        self.colour = self.highlight
    elseif in_bounds and left_click then
        self.colour = self.pressed
    else
        self.colour = self.normal
    end
end

function Button:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.colour)
    love.graphics.rectangle("fill", self.pos.x - self.width / 2, self.pos.y - self.height / 2, self.width, self.height, 4, 4)
    love.graphics.setColor(r, g, b, a)

    -- TODO - Consider caching this value
    local f = love.graphics.getFont()
    local fw = f:getWidth(self.label)
    local fh = f:getHeight();

    love.graphics.print(self.label, self.pos.x - fw / 2, self.pos.y - fh / 2)
end

return Button