local __exports = LibStub:GetLibrary("ovale/scripts/ovale_warrior")
if not __exports then return end
__exports.registerWarriorProtectionHooves = function(OvaleScripts)
do
	local name = "hooves_protection"
	local desc = "[Hooves][8.1.5] Warrior: Protection"
	local code = [[
Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddIcon specialization=3 help=main
{
	if not Mounted()
	{
	if target.InRange(shield_slam) and HasFullControl()
	{
		ProtectionHealMe()
		if PreviousGCDSpell(intercept) Spell(thunder_clap)

		# Cooldowns
		ProtectionDefaultCdActions()

		# Short Cooldowns
		ProtectionDefaultShortCdActions()

		# Default rotation
		ProtectionDefaultMainActions()
	}

	# Move to the target!
	if target.InRange(heroic_throw) and InCombat() Spell(heroic_throw usable=1)
	}
}

AddFunction ProtectionHealMe
{
	if HealthPercent() < 70 Spell(victory_rush)
	if HealthPercent() < 85 Spell(impending_victory)
}

AddFunction ProtectionGetInMeleeRange
{
	if InFlightToTarget(intercept) and not InFlightToTarget(heroic_leap)
	{
		if target.InRange(intercept) Spell(intercept)
		# if SpellCharges(intercept) == 0 and target.Distance(atLeast 8) and target.Distance(atMost 40) Spell(heroic_leap)
		# if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}




### actions.default
AddCheckBox(UseRevenge L(REVENGE))
AddFunction protectiondefaultmainactions
{
 #concentrated_flame,if=buff.avatar.down&!dot.concentrated_flame_burn.remains>0|essence.the_crucible_of_flame.rank<3
 if buffexpires(avatar) and not target.debuffremaining(concentrated_flame_burn_debuff) > 0 or azeriteessencerank(the_crucible_of_flame_essence_id) < 3 spell(concentrated_flame_essence)
 #avatar
 spell(avatar)
 #run_action_list,name=aoe,if=spell_targets.thunder_clap>=3
 if enemies(tagged=1) >= 3 protectionaoemainactions()

 unless enemies(tagged=1) >= 3 and protectionaoemainpostconditions()
 {
  #call_action_list,name=st
  protectionstmainactions()
 }
}

AddFunction protectiondefaultmainpostconditions
{
 enemies(tagged=1) >= 3 and protectionaoemainpostconditions() or protectionstmainpostconditions()
}

AddFunction protectiondefaultshortcdactions
{
 #auto_attack
 protectiongetinmeleerange()
 #bag_of_tricks
 spell(bag_of_tricks)
 #ignore_pain,if=rage.deficit<25+20*talent.booming_voice.enabled*cooldown.demoralizing_shout.ready
 if ragedeficit() < 25 + 20 * talentpoints(booming_voice_talent) * { spellcooldown(demoralizing_shout) == 0 } and not checkboxon(UseRevenge) spell(ignore_pain)
 #worldvein_resonance,if=cooldown.avatar.remains<=2
 if spellcooldown(avatar) <= 2 spell(worldvein_resonance_essence)
 #ripple_in_space
 spell(ripple_in_space_essence)

 unless { buffexpires(avatar) and not target.debuffremaining(concentrated_flame_burn_debuff) > 0 or azeriteessencerank(the_crucible_of_flame_essence_id) < 3 } and spell(concentrated_flame_essence) or spell(avatar)
 {
  #run_action_list,name=aoe,if=spell_targets.thunder_clap>=3
  if enemies(tagged=1) >= 3 protectionaoeshortcdactions()

  unless enemies(tagged=1) >= 3 and protectionaoeshortcdpostconditions()
  {
   #call_action_list,name=st
   protectionstshortcdactions()
  }
 }
}

AddFunction protectiondefaultshortcdpostconditions
{
 { buffexpires(avatar) and not target.debuffremaining(concentrated_flame_burn_debuff) > 0 or azeriteessencerank(the_crucible_of_flame_essence_id) < 3 } and spell(concentrated_flame_essence) or spell(avatar) or enemies(tagged=1) >= 3 and protectionaoeshortcdpostconditions() or protectionstshortcdpostconditions()
}

AddFunction protectiondefaultcdactions
{
 protectioninterruptactions()
 #use_items,if=cooldown.avatar.remains<=gcd|buff.avatar.up
 if spellcooldown(avatar) <= gcd() or buffpresent(avatar) protectionuseitemactions()
 #blood_fury
 spell(blood_fury_ap)
 #berserking
 spell(berserking)
 #arcane_torrent
 spell(arcane_torrent_rage)
 #lights_judgment
 spell(lights_judgment)
 #fireblood
 spell(fireblood)
 #ancestral_call
 spell(ancestral_call)

 unless spell(bag_of_tricks)
 {
  #potion,if=buff.avatar.up|target.time_to_die<25
  if { buffpresent(avatar) or target.timetodie() < 25 } and checkboxon(opt_use_consumables) and target.classification(worldboss) item(unbridled_fury_item usable=1)

  unless spellcooldown(avatar) <= 2 and spell(worldvein_resonance_essence) or spell(ripple_in_space_essence)
  {
   #memory_of_lucid_dreams
   spell(memory_of_lucid_dreams_essence)

   unless { buffexpires(avatar) and not target.debuffremaining(concentrated_flame_burn_debuff) > 0 or azeriteessencerank(the_crucible_of_flame_essence_id) < 3 } and spell(concentrated_flame_essence)
   {
    #last_stand,if=cooldown.anima_of_death.remains<=2
    if spellcooldown(anima_of_death) <= 2 and not checkboxon(UseRevenge) spell(last_stand)

    unless spell(avatar)
    {
     #run_action_list,name=aoe,if=spell_targets.thunder_clap>=3
     if enemies(tagged=1) >= 3 protectionaoecdactions()

     unless enemies(tagged=1) >= 3 and protectionaoecdpostconditions()
     {
      #call_action_list,name=st
      protectionstcdactions()
     }
    }
   }
  }
 }
}

AddFunction protectiondefaultcdpostconditions
{
 spell(bag_of_tricks) or spellcooldown(avatar) <= 2 and spell(worldvein_resonance_essence) or spell(ripple_in_space_essence) or { buffexpires(avatar) and not target.debuffremaining(concentrated_flame_burn_debuff) > 0 or azeriteessencerank(the_crucible_of_flame_essence_id) < 3 } and spell(concentrated_flame_essence) or spell(avatar) or enemies(tagged=1) >= 3 and protectionaoecdpostconditions() or protectionstcdpostconditions()
}

### actions.aoe

AddFunction protectionaoemainactions
{
 #thunder_clap
 spell(thunder_clap)
 #anima_of_death,if=buff.last_stand.up
 if buffpresent(last_stand_buff) spell(anima_of_death)
 #dragon_roar
 spell(dragon_roar)
 #revenge
 spell(revenge)
 #shield_slam
 spell(shield_slam)
}

AddFunction protectionaoemainpostconditions
{
}

AddFunction protectionaoeshortcdactions
{
 unless spell(thunder_clap)
 {
  #demoralizing_shout,if=talent.booming_voice.enabled
  if hastalent(booming_voice_talent) spell(demoralizing_shout)

  unless buffpresent(last_stand_buff) and spell(anima_of_death) or spell(dragon_roar) or spell(revenge)
  {
   #ravager
   spell(ravager_protection)
   #shield_block,if=cooldown.shield_slam.ready&buff.shield_block.down
   if spellcooldown(shield_slam) == 0 and buffexpires(shield_block_buff) and not checkboxon(UseRevenge) spell(shield_block)
  }
 }
}

AddFunction protectionaoeshortcdpostconditions
{
 spell(thunder_clap) or buffpresent(last_stand_buff) and spell(anima_of_death) or spell(dragon_roar) or spell(revenge) or spell(shield_slam)
}

AddFunction protectionaoecdactions
{
 unless spell(thunder_clap)
 {
  #memory_of_lucid_dreams,if=buff.avatar.down
  if buffexpires(avatar) spell(memory_of_lucid_dreams_essence)

  unless hastalent(booming_voice_talent) and spell(demoralizing_shout) or buffpresent(last_stand_buff) and spell(anima_of_death) or spell(dragon_roar) or spell(revenge)
  {
   #use_item,name=grongs_primal_rage,if=buff.avatar.down|cooldown.thunder_clap.remains>=4
   if buffexpires(avatar) or spellcooldown(thunder_clap) >= 4 protectionuseitemactions()
  }
 }
}

AddFunction protectionaoecdpostconditions
{
 spell(thunder_clap) or hastalent(booming_voice_talent) and spell(demoralizing_shout) or buffpresent(last_stand_buff) and spell(anima_of_death) or spell(dragon_roar) or spell(revenge) or spell(ravager_protection) or spell(shield_slam)
}

### actions.precombat

AddFunction protectionprecombatmainactions
{
}

AddFunction protectionprecombatmainpostconditions
{
}

AddFunction protectionprecombatshortcdactions
{
 #worldvein_resonance
 spell(worldvein_resonance_essence)
}

AddFunction protectionprecombatshortcdpostconditions
{
}

AddFunction protectionprecombatcdactions
{
 #flask
 #food
 #augmentation
 #snapshot_stats
 #use_item,name=azsharas_font_of_power
 protectionuseitemactions()

 unless spell(worldvein_resonance_essence)
 {
  #memory_of_lucid_dreams
  spell(memory_of_lucid_dreams_essence)
  #guardian_of_azeroth
  spell(guardian_of_azeroth)
  #potion
  if checkboxon(opt_use_consumables) and target.classification(worldboss) item(unbridled_fury_item usable=1)
 }
}

AddFunction protectionprecombatcdpostconditions
{
 spell(worldvein_resonance_essence)
}

### actions.st

AddFunction protectionstmainactions
{
 #thunder_clap,if=spell_targets.thunder_clap=2&talent.unstoppable_force.enabled&buff.avatar.up
 if enemies(tagged=1) == 2 and hastalent(unstoppable_force_talent) and buffpresent(avatar) spell(thunder_clap)
 #shield_slam,if=buff.shield_block.up
 if buffpresent(shield_block_buff) spell(shield_slam)
 #thunder_clap,if=(talent.unstoppable_force.enabled&buff.avatar.up)
 if hastalent(unstoppable_force_talent) and buffpresent(avatar) spell(thunder_clap)
 #anima_of_death,if=buff.last_stand.up
 if buffpresent(last_stand_buff) spell(anima_of_death)
 #shield_slam
 spell(shield_slam)
 #dragon_roar
 spell(dragon_roar)
 #thunder_clap
 spell(thunder_clap)
 #revenge
 spell(revenge)
 #devastate
 spell(devastate)
}

AddFunction protectionstmainpostconditions
{
}

AddFunction protectionstshortcdactions
{
 unless enemies(tagged=1) == 2 and hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap)
 {
  #shield_block,if=cooldown.shield_slam.ready&buff.shield_block.down
  if spellcooldown(shield_slam) == 0 and buffexpires(shield_block_buff) and not checkboxon(UseRevenge) spell(shield_block)

  unless buffpresent(shield_block_buff) and spell(shield_slam) or hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap)
  {
   #demoralizing_shout,if=talent.booming_voice.enabled
   if hastalent(booming_voice_talent) spell(demoralizing_shout)

   unless buffpresent(last_stand_buff) and spell(anima_of_death) or spell(shield_slam) or spell(dragon_roar) or spell(thunder_clap) or spell(revenge)
   {
    #ravager
    spell(ravager_protection)
   }
  }
 }
}

AddFunction protectionstshortcdpostconditions
{
 enemies(tagged=1) == 2 and hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap) or buffpresent(shield_block_buff) and spell(shield_slam) or hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap) or buffpresent(last_stand_buff) and spell(anima_of_death) or spell(shield_slam) or spell(dragon_roar) or spell(thunder_clap) or spell(revenge) or spell(devastate)
}

