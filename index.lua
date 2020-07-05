local tag = "achievements"
local table_a = {
    ["Правда"] = 1,
}
local table_b = {
    [1] = "Правда",
}
if CLIENT then
function SendA(number, bool)
    net.Start(tag)
    net.WriteString(number)
    net.WriteBool(bool)
    net.SendToServer()
    if file.Exists("sraka.txt", "DATA") then return end
    file.Write("sraka.txt", "1")
    net.Start(tag .. "_create")
    net.SendToServer()
end
hook.Add("OnPlayerChat", "vutka_pidr", function(ply, txt)
    if ply ~= LocalPlayer() then return end
    if txt == "вутка гей" then SendA(table_a["Правда"], true) end
end)
end

if SERVER then
util.AddNetworkString(tag)
util.AddNetworkString(tag .. "_create")
net.Receive(tag .. "_create", function(l, ply)
    sql.Query("INSERT INTO achievements(SteamID, a1, a2, a3) VALUES('".. ply:SteamID() .."', 0, 0, 0)")
end)
net.Receive(tag, function(l, ply)
    local number = net.ReadString()
    local bool = net.ReadBool()
    if bool then bool = 1 else bool = 0 end
    if tonumber(number) == 1 and tonumber(bool) == 1 then
        if sql.Query('SELECT a1 FROM `achievements` WHERE SteamID = "' .. ply:SteamID() .. '" AND a1="1"') then return end
        PrintMessage(HUD_PRINTTALK, ply:Name() .. " выполнил ачивку: " .. table_b[tonumber(number)])
        sql.Query("UPDATE achievements SET a1="..tonumber(number).." WHERE SteamID='"..ply:SteamID().."'")
    elseif tonumber(number) == 2 and tonumber(bool) == 1 then
        print(123)
    end
end)
end
