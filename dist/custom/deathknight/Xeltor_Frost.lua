local __exports = LibStub:GetLibrary("ovale/scripts/ovale_deathknight")
if not __exports then return end
__exports.registerDeathKnightFrostXeltor = function(OvaleScripts)
do
	local name = "xeltor_frosty"
	local desc = "[Xel][8.2] Death Knight: Frost"
	local code = [[
# Common functions.
Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_deathknight_spells)

# Frost
AddIcon specialization=2 help=main
{
	# Interrupt
	if InCombat() InterruptActions()
	
    if target.InRange(obliterate) and HasFullControl()
    {
		if BuffStacks(dark_succor_buff) and HealthPercent() < 100 Spell(death_strike)
		
		# Cooldown
		if Boss() FrostDefaultCdActions()
		
		# Short Cooldown
		FrostDefaultShortCdActions()
		
		# Main rotation
		FrostDefaultMainActions()
    }
}

# Custom functions.
AddFunction InterruptActions
{
	if { target.HasManagedInterrupts() and target.MustBeInterrupted() } or { not target.HasManagedInterrupts() and target.IsInterruptible() }
	{
		if target.Distance(less 5) and not target.Classification(worldboss) Spell(war_stomp)
		if target.Distance(less 12) and not target.Classification(worldboss) Spell(blinding_sleet)
		if target.InRange(mind_freeze) and target.IsInterruptible() Spell(mind_freeze)
	}
}

AddFunction FrostUseItemActions
{
	if Item(Trinket0Slot usable=1) Texture(inv_jewelry_talisman_12)
	if Item(Trinket1Slot usable=1) Texture(inv_jewelry_talisman_12)
}

AddFunction other_on_use_equipped
{
 HasEquippedItem(notorious_gladiators_badge_item) or HasEquippedItem(sinister_gladiators_badge_item) or HasEquippedItem(sinister_gladiators_medallion_item) or HasEquippedItem(vial_of_animated_blood_item) or HasEquippedItem(first_mates_spyglass_item) or HasEquippedItem(jes_howler_item) or HasEquippedItem(notorious_gladiators_medallion_item)
}

### actions.default

AddFunction FrostDefaultMainActions
{
 #howling_blast,if=!dot.frost_fever.ticking&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
 if not target.DebuffPresent(frost_fever_debuff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } Spell(howling_blast)
 #glacial_advance,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&spell_targets.glacial_advance>=2&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
 if BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and Enemies(tagged=1) >= 2 and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } Spell(glacial_advance)
 #frost_strike,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
 if BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } Spell(frost_strike)
 #call_action_list,name=essences
 FrostEssencesMainActions()

 unless FrostEssencesMainPostConditions()
 {
  #call_action_list,name=cooldowns
  FrostCooldownsMainActions()

  unless FrostCooldownsMainPostConditions()
  {
   #run_action_list,name=bos_pooling,if=talent.breath_of_sindragosa.enabled&((cooldown.breath_of_sindragosa.remains=0&cooldown.pillar_of_frost.remains<10)|(cooldown.breath_of_sindragosa.remains<20&target.1.time_to_die<35))
   if Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } FrostBosPoolingMainActions()

   unless Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } and FrostBosPoolingMainPostConditions()
   {
    #run_action_list,name=bos_ticking,if=buff.breath_of_sindragosa.up
    if BuffPresent(breath_of_sindragosa_buff) FrostBosTickingMainActions()

    unless BuffPresent(breath_of_sindragosa_buff) and FrostBosTickingMainPostConditions()
    {
     #run_action_list,name=obliteration,if=buff.pillar_of_frost.up&talent.obliteration.enabled
     if BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) FrostObliterationMainActions()

     unless BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) and FrostObliterationMainPostConditions()
     {
      #run_action_list,name=aoe,if=active_enemies>=2
      if Enemies(tagged=1) >= 2 FrostAoeMainActions()

      unless Enemies(tagged=1) >= 2 and FrostAoeMainPostConditions()
      {
       #call_action_list,name=standard
       FrostStandardMainActions()
      }
     }
    }
   }
  }
 }
}

AddFunction FrostDefaultMainPostConditions
{
 FrostEssencesMainPostConditions() or FrostCooldownsMainPostConditions() or Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } and FrostBosPoolingMainPostConditions() or BuffPresent(breath_of_sindragosa_buff) and FrostBosTickingMainPostConditions() or BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) and FrostObliterationMainPostConditions() or Enemies(tagged=1) >= 2 and FrostAoeMainPostConditions() or FrostStandardMainPostConditions()
}

AddFunction FrostDefaultShortCdActions
{
 #auto_attack
 # FrostGetInMeleeRange()

 unless not target.DebuffPresent(frost_fever_debuff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(howling_blast) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and Enemies(tagged=1) >= 2 and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(glacial_advance) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(frost_strike)
 {
  #call_action_list,name=essences
  FrostEssencesShortCdActions()

  unless FrostEssencesShortCdPostConditions()
  {
   #call_action_list,name=cooldowns
   FrostCooldownsShortCdActions()

   unless FrostCooldownsShortCdPostConditions()
   {
    #run_action_list,name=bos_pooling,if=talent.breath_of_sindragosa.enabled&((cooldown.breath_of_sindragosa.remains=0&cooldown.pillar_of_frost.remains<10)|(cooldown.breath_of_sindragosa.remains<20&target.1.time_to_die<35))
    if Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } FrostBosPoolingShortCdActions()

    unless Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } and FrostBosPoolingShortCdPostConditions()
    {
     #run_action_list,name=bos_ticking,if=buff.breath_of_sindragosa.up
     if BuffPresent(breath_of_sindragosa_buff) FrostBosTickingShortCdActions()

     unless BuffPresent(breath_of_sindragosa_buff) and FrostBosTickingShortCdPostConditions()
     {
      #run_action_list,name=obliteration,if=buff.pillar_of_frost.up&talent.obliteration.enabled
      if BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) FrostObliterationShortCdActions()

      unless BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) and FrostObliterationShortCdPostConditions()
      {
       #run_action_list,name=aoe,if=active_enemies>=2
       if Enemies(tagged=1) >= 2 FrostAoeShortCdActions()

       unless Enemies(tagged=1) >= 2 and FrostAoeShortCdPostConditions()
       {
        #call_action_list,name=standard
        FrostStandardShortCdActions()
       }
      }
     }
    }
   }
  }
 }
}

