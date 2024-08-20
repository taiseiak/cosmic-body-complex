local Push = require("libraries.push")

local InputManager = require('input-manager')

io.stdout:setvbuf("no")

local game = {}

-- x1,y1 are further out point
-- x2,y2 are center point
function game:getMouseAngle(dx, dy)
    local mx, my = Push:toGame(love.mouse.getPosition())
    mx, my = mx/self.levelScale, my/self.levelScale
    -- local mouseX = love.mouse.getX()
    -- local mouseY = love.mouse.getY()

    local angle = math.atan2((my - dy), (mx - dx))

    return angle
end

local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

function game:getPlayerCenter()
    return self.player.x + (self.player.size / 2), self.player.y + (self.player.size / 2)
end

function game:createPlayer(x, y, size, health)
    self.player.x = x
    self.player.y = y
    self.player.size = size
    self.player.health = health
end

function game:createAim(reticleScale, reticleDistance)
    self.aim.sprite = love.graphics.newImage("Aim.png")
    -- Sets clear renering for pixel sprites
    self.aim.sprite:setFilter('nearest', 'nearest')

    self.aim.width = self.aim.sprite:getWidth()
    self.aim.height = self.aim.sprite:getHeight()

    self.aim.x, self.aim.y = self:getPlayerCenter()

    self.aim.scaleX = reticleScale
    self.aim.scaleY = reticleScale

    -- center of image offset
    self.aim.originOffsetX = self.aim.width * 0.5
    self.aim.originOffsetY = self.aim.height * 0.5

    self.aim.reticleDistance = reticleDistance
end

function game:createEnemies(size, enemyCount, enemyStartPosMultiplier)
    local enemiesSize = size
    local enemyStartPosMultiplier = enemyStartPosMultiplier

    self.enemies.enemyCount = enemyCount

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

        table.insert(self.enemies, { x = ranx, y = rany, size = enemiesSize })
    end
end

function game:createPlayerBullets()
    local mx, my = self:getPlayerCenter()
    local bulletAngle = self:getMouseAngle(mx, my)

    local dx = math.cos(bulletAngle) * self.bulletSpeed
    local dy = math.sin(bulletAngle) * self.bulletSpeed

    table.insert(self.bullets, { x = mx, y = my, dx = dx, dy = dy })
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

    if checkCollision(e1.x, e1.y, e1.size, e1.size, e2.x, e2.y, e2.size, e2.size) == true then
        table.remove(self.enemies, num)
        self.enemies.enemyCount = self.enemies.enemyCount - 1
        self.player.health = self.player.health - 1
    end
end

function game:PlayerBulletCheck()
    for i, v in ipairs(self.bullets) do
        -- enemy collision check
        for d, c in ipairs(self.enemies) do
            if checkCollision(v.x, v.y, self.bulletSize, self.bulletSize, c.x, c.y, 10, 10) == true then
                self.enemies.enemyCount = self.enemies.enemyCount - 1
                table.remove(self.enemies, d)
                table.remove(self.bullets, i)
            end
        end

        -- outside bounds
        if v.x > self.screenWidth or v.x < 0 or v.y > self.screenHeight or v.y < 0 then
            table.remove(self.bullets, i)
        end
    end
end

function game:levelLoad()
    if self.level ~= self.winLevel then
        self.level = self.level + 1
        self.enemies.enemyCount = self.enemies.enemyCount + self.enemyIncrease
        self.levelScale = self.levelScale - self.levelScaleDecrease
        self.screenWidth = G.gameWidth / self.levelScale
        self.screenHeight = G.gameHeight / self.levelScale

        self:createTexts()

        self:createPlayer(
            ((G.gameWidth / 2) / self.levelScale),           -- x-coordinate player starting position
            ((G.gameHeight / 2) / self.levelScale),          -- y-coordinate player starting position
            10, 3)                                           -- size, health
        self:createAim(0.5, 20)                              -- reticleScale, reticleDistance
        self:createEnemies(10, 10, 2 / self.levelScale)      -- size, enemyCount, enemyStartPosMultiplier (recommend 2)
    end
end

