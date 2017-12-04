local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("main_menu")

function MM:new(scene_manager)
    self.super(scene_manager)
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    self.button = Button(sw / 2, sh / 2 - 60, 140, 40, "Start!")
end

function MM:enter()
    _G.events:hook("onBtnClick", on_click)    
end

function MM:exit()
    _G.events:unhook("onBtnClick", on_click)
end

function on_click(button)
    print(button.label)
    -- button:enabled(false)
end

function MM:update(dt)
    if Key:key_down("escape") then
        love.event.quit()
    elseif Key:key_down("space") then
        self.button:enabled(not self.button.interactable)
    end
    self.button:update(dt)
end

function MM:draw()
    self.button:draw()
    love.graphics.printf("Hello from main_menu!", 0, 25, love.graphics.getWidth(), "center")
end

return MM