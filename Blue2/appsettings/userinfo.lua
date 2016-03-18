local widget = require( "widget" )
local userSettings = {}

userSettings.userInfo = {}

local infoButtons = {}
local infoType = 
{
	'Basics',
	'Stats',
	'Doctor',
	'Medications',
	'Your Rock',
	"Back",
}

local blur
--~ local picker, catText, showButn, doneButn
--~ local wordGrp = nil
--~ local wordTxt = nil
--~ local happyButn = nil
--~ local skipButn = nil
--~ local changeButn = nil
--~ local responseGroup = nil
--~ local curCat, curIndx
local savedDoneListener = nil

function userSettings.TransitionOut()
	local function removeGroup()
		display.remove(blur)
		blur = nil
--~ 		showButn:removeSelf()
--~ 		showButn = nil
--~ 		doneButn:removeSelf()
--~ 		doneButn = nil
--~ 		picker:removeSelf()
--~ 		picker = nil
--~ 		happyButn:removeSelf()
--~ 		happyButn = nil
--~ 		skipButn:removeSelf()
--~ 		skipButn = nil
--~ 		changeButn:removeSelf()
--~ 		changeButn = nil
		
		for i=1, #infoButtons do
			infoButtons[i]:removeSelf()
			infoButtons[i] = nil
		end
		
		display.remove( userSettings.screen )
		userSettings.screen = nil
	end
	transition.to(blur, {alpha = 0})
	transition.to(userSettings.screen, {y = centerY + screenHeight, alpha = 0, time = transitionTime, onComplete = removeGroup})
	if savedDoneListener then
		savedDoneListener( false, userSettings.userInfo )
	end
end

function handleInfoType( event )
	if event.target.id == #infoType then
		userSettings.TransitionOut()
	end
end

------------------------------------------------------------------------------------
-- SHOW USER SETTINGS
------------------------------------------------------------------------------------
function userSettings.Show(transitionTime, doneListener, currentSettings)
	userSettings.userInfo = currentSettings
	if userSettings.userInfo == nil then
		userSettings.userInfo = {}
	end
	--PrintTable( userSettings.userInfo, 2, 1 )
	savedDoneListener = doneListener

	userSettings.screen = display.newGroup()

--~ 	-- let's dim & blur the scene underneath our picker
	blur = display.captureScreen()
		blur.x, blur.y = centerX, centerY
		blur:setFillColor(.1,.1,.1)
		blur.fill.effect = "filter.blur"
		blur.alpha = 0
		userSettings.screen:insert( blur )
		
--~ 	pickeroptions =
--~ 	{
--~ 		id = 'CatPick',
--~ 		left = 0,
--~ 		top = 0,
--~ 		columns = 
--~ 		{
--~ 			{
--~ 				align = 'center',
--~ 				width = 280,
--~ 				startIndex = 1,
--~ 				labels = {},
--~ 			},
--~ 		},
--~ 	}
--~ 	
--~ 	for category, catWords in pairs(wordList) do
--~ 		table.insert( pickeroptions.columns[1].labels, tostring(category) )
--~ 	end
	
--~ 	catText = display.newText( "Pick a Category", display.actualContentWidth/2, -24, native.systemFont, 24 )
--~ 	userSettings.screen:insert( catText )
	
	local butnHt = (screenHeight+44) / ( 1 + #infoType * 2 )
	local butnInfo = 
	{
		label = '',
		x = screenWidth/2,
		y = butnHt-44,
		width = 2 * screenWidth / 3,
		height = butnHt,
		fontSize = 24,
		onRelease = handleInfoType,
		labelYOffset = -1,
		emboss = false,
		shape="roundedRect",
		cornerRadius = 10,
		font = native.systemFont,
		fillColor = { default={ 1, 1, 1, 0.2 }, over={ 1, 1, 1, 0.2 } },	
	}
	for i =1,#infoType do
		butnInfo.id = i
		butnInfo.label = infoType[i]
		infoButtons[i] = widget.newButton( butnInfo )
		userSettings.screen:insert( infoButtons[i] )
		butnInfo.y = butnInfo.y + butnHt * 2
	end

--~ 	showButn = widget.newButton( butnInfo )
--~ 	userSettings.screen:insert( showButn )
--~ 	
--~ 	butnInfo.label = 'Done'
--~ 	butnInfo.x = 3 * display.actualContentWidth / 4
--~ 	doneButn = widget.newButton( butnInfo )
--~ 	userSettings.screen:insert( doneButn )
--~ 	picker = widget.newPickerWheel( pickeroptions )
--~ 	userSettings.screen:insert( picker )
--~ 	
--~ 	wordGrp = display.newGroup()
--~ 	userSettings.screen:insert( wordGrp )
--~ 	butnInfo.onRelease = handleResponse
--~ 	butnInfo.x = screenWidth/4
--~ 	butnInfo.y = 100
--~ 	butnInfo.label = 'X'
--~ 	butnInfo.shape = 'circle'
--~ 	butnInfo.radius = 22
--~ 	skipButn = widget.newButton( butnInfo )
--~ 	wordGrp:insert( skipButn )
--~ 	butnInfo.x = screenWidth/2
--~ 	butnInfo.label = ':-)'
--~ 	happyButn = widget.newButton( butnInfo )
--~ 	wordGrp:insert( happyButn )
--~ 	butnInfo.x = 3*screenWidth/4
--~ 	butnInfo.label = '^'
--~ 	changeButn = widget.newButton( butnInfo )
--~ 	wordGrp:insert( changeButn )
--~ 	transition.to( wordGrp, {y=screenBottom-150, alpha=0, time=0 } )
--~ 	
 	transition.to(blur, {alpha=1})
end



return userSettings