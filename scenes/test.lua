local Scene = require("lib.Scene")

local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")

local T = Scene:derive("test")


local hero_atlas

local sprite
local idle = Anim(16, 16, 16, 16, 4, 4, 6)
local walk = Anim(16, 32, 16, 16, { 1, 2, 3, 4, 5, 6 }, 6, 12)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 20, false)

local punchSfx = love.audio.newSource("assets/sfx/hits/hit01.wav", "static")

function T:new(scene_manager)
    T.super.new(self, scene_manager)
    hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
end

local entered = false
function T:enter()
    T.super.enter(self)
    if not entered then
        entered = true
        sprite = Sprite(hero_atlas, 100, 100, 16, 16, 4, 4)
        sprite:add_animations({idle = idle, walk = walk, swim = swim, punch = punch})
        sprite:animate("walk")
        self.em:add(sprite)
    end
end

function T:update(dt)
    self.super.update(self, dt)
    if Key:key_down("space") and sprite.current_animation ~= "punch" then
        sprite:animate("punch")
        love.audio.stop(punchSfx)        
        love.audio.play(punchSfx)
    elseif Key:key_down("escape") then
        love.event.quit()
    end

    if sprite.current_animation == "punch" and sprite:animation_finished() then
        sprite:animate("idle")
    end
end

function T:draw()
    love.graphics.clear(64,64,255)    
    love.graphics.print("Hello from test!", 200, 25)
    self.super.draw(self)
end

return T