local Baton = require("libraries.baton")

local InputManager = {}
InputManager.__index = InputManager

local instance = nil

local function new()
    local self = setmetatable({}, InputManager)
    self.input = Baton.new({
        controls = {
            up = { 'key:w' },
            left = { 'key:a' },
            down = { 'key:s' },
            right = { 'key:d' },
            leftMouse = { 'mouse:1' }
        },
        pairs = {
            move = { 'left', 'right', 'up', 'down' }
        },
        joystick = love.joystick.getJoysticks()[1],
    })
    return self
end

function InputManager:getInstance()
    if not instance then
        instance = new()
    end
    return instance
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
