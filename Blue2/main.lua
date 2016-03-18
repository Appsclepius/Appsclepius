centerX = display.contentCenterX
centerY = display.contentCenterY
screenTop = display.screenOriginY
screenLeft = display.screenOriginX
screenBottom = display.screenOriginY+display.actualContentHeight
screenRight = display.screenOriginX+display.actualContentWidth
screenWidth = screenRight - screenLeft
screenHeight = screenBottom - screenTop
useRadius = 22

sadLevels = 
{
	":-}",
	":-]",
	":-|",
	":-/",
	":-[",
	":-{",
	":-(",
}

stressors = 
{
	'$', -- Money
	'F', -- Family
	'R', -- Relationships
	'L', -- Love
	'H', -- Health
	'W', -- Work	
}

Settings = {}
WidgetInfo = {}
appTransitionComplete = false
lastUpdateTime = 0
lastFrameTime = 0
local state = 'startup'
local lastState = state
local activeWidget
local pauseSpin = 0
local stressSpinIndex = 0
local sadSpinIndex = 0
local stressAngle = 360/#stressors
local sadLevelAngle = 360/#sadLevels

unhappyColor = { 0.02, 0.003, 0.15, 1 }
local baseColor = { 1, 1, 1, .1 }

local settingsButton = nil
local happyButton = nil
local unhappyButton = nil
local sadLevelButtons = {}
local stressButtons = {}
local widgetTable = {}

math.randomseed(os.time())

function PrintTable( t, l, max )
	for k,v in pairs( t ) do
		if l < max then
			if type( v ) == 'table' then
				l = l + 1
				print( string.rep( '\t', l ) .. k )
				PrintTable(v, l, max)
				l = l - 1
			end
		end
		print( string.rep( '\t', l ), k, v )
	end	
end

local widget = require( "widget" )
loadsave = require( 'loadsave' )
display.setStatusBar( display.HiddenStatusBar ) 

local mainScreen = display.newGroup()
--~ local mainBkgnd = display.newRect( mainScreen, 0, -44, display.contentWidth, display.actualContentHeight, 18 )
--~ mainBkgnd.anchorX = 0
--~ mainBkgnd.anchorY = 0

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
		newC1 = Settings.HappyColor
		newC2 = unhappyColor
		newC1[4] = ratio
		newC2[4] = 1 - newC1[4]		
		return newC1, newC2,  "down"
		
	elseif phase == 3 then
		newC1 = baseColor
		newC2 = Settings.HappyColor
		newC2[4] = ratio
		newC1[4] = 1 - newC2[4]		
		return newC1, newC2, 'up'
		
	else
		return Settings.HappyColor, Settings.HappyColor, 'up'		
	end
end

function mcFadeOutDone( musicCredits )
	transition.to( musicCredits, {alpha=.5,time=5000,onComplete=mcFadeInDone} )
end

function mcFadeInDone( musicCredits )
	transition.to( musicCredits, {alpha=0,time=5000,onComplete=mcFadeOutDone} )
end

function SaveSettings( settingName, settingTable )
	Settings[settingName] = settingTable
	loadsave.saveTable( Settings, 'settings.json', system.DocumentsDirectory )
	settingsButton:setStrokeColor(unpack(Settings.HappyColor))
	for i=1,#sadLevels do
		sadLevelButtons[i].button:setStrokeColor(unpack(Settings.HappyColor))
	end
	for i=1, #stressors do
		stressButtons[i].button:setStrokeColor(unpack(Settings.HappyColor))
	end
	
end

function LoadSettings()
	Settings = loadsave.loadTable( 'settings.json', system.DocumentsDirectory )
end

