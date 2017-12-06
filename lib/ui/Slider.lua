local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local Slider = Class:derive("Slider")

function Slider:new(x, y, width, height, id)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.groove_height = 5
    self.knob_width = 20
    self.knob_height = height
    self.id = id

    self.slider_pos = 0
    self.previous_slider_pos = 0
    self.slider_x_delta = 0
    self.slider_moving = false
    self.value = 0
    
    -- Slider colours
    self.normal = U.colour(127, 0, 0, 255)
    self.highlight = U.colour(191, 31, 31, 255)
    self.pressed = U.colour(255, 31, 31, 255)
    self.disabled = U.grey(127, 255)
    self.groove_colour = U.grey(127)
    
    self.colour = self.normal
    self.interactable = true
end

function Slider:update(dt) 
    -- if not self.interactable then return end

    -- TODO Consider caching the mouse position elsewhere
    local mx, my = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)
    local in_bounds = U.mouse_in_rect(mx, my, self.pos.x + self.slider_pos, self.pos.y - self.knob_height, self.knob_width, self.knob_height)

    if in_bounds and not left_click then
        self.colour = self.highlight
        if self.previous_left_click then
            _G.events:invoke("onBtnClick", self)
        end
    elseif in_bounds and left_click then
        if not self.previous_left_click then
            self.slider_x_delta = (self.slider_pos) - mx
            self.slider_moving = true
        end
    else
        self.colour = self.normal
    end

    if self.slider_moving and left_click then
        self.colour = self.pressed        
        self.previous_slider_pos = self.slider_pos
        self.slider_pos = mx + self.slider_x_delta
        if self.slider_pos > self.width - self.knob_width then
            self.slider_pos = self.width - self.knob_width
        elseif self.slider_pos < 0 then
            self.slider_pos = 0
        end

        if self.slider_pos ~= self.previous_slider_pos then
            _G.events:invoke("onSliderChanged", self)
        end
        
    else
        self.slider_moving = false
    end

    self.previous_left_click = left_click

end

function Slider:draw()
    -- love.graphics.line(self.pos.x, self.pos.y - self.height / 2, self.pos.x, self.pos.y + self.height / 2)
    -- love.graphics.line(self.pos.x - self.width / 2, self.pos.y, self.pos.x  + self.width / 2, self.pos.y)

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.groove_colour)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.knob_height / 2, self.width, self.groove_height, 4, 4)
    love.graphics.setColor(self.colour)
    love.graphics.rectangle("fill", self.pos.x + self.slider_pos, self.pos.y - self.knob_height + self.groove_height / 2, self.knob_width, self.knob_height, 4, 4)
    love.graphics.setColor(r, g, b, a)
end

function Slider:get_value()
    return math.floor((self.slider_pos / (self.width - self.knob_width)) * 100)
end

return Slider