AddFunction FrostDefaultShortCdPostConditions
{
 not target.DebuffPresent(frost_fever_debuff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(howling_blast) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and Enemies(tagged=1) >= 2 and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(glacial_advance) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(frost_strike) or FrostEssencesShortCdPostConditions() or FrostCooldownsShortCdPostConditions() or Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } and FrostBosPoolingShortCdPostConditions() or BuffPresent(breath_of_sindragosa_buff) and FrostBosTickingShortCdPostConditions() or BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) and FrostObliterationShortCdPostConditions() or Enemies(tagged=1) >= 2 and FrostAoeShortCdPostConditions() or FrostStandardShortCdPostConditions()
}

AddFunction FrostDefaultCdActions
{
 # FrostInterruptActions()

 unless not target.DebuffPresent(frost_fever_debuff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(howling_blast) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and Enemies(tagged=1) >= 2 and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(glacial_advance) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(frost_strike)
 {
  #call_action_list,name=essences
  FrostEssencesCdActions()

  unless FrostEssencesCdPostConditions()
  {
   #call_action_list,name=cooldowns
   FrostCooldownsCdActions()

   unless FrostCooldownsCdPostConditions()
   {
    #run_action_list,name=bos_pooling,if=talent.breath_of_sindragosa.enabled&((cooldown.breath_of_sindragosa.remains=0&cooldown.pillar_of_frost.remains<10)|(cooldown.breath_of_sindragosa.remains<20&target.1.time_to_die<35))
    if Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } FrostBosPoolingCdActions()

    unless Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } and FrostBosPoolingCdPostConditions()
    {
     #run_action_list,name=bos_ticking,if=buff.breath_of_sindragosa.up
     if BuffPresent(breath_of_sindragosa_buff) FrostBosTickingCdActions()

     unless BuffPresent(breath_of_sindragosa_buff) and FrostBosTickingCdPostConditions()
     {
      #run_action_list,name=obliteration,if=buff.pillar_of_frost.up&talent.obliteration.enabled
      if BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) FrostObliterationCdActions()

      unless BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) and FrostObliterationCdPostConditions()
      {
       #run_action_list,name=aoe,if=active_enemies>=2
       if Enemies(tagged=1) >= 2 FrostAoeCdActions()

       unless Enemies(tagged=1) >= 2 and FrostAoeCdPostConditions()
       {
        #call_action_list,name=standard
        FrostStandardCdActions()
       }
      }
     }
    }
   }
  }
 }
}

AddFunction FrostDefaultCdPostConditions
{
 not target.DebuffPresent(frost_fever_debuff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(howling_blast) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and Enemies(tagged=1) >= 2 and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(glacial_advance) or BuffRemaining(icy_talons_buff) <= GCD() and BuffPresent(icy_talons_buff) and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(breath_of_sindragosa) > 15 } and Spell(frost_strike) or FrostEssencesCdPostConditions() or FrostCooldownsCdPostConditions() or Talent(breath_of_sindragosa_talent) and { not SpellCooldown(breath_of_sindragosa) > 0 and SpellCooldown(pillar_of_frost) < 10 or SpellCooldown(breath_of_sindragosa) < 20 and target.TimeToDie() < 35 } and FrostBosPoolingCdPostConditions() or BuffPresent(breath_of_sindragosa_buff) and FrostBosTickingCdPostConditions() or BuffPresent(pillar_of_frost_buff) and Talent(obliteration_talent) and FrostObliterationCdPostConditions() or Enemies(tagged=1) >= 2 and FrostAoeCdPostConditions() or FrostStandardCdPostConditions()
}

### actions.aoe

AddFunction FrostAoeMainActions
{
 #remorseless_winter,if=talent.gathering_storm.enabled|(azerite.frozen_tempest.rank&spell_targets.remorseless_winter>=3&!buff.rime.up)
 if Talent(gathering_storm_talent) or AzeriteTraitRank(frozen_tempest_trait) and Enemies(tagged=1) >= 3 and not BuffPresent(rime_buff) Spell(remorseless_winter)
 #glacial_advance,if=talent.frostscythe.enabled
 if Talent(frostscythe_talent) Spell(glacial_advance)
 #frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and not Talent(frostscythe_talent) Spell(frost_strike)
 #frost_strike,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled
 if SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) Spell(frost_strike)
 #howling_blast,if=buff.rime.up
 if BuffPresent(rime_buff) Spell(howling_blast)
 #frostscythe,if=buff.killing_machine.up
 if BuffPresent(killing_machine_buff) Spell(frostscythe)
 #glacial_advance,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
 if RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 Spell(glacial_advance)
 #frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit<(15+talent.runic_attenuation.enabled*3)&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) Spell(frost_strike)
 #frost_strike,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)&!talent.frostscythe.enabled
 if RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) Spell(frost_strike)
 #remorseless_winter
 Spell(remorseless_winter)
 #frostscythe
 Spell(frostscythe)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit>(25+talent.runic_attenuation.enabled*3)&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) Spell(obliterate)
 #obliterate,if=runic_power.deficit>(25+talent.runic_attenuation.enabled*3)
 if RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 Spell(obliterate)
 #glacial_advance
 Spell(glacial_advance)
 #frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) Spell(frost_strike)
 #frost_strike
 Spell(frost_strike)
 #horn_of_winter
 Spell(horn_of_winter)
}

AddFunction FrostAoeMainPostConditions
{
}

AddFunction FrostAoeShortCdActions
{
}

AddFunction FrostAoeShortCdPostConditions
{
 { Talent(gathering_storm_talent) or AzeriteTraitRank(frozen_tempest_trait) and Enemies(tagged=1) >= 3 and not BuffPresent(rime_buff) } and Spell(remorseless_winter) or Talent(frostscythe_talent) and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and not Talent(frostscythe_talent) and Spell(frost_strike) or SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or BuffPresent(killing_machine_buff) and Spell(frostscythe) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(frost_strike) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(frost_strike) or Spell(remorseless_winter) or Spell(frostscythe) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and Spell(frost_strike) or Spell(frost_strike) or Spell(horn_of_winter)
}

AddFunction FrostAoeCdActions
{
 unless { Talent(gathering_storm_talent) or AzeriteTraitRank(frozen_tempest_trait) and Enemies(tagged=1) >= 3 and not BuffPresent(rime_buff) } and Spell(remorseless_winter) or Talent(frostscythe_talent) and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and not Talent(frostscythe_talent) and Spell(frost_strike) or SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or BuffPresent(killing_machine_buff) and Spell(frostscythe) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(frost_strike) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(frost_strike) or Spell(remorseless_winter) or Spell(frostscythe) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and Spell(frost_strike) or Spell(frost_strike) or Spell(horn_of_winter)
 {
  #arcane_torrent
  Spell(arcane_torrent_runicpower)
 }
}

