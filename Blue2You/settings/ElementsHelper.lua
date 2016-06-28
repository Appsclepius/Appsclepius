local myApp = require( "myapp" )

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

--function AddShortcutMenu( shortcutTable )
--    
--end
