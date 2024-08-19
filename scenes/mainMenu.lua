local Text = require("libraries.slog-text")
local Push = require("libraries.push")

local InputManager = require("input-manager")

local game = {}

function game:load(args)
    self.gameMidX = G.gameWidth / 2
    self.gameMidY = G.gameHeight / 2

    -- [Main text] --
    self.mainMenuText = Text.new("center", {
        color = G.palette[4],
        font = Fonts.shinonomeBold,
        shadow_color = G.palette[2],
    })
    self.mainMenuText:send("[dropshadow=1]ALL HANDS ON DECK[/dropshadow]", 180, true)
    self.mainMenuTextX = self.gameMidX - self.mainMenuText.get.width / 2
    self.mainMenuTextY = self.gameMidY - self.mainMenuText.get.height / 2

    -- [Start text] --
    self.startText = Text.new("center", {
        color = G.palette[4],
        font = Fonts.shinonome,
        shadow_color = G.palette[2],
    })
    self.startText:send("START", 40, true)
    self.startTextX = self.gameMidX - self.startText.get.width / 2
    self.startTextY = self.gameMidY - self.startText.get.height / 2
    self.inputManager = InputManager:getInstance()
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
            self.setScene("testScene")
        end
    end
end

function game:draw()
    self.mainMenuText:draw(self.mainMenuTextX, self.mainMenuTextY - 30)
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
