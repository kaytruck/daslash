f_door = 0x11
f_hpmaxup = 0x22
f_hpup = 0x21

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
    x1 = x1 / 8 + stages[sn].m_x
    y1 = y1 / 8 + stages[sn].m_y
    x2 = x2 / 8 + stages[sn].m_x
    y2 = y2 / 8 + stages[sn].m_y

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
	local y1 = (obj.y + obj.h - 1) + offset
	-- bottom right
	local x2 = obj.x + obj.w - 3
	local y2 = (obj.y + obj.h - 1) + offset
	local flg = 0x4

	x1 = x1 / 8 + stages[sn].m_x
	y1 = y1 / 8 + stages[sn].m_y
	x2 = x2 / 8 + stages[sn].m_x
	y2 = y2 / 8 + stages[sn].m_y

	if (fget(mget(x1, y1)) & flg) ~= 0
	or (fget(mget(x2, y2)) & flg) ~= 0
	then
		return true
	else
		return false
	end
end

function chk_ladder(obj)
	-- bottom left and right
	local x1_l = obj.x + 2
	local x1_r = obj.x + obj.w -3
	local y1 = (obj.y + obj.h - 1)

	-- bottom + 1 left and right
	local x2_l = obj.x + 2
	local x2_r = obj.x + obj.w -3
	local y2 = (obj.y + obj.h)

	local flg = 0x14

	x1_l = x1_l / 8 + stages[sn].m_x
	x1_r = x1_r / 8 + stages[sn].m_x
	y1 = y1 / 8 + stages[sn].m_y
	x2_l = x2_l / 8 + stages[sn].m_x
	x2_r = x2_r / 8 + stages[sn].m_x
	y2 = y2 / 8 + stages[sn].m_y

    if fget(mget(x1_l, y1)) == flg 
	or fget(mget(x1_r, y1)) == flg then
		if fget(mget(x2_l, y2)) == flg
		or fget(mget(x2_r, y2)) == flg then
			return "in"
		else
			return "bottom"
		end
	elseif fget(mget(x2_l, y2)) == flg
	or fget(mget(x2_r, y2)) == flg then
		return "on"
	end
	return "none"
end

function chk_mapobj(player)
	local x = player.x + player.w / 2
	local y = player.y + player.h / 2
	local f = fget(mget(x/8 + stages[sn].m_x, y/8 + stages[sn].m_y))

	local mobj = "none"
	if f == f_door then
		mobj = "door"
	elseif f == f_hpmaxup then
		mobj = "hpmaxup"
	elseif f == f_hpup then
		mobj = "hpup"
	else
		mobj = "none"
	end
	exec_map_func(mobj, player, stages, sn)
	return mobj
end

function exec_map_func(mobj, player, stages, sn)
	local mf = map_func[mobj]
	if mf then
		mf(player, stages, sn)
	end
end