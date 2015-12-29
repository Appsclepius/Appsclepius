
function randomSign( reseed, modulo )
	if reseed then
		math.randomseed(os.time())
	end
	
	if math.random(100) % modulo == 0 then
		return -1
	else
		return 1
	end
end

wordRainWidget = require( 'wordrain' )
wordRainWidget.TransitionIn( 1 )