Ovale.defaut["MAGE"]=
[[
#Spells
Define(ARCANEBARRAGE 44425) #arcane instant
Define(ARCANEBLAST 30451) #arcane stacks*4 cost increased
	SpellAddDebuff(ARCANEBLAST ARCANEBLAST=10)
Define(ARCANEMISSILES 5143) #arcane channel
	SpellAddDebuff(ARCANEMISSILES ARCANEBLAST=0)
Define(ARCANEPOWER 12042) #arcane cd 
	SpellInfo(ARCANEPOWER cd=84)
Define(COLDSNAP 11958) #frost reset cd
Define(COMBUSTION 11129) #fire cd consume dot
	SpellInfo(COMBUSTION cd=180)
Define(DEEPFREEZE 44572) #frost instant
Define(FIREBLAST 2136) #fire instant
Define(FIREBALL 133) #fire 2.5
Define(FROSTBOLT 116) #frost
Define(FROSTFIREBOLT 44614) #frost+fire
Define(ICEARMOR 7302)
Define(ICELANCE 30455) #frost instant
Define(ICYVEINS 12472) #frost cd
	SpellInfo(ICYVEINS cd=144)
Define(LIVINGBOMB 44457) #fire dot
	SpellAddTargetDebuff(LIVINGBOMB LIVINGBOMB=12)
Define(MAGEARMOR 6117)
Define(MIRRORIMAGE 55342)
	SpellInfo(MIRRORIMAGE cd=180)
Define(MOLTENARMOR 30482)
Define(PRESENCEOFMIND 12043) #arcane next spell instant
Define(PYROBLAST 11366) #fire dot
	SpellAddTargetDebuff(PYROBLAST PYROBLAST=12)
	SpellAddBuff(PYROBLAST HOTSTREAK=0)
Define(SCORCH 2948) #fire 1.5 (cast while moving with firestarter talent)
Define(SUMMONWATERELEMENTAL 31687) #frost pet
	SpellInfo(SUMMONWATERELEMENTAL cd=180)

#Buff
Define(BRAINFREEZE 57761) #frost (instant fireball/frostfire bolt)
Define(FINGERSOFFROST 83074) #frost boost ice lance/deep freeze
Define(HOTSTREAK 48108) #fire instant pyroblast

#Talent
Define(FIRESTARTERTALENT 1849)

AddCheckBox(scorch SpellName(SCORCH) default talent=TALENTIMPROVEDSCORSH)
AddCheckBox(abarr SpellName(ARCANEBARRAGE) default talent=TALENTARCANEBARRAGE)

ScoreSpells(SCORCH PYROBLAST LIVINGBOMB FROSTFIREBOLT FIREBALL SUMMONWATERELEMENTAL FROSTBOLT ARCANEBLAST ARCANEMISSILES ARCANEBARRAGE
			DEEPFREEZE ICELANCE)

AddIcon help=main mastery=1
{
	unless InCombat() if BuffExpires(MAGEARMOR 400) and BuffExpires(MOLTENARMOR 400) and BuffExpires(ICEARMOR 400) Spell(MOLTENARMOR)
	
	if Speed(more 0) Spell(ARCANEBARRAGE)
	if DebuffPresent(ARCANEBLAST stacks=4)
		Spell(ARCANEMISSILES)
	Spell(ARCANEBLAST)
}

AddIcon help=main mastery=2
{
	unless InCombat() if BuffExpires(MAGEARMOR 400) and BuffExpires(MOLTENARMOR 400) and BuffExpires(ICEARMOR 400) Spell(MOLTENARMOR)

	if Talent(FIRESTARTERTALENT) and Speed(more 0) Spell(SCORCH)
	if BuffPresent(HOTSTREAK) Spell(PYROBLAST)
	if TargetDebuffExpires(LIVINGBOMB 0 mine=1) and TargetDeadIn(more 12) Spell(LIVINGBOMB)
	if TargetDebuffExpires(PYROBLAST 2.5 haste=spell mine=1) Spell(PYROBLAST)
	Spell(FIREBALL)
}

AddIcon help=main mastery=3
{
	unless InCombat() if BuffExpires(MAGEARMOR 400) and BuffExpires(MOLTENARMOR 400) and BuffExpires(ICEARMOR 400) Spell(MOLTENARMOR)

	if PetPresent(no) Spell(SUMMONWATERELEMENTAL)
	If BuffPresent(FINGERSOFFROST) or Speed(more 0) {Spell(DEEPFREEZE) Spell(ICELANCE)}
	if BuffPresent(BRAINFREEZE) Spell(FROSTFIREBOLT)
	Spell(FROSTBOLT)
}

AddIcon help=cd mastery=1
{
	if DebuffPresent(ARCANEBLAST stacks=3) Spell(ARCANEPOWER)
	Spell(PRESENCEOFMIND)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
	Spell(MIRRORIMAGE)
}

AddIcon help=cd mastery=2
{
	Spell(COMBUSTION)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
	Spell(MIRRORIMAGE)
}

AddIcon help=cd mastery=3
{
	Spell(ICYVEINS)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
	Spell(MIRRORIMAGE)
}

]]