-- game.lua
local game = {}
local pieces = require("STRESSTIS.pieces")
local grid = require("STRESSTIS.grid")
local ui = require("STRESSTIS.ui")
local dropTimer = 0
local dropInterval = 0.5
local moveTimer = 0
local moveInterval = 0.1
local gameOver = false
local score = 0
local blurShader = require("STRESSTIS.EFFECTS.blurShader")

-- Esta função carrega o jogo
function game.load()
    grid.initialize(20, 10, 30) -- Inicializa a grade
    pieces.initialize()         -- Inicializa as peças
    pieces.loadSprites()        -- Carrega os sprites
    game.spawnNewPiece()        -- Gera uma nova peça
end

-- Esta função desenha o jogo na tela
function game.draw()
    grid.draw()                                       -- Desenha a grade
    if currentPiece then                              -- Desenha a peça atual
        pieces.draw(currentPiece, currentX, currentY)
    end
    ui.draw(score, gameOver)                          -- Desenha a interface do usuário
end                                                   

-- Reseta todas as variáveis para recomeçar o jogo
function game.restart()
    dropTimer = 0
    dropInterval = 0.5
    moveTimer = 0
    moveInterval = 0.1
    gameOver = false
    score = 0
    grid.initialize(20, 10, 30)
    game.spawnNewPiece()
end

-- Esta função atualiza o estado do jogo
function game.update(dt)
    if gameOver then return end -- Se o jogo acabou, não faz nada
    dropTimer = dropTimer + dt
    moveTimer = moveTimer + dt
    local interval = love.keyboard.isDown("s") and dropInterval / 10 or dropInterval
    if dropTimer >= interval then
        dropTimer = 0
        if game.canMove(currentPiece, currentX, currentY + 1) then
            currentY = currentY + 1
        else
            game.placePiece()                -- Coloca a peça atual na grade
            game.clearLines()                -- Limpa as linhas completas
            if not game.spawnNewPiece() then -- Gera uma nova peça
                gameOver = true              -- Se não puder mover a nova peça, o jogo acaba
            end
        end
    end
    if moveTimer >= moveInterval then
        moveTimer = 0
        if love.keyboard.isDown("a") and game.canMove(currentPiece, currentX - 1, currentY) then
            currentX = currentX - 1
        elseif love.keyboard.isDown("d") and game.canMove(currentPiece, currentX + 1, currentY) then
            currentX = currentX + 1
        end
    end
end

-- Esta função é chamada quando uma tecla é pressionada
function game.keypressed(key)
    if key == "tab" then
        game.restart() -- Se a tecla Tab é pressionada, reinicia o jogo
        return
    end
    if gameOver then
        if key == "r" then
            love.event.quit("restart") -- Se o jogo acabou e a tecla R é pressionada, reinicia o jogo
        end
        return
    end
    if key == "right" then
        local rotatedPiece = pieces.rotateClockwise(currentPiece) -- Gira a peça atual
        if game.canMove(rotatedPiece, currentX, currentY) then
            currentPiece = rotatedPiece
        elseif game.canMove(rotatedPiece, currentX - 1, currentY) then
            currentPiece = rotatedPiece
            currentX = currentX - 1
        elseif game.canMove(rotatedPiece, currentX + 1, currentY) then
            currentPiece = rotatedPiece
            currentX = currentX + 1
        end
    elseif key == "left" then
        local rotatedPiece = pieces.rotateCounterClockwise(currentPiece) -- Gira a peça atual no sentido anti-horário
        if game.canMove(rotatedPiece, currentX, currentY) then
            currentPiece = rotatedPiece
        elseif game.canMove(rotatedPiece, currentX - 1, currentY) then
            currentPiece = rotatedPiece
            currentX = currentX - 1
        elseif game.canMove(rotatedPiece, currentX + 1, currentY) then
            currentPiece = rotatedPiece
            currentX = currentX + 1
        end
    elseif key == "w" then
        while game.canMove(currentPiece, currentX, currentY + 1) do
            currentY = currentY + 1
        end
        game.placePiece() -- Coloca a peça atual na grade
    end
end

-- Esta função verifica se uma peça pode se mover para uma nova posição
function game.canMove(piece, newX, newY)
    return grid.canMove(piece, newX, newY)
end

-- Esta função coloca uma peça na grade
function game.placePiece()
    -- Aplica o sharder de desfoque
    love.graphics.setShader(blurShader)

    -- Colcoa a peça na grade
    grid.placePiece(currentPiece, currentX, currentY)

    -- Desenha a grade e as peças
    grid.draw()
    pieces.draw(currentPiece, currentX, currentY)

    -- Desativa o shader
    love.graphics.setShader()
end

-- Esta função limpa as linhas completas da grade e atualiza a pontuação
function game.clearLines()
    local linesCleared = grid.clearLines()
    score = score + 100 * linesCleared

    -- Aumenta a velocidade a cada mil pontos
    if score % 1000 == 0 then
        dropInterval = dropInterval * 0.9 -- Reduz o intervlo de queda em 10%
    end
end

-- Esta função gera uma nova peça e a coloca na posição inicial
function game.spawnNewPiece()
    currentPiece = pieces.getRandomPiece()
    currentX, currentY = grid.getStartingPosition(currentPiece)
    if not game.canMove(currentPiece, currentX, currentY) then
        gameOver = true -- Se a nova peça não puder se mover, o jogo acaba
        return false
    end
    return true
end

return game
