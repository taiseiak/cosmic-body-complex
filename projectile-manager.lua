local Vector = require('libraries.brinevector')
local HC = require('libraries.HC')

local EntityManager = require('entity-manager')

local ProjectileManager = {}
ProjectileManager.__index = ProjectileManager

C.projectileType = {
    bullet = 'bullet'
}

local instance = nil

local function new()
    local self = setmetatable({}, ProjectileManager)
    self.projectiles = {}
    self.entityManager = EntityManager:getInstance()
    return self
end

function ProjectileManager:getInstance()
    if not instance then
        instance = new()
    end
    return instance
end

function ProjectileManager:update(dt)
    local playerBullets = self.entityManager:getEntities(C.entities.playerBullets)
    local enemies = self.entityManager:getEntities(C.entities.enemies)

    if not playerBullets then return end

    local bulletsCollided = {}
    local enemiesCollided = {}

    for bulletIndex, bullet in ipairs(playerBullets) do
        local newPosition = Vector(bullet.shape:center()) + bullet.direction.normalized * bullet.speed * dt
        bullet.shape:moveTo(newPosition.x, newPosition.y)
        if enemies then
            for enemyIndex, enemy in ipairs(enemies) do
                if bullet.shape:collidesWith(enemy.shape) then
                    table.insert(bulletsCollided, bullet)
                    table.insert(enemiesCollided, enemy)
                end
            end
        end
    end

    -- Separate collision removal from tables for performance
    for _, bullet in ipairs(bulletsCollided) do
        HC.remove(bullet.shape)
        self.entityManager:removeEntity(C.entities.playerBullets, bullet)
    end
    for _, enemy in ipairs(enemiesCollided) do
        enemy:takeDamage()
    end
end

function ProjectileManager:drawProjectiles()
    local playerBullets = self.entityManager:getEntities(C.entities.playerBullets)
    if not playerBullets then return end
    for _, bullet in ipairs(playerBullets) do
        love.graphics.setColor(G.palette[2])
        local x, y = bullet.shape:center()
        love.graphics.circle("fill", x, y, bullet.size)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function ProjectileManager:addProjectile(type, x, y, direction, modifiers)
    if type == C.projectileType.bullet then
        self.entityManager:addEntity(
            C.entities.playerBullets,
            self:createBullet(x, y, direction, modifiers))
    end
end

function ProjectileManager:createBullet(x, y, direction, modifiers)
    local bullet = {
        direction = direction,
        size = 1,
        speed = 100,
        shape = HC.circle(x, y, 1)
    }
    return bullet
end

return ProjectileManager
