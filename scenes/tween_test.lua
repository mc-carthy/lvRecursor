local Scene = require("lib.Scene")
local Label = require("lib.ui.Label")

local T = Scene:derive("tween_test")

local pos = { x = 0, y = 150 }
local label 

function T:new(scene_manager)
    T.super.new(self, scene_manager)
    label = Label(0, 25, love.graphics.getWidth(), 50, "No Tween")
    self.em:add(label)
end

function T:update(dt)
    self.super.update(self, dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    if Key:key_down("space") then
        Tween.create(pos, "x", 200, 2)
    end
end

function T:draw()
    love.graphics.clear(63,63,63)
    love.graphics.rectangle("fill", pos.x, pos.y, 30, 30)
    self.super.draw(self)
end

return T