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
	-- x1 /= 8
	-- y1 /= 8
	-- x2 /= 8
	-- y2 /= 8
    x1 = x1 / 8
    y1 = y1 / 8
    x2 = x2 / 8
    y2 = y2 / 8

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
	local flg = 0x4

	x1 = x1 / 8
	y1 = y1 / 8
	x2 = x2 / 8
	y2 = y2 / 8

	if (fget(mget(x1, y1)) & flg) ~= 0
	or (fget(mget(x2, y2)) & flg) ~= 0
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

	-- x1 /= 8
	-- y1 /= 8
	-- x2 /= 8
	-- y2 /= 8
	x1 = x1 / 8
	y1 = y1 / 8
	x2 = x2 / 8
	y2 = y2 / 8

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
