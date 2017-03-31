/*---------------------------------------------------------------------------
	
	WattyHud v0.1
	Based on the works of: TheCodingBeast - TheCodingBeast.com
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
	
---------------------------------------------------------------------------*/

--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]
local Settings = {}

Settings.X 	= "left"	--> Left, 	Center, Right.
Settings.Y 	= "bottom"	--> Top,	Center, Bottom.

Settings.Color_Bg		= Color( 33, 33, 33, 255 )
Settings.Color_Hg 		= Color( 70, 70, 70, 255 )
Settings.Color_High		= Color( 222, 222, 222, 255 )

Settings.Color_White 	= Color( 222, 222, 222, 255 )
Settings.Color_Black	= Color( 33, 33, 33, 255 )
Settings.Color_Grey		= Color( 70, 70, 70, 255 )

Settings.Color_Text1 	= Color( 222, 222, 222, 255 )
Settings.Color_Text2 	= Color( 33, 33, 33, 255 )

Settings.Color_Health 	= Color( 222, 222, 222, 255 )
Settings.Color_Armor 	= Color( 222, 222, 222, 255 )
Settings.Color_Stamina	= Color( 222, 222, 222, 255 )
Settings.Color_Hunger 	= Color( 222, 222, 222, 255 )

Settings.Show_Health 	= true
Settings.Show_Armor		= false
Settings.Show_Stamina 	= false
Settings.Show_Hunger 	= false

Settings.Show_Avatar	= true


--[[---------------------------------------------------------
	Name: Size
-----------------------------------------------------------]]
Settings.Width 	= 400
Settings.Height = 100


--[[---------------------------------------------------------
	Name: Position
-----------------------------------------------------------]]
Settings.PosX 	= 10
Settings.PosY 	= 10

--> Box Values
local HudDrawHeight 		= 32
local HUDDrawHeight_Extra 	= 0
local HUDDrawHeight_Health 	= 0
local HUDDrawHeight_Armor 	= 0
local HUDDrawHeight_Stamina = 0
local HUDDrawHeight_Hunger 	= 0

local Valuta		= "Dkk"

local AvatarSize 	= 80
local Edge 			= 2
local offset 		= 10-Edge
local IconTray 		= 40


--> X Pos
if Settings.X 		== "left" then
	Settings.PosX 	= 10
elseif Settings.X 	== "center" then
	Settings.PosX 	= ScrW() / 2 - Settings.Width / 2
elseif Settings.X 	== "right" then
	Settings.PosX 	= ScrW() - Settings.Width - 10	
end

--> Y Pos
if Settings.Y 		== "top" then
	Settings.PosY 	= 10
elseif Settings.Y 	== "center" then
	Settings.PosY 	= ScrH() / 2 - Settings.Height / 2
elseif Settings.Y 	== "bottom" then
	Settings.PosY 	= ScrH() - Settings.Height - 10
end


--[[---------------------------------------------------------
	Name: TextOverflow
-----------------------------------------------------------]]
function TextOverflow( text, font, width )

	surface.SetFont(font)

	local ellipsissize = surface.GetTextSize("...")

	for len = 1, #text do 
		local substr = text:sub(1, len)

		local subsize = surface.GetTextSize(substr)

		if(subsize > width - ellipsissize) then
			return text:sub(1, len - 1) .. "..."
		end
	end

	return text

end


--[[---------------------------------------------------------
	Name: FormatNumber
-----------------------------------------------------------]]
function FormatNumber( n )

	if not n then return "" end

	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1

	for i=dp-4, 1, -3 do

		n = n:sub(1, i) .. sep .. n:sub(i+1)
		
	end

	return n

end


--[[---------------------------------------------------------
	Name: Elements Table
-----------------------------------------------------------]]
local HideElementsTable = {
	
	--> DarkRP
	["DarkRP_HUD"]				= true,
	["DarkRP_EntityDisplay"] 	= true,
	["DarkRP_ZombieInfo"] 		= true,
	["DarkRP_LocalPlayerHUD"] 	= true,
	["DarkRP_Hungermod"] 		= true,
	["DarkRP_Agenda"] 			= true,

	--> GMod
	["CHudHealth"]				= true,
	["CHudBattery"]				= true,
	["CHudSuitPower"]			= true,

}


--[[---------------------------------------------------------
	Name: Hide Elements
-----------------------------------------------------------]]
local function HideElements( element )
	if HideElementsTable[ element ] then
		
		--> Stop Draw
		return false

	end
