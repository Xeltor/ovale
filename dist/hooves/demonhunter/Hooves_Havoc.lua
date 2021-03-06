local __exports = LibStub:GetLibrary("ovale/scripts/ovale_demonhunter")
if not __exports then return end
__exports.registerDemonHunterHavocHooves = function(OvaleScripts)
do
	local name = "hooves_havoc"
	local desc = "[Hooves][8.2] Demon Hunter: Havoc"
	local code = [[
Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_demonhunter_spells)

AddIcon specialization=1 help=main
{
	# if InCombat() InterruptActions()
	
	if target.InRange(chaos_strike) and HasFullControl()
	{
		# Cooldowns
		 if Boss() HavocCooldownCdActions()
		
		# Short Cooldowns
		 HavocDefaultShortCdActions()
		
		# Default Actions
		 HavocDefaultMainActions()
	}
	
	# if InCombat() and not target.InRange(chaos_strike) and Falling() and not BuffPresent(glide_buff) Spell(glide)
}
AddFunction pooling_for_meta
{
 not Talent(demonic_talent) and SpellCooldown(metamorphosis_havoc) < 6 and FuryDeficit() > 30 and { not waiting_for_nemesis() or SpellCooldown(nemesis) < 10 }
}

AddFunction waiting_for_momentum
{
 Talent(momentum_talent) and not BuffPresent(momentum_buff)
}

AddFunction waiting_for_dark_slash
{
 Talent(dark_slash_talent) and not pooling_for_blade_dance() and not pooling_for_meta() and not SpellCooldown(dark_slash) > 0
}

AddFunction pooling_for_eye_beam
{
 Talent(demonic_talent) and not Talent(blind_fury_talent) and SpellCooldown(eye_beam) < GCD() * 2 and FuryDeficit() > 20
}

AddFunction pooling_for_blade_dance
{
 blade_dance() and Fury() < 75 - TalentPoints(first_blood_talent) * 20
}

AddFunction waiting_for_nemesis
{
 not { not Talent(nemesis_talent) or Talent(nemesis_talent) and SpellCooldown(nemesis) == 0 or SpellCooldown(nemesis) > target.TimeToDie() or SpellCooldown(nemesis) > 60 }
}

AddFunction blade_dance
{
 Talent(first_blood_talent) or enemies(tagged=1) >= 3 - TalentPoints(trail_of_ruin_talent)
}

AddFunction HavocInterruptActions
{
 if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting()
 {
  if target.InRange(imprison) and not target.Classification(worldboss) and target.CreatureType(Demon Humanoid Beast) Spell(imprison)
  if target.Distance(less 8) and not target.Classification(worldboss) Spell(chaos_nova)
  if target.InRange(disrupt) and target.IsInterruptible() Spell(disrupt)
  if target.InRange(fel_eruption) and not target.Classification(worldboss) Spell(fel_eruption)
 }
}

AddFunction HavocUseItemActions
{
 Item(Trinket0Slot text=13 usable=1)
 Item(Trinket1Slot text=14 usable=1)
}

AddFunction HavocGetInMeleeRange
{
 if CheckBoxOn(opt_melee_range) and not target.InRange(chaos_strike)
 {
  if target.InRange(felblade) Spell(felblade)
  Texture(misc_arrowlup help=L(not_in_melee_range))
 }
}

### actions.default

AddFunction HavocDefaultMainActions
{
 #call_action_list,name=cooldown,if=gcd.remains=0
 if not GCDRemaining() > 0 HavocCooldownMainActions()

 unless not GCDRemaining() > 0 and HavocCooldownMainPostConditions()
 {
  #pick_up_fragment,if=fury.deficit>=35&(!azerite.eyes_of_rage.enabled|cooldown.eye_beam.remains>1.4)
  if FuryDeficit() >= 35 and { not HasAzeriteTrait(eyes_of_rage_trait) or SpellCooldown(eye_beam) > 1.4 } Spell(pick_up_fragment)
  #call_action_list,name=dark_slash,if=talent.dark_slash.enabled&(variable.waiting_for_dark_slash|debuff.dark_slash.up)
  if Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } HavocDarkSlashMainActions()

  unless Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } and HavocDarkSlashMainPostConditions()
  {
   #run_action_list,name=demonic,if=talent.demonic.enabled
   if Talent(demonic_talent) HavocDemonicMainActions()

   unless Talent(demonic_talent) and HavocDemonicMainPostConditions()
   {
    #run_action_list,name=normal
    HavocNormalMainActions()
   }
  }
 }
}

