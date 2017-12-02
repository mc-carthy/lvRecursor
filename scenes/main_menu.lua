local Scene = require("lib.Scene")

local MM = Scene:derive("main_menu")

function MM:draw()
    love.graphics.print("Hello from main_menu!", 200, 25)
end

return MM