end
hook.Add( "HUDShouldDraw", "HideElements", HideElements )


--[[---------------------------------------------------------
	Name: Base Panel
-----------------------------------------------------------]]
local function HUD_Base()

	--> Background
	draw.RoundedBox( 0, Settings.PosX, Settings.PosY, Settings.Width, Settings.Height, Settings.Color_Black )

end


--[[---------------------------------------------------------
	Name: PlayerModel Panel
-----------------------------------------------------------]]
local function HUD_Player()

	--> Background
	draw.RoundedBox( 0, Settings.PosX+offset, Settings.PosY+offset, 80 + (Edge*2), 80 + (Edge*2), Settings.Color_White )

end


--[[---------------------------------------------------------
	Name: PlayerModel
-----------------------------------------------------------]]
local CamPos = Vector( 15, 4, 60 )
local LookAt = Vector( 0, 0, 60 )
local function PlayerModel()

	--> Create
	PlayerModel = vgui.Create( "DModelPanel" )
	function PlayerModel:LayoutEntity( Entity ) return end
	PlayerModel:SetModel( LocalPlayer():GetModel() )
	PlayerModel:SetPos( Settings.PosX+10, Settings.PosY+10 )
	PlayerModel:SetSize( 80, 80 )
	PlayerModel:ParentToHUD()
	PlayerModel.Entity:SetPos( PlayerModel.Entity:GetPos() - Vector( 0, 0, 4 ) )
	PlayerModel:SetCamPos( CamPos )
	PlayerModel:SetLookAt( LookAt )

	timer.Create( "tcb_v4_update", 1, 0, function()
		if LocalPlayer():GetModel() != PlayerModel.Entity:GetModel() then
			
			--> Remove Panel
			PlayerModel:Remove()

			--> Create Panel
			PlayerModel = vgui.Create( "DModelPanel" )
			function PlayerModel:LayoutEntity( Entity ) return end
			PlayerModel:SetModel( LocalPlayer():GetModel() )
			PlayerModel:SetPos( Settings.PosX+10, Settings.PosY+10 )
			PlayerModel:SetSize( 80, 80 )
			PlayerModel:ParentToHUD()
			PlayerModel.Entity:SetPos( PlayerModel.Entity:GetPos() - Vector( 0, 0, 4 ) )
			PlayerModel:SetCamPos( CamPos )
			PlayerModel:SetLookAt( LookAt )

		end
	end )

end

--

--[[---------------------------------------------------------
	Name: Player Avatar
-----------------------------------------------------------]]
local avatar
function HUDValidCheck()

    if IsValid( LocalPlayer() ) && !IsValid( avatar ) then
    
        avatar= vgui.Create( "AvatarImage" )
    
        avatar:SetSize( 80, 80 )
        avatar:SetPos( Settings.PosX+offset+Edge, Settings.PosY+offset+Edge )
        avatar:SetPlayer( LocalPlayer(), 80 )
    
    end

end


if Settings.Show_Avatar then
	hook.Add( "HUDPaint", "WattyAvatar", HUDValidCheck )
	Edge = 2
else 
	hook.Add( "InitPostEntity", "PlayerModel", PlayerModel )
	Edge = 0
end

