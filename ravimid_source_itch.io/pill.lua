function loadPill()
	pill_x = {}
	pill_y = {}
	pill_active = {}
	pill_color = {}
	pillCount = 0
	
	pill1 = love.graphics.newImage("pill1.png")
	pill2 = love.graphics.newImage("pill2.png")
	pill3 = love.graphics.newImage("pill3.png")
	pill4 = love.graphics.newImage("pill4.png")
	pill5 = love.graphics.newImage("pill5.png")
	pill6 = love.graphics.newImage("pill6.png")
	pill7 = love.graphics.newImage("pill7.png")
end

function addPill(x, y, color)
	pill_id = pillCount
	pill_x[pill_id] = x
	pill_y[pill_id] = y
	pill_active[pill_id] = true
	pill_color[pill_id] = color
	pillCount = pillCount + 1
end

function addAllPills()
	-- the reason these values are reset is to clear the tables
	pill_x = {}
	pill_y = {}
	pill_active = {}
	pill_color = {}
	pillCount = 0
	
	addPill(176, 155, pill1)
	addPill(307, 135, pill1)
	addPill(348, 117, pill1)
	addPill(401, 156, pill1)
	
	addPill(533, 62, pill2)
	addPill(590, 62, pill2)
	addPill(630, 73, pill2)
	addPill(678, 58, pill2)
	addPill(722, 104, pill2)
	addPill(626, 196, pill2)
	addPill(662, 200, pill2)
	
	addPill(946, 206, pill3)
	addPill(969, 183, pill3)
	addPill(959, 160, pill3)
	addPill(922, 94, pill3)
	addPill(901, 55, pill3)
	addPill(1061, 83, pill3)
	addPill(1119, 90, pill3)
	addPill(1195, 90, pill3)
	addPill(1086, 200, pill3)
	addPill(1168, 200, pill3)
	
	addPill(1271, 24, pill4)
	addPill(1339, 26, pill4)
	addPill(1387, 23, pill4)
	addPill(1274, 61, pill4)
	addPill(1337, 87, pill4)
	addPill(1397, 78, pill4)
	addPill(1275, 94, pill4)
	addPill(1352, 122, pill4)
	addPill(1379, 125, pill4)
	addPill(1447, 201, pill4)
	
	addPill(1489, 144, pill5)
	addPill(1499, 28, pill5)
	
	addPill(1526, 97, pill6)
	addPill(1558, 102, pill6)
	addPill(1638, 100, pill6)
	
	addPill(1720, 189, pill7)
	addPill(1717, 158, pill7)
	addPill(1719, 105, pill7)
	addPill(1717, 60, pill7)
	addPill(1716, 19, pill7)
end

function noPills()
	stillActive = false
	for i = 0, pillCount - 1 do
		if pill_active[i] == true then
			stillActive = true
		end
	end
	
	return stillActive
end

function getFalsePills()
	num = 0
	for i = 0, pillCount - 1 do
		if pill_active[i] == false then
			num = num + 1
		end
	end
	
	return num
end

-- This function is super useful in a lot of places
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- This function is ravimid specific, it does the seiklus moving balls thing
-- I spent way more time than I would have liked to trying to make this work and the solution is stupid and simple
-- (other methods didn't work in LovePotion or didn't look as good)
function floatFive(dt)
	-- If there's a choose() function in lua, that would be better than this
	apple = math.random(0, 2)
	if apple == 0 then
		return -0.3 * dt * 60
	elseif apple == 1 then
		return 0
	else
		return 0.3 * dt * 60
	end
end

function updatePill(dt)
	for i = 0, pillCount - 1 do
		if pill_active[i] and isVisible(pill_x[i]) then
			pill_x[i] = pill_x[i] + floatFive(dt)
			pill_y[i] = pill_y[i] + floatFive(dt)
			
			yextra = math.max(getSlider() * 240, 40)
			if CheckCollision(90, 200 - yextra + 40, 32, 32,  pill_x[i] + level_x, pill_y[i], 16, 16) then
				pill_active[i] = false
				click:play()
			end
			
		end
	end
end

function drawPill()
	for i = 0, pillCount - 1 do
		if pill_active[i] and isVisible(pill_x[i]) then
			love.graphics.draw(pill_color[i], pill_x[i] + level_x, pill_y[i])
		end
	end
end