function create_enemey_yellow(init_x, init_y, init_vx)
	return create_enemy(64, 65, init_x, init_y, init_vx, 6, update_enemy_1, animate_enemy_1)
end

function create_enemey_dog(init_x, init_y, init_vx)
	return create_enemy(80, 81, init_x, init_y, init_vx, 3, update_enemy_1, animate_enemy_1)
end

function create_enemy(i_sp, i_sp_end, i_x, i_y, i_vx, i_hp, u_func, a_func)
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
		update=u_func,
		animate=a_func,
	}
end

function update_enemies(enemies)
	for enemy in all(enemies) do
		enemy:update()
	end
end

function update_enemy_1(self)
	if self.downt > 0 then
		self.downt = self.downt - 1
	end
	-- flip
	local collide_ground = collide_ground(self, 1)
	local dir = "right"
	if self.vx < 0 then
		dir = "left"
	end
	local collide_wall = collide_wall(self, dir)
	if not collide_ground 
	or collide_wall then
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
		if enemy.hp > 0 then
			spr(enemy.sp, enemy.x, enemy.y, 1, 1, enemy.flip)
		end
	end
end
