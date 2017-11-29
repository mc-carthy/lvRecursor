local class = require("class")
local Anim = class:derive("Animation")
local Vector2 = require("Vector2")

function Anim:new(x_offset, y_offset, cell_width, cell_height, num_frames, column_size, fps, loop)
    self.fps = fps
    self.timer = 1 / self.fps
    self.frame = 1
    self.num_frames = num_frames
    self.column_size = column_size
    self.start_offset = Vector2(x_offset, y_offset)
    self.offset = Vector2()
    self.size = Vector2(cell_width, cell_height)
    -- The below login allows loop to be an optional parameter with a default true value
    self.loop = (loop == nil) or loop
    self.done = false
end

function Anim:update(dt, quad)
    if self.num_frames <= 1 then
        return
    elseif self.timer > 0 then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.timer = 1 / self.fps
            self.frame = self.frame + 1
            if self.frame > self.num_frames then 
                if self.loop then
                    self.frame = 1
                else
                    self.frame = self.num_frames
                    self.timer = 0
                    self.done = true
                end
            end
            self.offset.x = self.start_offset.x + (self.size.x * ((self.frame - 1) % (self.column_size)))
            self.offset.y = self.start_offset.y + (self.size.y * math.floor((self.frame - 1) / self.column_size))
            self:set(quad)
        end
    end
end

function Anim:set(quad)
    quad:setViewport(self.offset.x, self.offset.y, self.size.x, self.size.y)
end

function Anim:reset()
    self.timer = 1 / self.fps
    self.frame = 1
    self.done = false
end

return Anim