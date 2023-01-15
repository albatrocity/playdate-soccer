local pd <const> = playdate
local gfx <const> = pd.graphics

local runSpeed <const> = 5
local sprintSpeed <const> = 10

class('Character').extends(gfx.sprite)

function Character:init(x, y, r, inputControls)
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
	self.inputControls = inputControls
end

function Character:getNewPosition(xDelta, yDelta)
	return self.x + (xDelta * self.speed), self.y + (yDelta * self.speed)
end

function Character:jump()
	if self:isJumping() ~= true then
		self.jumpingAnimator:reset(350)
	end
end

function Character:isJumping()
	return self.jumpingAnimator:currentValue() ~= 1
end

function Character:kickBall(collision, ball)
	local normal = collision['normal']
	local move =   collision['move']

	-- local playerRect = collision['spriteRect']
	-- local touch = collision['touch']


	if collision['other']:isa(Ball) and self:isJumping() == false then
		local kickSpeed = math.max(math.abs(move.dx), math.abs(move.dy))
		ball:kick(normal.dx, normal.dy, kickSpeed + self.speed)
	end
end


function Character:updateWithBall(ball)
	local characterActions = {}
	local character = self

	function characterActions.move(x, y)
		character:move(x, y, ball)
	end
	function characterActions.jump()
		character:jump()
	end
	function characterActions.sprint()
		character.speed = sprintSpeed
	end
	function characterActions.run()
		character.speed = runSpeed
	end
	function characterActions.getNewPosition(xDelta, yDelta)
		return character:getNewPosition(xDelta, yDelta)
	end

	self.inputControls(characterActions)
end

function Character:move(x, y, ball)
	local actualX, actualY, collisions, collisionsLen = self:moveWithCollisions( x, y )
	self:setScale(self.jumpingAnimator:currentValue())
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
	if other:isa(Character) and self:isJumping() ~= true then
		return 'slide'
	end
	if other:isa(Character) and self:isJumping() == true then
		return 'overlap'
	end
end