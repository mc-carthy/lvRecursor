local Class = require("lib.Class")

local SM = Class:derive("StateMachine")

local transition = {
    enter = "_enter",
    none = "",
    exit = "_exit"
}

function SM:new(state)
    self:reset()
    self:change(state)
end

function SM:reset()
    self.state = nil
    self.prev = nil
    self.transition = transition.none
end

-- Changes to a state without calling the previous state's _exit function
function SM:change_immediate(state)
    assert(type(state) == "string" or type(state) == nil, "State parameter must be a string or nil.")
    assert(state == nil or self[state] ~= nil, "Can't find state: " .. state .. "as a state function")

    self.prev = self.state
    self.state = state

    if self.state ~= nil and self[self.state .. transition.enter] ~= nil then
        self.transition = transition.enter
    else
        self.transition = transition.none
    end
end

function SM:change(state)
    if state == self.state then return end

    self:change_immediate(state)
    if self.prev ~= nil and self[self.prev .. transition.exit] ~= nil then
        self.transition = transition.exit
    end
end

function SM:update(dt)
    -- if self.prev ~= nil then
    --     print("Prev: " .. self.prev .. ", cur: " .. self.state .. self.transition)
    -- end
    if self.transition == transition.exit then
        self[self.prev .. self.transition](self, dt)    -- prev_state_exit(dt)

        if self.state ~= nil and self[self.state .. transition.enter] ~= nil then
            self.transition = transition.enter
        else
            self.transition = transition.none
        end

    elseif self.transition == transition.enter then
        self[self.state .. self.transition](self, dt)   -- state_enter(dt)
        self.transition = transition.none
    elseif self.state ~= nil then
        self[self.state](self, dt)
    end
end

function SM:draw()

end

return SM