--[[---------------------------------------------------------
	Name: Info Panel
-----------------------------------------------------------]]
local Person = Material( "icon/ic_person.png" )
local Money = Material( "icon/ic_money.png" )
local function HUD_Info()

	--> Variables
	local InfoWidth 	= Settings.Width - 80 - 30
	local InfoHeight 	= 60 + Edge
	local InfoOffset	= 5
	
	local Info_X 		= Settings.PosX + AvatarSize + IconTray
	local Info_Y 		= Settings.PosY + InfoOffset
	
	local InfoSpacing 	= 20

	--> Text Variables
	local PlayerNameVar 	= LocalPlayer():Nick() or ""
	local PlayerJobVar 		= LocalPlayer():getDarkRPVar( "job" ) or ""
	local PlayerWalletVar 	= LocalPlayer():getDarkRPVar( "money" ) or 0
	local PlayerSalaryVar 	= LocalPlayer():getDarkRPVar( "salary" ) or 0

	local PlayerName 	= TextOverflow( PlayerNameVar, 	"WATTY_HUD_18", InfoWidth/2 )
	local PlayerJob		= TextOverflow( PlayerJobVar, 	"WATTY_HUD_16", InfoWidth/2 )
	local PlayerWallet 	= Valuta..FormatNumber( PlayerWalletVar )
	local PlayerSalary 	= FormatNumber( PlayerSalaryVar )

	--> Draw Text
	draw.DrawText( PlayerName, 	"WATTY_HUD_22", Info_X, Info_Y, Settings.Color_Text1, 0 )
	draw.DrawText( PlayerJob, 	"WATTY_HUD_16", Info_X, Info_Y + InfoSpacing, Settings.Color_Text1, 0 )
	draw.DrawText( PlayerWallet.." ("..PlayerSalary..")", 	"WATTY_HUD_16", Info_X, Info_Y + InfoHeight - InfoOffset, Settings.Color_Text1, 0 )
	--draw.DrawText( PlayerSalary, 	"WATTY_HUD_16", Divider2_X+(InfoWidth/2)/2, Divider_Y+4, Settings.Color_Text1, 0 )
	
	--> Draw icon
	surface.SetMaterial( Person )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( Info_X - (IconTray/2) - 1, Info_Y + 5, 12, 12)
	surface.SetMaterial( Money )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( Info_X - (IconTray/2) - 1, Info_Y + InfoHeight - InfoOffset + 1, 12, 12)

end


--[[---------------------------------------------------------
	Name: Health Panel
-----------------------------------------------------------]]
local Heart = Material( "icon/ic_heart.png" )
local function HUD_Health()

	--> Variables
	local DrawHeight 	= 10
	local HealthDrawY 	= Settings.PosY + Settings.Height - (offset + DrawHeight)
	local HealthDrawX 	= Settings.PosX + AvatarSize + IconTray
	local DrawWidth 	= Settings.Width - HealthDrawX

	--> Background
	draw.RoundedBox( 0, HealthDrawX, HealthDrawY, DrawWidth, DrawHeight, Settings.Color_Grey )

	--> Draw
	local DrawValue	= LocalPlayer():Health() or 0
	local EchoValue	= LocalPlayer():Health() or 0
	
	--if DrawValue < 0 then DrawValue = 0 elseif DrawValue > 100 then DrawValue = 100 end
	DrawValue = math.Clamp( DrawValue, 0, 100 )
	
	if DrawValue != 0 then
		draw.RoundedBox( 0, HealthDrawX, HealthDrawY, DrawWidth * DrawValue / 100, DrawHeight, Settings.Color_White )
	end
	
	surface.SetMaterial( Heart )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( HealthDrawX - (IconTray/2) - 1, HealthDrawY - 1, 12, 12)

	--> Text Variables
	--local DrawText 	= "Health: "..EchoValue.."%"
	--local DrawTextX = Settings.PosX+DrawWidth/2
	--local DrawTextY = HealthDrawY+2

	--> Text
	--draw.DrawText( DrawText, "WATTY_HUD_18", DrawTextX, DrawTextY, Settings.Color_Text2, 1 )

end


--[[---------------------------------------------------------
	Name: Armor Panel
-----------------------------------------------------------]]
local function HUD_Armor()

	--> Variables
	local ArmorDrawY = Settings.PosY + Settings.Height - 32 - HUDDrawHeight_Armor

	--> Background
	draw.RoundedBox( 0, Settings.PosX+10, ArmorDrawY, Settings.Width - 20, 22, Settings.Color_Hg )

	--> Draw
	local DrawValue	= LocalPlayer():Armor() or 0
	local EchoValue	= LocalPlayer():Armor() or 0
	local DrawWidth = Settings.Width - 20

	if DrawValue < 0 then DrawValue = 0 elseif DrawValue > 100 then DrawValue = 100 end

	if DrawValue != 0 then
		draw.RoundedBox( 0, Settings.PosX+10, ArmorDrawY, DrawWidth * DrawValue / 100, 22, Settings.Color_Armor )
	end

	--> Text Variables
	local DrawText 	= "Armor: "..EchoValue.."%"
	local DrawTextX = Settings.PosX+DrawWidth/2
	local DrawTextY = ArmorDrawY+2

	--> Text
	draw.DrawText( DrawText, "WATTY_HUD_18", DrawTextX, DrawTextY, Settings.Color_Text2, 1 )

end


