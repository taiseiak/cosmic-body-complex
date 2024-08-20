local Vector = require('libraries.brinevector')
local HC = require('libraries.HC')

local EntityManager = require('entity-manager')
local ColliderManager = require('collider-manager')
local GameManager = require('game-manager')

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, size)
    local self = {}
    self.entityManager = EntityManager:getInstance()
    self.colliderManager = ColliderManager:getInstance()
    self.gameManager = GameManager:getInstance()

    self.speed = 15
    self.size = size
    self.shape = HC.circle(x, y, self.size)
    self.vector = Vector(self.shape:center())

    self.entityManager:addEntity(C.entities.enemies, self)
    return setmetatable(self, Enemy)
end

function Enemy:update(dt)
    self:move(dt)
end

function Enemy:draw()
    love.graphics.setColor(G.palette[3])
    local x, y = self.shape:center()
    love.graphics.circle("fill", x, y, self.size)
    love.graphics.setColor(1, 1, 1, 1)
end

function Enemy:move(dt)
    local player = self.entityManager:getEntity(C.entities.player)
    if not player then return end

    local toPlayerVector = player.vector - self.vector
    local newPosition = self.vector + toPlayerVector.normalized * self.speed * dt
    self.shape:moveTo(newPosition.x, newPosition.y)
    local collisions = HC.collisions(self.shape)
    for other, separating_vector in pairs(collisions) do
        local ox, oy = other:center()
        local px, py = player.shape:center()

        if ox ~= px and oy ~= py then
            self.shape:move(separating_vector.x / 2, separating_vector.y / 2)
            other:move(-separating_vector.x / 2, -separating_vector.y / 2)
        end
    end

    self.vector = Vector(self.shape:center())
end

function Enemy:takeDamage()
    HC.remove(self.shape)
    self.entityManager:removeEntity(C.entities.enemies, self)
    self.gameManager:addScore(100)
end

return Enemy
