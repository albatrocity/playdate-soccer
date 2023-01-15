local pd <const> = playdate

function inputControls(characterActions)
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
		characterActions['sprint']()
	else
		characterActions['run']()
	end

	if pd.buttonJustPressed(pd.kButtonA) then
		characterActions['jump']()
	end

	local newPositionX, newPositionY = characterActions['getNewPosition'](xDelta, yDelta)
	characterActions['move'](newPositionX, newPositionY)
end