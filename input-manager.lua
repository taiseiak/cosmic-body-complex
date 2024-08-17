local Baton = require("libraries.baton")

local InputManager = {}
InputManager.__index = InputManager

function InputManager:init()
    self.input = Baton.new({
        controls = {
            lift = { 'key:w' },
            lower = { 'key:s' }
        }
    })
end

function InputManager:update(dt)
    self.input:update()
end

function InputManager:pressed(control)
    return self.input:pressed(control)
end

function InputManager:released(control)
    return self.input:released(control)
end

return InputManager
