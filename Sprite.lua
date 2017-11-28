local class = require("class")
local Sprite = class:derive("Sprite")

function Sprite:new()
    self.animations = {}
end

function Sprite:play(anim_name)

end

function Sprite:update(dt)

end

function Sprite:draw()

end

return Sprite