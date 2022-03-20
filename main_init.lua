-- init
function _init()
	init_game()
	_update = update_title
	_draw = draw_title
end

function init_game()
	-- settings
	dead_h = 130
	gravity=0.2
	explode_time = 4
	-- gaming info
	cur_mapobj = "none"
	time_cnt = 0
	score = 0
	map_func = {}
	explode_pnts = {}
	-- window limits
	window_l = 0
	window_r = 128
	-- title screen
	blink_col1 = 8
	blink_col2 = 14
	blink_col = blink_col1
	blink_cnt = 0
	-- gameover screen
	shake_intensity = 0
	shake_intensity_max = 6
	-- player
	player = create_player()
	-- stage
	stages = load_stages()
	sn = 1	-- stange number
	init_stage()
	-- items
	init_item()
end

function init_stage()
	-- player
	player.x = stages[sn].p_x
	player.y = stages[sn].p_y
	-- enemies
	-- enemies = init_enemies(stages[sn].enemies)
	enemies = stages[sn].enemies
	-- life time
	life_time = stages[sn].life_time
end

