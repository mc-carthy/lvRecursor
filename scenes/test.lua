local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Player = require("../Player")
local Enemy = require("../Enemy")

local T = Scene:derive("test")

function T:new(scene_manager)
    T.super.new(self, scene_manager)
    self.p = Player("idle")
    self.e = Enemy("idle")
    self.e.spr.pos.x = 300
    self.e.spr.tintColour = U.colour(191, 0, 0)
    
    self.em:add(self.p)
    self.em:add(self.e)
end

function T:update(dt)
    self.super.update(self, dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    if U.AABBCol(self.p.spr:rect(), self.e.spr:rect()) then
        self.p.spr.tintColour = U.colour(0, 127, 127, 127)
    else
        self.p.spr.tintColour = U.colour(255, 255, 255, 255)
    end
end

function T:draw()
    love.graphics.clear(64,64,255)    
    -- love.graphics.print("Hello from test!", 200, 25)
    self.super.draw(self)
end

return T