local widget = require( "widget" )
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed(os.time())

wordRainWidget = {}
wordRainWidget.screen = display.newGroup()

local happyColor = { 1, .6, 0, 1 }
local unhappyColor = { 0.02, 0.003, 0.15, 1 }
local baseColor = { 1, 1, 1, .1 }

local wordRainBkgnd = display.newRect( 0, 0, display.contentWidth, display.actualContentHeight, 18 )
wordRainBkgnd:setFillColor( {
	type = 'gradient',
	color1 = baseColor, 
	color2 = unhappyColor,
	direction = "up"
} )
wordRainBkgnd.anchorX = 0
wordRainBkgnd.anchorY = 0
wordRainWidget.screen:insert( wordRainBkgnd )
transition.to( wordRainWidget.screen, { y = display.contentHeight * -1, alpha=0, time = 0, transition = easing.outQuad } )

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

local goodWords = 
{
	happy = 0,
	love = 0,
	god = 0,
	fun = 0,
	family = 0,
	forgive = 0,
	play = 0,
	icecream = 0,
	kids = 0,
	raise = 0,
}
local wordRain = {}
local lastUpdateTime = 0
local numWordsAdded = 0
local numWordsInRain = 0
local numGoodWordsAdded = 0
local numGoodWordsFound = 0
local goodWordsFoundMilestones = { 1, 2, 4 }
local currentgoodWordsFoundMilestone = 1
local goodWordChance = 80
local blahWordIndex = math.random( #blahWords )
local numBlahWordsInARow = 0
local numWordsInTransition = 0
local maxRows = 20
local butnH = display.actualContentHeight/maxRows
local butnW = display.contentWidth/2
local butnFS = 18


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
	numWordsInTransition = numWordsInTransition - 1
	RemoveButton( foundButton )
end

function doneFoundTransition1( foundButton )
	transition.to( foundButton, { time=250, alpha=0.75, onComplete=doneFoundTransition2, xScale=3, yScale=3,iterations=4 } )
end

function handleButtonEvent( event )
	if goodWords[event.target:getLabel()] then
		numGoodWordsFound = numGoodWordsFound + 1
		wordRain[event.target:getLabel()].found = true
		transition.cancel( wordRain[event.target:getLabel()].transition )
		event.target:setEnabled( false )
		numWordsInTransition = numWordsInTransition + 1
		transition.to( event.target, { time=1000, x=(display.actualContentWidth/2), y=(2*display.actualContentHeight/3-numWordsInTransition*butnH*2), onComplete=doneFoundTransition1, rotation = 1440, xScale=2, yScale=2 } )
		if numGoodWordsFound < goodWordsFoundMilestones[1] then
			newC1 = baseColor
			newC2 = unhappyColor
			newC1[4] = numGoodWordsFound/goodWordsFoundMilestones[1]
			newC2[4] = 1 - newC1[4]
			wordRainBkgnd:setFillColor( {
				type = 'gradient',
				color1 = newC1, 
				color2 = newC2,
				direction = "up"
			} )
			goodWordChance = 70
			currentgoodWordsFoundMilestone = 2
		elseif numGoodWordsFound < goodWordsFoundMilestones[2] then
			newC1 = happyColor
			newC2 = unhappyColor
			newC1[4] = numGoodWordsFound/goodWordsFoundMilestones[2]
			newC2[4] = 1 - newC1[4]
			wordRainBkgnd:setFillColor( {
				type = 'gradient',
				color1 = newC1,
				color2 = newC2,
				direction = "down"
			} )
			goodWordChance = 60
			currentgoodWordsFoundMilestone = 3
		elseif numGoodWordsFound < goodWordsFoundMilestones[3] then
			newC1 = baseColor
			newC2 = happyColor
			newC2[4] = numGoodWordsFound/goodWordsFoundMilestones[3]
			newC1[4] = 1 - newC2[4]
			wordRainBkgnd:setFillColor( {
				type = 'gradient',
				color1 = newC1, 
				color2 = newC2,
				direction = "up"
			} )
			goodWordChance = 50
			currentgoodWordsFoundMilestone = 4
		else
			wordRainBkgnd:setFillColor( {
				type = 'gradient',
				color1 = happyColor, 
				color2 = happyColor,
				direction = "up"
			} )
			goodWordChance = 20
		end
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
		if math.random( 100 ) > goodWordChance or numBlahWordsInARow > maxRows/2 then
			goodLabel = GetUnusedGoodWord()
			if goodLabel then
				label = goodLabel
				numGoodWordsAdded = numGoodWordsAdded + 1
				numBlahWordsInARow = 0
				butnInfo.fontSize = butnFS + 2
				if currentgoodWordsFoundMilestone < 4 then
					butnInfo.labelColor  = { default=happyColor, over=happyColor }
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
	thisFrameTime = event.time/2000 
	if thisFrameTime - lastUpdateTime > 1 then
		
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
end

wordRainWidget.TransitionOut = function( time )
	-- Transition Screen out
	transition.to( wordRainWidget.screen, { y = -display.contentHeight, alpha=0, time = time, transition = easing.outQuad } )
	
	-- Remove the frame update
	Runtime:removeEventListener( "enterFrame", wordRainWidget.enterFrame );
end

wordRainWidget.TransitionIn = function( time )
	-- Transition Screen In
	transition.to( wordRainWidget.screen, { y = display.screenOriginY, alpha=1, time = time, transition = easing.outQuad } )

	-- Add the frame update
	Runtime:addEventListener( "enterFrame", wordRainWidget.enterFrame );
end

return wordRainWidget