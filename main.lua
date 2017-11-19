local hero_atlas
local hero_sprite

local rot = 0

-- animation parameters
local anim_fps = 10
local anim_timer = 1 / anim_fps
local anim_frame = 1
local num_frames = 6
local x_offset

function love.load()
    -- Ensures pixel images have no filtering and will appear crisp if scaled up
    love.graphics.setDefaultFilter('nearest')
    hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
    hero_sprite = love.graphics.newQuad(16, 32, 16, 16, hero_atlas:getDimensions(hero_atlas))
end

function love.update(dt)    
    -- rot = rot + 3 * dt
    anim_timer = anim_timer - dt
    if anim_timer <= 0 then
        anim_frame = anim_frame + 1
        anim_timer = 1 / anim_fps
        if anim_frame > num_frames then anim_frame = 1 end
        x_offset = 16 * anim_frame
        hero_sprite:setViewport(x_offset, 32, 16, 16)
    end
end

function love.draw()
    love.graphics.draw(hero_atlas, hero_sprite, 320, 180, rot, 10, 10, 8, 8)
end