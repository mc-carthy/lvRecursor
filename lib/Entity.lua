local Class = require("lib.Class")
local U = require("lib.Utils")

local E = Class:derive("Entity")

function E:new()
    self.components = {}
end

local function priority_compare(c1, c2)
    return c1.priority < c2.priority
end

function E:add(component)
    if U.contains(self.components, component) then return end
    -- Add additional fields that should exist for all components
    component.priority = component.priority or 1
    component.started = component.started or false
    component.enabled = (component.enabled == nil) or component.enabled
    component.entity = self

    self.components[#self.components + 1] = component

    if component.type and type(component.type) == "string" then
        self[component.type] = component
    end

    table.sort(self.components, priority_compare)
end

function E:remove(component)
    local i = U.index_of(self.components, component)

    if i == -1 then return end
    
    if component.on_remove then
        component:on_remove()
    end
    table.remove(self.components, i)

    if component.type and type(component.type) == "string" then
        self[component.type] = nil
        component.entity = nil
    end

end

function E:update(dt)
    for i = 1, #self.components do
    local c = self.components[i]
    
        if c.enabled then
            if not c.started then
                c.started = true
                if c.on_start then 
                    c:on_start()
                end
            elseif c.update then
                c:update(dt)
            end
        end
    end
end

function E:draw()
    for i = 1, #self.components do
        if self.components[i].enabled and self.components[i].draw then
            self.components[i]:draw()
        end
    end
end

return E