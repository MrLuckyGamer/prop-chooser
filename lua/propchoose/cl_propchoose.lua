PCR.PropList = {}
net.Receive("pcr.PropListData", function()
	local total = net.ReadUInt(32)
	for i=1,total do
		local model = net.ReadString()
		table.insert(PCR.PropList, model)
	end
end)

PCR.WindowControl = {}
function PCR.WindowControl.MainFrame(ls)
	if !PCR.CVAR.EnableFeature:GetBool() then
		chat.AddText(Color(235,10,15), "[Prop Chooser]", Color(220,220,220), " This feature is disabled.")
		return
	end
	
	if LocalPlayer():Alive() && LocalPlayer():Team() == TEAM_PROPS then
		local str = "0"
		local uselimit = LocalPlayer():CheckUsage()
		
		if uselimit == 0 then
			chat.AddText(Color(10,235,30), "[Prop Chooser]", Color(220,220,220), " You have reached the limit!")
			return
		end
		if uselimit <= -1 then str = "Unlimited" end
		if uselimit > 0 then str = tostring(uselimit) end
		
		local f = {}
		
		f.frame = vgui.Create("DFrame")
		f.frame:SetPos(30,25)
		f.frame:SetSize(400,ScrH()-45)
		f.frame:SetTitle("[Prop Chooser] Change Prop")
		f.frame:SetVisible(true)
		f.frame:ShowCloseButton(true)
		f.frame:SetMouseInputEnabled(true)
		f.frame:SetKeyboardInputEnabled(true)
		
		f.frame:SetDraggable(true)
		
		-- top panel --
		f.panel = vgui.Create("DPanel",f.frame)
		f.panel:Dock(TOP)
		f.panel:SetSize(0,72)
		f.panel:DockMargin(8,4,8,0)
		f.panel:SetBackgroundColor(Color(64,64,64))
		
		-- container of top panel --	
		local font = "Trebuchet24"
		local font2 = "HudHintTextLarge"
		f.panel.PaintOver = function(self,w,h)
			surface.SetFont(font)
			draw.DrawText("Select any prop you want. You have",font2,w/2,h/2-32,Color(200,200,200),TEXT_ALIGN_CENTER)
			draw.DrawText(str.." usage limit",font,w/2,h/2-16,Color(255,255,30),TEXT_ALIGN_CENTER)
			draw.DrawText("to use this prop chooser!",font2,w/2,h/2+12,Color(200,200,200),TEXT_ALIGN_CENTER)
		end
		
		-- body panel --
		f.body = vgui.Create("DPanel",f.frame)
		f.body:Dock(FILL)
		f.body:DockMargin(8,4,8,4)
		
		f.gridscrl = vgui.Create("DScrollPanel", f.body)
		f.gridscrl:Dock(FILL)
		f.gridscrl:DockMargin(4,2,4,2)
		
		-- container of body --
		f.grid = vgui.Create("DGrid",f.gridscrl)
		f.grid:SetPos(10,10)
		f.grid:SetSize(f.gridscrl:GetWide(),f.gridscrl:GetTall())
		f.grid:SetCols(5)
		f.grid:SetColWide(67)
		f.grid:SetRowHeight(66)
		f.grid:SetVerticalScrollbarEnabled(true)
		
		for _,p in pairs(ls) do
			local pan = vgui.Create("DPanel")
			pan:SetSize(64,64)
			pan:SetBackgroundColor(Color(100,100,100))
			
			local icon = vgui.Create("SpawnIcon",pan)
			icon:SetModel(Model(p))
			icon:SetSize(64,64)
			icon:SetToolTip(p)
			
			icon.DoClick = function()
				local xtr = "0"
				if uselimit <= -1 then  xtr = "Unlimited" end
				if uselimit > 0 then xtr = tostring(uselimit - 1) end
				net.Start("pcr.SetMetheProp")
				net.WriteString(p)
				net.SendToServer()
				notification.AddLegacy("[Prop Chooser] You have ".. xtr .." usage left!", NOTIFY_GENERIC, 5)
				f.frame:Close()
			end
			f.grid:AddItem(pan)
		end
		
		-- footer panel --
		if PCR.CVAR.EnableDonationLink:GetBool() then
			f.footer = vgui.Create("DPanel",f.frame)
			f.footer:Dock(BOTTOM)
			f.footer:SetSize(0,32)
			f.footer:DockMargin(8,0,8,4)
			
			-- footer container --
			f.text = vgui.Create("DLabel",f.footer)
			f.text:Dock(TOP)
			f.text:SetSize(0,f.footer:GetTall()/2+8)
			f.text:DockMargin(12,4,12,0)
			f.text:SetFont("Trebuchet18")
			f.text:SetColor(Color(0,0,0))
			f.text:SetText("Made by Wolvindra-Vinzuerio.")
			f.text:SetContentAlignment(4)
			
			f.button = vgui.Create("DButton",f.footer)
			f.button:SetText("  Support my Addons!")
			f.button:SetPos(224,4)
			f.button:SetSize(140,24)
			f.button:SetIcon("icon16/heart.png")
			f.button.DoClick = function()
				gui.OpenURL("https://prophuntenhanced.xyz/donate")
				f.frame:Close()
			end
		end
		
		f.frame:MakePopup()
		f.frame:SetKeyboardInputEnabled(false)
	else
	
		chat.AddText(Color(10,235,30), "[Prop Chooser]", Color(220,220,220), " This feature is not available at this moment.")
		
	end
end

function PCR.AddProps()
	PCR.WindowControl.MainFrame(PCR.PropList)
end

concommand.Add("phe_access_propchoose", PCR.AddProps)

net.Receive("pcr.ShowUI", function()
	PCR.AddProps()
end)