AddFunction HavocDefaultMainPostConditions
{
 not GCDRemaining() > 0 and HavocCooldownMainPostConditions() or Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } and HavocDarkSlashMainPostConditions() or Talent(demonic_talent) and HavocDemonicMainPostConditions() or HavocNormalMainPostConditions()
}

AddFunction HavocDefaultShortCdActions
{
 #auto_attack
 HavocGetInMeleeRange()
 #call_action_list,name=cooldown,if=gcd.remains=0
 if not GCDRemaining() > 0 HavocCooldownShortCdActions()

 unless not GCDRemaining() > 0 and HavocCooldownShortCdPostConditions() or FuryDeficit() >= 35 and { not HasAzeriteTrait(eyes_of_rage_trait) or SpellCooldown(eye_beam) > 1.4 } and Spell(pick_up_fragment)
 {
  #call_action_list,name=dark_slash,if=talent.dark_slash.enabled&(variable.waiting_for_dark_slash|debuff.dark_slash.up)
  if Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } HavocDarkSlashShortCdActions()

  unless Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } and HavocDarkSlashShortCdPostConditions()
  {
   #run_action_list,name=demonic,if=talent.demonic.enabled
   if Talent(demonic_talent) HavocDemonicShortCdActions()

   unless Talent(demonic_talent) and HavocDemonicShortCdPostConditions()
   {
    #run_action_list,name=normal
    HavocNormalShortCdActions()
   }
  }
 }
}

AddFunction HavocDefaultShortCdPostConditions
{
 not GCDRemaining() > 0 and HavocCooldownShortCdPostConditions() or FuryDeficit() >= 35 and { not HasAzeriteTrait(eyes_of_rage_trait) or SpellCooldown(eye_beam) > 1.4 } and Spell(pick_up_fragment) or Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } and HavocDarkSlashShortCdPostConditions() or Talent(demonic_talent) and HavocDemonicShortCdPostConditions() or HavocNormalShortCdPostConditions()
}

AddFunction HavocDefaultCdActions
{
 #variable,name=blade_dance,value=talent.first_blood.enabled|spell_targets.blade_dance1>=(3-talent.trail_of_ruin.enabled)
 #variable,name=waiting_for_nemesis,value=!(!talent.nemesis.enabled|cooldown.nemesis.ready|cooldown.nemesis.remains>target.time_to_die|cooldown.nemesis.remains>60)
 #variable,name=pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30&(!variable.waiting_for_nemesis|cooldown.nemesis.remains<10)
 #variable,name=pooling_for_blade_dance,value=variable.blade_dance&(fury<75-talent.first_blood.enabled*20)
 #variable,name=pooling_for_eye_beam,value=talent.demonic.enabled&!talent.blind_fury.enabled&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
 #variable,name=waiting_for_dark_slash,value=talent.dark_slash.enabled&!variable.pooling_for_blade_dance&!variable.pooling_for_meta&cooldown.dark_slash.up
 #variable,name=waiting_for_momentum,value=talent.momentum.enabled&!buff.momentum.up
 #disrupt
 #HavocInterruptActions()
 #call_action_list,name=cooldown,if=gcd.remains=0
 if not GCDRemaining() > 0 HavocCooldownCdActions()

 unless not GCDRemaining() > 0 and HavocCooldownCdPostConditions() or FuryDeficit() >= 35 and { not HasAzeriteTrait(eyes_of_rage_trait) or SpellCooldown(eye_beam) > 1.4 } and Spell(pick_up_fragment)
 {
  #call_action_list,name=dark_slash,if=talent.dark_slash.enabled&(variable.waiting_for_dark_slash|debuff.dark_slash.up)
  if Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } HavocDarkSlashCdActions()

  unless Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } and HavocDarkSlashCdPostConditions()
  {
   #run_action_list,name=demonic,if=talent.demonic.enabled
   if Talent(demonic_talent) HavocDemonicCdActions()

   unless Talent(demonic_talent) and HavocDemonicCdPostConditions()
   {
    #run_action_list,name=normal
    HavocNormalCdActions()
   }
  }
 }
}

