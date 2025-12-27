function love.load()
    love.window.setTitle("My Love2D Game")
    love.window.setMode(800, 600)
    width, height = love.graphics.getDimensions()
    shootSound = love.audio.newSource("shoot.wav", "static")
    player1 = {
        x = width * 1/4,
        y = height * 1/4,
        rotation = 5/4 * math.pi,
        speed = 200,
        bullets = {},
        bulletCount = 10,
        lastbullettime = 4,
        lastblocktime = 0,
        color = {0, 0, 1}, -- Blue color
        health = 5,
    }
    player2 = {
        x = width * 3/4,
        y = height * 3/4,
        rotation = 1/4 * math.pi,
        speed = 200,
        bullets = {},
        bulletCount = 10,
        lastbullettime = 4,
        lastblocktime = 0,
        color = {1, 0.4, 0}, -- orange color
        health = 5,
    }   
    bulletSpeed = 500
end

function drawPlayer(player)
    love.graphics.setColor(player.color)
    love.graphics.push()
    love.graphics.translate(player.x, player.y)
    love.graphics.rotate(player.rotation)
    love.graphics.circle("fill", -0, -0, 30)
    love.graphics.rectangle("fill", 15, -15, 30, 30)
    love.graphics.setColor(1, 1, 1)
    for i = 1, 5 do
        if i > player.health then
            love.graphics.setColor(1, 1, 1, 0.5) -- Dark color for lost health
        else
            love.graphics.setColor(1, 1, 1) -- White color for remaining health
        end
        love.graphics.push()
        love.graphics.rotate(math.pi*2/5 * i)
        love.graphics.translate(15, 0)
        love.graphics.circle("fill", 0, 0, 6)
        love.graphics.pop()
    end
    love.graphics.pop()
end

function drawBullets()
    love.graphics.setColor(1, 0, 0) -- Set color to red for bullets
    for _, bullet in ipairs(player1.bullets) do
        love.graphics.push()
        love.graphics.translate(bullet.x, bullet.y)
        love.graphics.rotate(bullet.rotation + math.pi/2)
        love.graphics.rectangle("fill", -2, -5, 4, 10)
        love.graphics.pop()
    end
    
    for _, bullet in ipairs(player2.bullets) do
        love.graphics.push()
        love.graphics.translate(bullet.x, bullet.y )
        love.graphics.rotate(bullet.rotation + math.pi/2)
        love.graphics.rectangle("fill", -2, -5, 4, 10)
        love.graphics.pop()
    end
end

function shoot(player)
    shootSound:setPitch(1.8 + math.random() * 0.4)
    shootSound:setVolume(0.2)
    love.audio.play(shootSound)
    table.insert(player.bullets, {
        x = player.x + math.cos(player.rotation) * 45,
        y = player.y + math.sin(player.rotation) * 45,
        rotation = player.rotation
    })
end

function moveBullets(dt)
    for i, bullet in ipairs(player1.bullets) do
        bullet.x = bullet.x + dt * bulletSpeed * math.cos(bullet.rotation)
        bullet.y = bullet.y + dt * bulletSpeed * math.sin(bullet.rotation)
    end
    for i, bullet in ipairs(player2.bullets) do
        bullet.x = bullet.x + dt * bulletSpeed * math.cos(bullet.rotation)
        bullet.y = bullet.y + dt * bulletSpeed * math.sin(bullet.rotation)
    end
end

function bulletColision(bullet, player, otherPlayer)
    local dist = distance(bullet, player)
    if dist < 30 then
            print("Player 1 hit Player 2!")
            table.remove(otherPlayer.bullets, i)
            if love.timer.getTime() - player.lastblocktime < 2 then
                return
            end
            player.health = player.health - 1
            if player.health <= 0 then
                love.event.quit()
            end
        elseif bullet.x < 0 or bullet.x > width or bullet.y < 0 or bullet.y > height then
            table.remove(otherPlayer.bullets, i)
        end
end

function distance(obj1, obj2)
    local dx = obj1.x - obj2.x
    local dy = obj1.y - obj2.y
    return math.sqrt(dx * dx + dy * dy)
end

function love.update(dt)

    moveBullets(dt)

    for i, bullet in ipairs(player1.bullets) do
       bulletColision(bullet, player2, player1)
    end

    for i, bullet in ipairs(player2.bullets) do
         bulletColision(bullet, player1, player2)
    end

