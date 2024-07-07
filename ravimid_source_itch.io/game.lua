game_state = "LOAD"

-- loadGame(x) loads sections of data at a time
-- The benefit of this is that on 3DS, data doesn't just hang until the game is finished loading
-- This system works kind of weird, but it's robust enough that just putting any data you would normally load in between 10 sections
function loadGame(x)

	if x == 0 then -- 10%
	
		me = love.graphics.newImage("me.png")
		toasty = love.audio.newSource("toast.wav", "static")
		me_transparent = 0
		
	elseif x == 2 then -- 20%
	
		title_top = love.graphics.newImage("title.png")
		title_bot = love.graphics.newImage("title2.png")
	
	elseif x == 4 then -- 30%
	
		title_song = love.audio.newSource("title.ogg", "stream")
		title_song:setLooping(true)
	
	elseif x == 6 then -- 40%
	
		main_song = love.audio.newSource("main.ogg", "stream")
		main_song:setLooping(true)
	
	elseif x == 8 then -- 50%
	
		level1 = love.graphics.newImage("level1.png")
		level2 = love.graphics.newImage("level2.png")
		level_x = 0
	
	elseif x == 10 then -- 60%
	
		guy1 = love.graphics.newImage("guy1.png")
		guy2 = love.graphics.newImage("guy2.png")
		guy3 = love.graphics.newImage("guy3.png")
		guy4 = love.graphics.newImage("guy4.png")
		guy_frame = 0
		guy_image = guy1
		guy_scale = 1
		guy_speed = 1
		boss = love.graphics.newImage("boss.png")
	
	elseif x == 12 then -- 70%
	
		require "pill"
		loadPill()
		click = love.audio.newSource("click.wav", "static")
		
		require "fire"
		loadFire()
		gun1 = love.audio.newSource("gunshot2.wav", "static")
		gun2 = love.audio.newSource("gunshot3.wav", "static")
	
	elseif x == 14 then -- 80%
	
		walle = love.graphics.newImage("walle.png")
		walle_y = 0
		boss2 = love.graphics.newImage("boss2.png")
	
	elseif x == 16 then -- 90%
	
		game_over1 = love.graphics.newImage("death1.png")
		game_over2 = love.graphics.newImage("death2.png")
	
	elseif x == 18 then -- 100%
		
		end1 = love.graphics.newImage("end.png")
		end2 = love.graphics.newImage("end2.png")
		require "boss"
		require "bullet"
		hasDied = false
	
	end
	
end

-- This is a pretty useless function, it tries to save some ram on 3DS
-- For what it's worth, setting variables to nil does kill them and save ram
function unloadIntro()
	me = nil
	toasty = nil
	title_top = nil
	title_bot = nil
end

-- This function is specific to ravimid, remake it for another project
function isVisible(x)
	return (x + level_x > -80) and (x + level_x < 400)
end

function is3DS()
	return os_model ~= "pc"
end

-- Cross platform 3D slider
function getSlider()
	slide = 0
	if is3DS() then
		slide = love.graphics.get3DSlider()
	else
		slide = (240 - math.min(love.mouse.getY(), 240)) / 240
	end
	
	return slide
end

-- Cross-ish platform 3D
function _setDepth(x)
	if is3DS() then
		love.graphics.setDepth(x)
	end
end

-- Sets the animation frame for the player
function animateGuy()
	if guy_frame == 0 then
		guy_image = guy1
	elseif guy_frame == 2 then
		guy_image = guy3
	else
		guy_image = guy2
	end
end

-- *********************** Game state functions *********************************
function stateHOKSYStart()
	game_state = "HOKSY"
	toasty:play()
	timer = 0
end

function stateTITLE_SCREENStart()
	game_state = "TITLE_SCREEN"
	title_song:play()
end

-- This naming convention sucks, I'm sorry
function stateSTARTStart()
	game_state = "START"
	title_song:stop()
	unloadIntro()
	main_song:play()
	
	addAllPills()
	addAllFire()
end

-- This is a joke
function stateSTARTRestart()
	addAllPills()
	addAllFire()
	level_x = 0
	walle_y = 0
	game_state = "START"
	hasDied = true
end

function stateBATTLEStart()
	game_state = "BATTLE"
	
	-- reload boss and bullets (resets the battle if you died)
	loadBoss()
	loadBullet()
	
	-- Make starting bullets
	addBullet(250, boss_y + 70, fire1)
	addBullet(90, 40, randomBullet()) -- This is broken
	
	gun1:play()
	gun2:play()
end

