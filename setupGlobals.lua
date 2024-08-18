local Scenery = require("libraries.scenery")

local function setupGlobals()
    local g = {}
    g.gameWidth, g.gameHeight = 1280, 720
    g.currentTime = 0
    g.currentScene = "lunge"
    g.scenes = {}
    g.palette = {
        { 43 / 255,  43 / 255,  38 / 255 },  -- #2b2b26
        { 112 / 255, 107 / 255, 102 / 255 }, -- #706b66
        { 168 / 255, 159 / 255, 148 / 255 }, -- #a89f94
        { 224 / 255, 219 / 255, 205 / 255 }, -- #e0dbcd
    }
    g.scenery = Scenery("mainMenu")
    return g
end

return setupGlobals
