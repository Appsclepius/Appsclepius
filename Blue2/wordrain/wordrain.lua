local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed(os.time())

wordRainWidget = {}
wordRainWidget.screen = nil

local bkgnd = nil 

local blahWords =
{
	"arena",
	"ahead",
	"quiet ",
	"stadium",
	"building",
	"window",
	"curb",
	"sidewalk",
	"asphalt ",
	"van",
	"rubber",
	"correct",
	"drive ",
	"ride",
	"ring",
	"aboard",
	"about",
	"above",
	"across",
	"after",
	"along",
	"among ",
	"around",
	"at",
	"before",
	"behind",
	"below",
	"beneath",
	"beside",
	"beyond",
	"flutter",
	"by",
	"down",
	"during ",
	"except",
	"for",
	"from",
	"into",
	"in",
	"like",
	"of",
	"off",
	"on",
	"over",
	"passed",
	"since",
	"through",
	"throughout",
	"to",
	"toward",
	"under",
	"underneath",
	"with",
	"within ",
	"without",
	"near ",
	"out",
	"tree",
	"lamp",
	"sign",
	"string",
	"shrug",
	"shawl",
	"net",
	"wave",
	"neutral ",
	"machine",
	"eyelid",
	"plastic",
	"speed",
	"shoe",
	"steel",
	"iron",
	"lane",
	"stripe",
	"spot",
	"place",
	"area",
	"locked",
	"fluent",
	"door",
	"wash",
	"mart",
	"north",
	"south",
	"east",
	"west",
	"wall",
	"ball",
	"weave",
	"cheek",
	"nod",
	"leaf",
	"zone",
	"pile",
	"coat",
	"sweater ",
	"myriad",
	"turn",
	"particular",
	"bob",
	"recycle",
}

