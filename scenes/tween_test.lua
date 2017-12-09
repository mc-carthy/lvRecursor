local Scene = require("lib.Scene")
local Label = require("lib.ui.Label")

local T = Scene:derive("tween_test")

local pos = { x = 0, y = 150 }
local label 

local tween_index = 1
local available_tweens = {}

function getTweens()
    for k, v in pairs(Tween) do
        if (type(v) == "function") then
            if k ~= "update" and k ~= "create" then
                available_tweens[#available_tweens + 1] = v
            end
        end
    end
end

function T:new(scene_manager)
    T.super.new(self, scene_manager)
    label = Label(0, 25, love.graphics.getWidth(), 50, "No Tween")
    self.em:add(label)
    getTweens()
end

function T:update(dt)
    self.super.update(self, dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    if Key:key_down("space") then
        if pos.x == 0 then
            Tween.create(pos, "x", 200, 1, available_tweens[tween_index])
        else
            Tween.create(pos, "x", 0, 1, available_tweens[tween_index])
        end            
    end
    
    if Key:key_down(".") then
        tween_index = tween_index + 1
        if tween_index > #available_tweens then
            tween_index = 1
        end
    end

    if Key:key_down(",") then
        tween_index = tween_index - 1
        if tween_index < 1 then
            tween_index = #available_tweens
        end
    end

    for k, v in pairs(Tween) do
        if v == available_tweens[tween_index] then
            label.text = k
        end
    end
end

function T:draw()
    love.graphics.clear(63,63,63)
    love.graphics.rectangle("fill", pos.x, pos.y, 30, 30)
    self.super.draw(self)
end

return T