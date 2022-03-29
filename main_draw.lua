-- draw
function draw_title()
	cls(1)
	print("daslash", 32, 8, 12)
	spr(192, 48, 25, 4, 4)
	print("dash from behind, and slash!", 8, 62, 3)
	print("press ❎ to start", 32, 82, blink_col)
	print("🅾️ hiding - no damage", 16, 96, 6)
	print("❎ dash and slash", 16,104,6)
	print("0.1", 2, 120, 13)
	print("by kaytruck", 82, 120, 6)
end

function draw_gaming()
	cls(1)
	draw_map()
	-- draw info area background
	rectfill(0, 0, 127, 10, 0)
	-- TODO draw stage num
	-- print(""..sn.."/"..#stages, 2, 3, 9)
	-- draw player hp
	for i=0, player.hpmax - 1 do
		spr(49, 25 + 8 * i, 3)
	end
	for i=0, player.hp - 1 do
		spr(50, 25 + 8 * i, 3)
	end
	-- draw life time
	local life_time_c = 15
	if life_time / stage.life_time < 0.2 then
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
		player:draw()
	end
	-- draw enemies
	draw_enemies(enemies)
	-- draw player not hiding
	if not player.hiding then
		player:draw()
	end
	
	-- draw explosion
	for pnts in all(explode_pnts) do
		spr(18, pnts.x, pnts.y)
		pnts.explode_time = pnts.explode_time - 1
		if pnts.explode_time == 0 then
			del(explode_pnts, pnts)
		end
	end

	-- stop shake
	camera()

	-- debug print
	debug_print()
end

function draw_gameover()
	if shake_intensity > 0 then
		draw_gaming()
	else
		cls(1)
		local msg = "you died"
		if stage.next == nil
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
	map(stage.m_x, stage.m_y, 0, 0, stage.m_w, stage.m_w)
end

function debug_print()
	if debug then
		print("debug mode", 0, 12, 3)
	end
	-- print("player.vx:"..player.vx, 3)
	-- print("player.vy:"..player.vy, 3)
	-- print("player.x:"..player.x, 0, 18, 3)
	-- print("player.y:"..player.y, 0, 25, 3)
	-- print("player.chk_ladder:"..player.chk_ladder, 3)
	-- print("player.hiding_cnt:"..player.hiding_cnt, 3)
	-- print("player.hiding:"..(player.hiding and "true" or "false"), 3)
	-- print("player.hiding_limit:"..(player.hiding_limit and "true" or "false"), 3)
	-- print("cur_mapobj:"..cur_mapobj, 0, 18, 3)
	-- print("#enemies:"..#enemies, 0, 18, 3)
	-- print("enemies[1].downt:"..enemies[1].downt, 0, 18, 3)
	-- print("stages[sn].life_time:"..s	tages[sn].life_time, 0, 18, 3)
	-- print("shake_intensity:"..shake_intensity, 0, 18, 3)
	-- print("enemies[1].shot_max"..enemies[1].shot_max, 0, 18, 3)
	-- print("debug:"..(debug and "true" or "false"), 0, 18, 3)
end