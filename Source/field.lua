import "fieldBoundary"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry
local thickness <const> = 10
local dWidth <const> = 400
local dHeight <const> = 240


class('Field').extends()

function Field:init()
	local left 	 = FieldBoundary(thickness/2, dHeight/2, thickness, dHeight)
	local right  = FieldBoundary(dWidth - (thickness/2), dHeight/2, thickness, dHeight)
	local top 	 = FieldBoundary(dWidth/2, thickness/2, dWidth-(thickness*2), thickness)
	local bottom = FieldBoundary(dWidth/2, dHeight - thickness/2, dWidth-(thickness*2), thickness)
	
	left:add()
	right:add()
	top:add()
	bottom:add()
end

