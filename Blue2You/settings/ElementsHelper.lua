local myApp = require( "myapp" )
local widget = require( "widget" )

function GetStat( userData, statName )
    for k,v in ipairs( userData.Stats ) do
        if v.Name == statName then
            return v
        end
    end
    
    return nil
end

function AddStatWatcher( statName )
    -- look up stat
    local statTable = GetStat( myApp.UserData, statName )
    if statTable ~= nil then
        local data =
        {
            Type = 'StatReport',
            Height = 60,
            Settings = statTable,
        }
        
        return data
    end
    
    return nil
end

function AddQuote( random )
    local quotesTable = myApp.Quotes
    if #quotesTable > 0 then
        local index = math.random( #quotesTable )
        
        local data =
        {
            Type = 'Quote',
            Height = 100,
            Settings = quotesTable[index],
        }
        
        return data
    end
    
    return nil
end

function AddText( text )
    local data =
    {
        Type = 'Text',
        Settings =
        {
            Text = text,
            align = 'left',
        },
    }

    return data
end

function AddImage( filename, width, height, fullscreen )
    local data =
    {
        Type = 'Image',
        Settings =
        {
            FullScreen = fullscreen,
            FileName = filename,
            Width = width,
            Height = height,
        },
    }

    return data
end

function ProcessWidgetElements( row, curYOffset, widgetElements )
    local widgetYOffset = curYOffset
    
    if widgetElements ~= nil then
        for k,v in ipairs( widgetElements ) do
            if v.Type == 'Quote' then
                local quotePanel, height = widget.newWidgetQuotePanel({
                    quote = v.Settings.Quote,
                    source = v.Settings.Source,
                    height = v.Height,
                    y = widgetYOffset,
                    titleX = 20,
                    titleY = 25,---10,
                    descX = 35,---15,
                    descY = 85,---15,
                    backgroundColor = { 0.72, 0.8, 0.92 },
                    titleColor = {0, 0, 0},
                    titleFont = myApp.font,
                    titleFontSize = 16,
                    descColor = {0.2, 0.2, 0.2},
                    descFont = myApp.font,
                    descFontSize = 14,
                })
                row:insert(quotePanel)
                widgetYOffset = widgetYOffset + height
            elseif v.Type == 'Text' then
                local textPanel, height = widget.newWidgetTextPanel({
                    text = v.Settings.Text,
                    height = 10,
                    y = widgetYOffset,
                    textX = 10,
                    textY = 10,
                    backgroundColor = { 0.72, 0.8, 0.92 },
                    textColor = {0, 0, 0},
                    textFont = myApp.font,
                    textFontSize = 14,
                    align = v.Settings.align,
                })
                row:insert(textPanel)
                widgetYOffset = widgetYOffset + height
            elseif v.Type == 'Image' then
                local imagePanel, height = widget.newWidgetImagePanel({
                    image = 
                    {
                        name = v.Settings.FileName,
                        width = v.Settings.Width,
                        height = v.Settings.Height,
                    },
                    height = v.Settings.Height,
                    y = widgetYOffset,
                    imageX = 10,
                    imageY = 10,
                    backgroundColor = { 0.72, 0.8, 0.92 },
                })
                row:insert(imagePanel)
                widgetYOffset = widgetYOffset + height
            elseif v.Type == 'StatReport' then
                
            end
            
        end
    end
end


--function AddShortcutMenu( shortcutTable )
--    
--end