function LoadWidgets()
	WidgetInfo = loadsave.loadTable( 'widgets.json' )
	--PrintTable( WidgetInfo,1, 4 ) 
	widgetTable[#widgetTable+1] = require( 'appsettings.appsettings'  )
	for widgetName, widgetInfo in pairs( WidgetInfo.Widgets ) do
		if widgetName ~= 'appsettings' and widgetInfo.valid == 1 and widgetInfo.hasWidget == 1 then
			widgetTable[#widgetTable+1] = require( widgetName..'.'..widgetName )
		end
	end
end

--particleDesigner = require( "particleDesigner" )
--~ widgetTable[#widgetTable+1] = require( 'appsettings.appsettings'  )
--~ widgetTable[#widgetTable+1] = require( 'wordrain.wordrain' )
--~ widgetTable[#widgetTable+1] = require( 'followcircle.followcircle' )
--~ widgetTable[#widgetTable+1] = require( 'drawlines.drawlines' )


function ToggleStressors( enabled, alpha )
	for i=1,#stressors do
		transition.cancel( stressButtons[i].transition )
		stressButtons[i].button.alpha = alpha
		stressButtons[i].button:setEnabled( enabled )
	end
end

function ToggleSadLevels( enabled, alpha )
	for i=1,#sadLevels do
		transition.cancel( sadLevelButtons[i].transition )
		sadLevelButtons[i].button.alpha = alpha
		sadLevelButtons[i].button:setEnabled( enabled )
	end
end

--~ function activateStressorsComplete( object ) 
--~ 	print( object:getlabel() )
--~ 	object:setEnabled( true )
--~ end

function handleHappy( event )
	state = 'starthappy'
end

function handleUnhappy( event )
	pauseSpin = 5000
	ToggleStressors( true, 1 )
	happyButton:setEnabled( false )
	unhappyButton:setEnabled( false )
	unhappyButton.alpha = 0.6
	happyButton.alpha = 0.0
end

function handleStressor( event )
	-- create unhappy event
	-- save stressor
	pauseSpin = 5000
	ToggleStressors( false, 0 )
	ToggleSadLevels( true, 1 )
end

function handleSadLevel( event )
	-- update event with sad level
	-- start the widget
	state = 'startwidget'
	activeWidget = math.random( 2, #widgetTable )
end

function handleSettings( event )
	state = 'startwidget'
	activeWidget = 1
end

local function DoStartup()
	LoadSettings()	
	LoadWidgets()
	local butnInfo = 
	{
		label = 'S',
		labelColor = { default={1,1,1,1}, over=unhappyColor },
		x = display.actualContentWidth-32,
		y = -32,
		fontSize = 26,
		onRelease = handleSettings,
		labelYOffset = -1,
		emboss = true,
		shape="circle",
		radius = useRadius,
		strokeWidth = 4,
		strokeColor = { default=Settings.HappyColor, over=unhappyColor },	
		fontSize = butnFS,
		font = native.systemFont,
		fillColor = { default=unhappyColor, over=Settings.HappyColor },	
	}
	settingsButton = widget.newButton( butnInfo )
	settingsButton.anchorY = 0
	mainScreen:insert( settingsButton )

	butnInfo.x = centerX 
	butnInfo.y = screenTop + screenHeight/3 - useRadius
	butnInfo.onRelease = handleHappy
	butnInfo.label = ':-)'
	happyButton = widget.newButton( butnInfo )
	mainScreen:insert( happyButton )

	butnInfo.x = centerX 
	butnInfo.y = screenBottom - screenHeight/3 + useRadius
	butnInfo.onRelease = handleUnhappy
	butnInfo.label = ':-('
	unhappyButton = widget.newButton( butnInfo )
	mainScreen:insert( unhappyButton )
	
	butnInfo.fontSize = 20
	butnInfo.onRelease = handleStressor
	for i=1,#stressors do
		butnInfo.id = i
		butnInfo.label = stressors[i]
		local radians = math.rad( i*stressAngle ) 
		butnInfo.x = centerX + ( screenWidth/3 * math.cos( radians ) )
		butnInfo.y = screenBottom - screenHeight/3 + useRadius + ( screenWidth/3 * math.sin( radians ) )
		stressButtons[i] = {}
		stressButtons[i].button = widget.newButton( butnInfo )
		mainScreen:insert( stressButtons[i].button )
	end	
	ToggleStressors( false, 0.6 )
	butnInfo.onRelease = handleSadLevel
	for i=1,#sadLevels do
		butnInfo.id = i
		butnInfo.label = sadLevels[i]
		local radians = math.rad( i*sadLevelAngle ) 
		butnInfo.x = centerX + ( screenWidth/3 * math.cos( radians ) )
		butnInfo.y = screenBottom - screenHeight/3 + useRadius + ( screenWidth/3 * math.sin( radians ) )
		sadLevelButtons[i] = {}
		sadLevelButtons[i].button = widget.newButton( butnInfo )
		mainScreen:insert( sadLevelButtons[i].button )
	end
	ToggleSadLevels( false, 0 )
end

function SetState( newState )
	state = newState
end

local function startMainComplete( object ) 
--~ 	print( mainScreen.y )
--~ 	print( startButton.y)
--~ 	print( settingsButton.y )
end

local function appState(event)
	if state == 'startup' then
		DoStartup()
		state = 'mainscreen'
	elseif state == 'mainscreen' then
		if pauseSpin > 0 then
			transition.cancel()
			pauseSpin = pauseSpin - ( event.time -  lastFrameTime )
			if pauseSpin <= 0 then
				ToggleStressors( false, 0.6 )
				ToggleSadLevels( false, 0 )
				unhappyButton:setEnabled( true )
				unhappyButton.alpha = 1
				happyButton:setEnabled( true )
				happyButton.alpha = 1
			end
		else
			if event.time - lastUpdateTime > 1000 then
				for i=1,#stressors do
					local radians = math.rad( (i+stressSpinIndex)*stressAngle ) 
					stressButtons[i].transition = transition.to( stressButtons[i].button, { x = centerX + ( screenWidth/3 * math.cos( radians ) ), y = screenBottom - screenHeight/3 + useRadius + ( screenWidth/3 * math.sin( radians ) ), time = 1000 } )
				end
				for i=1,#sadLevels do
					local radians = math.rad( (i+sadSpinIndex)*sadLevelAngle ) 
					sadLevelButtons[i].transition = transition.to( sadLevelButtons[i].button, { x = centerX + ( screenWidth/3 * math.cos( radians ) ), y = screenBottom - screenHeight/3 + useRadius + ( screenWidth/3 * math.sin( radians ) ), time = 1000 } )
				end
				lastUpdateTime = event.time
				stressSpinIndex = (stressSpinIndex + 1)%#stressors
				sadSpinIndex = (sadSpinIndex + 1)%#sadLevels
			end
		end
	elseif state == 'startmainscreen' then
		state = 'mainscreen'
		transition.to( mainScreen, { y = 0, time = 2000, alpha=1, transition = easing.outQuad } )
		widgetTable[activeWidget].TransitionOut( 2000 )
		lastFrameTime = event.time
	elseif state == 'startwidget' then
		transition.to( mainScreen, {  y=display.actualContentHeight+1, alpha=0, time = 1700, transition = easing.outQuad, onComplete=startMainComplete } )
		widgetTable[activeWidget].TransitionIn( 2000 )
		state = 'InWidget'
		--widgetTable[4].TransitionIn( 2000 )
	elseif state == 'InWidget' then
	elseif state == 'starthappy' then
		pauseSpin = 5000
		ToggleStressors( false, 0 )
		ToggleSadLevels( false, 0 )
		unhappyButton:setEnabled( false )
		unhappyButton.alpha = 0
		transition.to( happyButton, {x= centerX, y = centerY, xScale = 5, yScale = 5, onComplete = doneHappyExpand, time = 2450 })
	else
	end
	lastFrameTime = event.time
end

Runtime:addEventListener( "enterFrame", appState );