-- ******************************* THIS IS THE MAIN GAME LOOP **************************************
function updateGame(dt)

	-- timer is used for time specific functions
	timer = timer + 1

	loadStart = 3
	
	-- We use game states to control game events
	if game_state == "LOAD" then
		-- Any modern PC can load this game waaaaaay faster than a 3DS
		if os_model == "pc" then
			timer = 20 + loadStart
			for i = 0, timer do
				loadGame(i)
			end
		end
		
		if timer >= loadStart then
			loadGame(timer - loadStart)
		end
		
		if timer > 19 + loadStart then
			stateHOKSYStart()
		end
	end
	-- END LOAD
	
	-- START HOKSY
	if game_state == "HOKSY" then
	
		-- Fade *-* in/out
		if timer < 80 then
			me_transparent = math.min(me_transparent + 24, 255)
		else
			me_transparent = math.max(me_transparent - 24, 0)
		end
		
		if timer > 100 then
			stateTITLE_SCREENStart()
		end
	end
	-- END HOKSY

	-- START TITLE_SCREEN
	if game_state == "TITLE_SCREEN" then
		-- Bear in mind PC and 3DS handle mouse slightly differently
		-- PC has mouse 0,0 in the top left hand corner of the window
		-- 3DS has it in the touch screen's top left hand corner
		mouse_x = love.mouse.getX()
		mouse_y = love.mouse.getY()
		
		--timer does nothing here anyway
		timer = 0
		
		-- See above ^^
		if os_model == "pc" then
			mouse_x = mouse_x - 40
			mouse_y = mouse_y - 240
		end
		
		if love.mouse.isDown(1) then
			-- I hard coded the button positions
			if mouse_y >= 56 and mouse_y <= 88 then
				stateSTARTStart()
				
				-- This is necessary for 3D to work on 3DS
				if is3DS() then
					love.graphics.set3D(true)
				end
				
			end
			
			if mouse_y >= 139 and mouse_y <= 183 then
				love.event.quit()
			end
			
		end
	end
	-- END TITLE_SCREEN
	
	if game_state == "START" then
		-- OH SHIT HE DIDN'T FIX IT
		-- (it's actually because the mouse is now a 3D slider on PC)
		mouse_x = love.mouse.getX()
		mouse_y = love.mouse.getY()
		
		-- This is a shitty way of doing animation
		-- Using modulus (%) guy_frame only ever returns 0, 1, 2 or 3
		guy_frame = math.floor((timer % 16) / 4)
		
		if hasDied == false then
			-- In the first playthrough, you slow down slightly as you get closer to Alex
			guy_speed = math.max((2000 + level_x) / 3500, 0.1)
		else
			-- After dying you just move at a normal speed
			guy_speed = 1
		end
		
		-- Cross platform stuff
		left_btn = "a"
		right_btn = "d"
		if os_model ~= "pc" then
			-- LovePotion actually doesn't update its documentation anymore
			
		--"a", "b", "select", "start",
		--"right", "left", "up", "down",
		--"rbutton", "lbutton", "x", "y", "lzbutton", "rzbutton",
		--"touch",
		--"cstickright", "cstickleft", "cstickup", "cstickdown",
		--"cpadright", "cpadleft", "cpadup", "cpaddown"
		
		-- ^^ all possible 'buttons' from LovePotion
		
			left_btn = "cpadleft"
			right_btn = "cpadright"
		end
		
		if love.keyboard.isDown(left_btn) then
		
			-- Face guy left
			guy_scale = -1
			
			-- This game doesn't have a real camera, we just scroll the background
			level_x = math.min(0, level_x + (guy_speed * dt) * 60)
			
			animateGuy()
			
		elseif love.keyboard.isDown(right_btn) then
		
			-- Face guy right
			guy_scale = 1
			
			level_x = math.max(-2048 + 400, level_x - (guy_speed * dt) * 60)
			
			animateGuy()
			
		end
		
		-- Pills and fire do their own things here
		updatePill(dt)
		updateFire(dt)
		
		-- If all pills have been collected
		if noPills() == false then
				
			if walle_y < -240 then -- Wait for the wall to finish moving before starting the Alex fight
			
				if level_x == -2048 + 400 then
					stateBATTLEStart()
				end
				
			elseif walle_y ~= -240 then -- If the wall is still on screen:
				-- move it!
				walle_y = walle_y - (1 * dt * 60)
			end
			
		end
		
	end
	
	if game_state == "BATTLE" then
		updateBoss(dt)
		
		-- This function contains the end game functions (see bullet.lua)
		updateBullet(dt)
	end
	
end
-- END START

-- ******************************* THIS IS THE MAIN GAME DRAW FUNCTION **************************************
function drawGame()

-- This must be called for the 3DS
drawTopScreen()
	
	if game_state == "LOAD" then
		
		-- LovePotion's love.graphics.rectangle is broken in line mode
		love.graphics.rectangle("line", 50, 96, 300, 48)
			loadBar = (math.max(0, math.floor((timer - loadStart) / 2)) + 1) / 10
		love.graphics.rectangle("fill", 56, 102, 288 * loadBar, 36)
		
		-- This fixes the LovePotion bug
		love.graphics.line(49, 96, 49, 96 + 48)
		love.graphics.print("loading, please wait...", 248, 216)
		
	end
	
	if game_state == "HOKSY" then
		love.graphics.setColor(255, 255, 255, me_transparent)
		love.graphics.draw(me, 0, 0)
		
		love.graphics.setColor(c_white)
	end
	
	if game_state == "TITLE_SCREEN" then
		love.graphics.setColor(c_white)
		love.graphics.draw(title_top, 0, 0)
	end
	
	if game_state == "START" then
		-- _setDepth() is how many pixels apart you want a sprite to be
		-- they're used as a sort of make-shift photoshop layers here
		_setDepth(16)
		love.graphics.draw(level1, level_x, 0) -- the 3DS doesn't like 2048 pixels at a time, so it's split up into two 1024 chunks
		love.graphics.draw(level2, level_x + 1024, 0)
		
		_setDepth(12)
		drawFire()
		
		_setDepth(8)
		drawPill()
		
		if walle_y ~= -240 then
			love.graphics.draw(walle, 1780 + level_x, walle_y)
			love.graphics.setColor(c_black)
			love.graphics.print(getFalsePills() .. "/41", 1780 + level_x + 8, walle_y + 24)
			love.graphics.setColor(c_white)
		end
		
		_setDepth(0)
		-- xorigin fixes a stupid bug with LovePotion
		xorigin = 0
		if guy_scale == -1 then
			xorigin = 32
		end
		
		yextra = math.max(getSlider() * 240, 40)
		
		-- draw the player!
		love.graphics.draw(guy_image, 90 + xorigin, 200 - yextra + 40, 0, guy_scale, 1, 0, 0)
	end
	
	if game_state == "BATTLE" then
		_setDepth(16)
		love.graphics.draw(level2, -1024 + 400, 0)
		
		_setDepth(8)
		drawBoss()
		drawBullet()
		
		-- This has some repeated code from above that should be put in a function
		_setDepth(0)
		xorigin = 0
		if guy_scale == -1 then
			xorigin = 32
		end
		
		yextra = math.max(getSlider() * 240, 40)
		
		love.graphics.draw(guy_image, 90 + xorigin, 200 - yextra + 40, 0, guy_scale, 1, 0, 0)
	end
	
	if game_state == "GAME_OVER" then
		_setDepth(16)
		love.graphics.draw(game_over1, 0, 0)
		
		_setDepth(8)
		
		-- When you die in the game, you need to ascend to respawn
		-- This makes sure the 3D slider was reset before ascending
		if slide_lock == false then
		
			yextra = math.max(getSlider() * 240, 40)
			
			-- ONCE YOU HAVE ASCENDED!!!
			if yextra == 240 then
				--RELOAD GAME
				stateSTARTRestart()
			end
			
		else
		
			yextra = math.max(getSlider() * 240, 40)
			
			if yextra == 40 then
				slide_lock = false
			end
			
			-- Stay at a y value of 40 until YOU HAVE ASCENDED
			yextra = 40
			
		end
		-- end slide_lock == false
		
		-- This is a funny trick
		
		-- Draw the guy as normal
		love.graphics.draw(guy1, 200 + xorigin - 16, 200 - yextra + 40, 0, guy_scale, 1, 0, 0)
		love.graphics.setColor(255, 255, 255, yextra + 15)
		
		-- Draw a guy sprite that is ALL WHITE and use transparency to overlay it over the guy as he ascends
		love.graphics.draw(guy4, 200 + xorigin - 16, 200 - yextra + 40, 0, guy_scale, 1, 0, 0)
		love.graphics.setColor(c_white)
		
	end
	
	if game_state == "WIN" then
		love.graphics.draw(end1, 0, 0)
	end
	
-- The touch screen is hardly used in this game
drawBottomScreen()
	
	if game_state == "TITLE_SCREEN" then
		love.graphics.draw(title_bot, 0, 0)
	end
	
	if game_state == "START" then
		love.graphics.draw(pill1, 16, 16)
		love.graphics.print("x " .. getFalsePills() .. " / 41", 40, 16)
	end
	
	if game_state == "GAME_OVER" then
		love.graphics.draw(game_over2, 0, 0)
	end
	
	if game_state == "WIN" then
		love.graphics.draw(end2, 0, 0)
	end
	
drawBottomScreenEnd()
end