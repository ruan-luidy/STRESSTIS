-- Efeito de desfoque
blurShader = love.graphics.newShader [[
    extern number radius;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
        vec4 pixel = Texel(texture, texture_coords);
        number total = 0.0;
        vec4 sum = vec4(0.0);
        number radius = 30.0;
        for (number x = -radius; x <= radius; x++) {
            for (number y = -radius; y <= radius; y++) {
                vec2 size = vec2(x, y);
                number weight = exp(-(x*x + y*y) / (2.0*radius*radius)) / (2.0*3.14159*radius*radius);
                sum += Texel(texture, texture_coords + size) * weight;
                total += weight;
            }
        }
        return sum / total;
    }
]]

