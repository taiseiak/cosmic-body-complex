local EntityManager = {}
EntityManager.__index = EntityManager

C.entities = {
    enemies = 'enemies',
    player = 'player',
    playerBullets = 'playerBullets'
}

local instance = nil

local function new()
    local self = setmetatable({}, EntityManager)
    self.ids = {}
    return self
end

function EntityManager:getInstance()
    if not instance then
        instance = new()
    end
    return instance
end

function EntityManager:update(dt) end

function EntityManager:addEntity(key, entity)
    if not self.ids[key] then
        self.ids[key] = 0
    else
        self.ids[key] = self.ids[key] + 1
    end
    entity.entityId = self.ids[key]

    if not self[key] then
        self[key] = { entity }
    else
        table.insert(self[key], entity)
    end
end

function EntityManager:removeEntity(key, entity)
    if not self[key] then
        return
    end
    local id = entity.entityId
    for index, value in ipairs(self[key]) do
        if (value.entityId == id) then
            table.remove(self[key], index)
            return
        end
    end
end

function EntityManager:getEntities(key)
    return self[key]
end

function EntityManager:getEntity(key)
    if not self[key] then
        return
    end
    assert(#self[key] == 1, "There are " .. #self[key] .. " of " .. key .. " where there should only be one.")
    return self[key][1]
end

function EntityManager:removeAllEntities()
    instance = new()
end

return EntityManager
