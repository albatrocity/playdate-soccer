import "character"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ball').extends(gfx.sprite)

function Ball:init(x, y, r)
	Ball.super.init(self)
	self:moveTo(x, y)
	local circleImage = gfx.image.new(r*2, r*2)
	gfx.pushContext(circleImage)
		gfx.fillCircleAtPoint(r, r, r)
	gfx.popContext()
	self:setImage(circleImage)
	self:setCollideRect(0, 0, r*2, r*2)
	-- self:setGroups(2)
	-- self:setCollidesWithGroups(1)
	
	self.speed = 1
	self.directionXDelta = -1
	self.directionYDelta = -1
	self.inertiaAnimator = gfx.animator.new(1000, 0, 0, pd.easingFunctions.outBounce)
end

function Ball:setDirectionDelta(newXDelta, newYDelta)
	if newXDelta ~= 0 then
		self.directionXDelta = newXDelta
	end
	if newYDelta ~= 0 then
		self.directionYDelta = newYDelta
	end
end

function Ball:kick(dx, dy, speed)
	print(speed)
	self.speed = speed
	self.inertiaAnimator = gfx.animator.new(1000, speed, 0, pd.easingFunctions.outBounce)
	self:setDirectionDelta(dx, dy)
end

function Ball:update()
	Ball.super.update(self)
	
	-- self.speed = self.inertiaAnimator:currentValue()
	
	local actualX, actualY, collisions, collisionsLen = 
		self:moveWithCollisions(
			self.x + (self.directionXDelta * self.speed), 
			self.y + (self.directionYDelta * self.speed)
		)
	
	if (collisionsLen ~= 0) then
		local col = collisions[1]
		local normal = col['normal']
		self:setDirectionDelta(normal.dx, normal.dy)
		self.inertiaAnimator = gfx.animator.new(1000, self.speed, 0, pd.easingFunctions.outBounce)
	end
end

function Ball:collisionResponse(other)
	return 'bounce'
end