AddFunction HavocDefaultCdPostConditions
{
 not GCDRemaining() > 0 and HavocCooldownCdPostConditions() or FuryDeficit() >= 35 and { not HasAzeriteTrait(eyes_of_rage_trait) or SpellCooldown(eye_beam) > 1.4 } and Spell(pick_up_fragment) or Talent(dark_slash_talent) and { waiting_for_dark_slash() or target.DebuffPresent(dark_slash_debuff) } and HavocDarkSlashCdPostConditions() or Talent(demonic_talent) and HavocDemonicCdPostConditions() or HavocNormalCdPostConditions()
}

### actions.cooldown

AddFunction HavocCooldownMainActions
{
 #call_action_list,name=essences
 HavocEssencesMainActions()
}

AddFunction HavocCooldownMainPostConditions
{
 HavocEssencesMainPostConditions()
}

AddFunction HavocCooldownShortCdActions
{
 #call_action_list,name=essences
 HavocEssencesShortCdActions()
}

AddFunction HavocCooldownShortCdPostConditions
{
 HavocEssencesShortCdPostConditions()
}

AddFunction HavocCooldownCdActions
{
 #metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta|variable.waiting_for_nemesis)|target.time_to_die<25
 if { not { Talent(demonic_talent) or pooling_for_meta() or waiting_for_nemesis() } or target.TimeToDie() < 25 } and { not CheckBoxOn(opt_meta_only_during_boss) or IsBossFight() } Spell(metamorphosis_havoc)
 #metamorphosis,if=talent.demonic.enabled&(!azerite.chaotic_transformation.enabled|(cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max)))
 if Talent(demonic_talent) and { not HasAzeriteTrait(chaotic_transformation_trait) or SpellCooldown(eye_beam) > 20 and { not blade_dance() or SpellCooldown(blade_dance) > GCD() } } and { not CheckBoxOn(opt_meta_only_during_boss) or IsBossFight() } Spell(metamorphosis_havoc)
 #nemesis,target_if=min:target.time_to_die,if=raid_event.adds.exists&debuff.nemesis.down&(active_enemies>desired_targets|raid_event.adds.in>60)
 if False(raid_event_adds_exists) and target.DebuffExpires(nemesis_debuff) and { enemies(tagged=1) > Enemies(tagged=1) or 600 > 60 } Spell(nemesis)
 #nemesis,if=!raid_event.adds.exists
 if not False(raid_event_adds_exists) Spell(nemesis)
 #potion,if=buff.metamorphosis.remains>25|target.time_to_die<60
 if { BuffRemaining(metamorphosis_havoc_buff) > 25 or target.TimeToDie() < 60 } and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(item_potion_of_unbridled_fury usable=1)
 #use_item,name=galecallers_boon,if=!talent.fel_barrage.enabled|cooldown.fel_barrage.ready
 #if not Talent(fel_barrage_talent) or SpellCooldown(fel_barrage) == 0 HavocUseItemActions()
 #use_item,effect_name=cyclotronic_blast,if=buff.metamorphosis.up&buff.memory_of_lucid_dreams.down&(!variable.blade_dance|!cooldown.blade_dance.ready)
 #if BuffPresent(metamorphosis_havoc_buff) and BuffExpires(memory_of_lucid_dreams_essence_buff) and { not blade_dance() or not SpellCooldown(blade_dance) == 0 } HavocUseItemActions()
 #use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|(debuff.conductive_ink_debuff.up|buff.metamorphosis.remains>20)&target.health.pct<31|target.time_to_die<20
 #if target.DebuffExpires(razor_coral_debuff) or { target.DebuffPresent(conductive_ink_debuff) or BuffRemaining(metamorphosis_havoc_buff) > 20 } and target.HealthPercent() < 31 or target.TimeToDie() < 20 HavocUseItemActions()
 #use_item,name=azsharas_font_of_power,if=cooldown.metamorphosis.remains<10|cooldown.metamorphosis.remains>60
 #if SpellCooldown(metamorphosis_havoc) < 10 or SpellCooldown(metamorphosis_havoc) > 60 HavocUseItemActions()
 #use_items,if=buff.metamorphosis.up
 #if BuffPresent(metamorphosis_havoc_buff) HavocUseItemActions()
 #call_action_list,name=essences
 HavocEssencesCdActions()
}

