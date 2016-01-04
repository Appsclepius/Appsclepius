local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed(os.time())

followCircleWidget = {}
followCircleWidget.screen = display.newGroup()

local bkgnd = display.newRect(followCircleWidget.screen, 0, 0, display.contentWidth, display.actualContentHeight, 18 )
c1, c2, dir = GetBkgndColorForPhase( 0 )
bkgnd:setFillColor( {
	type = 'gradient',
	color1 = c1,
	color2 = c2,
	direction = dir
} )
bkgnd.anchorX = 0
bkgnd.anchorY = 0
transition.to( followCircleWidget.screen, { y = display.contentHeight * -1, alpha=0, time = 0, transition = easing.outQuad } )


local theCircle
local wanderDirX = 0
local wanderDirY = 0
local wanderAngle = 0.1
local cDist = 0
local emitter1 = nil
local emitter2 = nil
local lastFrameTime = 0
local completionTime = 500 * 60
local completionTimeLeft = completionTime
local circleScaleTransition = nil
local emitter1ScaleTransition = nil
local onTheCircleLastFrame = false

function UpdateWanderDir()
	-- Generate movement
	cDist = theCircle.path.radius * 1.1 * theCircle.xScale 
	local turnScale = theCircle.xScale*10 + (1 - theCircle.xScale)*3
	wanderDirX = ( wanderDirX * cDist ) + turnScale*math.cos( wanderAngle ) 
	wanderDirY = ( wanderDirY * cDist ) + turnScale*math.sin( wanderAngle )

	-- Normalize the movement
	local length =  math.sqrt( (wanderDirX*wanderDirX) + (wanderDirY*wanderDirY) )
	wanderDirX = wanderDirX / length
	wanderDirY = wanderDirY / length
	
	-- Scale the movement
	local amp = theCircle.xScale*2 + (1 - theCircle.xScale)*3
	wanderDirX = amp * wanderDirX
	wanderDirY = amp * wanderDirY
	
	-- Set limit boundary
	cDist = cDist / 1.1
	
	-- Limit X movement
	if theCircle.x+wanderDirX > display.actualContentWidth-cDist then
		local collision =  ( display.actualContentWidth - ( theCircle.x+wanderDirX ) ) / cDist
		wanderDirX = wanderDirX * ( collision*0 + ( 1 - collision ) * -1.5 )
		if math.abs( wanderDirX ) < 0.1 then
			wanderDirX = -0.5
		end
	elseif theCircle.x+wanderDirX < cDist then
		local collision =  ( theCircle.x+wanderDirX ) / cDist
		wanderDirX = wanderDirX * ( collision*0 + ( 1 - collision ) * -1.5 )
		if math.abs( wanderDirX ) < 0.1 then
			wanderDirX = 0.5
		end
	end
	
	-- Limit Y movement
	if theCircle.y+wanderDirY > display.actualContentHeight-cDist then
		local collision =  ( display.actualContentHeight - ( theCircle.y+wanderDirY ) ) / cDist
		wanderDirY = wanderDirY * ( collision*0 + ( 1 - collision ) * -1.5 )
		if math.abs( wanderDirY ) < 0.1 then
			wanderDirY = -0.5
		end
	elseif theCircle.y+wanderDirY < cDist then
		local collision =  ( theCircle.y+wanderDirY ) / cDist
		wanderDirY = wanderDirY * ( collision*0 + ( 1 - collision ) * -1.5 )
		if math.abs( wanderDirY ) < 0.1 then
			wanderDirY = 0.5
		end
	end	
	
	-- Tweak the wander angle
	wanderAngle = wanderAngle + ( ( math.random( 0, 100 ) / 100 )  * .5 ) - .35

end

function UpdateBkgndFill()
	if theCircle.xScale > 0.7 then
		c1, c2, dir = GetBkgndColorForPhase( 1, (1-theCircle.xScale)/0.3 )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
	elseif theCircle.xScale > 0.4 then
		c1, c2, dir = GetBkgndColorForPhase( 2, (0.7-theCircle.xScale)/0.3 )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
	elseif theCircle.xScale > 0.105 then
		c1, c2, dir = GetBkgndColorForPhase( 3, (0.4-theCircle.xScale)/0.3 )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
	else
		c1, c2, dir = GetBkgndColorForPhase( 4 )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
	end
end

followCircleWidget.touchListener = function( event )
	local onTheCircle = true
	if event.phase == 'began' or event.phase == 'moved' then
		local distToCenter = math.sqrt( ( ( event.x - theCircle.x ) * ( event.x - theCircle.x )  ) +
		                                                  ( ( event.y - theCircle.y + 44 ) * ( event.y - theCircle.y + 44 )  ) )
		--print( distToCenter, theCircle.path.radius * 1.1 * theCircle.xScale )
		if distToCenter >  theCircle.path.radius * 1.1 * theCircle.xScale then
			onTheCircle = false
		end
	elseif event.phase == 'ended' or event.phase == 'cancelled' then
		onTheCircle = false
	end
	
	if onTheCircle then
		if not onTheCircleLastFrame then
			emitter1:start()
			emitter2:start()
			--- Slowly shrink the circle
			if circleScaleTransition then
				transition.cancel( circleScaleTransition )
				transition.cancel( emitter1ScaleTransition )
			end
			circleScaleTransition = transition.to( theCircle, { xScale = 0.1, yScale = 0.1, time=completionTimeLeft } )
			emitter1ScaleTransition = transition.to( emitter1, { xScale = 0.01, yScale = 0.01, time=completionTimeLeft } )
		end
	else
		emitter1:stop()
		emitter2:stop()
		--- Slowly grow the circle
		transition.cancel( circleScaleTransition )
		transition.cancel( emitter1ScaleTransition )
		circleScaleTransition = transition.to( theCircle, { xScale = 1, yScale = 1, time=completionTime - completionTimeLeft } )
		emitter1ScaleTransition = transition.to( emitter1, { xScale = 1, yScale = 1, time=completionTime - completionTimeLeft } )
	end
	onTheCircleLastFrame = onTheCircle
