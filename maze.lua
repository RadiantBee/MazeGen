--[[
-- node can have dirrection:
-- 0 - no dirrection (origin node)
-- 1 - up
-- 2 - right
-- 3 - down
-- 4 - left
--]]

local function createMaze(width, height, nodeSize)
	local nodeDraw = {}
	nodeDraw[0] = {
		x = 0,
		y = 0, -- position correction (+/- nodeSize)
		width = 1,
		height = 1, -- size correction (* nodeSize)
	}
	nodeDraw[1] = {
		x = 0,
		y = -1,
		width = 1,
		height = 2,
	}
	nodeDraw[2] = {
		x = 0,
		y = 0,
		width = 2,
		height = 1,
	}
	nodeDraw[3] = {
		x = 0,
		y = 0,
		width = 1,
		height = 2,
	}
	nodeDraw[4] = {
		x = -1,
		y = 0,
		width = 2,
		height = 1,
	}
	local maze = {
		width = width or 10,
		height = height or 10,
		nodeSize = nodeSize or 20,
		matrix = {},
		origin = {
			x = nil,
			y = nil,
		},
		nodeDraw = nodeDraw,
		initMap = function(self)
			self.matrix = {}
			for x = 1, self.width, 1 do
				self.matrix[x] = {}
				for y = 1, self.height, 1 do
					self.matrix[x][y] = 0
				end
			end
			for i = 0, 4, 1 do
				self.nodeDraw[i].x = nodeDraw[i].x * self.nodeSize
				self.nodeDraw[i].y = nodeDraw[i].y * self.nodeSize
				self.nodeDraw[i].width = nodeDraw[i].width * self.nodeSize
				self.nodeDraw[i].height = nodeDraw[i].height * self.nodeSize
			end
		end,
		prepareMap = function(self)
			for x = 1, self.width, 1 do
				for y = 1, self.height, 1 do
					if x ~= self.width then
						self.matrix[x][y] = 2
					else
						self.matrix[x][y] = 3
					end
				end
			end
			self.matrix[self.width][self.height] = 0
			self.origin.x = self.width
			self.origin.y = self.height
		end,
		print = function(self)
			for y = 1, self.height, 1 do
				for x = 1, self.width, 1 do
					io.write(self.matrix[x][y] .. " ")
				end
				io.write("\n")
			end
		end,
		stepChange = function(self)
			local canGo = {}
			if self.origin.y - 1 > 0 then
				table.insert(canGo, { self.origin.x, self.origin.y - 1, 1 })
			end
			if self.origin.x + 1 <= self.width then
				table.insert(canGo, { self.origin.x + 1, self.origin.y, 2 })
			end
			if self.origin.y + 1 <= self.height then
				table.insert(canGo, { self.origin.x, self.origin.y + 1, 3 })
			end
			if self.origin.x - 1 > 0 then
				table.insert(canGo, { self.origin.x - 1, self.origin.y, 4 })
			end
			local direction = canGo[math.random(#canGo)]
			self.matrix[self.origin.x][self.origin.y] = direction[3]
			self.origin.x = direction[1]
			self.origin.y = direction[2]
			self.matrix[self.origin.x][self.origin.y] = 0
		end,
		fullChange = function(self)
			for _ = 1, self.width * self.height * 10, 1 do
				self:stepChange()
			end
		end,
		draw = function(self, x, y, colorWall, colorFree)
			love.graphics.setColor(colorWall or { 1, 1, 1 })
			love.graphics.rectangle(
				"fill",
				x,
				y,
				self.nodeSize * self.width * 2 + self.nodeSize,
				self.nodeSize * self.height * 2 + self.nodeSize
			)
			love.graphics.setColor(colorFree or { 0, 0, 0 })
			for yi = 1, self.height, 1 do
				for xi = 1, self.width, 1 do
					love.graphics.rectangle(
						"fill",
						x + self.nodeSize + (xi - 1) * 2 * self.nodeSize + self.nodeDraw[self.matrix[xi][yi]].x,
						y + self.nodeSize + (yi - 1) * 2 * self.nodeSize + self.nodeDraw[self.matrix[xi][yi]].y,
						self.nodeDraw[self.matrix[xi][yi]].width,
						self.nodeDraw[self.matrix[xi][yi]].height
					)
				end
			end
			love.graphics.setColor(1, 1, 1)
		end,
	}

	return maze
end

return createMaze