AddFunction FrostAoeCdPostConditions
{
 { Talent(gathering_storm_talent) or AzeriteTraitRank(frozen_tempest_trait) and Enemies(tagged=1) >= 3 and not BuffPresent(rime_buff) } and Spell(remorseless_winter) or Talent(frostscythe_talent) and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and not Talent(frostscythe_talent) and Spell(frost_strike) or SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or BuffPresent(killing_machine_buff) and Spell(frostscythe) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(frost_strike) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(frost_strike) or Spell(remorseless_winter) or Spell(frostscythe) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and Spell(frost_strike) or Spell(frost_strike) or Spell(horn_of_winter)
}

### actions.bos_pooling

AddFunction FrostBosPoolingMainActions
{
 #howling_blast,if=buff.rime.up
 if BuffPresent(rime_buff) Spell(howling_blast)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&&runic_power.deficit>=25&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() >= 25 and not Talent(frostscythe_talent) Spell(obliterate)
 #obliterate,if=runic_power.deficit>=25
 if RunicPowerDeficit() >= 25 Spell(obliterate)
 #glacial_advance,if=runic_power.deficit<20&spell_targets.glacial_advance>=2&cooldown.pillar_of_frost.remains>5
 if RunicPowerDeficit() < 20 and Enemies(tagged=1) >= 2 and SpellCooldown(pillar_of_frost) > 5 Spell(glacial_advance)
 #frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit<20&!talent.frostscythe.enabled&cooldown.pillar_of_frost.remains>5
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() < 20 and not Talent(frostscythe_talent) and SpellCooldown(pillar_of_frost) > 5 Spell(frost_strike)
 #frost_strike,if=runic_power.deficit<20&cooldown.pillar_of_frost.remains>5
 if RunicPowerDeficit() < 20 and SpellCooldown(pillar_of_frost) > 5 Spell(frost_strike)
 #frostscythe,if=buff.killing_machine.up&runic_power.deficit>(15+talent.runic_attenuation.enabled*3)&spell_targets.frostscythe>=2
 if BuffPresent(killing_machine_buff) and RunicPowerDeficit() > 15 + TalentPoints(runic_attenuation_talent) * 3 and Enemies(tagged=1) >= 2 Spell(frostscythe)
 #frostscythe,if=runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)&spell_targets.frostscythe>=2
 if RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and Enemies(tagged=1) >= 2 Spell(frostscythe)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) Spell(obliterate)
 #obliterate,if=runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)
 if RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 Spell(obliterate)
 #glacial_advance,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40&spell_targets.glacial_advance>=2
 if SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and Enemies(tagged=1) >= 2 Spell(glacial_advance)
 #frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and not Talent(frostscythe_talent) Spell(frost_strike)
 #frost_strike,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40
 if SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 Spell(frost_strike)
}

AddFunction FrostBosPoolingMainPostConditions
{
}

AddFunction FrostBosPoolingShortCdActions
{
}

AddFunction FrostBosPoolingShortCdPostConditions
{
 BuffPresent(rime_buff) and Spell(howling_blast) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() >= 25 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPowerDeficit() >= 25 and Spell(obliterate) or RunicPowerDeficit() < 20 and Enemies(tagged=1) >= 2 and SpellCooldown(pillar_of_frost) > 5 and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() < 20 and not Talent(frostscythe_talent) and SpellCooldown(pillar_of_frost) > 5 and Spell(frost_strike) or RunicPowerDeficit() < 20 and SpellCooldown(pillar_of_frost) > 5 and Spell(frost_strike) or BuffPresent(killing_machine_buff) and RunicPowerDeficit() > 15 + TalentPoints(runic_attenuation_talent) * 3 and Enemies(tagged=1) >= 2 and Spell(frostscythe) or RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and Enemies(tagged=1) >= 2 and Spell(frostscythe) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and Enemies(tagged=1) >= 2 and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and not Talent(frostscythe_talent) and Spell(frost_strike) or SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and Spell(frost_strike)
}

AddFunction FrostBosPoolingCdActions
{
}

AddFunction FrostBosPoolingCdPostConditions
{
 BuffPresent(rime_buff) and Spell(howling_blast) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() >= 25 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPowerDeficit() >= 25 and Spell(obliterate) or RunicPowerDeficit() < 20 and Enemies(tagged=1) >= 2 and SpellCooldown(pillar_of_frost) > 5 and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() < 20 and not Talent(frostscythe_talent) and SpellCooldown(pillar_of_frost) > 5 and Spell(frost_strike) or RunicPowerDeficit() < 20 and SpellCooldown(pillar_of_frost) > 5 and Spell(frost_strike) or BuffPresent(killing_machine_buff) and RunicPowerDeficit() > 15 + TalentPoints(runic_attenuation_talent) * 3 and Enemies(tagged=1) >= 2 and Spell(frostscythe) or RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and Enemies(tagged=1) >= 2 and Spell(frostscythe) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPowerDeficit() >= 35 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and Enemies(tagged=1) >= 2 and Spell(glacial_advance) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and not Talent(frostscythe_talent) and Spell(frost_strike) or SpellCooldown(pillar_of_frost) > TimeToRunes(4) and RunicPowerDeficit() < 40 and Spell(frost_strike)
}

### actions.bos_ticking

