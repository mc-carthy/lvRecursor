local Class = require("lib.Class")
local EntityManager = require("lib.EntityManager")

local Scene = Class:derive("Scene")

-- This gets called when the scene is loaded
function Scene:new(scene_manager)
    self.scene_manager = scene_manager
    self.em = EntityManager()
end

function Scene:update(dt)
    self.em:update(dt)
end

function Scene:draw()
    self.em:draw()
end

function Scene:enter()
end

function Scene:exit()
end

function Scene:destroy()
end

return Scene