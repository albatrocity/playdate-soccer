local pd <const> = playdate
local gfx <const> = pd.graphics

class('Character').extends(gfx.sprite)

function Character:init(x, y, r)
	Character.super.init(self)
	self:moveTo(x, y)
	local circleImage = gfx.image.new(r*2, r*2)
	gfx.pushContext(circleImage)
		gfx.fillCircleAtPoint(r, r, r)
	gfx.popContext()
	self:setImage(circleImage)
	self:setCollideRect(0, 0, r*2, r*2)
	-- self:setGroups(1)
	-- self:setCollidesWithGroups(2)
	self.speed = 5
end

function Character:getNewPosition(xDelta, yDelta)
	return self.x + (xDelta * self.speed), self.y + (yDelta * self.speed)
end

function Character:collisionResponse(other)
	return 'overlap'
end