function love.load()
    FPS = 1
end

function love.update(dt)
    FPS = 1 / dt
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('FPS: ' .. math.floor(FPS), 590, 0)
    love.graphics.setColor(0, 191, 191, 255)
    love.graphics.rectangle("fill", 100 , 100, 50, 50)
end