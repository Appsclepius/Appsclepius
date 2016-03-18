local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar ) 
--math.randomseed(os.time())

-- Basic widget and screen
templateWidget = {}
templateWidget.screen = nil

local bkgnd = nil

-- Frame Update
templateWidget.enterFrame = function( event )
end

-- Transition Out completed, Finish Cleanup
templateWidget.TransitionOutComplete = function( screen )
	transition.cancel()

	-- Remove Controls
	display.remove( bkgnd )
	bkgnd = nil	
	
	display.remove( templateWidget.screen )
	templateWidget.screen = nil

	appTransitionComplete = true
end

-- Transition Out Start Cleanup
templateWidget.TransitionOut = function( time )
	-- Transition Screen out
	transition.to( templateWidget.screen, { y = -display.contentHeight, alpha=0, time = time, transition = easing.outQuad, onComplete=templateWidget.TransitionOutComplete } )
	
	
	-- Stop Music
	
	-- Remove the frame update
	Runtime:removeEventListener( "enterFrame", templateWidget.enterFrame )
	
end

-- Transition In, Show Screen, add stuff
templateWidget.TransitionIn = function( time )

	templateWidget.screen = display.newGroup()

	bkgnd = display.newRect( templateWidget.screen, 0, 0, display.contentWidth, display.actualContentHeight )
	c1, c2, dir = GetBkgndColorForPhase( 0 )
	bkgnd:setFillColor( {
		type = 'gradient',
		color1 = c1,
		color2 = c2,
		direction = dir
	} )
	bkgnd.anchorX = 0
	bkgnd.anchorY = 0

	-- Hide Screen
	transition.to( templateWidget.screen, { y = display.contentHeight * -1, alpha=0, time = 0, transition = easing.outQuad } )

	-- Transition Screen In
	transition.to( templateWidget.screen, { y = display.screenOriginY, alpha=1, time = time, transition = easing.outQuad } )
	
	-- Add Controls
	
	-- Start Music

	-- Add the frame update
	Runtime:addEventListener( "enterFrame", templateWidget.enterFrame )

end


return templateWidget