local goodWords = {}
--~ {
--~ 	happy = 0,
--~ 	love = 0,
--~ 	god = 0,
--~ 	fun = 0,
--~ 	family = 0,
--~ 	forgive = 0,
--~ 	play = 0,
--~ 	icecream = 0,
--~ 	kids = 0,
--~ 	raise = 0,
--~ }
local wordRain = {}
local numWordsAdded = 0
local numWordsInRain = 0
local numGoodWordsAdded = 0
local numGoodWordsFound = 0
--local goodWordsFoundMilestones = { 1, 2, 4 }
local goodWordsFoundMilestones = { 10, 25, 40 }
local currentgoodWordsFoundMilestone = 1
local goodWordChance = 80
local blahWordIndex = math.random( #blahWords )
local numBlahWordsInARow = 0
local numWordsInTransition = 0
local lfNumWordsInTransition = 0
local maxRows = 20
local butnH = display.actualContentHeight/maxRows
local butnW = display.contentWidth/2
local butnFS = 18
local backgroundMusic = nil
local clickSound = nil
local fullyHappy = false
local musicCredit = nil
local myText1 = nil
local myText2 = nil
local clickCredit = nil
local cText1 = nil
local cText2 = nil

local function GetUnusedGoodWord()
	usageSortedWords = {}
	for word, usage in pairs( goodWords ) do
		if wordRain[word] == nil then
			table.insert( usageSortedWords, word )
		end
	end

	if #usageSortedWords > 0 then
		function sortGoodWords( w1, w2 ) 
			if w1 and w2 then
					return goodWords[w1] < goodWords[w2] 
			elseif w1 then
				return true
			else
				return false
			end
		end 
		table.sort( usageSortedWords, sortGoodWords )
	--~ 	print( '-----------------------' )
	--~ 	for i=1,#usageSortedWords do
	--~ 		print( usageSortedWords[i], goodWords[usageSortedWords[i]] )
	--~ 	end
		goodWords[usageSortedWords[1]] = goodWords[usageSortedWords[1]] + 1
		return usageSortedWords[1]
	end
	
	return nil
end

local function RemoveButton( wButton )
	local label = wButton:getLabel()
	wButton:removeSelf()
	wordRain[label] = nil
	numWordsInRain = numWordsInRain - 1
end

function doneFoundTransition2( foundButton )
	RemoveButton( foundButton )
end

function doneFoundTransition1( foundButton )
	numWordsInTransition = numWordsInTransition - 1
	transition.to( foundButton, { time=500, alpha=0.5, onComplete=doneFoundTransition2, xScale=5, yScale=5,iterations=1 } )
end

local function SetupButtonInfo()
	if numGoodWordsFound < goodWordsFoundMilestones[1] then
		c1, c2, dir = GetBkgndColorForPhase( 1, numGoodWordsFound/goodWordsFoundMilestones[1] )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
		goodWordChance = 70
		currentgoodWordsFoundMilestone = 2
	elseif numGoodWordsFound < goodWordsFoundMilestones[2] then
		c1, c2, dir = GetBkgndColorForPhase( 2, numGoodWordsFound/goodWordsFoundMilestones[2] )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
		goodWordChance = 60
		currentgoodWordsFoundMilestone = 3
	elseif numGoodWordsFound < goodWordsFoundMilestones[3] then
		c1, c2, dir = GetBkgndColorForPhase( 3, numGoodWordsFound/goodWordsFoundMilestones[3] )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
		goodWordChance = 50
		currentgoodWordsFoundMilestone = 4
	else
		c1, c2, dir = GetBkgndColorForPhase( 4 )
		bkgnd:setFillColor( {
			type = 'gradient',
			color1 = c1,
			color2 = c2,
			direction = dir
		} )
		goodWordChance = 20
	end
end

function handleButtonEvent( event )
	if goodWords[event.target:getLabel()] then
		numGoodWordsFound = numGoodWordsFound + 1
		wordRain[event.target:getLabel()].found = true
		transition.cancel( wordRain[event.target:getLabel()].transition )
		event.target:setEnabled( false )
		numWordsInTransition = numWordsInTransition + 1
		transition.to( event.target, { time=1000, x=(display.actualContentWidth/2), y=(2*display.actualContentHeight/3-numWordsInTransition*butnH*2), onComplete=doneFoundTransition1, rotation = 720, xScale=2, yScale=2 } )
		if audio.isChannelPlaying( 2 ) then
			audio.pause( 2 )
			audio.rewind( 2 )
			audio.resume( 2 )
		else
			audio.play( clickSound, { channel=2 } )
		end
		--clickCredit.x = event.target.x - ( event.target.width/2 )
		clickCredit.y = event.target.y - ( butnH/2 )
		clickCredit.alpha = 1
		transition.to( clickCredit, { alpha = 0, time = 2000 } )
		SetupButtonInfo()
	end
end

function AddToWordRain( numWords )
	maxW = display.contentWidth/numWords
	local butnInfo = 
	{
		x = math.random( butnW/2, maxW-butnW/2 ),
		y = -butnH,
		width = butnW,
		height = butnH,
		labelColor = { default={1,1,1 }, over={ 1,1,1 } },
		fontSize = 26,
		onRelease = handleButtonEvent,
		labelYOffset = -1,
		emboss = false,
		shape="roundedRect",
		cornerRadius = 10,
		fontSize = butnFS,
		font = native.systemFont,
		fillColor = { default={ 1, 1, 1, 0.2 }, over={ 1, 1, 1, 0.2 } },	
	}
	for i=1,numWords do
		butnInfo.x =  butnInfo.x + (butnW*(i-1))
		numWordsAdded = numWordsAdded + 1
		local label = blahWords[blahWordIndex]
		blahWordIndex = ( blahWordIndex + 1 )%(#blahWords-1)+1
		if math.random( 100 ) > goodWordChance or numBlahWordsInARow > maxRows/3 then
			goodLabel = GetUnusedGoodWord()
			if goodLabel then
				label = goodLabel
				numGoodWordsAdded = numGoodWordsAdded + 1
				numBlahWordsInARow = 0
				butnInfo.fontSize = butnFS + 2
				if currentgoodWordsFoundMilestone < 4 then
					butnInfo.labelColor  = { default=Settings.HappyColor, over=Settings.HappyColor }
					butnInfo.labelColor.default[4] = 0.8
				else
					butnInfo.labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }
				end
			else
				butnInfo.fontSize = butnFS
				if currentgoodWordsFoundMilestone < 4 then
					butnInfo.labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }
				else
					butnInfo.labelColor = { default={ 0, 0, 0, 0.5 }, over={ 1, 1, 1 } }
				end
				numBlahWordsInARow = numBlahWordsInARow + 1
			end
		else
			butnInfo.fontSize = butnFS
			if currentgoodWordsFoundMilestone < 4 then
				butnInfo.labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }
			else
				butnInfo.labelColor = { default={ 0, 0, 0, 0.5 }, over={ 1, 1, 1 } }
			end
			numBlahWordsInARow = numBlahWordsInARow + 1
		end
		butnInfo.label = label
		wordRain[label] = {}
		wordRain[label].button = widget.newButton(butnInfo)
		wordRain[label].found = false
		numWordsInRain = numWordsInRain + 1
		wordRainWidget.screen:insert( wordRain[label].button )
	end
end

local function GetNewX( curX, halfWidth )
	if curX < halfWidth then
		curX = curX + math.random(20)
	elseif curX > display.contentWidth-halfWidth then
		curX = curX - math.random(20)
	else
		sign = randomSign( false, 2 )
		curX = curX + ( math.random(20) * sign )
		if curX < halfWidth then curX = halfWidth end
		if curX > display.contentWidth-halfWidth then curX = display.contentWidth-halfWidth end
	end
	return curX
end

