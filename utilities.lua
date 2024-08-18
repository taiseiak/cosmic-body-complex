-- x1,y1 are further out point
-- x2,y2 are center point
function getAngle(x1,y1,  x2, y2)
    local dx = x1 - x2
    local dy = -(y1 - y2)

    local angle = math.atan2(dx, dy)

    return angle
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
        x2 < x1+w1 and
        y1 < y2+h2 and
        y2 < y1+h1
end

bullets = {}
function love.mousepressed(x, y, button)
    -- shooting
    if button == 1 then

        local startTime = love.timer.getTime()

        local startX = Player.x + Player.size / 2
        local startY = Player.y + Player.size / 2

        local mouseX = love.mouse.getX()
        local mouseY = love.mouse.getY()

        local bulletAngle = math.atan2((mouseY - startY), (mouseX - startX))

        local dx = math.cos(bulletAngle) * bulletSpeed
        local dy = math.sin(bulletAngle) * bulletSpeed
        
        table.insert(bullets, {x = startX, y = startY, dx = dx, dy = dy})
        
    end
end