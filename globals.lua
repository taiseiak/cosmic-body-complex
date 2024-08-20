local Scenery = require("libraries.scenery")

G = {}
G.debug = false
G.gameWidth, G.gameHeight = 320, 180
G.currentTime = 0
G.currentScene = "lunge"
G.scenes = {}
G.palette = {
    { 43 / 255,  43 / 255,  38 / 255 },  -- #2b2b26
    { 112 / 255, 107 / 255, 102 / 255 }, -- #706b66
    { 168 / 255, 159 / 255, 148 / 255 }, -- #a89f94
    { 224 / 255, 219 / 255, 205 / 255 }, -- #e0dbcd
}
-- This is the default scene.
-- Change the string to change the default scene.
G.scenery = Scenery("mainMenu")
