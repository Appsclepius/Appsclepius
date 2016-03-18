local widget = require( "widget" )
local colorPicker = nil

display.setStatusBar( display.HiddenStatusBar ) 
--math.randomseed(os.time())

-- Basic widget and screen
appSettingsWidget = {}
appSettingsWidget.screen = display.newGroup()

-- Control Declarations
appSettingsWidget.settingsButtons = nil
appSettingsWidget.activeSettings = 0

local bkgnd = display.newRect( appSettingsWidget.screen, 0, 0, display.contentWidth, display.actualContentHeight )
c1, c2, dir = GetBkgndColorForPhase( 4 )
bkgnd:setFillColor( {
	type = 'gradient',
	color1 = c1,
	color2 = c2,
	direction = dir
} )
bkgnd.anchorX = 0
bkgnd.anchorY = 0

-- Hide Screen
transition.to( appSettingsWidget.screen, { y = display.contentHeight * -1, alpha=0, time = 0, transition = easing.outQuad } )

-- Frame Update
--~ appSettingsWidget.enterFrame = function( event )
--~ end

function WidgetSettingsDone( refreshBackground, settingsTable )
	SaveSettings( appSettingsWidget.settingsButtons[appSettingsWidget.activeSettings].butnText, settingsTable )
	if refreshBackground then
		c1, c2, dir = GetBkgndColorForPhase( 4 )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
	end
	for i =1,#appSettingsWidget.settingsButtons do
		appSettingsWidget.settingsButtons[i].button:setEnabled( true )
	end
	appSettingsWidget.activeSettings = 0
end

function handleSettingsButtonEvent( event )
	if event.phase == 'ended' then
		if event.target:getLabel()  == 'Done' then
			SetState( 'startmainscreen' )
		else
			for i =1,#appSettingsWidget.settingsButtons do
				appSettingsWidget.settingsButtons[i].button:setEnabled( false )
			end
			for i =1,#appSettingsWidget.settingsButtons do
				if event.target:getLabel() == appSettingsWidget.settingsButtons[i].butnText then
					appSettingsWidget.settingsButtons[i].widget.Show( 1000, WidgetSettingsDone, Settings[appSettingsWidget.settingsButtons[i].butnText] )
					appSettingsWidget.activeSettings = i
					break
				end
			end
		end
	end
end

-- Transition Out completed, Finish Cleanup
appSettingsWidget.TransitionOutComplete = function( screen )
	for i =1,#appSettingsWidget.settingsButtons do
		appSettingsWidget.settingsButtons[i].button:removeSelf()
		appSettingsWidget.settingsButtons[i].button = nil
	end
	appSettingsWidget.settingsButtons = nil
end

-- Transition Out Start Cleanup
appSettingsWidget.TransitionOut = function( time )
	-- Transition Screen out
	transition.to( appSettingsWidget.screen, { y = -display.contentHeight, alpha=0, time = time, transition = easing.outQuad, onComplete=appSettingsWidget.TransitionOutComplete } )
	
	-- Remove the frame update
	--Runtime:removeEventListener( "enterFrame", appSettingsWidget.enterFrame )
	
end

-- Transition In, Show Screen, add stuff
appSettingsWidget.TransitionIn = function( time )
	-- Transition Screen In
	transition.to( appSettingsWidget.screen, { y = display.screenOriginY, alpha=1, time = time, transition = easing.outQuad } )
	
	appSettingsWidget.settingsButtons = {}

	for wName, wInfo in pairs( WidgetInfo.Widgets ) do
		if wInfo.hasSettings and wInfo.valid == 1 then
			appSettingsWidget.settingsButtons[#appSettingsWidget.settingsButtons+1] = {}
			appSettingsWidget.settingsButtons[#appSettingsWidget.settingsButtons].widgetName = wName
			appSettingsWidget.settingsButtons[#appSettingsWidget.settingsButtons].butnText = wInfo.hasSettings
			appSettingsWidget.settingsButtons[#appSettingsWidget.settingsButtons].widget = require( 'appsettings.' .. wInfo.settingsWidget )

		end
	end

	appSettingsWidget.settingsButtons[#appSettingsWidget.settingsButtons+1] = {}
	appSettingsWidget.settingsButtons[#appSettingsWidget.settingsButtons].widgetName = ''
	appSettingsWidget.settingsButtons[#appSettingsWidget.settingsButtons].butnText = 'Done'
	local numButns = 1+ #appSettingsWidget.settingsButtons * 2
	
	local butnHt = (display.actualContentHeight+44) / numButns
	local butnInfo = 
	{
		x = display.actualContentWidth / 2,
		y = butnHt,
		width = 2 * display.actualContentWidth / 3,
		height = butnHt,
		fontSize = 26,
		onEvent = handleSettingsButtonEvent,
		labelYOffset = -1,
		emboss = false,
		shape="roundedRect",
		cornerRadius = 10,
		font = native.systemFont,
		fillColor = { default={ 1, 1, 1, 0.2 }, over={ 1, 1, 1, 0.2 } },	
	}
	
	for i =1,#appSettingsWidget.settingsButtons do
		butnInfo.label = appSettingsWidget.settingsButtons[i].butnText
		appSettingsWidget.settingsButtons[i].button = widget.newButton( butnInfo )
		appSettingsWidget.screen:insert( appSettingsWidget.settingsButtons[i].button )
		butnInfo.y = butnInfo.y + butnHt * 2
	end

	-- Add the frame update
	--Runtime:addEventListener( "enterFrame", appSettingsWidget.enterFrame )

end


return appSettingsWidget