AddFunction HavocCooldownCdPostConditions
{
 HavocEssencesCdPostConditions()
}

### actions.dark_slash

AddFunction HavocDarkSlashMainActions
{
 #dark_slash,if=fury>=80&(!variable.blade_dance|!cooldown.blade_dance.ready)
 if Fury() >= 80 and { not blade_dance() or not SpellCooldown(blade_dance) == 0 } Spell(dark_slash)
 #annihilation,if=debuff.dark_slash.up
 if target.DebuffPresent(dark_slash_debuff) Spell(annihilation)
 #chaos_strike,if=debuff.dark_slash.up
 if target.DebuffPresent(dark_slash_debuff) Spell(chaos_strike)
}

AddFunction HavocDarkSlashMainPostConditions
{
}

AddFunction HavocDarkSlashShortCdActions
{
}

AddFunction HavocDarkSlashShortCdPostConditions
{
 Fury() >= 80 and { not blade_dance() or not SpellCooldown(blade_dance) == 0 } and Spell(dark_slash) or target.DebuffPresent(dark_slash_debuff) and Spell(annihilation) or target.DebuffPresent(dark_slash_debuff) and Spell(chaos_strike)
}

AddFunction HavocDarkSlashCdActions
{
}

AddFunction HavocDarkSlashCdPostConditions
{
 Fury() >= 80 and { not blade_dance() or not SpellCooldown(blade_dance) == 0 } and Spell(dark_slash) or target.DebuffPresent(dark_slash_debuff) and Spell(annihilation) or target.DebuffPresent(dark_slash_debuff) and Spell(chaos_strike)
}

### actions.demonic

AddFunction HavocDemonicMainActions
{
 #death_sweep,if=variable.blade_dance
 if blade_dance() Spell(death_sweep)
 #blade_dance,if=variable.blade_dance&!cooldown.metamorphosis.ready&(cooldown.eye_beam.remains>(5-azerite.revolving_blades.rank*3)|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
 if blade_dance() and not { { not CheckBoxOn(opt_meta_only_during_boss) or IsBossFight() } and SpellCooldown(metamorphosis_havoc) == 0 } and { SpellCooldown(eye_beam) > 5 - AzeriteTraitRank(revolving_blades_trait) * 3 or 600 > SpellCooldown(blade_dance) and 600 < 25 } Spell(blade_dance)
 #immolation_aura
 Spell(immolation_aura_havoc)
 #annihilation,if=!variable.pooling_for_blade_dance
 if not pooling_for_blade_dance() Spell(annihilation)
 #felblade,if=fury.deficit>=40
 if FuryDeficit() >= 40 Spell(felblade)
 #chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
 if not pooling_for_blade_dance() and not pooling_for_eye_beam() Spell(chaos_strike)
 #fel_rush,if=talent.demon_blades.enabled&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
 if Talent(demon_blades_talent) and not SpellCooldown(eye_beam) == 0 and { Charges(fel_rush) == 2 or 600 > 10 and 600 > 10 } and CheckBoxOn(opt_fel_rush) Spell(fel_rush)
 #demons_bite
 Spell(demons_bite)
 #throw_glaive,if=buff.out_of_range.up
 if not target.InRange() Spell(throw_glaive_havoc)
 #fel_rush,if=movement.distance>15|buff.out_of_range.up
 if { target.Distance() > 15 or not target.InRange() } and CheckBoxOn(opt_fel_rush) Spell(fel_rush)
 #vengeful_retreat,if=movement.distance>15
 if target.Distance() > 15 and CheckBoxOn(opt_vengeful_retreat) Spell(vengeful_retreat)
 #throw_glaive,if=talent.demon_blades.enabled
 if Talent(demon_blades_talent) Spell(throw_glaive_havoc)
}

