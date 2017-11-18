local hero_atlas
local hero_sprite

local rot = 0

function love.load()
    -- Ensures pixel images have no filtering and will appear crisp if scaled up
    love.graphics.setDefaultFilter('nearest')
    hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
    hero_sprite = love.graphics.newQuad(32, 16, 16, 16, hero_atlas:getDimensions(hero_atlas))
end

function love.update(dt)    
    rot = rot + 3 * dt
end

function love.draw()
    love.graphics.draw(hero_atlas, hero_sprite, 320, 180, rot, 4, 4, 8, 8)
end