--[[---------------------------------------------------------
	Name: Stamina Panel
-----------------------------------------------------------]]
local function HUD_Stamina()

	--> Variables
	local StaminaDrawY = Settings.PosY + Settings.Height - 32 - HUDDrawHeight_Stamina

	--> Background
	draw.RoundedBox( 0, Settings.PosX+10, StaminaDrawY, Settings.Width - 20, 22, Settings.Color_Hg )

	--> Draw
	local DrawValue	= LocalPlayer():GetNWInt( "tcb_stamina" ) or 0
	local EchoValue	= LocalPlayer():GetNWInt( "tcb_stamina" ) or 0
	local DrawWidth = Settings.Width - 20

	if DrawValue < 0 then DrawValue = 0 elseif DrawValue > 100 then DrawValue = 100 end

	if DrawValue != 0 then
		draw.RoundedBox( 0, Settings.PosX+10, StaminaDrawY, DrawWidth * DrawValue / 100, 22, Settings.Color_Stamina )
	end

	--> Text Variables
	local DrawText 	= "Stamina: "..EchoValue.."%"
	local DrawTextX = Settings.PosX+DrawWidth/2
	local DrawTextY = StaminaDrawY+2

	--> Text
	draw.DrawText( DrawText, "WATTY_HUD_18", DrawTextX, DrawTextY, Settings.Color_Text2, 1 )

end


--[[---------------------------------------------------------
	Name: Stamina Panel
-----------------------------------------------------------]]
local function HUD_Hunger()

	--> Variables
	local HungerDrawY = Settings.PosY + Settings.Height - 32 - HUDDrawHeight_Hunger

	--> Background
	draw.RoundedBox( 0, Settings.PosX+10, HungerDrawY, Settings.Width - 20, 22, Settings.Color_Hg )

	--> Draw
	local DrawValue	= math.ceil( LocalPlayer():getDarkRPVar( "Energy" ) or 0 )
	local EchoValue	= math.ceil( LocalPlayer():getDarkRPVar( "Energy" ) or 0 )
	local DrawWidth = Settings.Width - 20

	if DrawValue < 0 then DrawValue = 0 elseif DrawValue > 100 then DrawValue = 100 end

	if DrawValue != 0 then
		draw.RoundedBox( 0, Settings.PosX+10, HungerDrawY, DrawWidth * DrawValue / 100, 22, Settings.Color_Hunger )
	end

	--> Text Variables
	local DrawText 	= "Hunger: "..EchoValue.."%"
	local DrawTextX = Settings.PosX+DrawWidth/2
	local DrawTextY = HungerDrawY+2

	--> Text
	draw.DrawText( DrawText, "WATTY_HUD_18", DrawTextX, DrawTextY, Settings.Color_Text2, 1 )

end




--[[---------------------------------------------------------
	Name: DarkRP Elements
-----------------------------------------------------------]]




--[[---------------------------------------------------------
	Name: GunLicense
-----------------------------------------------------------]]
local Page = Material( "icon/ic_page.png" )
local function GunLicense()
	if LocalPlayer():getDarkRPVar( "HasGunlicense" ) then

		surface.SetMaterial( Page )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( Settings.PosX + Settings.Width - 22, Settings.PosY + 22, 12, 12)

	end
end



--[[---------------------------------------------------------
	Name: Agenda
-----------------------------------------------------------]]
local agendaText
local function Agenda()

	local agenda = LocalPlayer():getAgendaTable()
	if not agenda then return end
	agendaText = agendaText or DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "DarkRPHUD1", 440)

	draw.RoundedBox( 10, 10, 10, 460, 110, Color(0, 0, 0, 155) )
	draw.RoundedBox( 10, 12, 12, 456, 106, Color(51, 58, 51,100) )
	draw.RoundedBox( 10, 12, 12, 456, 20, Color(0, 0, 70, 100) )

	draw.DrawNonParsedText( agenda.Title, "DarkRPHUD1", 30, 12, Color(255, 0, 0, 255), 0 )
	draw.DrawNonParsedText( agendaText, "DarkRPHUD1", 30, 35, Color(255, 255, 255, 255), 0 )

end


--[[---------------------------------------------------------
	Name: DarkRPVarChanged
-----------------------------------------------------------]]
hook.Add( "DarkRPVarChanged", "agendaHUD", function(ply, var, _, new)

	if ply != LocalPlayer() then return end

	if var == "agenda" and new then
		agendaText = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "DarkRPHUD1", 440)
	else
		agendaText = nil
	end

end )


