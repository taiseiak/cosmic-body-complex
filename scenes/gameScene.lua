local InputManager = require('input-manager')

local game = {}

io.stdout:setvbuf("no")
local bullets = {}

-- x1,y1 are further out point
-- x2,y2 are center point
local function getMouseAngle(dx, dy)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    local angle = math.atan((mouseY - dy), (mouseX - dx))

    return angle
end

local function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

function game:getPlayerCenter()
    return self.player.x + (self.player.size / 2), self.player.y + (self.player.size / 2)
end

function game:createPlayer(x, y, size, health)
    local player = {}

    player.x = x
    player.y = y
    player.size = size
    player.health = health

    return player
end

function game:createAim(scale, reticleDistance)
    local aim = {}

    aim.sprite = love.graphics.newImage("Aim.png")

    aim.width = aim.sprite:getWidth()
    aim.height = aim.sprite:getHeight()

    aim.x, aim.y = self:getPlayerCenter()

    aim.scaleX = scale
    aim.scaleY = scale

    -- center of image offset
    aim.originOffsetX = aim.width * 0.5
    aim.originOffsetY = aim.height * 0.5

    aim.reticleDistance = reticleDistance

    return aim
end

function game:createEnemies(size, enemyCount, enemyStartPosMultiplier)
    local enemies = {}
    local enemiesSize = size
    local enemyStartPosMultiplier = enemyStartPosMultiplier

    for num = 1, enemyCount do
        -- random enemy position
        local ranx, rany = love.math.random(0, G.gameWidth) * enemyStartPosMultiplier,
            love.math.random(0, G.gameHeight) * enemyStartPosMultiplier

        -- random negative
        local neg = love.math.random(1, 4)
        if neg == 1 then
            ranx = ranx * -1
        elseif neg == 2 then
            rany = rany * -1
        end

        table.insert(enemies, { x = ranx, y = rany, size = enemiesSize })
    end

    return enemies
end

function game:createPlayerBullets()
    local mx, my = self:getPlayerCenter()
    local bulletAngle = getMouseAngle(mx, my)

    local dx = math.cos(bulletAngle) * self.bulletSpeed
    local dy = math.sin(bulletAngle) * self.bulletSpeed

    table.insert(bullets, { x = mx, y = my, dx = dx, dy = dy })
end

function game:EnemyMove(v)
    local distX = self.player.x - v.x
    local distY = self.player.y - v.y

    local distance = math.sqrt(distX * distX + distY * distY)

    local velocityX = distX / distance
    local velocityY = distY / distance

    v.x = v.x + velocityX * self.enemySpeed
    v.y = v.y + velocityY * self.enemySpeed

    return v.x, v.y
end

function game:EnemyCollision(num, e1, e2)
    if CheckCollision(e1.x, e1.y, e1.size, e1.size, e2.x, e2.y, e2.size, e2.size) == true then
        table.remove(self.enemies, num)
        self.player.health = self.player.health - 1
    end
end

function game:PlayerBulletCheck()
    for i, v in ipairs(bullets) do
        -- enemy collision check
        for d, c in ipairs(self.enemies) do
            if CheckCollision(v.x, v.y, self.bulletSize, self.bulletSize, c.x, c.y, 10, 10) == true then
                table.remove(self.enemies, d)
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
    self.gameOverTextDrawable = love.graphics.newText(self.font, "Game Over")
    self.gameOverText = {}
    self.gameOverText.x = 300
    self.gameOverText.y = 300
    self.gameOverText.size = 100

    self.retryTextDrawable = love.graphics.newText(love.graphics.newFont(50), "Retry")
    self.retryText = {}
    self.retryText.x = 500
    self.retryText.y = 500
    self.retryText.size = 50

    self.player = self:createPlayer(G.gameWidth / 2, G.gameHeight / 2, 10, 3) -- x, y, size, health
    self.aim = self:createAim(0.5, 20)                                        -- scale, reticleDistance
    self.enemies = self:createEnemies(10, 10, 2)                              -- size, enemyCount, enemyStartPosMultiplier (recommend 2)

    self.inputManager = InputManager:getInstance()
end

function game:update(dt)
    if self.player.health > 0 then
        -- player movement
        local x, y = self.inputManager.input:get('move')
        self.player.x = self.player.x + x * dt * 100
        self.player.y = self.player.y + y * dt * 100
        -- if self.inputManager:pressed("w") then
        --     self.player.y = self.player.y - 10
        -- end
        -- if self.inputManager:pressed("s") then
        --     self.player.y = self.player.y + 10
        -- end
        -- if self.inputManager:pressed("d") then
        --     self.player.x = self.player.x + 10
        -- end
        -- if self.inputManager:pressed("a") then
        --     self.player.x = self.player.x - 10
        -- end


        -- aim angle
        local mx, my = self:getPlayerCenter()
        self.aim.angle = (getMouseAngle(mx, my))

        -- aim following player
        local dx = math.cos(self.aim.angle) * self.aim.reticleDistance
        local dy = math.sin(self.aim.angle) * self.aim.reticleDistance
        self.aim.x = mx + (dx)
        self.aim.y = my + (dy)

        -- create bullets
        if self.inputManager:pressed("leftMouse") then
            self:createPlayerBullets()
        end

        -- bullets movement
        for i, v in ipairs(bullets) do
            v.x = v.x + (v.dx * 0.25)
            v.y = v.y + (v.dy * 0.25)
        end

        -- remove enemy and excess bullets
        self:PlayerBulletCheck()
    else
        local x, y = love.mouse.getPosition()
        if self.inputManager:pressed("leftMouse") then
            -- retry button
            if x > self.retryText.x and x < self.retryText.x * self.retryText.size and
                y > self.retryText.y and y < self.retryText.y * self.retryText.size then
                self:load()
            end
        end
    end

    -- enemies
    for i, v in ipairs(self.enemies) do
        v.x, v.y = self:EnemyMove(v)
        self:EnemyCollision(i, v, self.player)
    end
end

function game:draw()
    -- self.aim reticle
    love.graphics.draw(self.aim.sprite, self.aim.x, self.aim.y, self.aim.angle, self.aim.scaleX, self.aim.scaleY,
        self.aim.originOffsetX, self.aim.originOffsetY)

    -- player
    love.graphics.rectangle("fill", self.player.x, self.player.y, self.player.size, self.player.size)

    -- game over text
    if self.player.health < 1 then
        love.graphics.draw(self.gameOverTextDrawable, self.gameOverText.x, self.gameOverText.y)

        love.graphics.draw(self.retryTextDrawable, self.retryText.x, self.retryText.y)
    end

    -- enemy
    for i, v in ipairs(self.enemies) do
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
