local Class = require("lib.Class")
local Scene = require ("lib.Scene")

local SM = Class:derive("SceneManager")

function SM:new(scene_dir, scenes)
    self.scenes = {}
    self.scene_dir = scene_dir

    if not scene_dir then scene_dir = "" end

    if (scenes ~= nil) then
        assert(type(scenes) == "table", "The scenes parameter must be a table.")
        for i = 1, #scenes do
            local M = require(scene_dir .. "." .. scenes[i])
            assert(M:is(Scene), "File: " .. scene_dir .. "." .. scenes[i] .. ".lua is not of type Scene")
            self.scenes[scenes[i]] = M(self)
        end
    end
    
    -- These are strings that are keys for the self.scenes table
    self.previous_scene_name = nil
    self.current_scene_name = nil

    -- This contains the actual scene object
    self.current = nil
end

-- Add a scene to the list where scene is an instance of a sub-class of Scene
function SM:add(scene, scene_name)
    if scene then
        assert(type(scene_name) ~= "string", "Scene Name parameter required")
        assert(type(scene_name) == "string", "Scene Name parameter must be a table")
        assert(type(scene) == "table", "Scene parameter must be a table")
        assert(scene:is(Scene), "Cannot add non-Scene objects to the Scene Manager")
        -- Assuming the scene is already constructed
        self.scenes[scene_name] = scene
    end
end

function SM:remove(scene_name)
    if scene_name then
        for k, v in pairs(self.scenes) do
            if k == scene_name then
                self.scenes[k]:destroy()
                self.scenes[k] = nil
                
                if scene_name == self.current_scene_name then
                    self.current = nil
                end

                break
            end
        end
    end
end

-- Switches from the current scene to the next scene
function SM:switch(next_scene)
    if self.current then
        self.current:exit()
    end

    if next_scene then
        assert(self.scenes[next_scene] ~= nil, "Unable to find scene: " .. next_scene)
        self.previous_scene_name = self.current_scene_name
        self.current_scene_name = next_scene
        self.current = self.scenes[next_scene]
        self.current:enter()
    end
end

-- Returns to a previous scene if there is one
function SM:pop()
    if self.previous_scene_name then
        self:switch(self.previous_scene_name)
        self.previous_scene_name = nil
    end
end

-- Returns a list of all the scene names the scene manager knows of
function SM:get_available_scenes()
    local scene_names = {}
    
    for k, v in pairs(self.scenes) do
        scene_names[#scene_names + 1] = k
    end
    
    return scene_names
end

function SM:update(dt)
    if self.current then
        self.current:update(dt)
    end
end

function SM:draw()
    if self.current then
        self.current:draw()
    end
end

return SM