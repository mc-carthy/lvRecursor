local Class = require("lib.Class")

local Scene = Class:derive("Scene")

-- This gets called when the scene is loaded
function Scene:new(scene_manager)
    self.scene_manager = scene_manager
end

function Scene:update(dt)
end

function Scene:draw()
end

function Scene:enter()
end

function Scene:exit()
end

function Scene:destroy()
end

return Scene