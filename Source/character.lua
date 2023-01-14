local pd <const> = playdate
local gfx <const> = pd.graphics

local runSpeed <const> = 5
local sprintSpeed <const> = 10

class('Character').extends(gfx.sprite)

function Character:init(x, y, r)
	Character.super.init(self)
	self:moveTo(x, y)
	local circleImage = gfx.image.new(r*2, r*2, gfx.kColorBlack)
	self:setImage(circleImage)
	self:setCollideRect(0, 0, r*2, r*2)
	-- self:setGroups(1)
	-- self:setCollidesWithGroups(2)
	self.speed = runSpeed
	self.jumpingAnimator = gfx.animator.new(1, 1, 2, pd.easingFunctions.outCubic)
	self.jumpingAnimator.reverses = true
end

function Character:getNewPosition(xDelta, yDelta)
	return self.x + (xDelta * self.speed), self.y + (yDelta * self.speed)
end

function Character:isJumping()
	return self.jumpingAnimator:currentValue() ~= 1
end

function Character:kickBall(collision, ball)
	local normal = collision['normal']
	local move =   collision['move']
	if collision['other']:isa(Ball) and self:isJumping() == false then
		local kickSpeed = math.max(math.abs(move.dx), math.abs(move.dy))
		ball:kick(normal.dx, normal.dy, kickSpeed + self.speed)
	end
end

function Character:movePlayer(ball)
	local yDelta = 0
	local xDelta = 0


	if pd.buttonIsPressed( pd.kButtonUp ) then
		yDelta = -1
	end
	if pd.buttonIsPressed( pd.kButtonRight ) then
		xDelta = 1
	end
	if pd.buttonIsPressed( pd.kButtonDown ) then
		yDelta = 1
	end
	if pd.buttonIsPressed( pd.kButtonLeft ) then
		xDelta = -1
	end

	if pd.buttonIsPressed( pd.kButtonB ) then
		self.speed = sprintSpeed
	else 
		self.speed = runSpeed
	end
	
	if pd.buttonJustPressed(pd.kButtonA) and self.jumpingAnimator:currentValue() == 1 then
		self.jumpingAnimator:reset(350)
	end	
	
	self:setScale(self.jumpingAnimator:currentValue())
	local newPositionX, newPositionY = self:getNewPosition(xDelta, yDelta)
	
	local actualX, actualY, collisions, collisionsLen = self:moveWithCollisions( newPositionX, newPositionY )
	if (collisionsLen ~= 0) then
		local col = collisions[1]
		self:kickBall(col, ball)
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