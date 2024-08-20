local Push = require("libraries.push")
local Vector = require("libraries.brinevector")

local InputManager = require('input-manager')
local WaveManager = require('wave-manager')
local EntityManager = require('entity-manager')
local ProjectileManager = require('projectile-manager')
local GameManager = require('game-manager')

local Player = require('player')

local game = {}

io.stdout:setvbuf("no")

function game:load(args)
    print("loading game scene")
    self.inputManager = InputManager:getInstance()
    self.waveManager = WaveManager:getInstance()
    self.entityManager = EntityManager:getInstance()
    self.projectileManager = ProjectileManager:getInstance()
    self.gameManager = GameManager:getInstance()
    self.waveManager:reset()

    self.gameOverTextDrawable = love.graphics.newText(Fonts.shinonomeBold, "Game Over")
    self.gameOverText = {}
    self.gameOverText.x = G.gameWidth / 2 - 30
    self.gameOverText.y = G.gameHeight / 2 - 20
    self.gameOverText.size = 5

    self.retryTextDrawable = love.graphics.newText(Fonts.shinonome, "Retry")
    self.retryText = {}
    self.retryText.x = G.gameWidth / 2 - 20
    self.retryText.y = G.gameHeight / 2 + 20
    self.retryText.size = 3
    self.player = Player.new(G.gameWidth / 2, G.gameHeight / 2, 6, 3) -- x, y, size, health

    self.waveManager:startRound()
end

function game:update(dt)
    self.gameManager:update(dt)
    self.waveManager:update(dt)
    self.player:update(dt)
    local enemies = self.entityManager:getEntities(C.entities.enemies)
    if enemies then
        for _, enemy in ipairs(enemies) do
            enemy:update(dt)
        end
    end
    self.projectileManager:update(dt)
    if not self.waveManager.roundStarted then
        self.waveManager:startRound()
    end
    if self.gameManager.gameOver then
        self.setScene("gameOver")
    end
end

function game:draw()
    self.projectileManager:drawProjectiles()
    local enemies = self.entityManager:getEntities(C.entities.enemies)
    if enemies then
        for _, enemy in ipairs(enemies) do
            enemy:draw()
        end
    end
    self.player:draw()
    self.gameManager:draw()
end

return game
