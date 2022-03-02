pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- daslash
-- by kaytruck

function _init()
	init()
	_update = update_title
	_draw = draw_title
end

function init()
	-- settings
	dead_h = 130
	gravity=0.2
	-- window limits
	window_l = 0
	window_r = 128
	-- title screen
	blink_col1 = 8
	blink_col2 = 14
	blink_col = blink_col1
	blink_cnt = 0
	-- player
	player = {
		sp=1,				-- sprite
		spw=1,				-- sprite width
		w=8,
		h=8,
		x=40,
		y=30,
		dx=0,
		dy=0,
		max_dx=2,
		max_dy=3,
		max_dy_ladder=1,
		acc_walk=0.8,
		acc_dash=2,
		acc_jump=3,
		fric=0.5,
		dash_time=0,
		dash_time_max = 6,
		atk=3,
		-- stat
		running=false,
		falling=false,
		landing=false,
		chk_ladder="none",
		flip=false,
		dash_time=0,
		dash_time_max = 6,
		hide=false,
		ladder="none",
		-- anim
		anim=0,
	}
	-- enemies
	enemies = {}
	create_enemey_1()
end

function create_enemey_1()
	local enemy = {
		sp=64,
		sp_begin=64,
		sp_end=65,
		spw=1,				-- sprite width
		w=8,
		h=8,
		x=70,
		y=16,
		dx=0.5,
		flip=false,
		dead=false,
		hp=6,
		-- anim
		anim=0,
		-- function
		update=update_enemy_1,
		animate=animate_enemy_1,
	}
	add(enemies, enemy)
end

-->8
function update_title()
	if btnp(❎) then
		_update = update_gaming
		_draw = draw_gaming
	end
	-- blink start message
	blink_cnt += 1
	if blink_cnt > 7 then
		blink_cnt = 0
		if blink_col == blink_col1 then
			blink_col = blink_col2
		else
			blink_col = blink_col1
		end
	end
end

function draw_title()
	cls(1)
	print("daslash", 32, 8, 12)
	spr(192, 48, 25, 4, 4)
	print("dash from behind, and slash!", 8, 62, 3)
	print("press ❎ to start", 32, 82, blink_col)
	print("🅾️ hide", 16, 96, 6)
	print("❎ dash and slash", 16,104,6)
	print("by kaytruck", 80, 120, 6)
	
end

-->8
function update_gaming()
	update_player()
	update_enemies()
	animate_player()
	animate_enemies()
end

function update_player()
	player.dx *= player.fric
	if player.dash_time > 0 then
		player.dash_time -= 1
	else
		player.dy += gravity
	end
	if abs(player.dx) < 0.5 then
		player.running = false
	end	
	player.ladder = "none"
	--control
	if btn(🅾️) then
		player.hide = true
	else
		player.hide = false
		if btn(⬅️) then
			player.flip = true
			player.running = true
			player.dx -= player.acc_walk
		end
		if btn(➡️) then
			player.flip = false
			player.running = true
			player.dx += player.acc_walk
		end
		if btn(⬆️) then
			player.ladder = "up"
		end
		if btn(⬇️) then
			player.ladder = "down"
		end
		if btnp(❎)
		and player.dash_time == 0 then
			player.dash_time = player.dash_time_max
		end
	end

	-- dash
	if player.dash_time > 0 then
		if player.flip then
			player.dx -= player.acc_dash
		else
			player.dx += player.acc_dash
		end
	elseif abs(player.dx) > player.max_dx then
		-- limit speed x-axis
		if player.dx > 0 then
			player.dx = player.max_dx
		else
			player.dx = -player.max_dx
		end
	end

	-- limit speed y-axis
	player.dy = mid(-player.max_dy, player.dy, player.max_dy)

	-- falling
	if player.dy > 0 and player.chk_ladder == "none" then
		player.falling = true
		player.landing = false
	end

	-- collide ground
	for offset = 1, flr(player.dy + 0.9) do
		collide = collide_ground(player, offset)
		if collide then
			player.falling = false
			player.landing = true
			if player.dy > 0 then
				player.dy = 0
			end
			break
		end
	end
	-- ladder
	player.chk_ladder = chk_ladder(player)
	if player.chk_ladder == "on" then
		if player.ladder == "down" then
			player.dy = 1
		end
	elseif player.chk_ladder == "in" then
		if player.ladder == "up" then
			player.dy = -1
		end
		if player.ladder == "down" then
			player.dy = 1
		end
	elseif player.chk_ladder == "bottom" then
		if player.ladder == "up" then
			player.dy = -1
		end
	end

	-- collide wall
	if player.dx > 0
	and collide_wall(player, "right") then
		player.dx = 0
		player.x -= (player.x + player.w) % 8
	elseif player.dx < 0
	and collide_wall(player, "left") then
		player.dx = 0
	end

	-- dash through enemy
	for enemy in all(enemies) do
		if player.dash_time > 0
		and min(player.x, player.x + player.dx) < enemy.x
		and max(player.x, player.x + player.dx) > enemy.x 
		and player.flip == enemy.flip then
			enemy.hp -= player.atk
		end
	end

	-- apply move
	player.x += player.dx
	player.y += player.dy
	player.y = flr(player.y + 0.9)

	-- limit player to window
	if player.y > dead_h then
		_update = update_gameover
		_draw = draw_gameover
	end
	if player.x < window_l then
		player.x = window_l
	elseif player.x > window_r - player.w then
		player.x = window_r - player.w
	end
