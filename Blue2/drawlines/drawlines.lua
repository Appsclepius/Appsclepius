local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed(os.time())

drawLinesWidget = {}
drawLinesWidget.screen = display.newGroup()

local clickCredit = display.newGroup()
drawLinesWidget.screen:insert( clickCredit )	

local bkgnd = display.newRect( drawLinesWidget.screen, 0, 0, display.contentWidth, display.actualContentHeight )
c1, c2, dir = GetBkgndColorForPhase( 0 )
bkgnd:setFillColor( {
	type = 'gradient',
	color1 = c1,
	color2 = c2,
	direction = dir
} )
bkgnd.anchorX = 0
bkgnd.anchorY = 0
transition.to( drawLinesWidget.screen, { y = display.contentHeight * -1, alpha=0, time = 0, transition = easing.outQuad } )

local activeLine = false
local drawLines = {}
local startButton = 0
local currentgoodWordsFoundMilestone = 1
local butnH = 5
local butnW = 5
local butnFS = 18
local backgroundMusic = nil
local clickSound = nil

function lineEraseComplete( object )
	for i=1,#drawLines do
		if drawLines[i].active then
			--print( 'Active', i )
			if object == drawLines[i].buttons[1] then
				object:removeSelf()
				drawLines[i].buttons[1] = nil
				if drawLines[i].buttons[2] == nil then
					drawLines[i].active = false
					drawLines[i].line:removeSelf()
					drawLines[i].line = nil
				end
				break
			elseif object == drawLines[i].buttons[2] then
				object:removeSelf()
				drawLines[i].buttons[2] = nil
				if drawLines[i].buttons[1] == nil then
					drawLines[i].active = false
					drawLines[i].line:removeSelf()
					drawLines[i].line = nil
				end
				break
			end
		end
	end
end

