local Text = require("libraries.slog-text")
local Push = require("libraries.push")

local InputManager = require("input-manager")
local GameManager = require('game-manager')
local EntityManager = require('entity-manager')

local game = {}

function game:load(args)
    self.inputManager = InputManager:getInstance()
    self.gameManager = GameManager:getInstance()
    self.entityManager = EntityManager:getInstance()

    self.entityManager:removeAllEntities()
    self.gameMidX = G.gameWidth / 2
    self.gameMidY = G.gameHeight / 2

    -- [Main text] --
    self.mainMenuText = Text.new("center", {
        color = G.palette[4],
        font = Fonts.shinonomeBold,
        shadow_color = G.palette[2],
    })
    self.mainMenuText:send("[dropshadow=1]GAME OVER[/dropshadow]", 180, true)
    self.mainMenuTextX = self.gameMidX - self.mainMenuText.get.width / 2
    self.mainMenuTextY = self.gameMidY - self.mainMenuText.get.height / 2 - 20


    self.scoreText = Text.new("center", {
        color = G.palette[4],
        font = Fonts.shinonome,
        shadow_color = G.palette[2],
    })
    self.scoreText:send("Score: " .. self.gameManager.score, 180, true)
    self.scoreTextX = self.gameMidX - self.scoreText.get.width / 2
    self.scoreTextY = self.gameMidY - self.scoreText.get.height / 2


    -- [Start text] --
    self.startText = Text.new("center", {
        color = G.palette[4],
        font = Fonts.shinonome,
        shadow_color = G.palette[2],
    })
    self.startText:send("RESTART", 60, true)
    self.startTextX = self.gameMidX - self.startText.get.width / 2
    self.startTextY = self.gameMidY - self.startText.get.height / 2
end

function game:update(dt)
    self.mainMenuText:update(dt)
    self.startText:update(dt)

    local mx, my = Push:toGame(love.mouse.getPosition())
    if mx >= self.startTextX
        and mx <= self.startTextX + self.startText.get.width
        and my >= self.startTextY + 10
        and my <= self.startTextY + 10 + self.startText.get
        .height then
        if self.inputManager:pressed("leftMouse") then
            self.gameManager:reset()
            self.setScene("gameScene")
        end
    end
end

function game:draw()
    self.mainMenuText:draw(self.mainMenuTextX, self.mainMenuTextY - 30)
    self.scoreText:draw(self.scoreTextX, self.scoreTextY - 30)
    local mx, my = Push:toGame(love.mouse.getPosition())
    if mx >= self.startTextX
        and mx <= self.startTextX + self.startText.get.width
        and my >= self.startTextY + 10
        and my <= self.startTextY + 10 + self.startText.get
        .height then
        love.graphics.setColor(G.palette[3])
        love.graphics.rectangle("fill", self.startTextX, self.startTextY + 10, self.startText.get.width,
            self.startText.get
            .height)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(G.palette[2])
        love.graphics.rectangle("fill", self.startTextX, self.startTextY + 10, self.startText.get.width,
            self.startText.get
            .height)
        love.graphics.setColor(1, 1, 1, 1)
    end
    self.startText:draw(self.startTextX, self.startTextY + 10)
end

return game
