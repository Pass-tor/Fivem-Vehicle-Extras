_menuPool = NativeUI.CreatePool()
local a = 0
if Config.MenuOrientation == 0 then
    a = 0
elseif Config.MenuOrientation == 1 then
    a = 1320
else
    a = 0
end
local b = ""
if Config.MenuTitle == 0 then
    b = "Extras Menu"
elseif Config.MenuTitle == 1 then
    local c = GetPlayerPed(-1)
    b = GetPlayerName(c)
elseif Config.MenuTitle == 2 then
    b = Config.MenuTitleCustom
else
    b = "Extras Menu"
end
function ShowNotification(d)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(d)
    DrawNotification(false, false)
end
function ExtraChanger(c, e, f)
    local g = {["vehicleExtras"] = {}}
    local h = {["vehicle"] = {}}
    for i = 0, 20 do
        if DoesExtraExist(e, i) then
            g.vehicleExtras[i] = IsVehicleExtraTurnedOn(e, i) == 1
        end
    end
    for j, k in pairs(Config.CustomNames) do
        for l, m in pairs(g.vehicleExtras) do
            if GetEntityModel(e) == GetHashKey(k.vehicle) then
                x = "" .. l .. ""
                local n =
                    NativeUI.CreateCheckboxItem(
                    k.extra[x],
                    g.vehicleExtras[l],
                    "Toggle for " .. k.extra[x] .. " | Extra #" .. l
                )
                mainMenu:AddItem(n)
                h.vehicle[l] = n
            else
                local n = NativeUI.CreateCheckboxItem("Extra " .. l, g.vehicleExtras[l], "Toggle for Extra " .. l)
                mainMenu:AddItem(n)
                h.vehicle[l] = n
            end
        end
    end
    mainMenu.OnCheckboxChange = function(o, p, q)
        for l, m in pairs(h.vehicle) do
            if p == m then
                g.vehicleExtras[l] = q
                if g.vehicleExtras[l] then
                    SetVehicleExtra(e, l, 0)
                else
                    SetVehicleExtra(e, l, 1)
                end
            end
        end
    end
end
function CreditsSection(c, e, f)
    local r =
        _menuPool:AddSubMenu(
        f,
        "Menu Info / Credits",
        "Information about the ~y~Extra Menu ~w~and the creators.",
        true,
        true
    )
    r:AddItem(
        NativeUI.CreateItem(
            "Menu Information",
            "The ~y~Extra Menu ~w~was created to make changing extras easier, and to allow for custom names to be added for extras for custom vehicles in servers."
        )
    )
    r:AddItem(NativeUI.CreateItem("Creators Information", "This menu was created by ~r~YAKUZA DEVELOPMENT~w~."))
    r:AddItem(NativeUI.CreateItem("Links", "~o~discord.gg/Vykg5uC7VG.org ~w~| ~b~discord.Yakuza Development"))
    r:SetMenuWidthOffset(Config.MenuWidth)
end
function openMenu(c, e)
    if mainMenu ~= nil and mainMenu:Visible() then
        mainMenu:Visible(false)
        return
    end
    mainMenu = NativeUI.CreateMenu(b, "~b~The easy way to change extras!", a)
    _menuPool:Add(mainMenu)
    ExtraChanger(c, e, mainMenu)
    if Config.EnableCredits then
        CreditsSection(c, e, mainMenu)
    end
    mainMenu:SetMenuWidthOffset(Config.MenuWidth)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
end
Citizen.CreateThread(
    function()
        while true do
            if Config.locationOpen == false then
                Citizen.Wait(0)
                _menuPool:ProcessMenus()
                local c = GetPlayerPed(-1)
                local e = GetVehiclePedIsIn(c, false)
                if IsControlJustReleased(1, Config.MenuKey) then
                    if IsPedInAnyVehicle(c, false) and GetPedInVehicleSeat(e, -1) == c then
                        openMenu(c, e)
                        mainMenu:Visible(not mainMenu:Visible())
                    end
                end
                if IsPedInAnyVehicle(c, false) == false then
                    if mainMenu ~= nil and mainMenu:Visible() then
                        mainMenu:Visible(false)
                    end
                end
            end
            if Config.locationOpen == true then
                Citizen.Wait(5)
                local s = GetPlayerPed(-1)
                local t = GetEntityCoords(s)
                for j, u in ipairs(Config.positions) do
                    teleport_text = u[3]
                    loc = {x = u[1][1], y = u[1][2], z = u[1][3], heading = u[1][4]}
                    Red = u[2][1]
                    Green = u[2][2]
                    Blue = u[2][3]
                    DrawMarker(
                        1,
                        loc.x,
                        loc.y,
                        loc.z,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1.501,
                        1.5001,
                        0.5001,
                        Red,
                        Green,
                        Blue,
                        200,
                        0,
                        0,
                        0,
                        0
                    )
                    if CheckPos(t.x, t.y, t.z, loc.x, loc.y, loc.z, 2) then
                        _menuPool:ProcessMenus()
                        local c = GetPlayerPed(-1)
                        local e = GetVehiclePedIsIn(c, false)
                        if IsControlJustReleased(1, Config.MenuKey) then
                            if IsPedInAnyVehicle(c, false) and GetPedInVehicleSeat(e, -1) == c then
                                openMenu(c, e)
                                mainMenu:Visible(not mainMenu:Visible())
                            end
                        end
                        if IsPedInAnyVehicle(c, false) == false then
                            if mainMenu ~= nil and mainMenu:Visible() then
                                mainMenu:Visible(false)
                            end
                        end
                    end
                end
            end
        end
    end
)
if Config.locationOpen == true then
    function CheckPos(x, v, w, y, z, A, B)
        local C = x - y
        local D = C ^ 2
        local E = v - z
        local F = E ^ 2
        local G = w - A
        local H = G ^ 2
        return D + F + H <= B ^ 2
    end
    function alert(I)
        SetTextComponentFormat("STRING")
        AddTextComponentString("~" .. keys[Config.MenuKey] .. "~ | ~w~" .. I)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
end
