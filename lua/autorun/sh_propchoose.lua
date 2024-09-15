if SERVER then
	AddCSLuaFile("propchoose/sh_propchoose.lua")
	AddCSLuaFile("propchoose/sh_meta.lua")
	AddCSLuaFile("propchoose/cl_propchoose.lua")
	
	include("propchoose/sh_propchoose.lua")
	include("propchoose/sh_meta.lua")
	include("propchoose/sv_propchoose.lua")
else
	include("propchoose/sh_propchoose.lua")
	include("propchoose/sh_meta.lua")
	include("propchoose/cl_propchoose.lua")
end

hook.Add("Initialize","CheckPHEifExists",function()
	if engine.ActiveGamemode() == "prop_hunt" then
		if !PHE then
			ErrorNoHalt("WARNING: It seems you do not have Prop Hunt: Enhanced Installed. some of it's function may not work properly.")
		else
			print("[Prop Chooser] Prop Hunt: Enhanced Detected. Continuing...")
		end
	end
end)