local CreateMaze = require("maze")
local ui = require("ui")

local mouseX, mouseY = 0, 0

local stepTimer = {
	time = 0,
	maxTime = 100,
	active = false,
	triggered = false,
	tick = function(self, dt)
		if self.active then
			self.time = self.time + dt
			if self.time > self.maxTime / 1000 then
				self.time = 0
				self.triggered = true
			else
				self.triggered = false
			end
		end
	end,
}

local maze = CreateMaze()
function love.load()
	math.randomseed(os.time())
	maze:initMap()
	maze:prepareMap()
	maze:fullChange()
	ui.resetButton.func = function(map)
		map:prepareMap()
	end
	ui.resetButton.funcArgs = maze

	ui.generateButton.func = function(map)
		map:fullChange()
	end
	ui.generateButton.funcArgs = maze

	ui.stepChangeButton.func = function(map)
		map:stepChange()
	end

	ui.stepChangeButton.funcArgs = maze

	ui.timerChangeButton.func = function(timerAndButton)
		timerAndButton[2].text = timerAndButton[1].active and "Start timer" or "Stop timer"
		timerAndButton[1].active = not timerAndButton[1].active
	end
	ui.timerChangeButton.funcArgs = { stepTimer, ui.timerChangeButton }

	ui.timerChangeEntry.text = tostring(stepTimer.maxTime)
end

function love.mousepressed(x, y)
	ui:mousepressed(x, y)
end

function love.keypressed(key)
	ui:onKeyboardPress(key)
	stepTimer.maxTime = tonumber(ui.timerChangeEntry.text) or 0
	ui.timerChangeEntry.text = tostring(stepTimer.maxTime)
end

function love.update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	if stepTimer.triggered and stepTimer.active then
		maze:stepChange()
	end

	stepTimer:tick(dt)
end

function love.draw()
	maze:draw(100, 100)
	ui:draw(mouseX, mouseY)
end
