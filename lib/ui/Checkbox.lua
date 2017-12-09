local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local Checkbox = Class:derive("Checkbox")

local padding = 10
local box_height_percentage = 0.9
local border_radius = 5
local line_width = 5

local function mouse_in_bounds(self, mx ,my) 
    return mx >= self.pos.x - self.width / 2 and mx <= self.pos.x + self.width / 2 and
           my >= self.pos.y - self.height / 2 and my <= self.pos.y + self.height / 2
end

function Checkbox:new(x, y, width, height, text) 
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height
    self.text = text
    self.cb_height = self.height * box_height_percentage
    self.cb_width = self.cb_height
    self.checked = false
    
    -- Checkbox colours
    self.normal = U.grey(128)
    self.highlight = U.grey(191)
    self.pressed = U.grey(255)
    self.disabled = U.grey(127, 127)

    -- Text colours
    self.text_normal = U.grey(255)
    self.text_disabled = U.grey(191)
    
    self.colour = self.normal
    self.text_colour = self.text_normal
    self.previous_left_click = false
    self.interactable = true
end

function Checkbox:update(dt) 
    if not self.interactable then return end
    
        -- TODO Consider caching the mouse position elsewhere
        local x, y = love.mouse.getPosition()
        local left_click = love.mouse.isDown(1)
        local in_bounds = U.mouse_in_rect(x, y, self.pos.x, self.pos.y, self.width,  self.height)
    
        if in_bounds and not left_click then
            if self.previous_left_click and self.colour == self.pressed then
                self.checked = not self.checked
                _G.events:invoke("onCheckboxClicked", self, self.checked)
            end
            self.colour = self.highlight
        elseif in_bounds and left_click and not self.previous_left_click then
            self.colour = self.pressed
        elseif not in_bounds then
            self.colour = self.normal
        end
    
        self.previous_left_click = left_click
end

function Checkbox:draw() 
    -- love.graphics.line(self.pos.x, self.pos.y - self.height / 2, self.pos.x, self.pos.y + self.height / 2)
    -- love.graphics.line(self.pos.x - self.width / 2, self.pos.y, self.pos.x  + self.width / 2, self.pos.y)
    -- love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width,self.height)

    local r, g, b, a = love.graphics.getColor()
    local lw = love.graphics.getLineWidth()
    love.graphics.setColor(self.colour)
    -- love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
    love.graphics.setLineWidth(line_width)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.cb_width, self.cb_height, border_radius, border_radius)
    
    if self.checked then
        love.graphics.rectangle("fill", self.pos.x + line_width, self.pos.y + line_width, self.cb_width - line_width * 2, self.cb_height - line_width * 2)
    end

    love.graphics.setColor(r, g, b, a)

    -- TODO - Consider caching this value
    local f = love.graphics.getFont()
    local fw = f:getWidth(self.text)
    local _, lines = f:getWrap(self.text, self.width - self.cb_width - padding)
    local fh = f:getHeight();

    love.graphics.setColor(self.text_colour)
    love.graphics.printf(self.text, self.pos.x + self.cb_width + padding, self.pos.y + self.height / 2 - (fh / 2 * #lines), self.width - self.cb_width - padding, "left")
    love.graphics.setColor(r, g, b, a)
    love.graphics.setLineWidth(lw)
end

function Checkbox:set_box(width, height)
    height = height or width
    self.cb_width = math.min(width, self.width)
    self.cb_height = math.min(height, self.height)
end

function Checkbox:enabled(enabled)
    self.interactable = enabled
    if not enabled then
        self.colour = self.disabled
        self.text_colour = self.text_disabled
    else
        self.text_colour = self.text_normal
    end
end

function Checkbox:colours(normal, highlight, pressed, disabled)
    assert(type(normal) == "table", "Normal must be a table.")
    assert(type(highlight) == "table", "Highlight must be a table.")
    assert(type(pressed) == "table", "Pressed must be a table.")
    assert(type(disabled) == "table", "Disabled must be a table.")

    self.normal = normal
    self.highlight = highlight
    self.pressed = pressed
    self.disabled = disabled
end

return Checkbox