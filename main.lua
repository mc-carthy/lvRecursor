Key = require("lib.Keyboard")
Tween = require("lib.Tween")
local GPM = require("lib.Gamepad")
local SM = require("lib.SceneManager")
local EVT = require("lib.Events")

local e
-- local gpm = GPM({"assets/gameControllerdb.txt"})
local gpm = GPM()
local sm

function love.load()
    Key:hook_love_events()
    -- Ensures pixel images have no filtering and will appear crisp if scaled up
    love.graphics.setDefaultFilter('nearest', 'nearest')
    local font = love.graphics.newFont("assets/Minecraft.ttf", 20)
    love.graphics.setFont(font)

    _G.events = EVT(false)

    gpm.event:hook('controller_added', on_controller_added)
    gpm.event:hook('controller_removed', on_controller_removed)

    sm = SM("scenes", {"main_menu", "test", "tween_test"})
    -- sm:switch("main_menu")
    sm:switch("test")
    -- sm:switch("tween_test")
end

function on_controller_added(joyId)
    print("controller " .. joyId .. "added")
end

function on_controller_removed(joyId)
    print("controller " .. joyId .. "removed")
end

function love.update(dt)
    if Key:key_down(",") then
        sm:switch("main_menu")
    elseif Key:key_down(".") then
        sm:switch("test")
    end
    

    sm:update(dt)
    Key:update(dt)
    gpm:update(dt)
    Tween.update(dt)
end

function love.draw()
    love.graphics.clear(0, 0, 0)
    sm:draw()
end