AddFunction FrostBosTickingMainActions
{
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power<=30&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPower() <= 30 and not Talent(frostscythe_talent) Spell(obliterate)
 #obliterate,if=runic_power<=32
 if RunicPower() <= 32 Spell(obliterate)
 #remorseless_winter,if=talent.gathering_storm.enabled
 if Talent(gathering_storm_talent) Spell(remorseless_winter)
 #howling_blast,if=buff.rime.up
 if BuffPresent(rime_buff) Spell(howling_blast)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&rune.time_to_5<gcd|runic_power<=45&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and TimeToRunes(5) < GCD() or RunicPower() <= 45 and not Talent(frostscythe_talent) Spell(obliterate)
 #obliterate,if=rune.time_to_5<gcd|runic_power<=45
 if TimeToRunes(5) < GCD() or RunicPower() <= 45 Spell(obliterate)
 #frostscythe,if=buff.killing_machine.up&spell_targets.frostscythe>=2
 if BuffPresent(killing_machine_buff) and Enemies(tagged=1) >= 2 Spell(frostscythe)
 #horn_of_winter,if=runic_power.deficit>=32&rune.time_to_3>gcd
 if RunicPowerDeficit() >= 32 and TimeToRunes(3) > GCD() Spell(horn_of_winter)
 #remorseless_winter
 Spell(remorseless_winter)
 #frostscythe,if=spell_targets.frostscythe>=2
 if Enemies(tagged=1) >= 2 Spell(frostscythe)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&runic_power.deficit>25|rune>3&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 or RuneCount() > 3 and not Talent(frostscythe_talent) Spell(obliterate)
 #obliterate,if=runic_power.deficit>25|rune>3
 if RunicPowerDeficit() > 25 or RuneCount() > 3 Spell(obliterate)
}

AddFunction FrostBosTickingMainPostConditions
{
}

AddFunction FrostBosTickingShortCdActions
{
}

AddFunction FrostBosTickingShortCdPostConditions
{
 { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPower() <= 30 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPower() <= 32 and Spell(obliterate) or Talent(gathering_storm_talent) and Spell(remorseless_winter) or BuffPresent(rime_buff) and Spell(howling_blast) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and TimeToRunes(5) < GCD() or RunicPower() <= 45 and not Talent(frostscythe_talent) } and Spell(obliterate) or { TimeToRunes(5) < GCD() or RunicPower() <= 45 } and Spell(obliterate) or BuffPresent(killing_machine_buff) and Enemies(tagged=1) >= 2 and Spell(frostscythe) or RunicPowerDeficit() >= 32 and TimeToRunes(3) > GCD() and Spell(horn_of_winter) or Spell(remorseless_winter) or Enemies(tagged=1) >= 2 and Spell(frostscythe) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 or RuneCount() > 3 and not Talent(frostscythe_talent) } and Spell(obliterate) or { RunicPowerDeficit() > 25 or RuneCount() > 3 } and Spell(obliterate)
}

AddFunction FrostBosTickingCdActions
{
 unless { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPower() <= 30 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPower() <= 32 and Spell(obliterate) or Talent(gathering_storm_talent) and Spell(remorseless_winter) or BuffPresent(rime_buff) and Spell(howling_blast) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and TimeToRunes(5) < GCD() or RunicPower() <= 45 and not Talent(frostscythe_talent) } and Spell(obliterate) or { TimeToRunes(5) < GCD() or RunicPower() <= 45 } and Spell(obliterate) or BuffPresent(killing_machine_buff) and Enemies(tagged=1) >= 2 and Spell(frostscythe) or RunicPowerDeficit() >= 32 and TimeToRunes(3) > GCD() and Spell(horn_of_winter) or Spell(remorseless_winter) or Enemies(tagged=1) >= 2 and Spell(frostscythe) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 or RuneCount() > 3 and not Talent(frostscythe_talent) } and Spell(obliterate) or { RunicPowerDeficit() > 25 or RuneCount() > 3 } and Spell(obliterate)
 {
  #arcane_torrent,if=runic_power.deficit>20
  if RunicPowerDeficit() > 20 Spell(arcane_torrent_runicpower)
 }
}

AddFunction FrostBosTickingCdPostConditions
{
 { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPower() <= 30 and not Talent(frostscythe_talent) and Spell(obliterate) or RunicPower() <= 32 and Spell(obliterate) or Talent(gathering_storm_talent) and Spell(remorseless_winter) or BuffPresent(rime_buff) and Spell(howling_blast) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and TimeToRunes(5) < GCD() or RunicPower() <= 45 and not Talent(frostscythe_talent) } and Spell(obliterate) or { TimeToRunes(5) < GCD() or RunicPower() <= 45 } and Spell(obliterate) or BuffPresent(killing_machine_buff) and Enemies(tagged=1) >= 2 and Spell(frostscythe) or RunicPowerDeficit() >= 32 and TimeToRunes(3) > GCD() and Spell(horn_of_winter) or Spell(remorseless_winter) or Enemies(tagged=1) >= 2 and Spell(frostscythe) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and RunicPowerDeficit() > 25 or RuneCount() > 3 and not Talent(frostscythe_talent) } and Spell(obliterate) or { RunicPowerDeficit() > 25 or RuneCount() > 3 } and Spell(obliterate)
}

### actions.cold_heart

AddFunction FrostColdHeartMainActions
{
 #chains_of_ice,if=buff.cold_heart.stack>5&target.1.time_to_die<gcd
 if BuffStacks(cold_heart_buff) > 5 and target.TimeToDie() < GCD() Spell(chains_of_ice)
 #chains_of_ice,if=(buff.pillar_of_frost.remains<=gcd*(1+cooldown.frostwyrms_fury.ready)|buff.pillar_of_frost.remains<rune.time_to_3)&buff.pillar_of_frost.up&azerite.icy_citadel.rank<=2
 if { BuffRemaining(pillar_of_frost_buff) <= GCD() * { 1 + { SpellCooldown(frostwyrms_fury) == 0 } } or BuffRemaining(pillar_of_frost_buff) < TimeToRunes(3) } and BuffPresent(pillar_of_frost_buff) and AzeriteTraitRank(icy_citadel_trait) <= 2 Spell(chains_of_ice)
 #chains_of_ice,if=buff.pillar_of_frost.remains<8&buff.unholy_strength.remains<gcd*(1+cooldown.frostwyrms_fury.ready)&buff.unholy_strength.remains&buff.pillar_of_frost.up&azerite.icy_citadel.rank<=2
 if BuffRemaining(pillar_of_frost_buff) < 8 and BuffRemaining(unholy_strength_buff) < GCD() * { 1 + { SpellCooldown(frostwyrms_fury) == 0 } } and BuffPresent(unholy_strength_buff) and BuffPresent(pillar_of_frost_buff) and AzeriteTraitRank(icy_citadel_trait) <= 2 Spell(chains_of_ice)
 #chains_of_ice,if=(buff.icy_citadel.remains<4|buff.icy_citadel.remains<rune.time_to_3)&buff.icy_citadel.up&azerite.icy_citadel.rank>2
 if { BuffRemaining(icy_citadel_buff) < 4 or BuffRemaining(icy_citadel_buff) < TimeToRunes(3) } and BuffPresent(icy_citadel_buff) and AzeriteTraitRank(icy_citadel_trait) > 2 Spell(chains_of_ice)
 #chains_of_ice,if=buff.icy_citadel.up&buff.unholy_strength.up&azerite.icy_citadel.rank>2
 if BuffPresent(icy_citadel_buff) and BuffPresent(unholy_strength_buff) and AzeriteTraitRank(icy_citadel_trait) > 2 Spell(chains_of_ice)
}

