local grid = {}
local rows, cols = 20, 10
local blockSize = 30
local currentPiece
local currentX, currentY
local dropTimer = 0
local dropInterval = 0.5
local moveTimer = 0
local moveInterval = 0.1
local gameOver = false
local score = 0
local windowWidth, windowHeight = 1280, 720

local pieces = {
    {
        shape = {
            { 1, 1, 1, 1 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
        },
        color = { 0, 1, 1 }, -- I-piece (Cyan)
    },
    {
        shape = {
            { 1, 1, 1 },
            { 0, 1, 0 },
            { 0, 0, 0 },
        },
        color = { 1, 0, 1 }, -- T-piece (Purple)
    },
    {
        shape = {
            { 1, 1, 0 },
            { 0, 1, 1 },
            { 0, 0, 0 },
        },
        color = { 1, 0, 0 }, -- Z-piece (Red)
    },
    {
        shape = {
            { 0, 1, 1 },
            { 1, 1, 0 },
            { 0, 0, 0 },
        },
        color = { 0, 1, 0 }, -- S-piece (Green)
    },
    {
        shape = {
            { 1, 1 },
            { 1, 1 },
        },
        color = { 1, 1, 0 }, -- O-piece (Yellow)
    },
    {
        shape = {
            { 1, 1, 1 },
            { 1, 0, 0 },
            { 0, 0, 0 },
        },
        color = { 1, 0.5, 0 }, -- L-piece (Orange)
    },
    {
        shape = {
            { 1, 1, 1 },
            { 0, 0, 1 },
            { 0, 0, 0 },
        },
        color = { 0, 0, 1 }, -- J-piece (Blue)
    },
}

function love.load()
    love.window.setTitle("stresstis")
    love.window.setMode(windowWidth, windowHeight, { resizable = false })

    for y = 1, rows do
        grid[y] = {}
        for x = 1, cols do
            grid[y][x] = { value = 0, color = { 0, 0, 0 } }
        end
    end

    spawnNewPiece()
end

function love.draw()
    drawGrid()
    drawPiece(currentPiece, currentX, currentY)
    drawUI()
    if gameOver then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("PERDEU! APERTE 'R' PRA RECOMECA", 0, windowHeight / 2 - 10, windowWidth, "center")
    end
end

function drawGrid()
    local gridOffsetX = (windowWidth - (cols * blockSize)) / 2
    local gridOffsetY = (windowHeight - (rows * blockSize)) / 2

    for y = 1, rows do
        for x = 1, cols do
            if grid[y][x].value == 0 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("line", gridOffsetX + (x - 1) * blockSize, gridOffsetY + (y - 1) * blockSize,
                    blockSize, blockSize)
            else
                love.graphics.setColor(grid[y][x].color)
                love.graphics.rectangle("fill", gridOffsetX + (x - 1) * blockSize, gridOffsetY + (y - 1) * blockSize,
                    blockSize, blockSize)
            end
        end
    end
end

function drawPiece(piece, x, y)
    love.graphics.setColor(piece.color)
    local gridOffsetX = (windowWidth - (cols * blockSize)) / 2
    local gridOffsetY = (windowHeight - (rows * blockSize)) / 2

    for py = 1, #piece.shape do
        for px = 1, #piece.shape[py] do
            if piece.shape[py][px] == 1 then
                love.graphics.rectangle("fill", gridOffsetX + (x + px - 2) * blockSize,
                    gridOffsetY + (y + py - 2) * blockSize, blockSize, blockSize)
            end
        end
    end
end

function drawUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("PONTOS: " .. score, 20, 20)
end

local function canMove(piece, newX, newY)
    for y = 1, #piece.shape do
        for x = 1, #piece.shape[y] do
            if piece.shape[y][x] == 1 then
                local targetX = newX + x - 1
                local targetY = newY + y - 1
                if targetX < 1 or targetX > cols or targetY > rows or (targetY > 0 and grid[targetY][targetX].value ~= 0) then
                    return false
                end
            end
        end
    end
    return true
end

local function rotatePiece(piece)
    local newShape = {}
    local pieceSize = #piece.shape
    for y = 1, pieceSize do
        newShape[y] = {}
        for x = 1, pieceSize do
            newShape[y][x] = piece.shape[pieceSize - x + 1][y]
        end
    end
    return { shape = newShape, color = piece.color }
end

function love.keypressed(key)
    if gameOver then
        if key == "r" then
            love.event.quit("restart")
        end
        return
    end

    if key == "up" then
        local rotatedPiece = rotatePiece(currentPiece)
        if not canMove(rotatedPiece, currentX, currentY) then
            if canMove(rotatedPiece, currentX - 1, currentY) then
                currentX = currentX - 1
                currentPiece = rotatedPiece
            elseif canMove(rotatedPiece, currentX + 1, currentY) then
                currentX = currentX + 1
                currentPiece = rotatedPiece
            end
        else
            currentPiece = rotatedPiece
        end
    elseif key == "space" then
        while canMove(currentPiece, currentX, currentY + 1) do
            currentY = currentY + 1
        end
        placePiece()
        clearLines()
        if not spawnNewPiece() then
            gameOver = true
        end
    end
end

function love.update(dt)
    if gameOver then
        return
    end
    dropTimer = dropTimer + dt
    moveTimer = moveTimer + dt
    local interval = love.keyboard.isDown("down") and dropInterval / 10 or dropInterval
    if dropTimer >= interval then
        dropTimer = 0
        if canMove(currentPiece, currentX, currentY + 1) then
            currentY = currentY + 1
        else
            placePiece()
            clearLines()
            if not spawnNewPiece() then
                gameOver = true
                return
            end
        end
    end
    if moveTimer >= moveInterval then
        moveTimer = 0
        if love.keyboard.isDown("left") and canMove(currentPiece, currentX - 1, currentY) then
            currentX = currentX - 1
        elseif love.keyboard.isDown("right") and canMove(currentPiece, currentX + 1, currentY) then
            currentX = currentX + 1
        end
    end
end

function placePiece()
    for y = 1, #currentPiece.shape do
        for x = 1, #currentPiece.shape[y] do
            if currentPiece.shape[y][x] == 1 then
                local gridY = currentY + y - 1
                local gridX = currentX + x - 1
                if gridY > 0 then
                    grid[gridY][gridX] = { value = 1, color = currentPiece.color }
                end
            end
        end
    end
end

function clearLines()
    local linesToRemove = {}
    for y = 1, rows do
        local fullLine = true
        for x = 1, cols do
            if grid[y][x].value == 0 then
                fullLine = false
                break
            end
        end
        if fullLine then
            table.insert(linesToRemove, y)
        end
    end
    for i = #linesToRemove, 1, -1 do
        table.remove(grid, linesToRemove[i])
    end
    for _ = 1, #linesToRemove do
        local newLine = {}
        for x = 1, cols do
            newLine[x] = { value = 0, color = { 0, 0, 0 } }
        end
        table.insert(grid, 1, newLine)
    end
    score = score + 100 * #linesToRemove
end

function spawnNewPiece()
    local pieceData = pieces[love.math.random(#pieces)]
    currentPiece = { shape = pieceData.shape, color = pieceData.color }
    currentX, currentY = math.floor(cols / 2) - math.floor(#currentPiece.shape[1] / 2), 0
    if not canMove(currentPiece, currentX, currentY) then
        gameOver = true
        return false
    end
    return true
end
