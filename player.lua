function init_player()
	return {
		sp=1,				-- sprite
		spw=1,				-- sprite width
		w=8,
		h=8,
		x=40,
		y=30,
		vx=0,
		dy=0,
		max_vx=2,
		max_dy=3,
		max_dy_ladder=1,
		acc_walk=0.8,
		acc_dash=2,
		acc_jump=3,
		fric=0.5,
		dash_time=0,
		dash_time_max = 6,
		hiding_cnt = 0,
		hiding_cnt_max = 30,
		atk=3,
		hp=3,					-- hp
		life_time = 30,			-- sec.
		-- stat
		running=false,
		falling=false,
		landing=false,
		underatk=false,			-- under attack flg
		chk_ladder="none",
		flip=false,
		hiding=false,
		hiding_limit=false,
		ladder="none",
		-- anim
		anim=0,
	}
end

function update_player(p, enemies)
	-- physics (friction and gravity)
    p.vx = p.vx * p.fric
	if p.dash_time > 0 then
        p.dash_time = p.dash_time - 1
	else
        p.dy = p.dy + gravity
	end
	-- running animation
	if abs(p.vx) < 0.5 then
		p.running = false
	end	
	-- on ladder ?
	p.ladder = "none"

	-- control
	if btn(4) then
		p.hiding = true
	else
		p.hiding = false
		if btn(0) then
			p.flip = true
			p.running = true
            p.vx = p.vx - p.acc_walk
		end
		if btn(1) then
			p.flip = false
			p.running = true
            p.vx = p.vx + p.acc_walk
		end
		if btn(2) then
			p.ladder = "up"
		end
		if btn(3) then
			p.ladder = "down"
		end
		if btnp(5)
		and p.dash_time == 0 then
			p.dash_time = p.dash_time_max
		end
	end

	-- hide
	hiding(p)

	-- dash
	if p.dash_time > 0 then
		if p.flip then
            p.vx = p.vx - p.acc_dash
		else
            p.vx = p.vx + p.acc_dash
		end
	elseif abs(p.vx) > p.max_vx then
		-- limit speed x-axis
		if p.vx > 0 then
			p.vx = p.max_vx
		else
			p.vx = -p.max_vx
		end
	end

	-- limit speed y-axis
	p.dy = mid(-p.max_dy, p.dy, p.max_dy)

	-- falling
	if p.dy > 0 and p.chk_ladder == "none" then
		p.falling = true
		p.landing = false
	end

	-- collide ground
	for offset = 1, flr(p.dy + 0.9) do
		local collide = collide_ground(p, offset)
		if collide then
			p.falling = false
			p.landing = true
			if p.dy > 0 then
				p.dy = 0
			end
			break
		end
	end
	-- ladder
	p.chk_ladder = chk_ladder(p)
	if p.chk_ladder == "on" then
		if p.ladder == "down" then
			p.dy = 1
		end
	elseif p.chk_ladder == "in" then
		if p.ladder == "up" then
			p.dy = -1
		end
		if p.ladder == "down" then
			p.dy = 1
		end
	elseif p.chk_ladder == "bottom" then
		if p.ladder == "up" then
			p.dy = -1
		end
	end

	-- collide wall
	if p.vx > 0
	and collide_wall(p, "right") then
		p.vx = 0
        p.x = p.x - (p.x + p.w) % 8
	elseif p.vx < 0
	and collide_wall(p, "left") then
		p.vx = 0
	end

	-- collide enemies
	engage(p, enemies)

	-- apply move
    p.x = p.x + p.vx
    p.y = p.y + p.dy
	p.y = flr(p.y + 0.9)

	-- player die
	if p.y > dead_h 
	or p.hp <= 0 
	or p.life_time <= 0 then
		_update = update_gameover
		_draw = draw_gameover
	end
	-- limit player to window
	if p.x < window_l then
		p.x = window_l
	elseif p.x > window_r - p.w then
		p.x = window_r - p.w
	end
end

function hiding(p)
	if p.hiding then
		if p.hiding_cnt < p.hiding_cnt_max then
			p.hiding_cnt = p.hiding_cnt + 0.5
		elseif p.hiding_cnt == p.hiding_cnt_max then
			p.hiding_limit = true
		end
	else
		if p.hiding_cnt > 0 then
			p.hiding_cnt = p.hiding_cnt - 0.5
		elseif p.hiding_cnt == 0 then
			p.hiding_limit = false
		end
	end
	if p.hiding
	and p.hiding_limit then
		p.hiding = false
	end
end

function engage(p, enemies)
	local deads = {}
	for enemy in all(enemies) do
		-- if not collide on y
		if not (max(p.y, enemy.y) <= min(p.y + p.h - 1, enemy.y + enemy.h - 1))
		and not (min(p.y + p.h - 1, enemy.y + enemy.h - 1) >= max(p.y, enemy.y)) then
			goto nextenemy
		end
		-- if not collide on x
		-- TODO should compare to center and center ?
		if not (max(p.x, enemy.x) <= min(p.x + p.w - 1, enemy.x + enemy.w - 1))
		and not (min(p.x + p.w - 1, enemy.x + enemy.w - 1) >= max(p.x, enemy.x)) then
			p.underatk = false
			enemy.underatk = false
			goto nextenemy
		end
		-- if dashing
		if p.dash_time > 0 then
			--  if same direction
			if p.flip == enemy.flip
			and not enemy.underatk then
				-- if dash through
					-- if min(p.x, p.x + p.vx) < enemy.x
					-- and max(p.x, p.x + p.vx) > enemy.x then
					-- 	enemy.hp -= p.atk
					-- end
                enemy.hp = enemy.hp - p.atk
				enemy.underatk = true
			end
		else
			-- player damage
			if not p.hiding
			and not p.underatk then
                p.hp = p.hp - 1
				p.underatk = true
			end
		end
		if enemy.hp <= 0 then
			add(deads, enemy)
		end
		::nextenemy::
	end
	for dead in all(deads) do
		del(enemies, dead)
	end
end

function animate_player(player)
	player.spw = 1
	if player.hiding then
		player.sp = 17
	elseif player.dash_time > 0 then
		player.sp = 33
		player.spw = 2
	elseif player.falling then
		player.sp = 7
	elseif player.running then
		if time() - player.anim > 0.1 then
			player.anim = time()
			-- player.sp += 1
            player.sp = player.sp + 1
			if player.sp > 6 then
				player.sp = 2
			end
		end
	elseif (player.chk_ladder == "in"
	or player.chk_ladder == "bottom")
	and player.dy ~= 0 then
		if time() - player.anim > 0.1 then
			player.anim = time()
			if player.sp == 8 then
				player.sp = 9
			else
				player.sp = 8
			end
		end
	else
		player.sp = 1
	end
end

function draw_player(player)
	spr(player.sp, player.x, player.y, player.spw, 1, player.flip)
end

