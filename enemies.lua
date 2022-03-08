function init_enemies(es)
	local enemies = {}
	for e in all(es) do
		add(enemies, e.create(e.sp, e.sp_end, e.x, e.y, e.vx, e.hp))
	end
	-- add(enemies, create_enemey_1(64, 65, 8 * 8, 2 * 8, 0.5, 6))
	-- add(enemies, create_enemey_1(80, 81, 9 * 8, 12 * 8, -0.7, 3))
	return enemies
end

function create_enemey_1(init_sp, init_sp_end, init_x, init_y, init_vx, init_hp)
	local flip = false
	if init_vx < 0 then
		flip = true
	end
	return {
		sp=init_sp,
		sp_begin=init_sp,
		sp_end=init_sp_end,
		spw=1,				-- sprite width
		w=8,
		h=8,
		x=init_x,
		y=init_y,
		vx=init_vx,
		flip=flip,
		dead=false,
		hp=init_hp,
		underatk=false,		-- under attack flag
		-- anim
		anim=0,
		-- function
		update=update_enemy_1,
		animate=animate_enemy_1,
	}
end

function update_enemies(enemies)
	for enemy in all(enemies) do
		enemy:update()
	end
end

function update_enemy_1(self)
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
	self.x = self.x + self.vx
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
