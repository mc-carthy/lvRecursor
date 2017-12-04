local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")

local MM = Scene:derive("main_menu")

function MM:new(scene_manager)
    self.super(scene_manager)
    self.click = function(btn) self:on_click(btn) end   
end

local entered = false

function MM:enter()
    if not entered then
        entered = true

        local sw = love.graphics.getWidth()
        local sh = love.graphics.getHeight()
        
        local start_button = Button(sw / 2, sh / 2 - 30, 140, 40, "Start!")
        local exit_button = Button(sw / 2, sh / 2, 140, 40, "Quit!")
        exit_button:colours({0, 191, 0, 255}, {63, 215, 63, 255}, {127, 255, 127, 255}, {63, 63, 63, 255})
        exit_button.layer = 0

        local mm_text = Label(0, 20, sw, 40, "Main Menu")

        self.em:add(start_button)
        self.em:add(exit_button)
        self.em:add(mm_text)
    end
    
    _G.events:hook("onBtnClick", self.click)    
end

function MM:exit()
    _G.events:unhook("onBtnClick", self.click)
end

function MM:on_click(button)
    if button.text == "Start!" then
        self.scene_manager:switch("test")
        -- button.remove = true
    elseif button.text == "Quit!" then
        love.event.quit()
        -- button.remove = true
    end
end

function MM:update(dt)
    self.super:update(dt)

    if Key:key_down("escape") then
        love.event.quit()
    -- elseif Key:key_down("space") then
    --     self.button:enabled(not self.button.interactable)
    end


end

function MM:draw()
    self.super:draw()
end

return MM