end

function update_enemies()
	for enemy in all(enemies) do
		enemy.update(enemy)
	end
end

function update_enemy_1(self)
	-- flip
	local collide = collide_ground(self, 1)
	if not collide then
		self.dx *= -1
		self.flip = not self.flip
	end
	-- apply move
	self.x += self.dx
end

function collide_wall(obj, dir)
	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0
	local flg = 0xF
	if dir == "right" then
		x1 = obj.x + obj.w
		y1 = obj.y
		x2 = obj.x + obj.w
		y2 = obj.y + obj.h - 1
	elseif dir == "left" then
		x1 = obj.x - 1
		y1 = obj.y
		x2 = obj.x - 1
		y2 = obj.y + obj.h - 1
	end

	-- pixel to tile
	x1 /= 8
	y1 /= 8
	x2 /= 8
	y2 /= 8

	if fget(mget(x1, y1)) == flg
	or fget(mget(x2, y2)) == flg
	then
		return true
	else
		return false
	end
end

function collide_ground(obj, offset)
	-- bottom left
	local x1 = obj.x + 2
	-- local x1 = obj.x + 3
	-- local x1 = obj.x + obj.w / 2
	local y1 = (obj.y + obj.h - 1) + offset
	-- bottom right
	local x2 = obj.x + obj.w - 3
	-- local x2 = obj.x + obj.w - 3
	-- local x2 = obj.x + obj.w / 2
	local y2 = (obj.y + obj.h - 1) + offset
	flg = 0x4

	x1 /= 8
	y1 /= 8
	x2 /= 8
	y2 /= 8

	if (fget(mget(x1, y1)) & flg) != 0
	or (fget(mget(x2, y2)) & flg) != 0
	then
		return true
	else
		return false
	end
end

function chk_ladder(obj)
	-- bottom center
	-- local x1 = obj.x + 2
	-- local x1 = obj.x + 3
	local x1 = obj.x + obj.w / 2
	local y1 = (obj.y + obj.h - 1)
	-- bottom center + 1
	-- local x2 = obj.x + obj.w - 2
	-- local x2 = obj.x + obj.w - 3
	local x2 = obj.x + obj.w / 2
	local y2 = (obj.y + obj.h)

	local flg = 0x14

	x1 /= 8
	y1 /= 8
	x2 /= 8
	y2 /= 8
	if fget(mget(x1, y1)) == flg then
		if fget(mget(x2, y2)) == flg then
			return "in"
		else
			return "bottom"
		end
	elseif fget(mget(x2, y2)) == flg then
		return "on"
	end
	return "none"
end

function animate_player()
	player.spw = 1
	if player.hide then
		player.sp = 17
	elseif player.dash_time > 0 then
		player.sp = 33
		player.spw = 2
	elseif player.falling then
		player.sp = 7
	elseif player.running then
		if time() - player.anim > 0.1 then
			player.anim = time()
			player.sp += 1
			if player.sp > 6 then
				player.sp = 2
			end
		end
	elseif (player.chk_ladder == "in"
	or player.chk_ladder == "bottom")
	and player.dy != 0 then
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

function animate_enemies()
	for enemy in all(enemies) do
		enemy.animate(enemy)
	end
end

