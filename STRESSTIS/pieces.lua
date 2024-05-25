local pieces = {}
local sprites = {}
local pieceShapes = {
    {
        shape = {
            { 1, 1, 1, 1 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
        },
        sprite = "I",
    },
    {
        shape = {
            { 1, 1, 1 },
            { 0, 1, 0 },
            { 0, 0, 0 },
        },
        sprite = "T",
    },
    {
        shape = {
            { 1, 1, 0 },
            { 0, 1, 1 },
            { 0, 0, 0 },
        },
        sprite = "Z",
    },
    {
        shape = {
            { 0, 1, 1 },
            { 1, 1, 0 },
            { 0, 0, 0 },
        },
        sprite = "S",
    },
    {
        shape = {
            { 1, 1 },
            { 1, 1 },
        },
        sprite = "O",
    },
    {
        shape = {
            { 1, 1, 1 },
            { 1, 0, 0 },
            { 0, 0, 0 },
        },
        sprite = "L",
    },
    {
        shape = {
            { 1, 1, 1 },
            { 0, 0, 1 },
            { 0, 0, 0 },
        },
        sprite = "J",
    },
}

function pieces.loadSprites()
    sprites["I"] = love.graphics.newImage("STRESSTIS/SPRITES/I-piece.png")
    sprites["J"] = love.graphics.newImage("STRESSTIS/SPRITES/J-piece.png")
    sprites["L"] = love.graphics.newImage("STRESSTIS/SPRITES/L-piece.png")
    sprites["O"] = love.graphics.newImage("STRESSTIS/SPRITES/O-piece.png")
    sprites["S"] = love.graphics.newImage("STRESSTIS/SPRITES/S-piece.png")
    sprites["T"] = love.graphics.newImage("STRESSTIS/SPRITES/T-piece.png")
    sprites["Z"] = love.graphics.newImage("STRESSTIS/SPRITES/Z-piece.png")
end

-- Esta função pode inicializar qualquer configuração específica de peça, se necessário
function pieces.initialize()
end

-- Esta função retorna uma peça aleatória
function pieces.getRandomPiece()
    local index = love.math.random(#pieceShapes)
    local pieceData = pieceShapes[index]
    return { shape = pieceData.shape, sprite = sprites[pieceData.sprite], type = pieceData.sprite }
end

-- Esta função rotaciona uma peça sentido horário
function pieces.rotateClockwise(piece)
    local newShape = {}
    local pieceSize = #piece.shape
    for y = 1, pieceSize do
        newShape[y] = {}
        for x = 1, pieceSize do
            newShape[y][x] = piece.shape[pieceSize - x + 1][y]
        end
    end
    return { shape = newShape, sprite = piece.sprite, type = piece.type }
end

-- Esta função rotaciona uma peça sentido anti-horário
function pieces.rotateCounterClockwise(piece)
    local newShape = {}
    local pieceSize = #piece.shape
    for y = 1, pieceSize do
        newShape[y] = {}
        for x = 1, pieceSize do
            newShape[y][x] = piece.shape[x][pieceSize - y + 1]
        end
    end
    return { shape = newShape, sprite = piece.sprite, type = piece.type }
end

-- Esta função desenha uma peça na tela
function pieces.draw(piece, x, y)
    local sprite = piece.sprite
    local gridOffsetX = (1280 - (10 * 30)) / 2
    local gridOffsetY = (720 - (20 * 30)) / 2
    for py = 1, #piece.shape do
        for px = 1, #piece.shape[py] do
            if piece.shape[py][px] == 1 then
                love.graphics.draw(sprite, gridOffsetX + (x + px - 2) * 30, gridOffsetY + (y + py - 2) * 30)
            end
        end
    end
end

return pieces