AddFunction FrostColdHeartMainPostConditions
{
}

AddFunction FrostColdHeartShortCdActions
{
}

AddFunction FrostColdHeartShortCdPostConditions
{
 BuffStacks(cold_heart_buff) > 5 and target.TimeToDie() < GCD() and Spell(chains_of_ice) or { BuffRemaining(pillar_of_frost_buff) <= GCD() * { 1 + { SpellCooldown(frostwyrms_fury) == 0 } } or BuffRemaining(pillar_of_frost_buff) < TimeToRunes(3) } and BuffPresent(pillar_of_frost_buff) and AzeriteTraitRank(icy_citadel_trait) <= 2 and Spell(chains_of_ice) or BuffRemaining(pillar_of_frost_buff) < 8 and BuffRemaining(unholy_strength_buff) < GCD() * { 1 + { SpellCooldown(frostwyrms_fury) == 0 } } and BuffPresent(unholy_strength_buff) and BuffPresent(pillar_of_frost_buff) and AzeriteTraitRank(icy_citadel_trait) <= 2 and Spell(chains_of_ice) or { BuffRemaining(icy_citadel_buff) < 4 or BuffRemaining(icy_citadel_buff) < TimeToRunes(3) } and BuffPresent(icy_citadel_buff) and AzeriteTraitRank(icy_citadel_trait) > 2 and Spell(chains_of_ice) or BuffPresent(icy_citadel_buff) and BuffPresent(unholy_strength_buff) and AzeriteTraitRank(icy_citadel_trait) > 2 and Spell(chains_of_ice)
}

AddFunction FrostColdHeartCdActions
{
}

AddFunction FrostColdHeartCdPostConditions
{
 BuffStacks(cold_heart_buff) > 5 and target.TimeToDie() < GCD() and Spell(chains_of_ice) or { BuffRemaining(pillar_of_frost_buff) <= GCD() * { 1 + { SpellCooldown(frostwyrms_fury) == 0 } } or BuffRemaining(pillar_of_frost_buff) < TimeToRunes(3) } and BuffPresent(pillar_of_frost_buff) and AzeriteTraitRank(icy_citadel_trait) <= 2 and Spell(chains_of_ice) or BuffRemaining(pillar_of_frost_buff) < 8 and BuffRemaining(unholy_strength_buff) < GCD() * { 1 + { SpellCooldown(frostwyrms_fury) == 0 } } and BuffPresent(unholy_strength_buff) and BuffPresent(pillar_of_frost_buff) and AzeriteTraitRank(icy_citadel_trait) <= 2 and Spell(chains_of_ice) or { BuffRemaining(icy_citadel_buff) < 4 or BuffRemaining(icy_citadel_buff) < TimeToRunes(3) } and BuffPresent(icy_citadel_buff) and AzeriteTraitRank(icy_citadel_trait) > 2 and Spell(chains_of_ice) or BuffPresent(icy_citadel_buff) and BuffPresent(unholy_strength_buff) and AzeriteTraitRank(icy_citadel_trait) > 2 and Spell(chains_of_ice)
}

### actions.cooldowns

AddFunction FrostCooldownsMainActions
{
 #call_action_list,name=cold_heart,if=talent.cold_heart.enabled&((buff.cold_heart.stack>=10&debuff.razorice.stack=5)|target.1.time_to_die<=gcd)
 if Talent(cold_heart_talent) and { BuffStacks(cold_heart_buff) >= 10 and target.DebuffStacks(razorice_debuff) == 5 or target.TimeToDie() <= GCD() } FrostColdHeartMainActions()
}

AddFunction FrostCooldownsMainPostConditions
{
 Talent(cold_heart_talent) and { BuffStacks(cold_heart_buff) >= 10 and target.DebuffStacks(razorice_debuff) == 5 or target.TimeToDie() <= GCD() } and FrostColdHeartMainPostConditions()
}

AddFunction FrostCooldownsShortCdActions
{
 #pillar_of_frost,if=cooldown.empower_rune_weapon.remains
 if SpellCooldown(empower_rune_weapon) > 0 Spell(pillar_of_frost)
 #call_action_list,name=cold_heart,if=talent.cold_heart.enabled&((buff.cold_heart.stack>=10&debuff.razorice.stack=5)|target.1.time_to_die<=gcd)
 if Talent(cold_heart_talent) and { BuffStacks(cold_heart_buff) >= 10 and target.DebuffStacks(razorice_debuff) == 5 or target.TimeToDie() <= GCD() } FrostColdHeartShortCdActions()
}

AddFunction FrostCooldownsShortCdPostConditions
{
 Talent(cold_heart_talent) and { BuffStacks(cold_heart_buff) >= 10 and target.DebuffStacks(razorice_debuff) == 5 or target.TimeToDie() <= GCD() } and FrostColdHeartShortCdPostConditions()
}

