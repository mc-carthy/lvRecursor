local pow = math.pow

local T = {}

local active_tweens = {}

-- Easing functions
function T.linear(ratio) return ratio end
function T.easeInQuad(ratio) return pow(ratio, 2) end
function T.easeOutQuad(ratio) return ratio * (2 - ratio) end

function T.create(target, prop_name, to, duration, ease_function)
    assert(type(target) == "table", "Target parameter must be a table.")
    assert(type(prop_name) == "string", "Prop_name parameter must be a string.")

    local t = 0
    local from = target[prop_name]
    local diff = to - from
    
    local update = function(dt)
        if t >= duration then
            t = duration
            return true
        end

        target[prop_name] = from + diff * ease_function(t / duration)
        t = t + dt

        return false
    end
    active_tweens[#active_tweens + 1] = update
end

function T.update(dt)
    for i = #active_tweens, 1, -1 do
        if active_tweens[i](dt) then
            table.remove(active_tweens, i)
        end
    end
end

return T