local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("main_menu")

function MM:new(scene_manager)
    self.super(scene_manager)
    self.click = function(btn) self:on_click(btn) end   
end

local entered = false

function MM:enter()
    if not entered then
        entered = true

        local sw = love.graphics.getWidth()
        local sh = love.graphics.getHeight()
        
        local start_button = Button(sw / 2, sh / 2 - 30, 140, 40, "Start!")
        local exit_button = Button(sw / 2, sh / 2, 140, 40, "Quit!")
        exit_button:colours({0, 191, 0, 255}, {63, 215, 63, 255}, {127, 255, 127, 255}, {63, 63, 63, 255})
        exit_button.layer = 0

        self.em:add(start_button)
        self.em:add(exit_button)
    end
    
    _G.events:hook("onBtnClick", self.click)    
end

function MM:exit()
    _G.events:unhook("onBtnClick", self.click)
end

function MM:on_click(button)
    print(button.label)
    if button.label == "Start!" then
        self.scene_manager:switch("test")
    elseif button.label == "Quit!" then
        love.event.quit()
    end
end

function MM:update(dt)
    self.super:update(dt)

    if Key:key_down("escape") then
        love.event.quit()
    elseif Key:key_down("space") then
        self.button:enabled(not self.button.interactable)
    end


end

function MM:draw()
    self.super:draw()

    love.graphics.printf("Hello from main_menu!", 0, 25, love.graphics.getWidth(), "center")
end

return MM