AddFunction HavocDemonicMainPostConditions
{
}

AddFunction HavocDemonicShortCdActions
{
 unless blade_dance() and Spell(death_sweep)
 {
  #eye_beam,if=raid_event.adds.up|raid_event.adds.in>25
  if False(raid_event_adds_exists) or 600 > 25 Spell(eye_beam)
  #fel_barrage,if=((!cooldown.eye_beam.up|buff.metamorphosis.up)&raid_event.adds.in>30)|active_enemies>desired_targets
  if { not { not SpellCooldown(eye_beam) > 0 } or BuffPresent(metamorphosis_havoc_buff) } and 600 > 30 or enemies(tagged=1) > Enemies(tagged=1) Spell(fel_barrage)
 }
}

AddFunction HavocDemonicShortCdPostConditions
{
 blade_dance() and Spell(death_sweep) or blade_dance() and not { { not CheckBoxOn(opt_meta_only_during_boss) or IsBossFight() } and SpellCooldown(metamorphosis_havoc) == 0 } and { SpellCooldown(eye_beam) > 5 - AzeriteTraitRank(revolving_blades_trait) * 3 or 600 > SpellCooldown(blade_dance) and 600 < 25 } and Spell(blade_dance) or Spell(immolation_aura_havoc) or not pooling_for_blade_dance() and Spell(annihilation) or FuryDeficit() >= 40 and Spell(felblade) or not pooling_for_blade_dance() and not pooling_for_eye_beam() and Spell(chaos_strike) or Talent(demon_blades_talent) and not SpellCooldown(eye_beam) == 0 and { Charges(fel_rush) == 2 or 600 > 10 and 600 > 10 } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or Spell(demons_bite) or not target.InRange() and Spell(throw_glaive_havoc) or { target.Distance() > 15 or not target.InRange() } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or Talent(demon_blades_talent) and Spell(throw_glaive_havoc)
}

AddFunction HavocDemonicCdActions
{
}

AddFunction HavocDemonicCdPostConditions
{
 blade_dance() and Spell(death_sweep) or { False(raid_event_adds_exists) or 600 > 25 } and Spell(eye_beam) or { { not { not SpellCooldown(eye_beam) > 0 } or BuffPresent(metamorphosis_havoc_buff) } and 600 > 30 or enemies(tagged=1) > Enemies(tagged=1) } and Spell(fel_barrage) or blade_dance() and not { { not CheckBoxOn(opt_meta_only_during_boss) or IsBossFight() } and SpellCooldown(metamorphosis_havoc) == 0 } and { SpellCooldown(eye_beam) > 5 - AzeriteTraitRank(revolving_blades_trait) * 3 or 600 > SpellCooldown(blade_dance) and 600 < 25 } and Spell(blade_dance) or Spell(immolation_aura_havoc) or not pooling_for_blade_dance() and Spell(annihilation) or FuryDeficit() >= 40 and Spell(felblade) or not pooling_for_blade_dance() and not pooling_for_eye_beam() and Spell(chaos_strike) or Talent(demon_blades_talent) and not SpellCooldown(eye_beam) == 0 and { Charges(fel_rush) == 2 or 600 > 10 and 600 > 10 } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or Spell(demons_bite) or not target.InRange() and Spell(throw_glaive_havoc) or { target.Distance() > 15 or not target.InRange() } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or Talent(demon_blades_talent) and Spell(throw_glaive_havoc)
}

### actions.essences

AddFunction HavocEssencesMainActions
{
 #concentrated_flame,if=(!dot.concentrated_flame_burn.ticking&!action.concentrated_flame.in_flight|full_recharge_time<gcd.max)
 if not target.DebuffPresent(concentrated_flame_burn_debuff) and not InFlightToTarget(concentrated_flame_essence) or SpellFullRecharge(concentrated_flame_essence) < GCD() Spell(concentrated_flame_essence)
}

