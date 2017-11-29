local Anim = require("Animation")
local Sprite = require("Sprite")

local hero_atlas
local hero_sprite

local rot = 0

-- animation parameters
local anim_fps = 10
local anim_timer = 1 / anim_fps
local anim_frame = 1
local num_frames = 6
local x_offset

local sprite
local idle = Anim(16, 16, 16, 16, 4, 4, 6)
local walk = Anim(16, 32, 16, 16, 6, 6, 12)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 20, false)

local punchSfx = love.audio.newSource("assets/sfx/hits/hit01.wav", "static")

function love.load()
    -- Ensures pixel images have no filtering and will appear crisp if scaled up
    love.graphics.setDefaultFilter('nearest', 'nearest')
    hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
    -- hero_sprite = love.graphics.newQuad(16, 32, 16, 16, hero_atlas:getDimensions(hero_atlas))
    sprite = Sprite(hero_atlas, 16, 16, 100, 100, 10, 10)
    sprite:add_animation("idle", idle)
    sprite:add_animation("walk", walk)
    sprite:add_animation("swim", swim)
    sprite:add_animation("punch", punch)
    sprite:animate("idle")
end

function love.update(dt)  
    sprite:update(dt, hero_sprite)

    if sprite.current_animation == "punch" and sprite:animation_finished() then
        sprite:animate("idle")
    end
end

function love.draw()
    -- love.graphics.draw(hero_atlas, hero_sprite, 320, 180, rot, 10, 10, 8, 8)
    sprite:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" and sprite.current_animation ~= "punch" then
        sprite:animate("punch")
        love.audio.stop(punchSfx)        
        love.audio.play(punchSfx)        
    end
end