local composer = require ( "composer" )
local widget = require( "widget" )
local myApp = require( "myapp" ) 

require( "settings\\ElementsHelper" )

myApp.Quotes = {}
local quotesTableLoaded = require( "settings\\_settings_quotes" )
if quotesTableLoaded then
    for k,v in ipairs( Quotes ) do
        local quotesLoaded = require( "settings\\"..v )
        if quotesLoaded then
            for qK, qV in ipairs( Data.Settings ) do
                myApp.Quotes[#myApp.Quotes+1] = qV
            end
        end
    end
end

local settingsLoaded = require( "settings\\_settings_default" )
if settingsLoaded then
    myApp.Settings = Settings
end

local userDataLoaded = require( "db\\UserData" )
if userDataLoaded then
    myApp.UserData = UserData
end

myApp.curModules = nil
myApp.curModule = nil

if (display.pixelHeight/display.pixelWidth) > 1.5 then
    myApp.isTall = true
end

if display.contentWidth > 320 then
    myApp.is_iPad = true
end

--
-- turn on debugging
--
local debugMode = true

--
-- this little snippet will make a copy of the print function
-- and now will only print if debugMode is true
-- quick way to clean up your logging for production
--

reallyPrint = print
function print(...)
    if debugMode then
        reallyPrint(unpack(arg))
    end
end

math.randomseed(os.time())

--
-- Load our fonts and define our styles
--

local tabBarBackgroundFile = "images/tabBarBg7.png"
local tabBarLeft = "images/tabBar_tabSelectedLeft7.png"
local tabBarMiddle = "images/tabBar_tabSelectedMiddle7.png"
local tabBarRight = "images/tabBar_tabSelectedRight7.png"

myApp.topBarBg = "images/topBarBg7.png"

local iconInfo = {
    width = 40,
    height = 40,
    numFrames = 20,
    sheetContentWidth = 200,
    sheetContentHeight = 160
}

myApp.icons = graphics.newImageSheet("images/ios7icons.png", iconInfo)

if system.getInfo("platformName") == "Android" then
    myApp.theme = "widget_theme_android"
    myApp.font = "Droid Sans"
    myApp.fontBold = "Droid Sans Bold"
    myApp.fontItalic = "Droid Sans"
    myApp.fontBoldItalic = "Droid Sans Bold"
    myApp.topBarBg = "images/topBarBg7.png"

else
    myApp.theme = "widget_theme_ios7"
    local coronaBuild = system.getInfo("build")
    if tonumber(coronaBuild:sub(6,12)) < 1206 then
        myApp.theme = "widget_theme_ios"
    end
    myApp.font = "HelveticaNeue-Light"
    myApp.fontBold = "HelveticaNeue"
    myApp.fontItalic = "HelveticaNeue-LightItalic"
    myApp.fontBoldItalic = "Helvetica-BoldItalic"
end
widget.setTheme(myApp.theme)

-- functions for activating different screens
myApp.tabBar = {}

function myApp.showScreenHome()
    myApp.tabBar:setSelected(1)
    composer.removeHidden()
    composer.gotoScene("screen_home", {time=250, effect="crossFade"})
    return true
end

function myApp.showScreenModules()
    --myApp.tabBar:setSelected(2)
    local options = {
    }
    composer.removeHidden()
    composer.gotoScene("screen_modules", {time=250, effect="crossFade", params = options})
    return true
end

function myApp.showScreenModuleGeneric()
    --myApp.tabBar:setSelected(2)
    local options = {
    }
    composer.removeHidden()
    composer.gotoScene("screen_module_generic", {time=250, effect="crossFade", params = options})
    return true
end

function myApp.showScreenQuotes()
    --myApp.tabBar:setSelected(2)
    local options = {
    }
--    composer.removeHidden()
--    composer.gotoScene("screen_modules", {time=250, effect="crossFade", params = options})
    return true
end

function myApp.createHeader( headerTitle )
    realHeaderTitle = headerTitle
    if realHeaderTitle == '' then realHeaderTitle = 'Blue2You' end
    
    local navBar = widget.newNavigationBar({
        title = realHeaderTitle,
        backgroundColor = { 0.36, 0.59, 0.74 },
        titleColor = {1, 1, 1},
        font = "HelveticaNeue"
    })

    return navBar
end

local tabButtons = {
    {
        label = "Menu",
        defaultFile = "images/tabbaricon.png",
        overFile = "images/tabbaricon-down.png",
        labelColor = { 
            default = { 0.25, 0.25, 0.25 }, 
            over = { 0.768, 0.516, 0.25 }
        },
        width = 32,
        height = 32,
        onPress = myApp.showScreenHome,
        selected = true,
    },
    {
        label = "Profile",
        defaultFile = "images/tabbaricon.png",
        overFile = "images/tabbaricon-down.png",
        labelColor = { 
            default = { 0.25, 0.25, 0.25 }, 
            over = { 0.768, 0.516, 0.25 }
        },
        width = 32,
        height = 32,
        onPress = myApp.showScreenHome,
    },
    {
        label = "Settings",
        defaultFile = "images/tabbaricon.png",
        overFile = "images/tabbaricon-down.png",
        labelColor = { 
            default = { 0.25, 0.25, 0.25 }, 
            over = { 0.768, 0.516, 0.25 }
        },
        width = 32,
        height = 32,
        onPress = myApp.showScreenHome,
    },
    {
        label = "Help",
        defaultFile = "images/tabbaricon.png",
        overFile = "images/tabbaricon-down.png",
        labelColor = { 
            default = { 0.25, 0.25, 0.25 }, 
            over = { 0.768, 0.516, 0.25 }
        },
        width = 32,
        height = 32,
        onPress = myApp.showScreenHome,
    },
}

myApp.tabBar = widget.newTabBar{
    top =  display.contentHeight - 50,
    left = 0,
    width = display.contentWidth,
    backgroundFile = tabBarBackgroundFile,
    tabSelectedLeftFile = tabBarLeft,      -- New
    tabSelectedRightFile = tabBarRight,    -- New
    tabSelectedMiddleFile = tabBarMiddle,      -- New
    tabSelectedFrameWidth = 20,                                         -- New
    tabSelectedFrameHeight = 50,                                        -- New    
    buttons = tabButtons,
    height = 50,
    --background="images/tabBarBg7.png"
}

local background = display.newRect(0,0, display.contentWidth, display.contentHeight)
background:setFillColor( 0.48, 0.79, 0.94 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local logo = display.newImageRect("Splash.png", 320, 480)
logo.x = display.contentCenterX
logo.y = display.contentCenterY

local title = display.newText("", 0, 0, myApp.fontBold, 28)
title:setFillColor( 0, 0, 0 )
title.x = display.contentCenterX
title.y = display.contentHeight - 64
--
-- now make the first tab active.align
--

local function closeSplash()
    display.remove(title)
    title = nil
    display.remove(logo)
    logo = nil
    display.remove(background)
    background = nil
    myApp.showScreenHome()
end

timer.performWithDelay(1500, closeSplash)


