require 'io'

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local widgetExtras = require("widget-extras")
local myApp = require( "myapp" )

widget.setTheme(myApp.theme)

local titleText
local locationtxt
local views = {}

local myList = nil

local function ignoreTouch( event )
	return true
end

--
-- this function gets called when we tap on a row.
--
local onRowTouch = function( event )
    if event.phase == "release" or event.phase == "tap" then
        
        local row = event.row
        local moduleData = event.row.params.ModuleData
        local id = row.index
--        myApp.CurrentQuest = id
        
--        if locked == false then
--            myApp.showScreenMissions()     
--        end
    end
    return true
end

-- 
-- This function is used to draw each row of the tableView
--
    
local function onRowRender(event)
    print("row render")
    --
    -- set up the variables we need that are passed via the event table
    --
    local row = event.row
    local moduleData = event.row.params.ModuleData
    local id = row.index
    --
    -- boundry check to make sure we are tnot trying to access a story that
    -- doesnt exist.
    --
--    if id > #myApp.Settings.Widgets then return true end

    local image = nil
    
    if moduleData.Image then
        image = {
    --        onEvent = goBack,
            name = moduleData.Image..'_small.png',
            width = 50,
            height = 50,
        }        
    end
    
    local curYOffset = 0
    
    ProcessWidgetElements( row, curYOffset, moduleData.Settings.Elements )
    
    return true
end


function scene:create( event )
    local sceneGroup = self.view
        
    local background = display.newRect(0,0,display.contentWidth, display.contentHeight)
--  local background = display.newImageRect( "header2.png", 320, 60 )
    background:setFillColor( 0.48, 0.79, 0.94 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)
    background:addEventListener("touch", ignoreTouch)

--  local titleLogo = display.newImageRect( "header2.png", 320, 60 )
--  titleLogo.x = display.contentWidth / 2
--  titleLogo.y = 30
--  sceneGroup:insert(titleLogo)
--  titleLogo:addEventListener("touch", ignoreTouch)

    sceneGroup:insert( myApp.createHeader('') )

--  local titleLogo = display.newImageRect( "header2.png", 320, 60 )
--  titleLogo.x = display.contentWidth / 2
--  titleLogo.y = 30
--  sceneGroup:insert(titleLogo)
--  titleLogo:addEventListener("touch", ignoreTouch)

    local leftButton = {
--  onEvent = goBack,
        width = 32,
        height = 32,
        defaultFile = "images/ui/button_back_left.png",
        overFile = "images/ui/button_back_left.png",
        onEvent = myApp.showScreenHome,
    }

    local tWidth = display.contentWidth
    local tHeight = display.contentHeight - 60 - myApp.tabBar.height

    myList = widget.newTableView{ 
        top = 60,--navBar.height, 
        width = tWidth, 
        height = tHeight, 
        maskFile = maskFile,
        listener = tableViewListener,
        hideBackground = true, 
        onRowRender = onRowRender,
        onRowTouch = onRowTouch 
    }
    --
    -- insert the list into the group
    sceneGroup:insert(myList)
    
    if myApp.curModule then
        myList:insertRow{
            rowHeight = 60,
            rowColor = { 1, 1, 1 },
            lineColor = { 0.90, 0.90, 0.90 },
            params = {
                ModuleData = myApp.curModule,
                Type = 'Module',
            }
        }          
    end    
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