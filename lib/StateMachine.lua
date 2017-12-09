local Class = require("lib.Class")

local SM = Class:derive("StateMachine")

local transition = {
    enter = "_enter",
    none = "",
    exit = "_exit"
}

function SM:new(state_table, start_state_name)
    assert(type(state_table) == "table", "State_table parameter must be a table.")
    assert(type(start_state_name) == "string" or type(start_state_name) == "nil", "Start_state_name parameter must be a string or nil.")
    
    self:reset()
    self.state_table = state_table
    self:change(start_state_name)
end

function SM:reset()
    self.state = nil
    self.state_name = nil
    self.prev_state_name = nil
    self.transition = transition.none
end

-- Take a state name and a transition type and returns true if it is 
-- able to set the state to the desired state name and transition type
function SM:set_transition_function(new_state_name, transition_type)
    assert(type(new_state_name) == "string" or type(new_state_name) == "nil", "New_state_name parameter must be a string or nil.")
    assert(type(transition_type) == "string", "Transition type parameter must be a string.")

    if new_state_name == nil or self.state_table[new_state_name .. transition_type] == nil  then
        self.state = nil
        self.transition = transition.none
        return false
    else
        self.state = self.state_table[new_state_name .. transition_type]
        assert(type(self.state) == "function", new_state_name .. "() must be a function.")
        self.transition = transition_type
        print("prev_state: " .. (self.state_name or "") .. self.transition .. " current: " .. (new_state_name .. transition_type or ""))
        
        return true
    end
end

function SM:change(new_state_name, immediate)
    if new_state_name == self.state then return end

    -- See if the previous state has an exit function
    if not immediate and self:set_transition_function(self.state_name, transition.exit) then
    elseif self:set_transition_function(new_state_name, transition.enter) then
    else self:set_transition_function(new_state_name, transition.none)
    end

    -- Store the previous state name and set the current one
    self.prev_state_name = self.state_name
    self.state_name = new_state_name
end

function SM:update(dt)
    if self.transition == transition.exit then
        self.state(self.state_table, dt)    -- prev_state_exit(dt)
        
        if self:set_transition_function(self.state_name, transition.enter) then
        else
            self:set_transition_function(self.state_name, transition.none)
        end

    elseif self.transition == transition.enter then
        self.state(self.state_table, dt)
        self:set_transition_function(self.state_name, transition.none)
    elseif self.state ~= nil then
        self.state(self.state_table, dt)
    end
end

function SM:draw()

end

return SM