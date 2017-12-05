local utf8 = require("utf8")
local U = require("lib.Utils")
local Label = require("lib.ui.Label")

local TextField = Label:derive("TextField")

local cursor = "|"

-- On Android and iOS, textinput is disabled by default; call love.keyboard.setTextInput to enable it.
function TextField:new(x, y, width, height, text, colour, align)
    TextField.super.new(self, x, y, width, height, text, colour, align)
    self.focus = false
    self.focused_colour = U.colour(127)
    self.unfocused_colour = U.colour(31)
    self.back_colour = self.unfocused_colour

    self.key_pressed = function(key) if key == "backspace" then self:on_text_input(key) end end
    self.text_input = function(text) self:on_text_input(text) end
end

function TextField:get_rect()
    return { x = self.pos.x, y = self.pos.y - self.height / 2, width = self.width, height = self.height }
end

function TextField:on_enter()
    _G.events:hook("key_pressed", self.key_pressed)
    _G.events:hook("text_input", self.text_input)
end

function TextField:on_exit()
    _G.events:unhook("key_pressed", self.key_pressed)
    _G.events:unhook("text_input", self.text_input)
end

function TextField:set_focus(focus)
    assert(type(focus) == "boolean", "Paramter focus should be of type boolean")
    if focus then
        self.back_colour = self.focused_colour
        if not self.focus then
            self.text = self.text .. cursor
        end
    else
        self.back_colour = self.unfocused_colour
        if self.focus then
            self:remove_end_chars(1)
        end
    end
    self.focus = focus
end

function TextField:on_text_input(text)
    if not self.focus or not self.enabled then
        return
    end

    if text == "backspace" then
        -- We remove 2 characters because we need to remove both the cursor and last char
        self:remove_end_chars(2)
        self.text = self.text .. cursor
    else
        self:remove_end_chars(1)        
        self.text = self.text .. text
        self.text = self.text .. cursor
    end
end

function TextField:remove_end_chars(num)
    local byte_offset = utf8.offset(self.text, -num)
    if byte_offset then
        self.text = string.sub(self.text, 1, byte_offset - 1)
    end
end

function TextField:draw()
    love.graphics.setColor(self.back_colour)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.height / 2, self.width, self.height)
    TextField.super.draw(self)
end

return TextField