function animate_enemy_1(self)
	if time() - self.anim > 0.1 then
		self.anim = time()
		self.sp += 1
		if self.sp > self.sp_end then
			self.sp = self.sp_begin
		end
	end
end

function draw_gaming()
	cls(1)
	draw_map()
	-- TODO draw player hp
	if player.hide then
		draw_player()
	end
	draw_enemies()
	if not player.hide then
		draw_player()
	end
	
	-- debug print
	-- print("player.dx:"..player.dx, 3)
	-- print("player.dy:"..player.dy, 3)
	-- print("player.x:"..player.x, 3)
	-- print("player.y:"..player.y, 3)
	-- print("player.chk_ladder:"..player.chk_ladder, 3)
end

function draw_map()
	map(0, 0)
end

function draw_player()
	spr(player.sp, player.x, player.y, player.spw, 1, player.flip)
end

function draw_enemies()
	for enemy in all(enemies) do
		-- local c = 11
		if enemy.hp > 0 then
			spr(enemy.sp, enemy.x, enemy.y, 1, 1, enemy.flip)
		end
	end
end

-->8
function update_gameover()
	if btnp(❎) then
		init()
		_update = update_title
		_draw = draw_title
	end
end

function draw_gameover()
	cls(1)
	print("you died", 32, 32, 6)
	print("press ❎ to title", 32, 48, 6)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccc00000ccc00000ccc00000ccc00000ccc00000ccc00000ccc0000cccc0000cccc00000000000000000000000000000000000000000000000000
00700700000c7500000c7500000c7500000c7500000c7500000c7500040c754000cccc0440cccc00000000000000000000000000000000000000000000000000
00077000000ccc00000ccc00000ccc00000ccc00000ccc00000ccc000c0ccc0000cccc0000cccc00000000000000000000000000000000000000000000000000
00077000000c0000004c0000000c0000000c0000000c0000004c000000cc00c0040c00000000c040000000000000000000000000000000000000000000000000
007007000040c0400000c0400040c4000004c4000040c0400000c4000000c000000cc000000cc000000000000000000000000000000000000000000000000000
00000000000cc00000cc00000000c000000d0c00000cd000000c0000000d0c0000c0000000000c00000000000000000000000000000000000000000000000000
0000000000c00c0000000d00000cd00000d00c0000c0000000000d00000d0c0000000c0000c00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000040dd0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000ccc060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006000000c75676000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000600000006ccc607600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000060000046c0d417600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000670000c600776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660cc6077660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000099c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0099c000009cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009cc000009990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000009555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09956550090560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00059000009990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09000900009090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffe2000000000000000022222222060000600000000000000000003333000000000000000000000000000000000000000000000000000000000000000000
f22222e20000000000000000ffffffff06666660000000000000000003bbbb300000000000000000000000000000000000000000000000000000000000000000
f22222e20000000000000000ddddd66d06000060000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
f22222e200000000000000002222222206666660000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
f22222e200000000000000002222222206000060000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
f22222e200000000000000002222222206666660000000000000000003a33b300000000000000000000000000000000000000000000000000000000000000000
eeeeee2200000000000000004444444406000060000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
2222222200000000000000002222222206666660000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
00000777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077666666666666667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00766dddddddddddddd6670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
076dddddddddddddddddd67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
076dd66666666666666dd67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6555555555555556dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6742444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6742444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6722222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6744444424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6744444424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6722222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6744424444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6722222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66dd6500000000000056dd6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddd6500000000000056dddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd655000000000000556ddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66655000000000000005566600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55550000000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000999c000000cccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000099cc00900000cc750006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000800099cc09000000cccc0066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000808999900500400cc000667760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080eeee00005500044c6cc00470776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000998080e500000000c1c0400076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000089990550e000000ccc66060076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009000500e00000c17606600076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008e0e888809900060cc06770000766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000888990009000060c67760007660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00008899090099900007076000077600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099000000000066760000776600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000090000090077606000077766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00009900700066700600607776660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00079070006676060007077666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007d00600000070766600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000070000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000001140000000000000000000000010101000000000000000000000000000100010f0000000000000000000000000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a3a30084a3a3a3a3a3a3a38400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000084000000000000008400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000084000000000000008400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000084000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000a3a3a3a3a384000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a300000000000084000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a300000000000084000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a3a3a3a3a3a3a384a30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000840000000000a300a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000840000008400a3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a3a3a3a3a3a3a3a3a3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
