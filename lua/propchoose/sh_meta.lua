local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")
if !Player then return end
if !Entity then return end

function Entity:GetPropSize()
	local hullxymax = math.Round(math.Max(self:OBBMaxs().x-self:OBBMins().x, self:OBBMaxs().y-self:OBBMins().y))
	local hullz = math.Round(self:OBBMaxs().z - self:OBBMins().z)
	
	return hullxymax,hullz
end

function Player:CheckHull(hx,hy,hz)
	local tr = {}
	tr.start = self:GetPos()
	tr.endpos = self:GetPos()
	tr.filter = {self, self.ph_prop}
	tr.maxs = Vector(hx,hy,hz)
	tr.mins = Vector(-hx,-hy,0)
	
	local trx = util.TraceHull(tr)
	if trx.Hit then return false end
	return true
end

function Player:CheckUsage()
	return self:GetNWInt("CurrentUsage", 0)
end

if SERVER then
	function Player:ResetUsage()
		self:SetNWInt("CurrentUsage", PCR.CVAR.UseLimit:GetInt() or 0)
	end

	function Player:UsageAddCount()
		local cur = self:CheckUsage()
		self:SetNWInt("CurrentUsage", cur + 1)
	end

	function Player:UsageSubstractCount()
		local cur = self:CheckUsage()
		self:SetNWInt("CurrentUsage", cur - 1)
	end

end