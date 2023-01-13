local pd <const> = playdate
local gfx <const> = pd.graphics

local runSpeed <const> = 5
local sprintSpeed <const> = 10

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
	self.speed = runSpeed
end

function Character:getNewPosition(xDelta, yDelta)
	return self.x + (xDelta * self.speed), self.y + (yDelta * self.speed)
end

function Character:movePlayer(ball)
	local yDelta = 0
	local xDelta = 0


	if playdate.buttonIsPressed( playdate.kButtonUp ) then
		yDelta = -1
	end
	if playdate.buttonIsPressed( playdate.kButtonRight ) then
		xDelta = 1
	end
	if playdate.buttonIsPressed( playdate.kButtonDown ) then
		yDelta = 1
	end
	if playdate.buttonIsPressed( playdate.kButtonLeft ) then
		xDelta = -1
	end

	if playdate.buttonIsPressed( playdate.kButtonB ) then
		self.speed = sprintSpeed
	else 
		self.speed = runSpeed
	end
	
	local newPositionX, newPositionY = self:getNewPosition(xDelta, yDelta)
	
	local actualX, actualY, collisions, collisionsLen = self:moveWithCollisions( newPositionX, newPositionY )
	if (collisionsLen ~= 0) then
		local col = collisions[1]
		local normal = col['normal']
		local move =   col['move']
		if col['other']:isa(Ball) then
			local kickSpeed = math.max(math.abs(move.dx), math.abs(move.dy))
			ball:kick(normal.dx, normal.dy, kickSpeed + self.speed)
		end
	end
end

function Character:collisionResponse(other)
	if other:isa(Ball) then
		return 'overlap'
	end
	if other:isa(FieldBoundary) then
		return 'slide'
	end
end