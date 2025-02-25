-- update
function update_title()
	if btnp(5) then
		stage = init_stage(create_stage_1())
		_update = update_gaming
		_draw = draw_gaming
	elseif btnp(4) then
		debugmode = true
		stage = init_stage(create_stage_1())
		_update = update_gaming
		_draw = draw_gaming
	end
	-- blink start message
	blink()
end

function update_gaming()
	-- life time count down
	time_cnt = time_cnt + 1
	if not debugmode
	and time_cnt % 30 == 1
	and life_time > 0 then
		life_time = life_time - 1
	end

	-- update player
	player:update(enemies)
	-- update enemies
	update_enemies(enemies)

	-- check stage finish
	if #enemies == 0
	and cur_mapobj == "door" then
		score = score + life_time
		if player.hp > 0 
		and stage.next ~= nil then
			-- goto next stage
			stage = init_stage(stage.next())
		else
			-- cleard
			_update = update_gameover
			_draw = draw_gameover
		end
	-- hp = 0 or timeout
	elseif player.hp == 0
	or life_time == 0 then
		-- game over
		shake_intensity = shake_intensity_gameover
		_update = update_gameover
		_draw = draw_gameover
	elseif cur_mapobj == "door" 
	and debugmode then
		if stage.next ~= nil then
			-- goto next stage
			stage = init_stage(stage.next())
		else
			-- cleard
			_update = update_gameover
			_draw = draw_gameover
		end
	end
	
	player:animate()
	animate_enemies(enemies)

	if shake_intensity > 0 then
		shake()
	end
end

function update_gameover()
	if shake_intensity > 0 then
		shake()
	else
		-- blink start message
		blink()
		if btnp(5) then
			init_game()
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