function game:createTexts()
    self.enemyCountTextDrawable = love.graphics.newText(Fonts.shinonomeBold, 0)
    self.enemyCountText = {}
    self.enemyCountText.x = 0
    self.enemyCountText.y = 0
    self.enemyCountText.size = 5

    self.levelTextDrawable = love.graphics.newText(Fonts.shinonomeBold, "Level")
    self.levelText = {}
    self.levelText.x = self.screenWidth / 2
    self.levelText.y = 0
    self.levelText.size = 5

    self.levelCountTextDrawable = love.graphics.newText(Fonts.shinonomeBold, 0)
    self.levelCountText = {}
    self.levelCountText.x = self.screenWidth / 2
    self.levelCountText.y = self.levelTextDrawable:getHeight()
    self.levelCountText.size = 5

    self.gameOverTextDrawable = love.graphics.newText(Fonts.shinonomeBold, "Game Over")
    self.gameOverText = {}
    self.gameOverText.x = self.screenWidth / 2 - 30
    self.gameOverText.y = self.screenHeight / 2 - 20
    self.gameOverText.size = 5

    self.retryTextDrawable = love.graphics.newText(Fonts.shinonome, "Retry")
    self.retryText = {}
    self.retryText.x = self.screenWidth / 2 - 20
    self.retryText.y = self.screenHeight / 2 + 20
    self.retryText.size = 3

    self.winTextDrawable = love.graphics.newText(Fonts.shinonomeBold, "You Win")
    self.winText = {}
    self.winText.x = self.screenWidth / 2 - 30
    self.winText.y = self.screenHeight / 2 - 20
    self.winText.size = 5
end






function game:load(args)
    self.bulletSize = 2
    self.bulletSpeed = 10
    self.enemySpeed = 1
    self.level = 0
    self.winLevel = 3
    self.levelScale = 1
    self.screenWidth = G.gameWidth
    self.screenHeight = G.gameHeight
    self.enemyIncrease = 1 -- enemy increase count per level
    self.levelScaleDecrease  = 0.1 -- zoom out scaling per level. increasing number will increase zooming out per level
    self.enemies = {enemyCount = 10}
    self.aim = {}
    self.player = {}
    self.bullets = {}

    self:levelLoad()

    self.inputManager = InputManager:getInstance()
end


function game:update(dt)
    if self.player.health >= 0 then
        -- player movement
        local x, y = self.inputManager.input:get('move')
        self.player.x = self.player.x + x * dt * 150
        self.player.y = self.player.y + y * dt * 150
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
        self.aim.angle = (self:getMouseAngle(mx, my))

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
        for i, v in ipairs(self.bullets) do
            v.x = v.x + (v.dx * 0.25)
            v.y = v.y + (v.dy * 0.25)
        end

        -- remove enemy and excess bullets
        self:PlayerBulletCheck()

        if self.enemies.enemyCount < 1 then
            self:levelLoad()
        end
    else
        local mx, my = Push:toGame(love.mouse.getPosition())
        mx, my = mx/self.levelScale, my/self.levelScale

        if self.inputManager:pressed("leftMouse") then
            -- retry button
            if checkCollision(self.retryText.x, self.retryText.y, self.retryTextDrawable:getWidth(), self.retryTextDrawable:getHeight(),
                mx, my, 1, 1) then
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
    love.graphics.scale(self.levelScale, self.levelScale) -- zoom out, needs to be at top to scale before rendering everything

    -- Debug
    if G.debug then
        -- Mouse location
        local mx, my = Push:toGame(love.mouse.getPosition())
        mx, my = mx/self.levelScale, my/self.levelScale
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle("line", mx, my, 2)

        -- Player location
        love.graphics.setColor(0, 1, 0, 1)
        local px, py = self:getPlayerCenter()
        love.graphics.circle("line", px, py, 10)

        love.graphics.setColor(1, 1, 1, 1)
    end

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

    -- enemy count text
    self.enemyCountTextDrawable:set(self.enemies.enemyCount)
    love.graphics.draw(self.enemyCountTextDrawable, self.enemyCountText.x, self.enemyCountText.y)

    -- bullets
    for i, v in ipairs(self.bullets) do
        love.graphics.rectangle("fill", v.x, v.y, self.bulletSize, self.bulletSize)
    end

    -- win text
    if self.level == self.winLevel and self.enemies.enemyCount == 0 then
        love.graphics.draw(self.winTextDrawable, self.winText.x, self.winText.y)
    end

    -- level text
    love.graphics.draw(self.levelTextDrawable, self.levelText.x, self.levelText.y)
    self.levelCountTextDrawable:set(self.level)
    love.graphics.draw(self.levelCountTextDrawable, self.levelCountText.x, self.levelCountText.y)
end

return game
