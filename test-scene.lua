local InputManager = require('input-manager')
local entities = require("entities")
local utilities = require("utilities")

io.stdout:setvbuf("no")
local TestScene = {}
TestScene.__index = TestScene


function TestScene.new()
    local self = {}

    bulletSize = 2
    bulletSpeed = 10
    enemySpeed = 1

    Enemies = CreateEnemies()
    Player = CreatePlayer()
    Aim = createAim()


    setmetatable(self, TestScene)
    return self
end

function TestScene:update(dt)
    -- enemy movements
    EnemyMove()



    -- aim rotation
    angle = getAngle(love.mouse.getX(), love.mouse.getY(), Aim.x, Aim.y)

    -- aim following player
    Aim.x, Aim.y = Player.x + (Player.size / 2), Player.y + (Player.size / 2)

    
    -- bullets movement
    for i, v in ipairs(bullets) do
		v.x = v.x + (v.dx * 0.25)
		v.y = v.y + (v.dy * 0.25)
	end

    -- remove enemy and excess bullets
    BulletCheck()

    -- player movement
    if InputManager:pressed("lift") then
        Player.y = Player.y - 10
    end
    if InputManager:pressed("lower") then
        Player.y = Player.y + 10
    end
    if InputManager:pressed("right") then
        Player.x = Player.x + 10
    end
    if InputManager:pressed("left") then
        Player.x = Player.x - 10
    end

end

function TestScene:draw()
    -- aim reticle
    love.graphics.draw(Aim.sprite, Aim.x, Aim.y, angle, Aim.scaleX, Aim.scaleY, Aim.originX, Aim.originY)

    -- player
    love.graphics.rectangle("fill", Player.x, Player.y, Player.size, Player.size)

    -- enemy
    for i, v in ipairs(Enemies) do
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill", v.x, v.y, 10, 10)
        love.graphics.setColor(255,255,255)
    end

    -- bullets
    for i, v in ipairs(bullets) do
        love.graphics.rectangle("fill", v.x, v.y, bulletSize, bulletSize)
    end
end


return TestScene