end

followCircleWidget.enterFrame = function( event )
	local frameTime = event.time - lastFrameTime
	if event.time - lastUpdateTime > 100 then
		-- Move stuff
		transition.to( theCircle, { x = theCircle.x+wanderDirX, y = theCircle.y+wanderDirY, time=100 } )
		transition.to( emitter1, { x = theCircle.x+wanderDirX, y = theCircle.y+wanderDirY, time=100 } )
		transition.to( emitter2, { x = theCircle.x+wanderDirX, y = theCircle.y+wanderDirY, time=100 } )
		
		UpdateWanderDir()
		UpdateBkgndFill()

		lastUpdateTime = event.time
	end
	
	if onTheCircleLastFrame then
		if completionTimeLeft > 0 then
			completionTimeLeft = completionTimeLeft - frameTime
		end
	else
		if completionTimeLeft < completionTime then
			completionTimeLeft = completionTimeLeft + frameTime
		end
	end
			
	lastFrameTime = event.time
end

followCircleWidget.TransitionOutComplete = function( screen )
	theCircle:removeSelf()
	theCircle = nil
	emitter1:removeSelf()
	emitter1 = nil 
	emitter2:removeSelf()
	emitter2 = nil
	appTransitionComplete = true
end

followCircleWidget.TransitionOut = function( time )
	-- Transition Screen out
	transition.to( followCircleWidget.screen, { y = -display.contentHeight, alpha=0, time = time, transition = easing.outQuad, onComplete=followCircleWidget.TransitionOutComplete } )
	
	-- Stop and clear background music
	audio.stop( backgroundMusic )
	audio.dispose( backgroundMusic )
	audio.setMaxVolume( 1, { channel=1 } )	
	
--~ 	audio.stop( clickSound )
--~ 	audio.dispose( clickSound )
--~ 	audio.setMaxVolume( 1, { channel=2 } )

	-- Stop the emitters
	emitter1:stop()
	emitter2:stop()
	
	-- Remove the frame update
	Runtime:removeEventListener( "enterFrame", followCircleWidget.enterFrame )
	Runtime:removeEventListener( "touch", followCircleWidget.touchListener )
	
end
	
followCircleWidget.TransitionIn = function( time )
	-- Transition Screen In
	transition.to( followCircleWidget.screen, { y = display.screenOriginY, alpha=1, time = time, transition = easing.outQuad } )

	-- Create the circle
	theCircle = display.newCircle( followCircleWidget.screen, display.actualContentWidth/2, display.actualContentHeight/2, display.actualContentWidth/3 )
	theCircle.fill = happyColor
	
	-- Slowly rotate the circle
	transition.to( theCircle, { rotation=-360, time=10000, iterations=30 } )
	
	-- Particle effects
	emitter1 = particleDesigner.newEmitter( 'followcircle\\blue_galaxy.json' )
	followCircleWidget.screen:insert( emitter1 )
	transition.to( emitter1, { x=display.actualContentWidth/2, y=display.actualContentHeight/2, time=0 } )
	emitter1:pause()
	
	emitter2 = particleDesigner.newEmitter( 'followcircle\\my_galaxy.json' )
	followCircleWidget.screen:insert( emitter2 )
	transition.to( emitter2, { x=display.actualContentWidth/2, y=display.actualContentHeight/2, time=0 } )
	emitter2:pause()
	
	-- Start background music
	backgroundMusic = audio.loadStream( "followcircle\\ripples.mp3" )
	audio.play( backgroundMusic, { channel=1, loops = -1, fadein = 10000 } )
	audio.setMaxVolume( 0.2, { channel=1 } )
	
	-- Music Credit
	local musicCredit = display.newGroup()
	followCircleWidget.screen:insert( musicCredit )	
	local myText1 = display.newText( "Music: Ripples by Kevin MacLeod", display.actualContentWidth/2, display.actualContentHeight-40, native.systemFont, 12 )
	musicCredit:insert( myText1 )
	local myText2 = display.newText( "http://incompetech.com/music/", display.actualContentWidth/2, display.actualContentHeight-20, native.systemFont, 10 )
	musicCredit:insert( myText2 )
	transition.to( musicCredit, {alpha=0,time=10000,onComplete=mcFadeOutDone} )

	-- Load click sound
--~ 	clickSound = audio.loadSound( "chime.wav" )
--~ 	audio.setMaxVolume( 0.03, { channel=2 } )
--~ 	local cText1 = display.newText( "Sound by JustinBW", display.actualContentWidth/2, 20, native.systemFont, 10 )
--~ 	clickCredit:insert( cText1 )
--~ 	local cText2 = display.newText( "http://bit.ly/1NOY9GJ", display.actualContentWidth/2, 40, native.systemFont, 10 )
--~ 	clickCredit:insert( cText2 )
--~ 	clickCredit.alpha = 0

	-- Start up the wander by picking a random direction
	wanderDirX = ( math.random( 0, 100 ) / 100 ) * randomSign( false, 3 )
	wanderDirY = ( math.random( 0, 100 ) / 100 ) * randomSign( false, 3 )
	
	-- Add the frame update
	Runtime:addEventListener( "enterFrame", followCircleWidget.enterFrame )
	
	--standard touch listener on an object
	Runtime:addEventListener( "touch", followCircleWidget.touchListener )
	
end

return followCircleWidget