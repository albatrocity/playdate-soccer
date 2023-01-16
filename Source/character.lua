local pd <const> = playdate
local gfx <const> = pd.graphics

local runSpeed <const> = 5
local sprintSpeed <const> = 12

class('Character').extends(gfx.sprite)

function Character:init(x, y, r, config)
	Character.super.init(self)
	self:moveTo(x, y)
	local circleImage = gfx.image.new(r*2, r*2, gfx.kColorBlack)
	self:setImage(circleImage)
	self:setCollideRect(0, 0, r*2, r*2)
	-- self:setGroups(1)
	-- self:setCollidesWithGroups(2)
	local baseSpeed = config['baseSpeed'] == nil and 1 or config['baseSpeed']
	self.baseSpeed = baseSpeed
	self.speed = runSpeed * (baseSpeed == nil and 1 or baseSpeed)
	self.jumpingAnimator = gfx.animator.new(1, 1, 2, pd.easingFunctions.outCubic)
	self.jumpingAnimator.reverses = true
	self.inputControls = config['inputControls']

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

function Character:kickBall(collision)
	local normal = collision['normal']
	local move =   collision['move']


	-- local playerRect = collision['spriteRect']
	-- local touch = collision['touch']
	local ball = collision['other']

	if not self:isJumping() then
		ball:kick(normal.dx, normal.dy, self.speed)
	end
end


function Character:update()
	local characterActions = {}
	local character = self

	function characterActions.move(x, y)
		character:move(x, y)
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

	self.inputControls(character, characterActions)
end

function Character:move(x, y)
	local futureX = x == nil and self.x or x
	local futureY = y == nil and self.y or y
	local actualX, actualY, collisions, collisionsLen = self:moveWithCollisions(futureX, futureY)
	local scale = self.jumpingAnimator:currentValue()
	self:setScale(scale)
	local origWidth = self.width / scale
	local rectOffset = scale == 1 and 0 or self.width / 2 / 2
	self:setCollideRect(0 + rectOffset, 0 + rectOffset, self.width / scale, self.height / scale)
	if (collisionsLen ~= 0) then
		local col = collisions[1]
		if (col['other']:isa(Ball)) then
			self:kickBall(col)
		end
	end
end

function Character:collisionResponse(other)
	if other:isa(Ball) and self:isJumping() then
		return 'overlap'
	end
	if other:isa(FieldBoundary) then
		return 'slide'
	end
	if other:isa(Character) and (other:isJumping() or self:isJumping()) then
		return 'overlap'
	end
	if other:isa(Character) and not other:isJumping() then
		return 'slide'
	end
end