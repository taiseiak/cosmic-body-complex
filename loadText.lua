local Text = require("libraries.slog-text")

local function LoadText()
    Fonts = {
        shinonome = love.graphics.newFont("assets/fonts/JF-Dot-ShinonomeMin14.ttf", 14, "mono"),
        shinonomeBold = love.graphics.newFont("assets/fonts/JF-Dot-ShinonomeMin14B.ttf", 14, "mono")
    }
    Text.configure.font_table("Fonts")

    Audio = { ch20 = love.audio.newSource("assets/sounds/CH 20.ogg", "static"), }
    Text.configure.add_text_sound(Audio.ch20, 0.2)
end

return LoadText