AddFunction FrostCooldownsCdActions
{
 #use_item,name=azsharas_font_of_power,if=(cooldown.empowered_rune_weapon.ready&!variable.other_on_use_equipped)|(cooldown.pillar_of_frost.remains<=10&variable.other_on_use_equipped)
 if SpellCooldown(empower_rune_weapon) == 0 and not other_on_use_equipped() or SpellCooldown(pillar_of_frost) <= 10 and other_on_use_equipped() FrostUseItemActions()
 #use_item,name=lurkers_insidious_gift,if=talent.breath_of_sindragosa.enabled&((cooldown.pillar_of_frost.remains<=10&variable.other_on_use_equipped)|(buff.pillar_of_frost.up&!variable.other_on_use_equipped))|(buff.pillar_of_frost.up&!talent.breath_of_sindragosa.enabled)
 if Talent(breath_of_sindragosa_talent) and { SpellCooldown(pillar_of_frost) <= 10 and other_on_use_equipped() or BuffPresent(pillar_of_frost_buff) and not other_on_use_equipped() } or BuffPresent(pillar_of_frost_buff) and not Talent(breath_of_sindragosa_talent) FrostUseItemActions()
 #use_item,name=cyclotronic_blast,if=!buff.pillar_of_frost.up
 if not BuffPresent(pillar_of_frost_buff) FrostUseItemActions()
 #use_item,name=ashvanes_razor_coral,if=cooldown.empower_rune_weapon.remains>110|cooldown.breath_of_sindragosa.remains>90|time<50|target.1.time_to_die<21
 if SpellCooldown(empower_rune_weapon) > 110 or SpellCooldown(breath_of_sindragosa) > 90 or TimeInCombat() < 50 or target.TimeToDie() < 21 FrostUseItemActions()
 #use_items,if=(cooldown.pillar_of_frost.ready|cooldown.pillar_of_frost.remains>20)&(!talent.breath_of_sindragosa.enabled|cooldown.empower_rune_weapon.remains>95)
 if { SpellCooldown(pillar_of_frost) == 0 or SpellCooldown(pillar_of_frost) > 20 } and { not Talent(breath_of_sindragosa_talent) or SpellCooldown(empower_rune_weapon) > 95 } FrostUseItemActions()
 #use_item,name=jes_howler,if=(equipped.lurkers_insidious_gift&buff.pillar_of_frost.remains)|(!equipped.lurkers_insidious_gift&buff.pillar_of_frost.remains<12&buff.pillar_of_frost.up)
 if HasEquippedItem(lurkers_insidious_gift_item) and BuffPresent(pillar_of_frost_buff) or not HasEquippedItem(lurkers_insidious_gift_item) and BuffRemaining(pillar_of_frost_buff) < 12 and BuffPresent(pillar_of_frost_buff) FrostUseItemActions()
 #use_item,name=knot_of_ancient_fury,if=cooldown.empower_rune_weapon.remains>40
 if SpellCooldown(empower_rune_weapon) > 40 FrostUseItemActions()
 #use_item,name=grongs_primal_rage,if=rune<=3&!buff.pillar_of_frost.up&(!buff.breath_of_sindragosa.up|!talent.breath_of_sindragosa.enabled)
 if RuneCount() <= 3 and not BuffPresent(pillar_of_frost_buff) and { not BuffPresent(breath_of_sindragosa_buff) or not Talent(breath_of_sindragosa_talent) } FrostUseItemActions()
 #use_item,name=razdunks_big_red_button
 FrostUseItemActions()
 #use_item,name=merekthas_fang,if=!buff.breath_of_sindragosa.up&!buff.pillar_of_frost.up
 if not BuffPresent(breath_of_sindragosa_buff) and not BuffPresent(pillar_of_frost_buff) FrostUseItemActions()
 #potion,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
 # if BuffPresent(pillar_of_frost_buff) and BuffPresent(empower_rune_weapon_buff) and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(item_battle_potion_of_strength usable=1)
 #blood_fury,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
 if BuffPresent(pillar_of_frost_buff) and BuffPresent(empower_rune_weapon_buff) Spell(blood_fury_ap)
 #berserking,if=buff.pillar_of_frost.up
 if BuffPresent(pillar_of_frost_buff) Spell(berserking)

 unless SpellCooldown(empower_rune_weapon) > 0 and Spell(pillar_of_frost)
 {
  #breath_of_sindragosa,use_off_gcd=1,if=cooldown.empower_rune_weapon.remains&cooldown.pillar_of_frost.remains
  if SpellCooldown(empower_rune_weapon) > 0 and SpellCooldown(pillar_of_frost) > 0 Spell(breath_of_sindragosa)
  #empower_rune_weapon,if=cooldown.pillar_of_frost.ready&!talent.breath_of_sindragosa.enabled&rune.time_to_5>gcd&runic_power.deficit>=10|target.1.time_to_die<20
  if SpellCooldown(pillar_of_frost) == 0 and not Talent(breath_of_sindragosa_talent) and TimeToRunes(5) > GCD() and RunicPowerDeficit() >= 10 or target.TimeToDie() < 20 Spell(empower_rune_weapon)
  #empower_rune_weapon,if=(cooldown.pillar_of_frost.ready|target.1.time_to_die<20)&talent.breath_of_sindragosa.enabled&runic_power>60
  if { SpellCooldown(pillar_of_frost) == 0 or target.TimeToDie() < 20 } and Talent(breath_of_sindragosa_talent) and RunicPower() > 60 Spell(empower_rune_weapon)
  #call_action_list,name=cold_heart,if=talent.cold_heart.enabled&((buff.cold_heart.stack>=10&debuff.razorice.stack=5)|target.1.time_to_die<=gcd)
  if Talent(cold_heart_talent) and { BuffStacks(cold_heart_buff) >= 10 and target.DebuffStacks(razorice_debuff) == 5 or target.TimeToDie() <= GCD() } FrostColdHeartCdActions()

  unless Talent(cold_heart_talent) and { BuffStacks(cold_heart_buff) >= 10 and target.DebuffStacks(razorice_debuff) == 5 or target.TimeToDie() <= GCD() } and FrostColdHeartCdPostConditions()
  {
   #frostwyrms_fury,if=(buff.pillar_of_frost.remains<=gcd|(buff.pillar_of_frost.remains<8&buff.unholy_strength.remains<=gcd&buff.unholy_strength.up))&buff.pillar_of_frost.up&azerite.icy_citadel.rank<=2
   if { BuffRemaining(pillar_of_frost_buff) <= GCD() or BuffRemaining(pillar_of_frost_buff) < 8 and BuffRemaining(unholy_strength_buff) <= GCD() and BuffPresent(unholy_strength_buff) } and BuffPresent(pillar_of_frost_buff) and AzeriteTraitRank(icy_citadel_trait) <= 2 Spell(frostwyrms_fury)
   #frostwyrms_fury,if=(buff.icy_citadel.remains<=gcd|(buff.icy_citadel.remains<8&buff.unholy_strength.remains<=gcd&buff.unholy_strength.up))&buff.icy_citadel.up&azerite.icy_citadel.rank>2
   if { BuffRemaining(icy_citadel_buff) <= GCD() or BuffRemaining(icy_citadel_buff) < 8 and BuffRemaining(unholy_strength_buff) <= GCD() and BuffPresent(unholy_strength_buff) } and BuffPresent(icy_citadel_buff) and AzeriteTraitRank(icy_citadel_trait) > 2 Spell(frostwyrms_fury)
   #frostwyrms_fury,if=target.1.time_to_die<gcd|(target.1.time_to_die<cooldown.pillar_of_frost.remains&buff.unholy_strength.up)
   if target.TimeToDie() < GCD() or target.TimeToDie() < SpellCooldown(pillar_of_frost) and BuffPresent(unholy_strength_buff) Spell(frostwyrms_fury)
  }
 }
}

