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
    self.super:new(scene_manager)
    hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
    -- hero_sprite = love.graphics.newQuad(16, 32, 16, 16, hero_atlas:getDimensions(hero_atlas))
    sprite = Sprite(hero_atlas, 100, 100, 16, 16, 10, 10)
    sprite:add_animations({idle = idle, walk = walk, swim = swim, punch = punch})
    sprite:animate("walk")
end

function T:enter()
    print("Enter test")
end

function T:update(dt)
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

    sprite:update(dt)    
end

function T:draw()
    love.graphics.clear(64,64,255)    
    love.graphics.print("Hello from test!", 200, 25)
    sprite:draw()    
end

return T