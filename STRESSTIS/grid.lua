-- grid.lua
local grid = {}
local rows, cols, blockSize
local gridData = {}

-- Esta função inicializa a grade com as linhas, colunas e tamanho do bloco especificados
function grid.initialize(r, c, bs)
    rows, cols, blockSize = r, c, bs
    for y = 1, rows do
        gridData[y] = {}
        for x = 1, cols do
            gridData[y][x] = { value = 0, color = { 0, 0, 0 } }
        end
    end
end

-- Esta função desenha a grade na tela
function grid.draw()
    local gridOffsetX = (1280 - (cols * blockSize)) / 2
    local gridOffsetY = (720 - (rows * blockSize)) / 2
    for y = 1, rows do
        for x = 1, cols do
            if gridData[y][x].value == 0 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("line", gridOffsetX + (x - 1) * blockSize, gridOffsetY + (y - 1) * blockSize,
                    blockSize, blockSize)
            else
                love.graphics.setColor(gridData[y][x].color)
                love.graphics.rectangle("fill", gridOffsetX + (x - 1) * blockSize, gridOffsetY + (y - 1) * blockSize,
                    blockSize, blockSize)
            end
        end
    end
end

-- Esta função verifica se uma peça pode ser movida para uma nova posição
function grid.canMove(piece, newX, newY)
    for y = 1, #piece.shape do
        for x = 1, #piece.shape[y] do
            if piece.shape[y][x] == 1 then
                local targetX = newX + x - 1
                local targetY = newY + y - 1
                if targetX < 1 or targetX > cols or targetY > rows or (targetY > 0 and gridData[targetY][targetX].value ~= 0) then
                    return false
                end
            end
        end
    end
    return true
end

-- Esta função coloca uma peça na grade
function grid.placePiece(piece, x, y)
    for py = 1, #piece.shape do
        for px = 1, #piece.shape[py] do
            if piece.shape[py][px] == 1 then
                local gridY = y + py - 1
                local gridX = x + px - 1
                if gridY > 0 then
                    gridData[gridY][gridX] = { value = 1, color = piece.color }
                end
            end
        end
    end
end

-- Esta função limpa as linhas completas da grade
function grid.clearLines()
    local linesToRemove = {}
    for y = 1, rows do
        local fullLine = true
        for x = 1, cols do
            if gridData[y][x].value == 0 then
                fullLine = false
                break
            end
        end
        if fullLine then
            table.insert(linesToRemove, y)
        end
    end
    for i = #linesToRemove, 1, -1 do
        table.remove(gridData, linesToRemove[i])
    end
    for _ = 1, #linesToRemove do
        local newLine = {}
        for x = 1, cols do
            newLine[x] = { value = 0, color = { 0, 0, 0 } }
        end
        table.insert(gridData, 1, newLine)
    end
    return #linesToRemove
end

-- Esta função retorna a posição inicial para uma peça
function grid.getStartingPosition(piece)
    return math.floor(cols / 2) - math.floor(#piece.shape[1] / 2), 0
end

return grid