AddFunction FrostCooldownsCdPostConditions
{
 SpellCooldown(empower_rune_weapon) > 0 and Spell(pillar_of_frost) or Talent(cold_heart_talent) and { BuffStacks(cold_heart_buff) >= 10 and target.DebuffStacks(razorice_debuff) == 5 or target.TimeToDie() <= GCD() } and FrostColdHeartCdPostConditions()
}

### actions.essences

AddFunction FrostEssencesMainActions
{
 #concentrated_flame,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up&dot.concentrated_flame_burn.remains=0
 if not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and not target.DebuffRemaining(concentrated_flame_burn_debuff) > 0 Spell(concentrated_flame_essence)
}

AddFunction FrostEssencesMainPostConditions
{
}

AddFunction FrostEssencesShortCdActions
{
 #chill_streak,if=buff.pillar_of_frost.remains<5|target.1.time_to_die<5
 if BuffRemaining(pillar_of_frost_buff) < 5 or target.TimeToDie() < 5 Spell(chill_streak)
 #the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<11
 if BuffPresent(reckless_force_buff) or BuffStacks(reckless_force_counter) < 11 Spell(the_unbound_force)
 #focused_azerite_beam,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
 if not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) Spell(focused_azerite_beam)

 unless not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and not target.DebuffRemaining(concentrated_flame_burn_debuff) > 0 and Spell(concentrated_flame_essence)
 {
  #purifying_blast,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
  if not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) Spell(purifying_blast)
  #worldvein_resonance,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
  if not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) Spell(worldvein_resonance_essence)
  #ripple_in_space,if=!buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
  if not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) Spell(ripple_in_space_essence)
 }
}

AddFunction FrostEssencesShortCdPostConditions
{
 not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and not target.DebuffRemaining(concentrated_flame_burn_debuff) > 0 and Spell(concentrated_flame_essence)
}

AddFunction FrostEssencesCdActions
{
 #blood_of_the_enemy,if=buff.pillar_of_frost.remains<10&cooldown.breath_of_sindragosa.remains|buff.pillar_of_frost.remains<10&!talent.breath_of_sindragosa.enabled
 if BuffRemaining(pillar_of_frost_buff) < 10 and SpellCooldown(breath_of_sindragosa) > 0 or BuffRemaining(pillar_of_frost_buff) < 10 and not Talent(breath_of_sindragosa_talent) Spell(blood_of_the_enemy)
 #guardian_of_azeroth
 Spell(guardian_of_azeroth)

 unless { BuffRemaining(pillar_of_frost_buff) < 5 or target.TimeToDie() < 5 } and Spell(chill_streak) or { BuffPresent(reckless_force_buff) or BuffStacks(reckless_force_counter) < 11 } and Spell(the_unbound_force) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(focused_azerite_beam) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and not target.DebuffRemaining(concentrated_flame_burn_debuff) > 0 and Spell(concentrated_flame_essence) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(purifying_blast) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(worldvein_resonance_essence) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(ripple_in_space_essence)
 {
  #memory_of_lucid_dreams,if=buff.empower_rune_weapon.remains<5&buff.breath_of_sindragosa.up|(rune.time_to_2>gcd&runic_power<50)
  if BuffRemaining(empower_rune_weapon_buff) < 5 and BuffPresent(breath_of_sindragosa_buff) or TimeToRunes(2) > GCD() and RunicPower() < 50 Spell(memory_of_lucid_dreams_essence)
 }
}

AddFunction FrostEssencesCdPostConditions
{
 { BuffRemaining(pillar_of_frost_buff) < 5 or target.TimeToDie() < 5 } and Spell(chill_streak) or { BuffPresent(reckless_force_buff) or BuffStacks(reckless_force_counter) < 11 } and Spell(the_unbound_force) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(focused_azerite_beam) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and not target.DebuffRemaining(concentrated_flame_burn_debuff) > 0 and Spell(concentrated_flame_essence) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(purifying_blast) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(worldvein_resonance_essence) or not BuffPresent(pillar_of_frost_buff) and not BuffPresent(breath_of_sindragosa_buff) and Spell(ripple_in_space_essence)
}

### actions.obliteration

AddFunction FrostObliterationMainActions
{
 #remorseless_winter,if=talent.gathering_storm.enabled
 if Talent(gathering_storm_talent) Spell(remorseless_winter)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!talent.frostscythe.enabled&!buff.rime.up&spell_targets.howling_blast>=3
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and not BuffPresent(rime_buff) and Enemies(tagged=1) >= 3 Spell(obliterate)
 #obliterate,if=!talent.frostscythe.enabled&!buff.rime.up&spell_targets.howling_blast>=3
 if not Talent(frostscythe_talent) and not BuffPresent(rime_buff) and Enemies(tagged=1) >= 3 Spell(obliterate)
 #frostscythe,if=(buff.killing_machine.react|(buff.killing_machine.up&(prev_gcd.1.frost_strike|prev_gcd.1.howling_blast|prev_gcd.1.glacial_advance)))&spell_targets.frostscythe>=2
 if { BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } } and Enemies(tagged=1) >= 2 Spell(frostscythe)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&buff.killing_machine.react|(buff.killing_machine.up&(prev_gcd.1.frost_strike|prev_gcd.1.howling_blast|prev_gcd.1.glacial_advance))
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } Spell(obliterate)
 #obliterate,if=buff.killing_machine.react|(buff.killing_machine.up&(prev_gcd.1.frost_strike|prev_gcd.1.howling_blast|prev_gcd.1.glacial_advance))
 if BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } Spell(obliterate)
 #glacial_advance,if=(!buff.rime.up|runic_power.deficit<10|rune.time_to_2>gcd)&spell_targets.glacial_advance>=2
 if { not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() } and Enemies(tagged=1) >= 2 Spell(glacial_advance)
 #howling_blast,if=buff.rime.up&spell_targets.howling_blast>=2
 if BuffPresent(rime_buff) and Enemies(tagged=1) >= 2 Spell(howling_blast)
 #frost_strike,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!buff.rime.up|runic_power.deficit<10|rune.time_to_2>gcd&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() and not Talent(frostscythe_talent) Spell(frost_strike)
 #frost_strike,if=!buff.rime.up|runic_power.deficit<10|rune.time_to_2>gcd
 if not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() Spell(frost_strike)
 #howling_blast,if=buff.rime.up
 if BuffPresent(rime_buff) Spell(howling_blast)
 #obliterate,target_if=(debuff.razorice.stack<5|debuff.razorice.remains<10)&!talent.frostscythe.enabled
 if { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) Spell(obliterate)
 #obliterate
 Spell(obliterate)
}

