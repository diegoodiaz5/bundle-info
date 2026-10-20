local net_string = GLOBAL.net_string
local tonumber = GLOBAL.tonumber

local function FromTableToText(items)
    local text = ""
    for i, item in ipairs(items) do
        if text ~= "" then
            text = text .. "\n"
        end
        text = text .. item[1] .. ":" .. item[2]
    end
    return text
end

local function FromTextToTable(text)
    local items = {}
    for line in string.gmatch(text, "[^\n]+") do
        local name, quantity = string.match(line, "(.+):(%d+)")
        table.insert(items, {name, tonumber(quantity)})
    end
    return items
end

local function FromItemdataToTable(itemdata)
    local items = {}
    for i, regist in ipairs(itemdata) do
        local name = regist.prefab
        local d = regist.data
        local quantity = d and d.stackable and d.stackable.stack or 1
        table.insert(items, {name, quantity})
    end
    return items
end

local function nameWithContent(inst)
    local text = inst.content:value()
    if text == "" then
        return inst.name
    end
    local res = inst.name
    for i, item in ipairs(FromTextToTable(text)) do
        local name = GLOBAL.STRINGS.NAMES[string.upper(item[1])] or item[1]
        res = res .. "\n" .. item[2] .. " x " .. name
    end
    return res
end

AddPrefabPostInit("bundle", function(inst)
    -- 1) server and client
    inst.content = net_string(inst.GUID, "bundleinfo_content")
    inst.displaynamefn = nameWithContent

    -- 2) break if client
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    -- 3) only server
    inst:DoTaskInTime(0, function()
        local unwrappable = inst.components.unwrappable
        if unwrappable and unwrappable.itemdata then
            local tabla = FromItemdataToTable(unwrappable.itemdata)
            inst.content:set(FromTableToText(tabla))
        end
    end)
end)