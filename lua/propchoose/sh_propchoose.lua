PCR = {}
PCR.__index = PCR

PCR.BannedProp = {}
PCR.CustomProp = {}

local svonly = {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}
PCR.CVAR = {}
PCR.CVAR.EnableFeature 	= CreateConVar("pcr_enable","1",			svonly, "Enable Prop Chooser Feature?")

PCR.CVAR.EnableLimit 	= CreateConVar("pcr_enable_bbox_limit","0", svonly, "[!EXPERIMENTAL] Add BBox Limit before adding to the Prop Chooser Lists?")
PCR.CVAR.MaxBBOXHeight 	= CreateConVar("pcr_bbox_max_height","96", 	svonly, "[!EXPERIMENTAL] BBOX CollissionBound Maximum Height Limit. Default is 96 (normally 72 for standard Kleiner models.")
PCR.CVAR.MaxBBOXWidth 	= CreateConVar("pcr_bbox_max_width","72",  svonly, "[!EXPERIMENTAL] BBOX CollissionBound Maximum Width Limit. Default is 72, 56 or 48.")

PCR.CVAR.AllowCustomProp = CreateConVar("pcr_allow_custom","0",		svonly, "Allow custom prop to be added in the lists?")

PCR.CVAR.EnablePropBan 	= CreateConVar("pcr_enable_prop_ban","0",	svonly, "Allow prop banning before adding to the Prop Chooser Lists?")

PCR.CVAR.EnableMaximum 	= CreateConVar("pcr_max_enable","0",		svonly,"Enable limit into Maximum Prop Entries (see pcr_max_prop_list for how many props model you'll need to limit.")
PCR.CVAR.MaximumLimit 	= CreateConVar("pcr_max_prop_list","100",	svonly, "Maximum list that props will be listed.")

PCR.CVAR.UseLimit		= CreateConVar("pcr_max_use","3",			svonly, "Maximum usage limit. -1 means unlimited.")

PCR.CVAR.DefaultKey		= CreateConVar("pcr_default_key_menu", KEY_F8, svonly, "Key that should be used to bring up the Prop Chooser Menu. Default is KEY_F8 (Decimal: 9).\nSee on this Wiki for buttons: https://wiki.garrysmod.com/page/Enums/BUTTON_CODE")

--Donate window
PCR.CVAR.EnableDonationLink = CreateConVar("pcr_enable_about","1",	svonly,"Enable about window? It's okay to turn it off btw.")

local ADDON_INFO = {
	name	= "Prop Chooser",
	version	= "1.0",
	info	= "A Prop Chooser. Press [F8] by default to open Prop Chooser, when in Emergency use!",
	
	settings = {
		{"pcr_enable", "check", "SERVER", "Enable Prop Chooser Feature"},
		{"pcr_enable_bbox_limit", "check", "SERVER", "[!EXPERIMENTAL] Add BBox Limit before adding to the Prop Chooser Lists?" },
		{"pcr_bbox_max_height" , "slider", {min = 16, max = 256, init = 96, dec = 0, kind = "SERVER"}, "[!EXPERIMENTAL] BBOX CollissionBound Maximum Height Limit." },
		{"pcr_bbox_max_width" , "slider", {min = 16, max = 256, init = 72, dec = 0, kind = "SERVER"}, "[!EXPERIMENTAL] BBOX CollissionBound Maximum Width Limit." },		
		{"pcr_allow_custom", "check", "SERVER", "Allow custom prop to be added in the lists?" },
		{"pcr_enable_prop_ban", "check", "SERVER", "Allow prop banning before adding to the Prop Chooser Lists?" },
		{"pcr_max_enable", "check", "SERVER", "Enable limit into Maximum Prop Entries (see pcr_max_prop_list for how many props model you'll need to limit.)"},
		{"pcr_max_prop_list" , "slider", {min = 20, max = 2048, init = 100, dec = 0, kind = "SERVER"}, "Maximum list that props will be listed."},
		{"pcr_max_use" , "slider", {min = -1, max = 20, init = 3, dec = 0, kind = "SERVER"}, "Maximum usage limit. -1 means unlimited."},
		{"pcr_enable_about", "check", "SERVER", "Enable about window?"}
	},
	
	client	= {}
}
list.Set("PHE.Plugins","Prop Chooser",ADDON_INFO)