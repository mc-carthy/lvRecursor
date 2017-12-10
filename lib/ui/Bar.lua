local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local Bar = Class:derive("Bar")

function Bar:set(percentage)
    self.percentage = math.max(0, math.min(percentage, 100))
end

local line_thickness = 2

function Bar:new(x, y, width, height, text)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height
    self.text = text
    self.percentage = 0
    self.filled_value = self.width - line_thickness

    self.text_colour = U.grey(255)
    self.bar_colour = U.colour(0, 191, 0)
    self.background_colour = U.colour(191, 0, 0)
    self.outline_colour = U.grey(127)
end

function Bar:update()

end

function Bar:draw()
    -- love.graphics.line(self.pos.x, self.pos.y - self.height / 2, self.pos.x, self.pos.y + self.height / 2)
    -- love.graphics.line(self.pos.x - self.width / 2, self.pos.y, self.pos.x  + self.width / 2, self.pos.y)

    local r, g, b, a = love.graphics.getColor()
    local lw = love.graphics.getLineWidth()

    local fill_amount = self.filled_value * self.percentage / 100

    love.graphics.setColor(self.background_colour)
    love.graphics.rectangle("fill", self.pos.x - self.width / 2 + line_thickness / 2, self.pos.y - self.height / 2, self.filled_value, self.height, 2, 2)
    love.graphics.setColor(self.bar_colour)
    if fill_amount > 0 then
        love.graphics.rectangle("fill", self.pos.x - self.width / 2 + line_thickness / 2, self.pos.y - self.height / 2, fill_amount, self.height, 2, 2)
    end
    love.graphics.setColor(self.outline_colour)

    love.graphics.setLineWidth(line_thickness)
    love.graphics.rectangle("line", self.pos.x - self.width / 2, self.pos.y - self.height / 2, self.width, self.height, 2, 2)
    love.graphics.setLineWidth(lw)
    love.graphics.setColor(r, g, b, a)

    -- TODO - Consider caching this value
    local f = love.graphics.getFont()
    local fw = f:getWidth(self.text)
    local _, lines = f:getWrap(self.text, self.width)
    local fh = f:getHeight();

    love.graphics.setColor(self.text_colour)
    love.graphics.printf(self.text, self.pos.x - self.width / 2, self.pos.y - (fh / 2 * #lines), self.width, "center")
    love.graphics.setColor(r, g, b, a)
end

return Bar