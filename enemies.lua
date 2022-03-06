function init_enemies()
	local enemies = {}
	add(enemies, create_enemey_1())
	return enemies
end
function create_enemey_1()
	return {
		sp=64,
		sp_begin=64,
		sp_end=65,
		spw=1,				-- sprite width
		w=8,
		h=8,
		x=70,
		y=16,
		vx=0.5,
		flip=false,
		dead=false,
		hp=6,
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
