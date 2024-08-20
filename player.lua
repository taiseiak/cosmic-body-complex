local Vector = require('libraries.brinevector')
local Push = require('libraries.push')
local HC = require('libraries.HC')

local EntityManager = require('entity-manager')
local InputManager = require('input-manager')
local ProjectileManager = require('projectile-manager')
local GameManager = require('game-manager')

local Player = {}
Player.__index = Player

function Player.new(x, y, size, health)
    local self = {}
    self.entityManager = EntityManager:getInstance()
    self.inputManager = InputManager:getInstance()
    self.projectileManager = ProjectileManager:getInstance()
    self.gameManager = GameManager:getInstance()

    self.shape = HC.circle(x, y, size)
    self.vector = Vector(self.shape:center())
    self.size = size
    self.health = health
    self.shootTimer = 0
    self.shootCooldown = 1
    self.speed = 150
    self.damageTimer = 0
    self.damageMaxTick = 0.2

    self.entityManager:addEntity(C.entities.player, self)
    return setmetatable(self, Player)
end

function Player:update(dt)
    local x, y = self.inputManager.input:get('move')
    local moveVector = Vector(x, y)
    local newPosition = self.vector + moveVector * self.speed * dt
    self.shape:moveTo(newPosition.x, newPosition.y)
    local enemies = self.entityManager:getEntities(C.entities.enemies)
    if enemies then
        for index, enemy in ipairs(enemies) do
            if enemy.shape:collidesWith(self.shape) then
                self:damage(.2)
            end
        end
    end
    self.vector = Vector(self.shape:center())


    self.shootTimer = self.shootTimer + dt
    if self.shootTimer >= self.shootCooldown then
        local closestEnemy = self:findClosestEnemy()
        if closestEnemy then
            local lengthToClosest = (closestEnemy.vector - self.vector).length
            if lengthToClosest < 80 then
                self:createBulletAtPosition(closestEnemy.vector.x, closestEnemy.vector.y)
            end
            self.shootTimer = self.shootTimer - self.shootCooldown
        else
            self.shootTimer = self.shootTimer - dt
        end
    end
    self.damageTimer = self.damageTimer + dt
end

function Player:draw()
    if G.debug then
        -- Mouse location
        local mx, my = Push:toGame(love.mouse.getPosition())
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle("line", mx, my, 2)

        -- Player location
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.circle('line', self.shape:outcircle())

        local px, py = self:getCenter()
        love.graphics.circle("line", px - self.size / 2, py - self.size / 2, 80)

        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.setColor(G.palette[4])
    local x, y = self.shape:center()
    love.graphics.circle("fill", x, y, self.size)
end

function Player:getCenter()
    return self.vector.x + (self.size / 2), self.vector.y + (self.size / 2)
end

function Player:createBulletAtPosition(x, y)
    local playerPosition = Vector(self:getCenter())
    local shootAtPosition = Vector(x, y)
    local directionVector = (shootAtPosition - playerPosition).normalized

    self.projectileManager:addProjectile(C.projectileType.bullet, playerPosition.x, playerPosition.y, directionVector, {})

    -- local dx = math.cos(angle) * self.bulletSpeed
    -- local dy = math.sin(angle) * self.bulletSpeed

    -- self.entityManager:addEntity('playerBullets', { x = playerPosition.x, y = playerPosition.y, dx = dx, dy = dy })
end

function Player:findClosestEnemy()
    local enemies = self.entityManager:getEntities(C.entities.enemies)
    if not enemies or #enemies < 1 then return end
    local closestEnemy = enemies[1]
    local closestDistance = (closestEnemy.vector - self.vector).length2
    if #enemies == 1 then return closestEnemy end
    for i = 2, #enemies, 1 do
        local enemy = enemies[i]
        local distanceVector = (enemy.vector - self.vector).length2
        if distanceVector < closestDistance then
            closestEnemy = enemy
        end
    end
    return closestEnemy
end

function Player:damage(damageValue)
    if self.damageTimer > self.damageMaxTick then
        self.health = self.health - damageValue
        self.damageTimer = 0
        if self.health <= 0 then
            self.gameManager:setGameOver()
        end
    end
end

return Player
