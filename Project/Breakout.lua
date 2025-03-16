-- Variables
--=========================================================================================================================

-- ENGINE variables
windowName = "Thalia Tritar - Breakout"
windowWidth = 500
windowHeight = 700
frameRate = 50
listenKeys = "ADR" -- keys to move the paddle left or right

-- paddle variables
paddleWidth = 100      
paddleHeight = 20    
paddleLeft = windowWidth/2 + paddleWidth/2   
paddleTop =  windowHeight - 2*paddleHeight   
paddleSpeed = 15        

-- ball variables
ballX = windowWidth  /2       
ballY = 2*windowHeight /3        
ballSpeedX = 5
ballSpeedY = -5   
ballRadius = 10    

if math.random(0,1)==1 then -- 50% chance to start in opposite direction
    ballSpeedX = ballSpeedX* (-1)  
end

-- power-up variables
bluePowerUpX = -1           -- (-1 = not active)
bluePowerUpY = -1           
bluePowerUpPickupable = false   
bluePowerUpEffectTime = 0   -- how long the power-up lasts
bluePowerUpDuration = 350   -- power-up duration (ticks)
bluePowerUpSizeIncrease = 50
bluePowerUpDropChance = 5 -- one in x chance (1/x)


-- brick Variables
bricks = {}         -- array of all bricks
brickRows = 5       -- total number of brick rows
brickCols = 7       -- total number of brick columns
brickWidth = 60    
brickHeight = 20    
brickPadding = 10   -- spacing between bricks
brickOffsetX = 10   -- offset from the left edge of the screen (margin)
brickOffsetY = 50   -- offset from the top edge of the screen (margin)

for row = 1, brickRows do   -- Initialise each brick
    bricks[row] = {}
    for col = 1, brickCols do
        lifes=math.random(1,3)
        bricks[row][col] = lifes
    end
end


-- game variables
gameOver = false    -- is game over?    (flag)
gameWin = false     -- is game won?     (flag)
maxLives = 3
lives = maxLives



-- Print Instructions!!!
print("Use A and D to move the paddle left and right.")
print("Use R to reset the game.")
print("")


-- Paint function
--=================
function Paint()
    FillWindowRect(0, 0, 0) -- clear screen 
    
    -- GAME DRAW
    ------------

    -- Draw power-up
    if bluePowerUpPickupable then   -- blue power-up
        SetColor(0, 0, 255) 
        DrawOval(bluePowerUpX - 10, bluePowerUpY - 10, bluePowerUpX + 10, bluePowerUpY + 10)
        SetColor(50, 50, 255) 
        DrawOval(bluePowerUpX - 6, bluePowerUpY - 6, bluePowerUpX + 6, bluePowerUpY + 6)
        SetColor(80, 80, 255) 
        DrawOval(bluePowerUpX - 2, bluePowerUpY - 2, bluePowerUpX + 2, bluePowerUpY + 2)
    end

    
    -- Draw paddle

    if bluePowerUpEffectTime > 0 then
        SetColor(0, 0, 255) 
        DrawRect(paddleLeft - 5, paddleTop - 5, paddleLeft + paddleWidth + 5, paddleTop + paddleHeight + 5) -- outer glow
    end

    SetColor(255, 255, 255)
    DrawRect(paddleLeft, paddleTop, paddleLeft + paddleWidth, paddleTop+paddleHeight)
    
    -- Draw ball
    SetColor(150, 255, 150)
    FillOval(ballX - ballRadius, ballY - ballRadius, ballX + ballRadius, ballY + ballRadius)
    
    -- Draw bricks
    for row = 1, brickRows do
        for col = 1, brickCols do
            if bricks[row][col]==1 then -- has 1 life
                SetColor(255, 0, 0)
                local brickLeft = brickOffsetX + (col - 1) * (brickWidth + brickPadding)
                local brickTop = brickOffsetY + (row - 1) * (brickHeight + brickPadding)
                DrawRect(brickLeft, brickTop, brickLeft + brickWidth, brickTop + brickHeight)
            end
            if bricks[row][col]==2 then -- has 2 life
                SetColor(255, 125, 0)
                local brickLeft = brickOffsetX + (col - 1) * (brickWidth + brickPadding)
                local brickTop = brickOffsetY + (row - 1) * (brickHeight + brickPadding)
                DrawRect(brickLeft, brickTop, brickLeft + brickWidth, brickTop + brickHeight)
            end
            if bricks[row][col]==3 then --has 3 life
                SetColor(255, 255, 0)
                local brickLeft = brickOffsetX + (col - 1) * (brickWidth + brickPadding)
                local brickTop = brickOffsetY + (row - 1) * (brickHeight + brickPadding)
                DrawRect(brickLeft, brickTop, brickLeft + brickWidth, brickTop + brickHeight)
            end
        end
    end


    -- Draw GameOver / GameWin text
    if gameOver then
        SetColor(255, 0, 0)
        DrawString("Game Over!",300,200)
        SetColor(200, 200, 200)
        DrawString("Press R to restart",300,200+20)
    end
    if gameWin then
        SetColor(0, 255, 0)
        DrawString("Game Won!",300,200)
        SetColor(200, 200, 200)
        DrawString("Press R to restart",300,200+20)
    end


    -- HUD DRAW
    ------------

    -- Lives remaining
    diameter=10
    left=10
    top=windowHeight-diameter - 10

    SetColor(150, 255, 150)
    FillOval(left,top,left+diameter,top+diameter )  -- little circle

    text = "x" .. tostring(lives)
    DrawString(text,left+diameter+left,top) -- live remaining number


