local HC = require('libraries.HC')

local ColliderManager = {}
ColliderManager.__index = ColliderManager

local instance = nil

local function new()
    local self = setmetatable({}, ColliderManager)
    self.collider = HC.new()
    return self
end

function ColliderManager:getInstance()
    if not instance then
        instance = new()
    end
    return instance
end

function ColliderManager:update(dt) end

function ColliderManager:getCollider()
    return self.self.collider
end

return ColliderManager