AddFunction FrostObliterationMainPostConditions
{
}

AddFunction FrostObliterationShortCdActions
{
}

AddFunction FrostObliterationShortCdPostConditions
{
 Talent(gathering_storm_talent) and Spell(remorseless_winter) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and not BuffPresent(rime_buff) and Enemies(tagged=1) >= 3 and Spell(obliterate) or not Talent(frostscythe_talent) and not BuffPresent(rime_buff) and Enemies(tagged=1) >= 3 and Spell(obliterate) or { BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } } and Enemies(tagged=1) >= 2 and Spell(frostscythe) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } } and Spell(obliterate) or { BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } } and Spell(obliterate) or { not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() } and Enemies(tagged=1) >= 2 and Spell(glacial_advance) or BuffPresent(rime_buff) and Enemies(tagged=1) >= 2 and Spell(howling_blast) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() and not Talent(frostscythe_talent) } and Spell(frost_strike) or { not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() } and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and Spell(obliterate) or Spell(obliterate)
}

AddFunction FrostObliterationCdActions
{
}

AddFunction FrostObliterationCdPostConditions
{
 Talent(gathering_storm_talent) and Spell(remorseless_winter) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and not BuffPresent(rime_buff) and Enemies(tagged=1) >= 3 and Spell(obliterate) or not Talent(frostscythe_talent) and not BuffPresent(rime_buff) and Enemies(tagged=1) >= 3 and Spell(obliterate) or { BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } } and Enemies(tagged=1) >= 2 and Spell(frostscythe) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } } and Spell(obliterate) or { BuffPresent(killing_machine_buff) or BuffPresent(killing_machine_buff) and { PreviousGCDSpell(frost_strike) or PreviousGCDSpell(howling_blast) or PreviousGCDSpell(glacial_advance) } } and Spell(obliterate) or { not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() } and Enemies(tagged=1) >= 2 and Spell(glacial_advance) or BuffPresent(rime_buff) and Enemies(tagged=1) >= 2 and Spell(howling_blast) or { { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() and not Talent(frostscythe_talent) } and Spell(frost_strike) or { not BuffPresent(rime_buff) or RunicPowerDeficit() < 10 or TimeToRunes(2) > GCD() } and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or { target.DebuffStacks(razorice_debuff) < 5 or target.DebuffRemaining(razorice_debuff) < 10 } and not Talent(frostscythe_talent) and Spell(obliterate) or Spell(obliterate)
}

### actions.precombat

AddFunction FrostPrecombatMainActions
{
}

AddFunction FrostPrecombatMainPostConditions
{
}

AddFunction FrostPrecombatShortCdActions
{
}

AddFunction FrostPrecombatShortCdPostConditions
{
}

AddFunction FrostPrecombatCdActions
{
 #flask
 #food
 #augmentation
 #snapshot_stats
 #potion
 # if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(item_battle_potion_of_strength usable=1)
}

AddFunction FrostPrecombatCdPostConditions
{
}

### actions.standard

AddFunction FrostStandardMainActions
{
 #remorseless_winter
 Spell(remorseless_winter)
 #frost_strike,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled
 if SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) Spell(frost_strike)
 #howling_blast,if=buff.rime.up
 if BuffPresent(rime_buff) Spell(howling_blast)
 #obliterate,if=!buff.frozen_pulse.up&talent.frozen_pulse.enabled
 if not BuffPresent(frozen_pulse_buff) and Talent(frozen_pulse_talent) Spell(obliterate)
 #frost_strike,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
 if RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 Spell(frost_strike)
 #frostscythe,if=buff.killing_machine.up&rune.time_to_4>=gcd
 if BuffPresent(killing_machine_buff) and TimeToRunes(4) >= GCD() Spell(frostscythe)
 #obliterate,if=runic_power.deficit>(25+talent.runic_attenuation.enabled*3)
 if RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 Spell(obliterate)
 #frost_strike
 Spell(frost_strike)
 #horn_of_winter
 Spell(horn_of_winter)
}

AddFunction FrostStandardMainPostConditions
{
}

AddFunction FrostStandardShortCdActions
{
}

AddFunction FrostStandardShortCdPostConditions
{
 Spell(remorseless_winter) or SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or not BuffPresent(frozen_pulse_buff) and Talent(frozen_pulse_talent) and Spell(obliterate) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and Spell(frost_strike) or BuffPresent(killing_machine_buff) and TimeToRunes(4) >= GCD() and Spell(frostscythe) or RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or Spell(frost_strike) or Spell(horn_of_winter)
}

AddFunction FrostStandardCdActions
{
 unless Spell(remorseless_winter) or SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or not BuffPresent(frozen_pulse_buff) and Talent(frozen_pulse_talent) and Spell(obliterate) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and Spell(frost_strike) or BuffPresent(killing_machine_buff) and TimeToRunes(4) >= GCD() and Spell(frostscythe) or RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or Spell(frost_strike) or Spell(horn_of_winter)
 {
  #arcane_torrent
  Spell(arcane_torrent_runicpower)
 }
}

AddFunction FrostStandardCdPostConditions
{
 Spell(remorseless_winter) or SpellCooldown(remorseless_winter) <= 2 * GCD() and Talent(gathering_storm_talent) and Spell(frost_strike) or BuffPresent(rime_buff) and Spell(howling_blast) or not BuffPresent(frozen_pulse_buff) and Talent(frozen_pulse_talent) and Spell(obliterate) or RunicPowerDeficit() < 15 + TalentPoints(runic_attenuation_talent) * 3 and Spell(frost_strike) or BuffPresent(killing_machine_buff) and TimeToRunes(4) >= GCD() and Spell(frostscythe) or RunicPowerDeficit() > 25 + TalentPoints(runic_attenuation_talent) * 3 and Spell(obliterate) or Spell(frost_strike) or Spell(horn_of_winter)
}
]]

	OvaleScripts:RegisterScript("DEATHKNIGHT", "frost", name, desc, code, "script")
end
end