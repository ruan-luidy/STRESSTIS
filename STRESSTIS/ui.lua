-- ui.lua
local ui = {}

-- Esta função desenha a interface do usuário na tela
-- Ela exibe a pontuação atual e, se o jogo acabou, uma mensagem de "game over"
function ui.draw(score, gameOver)
    -- Define a cor do texto para branco
    love.graphics.setColor(1, 1, 1)
    -- Desenha a pontuação atual na tela
    love.graphics.print(score, 20, 20)
    -- Se o jogo acabou, desenha uma mensagem de "game over"
    if gameOver then
        -- Define a cor do texto para vermelho
        love.graphics.setColor(1, 0, 0)
        -- Desenha a mensagem de "game over" no centro da tela
        love.graphics.printf("PERDEU! APERTE 'R' PRA RECOMECA", 0, 720 / 2 - 10, 1280, "center")
    end
end

return ui
