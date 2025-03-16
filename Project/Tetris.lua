-- Variables
--=========================================================================================================================

-- ENGINE variables
windowName = "Thalia Tritar - Tetris"
windowWidth = 300
windowHeight = 600
frameRate = 50
listenKeys = "ADSW"

-- Grid variables
gridCols = 10
gridRows = 20
blockSize = 30
grid = {}

for i = 1, gridRows do  -- Initialize the grid
    grid[i] = {}
    for j = 1, gridCols do
        grid[i][j] = 0
    end
end


-- Pieces variables
currentPiece = nil
currentX = 5
currentY = 1
pieces = {
    {{1, 1, 1}, {0, 1, 0}}, -- T-piece
    {{1, 1}, {1, 1}},       -- square piece
    {{0, 1, 1}, {1, 1, 0}}, -- S-piece
    {{1, 1, 0}, {0, 1, 1}}, -- Z-piece
    {{1, 1, 1, 1}},         -- long bar piece
    {{1, 1, 1}, {1, 0, 0}}, -- L-piece
    {{1, 1, 1}, {0, 0, 1}}  -- J-piece
}

-- Time and Frames variables
elapsedFrames = 0
moveElapsedFrames = 0 

-- Game Variables
scoreFilledRowMultiplyer = 2
score = 0
gameOver = false




-- Print Instructions!!!
print("Use ASD to move the piece left, down and right.")
print("Use W or LMB to rotate the piece.")
print("")

-- Paint function
--================
function Paint()
    FillWindowRect(0, 0, 0) -- Clear screen 
    
    -- GRID draw
    SetColor(100, 100, 100)
    for i = 1, gridRows do
        for j = 1, gridCols do
            local left = (j - 1) * blockSize
            local top = (i - 1) * blockSize
            local right = left + blockSize
            local bottom = top + blockSize

            if grid[i][j] == 1 then
                SetColor(200, 200, 200)
                FillRect(left, top, right, bottom)
            else
            end

             
            SetColor(50, 50, 50) 
            DrawRect(left, top, right, bottom)

        end
    end
    
    -- PIECE draw
    if currentPiece then 

        SetColor(100, 10, 50) 
        for i, row in ipairs(currentPiece) do
            for j, cell in ipairs(row) do
                if cell == 1 then
                    local left = (currentX + j - 2) * blockSize
                    local top = (currentY + i - 2) * blockSize
                    local right = left + blockSize
                    local bottom = top + blockSize

                    FillRect(left, top, right, bottom)
                end
            end
        end

    end


    -- HUD draw

    if(gameOver) then
        SetColor(255,0,0);
        DrawString("Game over!",200,10)
    end

    SetColor(50,255,50);
    DrawString("SCORE: ".. tostring(score),100,10)

end


-- Tick function
--===============
function Tick()
    if gameOver then
        return
    end

    -- Falling blocks speed control
    if(elapsedFrames >= frameRate) then
        elapsedFrames = 0

        if not currentPiece then
            SpawnNewPiece()
        else
            MovePiece(0, 1)  -- Move piece down by 1
        end
    else
        elapsedFrames = elapsedFrames + 2
    end

end


-- MouseButton function
--======================
function MouseButtonAction(isLeft, isDown, x, y, wParam)
    if isLeft and isDown then
        RotatePiece()
    end
end

-- MouseMove function
--====================
function MouseMove(x, y, wParam)
end

-- CheckKeyboard function
--========================
function CheckKeyboard()
    if moveElapsedFrames >= frameRate then   -- Control movement speed

        moveElapsedFrames = 0  

        if IsKeyDown("D") then
            MovePiece(1, 0) -- Move right
        end
        if IsKeyDown("A") then
            MovePiece(-1, 0) -- Move left
        end

        
        if IsKeyDown("S") then
            MovePiece(0, 2) -- Move down faster
        end
    else
        moveElapsedFrames = moveElapsedFrames + 10
    end
   

end

-- KeyPressed function
--=====================
function KeyPressed(char)
    if char == "W" then
        RotatePiece()
    end

    if char == "R" then
        ResetGame() 
    end
end

-- Local Function
--================

-- Spawn a new piece
function SpawnNewPiece()
    currentPiece = pieces[math.random(#pieces)] --choose random piece
    currentX = math.floor(gridCols / 2) - 1
    currentY = 1

    if not CanPlacePiece(currentX, currentY) then   -- If no piece can be placed -> GAME OVER
        gameOver = true
    end
end

-- Move the current piece
function MovePiece(dx, dy)
    if not currentPiece then return end -- is there a piece to rotate
    if CanPlacePiece(currentX + dx, currentY + dy) then
        currentX = currentX + dx
        currentY = currentY + dy
    elseif dy == 1 then
        PlacePiece()
    end
end

-- Rotate the current piece
function RotatePiece()
    if not currentPiece then return end -- is there a piece to rotate
    local newPiece = {}
    for x = 1, #currentPiece[1] do
        newPiece[x] = {}
        for y = 1, #currentPiece do
            newPiece[x][y] = currentPiece[#currentPiece - y + 1][x]
        end
    end

    if CanPlacePiece(currentX, currentY, newPiece) then
        currentPiece = newPiece
    end
end

-- Check if the piece can be placed
function CanPlacePiece(x, y, piece)
    piece = piece or currentPiece
    for i, row in ipairs(piece) do
        for j, cell in ipairs(row) do

            if cell == 1 then
                local gridX = x + j - 1
                local gridY = y + i - 1
                if gridX < 1 or gridX > gridCols or gridY > gridRows or (gridY > 0 and grid[gridY][gridX] == 1) then
                    return false
                end
            end

        end
    end
    return true
end

-- Place the piece on grid
function PlacePiece()
    if not currentPiece then return end -- is there a piece to plaxe

    totalBlocks=0

    for rowIdx, row in ipairs(currentPiece) do
        for cellIdx, cell in ipairs(row) do
            if cell == 1 then
                totalBlocks = totalBlocks+1 --Increment total block amount

                local gridX = currentX + cellIdx - 1
                local gridY = currentY + rowIdx - 1

                if gridY > 0 then
                    grid[gridY][gridX] = 1
                end
            end
        end
    end

    -- add totalblocks of placed block to score
    score = score + totalBlocks

    ClearLines()
    currentPiece = nil
end

-- Clear completed lines
function ClearLines()
    
    for i = gridRows, 1, -1 do   

        local fullLine = true
        for j = 1, gridCols do--if any of the line has not been filled -> false
                if grid[i][j] == 0 then
                    fullLine = false
                break
            end
        end
       

        if fullLine then
            table.remove(grid, i)    -- remove filled blocks
            table.insert(grid, 1, {})   -- add empty grid bac to table
            for j = 1, gridCols do
                grid[1][j] = 0
                score=score+scoreFilledRowMultiplyer--Increment score
            end
        end

    end
end

-- Reset the game state
function ResetGame()
    -- Reset the grid
    for i = 1, gridRows do
        for j = 1, gridCols do
            grid[i][j] = 0
        end
    end

    -- Reset variables
    currentPiece = nil
    currentX = math.floor(gridCols / 2) - 1
    currentY = 1
    score = 0
    gameOver = false
    elapsedFrames = 0
    moveElapsedFrames = 0

    print("Game has been reset!")
end