wordRainWidget.enterFrame = function( event )
	thisFrameTime = event.time/1000 
	if thisFrameTime - lastUpdateTime > 2 or ( lfNumWordsInTransition > 0 and numWordsInTransition == 0 )  then
		if numGoodWordsFound < goodWordsFoundMilestones[1] then
			numWords = 1
			butnW = display.contentWidth/2
			butnFS = 16
		elseif numGoodWordsFound < goodWordsFoundMilestones[2] then
			numWords = 2
			butnW = display.contentWidth/3 
			butnFS = 14
		else
			numWords = 3
			butnW = display.contentWidth/5
			butnFS = 12
			if not fullyHappy then
				fullyHappy = true
				for word, buttonInfo in pairs(wordRain) do
					if goodWords[buttonInfo.button:getLabel()] == nil then
						RemoveButton( buttonInfo.button )
					end
				end
			end
		end	
		if numWordsInTransition == 0 then
			if numWordsInRain < numWords * maxRows then
				AddToWordRain( numWords )
			end
			for word, buttonInfo in pairs(wordRain) do
				if buttonInfo.button.y < display.actualContentHeight then
					if not buttonInfo.found then
						local parms = 
						{
							x = GetNewX( buttonInfo.button.x, buttonInfo.button.width/2 ),
							y = buttonInfo.button.y+butnH,
							time= 2000, 
						}
						buttonInfo.transition = transition.to( buttonInfo.button, parms )
					end
				else
					RemoveButton( buttonInfo.button )
				end
			end
		end
		lastUpdateTime = thisFrameTime
	end
	lfNumWordsInTransition = numWordsInTransition
end

wordRainWidget.TransitionOutComplete = function( screen )
	transition.cancel()
	for word, buttonInfo in pairs(wordRain) do
		RemoveWord( buttonInfo.button )
	end
	
	display.remove( myText1 )
	myText1 = nil
	display.remove( myText2 )
	myText2 = nil
	display.remove( musicCredit )
	musicCredit = nil

	display.remove( cText1 )
	cText1 = nil
	display.remove( cText2 )
	cText2 = nil
	display.remove( clickCredit )
	clickCredit = nil	

	display.remove( bkgnd )
	bkgnd = nil	
	
	display.remove( wordRainWidget.screen )
	wordRainWidget.screen = nil

	appTransitionComplete = true
end

wordRainWidget.TransitionOut = function( time )
	-- Transition Screen out
	transition.to( wordRainWidget.screen, { y = -display.contentHeight, alpha=0, time = time, transition = easing.outQuad, onComplete=wordRainWidget.TransitionOutComplete } )
	
	-- Stop and clear background music
	audio.stop( backgroundMusic )
	audio.dispose( backgroundMusic )
	
	audio.stop( clickSound )
	audio.dispose( clickSound )

	audio.setMaxVolume( 1, { channel=1 } )
	audio.setMaxVolume( 1, { channel=2 } )
	
	-- Remove the frame update
	Runtime:removeEventListener( "enterFrame", wordRainWidget.enterFrame )
	
end


wordRainWidget.TransitionIn = function( time )

	wordRainWidget.screen = display.newGroup()

	-- Transition Screen In
	bkgnd = display.newRect( wordRainWidget.screen, 0, 0, display.contentWidth, display.actualContentHeight )
	c1, c2, dir = GetBkgndColorForPhase( 0 )
	bkgnd:setFillColor( {
		type = 'gradient',
		color1 = c1,
		color2 = c2,
		direction = dir
	} )
	bkgnd.anchorX = 0
	bkgnd.anchorY = 0
	transition.to( wordRainWidget.screen, { y = display.screenOriginY, alpha=1, time = time, transition = easing.outQuad } )

	-- Start background music
	backgroundMusic = audio.loadStream( "wordrain\\silverbluelight.mp3" )
	audio.play( backgroundMusic, { channel=1, loops = -1, fadein = 10000 } )
	audio.setMaxVolume( 0.1, { channel=1 } )
	
	-- Music Credit
	musicCredit = display.newGroup()
	wordRainWidget.screen:insert( musicCredit )	
	myText1 = display.newText( "Music: Silver Blue Light by Kevin MacLeod", display.actualContentWidth/2, display.actualContentHeight-40, native.systemFont, 12 )
	musicCredit:insert( myText1 )
	myText2 = display.newText( "http://incompetech.com/music/", display.actualContentWidth/2, display.actualContentHeight-20, native.systemFont, 10 )
	musicCredit:insert( myText2 )
	transition.to( musicCredit, {alpha=0,time=10000,onComplete=mcFadeOutDone} )

	-- Load click sound
	clickCredit = display.newGroup()
	wordRainWidget.screen:insert( clickCredit )	
	clickSound = audio.loadSound( "wordrain\\chime.wav" )
	audio.setMaxVolume( 0.03, { channel=2 } )
	cText1 = display.newText( "Sound by JustinBW", display.actualContentWidth/2, 20, native.systemFont, 10 )
	clickCredit:insert( cText1 )
	cText2 = display.newText( "http://bit.ly/1NOY9GJ", display.actualContentWidth/2, 40, native.systemFont, 10 )
	clickCredit:insert( cText2 )
	clickCredit.alpha = 0
	
	goodWords = Settings.HappyWords
	lastUpdateTime = 0
	
	-- Add the frame update
	Runtime:addEventListener( "enterFrame", wordRainWidget.enterFrame )
	
end

return wordRainWidget