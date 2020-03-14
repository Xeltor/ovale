local __exports = LibStub:GetLibrary("ovale/scripts/ovale_monk")
if not __exports then return end
__exports.registerMonkWindwalkerToast = function(OvaleScripts)
do
	local name = "toast_windwalker"
	local desc = "[Toast][8.2.5] Monk: Windwalker"
	local code = [[
Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_monk_spells)

# Windwalker
AddIcon specialization=3 help=main
{
    # if not mounted() and not {BuffPresent(critical_strike_buff any=1) or BuffPresent(str_agi_int_buff any=1)} Spell(legacy_of_the_white_tiger)
    
	#spear_hand_strike
	if InCombat() InterruptActions()
	
	if target.InRange(tiger_palm) and HasFullControl()
    {
		# Cooldowns
		if Boss() WindwalkerDefaultCdActions()
		
		WindwalkerDefaultShortCdActions()
		
		WindwalkerDefaultMainActions()
    }
}

AddFunction InterruptActions
{
}

AddFunction WindwalkerUseItemActions
{
}

### actions.default

AddFunction WindwalkerDefaultMainActions
{
 #call_action_list,name=serenity,if=buff.serenity.up
 if BuffPresent(serenity) WindwalkerSerenityMainActions()

 unless BuffPresent(serenity) and WindwalkerSerenityMainPostConditions()
 {
  #fist_of_the_white_tiger,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=3
  if { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 3 Spell(fist_of_the_white_tiger)
  #tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=2&!prev_gcd.1.tiger_palm
  if { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 2 and not PreviousGCDSpell(tiger_palm) Spell(tiger_palm)
  #call_action_list,name=cd
  WindwalkerCdMainActions()

  unless WindwalkerCdMainPostConditions()
  {
   #call_action_list,name=st,if=active_enemies<3
   if Enemies(tagged=1) < 3 WindwalkerStMainActions()

   unless Enemies(tagged=1) < 3 and WindwalkerStMainPostConditions()
   {
    #call_action_list,name=aoe,if=active_enemies>=3
    if Enemies(tagged=1) >= 3 WindwalkerAoeMainActions()
   }
  }
 }
}

AddFunction WindwalkerDefaultMainPostConditions
{
 BuffPresent(serenity) and WindwalkerSerenityMainPostConditions() or WindwalkerCdMainPostConditions() or Enemies(tagged=1) < 3 and WindwalkerStMainPostConditions() or Enemies(tagged=1) >= 3 and WindwalkerAoeMainPostConditions()
}

AddFunction WindwalkerDefaultShortCdActions
{
 #auto_attack
 # WindwalkerGetInMeleeRange()
 #touch_of_karma,interval=90,pct_health=0.5
 # if CheckBoxOn(opt_touch_of_karma) Spell(touch_of_karma)
 #call_action_list,name=serenity,if=buff.serenity.up
 if BuffPresent(serenity) WindwalkerSerenityShortCdActions()

 unless BuffPresent(serenity) and WindwalkerSerenityShortCdPostConditions() or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 3 and Spell(fist_of_the_white_tiger) or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 2 and not PreviousGCDSpell(tiger_palm) and Spell(tiger_palm)
 {
  #call_action_list,name=cd
  WindwalkerCdShortCdActions()

  unless WindwalkerCdShortCdPostConditions()
  {
   #call_action_list,name=st,if=active_enemies<3
   if Enemies(tagged=1) < 3 WindwalkerStShortCdActions()

   unless Enemies(tagged=1) < 3 and WindwalkerStShortCdPostConditions()
   {
    #call_action_list,name=aoe,if=active_enemies>=3
    if Enemies(tagged=1) >= 3 WindwalkerAoeShortCdActions()
   }
  }
 }
}

AddFunction WindwalkerDefaultShortCdPostConditions
{
 BuffPresent(serenity) and WindwalkerSerenityShortCdPostConditions() or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 3 and Spell(fist_of_the_white_tiger) or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 2 and not PreviousGCDSpell(tiger_palm) and Spell(tiger_palm) or WindwalkerCdShortCdPostConditions() or Enemies(tagged=1) < 3 and WindwalkerStShortCdPostConditions() or Enemies(tagged=1) >= 3 and WindwalkerAoeShortCdPostConditions()
}

AddFunction WindwalkerDefaultCdActions
{
 #spear_hand_strike,if=target.debuff.casting.react
 # if target.IsInterruptible() WindwalkerInterruptActions()
 #potion,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
 # if { BuffPresent(serenity) or BuffPresent(storm_earth_and_fire) or not Talent(serenity_talent) and BuffPresent(trinket_proc_agility_buff) or BuffPresent(bloodlust) or target.TimeToDie() <= 60 } and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(item_unbridled_fury usable=1)
 #call_action_list,name=serenity,if=buff.serenity.up
 if BuffPresent(serenity) WindwalkerSerenityCdActions()

 unless BuffPresent(serenity) and WindwalkerSerenityCdPostConditions() or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 3 and Spell(fist_of_the_white_tiger) or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 2 and not PreviousGCDSpell(tiger_palm) and Spell(tiger_palm)
 {
  #call_action_list,name=cd
  WindwalkerCdCdActions()

  unless WindwalkerCdCdPostConditions()
  {
   #call_action_list,name=st,if=active_enemies<3
   if Enemies(tagged=1) < 3 WindwalkerStCdActions()

   unless Enemies(tagged=1) < 3 and WindwalkerStCdPostConditions()
   {
    #call_action_list,name=aoe,if=active_enemies>=3
    if Enemies(tagged=1) >= 3 WindwalkerAoeCdActions()
   }
  }
 }
}

AddFunction WindwalkerDefaultCdPostConditions
{
 BuffPresent(serenity) and WindwalkerSerenityCdPostConditions() or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 3 and Spell(fist_of_the_white_tiger) or { TimeToMaxEnergy() < 1 or Talent(serenity_talent) and SpellCooldown(serenity) < 2 } and MaxChi() - Chi() >= 2 and not PreviousGCDSpell(tiger_palm) and Spell(tiger_palm) or WindwalkerCdCdPostConditions() or Enemies(tagged=1) < 3 and WindwalkerStCdPostConditions() or Enemies(tagged=1) >= 3 and WindwalkerAoeCdPostConditions()
}

### actions.aoe

AddFunction WindwalkerAoeMainActions
{
 #rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(talent.whirling_dragon_punch.enabled&cooldown.whirling_dragon_punch.remains<5)&cooldown.fists_of_fury.remains>3
 if Talent(whirling_dragon_punch_talent) and SpellCooldown(whirling_dragon_punch) < 5 and SpellCooldown(fists_of_fury) > 3 Spell(rising_sun_kick)
 #whirling_dragon_punch
 if SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 Spell(whirling_dragon_punch)
 #energizing_elixir,if=!prev_gcd.1.tiger_palm&chi<=1&energy<50
 if not PreviousGCDSpell(tiger_palm) and Chi() <= 1 and Energy() < 50 Spell(energizing_elixir)
 #fists_of_fury,if=energy.time_to_max>3
 if TimeToMaxEnergy() > 3 Spell(fists_of_fury)
 #rushing_jade_wind,if=buff.rushing_jade_wind.down
 if BuffExpires(rushing_jade_wind_windwalker_buff) Spell(rushing_jade_wind)
 #spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(((chi>3|cooldown.fists_of_fury.remains>6)&(chi>=5|cooldown.fists_of_fury.remains>2))|energy.time_to_max<=3)
 if not PreviousGCDSpell(spinning_crane_kick) and { { Chi() > 3 or SpellCooldown(fists_of_fury) > 6 } and { Chi() >= 5 or SpellCooldown(fists_of_fury) > 2 } or TimeToMaxEnergy() <= 3 } Spell(spinning_crane_kick)
 #chi_burst,if=chi<=3
 if Chi() <= 3 Spell(chi_burst)
 #fist_of_the_white_tiger,if=chi.max-chi>=3
 if MaxChi() - Chi() >= 3 Spell(fist_of_the_white_tiger)
 #tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=2&(!talent.hit_combo.enabled|!prev_gcd.1.tiger_palm)
 if MaxChi() - Chi() >= 2 and { not Talent(hit_combo_talent) or not PreviousGCDSpell(tiger_palm) } Spell(tiger_palm)
 #chi_wave
 Spell(chi_wave)
 #flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
 # if BuffExpires(blackout_kick_buff) and CheckBoxOn(opt_flying_serpent_kick) Spell(flying_serpent_kick)
 #blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(buff.bok_proc.up|(talent.hit_combo.enabled&prev_gcd.1.tiger_palm&chi<4))
 if not PreviousGCDSpell(blackout_kick_windwalker) and { BuffPresent(blackout_kick_buff) or Talent(hit_combo_talent) and PreviousGCDSpell(tiger_palm) and Chi() < 4 } Spell(blackout_kick_windwalker)
}

AddFunction WindwalkerAoeMainPostConditions
{
}

AddFunction WindwalkerAoeShortCdActions
{
 unless Talent(whirling_dragon_punch_talent) and SpellCooldown(whirling_dragon_punch) < 5 and SpellCooldown(fists_of_fury) > 3 and Spell(rising_sun_kick) or SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 and Spell(whirling_dragon_punch) or not PreviousGCDSpell(tiger_palm) and Chi() <= 1 and Energy() < 50 and Spell(energizing_elixir) or TimeToMaxEnergy() > 3 and Spell(fists_of_fury) or BuffExpires(rushing_jade_wind_windwalker_buff) and Spell(rushing_jade_wind) or not PreviousGCDSpell(spinning_crane_kick) and { { Chi() > 3 or SpellCooldown(fists_of_fury) > 6 } and { Chi() >= 5 or SpellCooldown(fists_of_fury) > 2 } or TimeToMaxEnergy() <= 3 } and Spell(spinning_crane_kick)
 {
  #reverse_harm,if=chi.max-chi>=2
  if MaxChi() - Chi() >= 2 Spell(reverse_harm)
 }
}

AddFunction WindwalkerAoeShortCdPostConditions
{
 Talent(whirling_dragon_punch_talent) and SpellCooldown(whirling_dragon_punch) < 5 and SpellCooldown(fists_of_fury) > 3 and Spell(rising_sun_kick) or SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 and Spell(whirling_dragon_punch) or not PreviousGCDSpell(tiger_palm) and Chi() <= 1 and Energy() < 50 and Spell(energizing_elixir) or TimeToMaxEnergy() > 3 and Spell(fists_of_fury) or BuffExpires(rushing_jade_wind_windwalker_buff) and Spell(rushing_jade_wind) or not PreviousGCDSpell(spinning_crane_kick) and { { Chi() > 3 or SpellCooldown(fists_of_fury) > 6 } and { Chi() >= 5 or SpellCooldown(fists_of_fury) > 2 } or TimeToMaxEnergy() <= 3 } and Spell(spinning_crane_kick) or Chi() <= 3 and Spell(chi_burst) or MaxChi() - Chi() >= 3 and Spell(fist_of_the_white_tiger) or MaxChi() - Chi() >= 2 and { not Talent(hit_combo_talent) or not PreviousGCDSpell(tiger_palm) } and Spell(tiger_palm) or Spell(chi_wave) or not PreviousGCDSpell(blackout_kick_windwalker) and { BuffPresent(blackout_kick_buff) or Talent(hit_combo_talent) and PreviousGCDSpell(tiger_palm) and Chi() < 4 } and Spell(blackout_kick_windwalker)
}

AddFunction WindwalkerAoeCdActions
{
}

AddFunction WindwalkerAoeCdPostConditions
{
 Talent(whirling_dragon_punch_talent) and SpellCooldown(whirling_dragon_punch) < 5 and SpellCooldown(fists_of_fury) > 3 and Spell(rising_sun_kick) or SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 and Spell(whirling_dragon_punch) or not PreviousGCDSpell(tiger_palm) and Chi() <= 1 and Energy() < 50 and Spell(energizing_elixir) or TimeToMaxEnergy() > 3 and Spell(fists_of_fury) or BuffExpires(rushing_jade_wind_windwalker_buff) and Spell(rushing_jade_wind) or not PreviousGCDSpell(spinning_crane_kick) and { { Chi() > 3 or SpellCooldown(fists_of_fury) > 6 } and { Chi() >= 5 or SpellCooldown(fists_of_fury) > 2 } or TimeToMaxEnergy() <= 3 } and Spell(spinning_crane_kick) or Chi() <= 3 and Spell(chi_burst) or MaxChi() - Chi() >= 3 and Spell(fist_of_the_white_tiger) or MaxChi() - Chi() >= 2 and { not Talent(hit_combo_talent) or not PreviousGCDSpell(tiger_palm) } and Spell(tiger_palm) or Spell(chi_wave) or not PreviousGCDSpell(blackout_kick_windwalker) and { BuffPresent(blackout_kick_buff) or Talent(hit_combo_talent) and PreviousGCDSpell(tiger_palm) and Chi() < 4 } and Spell(blackout_kick_windwalker)
}

### actions.cd

AddFunction WindwalkerCdMainActions
{
 #serenity,if=cooldown.rising_sun_kick.remains<=2|target.time_to_die<=12
 if SpellCooldown(rising_sun_kick) <= 2 or target.TimeToDie() <= 12 Spell(serenity)
 #call_action_list,name=essences
 WindwalkerEssencesMainActions()
}

AddFunction WindwalkerCdMainPostConditions
{
 WindwalkerEssencesMainPostConditions()
}

AddFunction WindwalkerCdShortCdActions
{
 unless { SpellCooldown(rising_sun_kick) <= 2 or target.TimeToDie() <= 12 } and Spell(serenity)
 {
  #call_action_list,name=essences
  WindwalkerEssencesShortCdActions()
 }
}

AddFunction WindwalkerCdShortCdPostConditions
{
 { SpellCooldown(rising_sun_kick) <= 2 or target.TimeToDie() <= 12 } and Spell(serenity) or WindwalkerEssencesShortCdPostConditions()
}

AddFunction WindwalkerCdCdActions
{
 #invoke_xuen_the_white_tiger
 Spell(invoke_xuen_the_white_tiger)
 #use_item,name=variable_intensity_gigavolt_oscillating_reactor
 WindwalkerUseItemActions()
 #blood_fury
 Spell(blood_fury_apsp)
 #berserking
 Spell(berserking)
 #arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
 if MaxChi() - Chi() >= 1 and TimeToMaxEnergy() >= 0.5 Spell(arcane_torrent_chi)
 #lights_judgment
 Spell(lights_judgment)
 #fireblood
 Spell(fireblood)
 #ancestral_call
 Spell(ancestral_call)
 #touch_of_death,if=target.time_to_die>9
 if target.TimeToDie() > 9 and { not UnitInRaid() and target.Classification(elite) or target.Classification(worldboss) or not BuffExpires(hidden_masters_forbidden_touch_buff) } Spell(touch_of_death)
 #storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|(cooldown.fists_of_fury.remains<=6&chi>=3&cooldown.rising_sun_kick.remains<=1)|target.time_to_die<=15
 if { SpellCharges(storm_earth_and_fire) == 2 or SpellCooldown(fists_of_fury) <= 6 and Chi() >= 3 and SpellCooldown(rising_sun_kick) <= 1 or target.TimeToDie() <= 15 } and not BuffPresent(storm_earth_and_fire_buff) Spell(storm_earth_and_fire)

 unless { SpellCooldown(rising_sun_kick) <= 2 or target.TimeToDie() <= 12 } and Spell(serenity)
 {
  #call_action_list,name=essences
  WindwalkerEssencesCdActions()
 }
}

AddFunction WindwalkerCdCdPostConditions
{
 { SpellCooldown(rising_sun_kick) <= 2 or target.TimeToDie() <= 12 } and Spell(serenity) or WindwalkerEssencesCdPostConditions()
}

### actions.essences

AddFunction WindwalkerEssencesMainActions
{
 #concentrated_flame
 Spell(concentrated_flame_essence)
}

AddFunction WindwalkerEssencesMainPostConditions
{
}

AddFunction WindwalkerEssencesShortCdActions
{
 unless Spell(concentrated_flame_essence)
 {
  #purifying_blast
  Spell(purifying_blast)
  #the_unbound_force
  Spell(the_unbound_force)
  #ripple_in_space
  Spell(ripple_in_space_essence)
  #worldvein_resonance
  Spell(worldvein_resonance_essence)
 }
}

AddFunction WindwalkerEssencesShortCdPostConditions
{
 Spell(concentrated_flame_essence)
}

AddFunction WindwalkerEssencesCdActions
{
 unless Spell(concentrated_flame_essence)
 {
  #blood_of_the_enemy
  Spell(blood_of_the_enemy)


  unless Spell(purifying_blast) or Spell(the_unbound_force) or Spell(ripple_in_space_essence) or Spell(worldvein_resonance_essence)
  {
   #memory_of_lucid_dreams,if=energy<40&buff.storm_earth_and_fire.up
   if Energy() < 40 and BuffPresent(storm_earth_and_fire) Spell(memory_of_lucid_dreams_essence)
  }
 }
}

AddFunction WindwalkerEssencesCdPostConditions
{
 Spell(concentrated_flame_essence) or Spell(purifying_blast) or Spell(the_unbound_force) or Spell(ripple_in_space_essence) or Spell(worldvein_resonance_essence)
}

### actions.precombat

AddFunction WindwalkerPrecombatMainActions
{
 #chi_burst,if=(!talent.serenity.enabled|!talent.fist_of_the_white_tiger.enabled)
 if { not Talent(serenity_talent) or not Talent(fist_of_the_white_tiger_talent) } Spell(chi_burst)
 #chi_wave
 Spell(chi_wave)
}

AddFunction WindwalkerPrecombatMainPostConditions
{
}

AddFunction WindwalkerPrecombatShortCdActions
{
}

AddFunction WindwalkerPrecombatShortCdPostConditions
{
 { not Talent(serenity_talent) or not Talent(fist_of_the_white_tiger_talent) } and Spell(chi_burst) or Spell(chi_wave)
}

AddFunction WindwalkerPrecombatCdActions
{
 #flask
 #food
 #augmentation
 #snapshot_stats
 #potion
 # if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(item_unbridled_fury usable=1)
}

AddFunction WindwalkerPrecombatCdPostConditions
{
 { not Talent(serenity_talent) or not Talent(fist_of_the_white_tiger_talent) } and Spell(chi_burst) or Spell(chi_wave)
}

### actions.serenity

AddFunction WindwalkerSerenityMainActions
{
 #rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=active_enemies<3|prev_gcd.1.spinning_crane_kick
 if Enemies(tagged=1) < 3 or PreviousGCDSpell(spinning_crane_kick) Spell(rising_sun_kick)
 #fists_of_fury,if=(buff.bloodlust.up&prev_gcd.1.rising_sun_kick)|buff.serenity.remains<1|(active_enemies>1&active_enemies<5)
 if BuffPresent(bloodlust) and PreviousGCDSpell(rising_sun_kick) or BuffRemaining(serenity) < 1 or Enemies(tagged=1) > 1 and Enemies(tagged=1) < 5 Spell(fists_of_fury)
 #spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(active_enemies>=3|(active_enemies=2&prev_gcd.1.blackout_kick))
 if not PreviousGCDSpell(spinning_crane_kick) and { Enemies(tagged=1) >= 3 or Enemies(tagged=1) == 2 and PreviousGCDSpell(blackout_kick_windwalker) } Spell(spinning_crane_kick)
 #blackout_kick,target_if=min:debuff.mark_of_the_crane.remains
 Spell(blackout_kick_windwalker)
}

AddFunction WindwalkerSerenityMainPostConditions
{
}

AddFunction WindwalkerSerenityShortCdActions
{
}

AddFunction WindwalkerSerenityShortCdPostConditions
{
 { Enemies(tagged=1) < 3 or PreviousGCDSpell(spinning_crane_kick) } and Spell(rising_sun_kick) or { BuffPresent(bloodlust) and PreviousGCDSpell(rising_sun_kick) or BuffRemaining(serenity) < 1 or Enemies(tagged=1) > 1 and Enemies(tagged=1) < 5 } and Spell(fists_of_fury) or not PreviousGCDSpell(spinning_crane_kick) and { Enemies(tagged=1) >= 3 or Enemies(tagged=1) == 2 and PreviousGCDSpell(blackout_kick_windwalker) } and Spell(spinning_crane_kick) or Spell(blackout_kick_windwalker)
}

AddFunction WindwalkerSerenityCdActions
{
}

AddFunction WindwalkerSerenityCdPostConditions
{
 { Enemies(tagged=1) < 3 or PreviousGCDSpell(spinning_crane_kick) } and Spell(rising_sun_kick) or { BuffPresent(bloodlust) and PreviousGCDSpell(rising_sun_kick) or BuffRemaining(serenity) < 1 or Enemies(tagged=1) > 1 and Enemies(tagged=1) < 5 } and Spell(fists_of_fury) or not PreviousGCDSpell(spinning_crane_kick) and { Enemies(tagged=1) >= 3 or Enemies(tagged=1) == 2 and PreviousGCDSpell(blackout_kick_windwalker) } and Spell(spinning_crane_kick) or Spell(blackout_kick_windwalker)
}

### actions.st

AddFunction WindwalkerStMainActions
{
 #whirling_dragon_punch
 if SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 Spell(whirling_dragon_punch)
 #rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=chi>=5
 if Chi() >= 5 Spell(rising_sun_kick)
 #fists_of_fury,if=energy.time_to_max>3
 if TimeToMaxEnergy() > 3 Spell(fists_of_fury)
 #rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains
 Spell(rising_sun_kick)
 #spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&buff.dance_of_chiji.up
 if not PreviousGCDSpell(spinning_crane_kick) and BuffPresent(dance_of_chiji_buff) Spell(spinning_crane_kick)
 #rushing_jade_wind,if=buff.rushing_jade_wind.down&active_enemies>1
 if BuffExpires(rushing_jade_wind_windwalker_buff) and Enemies(tagged=1) > 1 Spell(rushing_jade_wind)
 #fist_of_the_white_tiger,if=chi<=2
 if Chi() <= 2 Spell(fist_of_the_white_tiger)
 #energizing_elixir,if=chi<=3&energy<50
 if Chi() <= 3 and Energy() < 50 Spell(energizing_elixir)
 #blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(cooldown.rising_sun_kick.remains>3|chi>=3)&(cooldown.fists_of_fury.remains>4|chi>=4|(chi=2&prev_gcd.1.tiger_palm))&buff.swift_roundhouse.stack<2
 if not PreviousGCDSpell(blackout_kick_windwalker) and { SpellCooldown(rising_sun_kick) > 3 or Chi() >= 3 } and { SpellCooldown(fists_of_fury) > 4 or Chi() >= 4 or Chi() == 2 and PreviousGCDSpell(tiger_palm) } and BuffStacks(swift_roundhouse_buff) < 2 Spell(blackout_kick_windwalker)
 #chi_wave
 Spell(chi_wave)
 #chi_burst,if=chi.max-chi>=1&active_enemies=1|chi.max-chi>=2
 if { MaxChi() - Chi() >= 1 and Enemies(tagged=1) == 1 or MaxChi() - Chi() >= 2 } Spell(chi_burst)
 #tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.tiger_palm&chi.max-chi>=2
 if not PreviousGCDSpell(tiger_palm) and MaxChi() - Chi() >= 2 Spell(tiger_palm)
 #flying_serpent_kick,if=prev_gcd.1.blackout_kick&chi>3&buff.swift_roundhouse.stack<2,interrupt=1
 # if PreviousGCDSpell(blackout_kick_windwalker) and Chi() > 3 and BuffStacks(swift_roundhouse_buff) < 2 and CheckBoxOn(opt_flying_serpent_kick) Spell(flying_serpent_kick)
}

AddFunction WindwalkerStMainPostConditions
{
}

AddFunction WindwalkerStShortCdActions
{
 unless SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 and Spell(whirling_dragon_punch) or Chi() >= 5 and Spell(rising_sun_kick) or TimeToMaxEnergy() > 3 and Spell(fists_of_fury) or Spell(rising_sun_kick) or not PreviousGCDSpell(spinning_crane_kick) and BuffPresent(dance_of_chiji_buff) and Spell(spinning_crane_kick) or BuffExpires(rushing_jade_wind_windwalker_buff) and Enemies(tagged=1) > 1 and Spell(rushing_jade_wind)
 {
  #reverse_harm,if=chi.max-chi>=2
  if MaxChi() - Chi() >= 2 Spell(reverse_harm)
 }
}

AddFunction WindwalkerStShortCdPostConditions
{
 SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 and Spell(whirling_dragon_punch) or Chi() >= 5 and Spell(rising_sun_kick) or TimeToMaxEnergy() > 3 and Spell(fists_of_fury) or Spell(rising_sun_kick) or not PreviousGCDSpell(spinning_crane_kick) and BuffPresent(dance_of_chiji_buff) and Spell(spinning_crane_kick) or BuffExpires(rushing_jade_wind_windwalker_buff) and Enemies(tagged=1) > 1 and Spell(rushing_jade_wind) or Chi() <= 2 and Spell(fist_of_the_white_tiger) or Chi() <= 3 and Energy() < 50 and Spell(energizing_elixir) or not PreviousGCDSpell(blackout_kick_windwalker) and { SpellCooldown(rising_sun_kick) > 3 or Chi() >= 3 } and { SpellCooldown(fists_of_fury) > 4 or Chi() >= 4 or Chi() == 2 and PreviousGCDSpell(tiger_palm) } and BuffStacks(swift_roundhouse_buff) < 2 and Spell(blackout_kick_windwalker) or Spell(chi_wave) or { MaxChi() - Chi() >= 1 and Enemies(tagged=1) == 1 or MaxChi() - Chi() >= 2 } and Spell(chi_burst) or not PreviousGCDSpell(tiger_palm) and MaxChi() - Chi() >= 2 and Spell(tiger_palm)
}

AddFunction WindwalkerStCdActions
{
}

AddFunction WindwalkerStCdPostConditions
{
 SpellCooldown(fists_of_fury) > 0 and SpellCooldown(rising_sun_kick) > 0 and Spell(whirling_dragon_punch) or Chi() >= 5 and Spell(rising_sun_kick) or TimeToMaxEnergy() > 3 and Spell(fists_of_fury) or Spell(rising_sun_kick) or not PreviousGCDSpell(spinning_crane_kick) and BuffPresent(dance_of_chiji_buff) and Spell(spinning_crane_kick) or BuffExpires(rushing_jade_wind_windwalker_buff) and Enemies(tagged=1) > 1 and Spell(rushing_jade_wind) or Chi() <= 2 and Spell(fist_of_the_white_tiger) or Chi() <= 3 and Energy() < 50 and Spell(energizing_elixir) or not PreviousGCDSpell(blackout_kick_windwalker) and { SpellCooldown(rising_sun_kick) > 3 or Chi() >= 3 } and { SpellCooldown(fists_of_fury) > 4 or Chi() >= 4 or Chi() == 2 and PreviousGCDSpell(tiger_palm) } and BuffStacks(swift_roundhouse_buff) < 2 and Spell(blackout_kick_windwalker) or Spell(chi_wave) or { MaxChi() - Chi() >= 1 and Enemies(tagged=1) == 1 or MaxChi() - Chi() >= 2 } and Spell(chi_burst) or not PreviousGCDSpell(tiger_palm) and MaxChi() - Chi() >= 2 and Spell(tiger_palm)
}
]]

		OvaleScripts:RegisterScript("MONK", "windwalker", name, desc, code, "script")
	end
end