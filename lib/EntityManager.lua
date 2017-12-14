local Class = require("lib.Class")
local U = require("lib.Utils")

local EM = Class:derive("EntityManager")

local function layer_compare(e1, e2)
    return e1.layer < e2.layer
end

function EM:new()
    self.entities = {}
end

function EM:on_enter()
    for i = 1, #self.entities do
        local e = self.entities[i]
        if e.on_enter then e:on_enter() end
    end
end

function EM:on_exit()
    for i = 1, #self.entities do
        local e = self.entities[i]
        if e.on_exit then e:on_exit() end
    end
end

function EM:add(entity)
    if U.contains(self.entities, entity) then return end

    -- Add additional fields that should exist for all entities
    entity.layer = entity.layer or 1
    entity.started = entity.started or false
    entity.enabled = (entity.enabled == nil) or entity.enabled
    self.entities[#self.entities + 1] = entity

    table.sort(self.entities, layer_compare)
end

function EM:update(dt)
    for i = #self.entities, 1, -1 do
        local e = self.entities[i]
        
        -- If the entity requests removal then do it
        if e.remove == true then
            e.remove = false
            if e.on_remove then
                e:on_remove()
            end
            table.remove(self.entities, i)
        end

        if e.enabled then
            if not e.started then
                e.started = true
                if e.on_start then 
                    e:on_start()
                end
            -- elseif e.update then
            else
                e:update(dt)
            end
        end
    end
end

function EM:draw()
    for i = 1, #self.entities do
        if self.entities[i].enabled and self.entities[i].draw then
            self.entities[i]:draw()
        end
    end
end

return EM