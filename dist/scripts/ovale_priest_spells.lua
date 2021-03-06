local __exports = LibStub:NewLibrary("ovale/scripts/ovale_priest_spells", 80300)
if not __exports then return end
__exports.registerPriestSpells = function(OvaleScripts)
    local name = "ovale_priest_spells"
    local desc = "[8.2] Ovale: Priest spells"
    local code = [[
Define(blood_of_the_enemy_0 297108)
# The Heart of Azeroth erupts violently, dealing s1 Shadow damage to enemies within A1 yds. You gain m2 critical strike chance against the targets for 10 seconds?a297122[, and increases your critical hit damage by 297126m for 5 seconds][].
  SpellInfo(blood_of_the_enemy_0 cd=120 duration=10 channel=10)
  # You have a w2 increased chance to be Critically Hit by the caster.
  SpellAddTargetDebuff(blood_of_the_enemy_0 blood_of_the_enemy_0=1)
Define(blood_of_the_enemy_1 297969)
# Infuse your Heart of Azeroth with Blood of the Enemy.
  SpellInfo(blood_of_the_enemy_1)
Define(blood_of_the_enemy_2 297970)
# Infuse your Heart of Azeroth with Blood of the Enemy.
  SpellInfo(blood_of_the_enemy_2)
Define(blood_of_the_enemy_3 297971)
# Infuse your Heart of Azeroth with Blood of the Enemy.
  SpellInfo(blood_of_the_enemy_3)
Define(blood_of_the_enemy_4 298273)
# The Heart of Azeroth erupts violently, dealing 297108s1 Shadow damage to enemies within 297108A1 yds. You gain 297108m2 critical strike chance against the targets for 10 seconds.
  SpellInfo(blood_of_the_enemy_4 cd=90 duration=15 gcd=0 offgcd=1)
  SpellAddBuff(blood_of_the_enemy_4 blood_of_the_enemy_4=1)
Define(blood_of_the_enemy_5 298277)
# The Heart of Azeroth erupts violently, dealing 297108s1 Shadow damage to enemies within 297108A1 yds. You gain 297108m2 critical strike chance against the targets for 10 seconds, and increases your critical hit damage by 297126m for 5 seconds.
  SpellInfo(blood_of_the_enemy_5 cd=90 duration=15 gcd=0 offgcd=1)
  SpellAddBuff(blood_of_the_enemy_5 blood_of_the_enemy_5=1)
Define(blood_of_the_enemy_6 299039)
# Infuse your Heart of Azeroth with Blood of the Enemy.
  SpellInfo(blood_of_the_enemy_6)
Define(bloodlust 2825)
# Increases Haste by (25 of Spell Power) for all party and raid members for 40 seconds.rnrnAllies receiving this effect will become Sated and unable to benefit from Bloodlust or Time Warp again for 600 seconds.
  SpellInfo(bloodlust cd=300 duration=40 channel=40 gcd=0 offgcd=1)
  # Haste increased by s1.
  SpellAddBuff(bloodlust bloodlust=1)
Define(chorus_of_insanity 279572)
# When Voidform ends, gain s1 Critical Strike for each stack of Voidform. This effect decays every 279572t3 sec.
  SpellInfo(chorus_of_insanity duration=120 max_stacks=100 gcd=0 offgcd=1 tick=1)
  # Critical Strike increased by w1.
  SpellAddBuff(chorus_of_insanity chorus_of_insanity=1)

Define(dark_ascension 280711)
# Immediately activates a new Voidform, then releases an explosive blast of pure void energy, causing (95 of Spell Power)*2 Shadow damage to all enemies within a1 yds of your target.rnrn|cFFFFFFFFGenerates s2/100 Insanity.|r
  SpellInfo(dark_ascension cd=60 talent=dark_ascension_talent)
Define(dark_void 263346)
# Unleashes an explosion of dark energy around the target, dealing (100 of Spell Power) Shadow damage and applying Shadow Word: Pain to all nearby enemies.rnrn|cFFFFFFFFGenerates s2/100 Insanity.|r
  SpellInfo(dark_void cd=30 insanity=-3000 talent=dark_void_talent)
Define(focused_azerite_beam_0 295258)
# Focus excess Azerite energy into the Heart of Azeroth, then expel that energy outward, dealing m1*10 Fire damage to all enemies in front of you over 3 seconds.?a295263[ Castable while moving.][]
  SpellInfo(focused_azerite_beam_0 cd=90 duration=3 channel=3 tick=0.33)
  SpellAddBuff(focused_azerite_beam_0 focused_azerite_beam_0=1)
  SpellAddBuff(focused_azerite_beam_0 focused_azerite_beam_1=1)
Define(focused_azerite_beam_1 295261)
# Focus excess Azerite energy into the Heart of Azeroth, then expel that energy outward, dealing m1*10 Fire damage to all enemies in front of you over 3 seconds.?a295263[ Castable while moving.][]
  SpellInfo(focused_azerite_beam_1 cd=90)
Define(focused_azerite_beam_2 299336)
# Focus excess Azerite energy into the Heart of Azeroth, then expel that energy outward, dealing m1*10 Fire damage to all enemies in front of you over 3 seconds.
  SpellInfo(focused_azerite_beam_2 cd=90 duration=3 channel=3 tick=0.33)
  SpellAddBuff(focused_azerite_beam_2 focused_azerite_beam_0=1)
  SpellAddBuff(focused_azerite_beam_2 focused_azerite_beam_1=1)
Define(focused_azerite_beam_3 299338)
# Focus excess Azerite energy into the Heart of Azeroth, then expel that energy outward, dealing m1*10 Fire damage to all enemies in front of you over 3 seconds. Castable while moving.
  SpellInfo(focused_azerite_beam_3 cd=90 duration=3 channel=3 tick=0.33)
  SpellAddBuff(focused_azerite_beam_3 focused_azerite_beam_0=1)
  SpellAddBuff(focused_azerite_beam_3 focused_azerite_beam_1=1)
Define(guardian_of_azeroth_0 295840)
# Call upon Azeroth to summon a Guardian of Azeroth for 30 seconds who impales your target with spikes of Azerite every s1/10.1 sec that deal 295834m1*(1+@versadmg) Fire damage.?a295841[ Every 303347t1 sec, the Guardian launches a volley of Azerite Spikes at its target, dealing 295841s1 Fire damage to all nearby enemies.][]?a295843[rnrnEach time the Guardian of Azeroth casts a spell, you gain 295855s1 Haste, stacking up to 295855u times. This effect ends when the Guardian of Azeroth despawns.][]rn
  SpellInfo(guardian_of_azeroth_0 cd=180 duration=30)
  SpellAddBuff(guardian_of_azeroth_0 guardian_of_azeroth_0=1)
Define(guardian_of_azeroth_1 295855)
# Each time the Guardian of Azeroth casts a spell, you gain 295855s1 Haste, stacking up to 295855u times. This effect ends when the Guardian of Azeroth despawns.
  SpellInfo(guardian_of_azeroth_1 duration=60 max_stacks=5 gcd=0 offgcd=1)
  # Haste increased by s1.
  SpellAddBuff(guardian_of_azeroth_1 guardian_of_azeroth_1=1)
Define(guardian_of_azeroth_2 299355)
# Call upon Azeroth to summon a Guardian of Azeroth for 30 seconds who impales your target with spikes of Azerite every 295840s1/10.1 sec that deal 295834m1*(1+@versadmg)*(1+(295836m1/100)) Fire damage. Every 303347t1 sec, the Guardian launches a volley of Azerite Spikes at its target, dealing 295841s1 Fire damage to all nearby enemies.
  SpellInfo(guardian_of_azeroth_2 cd=180 duration=30 gcd=1)
  SpellAddBuff(guardian_of_azeroth_2 guardian_of_azeroth_2=1)
Define(guardian_of_azeroth_3 299358)
# Call upon Azeroth to summon a Guardian of Azeroth for 30 seconds who impales your target with spikes of Azerite every 295840s1/10.1 sec that deal 295834m1*(1+@versadmg)*(1+(295836m1/100)) Fire damage. Every 303347t1 sec, the Guardian launches a volley of Azerite Spikes at its target, dealing 295841s1 Fire damage to all nearby enemies.rnrnEach time the Guardian of Azeroth casts a spell, you gain 295855s1 Haste, stacking up to 295855u times. This effect ends when the Guardian of Azeroth despawns.
  SpellInfo(guardian_of_azeroth_3 cd=180 duration=20 gcd=1)
  SpellAddBuff(guardian_of_azeroth_3 guardian_of_azeroth_3=1)
Define(guardian_of_azeroth_4 300091)
# Call upon Azeroth to summon a Guardian of Azeroth to aid you in combat for 30 seconds.
  SpellInfo(guardian_of_azeroth_4 cd=300 duration=30 gcd=1)
Define(guardian_of_azeroth_5 303347)
  SpellInfo(guardian_of_azeroth_5 gcd=0 offgcd=1 tick=8)

Define(mind_blast 8092)
# Blasts the target's mind for (120 of Spell Power) Shadow damage.?a185916[rnrn|cFFFFFFFFGenerates /100;s2 Insanity.|r][]
  SpellInfo(mind_blast cd=7.5 insanity=-1200)
Define(mind_bomb 205369)
# Inflicts the target with a Mind Bomb.rnrnAfter 2 seconds or if the target dies, it unleashes a psychic explosion, disorienting all enemies within 226943A1 yds of the target for 6 seconds.
  SpellInfo(mind_bomb cd=30 duration=2 talent=mind_bomb_talent)
  # About to unleash a psychic explosion, disorienting all nearby enemies.
  SpellAddTargetDebuff(mind_bomb mind_bomb=1)
Define(mind_flay 15407)
# Assaults the target's mind with Shadow energy, causing o1 Shadow damage over 3 seconds and slowing their movement speed by s2.?a185916[rnrn|cFFFFFFFFGenerates s4*m3/100 Insanity over the duration.|r][]
  SpellInfo(mind_flay duration=3 channel=3 tick=0.75)
  # Movement speed slowed by s2 and taking Shadow damage every t1 sec.
  SpellAddBuff(mind_flay mind_flay=1)
  # Movement speed slowed by s2 and taking Shadow damage every t1 sec.
  SpellAddTargetDebuff(mind_flay mind_flay=1)
Define(mind_sear 48045)
# Corrosive shadow energy radiates from the target, dealing 49821m2*s2 Shadow damage over 3 seconds to all enemies within 49821a2 yards of the target.rnrn|cFFFFFFFFGenerates s2*208232m1/100 Insanity over the duration per target hit.|r
  SpellInfo(mind_sear duration=3 channel=3 tick=0.75)
  # Causing Shadow damage to all targets within 49821a2 yards every t1 sec.
  SpellAddBuff(mind_sear mind_sear=1)

Define(mindbender 200174)
# Summons a Mindbender to attack the target for 15 seconds.rnrn|cFFFFFFFFGenerates 200010s1/100 Insanity each time the Mindbender attacks.|r
  SpellInfo(mindbender cd=60 duration=15 talent=mindbender_talent)

Define(purifying_blast_0 295337)
# Call down a purifying beam upon the target area, dealing 295293s3*(1+@versadmg)*s2 Fire damage over 6 seconds.?a295364[ Has a low chance to immediately annihilate any specimen deemed unworthy by MOTHER.][]?a295352[rnrnWhen an enemy dies within the beam, your damage is increased by 295354s1 for 8 seconds.][]rnrnAny Aberration struck by the beam is stunned for 3 seconds.
  SpellInfo(purifying_blast_0 cd=60 duration=6)
Define(purifying_blast_1 295338)
# Call down a purifying beam upon the target area, dealing 295293s3*(1+@versadmg)*s2 Fire damage over 6 seconds.?a295364[ Has a low chance to immediately annihilate any specimen deemed unworthy by MOTHER.][]?a295352[rnrnWhen an enemy dies within the beam, your damage is increased by 295354s1 for 8 seconds.][]rnrnAny Aberration struck by the beam is stunned for 3 seconds.
  SpellInfo(purifying_blast_1 channel=0 gcd=0 offgcd=1)
Define(purifying_blast_2 295354)
# When an enemy dies within the beam, your damage is increased by 295354s1 for 8 seconds.
  SpellInfo(purifying_blast_2 duration=8 gcd=0 offgcd=1)
  # Damage dealt increased by s1.
  SpellAddBuff(purifying_blast_2 purifying_blast_2=1)
Define(purifying_blast_3 295366)
# Call down a purifying beam upon the target area, dealing 295293s3*(1+@versadmg)*s2 Fire damage over 6 seconds.?a295364[ Has a low chance to immediately annihilate any specimen deemed unworthy by MOTHER.][]?a295352[rnrnWhen an enemy dies within the beam, your damage is increased by 295354s1 for 8 seconds.][]rnrnAny Aberration struck by the beam is stunned for 3 seconds.
  SpellInfo(purifying_blast_3 duration=3 gcd=0 offgcd=1)
  # Stunned.
  SpellAddTargetDebuff(purifying_blast_3 purifying_blast_3=1)
Define(purifying_blast_4 299345)
# Call down a purifying beam upon the target area, dealing 295293s3*(1+@versadmg)*s2 Fire damage over 6 seconds. Has a low chance to immediately annihilate any specimen deemed unworthy by MOTHER.?a295352[rnrnWhen an enemy dies within the beam, your damage is increased by 295354s1 for 8 seconds.][]rnrnAny Aberration struck by the beam is stunned for 3 seconds.
  SpellInfo(purifying_blast_4 cd=60 duration=6 channel=6 gcd=1)
Define(purifying_blast_5 299347)
# Call down a purifying beam upon the target area, dealing 295293s3*(1+@versadmg)*s2 Fire damage over 6 seconds. Has a low chance to immediately annihilate any specimen deemed unworthy by MOTHER.rnrnWhen an enemy dies within the beam, your damage is increased by 295354s1 for 8 seconds.rnrnAny Aberration struck by the beam is stunned for 3 seconds.
  SpellInfo(purifying_blast_5 cd=60 duration=6 gcd=1)
Define(quaking_palm 107079)
# Strikes the target with lightning speed, incapacitating them for 4 seconds, and turns off your attack.
  SpellInfo(quaking_palm cd=120 duration=4 gcd=1)
  # Incapacitated.
  SpellAddTargetDebuff(quaking_palm quaking_palm=1)
Define(reaping_flames_0 310690)
# Burn your target with a bolt of Azerite, dealing 310712s3 Fire damage. If the target has less than s2 health?a310705[ or more than 310705s1 health][], the cooldown is reduced by s3 sec.?a310710[rnrnIf Reaping Flames kills an enemy, its cooldown is lowered to 310710s2 sec and it will deal 310710s1 increased damage on its next use.][]
  SpellInfo(reaping_flames_0 cd=45 channel=0)
Define(reaping_flames_1 311194)
# Burn your target with a bolt of Azerite, dealing 310712s3 Fire damage. If the target has less than s2 health or more than 310705s1 health, the cooldown is reduced by m3 sec.
  SpellInfo(reaping_flames_1 cd=45 channel=0)
Define(reaping_flames_2 311195)
# Burn your target with a bolt of Azerite, dealing 310712s3 Fire damage. If the target has less than s2 health or more than 310705s1 health, the cooldown is reduced by m3 sec.rnrnIf Reaping Flames kills an enemy, its cooldown is lowered to 310710s2 sec and it will deal 310710s1 increased damage on its next use.
  SpellInfo(reaping_flames_2 cd=45 channel=0)
Define(reaping_flames_3 311202)
# Burn your target with a bolt of Azerite, dealing 310712s3 Fire damage. If the target has less than s2 health?a310705[ or more than 310705s1 health][], the cooldown is reduced by s3 sec.?a310710[rnrnIf Reaping Flames kills an enemy, its cooldown is lowered to 310710s2 sec and it will deal 310710s1 increased damage on its next use.][]
  SpellInfo(reaping_flames_3 duration=30 gcd=0 offgcd=1)
  # Damage of next Reaping Flames increased by w1.
  SpellAddBuff(reaping_flames_3 reaping_flames_3=1)
Define(shadow_crash 205385)
# Hurl a bolt of slow-moving Shadow energy at the destination, dealing (125 of Spell Power) Shadow damage to all targets within 205386A1 yards.rnrn|cFFFFFFFFGenerates /100;s2 Insanity.|r
  SpellInfo(shadow_crash cd=20 insanity=-2000 talent=shadow_crash_talent)

Define(shadow_word_death 32379)
# A word of dark binding that inflicts (187.5 of Spell Power) Shadow damage to the target. Only usable on enemies that have less than s2 health.rnrn|cFFFFFFFFGenerates s3 Insanity, or s4 Insanity if the target dies.|r
  SpellInfo(shadow_word_death cd=9 talent=shadow_word_death_talent)
Define(shadow_word_pain 589)
# A word of darkness that causes (16.5 of Spell Power) Shadow damage instantly, and an additional o2 Shadow damage over 16 seconds.?a185916[rnrn|cFFFFFFFFGenerates m3/100 Insanity.|r][]
  SpellInfo(shadow_word_pain duration=16 insanity=-400 tick=2)
  # Suffering w2 Shadow damage every t2 sec.
  SpellAddTargetDebuff(shadow_word_pain shadow_word_pain=1)
Define(shadowform 232698)
# Assume a Shadowform, increasing your spell damage dealt by s1.
  SpellInfo(shadowform)
  # Spell damage dealt increased by s1.
  SpellAddBuff(shadowform shadowform=1)
  # Spell damage dealt increased by s1.
  SpellAddTargetDebuff(shadowform shadowform=1)
Define(silence 15487)
# Silences the target, preventing them from casting spells for 4 seconds. Against non-players, also interrupts spellcasting and prevents any spell in that school from being cast for 4 seconds.
# Rank 1: Silences an enemy preventing it from casting spells for 6 seconds.
  SpellInfo(silence cd=45 duration=4 gcd=0 offgcd=1)
  # Silenced.
  SpellAddTargetDebuff(silence silence=1)
Define(surrender_to_madness 193223)
# All your Insanity-generating abilities generate s1 more Insanity and you can cast while moving for 60 seconds.rnrnThen, you take damage equal to s3 of your maximum health and cannot generate Insanity for 15 seconds.
  SpellInfo(surrender_to_madness cd=180 duration=60 talent=surrender_to_madness_talent)
  # Generating s1 more Insanity.
  SpellAddBuff(surrender_to_madness surrender_to_madness=1)
Define(the_unbound_force_0 298452)
# Unleash the forces within the Heart of Azeroth, causing shards of Azerite to strike your target for (298407s3*((2 seconds/t)+1)+298407s3) Fire damage over 2 seconds. This damage is increased by s2 if it critically strikes.?a298456[rnrnEach time The Unbound Force causes a critical strike, it immediately strikes the target with an additional Azerite shard, up to a maximum of 298456m2.][]
  SpellInfo(the_unbound_force_0 cd=60 duration=2 channel=2 tick=0.33)
  SpellAddBuff(the_unbound_force_0 the_unbound_force_0=1)
  SpellAddTargetDebuff(the_unbound_force_0 the_unbound_force_0=1)
Define(the_unbound_force_1 298453)
# Unleash the forces within the Heart of Azeroth, causing shards of Azerite to strike your target for (298407s3*((2 seconds/t)+1)+298407s3) Fire damage over 2 seconds. This damage is increased by s2 if it critically strikes.?a298456[rnrnEach time The Unbound Force causes a critical strike, it immediately strikes the target with an additional Azerite shard, up to a maximum of 298456m2.][]
  SpellInfo(the_unbound_force_1 gcd=0 offgcd=1)
Define(the_unbound_force_2 299321)
# Infuse your Heart of Azeroth with The Unbound Force.
  SpellInfo(the_unbound_force_2)
Define(the_unbound_force_3 299322)
# Infuse your Heart of Azeroth with The Unbound Force.
  SpellInfo(the_unbound_force_3)
Define(the_unbound_force_4 299323)
# Infuse your Heart of Azeroth with The Unbound Force.
  SpellInfo(the_unbound_force_4)
Define(the_unbound_force_5 299324)
# Infuse your Heart of Azeroth with The Unbound Force.
  SpellInfo(the_unbound_force_5)
Define(the_unbound_force_6 299376)
# Unleash the forces within the Heart of Azeroth, causing shards of Azerite to strike your target for (298407s3*((2 seconds/298452t)+1)+298407s3) Fire damage over 2 seconds. This damage is increased by s2 if it critically strikes.
  SpellInfo(the_unbound_force_6 cd=45 duration=2 channel=2 gcd=1 tick=0.33)
  SpellAddBuff(the_unbound_force_6 the_unbound_force_6=1)
  SpellAddTargetDebuff(the_unbound_force_6 the_unbound_force_6=1)
Define(the_unbound_force_7 299378)
# Unleash the forces within the Heart of Azeroth, causing shards of Azerite to strike your target for (298407s3*((2 seconds/298452t)+1)+298407s3) Fire damage over 2 seconds. This damage is increased by s2 if it critically strikes.rnrnEach time The Unbound Force causes a critical strike, it immediately strikes the target with an additional Azerite shard, up to a maximum of 298456m2.
  SpellInfo(the_unbound_force_7 cd=45 duration=2 channel=2 gcd=1 tick=0.33)
  SpellAddBuff(the_unbound_force_7 the_unbound_force_7=1)
  SpellAddTargetDebuff(the_unbound_force_7 the_unbound_force_7=1)
Define(vampiric_touch 34914)
  SpellInfo(vampiric_touch insanity=-6)
  SpellRequire(vampiric_touch insanity_percent 200=buff,surrender_to_madness_buff)
  SpellAddTargetDebuff(vampiric_touch vampiric_touch_debuff=1)
  SpellAddTargetDebuff(vampiric_touch shadow_word_pain_debuff=1 talent=misery_talent)
Define(vampiric_touch_debuff 34914)
  SpellInfo(vampiric_touch_debuff duration=21 haste=spell tick=3)
# A touch of darkness that causes 34914o2 Shadow damage over 21 seconds, and heals you for e2*100 of damage dealt.rnrnIf Vampiric Touch is dispelled, the dispeller flees in Horror for 3 seconds.rnrn|cFFFFFFFFGenerates m3/100 Insanity.|r
  # SpellInfo(vampiric_touch duration=21 insanity=-600 tick=3)
  # Suffering w2 Shadow damage every t2 sec.
  # SpellAddTargetDebuff(vampiric_touch vampiric_touch=1)
Define(void_bolt_0 228266)
# For the duration of Voidform, your Void Eruption ability is replaced by Void Bolt:rnrn@spelltooltip205448
  SpellInfo(void_bolt_0 channel=0 gcd=0 offgcd=1)
  SpellAddBuff(void_bolt_0 void_bolt_0=1)
Define(void_bolt_1 231688)
# Void Bolt extends the duration of your Shadow Word: Pain and Vampiric Touch on all nearby targets by @switch<s2>[s1/1000][s1/1000.1] sec.
  SpellInfo(void_bolt_1 channel=0 gcd=0 offgcd=1)
  SpellAddBuff(void_bolt_1 void_bolt_1=1)
Define(void_eruption 228260)
# Releases an explosive blast of pure void energy, activating Voidform and causing (95 of Spell Power)*2 Shadow damage to all enemies within a1 yds of your target.rnrnDuring Voidform, this ability is replaced by Void Bolt.rnrn|cFFFFFFFFRequires C/100 Insanity to activate.|r
  SpellInfo(void_eruption insanity=9000)
Define(void_torrent 263165)
# Channel a torrent of void energy into the target, dealing o Shadow damage over 4 seconds.rnrnInsanity does not drain during this channel.rnrn|cFFFFFFFFGenerates 289577s1*289577s2/100 Insanity over the duration.|r
  SpellInfo(void_torrent cd=45 duration=4 channel=4 tick=1 talent=void_torrent_talent)
  # Dealing s1 Shadow damage to the target every t1 sec.rnrnInsanity drain temporarily stopped.
  SpellAddBuff(void_torrent void_torrent=1)
  # Dealing s1 Shadow damage to the target every t1 sec.rnrnInsanity drain temporarily stopped.
  SpellAddTargetDebuff(void_torrent void_torrent=1)
Define(voidform_shadow 228264)
# Activated by casting Void Eruption. Twists your Shadowform with the powers of the Void, increasing spell damage you deal by 194249s1?s8092[, reducing the cooldown on Mind Blast by 194249m6/-1000.1 sec,][] and granting an additional s2/10.1 Haste every 194249t5 sec.rnrnYour Insanity will drain increasingly fast until it reaches 0 and Voidform ends.
  SpellInfo(voidform_shadow channel=0 gcd=0 offgcd=1)
  SpellAddBuff(voidform_shadow voidform_shadow=1)
Define(war_stomp 20549)
# Stuns up to i enemies within A1 yds for 2 seconds.
  SpellInfo(war_stomp cd=90 duration=2 gcd=0 offgcd=1)
  # Stunned.
  SpellAddTargetDebuff(war_stomp war_stomp=1)
SpellList(blood_of_the_enemy blood_of_the_enemy_0 blood_of_the_enemy_1 blood_of_the_enemy_2 blood_of_the_enemy_3 blood_of_the_enemy_4 blood_of_the_enemy_5 blood_of_the_enemy_6)
SpellList(focused_azerite_beam focused_azerite_beam_0 focused_azerite_beam_1 focused_azerite_beam_2 focused_azerite_beam_3)
SpellList(guardian_of_azeroth guardian_of_azeroth_0 guardian_of_azeroth_1 guardian_of_azeroth_2 guardian_of_azeroth_3 guardian_of_azeroth_4 guardian_of_azeroth_5)
SpellList(purifying_blast purifying_blast_0 purifying_blast_1 purifying_blast_2 purifying_blast_3 purifying_blast_4 purifying_blast_5)
SpellList(reaping_flames reaping_flames_0 reaping_flames_1 reaping_flames_2 reaping_flames_3)
SpellList(the_unbound_force the_unbound_force_0 the_unbound_force_1 the_unbound_force_2 the_unbound_force_3 the_unbound_force_4 the_unbound_force_5 the_unbound_force_6 the_unbound_force_7)
SpellList(void_bolt void_bolt_0 void_bolt_1)
Define(dark_ascension_talent 20) #21978
# Immediately activates a new Voidform, then releases an explosive blast of pure void energy, causing (95 of Spell Power)*2 Shadow damage to all enemies within a1 yds of your target.rnrn|cFFFFFFFFGenerates s2/100 Insanity.|r
Define(dark_void_talent 9) #23127
# Unleashes an explosion of dark energy around the target, dealing (100 of Spell Power) Shadow damage and applying Shadow Word: Pain to all nearby enemies.rnrn|cFFFFFFFFGenerates s2/100 Insanity.|r
Define(mind_bomb_talent 11) #23375
# Inflicts the target with a Mind Bomb.rnrnAfter 2 seconds or if the target dies, it unleashes a psychic explosion, disorienting all enemies within 226943A1 yds of the target for 6 seconds.
Define(mindbender_talent 17) #21719
# Summons a Mindbender to attack the target for 15 seconds.rnrn|cFFFFFFFFGenerates 200010s1/100 Insanity each time the Mindbender attacks.|r
Define(misery_talent 8) #23126
# Vampiric Touch also applies Shadow Word: Pain to the target.
Define(shadow_crash_talent 15) #21755
# Hurl a bolt of slow-moving Shadow energy at the destination, dealing (125 of Spell Power) Shadow damage to all targets within 205386A1 yards.rnrn|cFFFFFFFFGenerates /100;s2 Insanity.|r
Define(shadow_word_death_talent 14) #22311
# A word of dark binding that inflicts (187.5 of Spell Power) Shadow damage to the target. Only usable on enemies that have less than s2 health.rnrn|cFFFFFFFFGenerates s3 Insanity, or s4 Insanity if the target dies.|r
Define(shadow_word_void_talent 3) #22314
# Blasts the target with a word of void for (130 of Spell Power) Shadow damage.?a185916[rnrn|cFFFFFFFFGenerates /100;s2 Insanity.|r][]
Define(surrender_to_madness_talent 21) #21979
# All your Insanity-generating abilities generate s1 more Insanity and you can cast while moving for 60 seconds.rnrnThen, you take damage equal to s3 of your maximum health and cannot generate Insanity for 15 seconds.
Define(void_torrent_talent 18) #21720
# Channel a torrent of void energy into the target, dealing o Shadow damage over 4 seconds.rnrnInsanity does not drain during this channel.rnrn|cFFFFFFFFGenerates 289577s1*289577s2/100 Insanity over the duration.|r
Define(unbridled_fury_item 169299)
Define(chorus_of_insanity_trait 278661)
Define(death_throes_trait 278659)
Define(searing_dialogue_trait 272788)
Define(spiteful_apparitions_trait 277682)
Define(thought_harvester_trait 288340)
Define(whispers_of_the_damned_trait 275722)
    ]]
    code = code .. [[
# Priest spells and functions.

# Spells

	SpellInfo(dark_ascension insanity=-50 cd=60)
	SpellAddBuff(dark_ascension voidform_buff=1)

	SpellInfo(dark_void cd=30 insanity=-30)
	SpellAddTargetDebuff(dark_void shadow_word_pain_debuff=1)
Define(dispel_magic 528)
Define(dispersion 47585)
	SpellInfo(dispersion cd=120)
	SpellAddBuff(dispersion dispersion_buff=1)
Define(dispersion_buff 47585)
	SpellInfo(dispersion_buff duration=6)

	SpellInfo(divine_star cd=15)
Define(fade 586)
	SpellInfo(fade cd=30)
Define(insanity_drain_stacks_buff 194249)
Define(leap_of_faith 73325)
	SpellInfo(leap_of_faith cd=90)
Define(levitate 1706)
Define(mass_dispel 32375)
	SpellInfo(mass_dispel cd=45)

	SpellInfo(mind_blast cd=7.5 cd_haste=spell insanity=-12 charges=1)
	SpellInfo(mind_blast replaced_by=shadow_word_void talent=shadow_word_void_talent)
	SpellInfo(mind_blast insanity_percent=120 talent=fortress_of_the_mind_talent)
	SpellRequire(mind_blast insanity_percent 200=buff,surrender_to_madness_buff)
	SpellRequire(mind_blast cd 6=buff,voidform_buff)
	SpellAddBuff(mind_blast shadowy_insight_buff=0 talent=shadowy_insight_talent)

	SpellInfo(mind_bomb cd=30)
Define(mind_bomb_debuff 205369)
	SpellInfo(mind_bomb_debuff duration=2)
Define(mind_control 605)

	SpellInfo(mind_flay channel=3 insanity=-4 haste=spell)
	SpellInfo(mind_flay insanity_percent=120 talent=fortress_of_the_mind_talent)
	SpellRequire(mind_flay insanity_percent 200=buff,surrender_to_madness_buff)

	SpellInfo(mind_sear channel=3 haste=spell)
Define(mind_vision 2096)
Define(smite 585)
Define(mindbender_discipline 123040)
	SpellInfo(mindbender_discipline cd=60 tag=main)

    SpellInfo(mindbender_shadow cd=60 tag=main)
Define(penance 47540)
	SpellInfo(penance cd=9 channel=2)
Define(power_word_fortitude 21562)
  SpellAddBuff(power_word_fortitude power_word_fortitude_buff=1)
Define(power_word_fortitude_buff 21562)
  SpellInfo(power_word_fortitude_buff duration=3600)
Define(power_word_shield 17)
	SpellInfo(power_word_shield cd=6 cd_haste=spell)
	SpellInfo(power_word_shield cd=0 specialization=discipline)
Define(power_word_solace 129250)
	SpellInfo(power_word_solace cd=12 cd_haste=spell)
Define(psychic_horror 64044)
	SpellInfo(psychic_horror cd=45)
Define(psychic_scream 8122)
	SpellInfo(psychic_scream cd=60)
	SpellInfo(psychic_scream replaced_by=mind_bomb talent=mind_bomb_talent)
Define(purify_disease 213634)
	SpellInfo(purify_disease cd=8)
Define(purge_the_wicked 204197)
	SpellInfo(purge_the_wicked replaced_by=shadow_word_pain talent=purge_the_wicked_talent specialization=discipline)
	SpellAddTargetDebuff(purge_the_wicked purge_the_wicked_debuff=1)
Define(purge_the_wicked_debuff 204213)
	SpellInfo(purge_the_wicked_debuff duration=20 haste=spell tick=2)
Define(rapture 47536)
	SpellInfo(rapture cd=90)
Define(rapture_buff 47536)
	SpellInfo(rapture_buff duration=10)
Define(resurrection 2006)
Define(schism 214621)
	SpellInfo(schism cd=24)
	SpellAddTargetDebuff(schism schism_debuff=1)
Define(schism_debuff 214621)
	SpellInfo(schism_debuff duration=9)
Define(shackle_undead 9484)

	SpellInfo(shadow_crash cd=20 insanity=-20 tag=shortcd)
	SpellRequire(shadow_crash insanity_percent 200=buff,surrender_to_madness_buff)
Define(shadow_mend 186263)

	SpellInfo(shadow_word_death target_health_pct=20 insanity=-15 cd=9 charges=2)
	SpellRequire(shadow_word_death insanity_percent 200=buff,surrender_to_madness_buff)

	SpellInfo(shadow_word_pain insanity=-4)
	SpellInfo(shadow_word_pain replaced_by=purge_the_wicked talent=!purge_the_wicked_talent specialization=discipline)
	SpellAddTargetDebuff(shadow_word_pain shadow_word_pain_debuff=1)
	SpellRequire(shadow_word_pain insanity_percent 200=buff,surrender_to_madness_buff)
Define(shadow_word_pain_debuff 589)
	SpellInfo(shadow_word_pain_debuff duration=16 haste=spell tick=2)
Define(shadow_word_void 205351)
    SpellInfo(shadow_word_void cd=9 insanity=-15 talent=shadow_word_void_talent)
	SpellInfo(shadow_word_void cd=9 charges=2 insanity=-15 tag=main)
	SpellInfo(shadow_word_void replaced_by=mind_blast talent=!shadow_word_void_talent)
	SpellRequire(shadow_word_void cd 7.5=buff,voidform_buff)
	SpellRequire(shadow_word_void insanity_percent 200=buff,surrender_to_madness_buff)
Define(shadowfiend 34433)
	SpellInfo(shadowfiend cd=180)
	SpellInfo(shadowfiend replaced_by=mindbender_discipline talent=disc_mindbender_talent specialization=discipline)
    SpellInfo(shadowfiend replaced_by=mindbender_shadow talent=shadow_mindbender_talent specialization=shadow)

    SpellRequire(shadowform unusable 1=buff,voidform_buff)
Define(shadowform_buff 232698)
Define(shadowy_insight_buff 124430)
	SpellInfo(shadowy_insight_buff duration=12)

	SpellInfo(silence cd=45 gcd=0 interrupt=1)


	SpellInfo(surrender_to_madness cd=240)
	SpellAddBuff(surrender_to_madness surrender_to_madness_buff=1)
Define(surrender_to_madness_buff 193223)
	SpellInfo(surrender_to_madness_buff duration=60)
Define(vampiric_embrace 15286)
	SpellInfo(vampiric_embrace cd=120)
	SpellAddBuff(vampiric_embrace vampiric_embrace_buff=1)
Define(vampiric_embrace_buff 15286)
	SpellInfo(vampiric_embrace_buff duration=15)
Define(void_bolt 205448)
	SpellInfo(void_bolt cd=4.5 insanity=-16 cd_haste=spell)
	SpellRequire(void_bolt unusable 1=buff,!voidform_buff)
	SpellRequire(void_bolt insanity_percent 200=buff,surrender_to_madness_buff)
	SpellAddTargetDebuff(void_bolt shadow_word_pain_debuff=refresh)
	SpellAddTargetDebuff(void_bolt vampiric_touch_debuff=refresh)

	SpellInfo(void_eruption insanity=90 tag=main)
	SpellInfo(void_eruption insanity=60 talent=legacy_of_the_void_talent)
	SpellAddBuff(void_eruption voidform_buff=1)
	SpellRequire(void_eruption unusable 1=buff,voidform_buff)
	SpellRequire(void_eruption replace void_bolt=buff,voidform_buff)

	SpellInfo(void_torrent cd=60 tag=main unusable=1)
	SpellRequire(void_torrent unusable 0=buff,voidform_buff)
Define(void_torrent_buff 263165) # TODO Insanity does not drain during this buff
	SpellInfo(void_torrent_buff duration=4)
Define(voidform 228264)
Define(voidform_buff 194249)

AddFunction CurrentInsanityDrain {
	if BuffPresent(dispersion_buff) 0
	if BuffPresent(void_torrent_buff) 0 # for some reason, this does not work as expected
	if BuffPresent(voidform_buff) BuffStacks(voidform_buff)/2 + 9
	0
}

# Azerite Traits
Define(thought_harvester_trait 273319)
	Define(harvested_thoughts_buff 273321)

#Talents
Define(apotheosis_talent 20)
Define(dark_ascension_talent 20)
Define(dark_void_talent 9)
Define(disc_mindbender_talent 8)
Define(divine_star_talent 17)
Define(fortress_of_the_mind_talent 1)
Define(halo_talent 18)
Define(legacy_of_the_void_talent 19)
Define(mind_bomb_talent 11)
Define(misery_talent 8)
Define(purge_the_wicked_talent 16)
Define(shadow_crash_talent 15)
Define(shadow_mindbender_talent 17)
Define(shadow_word_death_talent 14)
Define(shadow_word_void_talent 3)
Define(shadowy_insight_talent 2)
Define(surrender_to_madness_talent 21)
Define(void_torrent_talent 18)
]]
    OvaleScripts:RegisterScript("PRIEST", nil, name, desc, code, "include")
end
