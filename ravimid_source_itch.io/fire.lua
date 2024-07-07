function loadFire()
	fire_x = {}
	fire_y = {}
	fire_timer = {}
	fire_sprite = {}
	fire_goal = 5
	fireCount = 0
	
	fire1 = love.graphics.newImage("fire1.png")
	fire2 = love.graphics.newImage("fire2.png")
end

function changeFire(id, x)
	if x == 0 then
		fire_sprite[id] = fire1
	else
		fire_sprite[id] = fire2
	end
end

function addFire(x, y)
	fire_id = fireCount
	fire_x[fire_id] = x
	fire_y[fire_id] = y
	
	-- Fixes the LovePotion glitch that the player has too
	if is3DS() then
		fire_y[fire_id] = fire_y[fire_id] - 64
	end
	
	fire_timer[fire_id] = timer + math.random(1, fire_goal)
	
	fire_random = math.random(1)
	changeFire(fire_id, fire_random)
	
	fireCount = fireCount + 1
end

function addAllFire()
	-- the reason these values are reset is to clear the tables
	fire_x = {}
	fire_y = {}
	fire_timer = {}
	fire_sprite = {}
	fire_goal = 5
	fireCount = 0
	
	addFire(307, 135)
	addFire(290 - 32, 170)
	addFire(404 - 32, 196)
end

function updateFire(dt)
	for i = 0, fireCount - 1 do
	
		-- Animate on a timer
		if timer > fire_timer[i] then
		
			if fire_sprite[i] == fire1 then
				changeFire(i, 1)
			else
				changeFire(i, 0)
			end
			
			fire_timer[i] = timer + fire_goal
			
		end
	end
end

function drawFire()
	for i = 0, fireCount - 1 do
		if isVisible(fire_x[i]) then
			love.graphics.draw(fire_sprite[i], fire_x[i] + level_x, fire_y[i], (3 *math.pi) / 2)
		end
	end
end