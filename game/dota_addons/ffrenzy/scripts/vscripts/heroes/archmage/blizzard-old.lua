--[[
	Author: Noya
	Date: 25.01.2015.
	Creates a dummy unit to apply the Blizzard thinker modifier which does the waves
]]
function BlizzardStartPoint( event )
	local caster = event.caster
	local point = event.target_points[1]

	caster.blizzard_dummy_point = CreateUnitByName("dummy_unit_vulnerable", point, false, caster, caster, caster:GetTeam())
	event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_blizzard_wave", nil)
end


function BlizzardStart( event )
	-- Variables
	print("blizzar start called")
	local caster = event.caster
	--local point = event.target_points[1]
	local point = caster.blizzard_dummy_point:GetAbsOrigin()
	print(point)

	if caster.blizzard_dummy ~= nil then
		caster.blizzard_dummy:RemoveSelf()
	end
	caster.blizzard_dummy = CreateUnitByName("dummy_unit_vulnerable", point, false, caster, caster, caster:GetTeam())
	event.ability:ApplyDataDrivenModifier(caster, caster.blizzard_dummy, "modifier_blizzard_thinker", nil)
end

-- -- Create the particles with small delays between each other
function BlizzardWave( event )
	local caster = event.caster
	print("blizzard wave called")
	local target_position = event.target:GetAbsOrigin() --event.target_points[1]
    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
    local distance = 100

    -- Center explosion
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, target_position )

	local fv = caster:GetForwardVector()
    local distance = 100

    Timers:CreateTimer(0.05,function()
    local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle2, 0, target_position+RandomVector(100) ) end)

    Timers:CreateTimer(0.1,function()
	local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle3, 0, target_position-RandomVector(100) ) end)

    Timers:CreateTimer(0.15,function()
	local particle4 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle4, 0, target_position+RandomVector(RandomInt(50,100)) ) end)

    Timers:CreateTimer(0.2,function()
	local particle5 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle5, 0, target_position-RandomVector(RandomInt(50,100)) ) end)

    print(target_position)
end

function BlizzardEnd( event )
	local caster = event.caster
	caster:RemoveModifierByName("modifier_blizzard_wave")
	Timers:CreateTimer(0.5,function()
	caster.blizzard_dummy:RemoveSelf()
	caster.blizzard_dummy_point:RemoveSelf() end)
	
end