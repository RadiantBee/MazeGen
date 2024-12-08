local Button = require("button")
local Entry = require("entry")

return {
	resetButton = Button("Reset", nil, nil, 600, 100, 100, 20),
	generateButton = Button("Generate New", nil, nil, 600, 130, 100, 20),
	stepChangeButton = Button("One step", nil, nil, 600, 160, 100, 20),
	timerChangeButton = Button("Start timer", nil, nil, 600, 190, 100, 20),

	timerChangeEntry = Entry(710, 190, 100, 20),

	mousepressed = function(self, x, y)
		self.resetButton:onClick(x, y)
		self.generateButton:onClick(x, y)
		self.stepChangeButton:onClick(x, y)
		self.timerChangeButton:onClick(x, y)

		self.timerChangeEntry:onClick(x, y)
	end,

	onKeyboardPress = function(self, key)
		if tonumber(key) or key == "backspace" then
			self.timerChangeEntry:onKeyboardPress(key)
		end
	end,

	draw = function(self, mouseX, mouseY)
		self.resetButton:draw(nil, nil, mouseX, mouseY, 33, 2)
		self.generateButton:draw(nil, nil, mouseX, mouseY, 8, 2)
		self.stepChangeButton:draw(nil, nil, mouseX, mouseY, 23, 2)
		self.timerChangeButton:draw(nil, nil, mouseX, mouseY, 17, 2)

		self.timerChangeEntry:draw()
	end,
}