AddFunction HavocEssencesMainPostConditions
{
}

AddFunction HavocEssencesShortCdActions
{
 unless { not target.DebuffPresent(concentrated_flame_burn_debuff) and not InFlightToTarget(concentrated_flame_essence) or SpellFullRecharge(concentrated_flame_essence) < GCD() } and Spell(concentrated_flame_essence)
 {
  #blood_of_the_enemy,if=buff.metamorphosis.up|target.time_to_die<=10
  if BuffPresent(metamorphosis_havoc_buff) or target.TimeToDie() <= 10 Spell(blood_of_the_enemy)
  #focused_azerite_beam,if=spell_targets.blade_dance1>=2|raid_event.adds.in>60
  if enemies(tagged=1) >= 2 or 600 > 60 Spell(focused_azerite_beam)
  #purifying_blast,if=spell_targets.blade_dance1>=2|raid_event.adds.in>60
  if enemies(tagged=1) >= 2 or 600 > 60 Spell(purifying_blast)
  #the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10
  if BuffPresent(reckless_force_buff) or BuffStacks(reckless_force_counter) < 10 Spell(the_unbound_force)
  #ripple_in_space
  Spell(ripple_in_space_essence)
  #worldvein_resonance,if=buff.lifeblood.stack<3
  if BuffStacks(lifeblood_buff) < 3 Spell(worldvein_resonance_essence)
 }
}

AddFunction HavocEssencesShortCdPostConditions
{
 { not target.DebuffPresent(concentrated_flame_burn_debuff) and not InFlightToTarget(concentrated_flame_essence) or SpellFullRecharge(concentrated_flame_essence) < GCD() } and Spell(concentrated_flame_essence)
}

AddFunction HavocEssencesCdActions
{
 unless { not target.DebuffPresent(concentrated_flame_burn_debuff) and not InFlightToTarget(concentrated_flame_essence) or SpellFullRecharge(concentrated_flame_essence) < GCD() } and Spell(concentrated_flame_essence)
 {
  #guardian_of_azeroth,if=buff.metamorphosis.up|target.time_to_die<=30
  if BuffPresent(metamorphosis_havoc_buff) or target.TimeToDie() <= 30 Spell(guardian_of_azeroth)

  unless { enemies(tagged=1) >= 2 or 600 > 60 } and Spell(focused_azerite_beam) or { enemies(tagged=1) >= 2 or 600 > 60 } and Spell(purifying_blast) or { BuffPresent(reckless_force_buff) or BuffStacks(reckless_force_counter) < 10 } and Spell(the_unbound_force) or Spell(ripple_in_space_essence) or BuffStacks(lifeblood_buff) < 3 and Spell(worldvein_resonance_essence)
  {
   #memory_of_lucid_dreams,if=fury<40&buff.metamorphosis.up
   if Fury() < 40 and BuffPresent(metamorphosis_havoc_buff) Spell(memory_of_lucid_dreams_essence)
  }
 }
}

AddFunction HavocEssencesCdPostConditions
{
 { not target.DebuffPresent(concentrated_flame_burn_debuff) and not InFlightToTarget(concentrated_flame_essence) or SpellFullRecharge(concentrated_flame_essence) < GCD() } and Spell(concentrated_flame_essence) or { enemies(tagged=1) >= 2 or 600 > 60 } and Spell(focused_azerite_beam) or { enemies(tagged=1) >= 2 or 600 > 60 } and Spell(purifying_blast) or { BuffPresent(reckless_force_buff) or BuffStacks(reckless_force_counter) < 10 } and Spell(the_unbound_force) or Spell(ripple_in_space_essence) or BuffStacks(lifeblood_buff) < 3 and Spell(worldvein_resonance_essence)
}

### actions.normal

