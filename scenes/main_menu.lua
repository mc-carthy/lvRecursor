local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local TextField = require("lib.ui.TextField")
local Slider = require("lib.ui.Slider")
local Checkbox = require("lib.ui.Checkbox")

local MM = Scene:derive("main_menu")

function MM:new(scene_manager)
    MM.super.new(self, scene_manager)

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    
    local start_button = Button(sw / 2, sh / 2 - 30, 140, 40, "Start!")
    local exit_button = Button(sw / 2, sh / 2 + 30, 140, 40, "Quit!")
    exit_button:colours({0, 191, 0, 255}, {63, 215, 63, 255}, {127, 255, 127, 255}, {63, 63, 63, 255})
    exit_button.layer = 0

    local mm_text = Label(0, 20, sw, 40, "Main Menu")

    self.tf = TextField(sw / 2 - 50, 75, 100, 40, "Hello!", U.grey(191), "left")
    self.h_slider = Slider(sw / 2 - 100, 275, 200, 40, "horizontal_slider", false)
    self.v_slider = Slider(20, 40, 40, 200, "vertical_slider", true)
    self.h_slider_label = Label(sw / 2 + 110, 270, 40, 40, "0", U.grey(255), "left")
    self.v_slider_label = Label(5, 255, 40, 40, "0", U.grey(255), "center")
    self.cb = Checkbox(love.graphics.getWidth() / 2 - 100, 300, 200, 40, "Enable Music!")

    self.em:add(start_button)
    self.em:add(exit_button)
    self.em:add(mm_text)
    self.em:add(self.tf)
    self.em:add(self.h_slider)
    self.em:add(self.v_slider)
    self.em:add(self.h_slider_label)
    self.em:add(self.v_slider_label)
    self.em:add(self.cb)

    self.click = function(btn) 
        self:on_click(btn) 
    end

    self.slider_changed = function(slider) 
        self:on_slider_changed(slider)
    end

    self.checkbox_changed = function(checkbox, value)
        self:on_checkbox_changed(checkbox, value)
    end
end

local entered = false

function MM:enter()
    MM.super.enter(self)
    if not entered then
        entered = true
    end
    
    _G.events:hook("onBtnClick", self.click)    
    _G.events:hook("onSliderChanged", self.slider_changed)    
    _G.events:hook("onCheckboxClicked", self.checkbox_changed)    
end

function MM:exit()
    MM.super.exit(self)
    _G.events:unhook("onBtnClick", self.click)
    _G.events:unhook("onSliderChanged", self.slider_changed)
    _G.events:unhook("onCheckboxClicked", self.checkbox_changed)
end

function MM:on_click(button)
    if button.text == "Start!" then
        self.scene_manager:switch("test")
        -- button.remove = true
    elseif button.text == "Quit!" then
        love.event.quit()
        -- button.remove = true
    end
end

function MM:on_slider_changed(slider)
    if slider.id == "horizontal_slider" then
        self.h_slider_label.text = slider:get_value()
    end

    if slider.id == "vertical_slider" then
        self.v_slider_label.text = slider:get_value()
    end
    -- print("Slider " .. slider.id .. " has a value of " .. slider:get_value())
end

function MM:on_checkbox_changed(checkbox, value)
    if checkbox.text == "Enable Music!" then
        print(checkbox.text .. ": " .. tostring(value))
    end
end

local prev_down = false
function MM:update(dt)
    self.super.update(self, dt)

    if Key:key_down("escape") then
        love.event.quit()
    -- elseif Key:key_down("space") then
    --     self.button:enabled(not self.button.interactable)
    end

    local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
    local mouse_left_down = love.mouse.isDown(1)

    -- If the left mouse button was just clicked
    if mouse_left_down and not prev_down then
        if U.point_in_rectangle({ x = mouse_pos_x, y = mouse_pos_y }, self.tf:get_rect()) then
            self.tf:set_focus(true)
        else
            self.tf:set_focus(false)
        end
    end

    prev_down = mouse_left_down

end

function MM:draw()
    self.super.draw(self)
end

return MM