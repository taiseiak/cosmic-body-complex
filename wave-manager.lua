local Vector = require('libraries.brinevector')

local EntityManager = require('entity-manager')

local Enemy = require('enemy')

local WaveManager = {}
WaveManager.__index = WaveManager

local instance = nil

local function new()
    local self = setmetatable({}, WaveManager)
    self.round = 0
    self.rounds = {
        {
            enemies = 5
        },
        {
            enemies = 10
        },
        {
            enemies = 20
        },
        {
            enemies = 50
        },
        {
            enemies = 100
        }
    }
    self.roundStarted = false
    self.entityManager = EntityManager:getInstance()
    return self
end

function WaveManager:getInstance()
    if not instance then
        instance = new()
    end
    return instance
end

function WaveManager:update(dt)
    local enemies = self:getEntities(C.entities.enemies)
    if (not enemies or #enemies < 1) and self.roundStarted then
        self.roundStarted = false
    end
end

function WaveManager:reset()
    self.round = 0
    self.roundStarted = false
end

function WaveManager:getround()
    return self.round
end

function WaveManager:hasRoundEnded()
    return not self.roundStarted
end

function WaveManager:startRound()
    if self.roundStarted then
        return
    end
    if self.round >= #self.rounds then
        -- Rounds all done
        return
    end
    local enemies = self.entityManager:getEntities(C.entities.enemies) or {}
    if not self.roundStarted and #enemies < 1 then
        self.roundStarted = true
        self.round = self.round + 1
        print("Starting round " .. self.round)
        self:createEnemies(self.rounds[self.round].enemies)
        print("enemy count: " .. #self.entityManager:getEntities(C.entities.enemies))
    end
end

function WaveManager:createEnemies(enemyCount)
    local centerX, centerY = G.gameWidth / 2, G.gameHeight / 2
    for i = 1, enemyCount do
        local randomAngle = love.math.random(-math.pi, math.pi)
        randomAngle = randomAngle - love.math.random()
        local randomRadius = love.math.random(200, 250)
        local randomVector = Vector(1, 0):angled(randomAngle) * randomRadius
        local ranx, rany = randomVector.x + centerX, randomVector.y + centerY
        local enemy = Enemy.new(ranx, rany, 5)
        self.entityManager:addEntity(C.entities.enemies, enemy)
    end
end

function WaveManager:getEntities(key)
    return self[key] or {}
end

return WaveManager
