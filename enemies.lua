function create_enemey_yellow(init_x, init_y, init_vx, init_vy)
	local yellow = create_enemy(64, 65, init_x, init_y, init_vx, init_vy, 6,
		update_enemy_yellow,
		animate_enemy_1,
		function(self)
			spr(self.sp, self.x, self.y, 1, 1, self.flip)
			for shot in all(self.shots) do
				circfill(shot.x, shot.y, 1, 10)
			end
		end
	)
	yellow["shots"] = {}
	yellow["shots_max"] = 3
	return yellow
end

function create_enemey_dog(init_x, init_y, init_vx, init_vy)
	return create_enemy(80, 81, init_x, init_y, init_vx, init_vy, 3,
		update_enemy_dog,
		animate_enemy_1,
		function(self)
			spr(self.sp, self.x, self.y, 1, 1, self.flip)
		end
	)
end

function create_enemy(i_sp, i_sp_end, i_x, i_y, i_vx, i_vy, i_hp, u_func, a_func, d_func)
	local flip = false
	if i_vx < 0 then
		flip = true
	end
	return {
		sp=i_sp,
		sp_begin=i_sp,
		sp_end=i_sp_end,
		spw=1,				-- sprite width
		w=8,
		h=8,
		x=i_x,
		y=i_y,
		vx=i_vx,
		vy=i_vy,
		flip=flip,
		-- status
		downt=0,
		downt_max=10,
		dead=false,
		hp=i_hp,
		underatk=false,		-- under attack flag
		-- anim
		anim=0,
		-- function
		update = u_func,
		animate = a_func,
		draw = d_func,
	}
end

function update_enemies(enemies)
	for enemy in all(enemies) do
		enemy:update()
	end
end

function update_enemy_yellow(self)
	-- add shot
	if rnd(1) < 0.025
	and #self.shots < self.shots_max then
		local x = self.x
		local vx = -2
		if not self.flip then
			x = x + self.w
			vx = -vx
		end
		add(self.shots, {
			x = x,
			y = self.y + 4,
			vx = vx,
			dmg = 1,
		})
	end 
	-- shot move
	for s in all(self.shots) do
		s.x = s.x + s.vx
		-- engage player
		if s.x > player.x
		and s.x < player.x + player.w
		and s.y > player.y
		and s.y < player.y + player.h then
			player:dmg(s.dmg)
			del(self.shots, s)
			goto next_shot
		end
		-- delete on frame out
		if s.x < 0 or s.x > 127 then
			del(self.shots, s)
		end
		::next_shot::
	end
	-- move
	enemy_move_1(self)
end

function update_enemy_dog(self)
	enemy_move_1(self)
end

function enemy_move_1(self)
	if self.downt > 0 then
		self.downt = self.downt - 1
	end
	-- flip
	if not collide_ground2(self) 
	or collide_wall2(self) then
		self.vx = self.vx * -1
		self.flip = not self.flip
	end
	-- apply move
	if self.downt == 0 then
		self.x = self.x + self.vx
	end
end

function animate_enemies(enemies)
	for enemy in all(enemies) do
		enemy.animate(enemy)
	end
end

function animate_enemy_1(this)
	if time() - this.anim > 0.1 then
		this.anim = time()
		this.sp = this.sp + 1
		if this.sp > this.sp_end then
			this.sp = this.sp_begin
		end
	end
end

function draw_enemies(enemies)
	for enemy in all(enemies) do
		enemy:draw()
	end
end
