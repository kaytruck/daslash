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
	debug = false
	-- gaming info
	cur_mapobj = "none"
	time_cnt = 0
	score = 0
	map_func = {}
	explode_pnts = {}
	-- shots = {}
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
	shake_intensity_gameover = 6
	shake_intensity_hit = 1
	-- player
	player = create_player()
	-- stage
	stage = init_stage(create_stage_1())
	-- items
	init_item(map_func)

	-- music begin
	music(0)
end

function init_stage(stage)
	-- player
	player.x = stage.p_x
	player.y = stage.p_y
	-- enemies
	enemies = stage.enemies
	-- life time
	life_time = stage.life_time

	return stage
end