AddFunction HavocNormalMainActions
{
 #vengeful_retreat,if=talent.momentum.enabled&buff.prepared.down&time>1
 if Talent(momentum_talent) and BuffExpires(prepared_buff) and TimeInCombat() > 1 and CheckBoxOn(opt_vengeful_retreat) Spell(vengeful_retreat)
 #fel_rush,if=(variable.waiting_for_momentum|talent.fel_mastery.enabled)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
 if { waiting_for_momentum() or Talent(fel_mastery_talent) } and { Charges(fel_rush) == 2 or 600 > 10 and 600 > 10 } and CheckBoxOn(opt_fel_rush) Spell(fel_rush)
 #death_sweep,if=variable.blade_dance
 if blade_dance() Spell(death_sweep)
 #immolation_aura
 Spell(immolation_aura_havoc)
 #blade_dance,if=variable.blade_dance
 if blade_dance() Spell(blade_dance)
 #felblade,if=fury.deficit>=40
 if FuryDeficit() >= 40 Spell(felblade)
 #annihilation,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance&!variable.waiting_for_dark_slash
 if { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 or BuffRemaining(metamorphosis_havoc_buff) < 5 } and not pooling_for_blade_dance() and not waiting_for_dark_slash() Spell(annihilation)
 #chaos_strike,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance&!variable.waiting_for_dark_slash
 if { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 } and not pooling_for_meta() and not pooling_for_blade_dance() and not waiting_for_dark_slash() Spell(chaos_strike)
 #demons_bite
 Spell(demons_bite)
 #fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&talent.demon_blades.enabled
 if not Talent(momentum_talent) and 600 > Charges(fel_rush) * 10 and Talent(demon_blades_talent) and CheckBoxOn(opt_fel_rush) Spell(fel_rush)
 #felblade,if=movement.distance>15|buff.out_of_range.up
 if target.Distance() > 15 or not target.InRange() Spell(felblade)
 #fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
 if { target.Distance() > 15 or not target.InRange() and not Talent(momentum_talent) } and CheckBoxOn(opt_fel_rush) Spell(fel_rush)
 #vengeful_retreat,if=movement.distance>15
 if target.Distance() > 15 and CheckBoxOn(opt_vengeful_retreat) Spell(vengeful_retreat)
 #throw_glaive,if=talent.demon_blades.enabled
 if Talent(demon_blades_talent) Spell(throw_glaive_havoc)
}

AddFunction HavocNormalMainPostConditions
{
}

AddFunction HavocNormalShortCdActions
{
 unless { waiting_for_momentum() or Talent(fel_mastery_talent) } and { Charges(fel_rush) == 2 or 600 > 10 and 600 > 10 } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush)
 {
  #fel_barrage,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>30)
  if not waiting_for_momentum() and { enemies(tagged=1) > Enemies(tagged=1) or 600 > 30 } Spell(fel_barrage)

  unless blade_dance() and Spell(death_sweep) or Spell(immolation_aura_havoc)
  {
   #eye_beam,if=active_enemies>1&(!raid_event.adds.exists|raid_event.adds.up)&!variable.waiting_for_momentum
   if enemies(tagged=1) > 1 and { not False(raid_event_adds_exists) or False(raid_event_adds_exists) } and not waiting_for_momentum() Spell(eye_beam)

   unless blade_dance() and Spell(blade_dance) or FuryDeficit() >= 40 and Spell(felblade)
   {
    #eye_beam,if=!talent.blind_fury.enabled&!variable.waiting_for_dark_slash&raid_event.adds.in>cooldown
    if not Talent(blind_fury_talent) and not waiting_for_dark_slash() and 600 > SpellCooldown(eye_beam) Spell(eye_beam)

    unless { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 or BuffRemaining(metamorphosis_havoc_buff) < 5 } and not pooling_for_blade_dance() and not waiting_for_dark_slash() and Spell(annihilation) or { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 } and not pooling_for_meta() and not pooling_for_blade_dance() and not waiting_for_dark_slash() and Spell(chaos_strike)
    {
     #eye_beam,if=talent.blind_fury.enabled&raid_event.adds.in>cooldown
     if Talent(blind_fury_talent) and 600 > SpellCooldown(eye_beam) Spell(eye_beam)
    }
   }
  }
 }
}

