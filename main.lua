local Push = require("libraries.push")

local InputManager = require("input-manager")

local TestScene = require("test-scene")
local LungeScene = require("lunge-scene")

local palette = {
    { 43 / 255,  43 / 255,  38 / 255 },  -- #2b2b26
    { 112 / 255, 107 / 255, 102 / 255 }, -- #706b66
    { 168 / 255, 159 / 255, 148 / 255 }, -- #a89f94
    { 224 / 255, 219 / 255, 205 / 255 }, -- #e0dbcd
}

G_gameWidth, G_gameHeight = 320, 180
G_currentTime = 0
G_currentScene = "lunge"
G_scenes = {}

-- [Locals] --
local startTime
local testScene

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    Push:setupScreen(G_gameWidth, G_gameHeight, 1280, 720,
        {
            fullscreen = false,
            highdpi = true,
            pixelperfect = false,
            resizable = false
        })
    -- [managers] --
    InputManager:init()

    startTime = love.timer.getTime()

    -- [scenes] --
    testScene = TestScene.new()
    G_scenes.lunge = LungeScene.new()
end

function love.update(dt)
    G_currentTime = love.timer.getTime() - startTime

    InputManager:update()

    G_scenes[G_currentScene]:update(dt)
end

function love.draw()
    love.graphics.clear(palette[2])
    Push:apply("start")
    love.graphics.clear(palette[1])
    G_scenes[G_currentScene]:draw()
    Push:apply("end")
end
