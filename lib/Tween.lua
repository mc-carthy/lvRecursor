local pow = math.pow
local sin = math.sin
local cos = math.cos
local PI = math.pi

local T = {}

local active_tweens = {}

-- Easing functions
function T.linear(ratio) return ratio end
function T.easeInQuad(ratio) return pow(ratio, 2) end
function T.easeOutQuad(ratio) return 1 - pow(ratio - 1, 2) end
-- Not a quad function
function T.easeInOut(ratio) return pow(ratio, 2) * (2 - pow(ratio, 2)) end

function T.easeInCubic(ratio) return pow(ratio, 3) end
function T.easeOutCubic(ratio) return pow(ratio - 1, 3) + 1 end

function T.easeInQuartic(ratio) return pow(ratio, 4) end
function T.easeOutQuartic(ratio) return 1 - pow(ratio - 1, 4) end

function T.easeInQuintic(ratio) return pow(ratio, 5) end
function T.easeOutQuintic(ratio) return pow(ratio - 1, 5) + 1 end

function T.easeInSin(ratio) return 1 - cos(ratio * PI / 2) end
function T.easeOutSin(ratio) return sin(ratio * PI / 2) end
function T.easeInOutSin(ratio) return (1 + sin(ratio * PI - PI / 2)) / 2 end

function T.create(target, prop_name, to, duration, ease_function)
    assert(type(target) == "table", "Target parameter must be a table.")
    assert(type(prop_name) == "string", "Prop_name parameter must be a string.")

    local t = 0
    local from = target[prop_name]
    local diff = to - from
    
    local update = function(dt)
        if t >= duration then
            t = duration
            target[prop_name] = to
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