AddFunction HavocNormalShortCdPostConditions
{
 { waiting_for_momentum() or Talent(fel_mastery_talent) } and { Charges(fel_rush) == 2 or 600 > 10 and 600 > 10 } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or blade_dance() and Spell(death_sweep) or Spell(immolation_aura_havoc) or blade_dance() and Spell(blade_dance) or FuryDeficit() >= 40 and Spell(felblade) or { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 or BuffRemaining(metamorphosis_havoc_buff) < 5 } and not pooling_for_blade_dance() and not waiting_for_dark_slash() and Spell(annihilation) or { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 } and not pooling_for_meta() and not pooling_for_blade_dance() and not waiting_for_dark_slash() and Spell(chaos_strike) or Spell(demons_bite) or not Talent(momentum_talent) and 600 > Charges(fel_rush) * 10 and Talent(demon_blades_talent) and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or { target.Distance() > 15 or not target.InRange() } and Spell(felblade) or { target.Distance() > 15 or not target.InRange() and not Talent(momentum_talent) } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or Talent(demon_blades_talent) and Spell(throw_glaive_havoc)
}

AddFunction HavocNormalCdActions
{
}

AddFunction HavocNormalCdPostConditions
{
 { waiting_for_momentum() or Talent(fel_mastery_talent) } and { Charges(fel_rush) == 2 or 600 > 10 and 600 > 10 } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or not waiting_for_momentum() and { enemies(tagged=1) > Enemies(tagged=1) or 600 > 30 } and Spell(fel_barrage) or blade_dance() and Spell(death_sweep) or Spell(immolation_aura_havoc) or enemies(tagged=1) > 1 and { not False(raid_event_adds_exists) or False(raid_event_adds_exists) } and not waiting_for_momentum() and Spell(eye_beam) or blade_dance() and Spell(blade_dance) or FuryDeficit() >= 40 and Spell(felblade) or not Talent(blind_fury_talent) and not waiting_for_dark_slash() and 600 > SpellCooldown(eye_beam) and Spell(eye_beam) or { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 or BuffRemaining(metamorphosis_havoc_buff) < 5 } and not pooling_for_blade_dance() and not waiting_for_dark_slash() and Spell(annihilation) or { Talent(demon_blades_talent) or not waiting_for_momentum() or FuryDeficit() < 30 } and not pooling_for_meta() and not pooling_for_blade_dance() and not waiting_for_dark_slash() and Spell(chaos_strike) or Talent(blind_fury_talent) and 600 > SpellCooldown(eye_beam) and Spell(eye_beam) or Spell(demons_bite) or not Talent(momentum_talent) and 600 > Charges(fel_rush) * 10 and Talent(demon_blades_talent) and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or { target.Distance() > 15 or not target.InRange() } and Spell(felblade) or { target.Distance() > 15 or not target.InRange() and not Talent(momentum_talent) } and CheckBoxOn(opt_fel_rush) and Spell(fel_rush) or Talent(demon_blades_talent) and Spell(throw_glaive_havoc)
}

### actions.precombat

AddFunction HavocPrecombatMainActions
{
}

AddFunction HavocPrecombatMainPostConditions
{
}

AddFunction HavocPrecombatShortCdActions
{
}

AddFunction HavocPrecombatShortCdPostConditions
{
}

AddFunction HavocPrecombatCdActions
{
 #flask
 #augmentation
 #food
 #snapshot_stats
 #potion
 if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(item_potion_of_unbridled_fury usable=1)
 #metamorphosis,if=!azerite.chaotic_transformation.enabled
 if not HasAzeriteTrait(chaotic_transformation_trait) and { not CheckBoxOn(opt_meta_only_during_boss) or IsBossFight() } Spell(metamorphosis_havoc)
 #use_item,name=azsharas_font_of_power
 HavocUseItemActions()
}

AddFunction HavocPrecombatCdPostConditions
{
}


]]

		OvaleScripts:RegisterScript("DEMONHUNTER", "havoc", name, desc, code, "script")
	end
end