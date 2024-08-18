local utilities = require("utilities")

function CreatePlayer()
    local Player = {}

    Player.x = 10
    Player.y = 130
    Player.size = 10
    Player.health = 3

    return Player
end

function createAim()
    local Aim = {}

    Aim.sprite = love.graphics.newImage("Aim.png")

    Aim.width = Aim.sprite:getWidth()
    Aim.height = Aim.sprite:getHeight()

    Aim.x, Aim.y = Player.x + (Player.size / 2), Player.y + (Player.size / 2)

    Aim.rotation = math.rad(0)

    Aim.scaleX = 0.5
    Aim.scaleY = 0.5

    Aim.originX = Player.x + (Player.size / 2)
    Aim.originY = Player.y + (Player.size / 2)

    return Aim
end

function CreateEnemies()
    local Enemies = {}

    -- random enemy count
    local enemyCount = love.math.random(3, 7)

    for num = 1, enemyCount do
        -- random enemy position
        local x, y = love.math.random(G_gameWidth), love.math.random(G_gameHeight)
        
        table.insert(Enemies, {x=x, y=y, size=10})
    end

    return Enemies
end

function EnemyMove(v)
    local distX =  Player.x - v.x
    local distY =  Player.y - v.y

    local distance = math.sqrt(distX*distX+distY*distY)

    local velocityX = distX / distance
    local velocityY = distY / distance

    v.x = v.x + velocityX * enemySpeed
    v.y = v.y + velocityY * enemySpeed

    return v.x, v.y
 end

 function EnemyCollision(num, e1, e2)
    if CheckCollision(e1.x,e1.y,e1.size,e1.size, e2.x,e2.y,e2.size,e2.size) == true then
        table.remove(Enemies, num)
        Player.health = Player.health - 1
    end
 end

 function BulletCheck()
    for i, v in ipairs(bullets) do
        -- enemy collision check
        for d, c in ipairs(Enemies) do
            if CheckCollision(v.x, v.y, bulletSize, bulletSize,    c.x, c.y, 10, 10) == true then
                table.remove(Enemies,d)
                table.remove(bullets,i)
            end
        end

        -- outside bounds
        if v.x > G_gameWidth or v.x < 0 or v.y > G_gameHeight or v.y < 0 then
            table.remove(bullets, i)
        end
    end
end