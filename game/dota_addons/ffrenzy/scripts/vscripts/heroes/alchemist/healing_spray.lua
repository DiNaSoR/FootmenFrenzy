--[[
	Author: Noya
	Date: 25.01.2015.
	Creates a dummy unit to apply the HealingSpray thinker modifier which does the waves
]]
function HealingSprayStart( event )
	local caster = event.caster
	local point = event.target_points[1]

	caster.healing_spray_dummy = CreateUnitByName("dummy_unit_vulnerable", point, false, caster, caster, caster:GetTeam())
	event.ability:ApplyDataDrivenModifier(caster, caster.healing_spray_dummy, "modifier_healing_spray_thinker", nil)
end


function HealingSprayWave( event )
	local caster = event.caster
	local point = event.target:GetAbsOrigin()

	local particleName = "particles/custom/alchemist_acid_spray_cast.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, point)
	ParticleManager:SetParticleControl(particle, 15, Vector(255,255,0))
	ParticleManager:SetParticleControl(particle, 16, Vector(255,255,0))

end

function HealingSprayEnd( event )
	local caster = event.caster
	caster.healing_spray_dummy:RemoveModifierByName("modifier_healing_spray_thinker")
	caster:RemoveModifierByName("modifier_healing_spray_channelling")
	
	local healing_spray_dummy_pointer = caster.healing_spray_dummy
	Timers:CreateTimer(0.7,function() healing_spray_dummy_pointer:RemoveSelf() end)
end

function ApplyHeal(event)
	local units = event.target_entities
	local heal = event.Heal -- "Heal" "%wave_heal"
 
	for _,unit in pairs(units) do
		print("Healing "..unit:GetUnitName().." for "..heal)
		unit:Heal(heal, caster)
	-- PopupHeal
	end

end