end

-- Tick function
--================
function Tick()
    -- GAME STATES
    --------------
    if gameOver or gameWin then return end  -- If game state not playing, dont tick

    -- Check if all bricks are destroyed -> game was won
    local bricksLeft = false
    for row = 1, brickRows do
        for col = 1, brickCols do
            if bricks[row][col]~=0 then
                bricksLeft = true
                break
            end
        end

        if bricksLeft then break end
    end
    
    if  not bricksLeft  then
        gameWin = true
        return
    end


    -- MOVEMENT
    --------------

    -- ball
    ballX = ballX + ballSpeedX
    ballY = ballY + ballSpeedY

    -- powerup
    if bluePowerUpPickupable then
        bluePowerUpY = bluePowerUpY + 5 
        if bluePowerUpY > windowHeight then
            bluePowerUpPickupable = false -- disavle if out of screen
        end
    end


    
    -- COLLISIONS
    --------------

    -- Paddle - PowerUp
    if bluePowerUpPickupable and bluePowerUpY + 10 >= paddleTop and bluePowerUpX >= paddleLeft and bluePowerUpX <= paddleLeft + paddleWidth then    --BLUE
        bluePowerUpPickupable = false
        paddleWidth = paddleWidth + bluePowerUpSizeIncrease -- up paddle size
            bluePowerUpEffectTime = bluePowerUpDuration -- set timer
    end


    -- Ball - Walls
    if ballX - ballRadius < 0 or ballX + ballRadius > windowWidth then
        ballSpeedX = -ballSpeedX
    end
    if ballY - ballRadius < 0 then
        ballSpeedY = -ballSpeedY
    end

    -- Ball - Floor (game over / -lose a life-)
    if ballY > windowHeight then
        lives = lives - 1
        if lives > 0 then
            ResetBall()
        else
            gameOver = true 
        end
    end

    -- Ball - Paddle
    if ballY + ballRadius >= paddleTop and ballX >= paddleLeft and ballX <= paddleLeft + paddleWidth then
        ballSpeedY = -ballSpeedY
        ballY = paddleTop - ballRadius -- move up to avoid bug
    end

    -- Ball - Bricks
    for row = 1, brickRows do
        for col = 1, brickCols do
            if bricks[row][col]~=0 then
                local brickLeft = brickOffsetX + (col - 1) * (brickWidth + brickPadding)
                local brickTop = brickOffsetY + (row - 1) * (brickHeight + brickPadding)
                local brickRight = brickLeft + brickWidth
                local brickBottom = brickTop + brickHeight

                if ballX + ballRadius > brickLeft and ballX - ballRadius < brickRight and 
                   ballY + ballRadius > brickTop and ballY - ballRadius < brickBottom then
                    bricks[row][col] = bricks[row][col]-1
                    ballSpeedY = -ballSpeedY
                    
                    if not bluePowerUpPickupable and math.random(1, bluePowerUpDropChance) == 1 then
                        bluePowerUpX = (brickLeft + brickRight) / 2 
                        bluePowerUpY = (brickTop + brickBottom) / 2
                        bluePowerUpPickupable = true
                        end
                    break

                end
            end
        end
    end



    -- TIMER HANDLE
    --------------

    -- BLUEpowerup tumer
    if bluePowerUpEffectTime > 0 then
        bluePowerUpEffectTime = bluePowerUpEffectTime - 1
        if bluePowerUpEffectTime == 0 then
            paddleWidth = paddleWidth - bluePowerUpSizeIncrease -- reset size
        end
    end


end

-- MouseButton function
--======================
function MouseButtonAction(isLeft, isDown, x, y, wParam)    
end

-- MouseMove function
--====================
function MouseMove(x, y, wParam)
end

-- CheckKeyboard function
--=========================
function CheckKeyboard()
    if IsKeyDown("A") then  -- Move left
        paddleLeft = paddleLeft - paddleSpeed
        if paddleLeft < 0 then paddleLeft = 0 end
    end
    if IsKeyDown("D") then  -- Move right
        paddleLeft = paddleLeft + paddleSpeed
        if paddleLeft > 500 - paddleWidth then paddleLeft = 500 - paddleWidth end
    end
end

-- KeyPressed function
--=====================
function KeyPressed(char)
    if char == "R" then     -- Restart game
        gameOver = false
        gameWin=false

        -- reset lives
        lives=maxLives

        ResetBall()
        ResetBricks()
    end
end



-- Local Function
--=====================

--Resets
function ResetBall(...)
    ballX = windowWidth/2
    ballY = 2*windowHeight/3
    ballSpeedX = 5
    ballSpeedY = -5
    if math.random(0,1)==1 then -- 50% chance to start in opposite direction
        ballSpeedX = ballSpeedX* (-1)  
    end
end
function ResetBricks(...)
    for row = 1, brickRows do
        for col = 1, brickCols do
            lifes=math.random(1,3)
        bricks[row][col] = lifes
        end
    end
end