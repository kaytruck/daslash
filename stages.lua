function init_stages()
    stages = {stage1}
    return load_stage(1)
end

function load_stage(stage)
    return stages[stage]
end

stage1 = {
    -- player
    p_x = 40,
    p_y = 30,
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