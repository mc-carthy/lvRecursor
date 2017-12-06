local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local TextField = require("lib.ui.TextField")
local Slider = require("lib.ui.Slider")

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
    self.slider = Slider(sw / 2 - 100, 275, 200, 40)

    self.em:add(start_button)
    self.em:add(exit_button)
    self.em:add(mm_text)
    self.em:add(self.tf)
    self.em:add(self.slider)

    self.click = function(btn) 
        self:on_click(btn) 
    end
end

local entered = false

function MM:enter()
    MM.super.enter(self)
    if not entered then
        entered = true
    end
    
    _G.events:hook("onBtnClick", self.click)    
end

function MM:exit()
    MM.super.exit(self)
    _G.events:unhook("onBtnClick", self.click)
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