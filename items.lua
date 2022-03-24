function init_item(map_func)
    map_func["hpmaxup"] = item_hpmaxup
    map_func["hpup"] = item_hpup
end

function item_hpmaxup(player, stage)
    if player.hpmax < player.hplimit then
        player.hpmax = player.hpmax + 1
        local x = player.x + player.w / 2
        local y = player.y + player.h / 2
        mset(x/8 + stage.m_x, y/8 + stage.m_y, 0)
    end
    if player.hp < player.hpmax then
        player.hp = player.hpmax
        local x = player.x + player.w / 2
        local y = player.y + player.h / 2
        mset(x/8 + stage.m_x, y/8 + stage.m_y, 0)
    end
end

function item_hpup(player, stage)
    if player.hp < player.hpmax then
        player.hp = player.hp + 1
        local x = player.x + player.w / 2
        local y = player.y + player.h / 2
        mset(x/8 + stage.m_x, y/8 + stage.m_y, 0)
    end
end