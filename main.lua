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
	cur_mapobj = "none"
	time_cnt = 0
	score = 0
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
	-- stage
	stages = load_stages()
	sn = 1
	init_stage()
end

function init_stage()
	-- player
	player = init_player(stages[sn].p_x, stages[sn].p_y)
	-- enemies
	enemies = init_enemies(stages[sn].enemies)
	-- life time
	life_time = stages[sn].life_time
end

-- update
function update_title()
	if btnp(5) then
		_update = update_gaming
		_draw = draw_gaming
	end
	-- blink start message
	blink()
end

function update_gaming()
	-- life time count down
	time_cnt = time_cnt + 1
	if time_cnt % 30 == 1
	and life_time > 0 then
		life_time = life_time - 1
	end

	update_player(player, enemies)
	update_enemies(enemies)

	-- check stage finish
	if #enemies == 0
	and cur_mapobj == "door" then
		if player.hp > 0 
		and sn < #stages then
			-- goto next stage
			score = score + life_time
			sn = sn + 1
			init_stage()
		else
			-- cleard
			_update = update_gameover
			_draw = draw_gameover
		end
	elseif player.hp == 0
	-- or stages[sn].life_time == 0 then
	or life_time == 0 then
		-- game over
		shake_intensity = shake_intensity_max
		_update = update_gameover
		_draw = draw_gameover
	end
	
	animate_player(player)
	animate_enemies(enemies)
end

function update_gameover()
	if shake_intensity > 0 then
		shake()
	else
		-- blink start message
		blink()
		if btnp(5) then
			init()
			_update = update_title
			_draw = draw_title
		end
	end
end

function shake()
	local shake_x = rnd(shake_intensity) - (shake_intensity / 2)
	local shake_y = rnd(shake_intensity) - (shake_intensity / 2)
	camera(shake_x, shake_y)
	shake_intensity = shake_intensity * 0.9
	if shake_intensity < 0.3 then
		shake_intensity = 0
	end
end

function blink()
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

-- draw
function draw_title()
	-- camera()
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
	-- camera(stages[sn].s_x, stages[sn].s_y)
	cls(1)
	draw_map()
	-- draw info area background
	rectfill(0, 0, 127, 10, 0)
	-- draw stage num
	print(""..sn.."/"..#stages, 2, 3, 9)
	-- draw player hp
	for i=0, player.hp - 1 do
		circfill(25 + 8 * i, 5, 2, 14)
	end
	-- draw life time
	local life_time_c = 15
	if life_time / stages[sn].life_time < 0.2 then
		life_time_c = 8
	end
	local life_time_s = "0"..life_time
	print(sub(life_time_s, #life_time_s - 1), 75, 3, life_time_c)
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
	-- print("player.vy:"..player.vy, 3)
	-- print("player.x:"..player.x, 0, 18, 3)
	-- print("player.y:"..player.y, 0, 25, 3)
	-- print("player.chk_ladder:"..player.chk_ladder, 3)
	-- print("player.hiding_cnt:"..player.hiding_cnt, 3)
	-- print("player.hiding:"..(player.hiding and "true" or "false"), 3)
	-- print("player.hiding_limit:"..(player.hiding_limit and "true" or "false"), 3)
	-- print("cur_mapobj:"..cur_mapobj, 0, 10, 3)
	-- print("#enemies:"..#enemies, 0, 18, 3)
	-- print("enemies[1].downt:"..enemies[1].downt, 0, 18, 3)
	-- print("stages[sn].life_time:"..s	tages[sn].life_time, 0, 18, 3)
	-- print("shake_intensity:"..shake_intensity, 0, 18, 3)
end

function draw_gameover()
	if shake_intensity > 0 then
		draw_gaming()
	else
		cls(1)
		local msg = "you died"
		if #stages == sn
		and player.hp > 0 then
			msg = "cleard"
		end
		print(msg, 32, 32, 14)
		print("score:"..score, 32, 48, 6)
		print("press ❎ to title", 32, 64, blink_col)
	end
	camera()
end

function draw_map()
	map(stages[sn].m_x, stages[sn].m_y, 0, 0, stages[sn].m_w, stages[sn].m_w)
end
