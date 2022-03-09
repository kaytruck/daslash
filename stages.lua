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
        {
            create=create_enemey_1,
            sp=64,
            sp_end=65,
            x=8*8,
            y=2*8,
            vx=0.5,
            hp=6,
        },
        {
            create=create_enemey_1,
            sp=80,
            sp_end=81,
            x=9*8,
            y=12*8,
            vx=-0.7,
            hp=3,
        },
    },
}

stage2 = {
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
        {
            create=create_enemey_1,
            sp=64,
            sp_end=65,
            x=8*8,
            y=2*8,
            vx=0.5,
            hp=6,
        },
        {
            create=create_enemey_1,
            sp=80,
            sp_end=81,
            x=9*8,
            y=12*8,
            vx=-0.7,
            hp=3,
        },
    },
}
