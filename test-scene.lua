local InputManager = require('input-manager')

local TestScene = {}
TestScene.__index = TestScene

function TestScene.new()
    local self = {}
    setmetatable(self, TestScene)
    return self
end

function TestScene:update(dt)
end

function TestScene:draw()
    if InputManager:pressed("lift") then
        love.graphics.print("lifting...", 10, 10)
    elseif InputManager:pressed("lower") then
        love.graphics.print("lowering...", 20, 10)
    end
end

return TestScene
