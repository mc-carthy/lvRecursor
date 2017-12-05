local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Label = Class:derive("Label")

function Label:new(x, y, width, height, text, align)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height
    self.text = text
    self.align = align or "center"
end

function Label:update(dt) end

function Label:draw()
    -- TODO: Consider caching this value
    local f = love.graphics.getFont()
    local _, lines = f:getWrap(self.text, self.width)
    local fh = f:getHeight();
    love.graphics.printf(self.text, self.pos.x, self.pos.y - (#lines * fh / 2), self.width, self.align)

    -- love.graphics.rectangle("line", self.pos.x, self.pos.y - self.height / 2, self.width, self.height)
end

return Label