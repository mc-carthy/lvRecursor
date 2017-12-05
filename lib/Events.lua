local Class = require("lib.Class")

local Events = Class:derive("Events")

function Events:new(event_must_exist)
    self.handlers = {}
    self.event_must_exist = (event_must_exist == nil) or event_must_exist
end

-- Check if an event exists
function Events:exists(evnt_type)
    return self.handlers[evnt_type] ~= nil
end

-- Add an event to our event table
function Events:add(evnt_type)
    -- if self.handlers[evnt_type] ~= nil then return end
    assert(self.handlers[evnt_type] == nil, "Event " .. evnt_type .. " already exists")
    self.handlers[evnt_type] = {}
end

local function index_of(evnt_tbl, callback)
    if (evnt_tbl == nil or callback == nil) then return -1 end
    
    for i = 1, #evnt_tbl do
        if evnt_tbl[i] == callback then 
            return i
        end
    end

    return -1
end

-- Remove an event from our event table
function Events:remove(evnt_type)
    self.handlers[evnt_type] = nil
end

-- Subscribe to an event
function Events:hook(evnt_type, callback)
    assert(type(callback) == "function", "Callback parameter must be a function.")

    if self.event_must_exist then
        assert(self.handlers[evnt_type] ~= nil, "Event of type " .. evnt_type .. " does not exist.")
    elseif self.handlers[evnt_type] == nil then
        self:add(evnt_type)
    end

    -- if index_of(self.handlers[evnt_type], callback) > -1 then return end
    assert(index_of(self.handlers[evnt_type], callback) == -1, "Callback has already been registered.")

    local tbl = self.handlers[evnt_type]
    tbl[#tbl + 1] = callback
end

-- Unsubscribe from an event
function Events:unhook(evnt_type, callback)
    assert(type(callback) == "function", "Callback parameter must be a function.")
    
    if self.handlers[evnt_type] == nil then return end
    
    local index = index_of(self.handlers[evnt_type], callback)
    if index > -1 then
        table.remove(self.handlers[evnt_type], index)
    end
end

-- Clear out event handlers for the given event type, or all handlers if no type given
function Events:clear(evnt_type)
    if evnt_type == nil then
        for k, v in pairs(self.handlers) do
            self.handlers[k] = {}
        end
    elseif self.handlers[evnt_type] ~= nil then
        self.handlers[evnt_type] = {}
    end
end

-- Invoke the event
function Events:invoke(evnt_type, ...)
    if self.handlers[evnt_type] == nil then return end
    -- assert(self.handlers[evnt_type] ~= nil, "Event of type " .. evnt_type .. " does not exist.")

    local tbl = self.handlers[evnt_type]
    for i = 1, #tbl do
        tbl[i](...)
    end
end

return Events