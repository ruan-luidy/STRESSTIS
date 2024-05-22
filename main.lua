--main.lua
local game = require("game")

-- Esta função é chamada uma vez quando o jogo é carregado
function love.load()
    game.load() -- Carrega o jogo
end

-- Esta função é chamada a cada quadro para desenhar na tela
function love.draw()
    game.draw() -- Desenha o jogo
end

-- Esta função é chamada a cada quadro para atualizar o estado do jogo
-- dt é o tempo decorrido desde o último quadro
function love.update(dt)
    game.update(dt) -- Atualiza o jogo
end

-- Esta função é chamada quando uma tecla é pressionada
-- key é a tecla que foi pressionada
function love.keypressed(key)
    game.keypressed(key) -- Processa a tecla pressionada
end
