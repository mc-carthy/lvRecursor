local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("main_menu")

function MM:new(scene_manager)
    self.super(scene_manager)
    self.button = Button(100, 100, 140, 40, "Press Me!")
end

function MM:update(dt)
    self.button:update(dt)
end

function MM:draw()
    self.button:draw()
    love.graphics.print("Hello from main_menu!", 200, 25)
end

return MM