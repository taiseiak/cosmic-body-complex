local Text = require('libraries.slog-text')

local GameManager = {}
GameManager.__index = GameManager

local instance = nil

local function new()
    local gameMidX = G.gameWidth / 2
    local gameMidY = G.gameHeight / 2

    local self = setmetatable({}, GameManager)
    self.paused = false
    self.gameOver = false
    self.score = 0

    self.scoreUI = {
        scoreText = Text.new("left", {
            color = G.palette[4],
            font = Fonts.shinonomeBold,
            shadow_color = G.palette[2],
        })
    }

    self.scoreUI.scoreText:send("[dropshadow=1]SCORE: " .. self.score .. "[/dropshadow]", 180, true)
    self.scoreUI.scoreTextX = 3
    self.scoreUI.scoreTextY = 3

    self.pauseMenu = {
        pauseMenuText = Text.new("center", {
            color = G.palette[4],
            font = Fonts.shinonomeBold,
            shadow_color = G.palette[2],
        }),
        startText = Text.new("center", {
            color = G.palette[4],
            font = Fonts.shinonome,
            shadow_color = G.palette[2],
        })
    }
    self.pauseMenu.pauseMenuText:send("[dropshadow=1]PAUSE[/dropshadow]", 180, true)
    self.pauseMenu.pauseMenuTextX = gameMidX - self.pauseMenu.pauseMenuText.get.width / 2
    self.pauseMenu.pauseMenuTextY = gameMidY - self.pauseMenu.pauseMenuText.get.height / 2
    self.pauseMenu.startText:send("Resume", 40, true)
    self.pauseMenu.startTextX = gameMidX - self.pauseMenu.startText.get.width / 2
    self.pauseMenu.startTextY = gameMidY - self.pauseMenu.startText.get.height / 2
    return self
end

function GameManager:getInstance()
    if not instance then
        instance = new()
    end
    return instance
end

function GameManager:update(dt)
    self.scoreUI.scoreText:update(dt)
    self.pauseMenu.pauseMenuText:update(dt)
    self.pauseMenu.startText:update(dt)
end

function GameManager:draw()
    self.scoreUI.scoreText:draw(self.scoreUI.scoreTextX, self.scoreUI.scoreTextY)
    if self.pause then
        self.pauseMenu.pauseMenuText:draw(self.pauseMenu.pauseMenuTextX, self.pauseMenu.PauseMenuTextY)
        self.pauseMenu.startText:draw(self.pauseMenu.startTextX, self.pauseMenu.startTextY)
    end
end

function GameManager:reset()
    self.score = 0
    self.gameOver = false
    self.scoreUI.scoreText:send("[dropshadow=1]SCORE: " .. self.score .. "[/dropshadow]", 180, true)
end

function GameManager:addScore(score)
    self.score = self.score + score
    self.scoreUI.scoreText:send("[dropshadow=1]SCORE: " .. self.score .. "[/dropshadow]", 180, true)
end

function GameManager:setGameOver()
    self.gameOver = true
end

return GameManager
