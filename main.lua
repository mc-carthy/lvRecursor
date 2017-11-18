local x = 100
local dir = 1

function love.load()
    FPS = 1
end

function love.update(dt)
    FPS = 1 / dt

    if x > 400 or x < 100 then
        dir = dir * -1
    end
    x = x + (150 * dir * dt)
    
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('FPS: ' .. math.floor(FPS), 590, 0)
    love.graphics.setColor(0, 191, 191, 255)
    love.graphics.rectangle("fill", x , 100, 50, 50)
end