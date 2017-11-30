local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")
local Key = require("lib.Keyboard")
local Evt = require("lib.Events")

local e

local hero_atlas

local sprite
local idle = Anim(16, 16, 16, 16, 4, 4, 6)
local walk = Anim(16, 32, 16, 16, { 1, 2, 3, 4, 5, 6 }, 6, 12)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 20, false)

local punchSfx = love.audio.newSource("assets/sfx/hits/hit01.wav", "static")

function love.load()
    Key:hook_love_events()

    e = Evt()
    e:add("on_space")
    e:hook("on_space", on_space)

    -- Ensures pixel images have no filtering and will appear crisp if scaled up
    love.graphics.setDefaultFilter('nearest', 'nearest')
    hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
    -- hero_sprite = love.graphics.newQuad(16, 32, 16, 16, hero_atlas:getDimensions(hero_atlas))
    sprite = Sprite(hero_atlas, 16, 16, 100, 100, 10, 10)
    sprite:add_animation("idle", idle)
    sprite:add_animation("walk", walk)
    sprite:add_animation("swim", swim)
    sprite:add_animation("punch", punch)
    sprite:animate("walk")
end

function on_space()
    print("SPACE!")
end

function love.update(dt)
    if Key:key_down("space") and sprite.current_animation ~= "punch" then
        sprite:animate("punch")
        love.audio.stop(punchSfx)        
        love.audio.play(punchSfx)
        e:invoke("on_space")
    elseif Key:key_down("u") then
        e:unhook("on_space", on_space)
    elseif Key:key_down("escape") then
        love.event.quit()
    end

    if sprite.current_animation == "punch" and sprite:animation_finished() then
        sprite:animate("idle")
    end
    Key:update(dt)
    sprite:update(dt)
end

function love.draw()
    sprite:draw()
end

-- function love.keypressed(key, scancode, isrepeat)
--     if key == "space" and sprite.current_animation ~= "punch" then
--         sprite:animate("punch")
--         love.audio.stop(punchSfx)        
--         love.audio.play(punchSfx)        
--     elseif key == "a" then
--         sprite:flip_h(true)
--     elseif key == "d" then
--         sprite:flip_h(false)
--     elseif key == "w" then
--         sprite:flip_v(true)
--     elseif key == "s" then
--         sprite:flip_v(false)
--     end
-- end