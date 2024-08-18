local Text = require("libraries.slog-text")

local game = {}

function game:load(args)
    self.mainMenuText = Text.new("center", {
        color = G.palette[3],
        font = Fonts.shinonome,
        shadow_color = G.palette[2],
    })
    self.mainMenuText:send("BUILT TO SCALE", 90, true)
end

function game:update(dt)
    self.mainMenuText:update(dt)
end

function game:draw()
    self.mainMenuText:draw(0, 0)
end

return game
