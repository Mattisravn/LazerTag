function love.load()
    love.window.setTitle("My Love2D Game")
    love.window.setMode(800, 600)
    width, height = love.graphics.getDimensions()
    shootSound = love.audio.newSource("shoot.wav", "static")
    player1 = {
        x = width / 2,
        y = height / 2,
        rotation = 0,
        speed = 200,
        bullets = {},
        bulletCount = 10,
        lastbullettime = 0,
        color = {0, 0, 1} -- Blue color

    }   
    player2 = {
        x = width / 2,
        y = height / 2,
        rotation = 0,
        speed = 200,
        bullets = {},
        bulletCount = 10,
        lastbullettime = 0,
        color = {1, 0.4, 0} -- orange color
    }   
    bulletSpeed = 500
end

function drawPlayer1()
    love.graphics.setColor(player1.color)
    love.graphics.push()
    love.graphics.translate(player1.x, player1.y)
    love.graphics.rotate(player1.rotation + math.pi / 4)
    love.graphics.circle("fill", -0, -0, 30)
    love.graphics.rectangle("fill", -10, -10, 40, 40)
    love.graphics.pop()
end

function drawPlayer2()
    love.graphics.setColor(player2.color)
    love.graphics.push()
    love.graphics.translate(player2.x, player2.y)
    love.graphics.rotate(player2.rotation + math.pi / 4)
    love.graphics.circle("fill", -0, -0, 30)
    love.graphics.rectangle("fill", -10, -10, 40, 40)
    love.graphics.pop()
end

function drawBullets()
    love.graphics.setColor(1, 0, 0) -- Set color to red for bullets
    for _, bullet in ipairs(player1.bullets) do
        love.graphics.push()
        love.graphics.translate(player1.x, player1.y)
        love.graphics.rotate(bullet.rotation)
        love.graphics.rectangle("fill",0 -2, bullet.pos - 5, 4, 10)
        love.graphics.pop()
    end
    for _, bullet in ipairs(player2.bullets) do
        love.graphics.push()
        love.graphics.translate(player2.x, player2.y)
        love.graphics.rotate(bullet.rotation)
        love.graphics.rectangle("fill",0 -2, bullet.pos - 5, 4, 10)
        love.graphics.pop()
    end
end

function shoot(player)
    shootSound:setPitch(1.8 + math.random() * 0.4)
    shootSound:setVolume(0.2)
    love.audio.play(shootSound)
    table.insert(player.bullets, {pos = 45,rotation = player.rotation})
end

function moveBullets(dt)
    for i, bullet in ipairs(player1.bullets) do
        bullet.pos = bullet.pos + dt * bulletSpeed
    end
    for i, bullet in ipairs(player2.bullets) do
        bullet.pos = bullet.pos + dt * bulletSpeed
    end
end

function love.update(dt)

    moveBullets(dt)

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
        player1.x = player1.x + math.cos(player1.rotation + math.pi / 2) * player1.speed * dt
        player1.y = player1.y + math.sin(player1.rotation + math.pi / 2) * player1.speed * dt
    elseif love.keyboard.isDown("s") then -- Move backward
        player1.x = player1.x - math.cos(player1.rotation + math.pi / 2) * player1.speed * dt / 2
        player1.y = player1.y - math.sin(player1.rotation + math.pi / 2) * player1.speed * dt / 2
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
    if love.keyboard.isDown("rshift") then -- block
        
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
        player2.x = player2.x + math.cos(player2.rotation + math.pi / 2) * player2.speed * dt
        player2.y = player2.y + math.sin(player2.rotation + math.pi / 2) * player2.speed * dt
    elseif love.keyboard.isScancodeDown(";") then -- Move backward
        player2.x = player2.x - math.cos(player2.rotation + math.pi / 2) * player2.speed * dt / 2
        player2.y = player2.y - math.sin(player2.rotation + math.pi / 2) * player2.speed * dt / 2
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
    if love.keyboard.isDown("lshift") then -- block
        
    end
end

function love.draw()

    love.graphics.setColor(1, 1, 1) -- Set color to white
    love.graphics.setLineWidth(7)
    love.graphics.rectangle("line", width/2-275, height/2-275, 550, 550)

    drawBullets()
    love.graphics.setColor(1, 1, 1) -- Set color to white
    drawPlayer1()
    drawPlayer2()
end

