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
    
    self.c1 = { x = 200, y = 200, r = 20, c = U.colour(255)}
    self.c2 = { x = 300, y = 200, r = 40, c = U.colour(127)}

    self.em:add(self.p)
    self.em:add(self.e)
end

function T:update(dt)
    self.super.update(self, dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    if U.AABB_col(self.p.spr:rect(), self.e.spr:rect()) then
        self.p.spr.tintColour = U.colour(0, 127, 127, 127)
    else
        self.p.spr.tintColour = U.colour(255, 255, 255, 255)
    end

    if Key:key("w") then
        self.c1.y = self.c1.y - 100 * dt
    elseif Key:key("s") then
        self.c1.y = self.c1.y + 100 * dt
    end

    if Key:key("a") then
        self.c1.x = self.c1.x - 100 * dt
    elseif Key:key("d") then
        self.c1.x = self.c1.x + 100 * dt
    end

    -- local trigger, msv = U.circle_to_circle_trigger(self.c1,  self.c2)
    -- if trigger then
    --     self.c1.c = U.colour(0, 127, 127, 127)
    -- else
    --     self.c1.c = U.colour(255, 255, 255, 255)
    -- end

    U.circle_to_circle_col(self.c1, self.c2, 0)
    
    -- if U.circle_to_circle_col(self.c1, self.c2, 0.75) then
    --     self.c1.c = U.colour(0, 127, 127, 127)
    -- else
    --     self.c1.c = U.colour(255, 255, 255, 255)
    -- end
end

function T:draw()
    love.graphics.clear(64,64,255)    
    -- love.graphics.print("Hello from test!", 200, 25)
    self.super.draw(self)

    love.graphics.setColor(self.c1.c)
    love.graphics.circle("line", self.c1.x, self.c1.y, self.c1.r)
    love.graphics.setColor(self.c2.c)
    love.graphics.circle("line", self.c2.x, self.c2.y, self.c2.r)
    
end

return T