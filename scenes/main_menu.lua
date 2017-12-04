local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("main_menu")

function MM:new(scene_manager)
    self.super(scene_manager)
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    self.start_button = Button(sw / 2, sh / 2 - 30, 140, 40, "Start!")
    self.exit_button = Button(sw / 2, sh / 2 + 30, 140, 40, "Quit!")
    self.exit_button:colours({0, 191, 0, 255}, {63, 215, 63, 255}, {127, 255, 127, 255}, {63, 63, 63, 255})
    
    self.click = function(btn) self:on_click(btn) end
end

function MM:enter()
    _G.events:hook("onBtnClick", self.click)    
end

function MM:exit()
    _G.events:unhook("onBtnClick", self.click)
end

function MM:on_click(button)
    print(button.label)
    if button.label == "Start!" then
    -- if button == self.start_button then
        self.scene_manager:switch("test")
    elseif button == self.exit_button then
        love.event.quit()
    end
end

function MM:update(dt)
    if Key:key_down("escape") then
        love.event.quit()
    elseif Key:key_down("space") then
        self.button:enabled(not self.button.interactable)
    end
    self.start_button:update(dt)
    self.exit_button:update(dt)
end

function MM:draw()
    self.start_button:draw()
    self.exit_button:draw()
    love.graphics.printf("Hello from main_menu!", 0, 25, love.graphics.getWidth(), "center")
end

return MM