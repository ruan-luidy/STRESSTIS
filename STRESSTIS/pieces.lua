-- pieces.lua
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
        color = { 0, 1, 1 }, -- I-piece (Ciano)
    },
    {
        shape = {
            { 1, 1, 1 },
            { 0, 1, 0 },
            { 0, 0, 0 },
        },
        color = { 1, 0, 1 }, -- T-piece (Roxo)
    },
    {
        shape = {
            { 1, 1, 0 },
            { 0, 1, 1 },
            { 0, 0, 0 },
        },
        color = { 1, 0, 0 }, -- Z-piece (Vermelho)
    },
    {
        shape = {
            { 0, 1, 1 },
            { 1, 1, 0 },
            { 0, 0, 0 },
        },
        color = { 0, 1, 0 }, -- S-piece (Verde)
    },
    {
        shape = {
            { 1, 1 },
            { 1, 1 },
        },
        color = { 1, 1, 0 }, -- O-piece (Amarelo)
    },
    {
        shape = {
            { 1, 1, 1 },
            { 1, 0, 0 },
            { 0, 0, 0 },
        },
        color = { 1, 0.5, 0 }, -- L-piece (Laranja)
    },
    {
        shape = {
            { 1, 1, 1 },
            { 0, 0, 1 },
            { 0, 0, 0 },
        },
        color = { 0, 0, 1 }, -- J-piece (Azul)
    },
}

function pieces.loadSprites()
    sprites["I"] = love.graphics.newImage("")
    sprites["J"] = love.graphics.newImage("")
    sprites["L"] = love.graphics.newImage("")
    sprites["O"] = love.graphics.newImage("")
    sprites["S"] = love.graphics.newImage("")
    sprites["T"] = love.graphics.newImage("")
    sprites["Z"] = love.graphics.newImage("")
end

local iPieceOffsets = {
    [0] = { { 0, 0 }, { -1, 0 }, { 2, 0 }, { -1, 0 }, { 2, 0 } },
    [1] = { { -1, 0 }, { 0, 0 }, { 0, 0 }, { 0, 1 }, { 0, -2 } },
    [2] = { { -1, -1 }, { 1, -1 }, { -2, -1 }, { 1, 0 }, { -2, 0 } },
    [3] = { { 0, -1 }, { 0, -1 }, { 0, -1 }, { 0, -1 }, { 0, -1 } }
}

local jlstzPieceOffsets = {
    [0] = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } },
    [1] = { { 0, 0 }, { 1, 0 }, { 1, -1 }, { 0, 2 }, { 1, 2 } },
    [2] = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } },
    [3] = { { 0, 0 }, { -1, 0 }, { -1, -1 }, { 0, 2 }, { -1, 2 } }
}

local oPieceOffsets = {
    [0] = { { 0, 0 } },
    [1] = { { 0, -1 } },
    [2] = { { -1, -1 } },
    [3] = { { -1, 0 } }
}

function pieces.srsRotate(piece, direction)
    local newPiece = pieces.rotateClockwise(piece) -- ou pieces.rotateCounterClockwise(piece) dependendo da direção
    local offsets
    if piece.shape == 'I' then
        offsets = iPieceOffsets
    elseif piece.shape == 'O' then
        offsets = oPieceOffsets
    else
        offsets = jlstzPieceOffsets
    end
    for _, offset in ipairs(offsets) do
        local testX = currentX + offset[1]
        local testY = currentY + offset[2]
        if grid.canPlacePiece(newPiece, testX, testY) then
            currentX = testX
            currentY = testY
            return newPiece
        end
    end
    return piece -- se a peça não puder ser rotacionada, retorne a peça original
end

-- Esta função pode inicializar qualquer configuração específica de peça, se necessário
function pieces.initialize()
end

-- Esta função retorna uma peça aleatória
function pieces.getRandomPiece()
    local pieceData = pieceShapes[love.math.random(#pieceShapes)]
    return { shape = pieceData.shape, color = pieceData.color }
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
    return { shape = newShape, color = piece.color }
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
    return { shape = newShape, color = piece.color }
end

-- Esta função desenha uma peça na tela
function pieces.draw(piece, x, y)
    local sprite = sprites[piece.type] -- Obtém o sprite da peça
    local gridOffsetX = (1280 - (10 * 30)) / 2
    local gridOffsetY = (720 - (20 * 30)) / 2
    for py = 1, #piece.shape do
        for px = 1, #piece.shape[py] do
            if piece.shape[py][px] == 1 then
                -- Desenha o sprite em vez do retângulo
                love.graphics.draw(sprite, gridOffsetX + (x + px - 2) * 30, gridOffsetY + (y + py - 2) * 30)
            end
        end
    end
end

return pieces
