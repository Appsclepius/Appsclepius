local widget = require( "widget" )
local happyWords = {}

local wordList =
{
	Food = 
	{
		"Ice cream",
		"Tacos",
		"Burgers",
		"Fries",
		"Pizza",
	},
	Family = 
	{
		"Mom",
		"Dad",
		"Kids",
		"Grandma",
		"Grandpa",
		"Home",
		"Family",
		"Daughter",
		"Son",
	},
	Relationships = 
	{
		"Love",
		"Sweetheart",
		"Darling",
		"Husband",
		"Wife",
		"Boyfriend",
		"Girlfriend",
		"Best Friend",
		"Buddies",
		"Pals",
		"BFFs",
		"Adore",
		"Kisses",
		"Hugs",
	},
	Feelings = 
	{
		"Happy",
		"Love",
		"Peaceful",
		"Excited",
		"Blessed",
		"Loved",
		"Remembered",
		"Gratefu",
	},
	Fun = 
	{
		"Party",
		"Holiday", 
		"Christmas",
		"Thanksgiving", 
		"Halloween",
		"Hiking",
		"Biking",
		"Running",
		"Skiing",
		"Rollerblading",
	},
	Religious = 
	{
		"God",
		"Prayer",
		"Blessing",
		"Miracle",
	},
}

happyWords.goodWords = nil

local blur, picker, catText, showButn, doneButn
local wordGrp = nil
local wordTxt = nil
local happyButn = nil
local skipButn = nil
local changeButn = nil
local responseGroup = nil
local curCat, curIndx
local savedDoneListener = nil

function TransitionOut()
	local function removeGroup()
		display.remove(blur)
		blur = nil
		showButn:removeSelf()
		showButn = nil
		doneButn:removeSelf()
		doneButn = nil
		picker:removeSelf()
		picker = nil
		happyButn:removeSelf()
		happyButn = nil
		skipButn:removeSelf()
		skipButn = nil
		changeButn:removeSelf()
		changeButn = nil
		
		display.remove( happyWords.screen )
		happyWords.screen = nil
	end
	transition.to(blur, {alpha = 0})
	transition.to(happyWords.screen, {y = centerY + screenHeight, alpha = 0, time = transitionTime, onComplete = removeGroup})
	if savedDoneListener then
		savedDoneListener( false, happyWords.goodWords )
	end
end

local function DropWord()
	curIndx = ( curIndx + 1 ) % #wordList[curCat]
	if curIndx == 0 then curIndx = 1 end
	if wordTxt == nil then
		wordTxt = display.newText( wordList[curCat][curIndx], screenWidth/2, 40, native.systemFont, 24 )
		wordGrp:insert( wordTxt )
	else
		wordTxt.text = wordList[curCat][curIndx]
	end
	
	transition.to( wordGrp, {alpha = 1, time=0} )
end

local function handleResponse( event )
	if event.target:getLabel() == 'X' then
		happyWords.goodWords[ wordList[curCat][curIndx] ] = nil
	else
		happyWords.goodWords[ wordList[curCat][curIndx] ] = 0
	end
	DropWord()
end

local function handleShowOrDone( event )
	if event.target:getLabel():find( 'Done' ) then
		TransitionOut()
	else
		curIndx = 0
		curCat = picker:getValues()[1].value
		DropWord()
	--print( curCat, curIndx )
	end
end 

------------------------------------------------------------------------------------
-- SHOW WORD PICKER
------------------------------------------------------------------------------------
function happyWords.Show(transitionTime, doneListener, currentSettings)
	happyWords.goodWords = currentSettings
	if happyWords.goodWords == nil then
		happyWords.goodWords = {}
	end
	PrintTable( happyWords.goodWords, 2, 1 )
	savedDoneListener = doneListener

	happyWords.screen = display.newGroup()

	-- let's dim & blur the scene underneath our picker
	blur = display.captureScreen()
		blur.x, blur.y = centerX, centerY
		blur:setFillColor(.1,.1,.1)
		blur.fill.effect = "filter.blur"
		blur.alpha = 0
		happyWords.screen:insert( blur )
		
	pickeroptions =
	{
		id = 'CatPick',
		left = 0,
		top = 0,
		columns = 
		{
			{
				align = 'center',
				width = 280,
				startIndex = 1,
				labels = {},
			},
		},
	}
	
	for category, catWords in pairs(wordList) do
		table.insert( pickeroptions.columns[1].labels, tostring(category) )
	end
	
	catText = display.newText( "Pick a Category", display.actualContentWidth/2, -24, native.systemFont, 24 )
	happyWords.screen:insert( catText )
	
	local butnInfo = 
	{
		label = 'Show Words',
		x = display.actualContentWidth / 4,
		y = 244,
		width = display.actualContentWidth/2,
		height = 32,
		fontSize = 24,
		onRelease = handleShowOrDone,
		labelYOffset = -1,
		emboss = false,
		shape="roundedRect",
		cornerRadius = 5,
		font = native.systemFont,
		fillColor = { default={ 1, 1, 1, 0.2 }, over={ 1, 1, 1, 0.2 } },	
	}
	showButn = widget.newButton( butnInfo )
	happyWords.screen:insert( showButn )
	
	butnInfo.label = 'Done'
	butnInfo.x = 3 * display.actualContentWidth / 4
	doneButn = widget.newButton( butnInfo )
	happyWords.screen:insert( doneButn )
	picker = widget.newPickerWheel( pickeroptions )
	happyWords.screen:insert( picker )
	
	wordGrp = display.newGroup()
	happyWords.screen:insert( wordGrp )
	butnInfo.onRelease = handleResponse
	butnInfo.x = screenWidth/4
	butnInfo.y = 100
	butnInfo.label = 'X'
	butnInfo.shape = 'circle'
	butnInfo.radius = 22
	skipButn = widget.newButton( butnInfo )
	wordGrp:insert( skipButn )
	butnInfo.x = screenWidth/2
	butnInfo.label = ':-)'
	happyButn = widget.newButton( butnInfo )
	wordGrp:insert( happyButn )
	butnInfo.x = 3*screenWidth/4
	butnInfo.label = '^'
	changeButn = widget.newButton( butnInfo )
	wordGrp:insert( changeButn )
	transition.to( wordGrp, {y=screenBottom-150, alpha=0, time=0 } )
	
	transition.to(blur, {alpha=1})
end



return happyWords