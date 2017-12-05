local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local Button = Class:derive("Button")

function Button:new(x, y, width, height, text)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height
    self.text = text
    
    -- Button colours
    self.normal = U.colour(191, 31, 31, 191)
    self.highlight = U.colour(191, 31, 31, 255)
    self.pressed = U.colour(255, 31, 31, 255)
    self.disabled = U.grey(127, 255)

    -- Text colours
    self.text_normal = U.grey(255)
    self.text_disabled = U.grey(191)
    
    self.colour = self.normal
    self.text_colour = self.text_normal
    self.previous_left_click = false
    self.interactable = true
end

function Button:text_colours(normal, disabled)
    assert(type(normal) == "table", "Normal must be a table.")
    assert(type(disabled) == "table", "Disabled must be a table.")
    
    self.text_normal = normal
    self.text_disabled = disabled
end

function Button:colours(normal, highlight, pressed, disabled)
    assert(type(normal) == "table", "Normal must be a table.")
    assert(type(highlight) == "table", "Highlight must be a table.")
    assert(type(pressed) == "table", "Pressed must be a table.")
    assert(type(disabled) == "table", "Disabled must be a table.")

    self.normal = normal
    self.highlight = highlight
    self.pressed = pressed
    self.disabled = disabled
end

-- Set the button's left-most x location at a given value
function Button:left(x)
    self.pos.x = x + self.width / 2
end

-- Set the button's top-most y location at a given value
function Button:top(y)
    self.pos.y = y + self.height / 2
end

function Button:enabled(enabled)
    self.interactable = enabled
    if not enabled then
        self.colour = self.disabled
        self.text_colour = self.text_disabled
    else
        self.text_colour = self.text_normal
    end
end

function Button:update(dt)
    if not self.interactable then return end

    -- TODO Consider caching the mouse position elsewhere
    x, y = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)
    local in_bounds = U.mouse_in_bounds(self, x, y)

    if in_bounds and not left_click then
        self.colour = self.highlight
        if self.previous_left_click then
            _G.events:invoke("onBtnClick", self)
        end
    elseif in_bounds and left_click then
        self.colour = self.pressed
    else
        self.colour = self.normal
    end

    self.previous_left_click = left_click
end

function Button:draw()
    -- love.graphics.line(self.pos.x, self.pos.y - self.height / 2, self.pos.x, self.pos.y + self.height / 2)
    -- love.graphics.line(self.pos.x - self.width / 2, self.pos.y, self.pos.x  + self.width / 2, self.pos.y)

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.colour)
    love.graphics.rectangle("fill", self.pos.x - self.width / 2, self.pos.y - self.height / 2, self.width, self.height, 4, 4)
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

return Button