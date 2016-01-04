appTransitionComplete = false
lastUpdateTime = 0

happyColor = { 1, .6, 0, 1 }
unhappyColor = { 0.02, 0.003, 0.15, 1 }
local baseColor = { 1, 1, 1, .1 }

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

function GetBkgndColorForPhase( phase, ratio )
	if phase == 0 then
		return baseColor, unhappyColor, 'up'
		
	elseif phase == 1 then
		newC1 = baseColor
		newC2 = unhappyColor
		newC1[4] = ratio
		newC2[4] = 1 - newC1[4]
		return newC1, newC2, 'up'
		
	elseif phase == 2 then
		newC1 = happyColor
		newC2 = unhappyColor
		newC1[4] = ratio
		newC2[4] = 1 - newC1[4]		
		return newC1, newC2,  "down"
		
	elseif phase == 3 then
		newC1 = baseColor
		newC2 = happyColor
		newC2[4] = ratio
		newC1[4] = 1 - newC2[4]		
		return newC1, newC2, 'up'
		
	else
		return happyColor, happyColor, 'up'
		
	end
end

function mcFadeOutDone( musicCredits )
	transition.to( musicCredits, {alpha=.5,time=5000,onComplete=mcFadeInDone} )
end

function mcFadeInDone( musicCredits )
	transition.to( musicCredits, {alpha=0,time=5000,onComplete=mcFadeOutDone} )
end

particleDesigner = require( "particleDesigner" )

widget1 = require( 'wordrain.wordrain' )
widget2 = require( 'followcircle.followcircle' )
widget3 = require( 'drawlines.drawlines' )

--widget1.TransitionIn( 1 )
--widget2.TransitionIn( 1 )
widget3.TransitionIn( 1 )