--[[---------------------------------------------------------
	Name: DrawVoiceChat
-----------------------------------------------------------]]
local VoiceChatTexture = surface.GetTextureID( "voice/icntlk_pl" )
local function DrawVoiceChat()
	if LocalPlayer().DRPIsTalking then

		local chbxX, chboxY = chat.GetChatBoxPos()

		local Rotating = math.sin(CurTime()*3)
		local backwards = 0

		if Rotating < 0 then
			Rotating = 1-(1+Rotating)
			backwards = 180
		end

		surface.SetTexture( VoiceChatTexture )
		surface.SetDrawColor( 140, 0, 0, 180 )
		surface.DrawTexturedRectRotated( ScrW() - 100, chboxY, Rotating*96, 96, backwards )

	end
end


--[[---------------------------------------------------------
	Name: LockDown
-----------------------------------------------------------]]
local function LockDown()

	local chbxX, chboxY = chat.GetChatBoxPos()

	if GetGlobalBool("DarkRP_LockDown") then

		local cin = (math.sin(CurTime()) + 1) / 2
		local chatBoxSize = math.floor(ScrH() / 4)

		draw.DrawNonParsedText(DarkRP.getPhrase("lockdown_started"), "ScoreboardSubtitle", chbxX, chboxY + chatBoxSize, Color(cin * 255, 0, 255 - (cin * 255), 255), TEXT_ALIGN_LEFT)
	
	end

end

--[[---------------------------------------------------------
	Name: Arrested
-----------------------------------------------------------]]
local Arrested = function() end
usermessage.Hook( "GotArrested", function(msg)

	local StartArrested = CurTime()
	local ArrestedUntil = msg:ReadFloat()

	Arrested = function()

		if CurTime() - StartArrested <= ArrestedUntil and LocalPlayer():getDarkRPVar("Arrested") then

			draw.DrawNonParsedText(DarkRP.getPhrase("youre_arrested", math.ceil(ArrestedUntil - (CurTime() - StartArrested))), "DarkRPHUD1", ScrW()/2, ScrH() - ScrH()/12, Color(255, 255, 255, 255), 1)
		
		elseif not LocalPlayer():getDarkRPVar("Arrested") then

			Arrested = function() end

		end

	end

end )


--[[---------------------------------------------------------
	Name: AdminTell
-----------------------------------------------------------]]
local AdminTell = function() end
usermessage.Hook( "AdminTell", function(msg)

	timer.Destroy("DarkRP_AdminTell")
	local Message = msg:ReadString()

	AdminTell = function()

		draw.RoundedBox(4, 10, 10, ScrW() - 20, 110, Color(0, 0, 0, 200))
		draw.DrawNonParsedText(DarkRP.getPhrase("listen_up"), "GModToolName", ScrW() / 2 + 10, 10, Color(255, 255, 255, 255), 1)
		draw.DrawNonParsedText(Message, "ChatFont", ScrW() / 2 + 10, 90, Color(200, 30, 30, 255), 1)

	end

	timer.Create("DarkRP_AdminTell", 10, 1, function()
		AdminTell = function() end
	end)

end )


--[[---------------------------------------------------------
	Name: DrawPlayerInfo
-----------------------------------------------------------]]
local plyMeta = FindMetaTable("Player")
plyMeta.drawPlayerInfo = plyMeta.drawPlayerInfo or function(self)

	local pos = self:EyePos()

	pos.z = pos.z + 10
	pos = pos:ToScreen()
	if not self:getDarkRPVar("wanted") then
		pos.y = pos.y - 50
	end

	if GAMEMODE.Config.showname then
		local nick, plyTeam = self:Nick(), self:Team()
		draw.DrawNonParsedText(nick, "DarkRPHUD2", pos.x + 1, pos.y + 1, Color(0, 0, 0, 255), 1)
		draw.DrawNonParsedText(nick, "DarkRPHUD2", pos.x, pos.y, RPExtraTeams[plyTeam] and RPExtraTeams[plyTeam].color or team.GetColor(plyTeam) , 1)
	end

	if GAMEMODE.Config.showhealth then
		local health = DarkRP.getPhrase("health", self:Health())
		draw.DrawNonParsedText(health, "DarkRPHUD2", pos.x + 1, pos.y + 21, Color(0, 0, 0, 255), 1)
		draw.DrawNonParsedText(health, "DarkRPHUD2", pos.x, pos.y + 20, Color(255, 255, 255, 200), 1)
	end

	if GAMEMODE.Config.showjob then
		local teamname = self:getDarkRPVar("job") or team.GetName(self:Team())
		draw.DrawNonParsedText(teamname, "DarkRPHUD2", pos.x + 1, pos.y + 41, Color(0, 0, 0, 255), 1)
		draw.DrawNonParsedText(teamname, "DarkRPHUD2", pos.x, pos.y + 40, Color(255, 255, 255, 200), 1)
	end

	if self:getDarkRPVar("HasGunlicense") then
		surface.SetMaterial(Page)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect( Settings.PosX + Settings.Width + 10, Settings.PosY + Settings.Height - 32, 32, 32)
	end

