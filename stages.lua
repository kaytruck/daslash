function load_stages()
    local stages = {stage1, stage2}
    return stages
end

stage1 = {
    -- player
    p_x = 40,
    p_y = 30,
    life_time = 60,			-- sec.
    -- map
    m_x = 0,
    m_y = 0,
    m_w = 16,
    m_h = 16,
    -- enemies
    enemies = {
        create_enemey_yellow(8*8, 2*8, 0.5),
        create_enemey_dog(9*8, 12*8, -0.7),
    },
}

stage2 = {
    -- player
    p_x = 3 * 8,
    p_y = 3 * 8,
    life_time = 60,			-- sec.
    -- map
    m_x = 16,
    m_y = 0,
    m_w = 16,
    m_h = 16,
    -- enemies
    enemies = {
        create_enemey_yellow((24 - 16)*8, 3*8, 0.5),
        create_enemey_yellow((27 - 16)*8, 10*8, 0.5),
        create_enemey_dog((20 - 16)*8, 7*8, -0.7),
    },
}
