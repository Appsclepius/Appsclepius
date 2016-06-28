local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local widgetExtras = require("widget-extras")
local myApp = require( "myapp" )

widget.setTheme(myApp.theme)

local titleText
local locationtxt
local views = {}


local function ignoreTouch( event )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	local background = display.newRect(0,0,display.contentWidth, display.contentHeight)
--	local background = display.newImageRect( "header2.png", 320, 60 )
	background:setFillColor( 0.48, 0.79, 0.94 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	sceneGroup:insert(background)
	background:addEventListener("touch", ignoreTouch)

--	local titleLogo = display.newImageRect( "header2.png", 320, 60 )
--	titleLogo.x = display.contentWidth / 2
--	titleLogo.y = 30
--	sceneGroup:insert(titleLogo)
--	titleLogo:addEventListener("touch", ignoreTouch)

    sceneGroup:insert( myApp.createHeader('Contact Us') )

end

function scene:show( event )
	local sceneGroup = self.view

end

function scene:hide( event )
	local sceneGroup = self.view

	--
	-- Clean up native objects
	--

end

function scene:destroy( event )
	local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene