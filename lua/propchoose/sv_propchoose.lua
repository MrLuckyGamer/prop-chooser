function PCR.ReadBannedProps()
	local path = "phe_config/prop_model_bans"
	
	if !file.Exists(path,"DATA") then
		print("[Prop Chooser] !!WARNING : Prop Hunt: Enhanced's Prop Ban Data does not exists. Did you forgot to install Prop Hunt: Enhanced? Creating the folder anyway...")
		file.CreateDir(path)
	end
	
	if file.Exists(path.."/model_bans.txt","DATA") then
		local read = util.JSONToTable(file.Read(path.."/model_bans.txt"))
		for _,mdl in pairs(read) do
			table.insert(PCR.BannedProp, mdl)
		end
	else
		print("[Prop Chooser] !!WARNING: Prop Hunt: Enhanced's Prop Ban Data does not exists, Ignoring...")
	end
	
	if file.Exists(path.."/pcr_bans.txt","DATA") then
		local read = util.JSONToTable(file.Read(path.."/pcr_bans.txt"))
		for _,mdl in pairs(read) do
			table.insert(PCR.BannedProp, mdl)
		end
	else
		print("[Prop Chooser] !!WARNING: Prop Chooser additional prop bans data does not exists, Creating new one...")
		
		local proplist = { "models/player.mdl", "models/player/kleiner.mdl" }
		local json = util.TableToJSON(proplist,true)
		file.Write(path.."/pcr_bans.txt", json)
		
		print("[Prop Chooser] File successfully created on: phe_config/prop_model_bans/pcr_bans.txt.")
	end
end

function PCR.CheckBBox(entity)
	local min,max = entity:GetCollisionBounds()
	if math.Round(max.x) >= PCR.CVAR.MaxBBOXWidth:GetInt() or
		math.Round(max.y) >= PCR.CVAR.MaxBBOXWidth:GetInt() or 
		math.Round(max.z) >= PCR.CVAR.MaxBBOXHeight:GetInt() then 
			return true 
	end
	return false
end

function PCR.GetCustomProps()
	local path = "phe_config/prop_chooser_custom"
	
	if !file.Exists(path,"DATA") then
		print("[Prop Chooser] Creating default Prop Chooser Prop Data...")
		file.CreateDir(path)
		print("[Prop Chooser] Successfully created: "..path.."!")
	end
	
	if file.Exists(path.."/models.txt","DATA") then
		local read = util.JSONToTable(file.Read(path.."/models.txt"))
		for _,mdl in pairs(read) do
			table.insert(PCR.CustomProp, mdl)
		end
	else
		print("[Prop Chooser] Creating a default Prop Chooser custom prop data...")
		
		local proplist = { "models/balloons/balloon_star.mdl", "models/balloons/balloon_dog.mdl", "models/balloons/balloon_classicheart.mdl" }
		local json = util.TableToJSON(proplist,true)
		file.Write(path.."/models.txt", json)
		
		print("[Prop Chooser] File successfully created on: phe_config/prop_chooser_custom/models.txt.")
	end
end

PCR.PropList = {}
function PCR.PopulateProp()
	PCR.ReadBannedProps()

	local count = 0
	for i,prop in RandomPairs(ents.FindByClass("prop_physics*")) do			
		if (!IsValid(prop:GetPhysicsObject())) then
			print("[Prop Chooser] Warning: Prop "..prop:GetModel().. " @Index #"..prop:EntIndex().." has no physics. Ignoring!")
			continue
		end
		if table.HasValue(PCR.PropList, string.lower(prop:GetModel())) then continue end
		if (PCR.CVAR.EnablePropBan:GetBool() && table.HasValue(PCR.BannedProp, string.lower(prop:GetModel()))) then
			print("[Prop Chooser] Banning a prop of "..prop:GetModel().." @Index #"..prop:EntIndex().."...")
			continue
		end
		if (PCR.CVAR.EnableLimit:GetBool() && PCR.CheckBBox(prop)) then
			print("[Prop Chooser] Found a prop "..prop:GetModel().." @Index #"..prop:EntIndex().." that Exceeds the OBB settings, ignoring...")
			continue
		end
		
		if (PCR.CVAR.EnableMaximum:GetBool() && count == PCR.CVAR.MaximumLimit:GetInt()) then break end
		
		count = count + 1
		table.insert(PCR.PropList, string.lower(prop:GetModel()))
		util.PrecacheModel(prop:GetModel())
	end
	print("[Prop Chooser] Total by "..count.." props was added.")
	
	if PCR.CVAR.AllowCustomProp:GetBool() then
		print("[Prop Chooser] Adding Custom Props as well...")
		PCR.GetCustomProps()
		for i,prop in pairs(PCR.CustomProp) do
			table.insert(PCR.PropList, prop)
			util.PrecacheModel(prop)
		end
	end
end

hook.Add("Initialize", "PCR.PopulateProps", function()
	timer.Simple(math.Rand(2,3), function()
		PCR.PopulateProp()
	end)
end)

util.AddNetworkString("pcr.PropListData")
hook.Add("PlayerInitialSpawn", "PCR.SendPropListData", function(ply)
	timer.Simple(math.random(4,7), function()
		net.Start("pcr.PropListData")
			net.WriteUInt(#PCR.PropList, 32)
			for i=1, #PCR.PropList do
				net.WriteString(PCR.PropList[i])
			end
		net.Send(ply)
	end)
	
	ply:SetNWInt("CurrentUsage", 0)
end)

util.AddNetworkString("pcr.ResetUseLimit")
hook.Add("PostCleanupMap","PCR.ResetUseLimit",function()
	for _,ply in pairs(player.GetAll()) do
		ply:ResetUsage()
	end
end)

util.AddNetworkString("pcr.SetMetheProp")
util.AddNetworkString("pcr.RevertUsage")
net.Receive("pcr.SetMetheProp",function(len,ply)
	local mdl = net.ReadString()
	
	if (!table.HasValue(PCR.PropList, mdl)) then
		print("WARNING: User ".. ply:Nick() .." is trying to use Invalid Prop Model : " .. mdl .. ", which does not exists in the map!")
		ply:ChatPrint("That prop does not seem to exists in the server map.")
		return
	end
	
	local pos = ply:GetPos()
	--Temporarily Spawn a prop.
	local ent = ents.Create("prop_physics")
	ent:SetPos(Vector(pos.x,pos.y,pos.z-512))
	ent:SetAngles(Angle(0,0,0))
	ent:SetKeyValue("spawnflags","654")
	ent:SetNoDraw(true)
	ent:SetModel(mdl)
	
	ent:Spawn()
	
	local usage = ply:CheckUsage()
	local hmx,hz = ent:GetPropSize()
	if !ply:CheckHull(hmx,hmx,hz) then
		if usage > 0 then
			ply:SendLua([[chat.AddText(Color(235,10,15), "[Prop Chooser]", Color(220,220,220), " There is no room to change the prop. Move a little a bit...")]])
		end
	else
		if usage <= -1 then
			GAMEMODE:PlayerExchangeProp(ply,ent)
		elseif usage > 0 then
			ply:UsageSubstractCount()
			GAMEMODE:PlayerExchangeProp(ply,ent)
		end
	end
	ent:Remove()
end)

-- Handles UI
util.AddNetworkString("pcr.ShowUI")
function PCR.KeyUp(ply,key)
	if (IsValid(ply) && key == PCR.CVAR.DefaultKey:GetInt()) then
		net.Start("pcr.ShowUI")
		net.Send(ply)
	end
end
hook.Add("PlayerButtonUp","PCR.PressedKey",function(ply, btn)
	PCR.KeyUp(ply,btn)
end)

concommand.Add("pcr_debug_model_list",function(ply)
	if ply:IsSuperAdmin() || ply:IsAdmin() then
		PrintTable(PCR.PropList)
	else
		ply:ChatPrint("Sorry, you can not use this command.")
	end
end)