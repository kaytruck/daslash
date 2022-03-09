-- init
function _init()
	init()
	_update = update_title
	_draw = draw_title
end

function init()
	-- settings
	dead_h = 130
	gravity=0.2
	-- gaming info
	time_cnt = 0
	cur_mapobj = "none"
	-- window limits
	window_l = 0
	window_r = 128
	-- title screen
	blink_col1 = 8
	blink_col2 = 14
	blink_col = blink_col1
	blink_cnt = 0
	-- stage
	stages = load_stages()
	sn = 1
	-- stage = stages[stage_n]
	init_stage()
end

function init_stage()
	-- player
	player = init_player(stages[sn].p_x, stages[sn].p_y)
	-- enemies
	enemies = init_enemies(stages[sn].enemies)
end

-- update
function update_title()
	if btnp(5) then
		_update = update_gaming
		_draw = draw_gaming
	end
	-- blink start message
	blink_cnt = blink_cnt + 1
	if blink_cnt > 7 then
		blink_cnt = 0
		if blink_col == blink_col1 then
			blink_col = blink_col2
		else
			blink_col = blink_col1
		end
	end
end

function update_gaming()
	-- life time count down
	time_cnt = time_cnt + 1
	if time_cnt % 30 == 1
	and stages[sn].life_time > 0 then
		stages[sn].life_time = stages[sn].life_time - 1
	end

	update_player(player, enemies)
	update_enemies(enemies)

	-- check finish
	if #enemies == 0
	and cur_mapobj == "door" then
		if player.hp > 0 
		and sn < #stages then
			-- goto next stage
			sn = sn + 1
			init_stage()
		else
			-- cleard
			_update = update_gameover
			_draw = draw_gameover
		end
	elseif player.hp == 0
	or stages[sn].life_time == 0 then
		-- game over
		_update = update_gameover
		_draw = draw_gameover
	end
	
	animate_player(player)
	animate_enemies(enemies)
end

function update_gameover()
	if btnp(5) then
		init()
		_update = update_title
		_draw = draw_title
	end
end

-- draw
function draw_title()
	cls(1)
	print("daslash", 32, 8, 12)
	spr(192, 48, 25, 4, 4)
	print("dash from behind, and slash!", 8, 62, 3)
	print("press ❎ to start", 32, 82, blink_col)
	print("🅾️ hiding -- no damage", 16, 96, 6)
	print("❎ dash and slash", 16,104,6)
	print("0.1", 2, 120, 13)
	print("by kaytruck", 82, 120, 6)
	
end

function draw_gaming()
	cls(1)
	draw_map()
	-- draw info area background
	rectfill(0, 0, 127, 10, 0)
	-- draw player hp
	for i=0, player.hp - 1 do
		circfill(5 + 8 * i, 5, 2, 14)
	end
	-- draw life time
	local life_time_s = "0"..stages[sn].life_time
	print(sub(life_time_s, #life_time_s - 1), 62, 3, 15)
	-- draw hiding time bar
	local hbx = 84
	rectfill(hbx, 2, (hbx + player.hiding_cnt_max), 8, 13)
	local hiding_bar_col = 7
	if player.hiding_cnt == 0 then
		hiding_bar_col = 12
	end
	if player.hiding_limit then
		hiding_bar_col = 2
	end
	rectfill(hbx, 2, (hbx + player.hiding_cnt_max - player.hiding_cnt), 8, hiding_bar_col)

	-- draw player if hiding
	if player.hiding then
		draw_player(player)
	end
	-- draw enemies
	draw_enemies(enemies)
	-- draw player not hiding
	if not player.hiding then
		draw_player(player)
	end
	
	-- debug print
	-- print("player.vx:"..player.vx, 3)
	-- print("player.dy:"..player.dy, 3)
	-- print("player.x:"..player.x, 3)
	-- print("player.y:"..player.y, 3)
	-- print("player.chk_ladder:"..player.chk_ladder, 3)
	-- print("player.hiding_cnt:"..player.hiding_cnt, 3)
	-- print("player.hiding:"..(player.hiding and "true" or "false"), 3)
	-- print("player.hiding_limit:"..(player.hiding_limit and "true" or "false"), 3)
	-- print("cur_mapobj:"..cur_mapobj, 0, 10, 3)
	-- print("#enemies:"..#enemies, 0, 18, 3)
end

function draw_gameover()
	cls(1)
	local msg = "cleard"
	if player.hp == 0 then
		msg = "you died"
	end
	print(msg, 32, 32, 6)
	print("press ❎ to title", 32, 48, 6)
end

function draw_map()
	map(stages[sn].m_x, stages[sn].m_y, 0, 0, stages[sn].m_w, stages[sn].m_w)
end
