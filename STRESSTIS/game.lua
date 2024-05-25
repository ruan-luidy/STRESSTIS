local grid = require "STRESSTIS/grid"
local pieces = require "STRESSTIS/pieces"
local ui = require "STRESSTIS/ui"

local game = {}
local currentPiece
local currentX, currentY
local nextPiece
local score
local gameOver

-- Função de inicialização do jogo
function game.initialize()
    grid.initialize(20, 10, 30)
    pieces.loadSprites()
    currentPiece = pieces.getRandomPiece()
    currentX, currentY = grid.getStartingPosition(currentPiece)
    nextPiece = pieces.getRandomPiece()
    score = 0
    gameOver = false
end

-- Alias para a função de inicialização para manter a compatibilidade com o main.lua
game.load = game.initialize

-- Função de atualização do jogo
function game.update(dt)
    if not gameOver then
        -- Atualizações de lógica do jogo aqui
    end
end

-- Função de desenho do jogo
function game.draw()
    grid.draw()
    pieces.draw(currentPiece, currentX, currentY)
    ui.draw(score, gameOver)
end

-- Função de tratamento de teclas pressionadas
function game.keypressed(key)
    if key == "left" then
        if grid.canMove(currentPiece, currentX - 1, currentY) then
            currentX = currentX - 1
        end
    elseif key == "right" then
        if grid.canMove(currentPiece, currentX + 1, currentY) then
            currentX = currentX + 1
        end
    elseif key == "down" then
        if grid.canMove(currentPiece, currentX, currentY + 1) then
            currentY = currentY + 1
        end
    elseif key == "up" then
        local newPiece = pieces.rotateClockwise(currentPiece)
        if grid.canMove(newPiece, currentX, currentY) then
            currentPiece = newPiece
        end
    elseif key == "space" then
        while grid.canMove(currentPiece, currentX, currentY + 1) do
            currentY = currentY + 1
        end
        game.placePiece()
    elseif key == "r" then
        game.initialize()
    end
end

-- Função para colocar a peça na grade
function game.placePiece()
    grid.placePiece(currentPiece, currentX, currentY)
    local clearedLines = grid.clearLines()
    score = score + clearedLines * 100
    if not grid.canMove(nextPiece, grid.getStartingPosition(nextPiece)) then
        gameOver = true
    else
        currentPiece = nextPiece
        currentX, currentY = grid.getStartingPosition(currentPiece)
        nextPiece = pieces.getRandomPiece()
    end
end

return game
