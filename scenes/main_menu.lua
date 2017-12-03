local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("main_menu")

function MM:new(scene_manager)
    self.super(scene_manager)
    self.button = Button(100, 100, 140, 40, "Press Me!")

    _G.events:hook("onBtnClick", on_click)
end

function on_click(button)
    print(button.label)
    button:enabled(false)
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
    love.graphics.print("Hello from main_menu!", 200, 25)
end

return MM