end


--[[---------------------------------------------------------
	Name: DrawWantedInfo
-----------------------------------------------------------]]
plyMeta.drawWantedInfo = plyMeta.drawWantedInfo or function(self)

	if not self:Alive() then return end

	local pos = self:EyePos()
	if not pos:isInSight({LocalPlayer(), self}) then return end

	pos.z = pos.z + 10
	pos = pos:ToScreen()

	if GAMEMODE.Config.showname then
		draw.DrawNonParsedText(self:Nick(), "DarkRPHUD2", pos.x + 1, pos.y + 1, Color(0, 0, 0, 255), 1)
		draw.DrawNonParsedText(self:Nick(), "DarkRPHUD2", pos.x, pos.y, team.GetColor(self:Team()), 1)
	end

	local wantedText = DarkRP.getPhrase("wanted", tostring(self:getDarkRPVar("wantedReason")))

	draw.DrawNonParsedText(wantedText, "DarkRPHUD2", pos.x, pos.y - 40, Color(255, 255, 255, 200), 1)
	draw.DrawNonParsedText(wantedText, "DarkRPHUD2", pos.x + 1, pos.y - 41, Color(255, 0, 0, 255), 1)

end


--[[---------------------------------------------------------
	Name: DrawEntityDisplay
-----------------------------------------------------------]]
local function DrawEntityDisplay()

	local shootPos = LocalPlayer():GetShootPos()
	local aimVec = LocalPlayer():GetAimVector()

	for k, ply in pairs(players or player.GetAll()) do
		if ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() then continue end
		local hisPos = ply:GetShootPos()
		if ply:getDarkRPVar("wanted") then ply:drawWantedInfo() end

		if GAMEMODE.Config.globalshow then
			ply:drawPlayerInfo()
		-- Draw when you're (almost) looking at player
		elseif hisPos:DistToSqr(shootPos) < 160000 then
			local pos = hisPos - shootPos
			local unitPos = pos:GetNormalized()
			if unitPos:Dot(aimVec) > 0.95 then
				local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
				if trace.Hit and trace.Entity ~= ply then return end
				ply:drawPlayerInfo()
			end
		end
	end

	local tr = LocalPlayer():GetEyeTrace()

	if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
		tr.Entity:drawOwnableInfo()
	end

end


--[[---------------------------------------------------------
	Name: HUD Paint
-----------------------------------------------------------]]
function GAMEMODE:DrawDeathNotice(x, y)

	if not GAMEMODE.Config.showdeaths then return end

	self.BaseClass:DrawDeathNotice(x, y)

end


--[[---------------------------------------------------------
	Name: HUD Paint
-----------------------------------------------------------]]
local function DisplayNotify(msg)

	local txt = msg:ReadString()
	GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("buttons/lightswitch2.wav")

	-- Log to client console
	print(txt)

end
usermessage.Hook("_Notify", DisplayNotify)


--[[---------------------------------------------------------
	Name: HUD Paint
-----------------------------------------------------------]]
local function TCB_V4_Paint()

	--> Custom Elements
	HUD_Base()

	HUD_Player()
	HUD_Info()

	if Settings.Show_Health 	then HUD_Health() 	end
	if Settings.Show_Armor 		then HUD_Armor() 	end
	if Settings.Show_Stamina 	then HUD_Stamina() 	end
	if Settings.Show_Hunger 	then HUD_Hunger() 	end

	--> Default Elements (DarkRP)
	GunLicense()
	Agenda()
	DrawVoiceChat()
	LockDown()

	Arrested()
	AdminTell()

	DrawEntityDisplay()

	GAMEMODE.BaseClass:HUDPaint()


end
hook.Add( "HUDPaint", "TCB_V4_Paint", TCB_V4_Paint )