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

    sceneGroup:insert( myApp.createHeader('') )


    local button1 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Mission",
        labelColor = { 
            default = { 0.99, 0.99, 0.99 }, 
            over = { 0.7, 0.7, 0.7 } 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreenMission
    })
    sceneGroup:insert(button1)
    button1.x = display.contentCenterX
    button1.y = display.contentCenterY - 120


    local button2 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Roles & Goals",
        labelColor = { 
            default = { 0.99, 0.99, 0.99 }, 
            over = { 0.7, 0.7, 0.7 } 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreenRoles
    })
    sceneGroup:insert(button2)
    button2.x = display.contentCenterX
    button2.y = display.contentCenterY - 40


    local button3 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Pursuut Blog",
        labelColor = { 
            default = { 0.99, 0.99, 0.99 }, 
            over = { 0.7, 0.7, 0.7 } 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreenBlog
    })
    sceneGroup:insert(button3)
    button3.x = display.contentCenterX
    button3.y = display.contentCenterY + 40

    local button4 = widget.newButton({
    	width = 160,
    	height = 40,
    	label = "Contact Pursuut",
        labelColor = { 
            default = { 0.99, 0.99, 0.99 }, 
            over = { 0.7, 0.7, 0.7 } 
        },
    	labelYOffset = -4, 
    	font = myApp.font,
    	fontSize = 18,
    	emboss = false,
    	onRelease = myApp.showScreenContact
    })
    sceneGroup:insert(button4)
    button4.x = display.contentCenterX
    button4.y = display.contentCenterY + 120
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