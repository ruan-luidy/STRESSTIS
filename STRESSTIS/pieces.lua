-- pieces.lua
local pieces = {}
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
    love.graphics.setColor(piece.color)
    local gridOffsetX = (1280 - (10 * 30)) / 2
    local gridOffsetY = (720 - (20 * 30)) / 2
    for py = 1, #piece.shape do
        for px = 1, #piece.shape[py] do
            if piece.shape[py][px] == 1 then
                love.graphics.rectangle("fill", gridOffsetX + (x + px - 2) * 30, gridOffsetY + (y + py - 2) * 30, 30, 30)
            end
        end
    end
end

return pieces
