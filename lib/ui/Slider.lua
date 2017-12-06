local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local Slider = Class:derive("Slider")

function Slider:new(x, y, width, height)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height
    self.groove_height = 5
    self.knob_width = 20

    self.slider_pos = 0
    
    -- Slider colours
    self.normal = U.colour(191, 31, 31, 191)
    self.highlight = U.colour(191, 31, 31, 255)
    self.pressed = U.colour(255, 31, 31, 255)
    self.disabled = U.grey(127, 255)
    
    self.colour = self.normal
    -- self.interactable = true
end

function Slider:update(dt) end

function Slider:draw()
    -- love.graphics.line(self.pos.x, self.pos.y - self.height / 2, self.pos.x, self.pos.y + self.height / 2)
    -- love.graphics.line(self.pos.x - self.width / 2, self.pos.y, self.pos.x  + self.width / 2, self.pos.y)

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.colour)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.height / 2, self.width, 5, 4, 4)
    love.graphics.rectangle("fill", self.pos.x + self.slider_pos, self.pos.y - self.height + self.groove_height / 2, self.knob_width, self.height, 4, 4)
    love.graphics.setColor(r, g, b, a)
end

return Slider