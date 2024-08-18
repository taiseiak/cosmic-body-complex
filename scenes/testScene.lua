local InputManager = require('input-manager')

local game = {}

io.stdout:setvbuf("no")
local bullets = {}

-- x1,y1 are further out point
-- x2,y2 are center point
local function getMouseAngle(x, y)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    local angle = math.atan2((mouseY - y), (mouseX - x))

    return angle
end

local function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

function CreatePlayer()
    local Player = {}

    Player.x = G.gameWidth/2
    Player.y = G.gameHeight/2
    Player.size = 10
    Player.health = 3

    return Player
end

function CreateAim(Player)
    local Aim = {}

    Aim.sprite = love.graphics.newImage("Aim.png")

    Aim.width = Aim.sprite:getWidth()
    Aim.height = Aim.sprite:getHeight()

    Aim.x = Player.x + (Player.size / 2)
    Aim.y = Player.y + (Player.size / 2)

    Aim.rotation = math.rad(0)

    Aim.scaleX = 0.5
    Aim.scaleY = 0.5

    Aim.originX = Player.x + (Player.size / 2)
    Aim.originY = Player.y + (Player.size / 2)

    Aim.angle = 0

    return Aim
end

function CreateEnemies()
    local Enemies = {}
    local enemiesSize = 10
    local minEnemies, maxEnemies = 0, 0
    local enemyStartPosMultiplier = 2

    -- random enemy count
    local enemyCount = love.math.random(minEnemies, maxEnemies)

    for num = 1, enemyCount do
        -- random enemy position
        local x, y = love.math.random(0,G.gameWidth) * enemyStartPosMultiplier, love.math.random(0,G.gameHeight) * enemyStartPosMultiplier

        -- random negative
        local neg = love.math.random(1,4)
        print(neg)
        if neg == 1 then
            x = x * -1
        elseif neg == 2 then
            y = y * -1
        end

        table.insert(Enemies, { x = x, y = y, size = enemiesSize })
    end

    return Enemies
end

function game:EnemyMove(v)
    local distX = self.Player.x - v.x
    local distY = self.Player.y - v.y

    local distance = math.sqrt(distX * distX + distY * distY)

    local velocityX = distX / distance
    local velocityY = distY / distance

    v.x = v.x + velocityX * self.enemySpeed
    v.y = v.y + velocityY * self.enemySpeed

    return v.x, v.y
end

function game:EnemyCollision(num, e1, e2)
    if CheckCollision(e1.x, e1.y, e1.size, e1.size, e2.x, e2.y, e2.size, e2.size) == true then
        table.remove(self.Enemies, num)
        self.Player.health = self.Player.health - 1
    end
end

function game:BulletCheck()
    for i, v in ipairs(bullets) do
        -- enemy collision check
        for d, c in ipairs(self.Enemies) do
            if CheckCollision(v.x, v.y, self.bulletSize, self.bulletSize, c.x, c.y, 10, 10) == true then
                table.remove(self.Enemies, d)
                table.remove(bullets, i)
            end
        end

        -- outside bounds
        if v.x > G.gameWidth or v.x < 0 or v.y > G.gameHeight or v.y < 0 then
            table.remove(bullets, i)
        end
    end
end

function game:load(args)
    self.bulletSize = 2
    self.bulletSpeed = 10
    self.enemySpeed = 1

    self.font = love.graphics.newFont(100)
    self.gameOverText = love.graphics.newText(self.font, "Game Over")

    self.Enemies = CreateEnemies()
    self.Player = CreatePlayer()
    self.Aim = CreateAim(self.Player)
    self.inputManager = InputManager:getInstance()
end

function game:update(dt)
    -- enemies
    for i, v in ipairs(self.Enemies) do
        v.x, v.y = self:EnemyMove(v)
        self:EnemyCollision(i, v, self.Player)
    end

    if self.inputManager:pressed("leftMouse") then
        -- shooting
        local x = self.Player.x + self.Player.size / 2
        local y = self.Player.y + self.Player.size / 2

        local bulletAngle = getMouseAngle(x, y)

        local dx = math.cos(bulletAngle) * self.bulletSpeed
        local dy = math.sin(bulletAngle) * self.bulletSpeed

        table.insert(bullets, { x = x, y = y, dx = dx, dy = dy })
    end

    if self.Player.health > 0 then
        -- aim rotation
        self.Aim.angle = getMouseAngle(self.Aim.x, self.Aim.y)

        -- aim following player
        --self.Aim.x, self.Aim.y = self.Player.x + (self.Player.size / 2), self.Player.y + (self.Player.size / 2)
        --self.Aim.originX, self.Aim.originY = self.Player.x + (self.Player.size / 2), self.Player.y + (self.Player.size / 2)


        -- bullets movement
        for i, v in ipairs(bullets) do
            v.x = v.x + (v.dx * 0.25)
            v.y = v.y + (v.dy * 0.25)
        end

        -- remove enemy and excess bullets
        self:BulletCheck()

        -- player movement
        if self.inputManager:pressed("w") then
            self.Player.y = self.Player.y - 10
        end
        if self.inputManager:pressed("s") then
            self.Player.y = self.Player.y + 10
        end
        if self.inputManager:pressed("d") then
            self.Player.x = self.Player.x + 10
        end
        if self.inputManager:pressed("a") then
            self.Player.x = self.Player.x - 10
        end
    end
end

function game:draw()
    -- self.aim reticle
    love.graphics.draw(self.Aim.sprite, self.Aim.x, self.Aim.y, self.Aim.angle, self.Aim.scaleX, self.Aim.scaleY, 
        self.Aim.originX, self.Aim.originY)

    -- player
    love.graphics.rectangle("fill", self.Player.x, self.Player.y, self.Player.size, self.Player.size)

    -- game over text
    if self.Player.health < 1 then
        love.graphics.draw(self.gameOverText, 300, 300)
    end

    -- enemy
    for i, v in ipairs(self.Enemies) do
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", v.x, v.y, v.size, v.size)
        love.graphics.setColor(255, 255, 255)
    end

    -- bullets
    for i, v in ipairs(bullets) do
        love.graphics.rectangle("fill", v.x, v.y, self.bulletSize, self.bulletSize)
    end
end

return game
