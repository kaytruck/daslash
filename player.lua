function create_player()
	return {
		sp=1,				-- sprite
		spw=1,				-- sprite width
		w=8,
		h=8,
		x=0,
		y=0,
		vx=0,
		vy=0,
		max_vx=2,
		max_vy=3,
		max_vy_ladder=1,
		acc_walk=0.8,
		acc_dash=2,
		acc_jump=3,
		fric=0.5,
		dash_time=0,
		dash_time_max = 6,
		cool_time = 0,
		cool_time_max = 4,
		hiding_cnt = 0,
		hiding_cnt_max = 30,
		atk=3,
		-- hp
		hplimit=6,
		hpmax=3,
		hp=3,
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
		-- function
		update=update_player,
		animate=animate_player,
		draw=draw_player,
		dmg=player_dmg,
	}
end

function update_player(self, enemies)
	-- physics (friction and gravity)
    self.vx = self.vx * self.fric
	if self.dash_time > 0 then
        self.dash_time = self.dash_time - 1
		if self.dash_time == 0 then
			self.cool_time = self.cool_time_max
		end
	else
        self.vy = self.vy + gravity
	end
	if self.cool_time > 0 then
		self.cool_time = self.cool_time - 1
	end
	-- running animation
	if abs(self.vx) < 0.5 then
		self.running = false
	end	
	-- on ladder ? reset
	self.ladder = "none"

	-- control
	if btn(4) then
		self.hiding = true
	else
		self.hiding = false
		if btn(0) then
			self.flip = true
			self.running = true
            self.vx = self.vx - self.acc_walk
		end
		if btn(1) then
			self.flip = false
			self.running = true
            self.vx = self.vx + self.acc_walk
		end
		if btn(2) then
			self.ladder = "up"
		end
		if btn(3) then
			self.ladder = "down"
		end
		if btnp(5)
		and self.dash_time == 0 then
			self.dash_time = self.dash_time_max
		end
	end

	-- hide
	hiding(self)

	-- dash
	if self.dash_time > 0 then
		if self.flip then
            self.vx = self.vx - self.acc_dash
		else
            self.vx = self.vx + self.acc_dash
		end
	elseif abs(self.vx) > self.max_vx then
		-- limit speed x-axis
		if self.vx > 0 then
			self.vx = self.max_vx
		else
			self.vx = -self.max_vx
		end
	end

	-- limit speed y-axis
	self.vy = mid(-self.max_vy, self.vy, self.max_vy)

	-- falling
	if self.vy > 0 and self.chk_ladder == "none" then
		self.falling = true
		self.landing = false
	end

	-- collide ground
	for offset = 1, flr(self.vy + 0.9) do
		local collide = collide_ground(self, offset)
		if collide then
			self.falling = false
			self.landing = true
			if self.vy > 0 then
				self.vy = 0
			end
			break
		end
	end
	-- ladder
	self.chk_ladder = chk_ladder(self)
	if self.chk_ladder == "on" then
		if self.ladder == "down" then
			self.vy = 1
		end
	elseif self.chk_ladder == "in" then
		if self.ladder == "up" then
			self.vy = -1
		end
		if self.ladder == "down" then
			self.vy = 1
		end
	elseif self.chk_ladder == "bottom" then
		if self.ladder == "up" then
			self.vy = -1
		end
	end

	-- collide wall
	if self.vx > 0
	and collide_wall(self, "right") then
		self.vx = 0
        self.x = self.x - (self.x + self.w) % 8
	elseif self.vx < 0
	and collide_wall(self, "left") then
		self.vx = 0
	end
	
	-- check map obj (goal, item, ...)
	cur_mapobj = chk_mapobj(self)
	
	-- collide enemies
	engage(self, enemies)

	-- apply move
    self.x = self.x + self.vx
    self.y = self.y + self.vy
	self.y = flr(self.y + 0.9)

	-- limit player to window
	if self.x < window_l then
		self.x = window_l
	elseif self.x > window_r - self.w then
		self.x = window_r - self.w
	end

	-- check player die
	if player.y > dead_h then
		self.hp = 0
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
	for enemy in all(enemies) do
		-- if not collide on y
		if not (max(p.y, enemy.y) <= min(p.y + p.h - 1, enemy.y + enemy.h - 1))
		and not (min(p.y + p.h - 1, enemy.y + enemy.h - 1) >= max(p.y, enemy.y)) then
			goto nextenemy
		end
		-- if not collide on x
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
                enemy.hp = enemy.hp - p.atk
				enemy.underatk = true
				enemy.downt = enemy.downt_max
				add(explode_pnts, {x=enemy.x, y=enemy.y, explode_time=explode_time})
			end
		else
			-- player damage
			if not p.hiding
			and not p.underatk
			and p.cool_time == 0
			and enemy.downt == 0 then
				p:dmg(1)
				p.underatk = true
				shake_intensity = shake_intensity_hit
			end
		end
		if enemy.hp <= 0 then
			del(enemies, enemy)
		end
		::nextenemy::
	end
end

function animate_player(self)
	self.spw = 1
	if self.hiding then
		-- hiding
		self.sp = 17
	elseif self.dash_time > 0 then
		-- dash
		self.sp = 33
		self.spw = 2
	elseif self.falling then
		-- falling
		self.sp = 7
	elseif self.running then
		-- running
		if time() - self.anim > 0.1 then
			self.anim = time()
            self.sp = self.sp + 1
			if self.sp > 6 then
				self.sp = 2
			end
		end
	elseif (self.chk_ladder == "in"
	or self.chk_ladder == "bottom")
	and self.vy ~= 0 then
		-- ladder
		if time() - self.anim > 0.1 then
			self.anim = time()
			if self.sp == 8 then
				self.sp = 9
			else
				self.sp = 8
			end
		end
	else
		self.sp = 1
	end
end

function player_dmg(self, d)
	self.hp = self.hp - d
end

function draw_player(self)
	spr(self.sp, self.x, self.y, self.spw, 1, self.flip)
end