function handleButtonEvent( event )
	curActiveLine = drawLines[#drawLines]
	if event.phase == 'began' then
		if event.target == curActiveLine.buttons[1] then
			startButton = 1
		else
			startButton = 2
		end
	elseif event.phase == 'moved' then
		if curActiveLine.line ~= nil then
			curActiveLine.line:removeSelf()
			curActiveLine.line = nil
		end
		curActiveLine.line = display.newLine( drawLinesWidget.screen, curActiveLine.buttons[startButton].x, curActiveLine.buttons[startButton].y, event.x, event.y+44)
		curActiveLine.line:setStrokeColor( curActiveLine.color[1], curActiveLine.color[2], curActiveLine.color[3], curActiveLine.color[4] )
		curActiveLine.line.strokeWidth = 5
	elseif event.phase == 'cancelled' then
		local checkButtonIndex = 2
		if startButton == 2 then
			checkButtonIndex = 1
		end
		if math.abs( event.x - curActiveLine.buttons[checkButtonIndex].x ) <= butnW and
		   math.abs( event.y - curActiveLine.buttons[checkButtonIndex].y + 44 ) <= butnH then
		   local transitionX = ( curActiveLine.buttons[1].x + curActiveLine.buttons[2].x ) / 2
		   local transitionY = ( curActiveLine.buttons[1].y + curActiveLine.buttons[2].y ) / 2
		   transition.to( curActiveLine.buttons[1], {x= transitionX, y = transitionY, time = 1000, onComplete=lineEraseComplete } )
		   transition.to( curActiveLine.buttons[2], {x= transitionX, y = transitionY, time = 1000, onComplete=lineEraseComplete } )
		   curActiveLine.buttons[1]:setEnabled( false )
		   curActiveLine.buttons[2]:setEnabled( false )
		   drawLines[#drawLines].active = true
		   activeLine = false
		else
			curActiveLine.line:removeSelf()
			curActiveLine.line = nil
		end
	end
end

drawLinesWidget.enterFrame = function( event )
	if not activeLine then
		local butnInfo = 
		{
			x = math.random( 20, display.actualContentWidth-20 ),
			y = math.random( 20, display.actualContentHeight-20 ),
			width = butnW,
			height = butnH,
			fontSize = 26,
			onEvent = handleButtonEvent,
			labelYOffset = -1,
			emboss = false,
			shape="roundedRect",
			cornerRadius = 10,
			fontSize = butnFS,
			font = native.systemFont,
			fillColor = { default={ 1, 1, 1, 0.2 }, over={ 1, 1, 1, 0.2 } },	
		}
		butnInfo.fillColor.default[1] = math.random(100 ) /100 
		butnInfo.fillColor.default[2] = math.random(100 ) /100 
		butnInfo.fillColor.default[3] = math.random(100 ) /100 
		newActiveLine = {}
		newActiveLine.color = butnInfo.fillColor.default
		newActiveLine.buttons = {}
		newActiveLine.buttons[1] = widget.newButton( butnInfo )
		drawLinesWidget.screen:insert( newActiveLine.buttons[1] )
		butnInfo.x = math.random( 20, display.actualContentWidth-20 )
		butnInfo.y = math.random( 20, display.actualContentHeight-20 )
		newActiveLine.buttons[2] = widget.newButton( butnInfo )
		drawLinesWidget.screen:insert( newActiveLine.buttons[2] )
		drawLines[#drawLines+1] = newActiveLine
		activeLine = true
	end
	
	for i=1,#drawLines do
		if drawLines[i].active then
			if drawLines[i].buttons[1] and drawLines[i].buttons[2] then
				if drawLines[i].line ~= nil then
					drawLines[i].line:removeSelf()
				end
				drawLines[i].line = display.newLine( drawLinesWidget.screen, drawLines[i].buttons[1].x,drawLines[i].buttons[1].y,drawLines[i].buttons[2].x,drawLines[i].buttons[2].y )
				drawLines[i].line:setStrokeColor( curActiveLine.color[1], curActiveLine.color[2], curActiveLine.color[3], curActiveLine.color[4] )
				drawLines[i].line.strokeWidth = 5
			end
		end
	end
end

drawLinesWidget.TransitionOutComplete = function( screen )
	transition.cancel()
	appTransitionComplete = true
end

drawLinesWidget.TransitionOut = function( time )
	-- Transition Screen out
	transition.to( drawLinesWidget.screen, { y = -display.contentHeight, alpha=0, time = time, transition = easing.outQuad, onComplete=drawLinesWidget.TransitionOutComplete } )
	
	-- Stop and clear background music
	audio.stop( backgroundMusic )
	audio.dispose( backgroundMusic )
	
	audio.stop( clickSound )
	audio.dispose( clickSound )

	audio.setMaxVolume( 1, { channel=1 } )
	audio.setMaxVolume( 1, { channel=2 } )
	
	-- Remove the frame update
	Runtime:removeEventListener( "enterFrame", drawLinesWidget.enterFrame )
	
end


drawLinesWidget.TransitionIn = function( time )

	-- Transition Screen In
	transition.to( drawLinesWidget.screen, { y = display.screenOriginY, alpha=1, time = time, transition = easing.outQuad } )

	-- Start background music
	backgroundMusic = audio.loadStream( "drawlines\\silverbluelight.mp3" )
	audio.play( backgroundMusic, { channel=1, loops = -1, fadein = 10000 } )
	audio.setMaxVolume( 0.1, { channel=1 } )
	
	-- Music Credit
	local musicCredit = display.newGroup()
	drawLinesWidget.screen:insert( musicCredit )	
	local myText1 = display.newText( "Music: Silver Blue Light by Kevin MacLeod", display.actualContentWidth/2, display.actualContentHeight-40, native.systemFont, 12 )
	musicCredit:insert( myText1 )
	local myText2 = display.newText( "http://incompetech.com/music/", display.actualContentWidth/2, display.actualContentHeight-20, native.systemFont, 10 )
	musicCredit:insert( myText2 )
	transition.to( musicCredit, {alpha=0,time=10000,onComplete=mcFadeOutDone} )

	-- Load click sound
	clickSound = audio.loadSound( "drawlines\\chime.wav" )
	audio.setMaxVolume( 0.03, { channel=2 } )
	local cText1 = display.newText( "Sound by JustinBW", display.actualContentWidth/2, 20, native.systemFont, 10 )
	clickCredit:insert( cText1 )
	local cText2 = display.newText( "http://bit.ly/1NOY9GJ", display.actualContentWidth/2, 40, native.systemFont, 10 )
	clickCredit:insert( cText2 )
	clickCredit.alpha = 0
	
	-- Add the frame update
	Runtime:addEventListener( "enterFrame", drawLinesWidget.enterFrame )
	
end

return drawLinesWidget