function loadBoss()
	boss_x = 250
	boss_y = 20
	boss_direction = 1
	boss_sprite = boss
	boss_count = 0
	boss_health = 10
end

function updateBoss(dt)
	boss_y = boss_y + (boss_direction * dt * 60)
	boss_count = boss_count + 1
	
	if boss_count == 10 then
		if boss_sprite == boss then
			boss_sprite = boss2
		else
			boss_sprite = boss
		end
		boss_count = 0
	end
	
	if boss_direction == 1 and boss_y > 40 then
		boss_direction = -1
	end
	
	if boss_direction == -1 and boss_y < 0 then
		boss_direction = 1
	end
end

function drawBoss()
	love.graphics.setColor(255, 255, 255, ((boss_health + 1) / 11) * 255) -- The boss fades as his health decreases
	love.graphics.draw(boss_sprite, boss_x, boss_y)
	love.graphics.setColor(c_white)
end