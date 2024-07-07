require "game"

-- COLOR CONSTANTS
c_white = {255, 255, 255, 255}
c_black = {0, 0, 0, 255}
c_red = {255, 0, 0, 255}
c_blue = {0, 0, 255, 255}

-- Some initial checks for operating system
global_os = love.system.getOS()
os_model = "pc"
if global_os == "3ds" then
	os_model = love.system.getModel()
else
	love.window.setMode(400, 480)
	
	--Enable debug features on windows
	--require "lume"
	--lurker = require "lurker"
end

-- Cross platform screen switching
function drawTopScreen()
	if global_os == "3ds" then
		love.graphics.setScreen("top")
	end
end

-- More cross platform screen switching
function drawBottomScreen()
	if global_os ~= "3ds" then
		love.graphics.push()
		love.graphics.translate((400 - 320) / 2, 240)
	else
		love.graphics.setScreen("bottom")
	end
end

-- Even more cross platform screen switching
function drawBottomScreenEnd()
	if global_os ~= "3ds" then
		love.graphics.pop()
	else
		love.graphics.setScreen("top")
	end
end

-- ********************** START OF GAME CODE *******************************
function love.load()
	timer = 0
	math.randomseed(os.time())
end

function love.update(dt)
	if os_model == "pc" then
		--require("lurker").update()
	end
	
	updateGame(dt)
end

function love.draw()
	drawGame()
end