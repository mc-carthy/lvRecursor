local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")
local Entity = require("lib.Entity")
local Player = require("../Player")
local Missile = require("../Missile")
local Transform = require("lib.components.Transform")

local T = Scene:derive("test")

function T:new(scene_manager)
    T.super.new(self, scene_manager)
    self.p = Player("idle")
    self.m = Missile(320, 100)
    self.m:target(self.p.Sprite)
    
    self.c1 = { x = 200, y = 200, r = 20, c = U.colour(255)}
    self.c2 = { x = 300, y = 200, r = 40, c = U.colour(127)}

    local e = Entity()
    local t = Transform(100, 100, 0)
    e:add(t)
    print(e.Transform.x)
    e:remove(t)

    self.em:add(self.p)
    self.em:add(self.m)

end

function T:update(dt)
    self.super.update(self, dt)


    if Key:key_down("escape") then
        love.event.quit()
    end

    local r1 = self.p.Sprite:rect()
    local r2 = self.m.Sprite:rect()

    if U.AABB_col(r1, r2) then
        self.p.Sprite.tintColour = U.colour(0, 127, 127, 127)

        local md = r2:minkowski_difference(r1)

        -- Positive x = left side collision
        -- Negative x = right side collision
        -- Positive y = Top side collision
        -- Negative y = Bottom side collision
        --Points towards the direction in which the rect should move to no longer be colliding

        local msv = md:closest_point_on_bounds(Vector2())


        -- Tell the player which side the collision has occured
        self.p:collided(
            md:collides_top(msv),
            md:collides_bottom(msv),
            md:collides_left(msv),
            md:collides_right(msv)
        )

        if md:collides_bottom(msv) then print("Bottom") end

        self.p.Transform.x = self.p.Transform.x + msv.x
        self.p.Transform.y = self.p.Transform.y + msv.y

    else
        self.p.Sprite.tintColour = U.colour(255, 255, 255, 255)
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

    -- U.circle_to_circle_col(self.c1, self.c2, 0)
    
    if U.circle_to_circle_col(self.c1, self.c2, 0.5) then
        self.c1.c = U.colour(0, 127, 127, 127)
    else
        self.c1.c = U.colour(255, 255, 255, 255)
    end
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