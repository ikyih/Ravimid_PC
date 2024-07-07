function loadBullet()
	bullet_x = {}
	bullet_y = {}
	bullet_timer = {}
	bullet_sprite = {}
	bullet_goal = 5
	bulletCount = 0
	bullet_count = 20
end

function changeBullet(id, x)
	if x == 0 then
		bullet_sprite[id] = fire1
	else
		bullet_sprite[id] = fire2
	end
end

function addBullet(x, y, sprite)
	id = bulletCount
	bullet_x[id] = x
	bullet_y[id] = y
	bullet_sprite[id] = sprite
	bullet_timer[id] = timer + math.random(1, bullet_goal)
	
	if sprite == fire1 or sprite == fire2 then
		fire_random = math.random(1)
		changeBullet(id, fire_random)
	end
	
	bulletCount = bulletCount + 1
end

function randomBullet()
	bullet = pill1
	rand = math.random(0,6)
	if rand == 0 then
		bullet = pill1
	elseif rand == 1 then
		bullet = pill2
	elseif rand == 2 then
		bullet = pill3
	elseif rand == 3 then
		bullet = pill4
	elseif rand == 4 then
		bullet = pill5
	elseif rand == 5 then
		bullet = pill6
	elseif rand == 6 then
		bullet = pill7
	end
	
	return bullet
end

function updateBullet(dt)
	for i = 0, bulletCount - 1 do
	
		if bullet_sprite[i] == fire1 or bullet_sprite[i] == fire2 then -- If this bullet is a boss bullet
		
		-- Move it quickly
		bullet_x[i] = bullet_x[i] - (4 * dt * 60)
		
			-- On a timer:
			if timer > bullet_timer[i] then
			
				-- animate the sprite
				if bullet_sprite[i] == fire1 then
					changeBullet(i, 1)
				else
					changeBullet(i, 0)
				end
				
				bullet_timer[i] = timer + bullet_goal
				
			end
			
			-- If it's offscreen:
			if bullet_x[i] < -64 then
				-- Push it back to it's start
				bullet_x[i] = 250
				bullet_y[i] = boss_y + 70
				gun1:play()
			end
			
			yextra = math.max(getSlider() * 240, 40)
			
			-- If boss bullet hit the player, end the game
			if CheckCollision(90, 200 - yextra + 40, 32, 32,  bullet_x[i], bullet_y[i] + 16, 64, 24) then
				slide_lock = true
				game_state = "GAME_OVER"
			end
			
		else -- If the current bullet is a player bullet
		
			bullet_x[i] = bullet_x[i] + (1 * dt * 60)
			
			if bullet_x[i] > 400 then
			
				-- The player can run out of bullets
				-- This doesn't usually happen on normal playthroughs
				if bullet_count > 0 then
					bullet_x[i] = 90
					bullet_y[i] = 240 - math.max(getSlider() * 240, 40)
					bullet_sprite[i] = randomBullet()
					gun2:play()
				end
				
				bullet_count = bullet_count - 1
			end
			
			-- If the bullet hit Alex's mouth
			if CheckCollision(boss_x + 30, boss_y + 130, 80, 28,  bullet_x[i], bullet_y[i], 16, 16) then
				
				-- If you still have bullets, respawn it
				if bullet_count > 0 then
					bullet_x[i] = 90
					bullet_y[i] = 240 - math.max(getSlider() * 240, 40)
					bullet_sprite[i] = randomBullet()
					gun2:play()
				else
					bullet_x[i] = -100
					bullet_y[i] = -100
				end
				
				boss_health = boss_health - 1
				bullet_count = bullet_count - 1
				
				if boss_health == 0 then
					game_state = "WIN"
					main_song:stop()
					title_song:play()
				end
			end
		
		end
		
	end
end

function drawBullet()
	for i = 0, bulletCount - 1 do
			love.graphics.draw(bullet_sprite[i], bullet_x[i], bullet_y[i])
	end
end