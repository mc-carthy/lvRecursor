local utf8 = require("utf8")
local U = require("lib.Utils")
local Label = require("lib.ui.Label")

local TextField = Label:derive("TextField")

-- On Android and iOS, textinput is disabled by default; call love.keyboard.setTextInput to enable it.
function TextField:new(x, y, width, height, text, colour, align)
    TextField.super.new(self, x, y, width, height, text, colour, align)
    self.focus = false

    self.key_pressed = function(key) if key == "backspace" then self:on_text_input(key) end end
    self.text_input = function(text) self:on_text_input(text) end

    _G.events:hook("key_pressed", self.key_pressed)
    _G.events:hook("text_input", self.text_input)
end

function TextField:set_focus(focus)
    assert(type(focus) == "boolean", "Paramter focus should be of type boolean")
    self.focus = focus
end

function TextField:on_text_input(text)
    -- if not self.focus or not self.enabled then
    --     return
    -- end

    if text == "backspace" then
        local byte_offset = utf8.offset(self.text, -1)
        if byte_offset then
            self.text = string.sub(self.text, 1, byte_offset - 1)
        end
    else
        self.text = self.text .. text
    end
end

function TextField:draw()
    love.graphics.setColor(U.grey(31))
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.height / 2, self.width, self.height)
    TextField.super.draw(self)
end

return TextField