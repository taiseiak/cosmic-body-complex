local Push = require("libraries.push")

require("constants")
require("globals")

local LoadText = require("loadText")

local InputManager = require("input-manager")

-- [Globals] --
if LoadText then LoadText() end

-- [Locals] --
local startTime
local inputManager


function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    Push:setupScreen(G.gameWidth, G.gameHeight, 1280, 720,
        {
            fullscreen = false,
            highdpi = true,
            pixelperfect = false,
            resizable = false
        })

    -- [libraries] --
    G.scenery:load()

    -- [managers] --
    inputManager = InputManager:getInstance()

    startTime = love.timer.getTime()
end

function love.update(dt)
    G_currentTime = love.timer.getTime() - startTime

    inputManager:update()

    G.scenery:update(dt)
end

function love.draw()
    love.graphics.clear(G.palette[2])
    Push:apply("start")
    love.graphics.clear(G.palette[1])
    G.scenery:draw()
    Push:apply("end")
end