AddFunction protectionstcdactions
{
 unless enemies(tagged=1) == 2 and hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap) or buffpresent(shield_block_buff) and spell(shield_slam) or hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap) or hastalent(booming_voice_talent) and spell(demoralizing_shout) or buffpresent(last_stand_buff) and spell(anima_of_death) or spell(shield_slam)
 {
  #use_item,name=ashvanes_razor_coral,target_if=debuff.razor_coral_debuff.stack=0
  if target.debuffstacks(razor_coral_debuff) == 0 protectionuseitemactions()
  #use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.stack>7&(cooldown.avatar.remains<5|buff.avatar.up)
  if target.debuffstacks(razor_coral_debuff) > 7 and { spellcooldown(avatar) < 5 or buffpresent(avatar) } protectionuseitemactions()

  unless spell(dragon_roar) or spell(thunder_clap) or spell(revenge)
  {
   #use_item,name=grongs_primal_rage,if=buff.avatar.down|cooldown.shield_slam.remains>=4
   if buffexpires(avatar) or spellcooldown(shield_slam) >= 4 protectionuseitemactions()
  }
 }
}

AddFunction protectionstcdpostconditions
{
 enemies(tagged=1) == 2 and hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap) or buffpresent(shield_block_buff) and spell(shield_slam) or hastalent(unstoppable_force_talent) and buffpresent(avatar) and spell(thunder_clap) or hastalent(booming_voice_talent) and spell(demoralizing_shout) or buffpresent(last_stand_buff) and spell(anima_of_death) or spell(shield_slam) or spell(dragon_roar) or spell(thunder_clap) or spell(revenge) or spell(ravager_protection) or spell(devastate)
}

]]

		OvaleScripts:RegisterScript("WARRIOR", "protection", name, desc, code, "script")
	end
end