-- Reset player colors after block duration
if love.timer.getTime() - player1.lastblocktime > 2 and love.timer.getTime() - player1.lastblocktime < 3 then
    player1.color = {0, 0, 1} -- Revert to blue
end

if love.timer.getTime() - player2.lastblocktime > 2 and love.timer.getTime() - player2.lastblocktime < 3 then
    player2.color = {1, 0.4, 0} -- Revert to orange
end
    -------------------------------------------------
    ---------player1 movement and shooting-----------
    -------------------------------------------------

    if love.keyboard.isDown("a") then -- Rotate left
        player1.rotation = player1.rotation - 3 * love.timer.getDelta()
    end
    if love.keyboard.isDown("d") then -- Rotate right
        player1.rotation = player1.rotation + 3 * love.timer.getDelta()    
    end
    if love.keyboard.isDown("w") then -- Move forward
        player1.x = player1.x + math.cos(player1.rotation) * player1.speed * dt
        player1.y = player1.y + math.sin(player1.rotation) * player1.speed * dt
    elseif love.keyboard.isDown("s") then -- Move backward
        player1.x = player1.x - math.cos(player1.rotation) * player1.speed * dt / 2
        player1.y = player1.y - math.sin(player1.rotation) * player1.speed * dt / 2
    end
    if love.keyboard.isDown("space") then -- Shoot
        if love.timer.getTime() - player1.lastbullettime > 0.1 and player1.bulletCount > 0 then
            shoot(player1)
            player1.lastbullettime = love.timer.getTime()
            player1.bulletCount = player1.bulletCount - 1
        elseif love.timer.getTime() - player1.lastbullettime > 0.1 then
            player1.lastbullettime = love.timer.getTime() + 0.9 -- Delay before next shot when out of bullets
            player1.bulletCount = 10 -- Reload bullets
        end
    end
    if love.keyboard.isDown("lshift") then -- block
        if love.timer.getTime() - player1.lastblocktime > 5 then
           player1.lastblocktime = love.timer.getTime() 
           player1.color = {0, 1, 1}
        end        
    end

    -------------------------------------------------
    ---------player2 movement and shooting-----------
    -------------------------------------------------

    if love.keyboard.isDown("l") then -- Rotate left
        player2.rotation = player2.rotation - 3 * love.timer.getDelta()
    end
    if love.keyboard.isScancodeDown("'")then -- Rotate right
        player2.rotation = player2.rotation + 3 * love.timer.getDelta()    
    end
    if love.keyboard.isDown("p") then -- Move forward
        player2.x = player2.x + math.cos(player2.rotation) * player2.speed * dt
        player2.y = player2.y + math.sin(player2.rotation) * player2.speed * dt
    elseif love.keyboard.isScancodeDown(";") then -- Move backward
        player2.x = player2.x - math.cos(player2.rotation) * player2.speed * dt / 2
        player2.y = player2.y - math.sin(player2.rotation) * player2.speed * dt / 2
    end
    if love.keyboard.isDown("return") then -- Shoot
        if love.timer.getTime() - player2.lastbullettime > 0.1 and player2.bulletCount > 0 then
            shoot(player2)
            player2.lastbullettime = love.timer.getTime()
            player2.bulletCount = player2.bulletCount - 1
        elseif love.timer.getTime() - player2.lastbullettime > 0.1 then
            player2.lastbullettime = love.timer.getTime() + 0.9 -- Delay before next shot when out of bullets
            player2.bulletCount = 10 -- Reload bullets
        end
    end
    if love.keyboard.isDown("rshift") then -- block
        if love.timer.getTime() - player2.lastblocktime > 5 then
           player2.lastblocktime = love.timer.getTime()
           player2.color = {0, 1, 1} -- Change color to indicate blocking 
        end
    end
end

function love.draw()

    love.graphics.setColor(1, 1, 1) -- Set color to white
    love.graphics.setLineWidth(7)
    love.graphics.rectangle("line", width/2-275, height/2-275, 550, 550)

    drawBullets()
    love.graphics.setColor(1, 1, 1) -- Set color to white
    drawPlayer(player1)
    drawPlayer(player2)
end