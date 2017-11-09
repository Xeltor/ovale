local LibBabbleCreatureType = LibStub:GetLibrary("LibBabble-creatureType-3.0", true)
local LibRangeCheck = LibStub:GetLibrary("LibRangeCheck-2.0", true)
local __BestAction = LibStub:GetLibrary("ovale/BestAction")
local OvaleBestAction = __BestAction.OvaleBestAction
local __Compile = LibStub:GetLibrary("ovale/Compile")
local OvaleCompile = __Compile.OvaleCompile
local __Condition = LibStub:GetLibrary("ovale/Condition")
local OvaleCondition = __Condition.OvaleCondition
local TestValue = __Condition.TestValue
local Compare = __Condition.Compare
local TestBoolean = __Condition.TestBoolean
local ParseCondition = __Condition.ParseCondition
local __CooldownState = LibStub:GetLibrary("ovale/CooldownState")
local cooldownState = __CooldownState.cooldownState
local __DamageTaken = LibStub:GetLibrary("ovale/DamageTaken")
local OvaleDamageTaken = __DamageTaken.OvaleDamageTaken
local __Data = LibStub:GetLibrary("ovale/Data")
local OvaleData = __Data.OvaleData
local __Equipment = LibStub:GetLibrary("ovale/Equipment")
local OvaleEquipment = __Equipment.OvaleEquipment
local __Future = LibStub:GetLibrary("ovale/Future")
local OvaleFuture = __Future.OvaleFuture
local __GUID = LibStub:GetLibrary("ovale/GUID")
local OvaleGUID = __GUID.OvaleGUID
local __Health = LibStub:GetLibrary("ovale/Health")
local OvaleHealth = __Health.OvaleHealth
local __Power = LibStub:GetLibrary("ovale/Power")
local OvalePower = __Power.OvalePower
local powerState = __Power.powerState
local __Runes = LibStub:GetLibrary("ovale/Runes")
local runesState = __Runes.runesState
local __SpellBook = LibStub:GetLibrary("ovale/SpellBook")
local OvaleSpellBook = __SpellBook.OvaleSpellBook
local __SpellDamage = LibStub:GetLibrary("ovale/SpellDamage")
local OvaleSpellDamage = __SpellDamage.OvaleSpellDamage
local __Artifact = LibStub:GetLibrary("ovale/Artifact")
local OvaleArtifact = __Artifact.OvaleArtifact
local __BossMod = LibStub:GetLibrary("ovale/BossMod")
local OvaleBossMod = __BossMod.OvaleBossMod
local __Ovale = LibStub:GetLibrary("ovale/Ovale")
local Ovale = __Ovale.Ovale
local __PaperDoll = LibStub:GetLibrary("ovale/PaperDoll")
local paperDollState = __PaperDoll.paperDollState
local __Aura = LibStub:GetLibrary("ovale/Aura")
local auraState = __Aura.auraState
local __ComboPoints = LibStub:GetLibrary("ovale/ComboPoints")
local comboPointsState = __ComboPoints.comboPointsState
local __WildImps = LibStub:GetLibrary("ovale/WildImps")
local wildImpsState = __WildImps.wildImpsState
local __Enemies = LibStub:GetLibrary("ovale/Enemies")
local EnemiesState = __Enemies.EnemiesState
local __Totem = LibStub:GetLibrary("ovale/Totem")
local totemState = __Totem.totemState
local __DemonHunterSigils = LibStub:GetLibrary("ovale/DemonHunterSigils")
local sigilState = __DemonHunterSigils.sigilState
local __DemonHunterSoulFragments = LibStub:GetLibrary("ovale/DemonHunterSoulFragments")
local demonHunterSoulFragmentsState = __DemonHunterSoulFragments.demonHunterSoulFragmentsState
local __Frame = LibStub:GetLibrary("ovale/Frame")
local OvaleFrameModule = __Frame.OvaleFrameModule
local __LastSpell = LibStub:GetLibrary("ovale/LastSpell")
local lastSpell = __LastSpell.lastSpell
local __DataState = LibStub:GetLibrary("ovale/DataState")
local dataState = __DataState.dataState
local __StanceState = LibStub:GetLibrary("ovale/StanceState")
local stanceState = __StanceState.stanceState
local __SpellBookState = LibStub:GetLibrary("ovale/SpellBookState")
local spellBookState = __SpellBookState.spellBookState
local __FutureState = LibStub:GetLibrary("ovale/FutureState")
local futureState = __FutureState.futureState
local ipairs = ipairs
local pairs = pairs
local type = type
local GetBuildInfo = GetBuildInfo
local GetItemCooldown = GetItemCooldown
local GetItemCount = GetItemCount
local GetNumTrackingTypes = GetNumTrackingTypes
local GetTime = GetTime
local GetTrackingInfo = GetTrackingInfo
local GetUnitSpeed = GetUnitSpeed
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local HasFullControl = HasFullControl
local IsStealthed = IsStealthed
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitCreatureFamily = UnitCreatureFamily
local UnitCreatureType = UnitCreatureType
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local UnitExists = UnitExists
local UnitInRaid = UnitInRaid
local UnitIsDead = UnitIsDead
local UnitIsFriend = UnitIsFriend
local UnitIsPVP = UnitIsPVP
local UnitIsUnit = UnitIsUnit
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitRace = UnitRace
local UnitStagger = UnitStagger
local huge = math.huge
local __AST = LibStub:GetLibrary("ovale/AST")
local isValueNode = __AST.isValueNode
local INFINITY = huge
local BossArmorDamageReduction = function(target, state)
    local armor = 24835
    local constant = 4037.5 * paperDollState.level - 317117.5
    if constant < 0 then
        constant = 0
    end
    return armor / (armor + constant)
end

local ComputeParameter = function(spellId, paramName, state, atTime)
    local si = OvaleData:GetSpellInfo(spellId)
    if si and si[paramName] then
        local name = si[paramName]
        local node = OvaleCompile:GetFunctionNode(name)
        if node then
            local _, element = OvaleBestAction:Compute(node.child[1], state, atTime)
            if element and isValueNode(element) then
                local value = element.value + (state.currentTime - element.origin) * element.rate
                return value
            end
        else
            return si[paramName]
        end
    end
    return nil
end

local GetHastedTime = function(seconds, haste, state)
    seconds = seconds or 0
    local multiplier = paperDollState:GetHasteMultiplier(haste)
    return seconds / multiplier
end

do
    local ArmorSetBonus = function(positionalParams, namedParams, state, atTime)
        local armorSet, count = positionalParams[1], positionalParams[2]
        local value = (OvaleEquipment:GetArmorSetCount(armorSet) >= count) and 1 or 0
        return 0, INFINITY, value, 0, 0
    end

    OvaleCondition:RegisterCondition("armorsetbonus", false, ArmorSetBonus)
end
do
    local ArmorSetParts = function(positionalParams, namedParams, state, atTime)
        local armorSet, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = OvaleEquipment:GetArmorSetCount(armorSet)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("armorsetparts", false, ArmorSetParts)
end
do
    local ArtifactTraitRank = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = OvaleArtifact:TraitRank(spellId)
        return Compare(value, comparator, limit)
    end

    local HasArtifactTrait = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local value = OvaleArtifact:HasTrait(spellId)
        return TestBoolean(value, yesno)
    end

    OvaleCondition:RegisterCondition("hasartifacttrait", false, HasArtifactTrait)
    OvaleCondition:RegisterCondition("artifacttraitrank", false, ArtifactTraitRank)
end
do
    local BaseDuration = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value
        if (OvaleData.buffSpellList[auraId]) then
            local spellList = OvaleData.buffSpellList[auraId]
            for id in pairs(spellList) do
                value = OvaleData:GetBaseDuration(id, state)
                if value ~= huge then
                    break
                end
            end
        else
            value = OvaleData:GetBaseDuration(auraId, state)
        end
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("baseduration", false, BaseDuration)
    OvaleCondition:RegisterCondition("buffdurationifapplied", false, BaseDuration)
    OvaleCondition:RegisterCondition("debuffdurationifapplied", false, BaseDuration)
end
do
    local BuffAmount = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local value = namedParams.value or 1
        local statName = "value1"
        if value == 1 then
            statName = "value1"
        elseif value == 2 then
            statName = "value2"
        elseif value == 3 then
            statName = "value3"
        end
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if auraState:IsActiveAura(aura, atTime) then
            local gain, start, ending = aura.gain, aura.start, aura.ending
            local value = aura[statName] or 0
            return TestValue(gain, ending, value, start, 0, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffamount", false, BuffAmount)
    OvaleCondition:RegisterCondition("debuffamount", false, BuffAmount)
    OvaleCondition:RegisterCondition("tickvalue", false, BuffAmount)
end
do
    local BuffComboPoints = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if auraState:IsActiveAura(aura, atTime) then
            local gain, start, ending = aura.gain, aura.start, aura.ending
            local value = aura and aura.combo or 0
            return TestValue(gain, ending, value, start, 0, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffcombopoints", false, BuffComboPoints)
    OvaleCondition:RegisterCondition("debuffcombopoints", false, BuffComboPoints)
end
do
    local BuffCooldown = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local gain, cooldownEnding = aura.gain, aura.cooldownEnding
            cooldownEnding = aura.cooldownEnding or 0
            return TestValue(gain, INFINITY, 0, cooldownEnding, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffcooldown", false, BuffCooldown)
    OvaleCondition:RegisterCondition("debuffcooldown", false, BuffCooldown)
end
do
    local BuffCount = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local spellList = OvaleData.buffSpellList[auraId]
        local count = 0
        for id in pairs(spellList) do
            local aura = auraState:GetAura(target, id, filter, mine)
            if auraState:IsActiveAura(aura, atTime) then
                count = count + 1
            end
        end
        return Compare(count, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffcount", false, BuffCount)
end
do
    local BuffCooldownDuration = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local minCooldown = INFINITY
        if OvaleData.buffSpellList[auraId] then
            for id in pairs(OvaleData.buffSpellList[auraId]) do
                local si = OvaleData.spellInfo[id]
                local cd = si and si.buff_cd
                if cd and minCooldown > cd then
                    minCooldown = cd
                end
            end
        else
            minCooldown = 0
        end
        return Compare(minCooldown, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffcooldownduration", false, BuffCooldownDuration)
    OvaleCondition:RegisterCondition("debuffcooldownduration", false, BuffCooldownDuration)
end
do
    local BuffCountOnAny = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local _, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local excludeUnitId = (namedParams.excludeTarget == 1) and state.defaultTarget or nil
        local fractional = (namedParams.count == 0) and true or false
        local count, _, startChangeCount, endingChangeCount, startFirst, endingLast = auraState:AuraCount(auraId, filter, mine, namedParams.stacks, atTime, excludeUnitId)
        if count > 0 and startChangeCount < INFINITY and fractional then
            local origin = startChangeCount
            local rate = -1 / (endingChangeCount - startChangeCount)
            local start, ending = startFirst, endingLast
            return TestValue(start, ending, count, origin, rate, comparator, limit)
        end
        return Compare(count, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffcountonany", false, BuffCountOnAny)
    OvaleCondition:RegisterCondition("debuffcountonany", false, BuffCountOnAny)
end
do
    local BuffDirection = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local gain, _, _, direction = aura.gain, aura.start, aura.ending, aura.direction
            return TestValue(gain, INFINITY, direction, gain, 0, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffdirection", false, BuffDirection)
    OvaleCondition:RegisterCondition("debuffdirection", false, BuffDirection)
end
do
    local BuffDuration = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if auraState:IsActiveAura(aura, atTime) then
            local gain, start, ending = aura.gain, aura.start, aura.ending
            local value = ending - start
            return TestValue(gain, ending, value, start, 0, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffduration", false, BuffDuration)
    OvaleCondition:RegisterCondition("debuffduration", false, BuffDuration)
end
do
    local BuffExpires = function(positionalParams, namedParams, state, atTime)
        local auraId, seconds = positionalParams[1], positionalParams[2]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local gain, _, ending = aura.gain, aura.start, aura.ending
            seconds = GetHastedTime(seconds, namedParams.haste, state)
            if ending - seconds <= gain then
                return gain, INFINITY
            else
                return ending - seconds, INFINITY
            end
        end
        return 0, INFINITY
    end

    OvaleCondition:RegisterCondition("buffexpires", false, BuffExpires)
    OvaleCondition:RegisterCondition("debuffexpires", false, BuffExpires)
    local BuffPresent = function(positionalParams, namedParams, state, atTime)
        local auraId, seconds = positionalParams[1], positionalParams[2]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local gain, _, ending = aura.gain, aura.start, aura.ending
            seconds = GetHastedTime(seconds, namedParams.haste, state)
            if ending - seconds <= gain then
                return nil
            else
                return gain, ending - seconds
            end
        end
        return nil
    end

    OvaleCondition:RegisterCondition("buffpresent", false, BuffPresent)
    OvaleCondition:RegisterCondition("debuffpresent", false, BuffPresent)
end
do
    local BuffGain = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local gain = aura.gain or 0
            return TestValue(gain, INFINITY, 0, gain, 1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffgain", false, BuffGain)
    OvaleCondition:RegisterCondition("debuffgain", false, BuffGain)
end
do
    local BuffImproved = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffimproved", false, BuffImproved)
    OvaleCondition:RegisterCondition("debuffimproved", false, BuffImproved)
end
do
    local BuffPersistentMultiplier = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if auraState:IsActiveAura(aura, atTime) then
            local gain, start, ending = aura.gain, aura.start, aura.ending
            local value = aura.damageMultiplier or 1
            return TestValue(gain, ending, value, start, 0, comparator, limit)
        end
        return Compare(1, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffpersistentmultiplier", false, BuffPersistentMultiplier)
    OvaleCondition:RegisterCondition("debuffpersistentmultiplier", false, BuffPersistentMultiplier)
end
do
    local BuffRemaining = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local gain, _, ending = aura.gain, aura.start, aura.ending
            return TestValue(gain, INFINITY, 0, ending, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffremaining", false, BuffRemaining)
    OvaleCondition:RegisterCondition("debuffremaining", false, BuffRemaining)
    OvaleCondition:RegisterCondition("buffremains", false, BuffRemaining)
    OvaleCondition:RegisterCondition("debuffremains", false, BuffRemaining)
end
do
    local BuffRemainingOnAny = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local _, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local excludeUnitId = (namedParams.excludeTarget == 1) and state.defaultTarget or nil
        local count, _, _, _, startFirst, endingLast = auraState:AuraCount(auraId, filter, mine, namedParams.stacks, atTime, excludeUnitId)
        if count > 0 then
            local start, ending = startFirst, endingLast
            return TestValue(start, INFINITY, 0, ending, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffremainingonany", false, BuffRemainingOnAny)
    OvaleCondition:RegisterCondition("debuffremainingonany", false, BuffRemainingOnAny)
    OvaleCondition:RegisterCondition("buffremainsonany", false, BuffRemainingOnAny)
    OvaleCondition:RegisterCondition("debuffremainsonany", false, BuffRemainingOnAny)
end
do
    local BuffStacks = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if auraState:IsActiveAura(aura, atTime) then
            local gain, start, ending = aura.gain, aura.start, aura.ending
            local value = aura.stacks or 0
            return TestValue(gain, ending, value, start, 0, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffstacks", false, BuffStacks)
    OvaleCondition:RegisterCondition("debuffstacks", false, BuffStacks)
end
do
    local BuffStacksOnAny = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local _, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local excludeUnitId = (namedParams.excludeTarget == 1) and state.defaultTarget or nil
        local count, stacks, _, endingChangeCount, startFirst = auraState:AuraCount(auraId, filter, mine, 1, atTime, excludeUnitId)
        if count > 0 then
            local start, ending = startFirst, endingChangeCount
            return TestValue(start, ending, stacks, start, 0, comparator, limit)
        end
        return Compare(count, comparator, limit)
    end

    OvaleCondition:RegisterCondition("buffstacksonany", false, BuffStacksOnAny)
    OvaleCondition:RegisterCondition("debuffstacksonany", false, BuffStacksOnAny)
end
do
    local BuffStealable = function(positionalParams, namedParams, state, atTime)
        local target = ParseCondition(positionalParams, namedParams, state)
        return auraState:GetAuraWithProperty(target, "stealable", "HELPFUL", atTime)
    end

    OvaleCondition:RegisterCondition("buffstealable", false, BuffStealable)
end
do
    local CanCast = function(positionalParams, namedParams, state, atTime)
        local spellId = positionalParams[1]
        local start, duration = cooldownState:GetSpellCooldown(spellId)
        return start + duration, INFINITY
    end

    OvaleCondition:RegisterCondition("cancast", true, CanCast)
end
do
    local CastTime = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local castTime = OvaleSpellBook:GetCastTime(spellId) or 0
        return Compare(castTime, comparator, limit)
    end

    local ExecuteTime = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local castTime = OvaleSpellBook:GetCastTime(spellId) or 0
        local gcd = futureState:GetGCD()
        local t = (castTime > gcd) and castTime or gcd
        return Compare(t, comparator, limit)
    end

    OvaleCondition:RegisterCondition("casttime", true, CastTime)
    OvaleCondition:RegisterCondition("executetime", true, ExecuteTime)
end
do
    local Casting = function(positionalParams, namedParams, state, atTime)
        local spellId = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local start, ending, castSpellId, castSpellName
        if target == "player" then
            start = futureState.startCast
            ending = futureState.endCast
            castSpellId = futureState.currentSpellId
            castSpellName = OvaleSpellBook:GetSpellName(castSpellId)
        else
            local spellName, _1, _2, _3, startTime, endTime = UnitCastingInfo(target)
            if  not spellName then
                spellName, _1, _2, _3, startTime, endTime = UnitChannelInfo(target)
            end
            if spellName then
                castSpellName = spellName
                start = startTime / 1000
                ending = endTime / 1000
            end
        end
        if castSpellId or castSpellName then
            if  not spellId then
                return start, ending
            elseif OvaleData.buffSpellList[spellId] then
                for id in pairs(OvaleData.buffSpellList[spellId]) do
                    if id == castSpellId or OvaleSpellBook:GetSpellName(id) == castSpellName then
                        return start, ending
                    end
                end
            elseif spellId == "harmful" and OvaleSpellBook:IsHarmfulSpell(spellId) then
                return start, ending
            elseif spellId == "helpful" and OvaleSpellBook:IsHelpfulSpell(spellId) then
                return start, ending
            elseif spellId == castSpellId then
                return start, ending
            elseif type(spellId) == "number" and OvaleSpellBook:GetSpellName(spellId) == castSpellName then
                return start, ending
            end
        end
        return nil
    end

    OvaleCondition:RegisterCondition("casting", false, Casting)
end
do
    local CheckBoxOff = function(positionalParams, namedParams, state, atTime)
        for _, id in ipairs(positionalParams) do
            if OvaleFrameModule.frame and OvaleFrameModule.frame:IsChecked(id) then
                return nil
            end
        end
        return 0, INFINITY
    end

    local CheckBoxOn = function(positionalParams, namedParams, state, atTime)
        for _, id in ipairs(positionalParams) do
            if OvaleFrameModule.frame and  not OvaleFrameModule.frame:IsChecked(id) then
                return nil
            end
        end
        return 0, INFINITY
    end

    OvaleCondition:RegisterCondition("checkboxoff", false, CheckBoxOff)
    OvaleCondition:RegisterCondition("checkboxon", false, CheckBoxOn)
end
do
    local Class = function(positionalParams, namedParams, state, atTime)
        local className, yesno = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local _, classToken = UnitClass(target)
        local boolean = (classToken == className)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("class", false, Class)
end
do
    local IMBUED_BUFF_ID = 214336
    local Classification = function(positionalParams, namedParams, state, atTime)
        local classification, yesno = positionalParams[1], positionalParams[2]
        local targetClassification
        local target = ParseCondition(positionalParams, namedParams, state)
        if UnitLevel(target) < 0 then
            targetClassification = "worldboss"
        elseif UnitExists("boss1") and OvaleGUID:UnitGUID(target) == OvaleGUID:UnitGUID("boss1") then
            targetClassification = "worldboss"
        else
            local aura = auraState:GetAura(target, IMBUED_BUFF_ID, "debuff", false)
            if auraState:IsActiveAura(aura, atTime) then
                targetClassification = "worldboss"
            else
                targetClassification = UnitClassification(target)
                if targetClassification == "rareelite" then
                    targetClassification = "elite"
                elseif targetClassification == "rare" then
                    targetClassification = "normal"
                end
            end
        end
        local boolean = (targetClassification == classification)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("classification", false, Classification)
end
do
    local ComboPoints = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = comboPointsState.combo
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("combopoints", false, ComboPoints)
end
do
    local Counter = function(positionalParams, namedParams, state, atTime)
        local counter, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = futureState:GetCounterValue(counter)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("counter", false, Counter)
end
do
    local CreatureFamily = function(positionalParams, namedParams, state, atTime)
        local name, yesno = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local family = UnitCreatureFamily(target)
        local lookupTable = LibBabbleCreatureType and LibBabbleCreatureType:GetLookupTable()
        local boolean = (lookupTable and family == lookupTable[name])
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("creaturefamily", false, CreatureFamily)
end
do
    local CreatureType = function(positionalParams, namedParams, state, atTime)
        local target = ParseCondition(positionalParams, namedParams, state)
        local creatureType = UnitCreatureType(target)
        local lookupTable = LibBabbleCreatureType and LibBabbleCreatureType:GetLookupTable()
        if lookupTable then
            for _, name in ipairs(positionalParams) do
                if creatureType == lookupTable[name] then
                    return 0, INFINITY
                end
            end
        end
        return nil
    end

    OvaleCondition:RegisterCondition("creaturetype", false, CreatureType)
end
do
    local AMPLIFICATION = 146051
    local INCREASED_CRIT_EFFECT_3_PERCENT = 44797
    local CritDamage = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local value = ComputeParameter(spellId, "damage", state, atTime) or 0
        local si = OvaleData.spellInfo[spellId]
        if si and si.physical == 1 then
            value = value * (1 - BossArmorDamageReduction(target, state))
        end
        local critMultiplier = 2
        do
            local aura = auraState:GetAura("player", AMPLIFICATION, "HELPFUL")
            if auraState:IsActiveAura(aura, atTime) then
                critMultiplier = critMultiplier + aura.value1
            end
        end
        do
            local aura = auraState:GetAura("player", INCREASED_CRIT_EFFECT_3_PERCENT, "HELPFUL")
            if auraState:IsActiveAura(aura, atTime) then
                critMultiplier = critMultiplier * aura.value1
            end
        end
        value = critMultiplier * value
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("critdamage", false, CritDamage)
    local Damage = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local value = ComputeParameter(spellId, "damage", state, atTime) or 0
        local si = OvaleData.spellInfo[spellId]
        if si and si.physical == 1 then
            value = value * (1 - BossArmorDamageReduction(target, state))
        end
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("damage", false, Damage)
end
do
    local DamageTaken = function(positionalParams, namedParams, state, atTime)
        local interval, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = 0
        if interval > 0 then
            local total, totalMagic = OvaleDamageTaken:GetRecentDamage(interval)
            if namedParams.magic == 1 then
                value = totalMagic
            elseif namedParams.physical == 1 then
                value = total - totalMagic
            else
                value = total
            end
        end
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("damagetaken", false, DamageTaken)
    OvaleCondition:RegisterCondition("incomingdamage", false, DamageTaken)
end
do
    local Demons = function(positionalParams, namedParams, state, atTime)
        local creatureId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = wildImpsState:GetDemonsCount(creatureId, atTime)
        return Compare(value, comparator, limit)
    end

    local NotDeDemons = function(positionalParams, namedParams, state, atTime)
        local creatureId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = wildImpsState:GetNotDemonicEmpoweredDemonsCount(creatureId, atTime)
        return Compare(value, comparator, limit)
    end

    local DemonDuration = function(positionalParams, namedParams, state, atTime)
        local creatureId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = wildImpsState:GetRemainingDemonDuration(creatureId, atTime)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("demons", false, Demons)
    OvaleCondition:RegisterCondition("notdedemons", false, NotDeDemons)
    OvaleCondition:RegisterCondition("demonduration", false, DemonDuration)
end
do
    local NECROTIC_PLAGUE_TALENT = 19
    local NECROTIC_PLAGUE_DEBUFF = 155159
    local BLOOD_PLAGUE_DEBUFF = 55078
    local FROST_FEVER_DEBUFF = 55095
    local GetDiseases = function(target, state)
        local npAura, bpAura, ffAura
        local talented = (OvaleSpellBook:GetTalentPoints(NECROTIC_PLAGUE_TALENT) > 0)
        if talented then
            npAura = auraState:GetAura(target, NECROTIC_PLAGUE_DEBUFF, "HARMFUL", true)
        else
            bpAura = auraState:GetAura(target, BLOOD_PLAGUE_DEBUFF, "HARMFUL", true)
            ffAura = auraState:GetAura(target, FROST_FEVER_DEBUFF, "HARMFUL", true)
        end
        return talented, npAura, bpAura, ffAura
    end

    local DiseasesRemaining = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, _ = ParseCondition(positionalParams, namedParams, state)
        local talented, npAura, bpAura, ffAura = GetDiseases(target, state)
        local aura
        if talented and auraState:IsActiveAura(npAura, atTime) then
            aura = npAura
        elseif  not talented and auraState:IsActiveAura(bpAura, atTime) and auraState:IsActiveAura(ffAura, atTime) then
            aura = (bpAura.ending < ffAura.ending) and bpAura or ffAura
        end
        if aura then
            local gain, _, ending = aura.gain, aura.start, aura.ending
            return TestValue(gain, INFINITY, 0, ending, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    local DiseasesTicking = function(positionalParams, namedParams, state, atTime)
        local target, _ = ParseCondition(positionalParams, namedParams, state)
        local talented, npAura, bpAura, ffAura = GetDiseases(target, state)
        local gain, start, ending
        if talented and npAura then
            gain, start, ending = npAura.gain, npAura.start, npAura.ending
        elseif  not talented and bpAura and ffAura then
            gain = (bpAura.gain > ffAura.gain) and bpAura.gain or ffAura.gain
            start = (bpAura.start > ffAura.start) and bpAura.start or ffAura.start
            ending = (bpAura.ending < ffAura.ending) and bpAura.ending or ffAura.ending
        end
        if gain and ending and ending > gain then
            return gain, ending
        end
        return nil
    end

    local DiseasesAnyTicking = function(positionalParams, namedParams, state, atTime)
        local target, _ = ParseCondition(positionalParams, namedParams, state)
        local talented, npAura, bpAura, ffAura = GetDiseases(target, state)
        local aura
        if talented and npAura then
            aura = npAura
        elseif  not talented and (bpAura or ffAura) then
            aura = bpAura or ffAura
            if bpAura and ffAura then
                aura = (bpAura.ending > ffAura.ending) and bpAura or ffAura
            end
        end
        if aura then
            local gain, _, ending = aura.gain, aura.start, aura.ending
            if ending > gain then
                return gain, ending
            end
        end
        return nil
    end

    OvaleCondition:RegisterCondition("diseasesremaining", false, DiseasesRemaining)
    OvaleCondition:RegisterCondition("diseasesticking", false, DiseasesTicking)
    OvaleCondition:RegisterCondition("diseasesanyticking", false, DiseasesAnyTicking)
end
do
    local Distance = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local value = LibRangeCheck and LibRangeCheck:GetRange(target) or 0
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("distance", false, Distance)
end
do
    local Enemies = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = EnemiesState.enemies
        if  not value then
            local useTagged = Ovale.db.profile.apparence.taggedEnemies
            if namedParams.tagged == 0 then
                useTagged = false
            elseif namedParams.tagged == 1 then
                useTagged = true
            end
            value = useTagged and EnemiesState.taggedEnemies or EnemiesState.activeEnemies
        end
        if value < 1 then
            value = 1
        end
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("enemies", false, Enemies)
end
do
    local EnergyRegenRate = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = powerState.powerRate.energy
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("energyregen", false, EnergyRegenRate)
    OvaleCondition:RegisterCondition("energyregenrate", false, EnergyRegenRate)
end
do
    local EnrageRemaining = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local start, ending = auraState:GetAuraWithProperty(target, "enrage", "HELPFUL", atTime)
        if start and ending then
            return TestValue(start, INFINITY, 0, ending, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("enrageremaining", false, EnrageRemaining)
end
do
    local Exists = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = UnitExists(target)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("exists", false, Exists)
end
do
    local False = function(positionalParams, namedParams, state, atTime)
        return nil
    end

    OvaleCondition:RegisterCondition("false", false, False)
end
do
    local FocusRegenRate = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = powerState.powerRate.focus
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("focusregen", false, FocusRegenRate)
    OvaleCondition:RegisterCondition("focusregenrate", false, FocusRegenRate)
end
do
    local STEADY_FOCUS = 177668
    local FocusCastingRegen = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local regenRate = powerState.powerRate.focus
        local power = 0
        local castTime = OvaleSpellBook:GetCastTime(spellId) or 0
        local gcd = futureState:GetGCD()
        local castSeconds = (castTime > gcd) and castTime or gcd
        power = power + regenRate * castSeconds
        local aura = auraState:GetAura("player", STEADY_FOCUS, "HELPFUL", true)
        if aura then
            local seconds = aura.ending - state.currentTime
            if seconds <= 0 then
                seconds = 0
            elseif seconds > castSeconds then
                seconds = castSeconds
            end
            power = power + regenRate * 1.5 * seconds
        end
        return Compare(power, comparator, limit)
    end

    OvaleCondition:RegisterCondition("focuscastingregen", false, FocusCastingRegen)
end
do
    local GCD = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = futureState:GetGCD()
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("gcd", false, GCD)
end
do
    local GCDRemaining = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        if futureState.lastSpellId then
            local duration = futureState:GetGCD(futureState.lastSpellId, atTime, OvaleGUID:UnitGUID(target))
            local spellcast = lastSpell:LastInFlightSpell()
            local start = (spellcast and spellcast.start) or 0
            local ending = start + duration
            if atTime < ending then
                return TestValue(start, INFINITY, 0, ending, -1, comparator, limit)
            end
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("gcdremaining", false, GCDRemaining)
end
do
    local GetState = function(positionalParams, namedParams, state, atTime)
        local name, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = state:GetState(name)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("getstate", false, GetState)
end
do
    local GetStateDuration = function(positionalParams, namedParams, state, atTime)
        local name, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = state:GetStateDuration(name)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("getstateduration", false, GetStateDuration)
end
do
    local Glyph = function(positionalParams, namedParams, state, atTime)
        local _, yesno = positionalParams[1], positionalParams[2]
        return TestBoolean(false, yesno)
    end

    OvaleCondition:RegisterCondition("glyph", false, Glyph)
end
do
    local HasEquippedItem = function(positionalParams, namedParams, state, atTime)
        local itemId, yesno = positionalParams[1], positionalParams[2]
        local ilevel, slot = namedParams.ilevel, namedParams.slot
        local boolean = false
        local slotId
        if type(itemId) == "number" then
            slotId = OvaleEquipment:HasEquippedItem(itemId, slot)
            if slotId then
                if  not ilevel or (ilevel and ilevel == OvaleEquipment:GetEquippedItemLevel(slotId)) then
                    boolean = true
                end
            end
        elseif OvaleData.itemList[itemId] then
            for _, v in pairs(OvaleData.itemList[itemId]) do
                slotId = OvaleEquipment:HasEquippedItem(v, slot)
                if slotId then
                    if  not ilevel or (ilevel and ilevel == OvaleEquipment:GetEquippedItemLevel(slotId)) then
                        boolean = true
                        break
                    end
                end
            end
        end
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("hasequippeditem", false, HasEquippedItem)
end
do
    local HasFullControlCondition = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local boolean = HasFullControl()
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("hasfullcontrol", false, HasFullControlCondition)
end
do
    local HasShield = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local boolean = OvaleEquipment:HasShield()
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("hasshield", false, HasShield)
end
do
    local HasTrinket = function(positionalParams, namedParams, state, atTime)
        local trinketId, yesno = positionalParams[1], positionalParams[2]
        local boolean = false
        if type(trinketId) == "number" then
            boolean = OvaleEquipment:HasTrinket(trinketId)
        elseif OvaleData.itemList[trinketId] then
            for _, v in pairs(OvaleData.itemList[trinketId]) do
                boolean = OvaleEquipment:HasTrinket(v)
                if boolean then
                    break
                end
            end
        end
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("hastrinket", false, HasTrinket)
end
do
    local HasWeapon = function(positionalParams, namedParams, state, atTime)
        local hand, yesno = positionalParams[1], positionalParams[2]
        local weaponType = namedParams.type
        local boolean = false
        if weaponType == "one_handed" then
            weaponType = 1
        elseif weaponType == "two_handed" then
            weaponType = 2
        end
        if hand == "offhand" or hand == "off" then
            boolean = OvaleEquipment:HasOffHandWeapon(weaponType)
        elseif hand == "mainhand" or hand == "main" then
            boolean = OvaleEquipment:HasMainHandWeapon(weaponType)
        end
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("hasweapon", false, HasWeapon)
end
do
    local Health = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local health = OvaleHealth:UnitHealth(target) or 0
        if health > 0 then
            local now = GetTime()
            local timeToDie = OvaleHealth:UnitTimeToDie(target)
            local value, origin, rate = health, now, -1 * health / timeToDie
            local start, ending = now, INFINITY
            return TestValue(start, ending, value, origin, rate, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("health", false, Health)
    OvaleCondition:RegisterCondition("life", false, Health)
    local HealthMissing = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local health = OvaleHealth:UnitHealth(target) or 0
        local maxHealth = OvaleHealth:UnitHealthMax(target) or 1
        if health > 0 then
            local now = GetTime()
            local missing = maxHealth - health
            local timeToDie = OvaleHealth:UnitTimeToDie(target)
            local value, origin, rate = missing, now, health / timeToDie
            local start, ending = now, INFINITY
            return TestValue(start, ending, value, origin, rate, comparator, limit)
        end
        return Compare(maxHealth, comparator, limit)
    end

    OvaleCondition:RegisterCondition("healthmissing", false, HealthMissing)
    OvaleCondition:RegisterCondition("lifemissing", false, HealthMissing)
    local HealthPercent = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local health = OvaleHealth:UnitHealth(target) or 0
        if health > 0 then
            local now = GetTime()
            local maxHealth = OvaleHealth:UnitHealthMax(target) or 1
            local healthPercent = health / maxHealth * 100
            local timeToDie = OvaleHealth:UnitTimeToDie(target)
            local value, origin, rate = healthPercent, now, -1 * healthPercent / timeToDie
            local start, ending = now, INFINITY
            return TestValue(start, ending, value, origin, rate, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("healthpercent", false, HealthPercent)
    OvaleCondition:RegisterCondition("lifepercent", false, HealthPercent)
    local MaxHealth = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local value = OvaleHealth:UnitHealthMax(target)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("maxhealth", false, MaxHealth)
    local TimeToDie = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local now = GetTime()
        local timeToDie = OvaleHealth:UnitTimeToDie(target)
        local value, origin, rate = timeToDie, now, -1
        local start, ending = now, now + timeToDie
        return TestValue(start, ending, value, origin, rate, comparator, limit)
    end

    OvaleCondition:RegisterCondition("deadin", false, TimeToDie)
    OvaleCondition:RegisterCondition("timetodie", false, TimeToDie)
    local TimeToHealthPercent = function(positionalParams, namedParams, state, atTime)
        local percent, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state)
        local health = OvaleHealth:UnitHealth(target) or 0
        if health > 0 then
            local maxHealth = OvaleHealth:UnitHealthMax(target) or 1
            local healthPercent = health / maxHealth * 100
            if healthPercent >= percent then
                local now = GetTime()
                local timeToDie = OvaleHealth:UnitTimeToDie(target)
                local t = timeToDie * (healthPercent - percent) / healthPercent
                local value, origin, rate = t, now, -1
                local start, ending = now, now + t
                return TestValue(start, ending, value, origin, rate, comparator, limit)
            end
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("timetohealthpercent", false, TimeToHealthPercent)
    OvaleCondition:RegisterCondition("timetolifepercent", false, TimeToHealthPercent)
end
do
    local InCombat = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local boolean = state.inCombat
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("incombat", false, InCombat)
end
do
    local InFlightToTarget = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local boolean = (futureState.currentSpellId == spellId) or OvaleFuture:InFlight(spellId)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("inflighttotarget", false, InFlightToTarget)
end
do
    local InRange = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = (OvaleSpellBook:IsSpellInRange(spellId, target) == 1)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("inrange", false, InRange)
end
do
    local IsAggroed = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = UnitDetailedThreatSituation("player", target)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isaggroed", false, IsAggroed)
end
do
    local IsDead = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = UnitIsDead(target)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isdead", false, IsDead)
end
do
    local IsEnraged = function(positionalParams, namedParams, state, atTime)
        local target = ParseCondition(positionalParams, namedParams, state)
        return auraState:GetAuraWithProperty(target, "enrage", "HELPFUL", atTime)
    end

    OvaleCondition:RegisterCondition("isenraged", false, IsEnraged)
end
do
    local IsFeared = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local aura = auraState:GetAura("player", "fear_debuff", "HARMFUL")
        local boolean =  not HasFullControl() and auraState:IsActiveAura(aura, atTime)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isfeared", false, IsFeared)
end
do
    local IsFriend = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = UnitIsFriend("player", target)
        return TestBoolean(boolean == 1, yesno)
    end

    OvaleCondition:RegisterCondition("isfriend", false, IsFriend)
end
do
    local IsIncapacitated = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local aura = auraState:GetAura("player", "incapacitate_debuff", "HARMFUL")
        local boolean =  not HasFullControl() and auraState:IsActiveAura(aura, atTime)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isincapacitated", false, IsIncapacitated)
end
do
    local IsInterruptible = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local name, _1, _2, _3, _4, _5, _6, _, notInterruptible = UnitCastingInfo(target)
        if  not name then
            name, _1, _2, _3, _4, _5, _6, notInterruptible = UnitChannelInfo(target)
        end
        local boolean = notInterruptible ~= nil and  not notInterruptible
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isinterruptible", false, IsInterruptible)
end
do
    local IsPVP = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = UnitIsPVP(target)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("ispvp", false, IsPVP)
end
do
    local IsRooted = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local aura = auraState:GetAura("player", "root_debuff", "HARMFUL")
        local boolean = auraState:IsActiveAura(aura, atTime)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isrooted", false, IsRooted)
end
do
    local IsStunned = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local aura = auraState:GetAura("player", "stun_debuff", "HARMFUL")
        local boolean =  not HasFullControl() and auraState:IsActiveAura(aura, atTime)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isstunned", false, IsStunned)
end
do
    local ItemCharges = function(positionalParams, namedParams, state, atTime)
        local itemId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = GetItemCount(itemId, false, true)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("itemcharges", false, ItemCharges)
end
do
    local ItemCooldown = function(positionalParams, namedParams, state, atTime)
        local itemId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        if itemId and type(itemId) ~= "number" then
            itemId = OvaleEquipment:GetEquippedItem(itemId)
        end
        if itemId then
            local start, duration = GetItemCooldown(itemId)
            if start > 0 and duration > 0 then
                return TestValue(start, start + duration, duration, start, -1, comparator, limit)
            end
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("itemcooldown", false, ItemCooldown)
end
do
    local ItemCount = function(positionalParams, namedParams, state, atTime)
        local itemId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = GetItemCount(itemId)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("itemcount", false, ItemCount)
end
do
    local LastDamage = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = OvaleSpellDamage:Get(spellId)
        if value then
            return Compare(value, comparator, limit)
        end
        return nil
    end

    OvaleCondition:RegisterCondition("lastdamage", false, LastDamage)
    OvaleCondition:RegisterCondition("lastspelldamage", false, LastDamage)
end
do
    local Level = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local value
        if target == "player" then
            value = paperDollState.level
        else
            value = UnitLevel(target)
        end
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("level", false, Level)
end
do
    local List = function(positionalParams, namedParams, state, atTime)
        local name, value = positionalParams[1], positionalParams[2]
        if name and OvaleFrameModule.frame and OvaleFrameModule.frame:GetListValue(name) == value then
            return 0, INFINITY
        end
        return nil
    end

    OvaleCondition:RegisterCondition("list", false, List)
end
do
    local Name = function(positionalParams, namedParams, state, atTime)
        local name, yesno = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        if type(name) == "number" then
            name = OvaleSpellBook:GetSpellName(name)
        end
        local targetName = UnitName(target)
        local boolean = (name == targetName)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("name", false, Name)
end
do
    local PTR = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local _, _, _, uiVersion = GetBuildInfo()
        local value = (uiVersion > 70200) and 1 or 0
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("ptr", false, PTR)
end
do
    local PersistentMultiplier = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local value = futureState:GetDamageMultiplier(spellId, OvaleGUID:UnitGUID(target), atTime)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("persistentmultiplier", false, PersistentMultiplier)
end
do
    local PetPresent = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local name = namedParams.name
        local target = "pet"
        local boolean = UnitExists(target) and  not UnitIsDead(target) and (name == nil or name == UnitName(target))
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("petpresent", false, PetPresent)
end
do
    local MaxPower = function(powerType, positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local value
        if target == "player" then
            value = OvalePower.maxPower[powerType]
        else
            local powerInfo = OvalePower.POWER_INFO[powerType]
            value = UnitPowerMax(target, powerInfo.id, powerInfo.segments)
        end
        return Compare(value, comparator, limit)
    end

    local Power = function(powerType, positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        if target == "player" then
            local value, origin, rate = powerState[powerType], state.currentTime, powerState.powerRate[powerType]
            local start, ending = state.currentTime, INFINITY
            return TestValue(start, ending, value, origin, rate, comparator, limit)
        else
            local powerInfo = OvalePower.POWER_INFO[powerType]
            local value = UnitPower(target, powerInfo.id)
            return Compare(value, comparator, limit)
        end
    end

    local PowerDeficit = function(powerType, positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        if target == "player" then
            local powerMax = OvalePower.maxPower[powerType] or 0
            if powerMax > 0 then
                local value, origin, rate = powerMax - powerState[powerType], state.currentTime, -1 * powerState.powerRate[powerType]
                local start, ending = state.currentTime, INFINITY
                return TestValue(start, ending, value, origin, rate, comparator, limit)
            end
        else
            local powerInfo = OvalePower.POWER_INFO[powerType]
            local powerMax = UnitPowerMax(target, powerInfo.id, powerInfo.segments) or 0
            if powerMax > 0 then
                local power = UnitPower(target, powerInfo.id)
                local value = powerMax - power
                return Compare(value, comparator, limit)
            end
        end
        return Compare(0, comparator, limit)
    end

    local PowerPercent = function(powerType, positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        if target == "player" then
            local powerMax = OvalePower.maxPower[powerType] or 0
            if powerMax > 0 then
                local conversion = 100 / powerMax
                local value, origin, rate = powerState[powerType] * conversion, state.currentTime, powerState.powerRate[powerType] * conversion
                if rate > 0 and value >= 100 or rate < 0 and value == 0 then
                    rate = 0
                end
                local start, ending = state.currentTime, INFINITY
                return TestValue(start, ending, value, origin, rate, comparator, limit)
            end
        else
            local powerInfo = OvalePower.POWER_INFO[powerType]
            local powerMax = UnitPowerMax(target, powerInfo.id, powerInfo.segments) or 0
            if powerMax > 0 then
                local conversion = 100 / powerMax
                local value = UnitPower(target, powerInfo.id) * conversion
                return Compare(value, comparator, limit)
            end
        end
        return Compare(0, comparator, limit)
    end

    local PrimaryResource = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local primaryPowerType
        local si = OvaleData:GetSpellInfo(spellId)
        if si then
            for powerType in pairs(OvalePower.PRIMARY_POWER) do
                if si[powerType] then
                    primaryPowerType = powerType
                    break
                end
            end
        end
        if  not primaryPowerType then
            local _, powerType = OvalePower:GetSpellCost(spellId)
            if powerType then
                primaryPowerType = powerType
            end
        end
        if primaryPowerType then
            local value, origin, rate = powerState[primaryPowerType], state.currentTime, powerState.powerRate[primaryPowerType]
            local start, ending = state.currentTime, INFINITY
            return TestValue(start, ending, value, origin, rate, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("primaryresource", true, PrimaryResource)
    local AlternatePower = function(positionalParams, namedParams, state, atTime)
        return Power("alternate", positionalParams, namedParams, state, atTime)
    end

    local AstralPower = function(positionalParams, namedParams, state, atTime)
        return Power("astralpower", positionalParams, namedParams, state, atTime)
    end

    local Chi = function(positionalParams, namedParams, state, atTime)
        return Power("chi", positionalParams, namedParams, state, atTime)
    end

    local Energy = function(positionalParams, namedParams, state, atTime)
        return Power("energy", positionalParams, namedParams, state, atTime)
    end

    local Focus = function(positionalParams, namedParams, state, atTime)
        return Power("focus", positionalParams, namedParams, state, atTime)
    end

    local Fury = function(positionalParams, namedParams, state, atTime)
        return Power("fury", positionalParams, namedParams, state, atTime)
    end

    local HolyPower = function(positionalParams, namedParams, state, atTime)
        return Power("holy", positionalParams, namedParams, state, atTime)
    end

    local Insanity = function(positionalParams, namedParams, state, atTime)
        return Power("insanity", positionalParams, namedParams, state, atTime)
    end

    local Mana = function(positionalParams, namedParams, state, atTime)
        return Power("mana", positionalParams, namedParams, state, atTime)
    end

    local Maelstrom = function(positionalParams, namedParams, state, atTime)
        return Power("maelstrom", positionalParams, namedParams, state, atTime)
    end

    local Pain = function(positionalParams, namedParams, state, atTime)
        return Power("pain", positionalParams, namedParams, state, atTime)
    end

    local Rage = function(positionalParams, namedParams, state, atTime)
        return Power("rage", positionalParams, namedParams, state, atTime)
    end

    local RunicPower = function(positionalParams, namedParams, state, atTime)
        return Power("runicpower", positionalParams, namedParams, state, atTime)
    end

    local ShadowOrbs = function(positionalParams, namedParams, state, atTime)
        return Power("shadoworbs", positionalParams, namedParams, state, atTime)
    end

    local SoulShards = function(positionalParams, namedParams, state, atTime)
        return Power("soulshards", positionalParams, namedParams, state, atTime)
    end

    local ArcaneCharges = function(positionalParams, namedParams, state, atTime)
        return Power("arcanecharges", positionalParams, namedParams, state, atTime)
    end

    OvaleCondition:RegisterCondition("alternatepower", false, AlternatePower)
    OvaleCondition:RegisterCondition("arcanecharges", false, ArcaneCharges)
    OvaleCondition:RegisterCondition("astralpower", false, AstralPower)
    OvaleCondition:RegisterCondition("chi", false, Chi)
    OvaleCondition:RegisterCondition("energy", false, Energy)
    OvaleCondition:RegisterCondition("focus", false, Focus)
    OvaleCondition:RegisterCondition("fury", false, Fury)
    OvaleCondition:RegisterCondition("holypower", false, HolyPower)
    OvaleCondition:RegisterCondition("insanity", false, Insanity)
    OvaleCondition:RegisterCondition("maelstrom", false, Maelstrom)
    OvaleCondition:RegisterCondition("mana", false, Mana)
    OvaleCondition:RegisterCondition("pain", false, Pain)
    OvaleCondition:RegisterCondition("rage", false, Rage)
    OvaleCondition:RegisterCondition("runicpower", false, RunicPower)
    OvaleCondition:RegisterCondition("shadoworbs", false, ShadowOrbs)
    OvaleCondition:RegisterCondition("soulshards", false, SoulShards)
    local AlternatePowerDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("alternatepower", positionalParams, namedParams, state, atTime)
    end

    local AstralPowerDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("astralpower", positionalParams, namedParams, state, atTime)
    end

    local ChiDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("chi", positionalParams, namedParams, state, atTime)
    end

    local ComboPointsDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("combopoints", positionalParams, namedParams, state, atTime)
    end

    local EnergyDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("energy", positionalParams, namedParams, state, atTime)
    end

    local FocusDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("focus", positionalParams, namedParams, state, atTime)
    end

    local FuryDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("fury", positionalParams, namedParams, state, atTime)
    end

    local HolyPowerDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("holypower", positionalParams, namedParams, state, atTime)
    end

    local ManaDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("mana", positionalParams, namedParams, state, atTime)
    end

    local PainDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("pain", positionalParams, namedParams, state, atTime)
    end

    local RageDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("rage", positionalParams, namedParams, state, atTime)
    end

    local RunicPowerDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("runicpower", positionalParams, namedParams, state, atTime)
    end

    local ShadowOrbsDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("shadoworbs", positionalParams, namedParams, state, atTime)
    end

    local SoulShardsDeficit = function(positionalParams, namedParams, state, atTime)
        return PowerDeficit("soulshards", positionalParams, namedParams, state, atTime)
    end

    OvaleCondition:RegisterCondition("alternatepowerdeficit", false, AlternatePowerDeficit)
    OvaleCondition:RegisterCondition("astralpowerdeficit", false, AstralPowerDeficit)
    OvaleCondition:RegisterCondition("chideficit", false, ChiDeficit)
    OvaleCondition:RegisterCondition("combopointsdeficit", false, ComboPointsDeficit)
    OvaleCondition:RegisterCondition("energydeficit", false, EnergyDeficit)
    OvaleCondition:RegisterCondition("focusdeficit", false, FocusDeficit)
    OvaleCondition:RegisterCondition("furydeficit", false, FuryDeficit)
    OvaleCondition:RegisterCondition("holypowerdeficit", false, HolyPowerDeficit)
    OvaleCondition:RegisterCondition("manadeficit", false, ManaDeficit)
    OvaleCondition:RegisterCondition("paindeficit", false, PainDeficit)
    OvaleCondition:RegisterCondition("ragedeficit", false, RageDeficit)
    OvaleCondition:RegisterCondition("runicpowerdeficit", false, RunicPowerDeficit)
    OvaleCondition:RegisterCondition("shadoworbsdeficit", false, ShadowOrbsDeficit)
    OvaleCondition:RegisterCondition("soulshardsdeficit", false, SoulShardsDeficit)
    local ManaPercent = function(positionalParams, namedParams, state, atTime)
        return PowerPercent("mana", positionalParams, namedParams, state, atTime)
    end

    OvaleCondition:RegisterCondition("manapercent", false, ManaPercent)
    local MaxAlternatePower = function(positionalParams, namedParams, state, atTime)
        return MaxPower("alternate", positionalParams, namedParams, state, atTime)
    end

    local MaxChi = function(positionalParams, namedParams, state, atTime)
        return MaxPower("chi", positionalParams, namedParams, state, atTime)
    end

    local MaxComboPoints = function(positionalParams, namedParams, state, atTime)
        return MaxPower("combopoints", positionalParams, namedParams, state, atTime)
    end

    local MaxEnergy = function(positionalParams, namedParams, state, atTime)
        return MaxPower("energy", positionalParams, namedParams, state, atTime)
    end

    local MaxFocus = function(positionalParams, namedParams, state, atTime)
        return MaxPower("focus", positionalParams, namedParams, state, atTime)
    end

    local MaxFury = function(positionalParams, namedParams, state, atTime)
        return MaxPower("fury", positionalParams, namedParams, state, atTime)
    end

    local MaxHolyPower = function(positionalParams, namedParams, state, atTime)
        return MaxPower("holy", positionalParams, namedParams, state, atTime)
    end

    local MaxMana = function(positionalParams, namedParams, state, atTime)
        return MaxPower("mana", positionalParams, namedParams, state, atTime)
    end

    local MaxPain = function(positionalParams, namedParams, state, atTime)
        return MaxPower("pain", positionalParams, namedParams, state, atTime)
    end

    local MaxRage = function(positionalParams, namedParams, state, atTime)
        return MaxPower("rage", positionalParams, namedParams, state, atTime)
    end

    local MaxRunicPower = function(positionalParams, namedParams, state, atTime)
        return MaxPower("runicpower", positionalParams, namedParams, state, atTime)
    end

    local MaxShadowOrbs = function(positionalParams, namedParams, state, atTime)
        return MaxPower("shadoworbs", positionalParams, namedParams, state, atTime)
    end

    local MaxSoulShards = function(positionalParams, namedParams, state, atTime)
        return MaxPower("soulshards", positionalParams, namedParams, state, atTime)
    end

    OvaleCondition:RegisterCondition("maxalternatepower", false, MaxAlternatePower)
    OvaleCondition:RegisterCondition("maxchi", false, MaxChi)
    OvaleCondition:RegisterCondition("maxcombopoints", false, MaxComboPoints)
    OvaleCondition:RegisterCondition("maxenergy", false, MaxEnergy)
    OvaleCondition:RegisterCondition("maxfocus", false, MaxFocus)
    OvaleCondition:RegisterCondition("maxfury", false, MaxFury)
    OvaleCondition:RegisterCondition("maxholypower", false, MaxHolyPower)
    OvaleCondition:RegisterCondition("maxmana", false, MaxMana)
    OvaleCondition:RegisterCondition("maxpain", false, MaxPain)
    OvaleCondition:RegisterCondition("maxrage", false, MaxRage)
    OvaleCondition:RegisterCondition("maxrunicpower", false, MaxRunicPower)
    OvaleCondition:RegisterCondition("maxshadoworbs", false, MaxShadowOrbs)
    OvaleCondition:RegisterCondition("maxsoulshards", false, MaxSoulShards)
end
do
    local PowerCost = function(powerType, positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local maxCost = (namedParams.max == 1)
        local value = powerState:PowerCost(spellId, powerType, atTime, target, maxCost) or 0
        return Compare(value, comparator, limit)
    end

    local EnergyCost = function(positionalParams, namedParams, state, atTime)
        return PowerCost("energy", positionalParams, namedParams, state, atTime)
    end

    local FocusCost = function(positionalParams, namedParams, state, atTime)
        return PowerCost("focus", positionalParams, namedParams, state, atTime)
    end

    local ManaCost = function(positionalParams, namedParams, state, atTime)
        return PowerCost("mana", positionalParams, namedParams, state, atTime)
    end

    local RageCost = function(positionalParams, namedParams, state, atTime)
        return PowerCost("rage", positionalParams, namedParams, state, atTime)
    end

    local RunicPowerCost = function(positionalParams, namedParams, state, atTime)
        return PowerCost("runicpower", positionalParams, namedParams, state, atTime)
    end

    local AstralPowerCost = function(positionalParams, namedParams, state, atTime)
        return PowerCost("astralpower", positionalParams, namedParams, state, atTime)
    end

    local MainPowerCost = function(positionalParams, namedParams, state, atTime)
        return PowerCost(OvalePower.powerType, positionalParams, namedParams, state, atTime)
    end

    OvaleCondition:RegisterCondition("powercost", true, MainPowerCost)
    OvaleCondition:RegisterCondition("astralpowercost", true, AstralPowerCost)
    OvaleCondition:RegisterCondition("energycost", true, EnergyCost)
    OvaleCondition:RegisterCondition("focuscost", true, FocusCost)
    OvaleCondition:RegisterCondition("manacost", true, ManaCost)
    OvaleCondition:RegisterCondition("ragecost", true, RageCost)
    OvaleCondition:RegisterCondition("runicpowercost", true, RunicPowerCost)
end
do
    local Present = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = UnitExists(target) and  not UnitIsDead(target)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("present", false, Present)
end
do
    local PreviousGCDSpell = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local count = namedParams.count
        local boolean
        if count and count > 1 then
            boolean = (spellId == futureState.lastGCDSpellIds[#futureState.lastGCDSpellIds - count + 2])
        else
            boolean = (spellId == futureState.lastGCDSpellId)
        end
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("previousgcdspell", true, PreviousGCDSpell)
end
do
    local PreviousOffGCDSpell = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local boolean = (spellId == futureState.lastOffGCDSpellId)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("previousoffgcdspell", true, PreviousOffGCDSpell)
end
do
    local PreviousSpell = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local boolean = (spellId == futureState.lastSpellId)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("previousspell", true, PreviousSpell)
end
do
    local RelativeLevel = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local value, level
        if target == "player" then
            level = paperDollState.level
        else
            level = UnitLevel(target)
        end
        if level < 0 then
            value = 3
        else
            value = level - paperDollState.level
        end
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("relativelevel", false, RelativeLevel)
end
do
    local Refreshable = function(positionalParams, namedParams, state, atTime)
        local auraId = positionalParams[1]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local baseDuration = OvaleData:GetBaseDuration(auraId)
            local extensionDuration = 0.3 * baseDuration
            return aura.ending - extensionDuration, INFINITY
        end
        return 0, INFINITY
    end

    OvaleCondition:RegisterCondition("refreshable", false, Refreshable)
    OvaleCondition:RegisterCondition("debuffrefreshable", false, Refreshable)
    OvaleCondition:RegisterCondition("buffrefreshable", false, Refreshable)
end
do
    local RemainingCastTime = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local _, _, _, _, startTime, endTime = UnitCastingInfo(target)
        if startTime and endTime then
            startTime = startTime / 1000
            endTime = endTime / 1000
            return TestValue(startTime, endTime, 0, endTime, -1, comparator, limit)
        end
        return nil
    end

    OvaleCondition:RegisterCondition("remainingcasttime", false, RemainingCastTime)
end
do
    local Rune = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local count, startCooldown, endCooldown = runesState:RuneCount(atTime)
        if startCooldown < INFINITY then
            local origin = startCooldown
            local rate = 1 / (endCooldown - startCooldown)
            local start, ending = startCooldown, INFINITY
            return TestValue(start, ending, count, origin, rate, comparator, limit)
        end
        return Compare(count, comparator, limit)
    end

    local RuneCount = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local count, startCooldown, endCooldown = runesState:RuneCount(atTime)
        if startCooldown < INFINITY then
            local start, ending = startCooldown, endCooldown
            return TestValue(start, ending, count, start, 0, comparator, limit)
        end
        return Compare(count, comparator, limit)
    end

    local TimeToRunes = function(positionalParams, namedParams, state, atTime)
        local runes, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local seconds = runesState:GetRunesCooldown(atTime, runes)
        if seconds < 0 then
            seconds = 0
        end
        return Compare(seconds, comparator, limit)
    end

    OvaleCondition:RegisterCondition("rune", false, Rune)
    OvaleCondition:RegisterCondition("runecount", false, RuneCount)
    OvaleCondition:RegisterCondition("timetorunes", false, TimeToRunes)
end
do
    local Snapshot = function(statName, defaultValue, positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = paperDollState[statName] or defaultValue
        return Compare(value, comparator, limit)
    end

    local SnapshotCritChance = function(statName, defaultValue, positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = paperDollState[statName] or defaultValue
        if namedParams.unlimited ~= 1 and value > 100 then
            value = 100
        end
        return Compare(value, comparator, limit)
    end

    local Agility = function(positionalParams, namedParams, state, atTime)
        return Snapshot("agility", 0, positionalParams, namedParams, state, atTime)
    end

    local AttackPower = function(positionalParams, namedParams, state, atTime)
        return Snapshot("attackPower", 0, positionalParams, namedParams, state, atTime)
    end

    local CritRating = function(positionalParams, namedParams, state, atTime)
        return Snapshot("critRating", 0, positionalParams, namedParams, state, atTime)
    end

    local HasteRating = function(positionalParams, namedParams, state, atTime)
        return Snapshot("hasteRating", 0, positionalParams, namedParams, state, atTime)
    end

    local Intellect = function(positionalParams, namedParams, state, atTime)
        return Snapshot("intellect", 0, positionalParams, namedParams, state, atTime)
    end

    local MasteryEffect = function(positionalParams, namedParams, state, atTime)
        return Snapshot("masteryEffect", 0, positionalParams, namedParams, state, atTime)
    end

    local MasteryRating = function(positionalParams, namedParams, state, atTime)
        return Snapshot("masteryRating", 0, positionalParams, namedParams, state, atTime)
    end

    local MeleeCritChance = function(positionalParams, namedParams, state, atTime)
        return SnapshotCritChance("meleeCrit", 0, positionalParams, namedParams, state, atTime)
    end

    local MeleeHaste = function(positionalParams, namedParams, state, atTime)
        return Snapshot("meleeHaste", 0, positionalParams, namedParams, state, atTime)
    end

    local MultistrikeChance = function(positionalParams, namedParams, state, atTime)
        return Snapshot("multistrike", 0, positionalParams, namedParams, state, atTime)
    end

    local RangedCritChance = function(positionalParams, namedParams, state, atTime)
        return SnapshotCritChance("rangedCrit", 0, positionalParams, namedParams, state, atTime)
    end

    local SpellCritChance = function(positionalParams, namedParams, state, atTime)
        return SnapshotCritChance("spellCrit", 0, positionalParams, namedParams, state, atTime)
    end

    local SpellHaste = function(positionalParams, namedParams, state, atTime)
        return Snapshot("spellHaste", 0, positionalParams, namedParams, state, atTime)
    end

    local Spellpower = function(positionalParams, namedParams, state, atTime)
        return Snapshot("spellBonusDamage", 0, positionalParams, namedParams, state, atTime)
    end

    local Spirit = function(positionalParams, namedParams, state, atTime)
        return Snapshot("spirit", 0, positionalParams, namedParams, state, atTime)
    end

    local Stamina = function(positionalParams, namedParams, state, atTime)
        return Snapshot("stamina", 0, positionalParams, namedParams, state, atTime)
    end

    local Strength = function(positionalParams, namedParams, state, atTime)
        return Snapshot("strength", 0, positionalParams, namedParams, state, atTime)
    end

    OvaleCondition:RegisterCondition("agility", false, Agility)
    OvaleCondition:RegisterCondition("attackpower", false, AttackPower)
    OvaleCondition:RegisterCondition("critrating", false, CritRating)
    OvaleCondition:RegisterCondition("hasterating", false, HasteRating)
    OvaleCondition:RegisterCondition("intellect", false, Intellect)
    OvaleCondition:RegisterCondition("mastery", false, MasteryEffect)
    OvaleCondition:RegisterCondition("masteryeffect", false, MasteryEffect)
    OvaleCondition:RegisterCondition("masteryrating", false, MasteryRating)
    OvaleCondition:RegisterCondition("meleecritchance", false, MeleeCritChance)
    OvaleCondition:RegisterCondition("meleehaste", false, MeleeHaste)
    OvaleCondition:RegisterCondition("multistrikechance", false, MultistrikeChance)
    OvaleCondition:RegisterCondition("rangedcritchance", false, RangedCritChance)
    OvaleCondition:RegisterCondition("spellcritchance", false, SpellCritChance)
    OvaleCondition:RegisterCondition("spellhaste", false, SpellHaste)
    OvaleCondition:RegisterCondition("spellpower", false, Spellpower)
    OvaleCondition:RegisterCondition("spirit", false, Spirit)
    OvaleCondition:RegisterCondition("stamina", false, Stamina)
    OvaleCondition:RegisterCondition("strength", false, Strength)
end
do
    local Speed = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local value = GetUnitSpeed(target) * 100 / 7
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("speed", false, Speed)
end
do
    local SpellChargeCooldown = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local charges, maxCharges, start, duration = cooldownState:GetSpellCharges(spellId, atTime)
        if charges and charges < maxCharges then
            return TestValue(start, start + duration, duration, start, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("spellchargecooldown", true, SpellChargeCooldown)
end
do
    local SpellCharges = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local charges, maxCharges, start, duration = cooldownState:GetSpellCharges(spellId, atTime)
        if  not charges then
            return nil
        end
        charges = charges or 0
        maxCharges = maxCharges or 1
        if namedParams.count == 0 and charges < maxCharges then
            return TestValue(state.currentTime, INFINITY, charges + 1, start + duration, 1 / duration, comparator, limit)
        end
        return Compare(charges, comparator, limit)
    end

    OvaleCondition:RegisterCondition("charges", true, SpellCharges)
    OvaleCondition:RegisterCondition("spellcharges", true, SpellCharges)
end
do
local function SpellFullRecharge(positionalParams, namedParams, state, atTime)
        local spellId = positionalParams[1]
        local comparator = positionalParams[2]
        local limit = positionalParams[3]
        local charges, maxCharges, start, dur = cooldownState:GetSpellCharges(spellId, atTime)
        if charges and charges < maxCharges then
            local duration = (maxCharges - charges) * dur
            local ending = start + duration
            return TestValue(start, ending, ending - start, start, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end
    OvaleCondition:RegisterCondition("spellfullrecharge", true, SpellFullRecharge)
end
do
    local SpellCooldown = function(positionalParams, namedParams, state, atTime)
        local comparator, limit
        local usable = (namedParams.usable == 1)
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local earliest = INFINITY
        for i, spellId in ipairs(positionalParams) do
            if OvaleCondition.COMPARATOR[spellId] then
                comparator, limit = spellId, positionalParams[i + 1]
                break
            elseif  not usable or spellBookState:IsUsableSpell(spellId, atTime, OvaleGUID:UnitGUID(target)) then
                local start, duration = cooldownState:GetSpellCooldown(spellId)
                local t = 0
                if start > 0 and duration > 0 then
                    t = start + duration
                end
                if earliest > t then
                    earliest = t
                end
            end
        end
        if earliest == INFINITY then
            return Compare(0, comparator, limit)
        elseif earliest > 0 then
            return TestValue(0, earliest, 0, earliest, -1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("spellcooldown", true, SpellCooldown)
end
do
    local SpellCooldownDuration = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local duration = cooldownState:GetSpellCooldownDuration(spellId, atTime, target)
        return Compare(duration, comparator, limit)
    end

    OvaleCondition:RegisterCondition("spellcooldownduration", true, SpellCooldownDuration)
end
do
    local SpellRechargeDuration = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local cd = cooldownState:GetCD(spellId)
        local duration = cd.chargeDuration or cooldownState:GetSpellCooldownDuration(spellId, atTime, target)
        return Compare(duration, comparator, limit)
    end

    OvaleCondition:RegisterCondition("spellrechargeduration", true, SpellRechargeDuration)
end
do
    local SpellData = function(positionalParams, namedParams, state, atTime)
        local spellId, key, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3], positionalParams[4]
        local si = OvaleData.spellInfo[spellId]
        if si then
            local value = si[key]
            if value then
                return Compare(value, comparator, limit)
            end
        end
        return nil
    end

    OvaleCondition:RegisterCondition("spelldata", false, SpellData)
end
do
    local SpellInfoProperty = function(positionalParams, namedParams, state, atTime)
        local spellId, key, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3], positionalParams[4]
        local value = dataState:GetSpellInfoProperty(spellId, atTime, key)
        if value then
            return Compare(value, comparator, limit)
        end
        return nil
    end

    OvaleCondition:RegisterCondition("spellinfoproperty", false, SpellInfoProperty)
end
do
    local SpellCount = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local spellCount = OvaleSpellBook:GetSpellCount(spellId)
        return Compare(spellCount, comparator, limit)
    end

    OvaleCondition:RegisterCondition("spellcount", true, SpellCount)
end
do
    local SpellKnown = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local boolean = OvaleSpellBook:IsKnownSpell(spellId)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("spellknown", true, SpellKnown)
end
do
    local SpellMaxCharges = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local _, maxCharges, _ = cooldownState:GetSpellCharges(spellId, atTime)
        if  not maxCharges then
            return nil
        end
        maxCharges = maxCharges or 1
        return Compare(maxCharges, comparator, limit)
    end

    OvaleCondition:RegisterCondition("spellmaxcharges", true, SpellMaxCharges)
end
do
    local SpellUsable = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local isUsable, noMana = spellBookState:IsUsableSpell(spellId, atTime, OvaleGUID:UnitGUID(target))
        local boolean = isUsable or noMana
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("spellusable", true, SpellUsable)
end
do
    local LIGHT_STAGGER = 124275
    local MODERATE_STAGGER = 124274
    local HEAVY_STAGGER = 124273
    local StaggerRemaining = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, HEAVY_STAGGER, "HARMFUL")
        if  not auraState:IsActiveAura(aura, atTime) then
            aura = auraState:GetAura(target, MODERATE_STAGGER, "HARMFUL")
        end
        if  not auraState:IsActiveAura(aura, atTime) then
            aura = auraState:GetAura(target, LIGHT_STAGGER, "HARMFUL")
        end
        if auraState:IsActiveAura(aura, atTime) then
            local gain, start, ending = aura.gain, aura.start, aura.ending
            local stagger = UnitStagger(target)
            local rate = -1 * stagger / (ending - start)
            return TestValue(gain, ending, 0, ending, rate, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("staggerremaining", false, StaggerRemaining)
    OvaleCondition:RegisterCondition("staggerremains", false, StaggerRemaining)
end
do
    local Stance = function(positionalParams, namedParams, state, atTime)
        local stance, yesno = positionalParams[1], positionalParams[2]
        local boolean = stanceState:IsStance(stance)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("stance", false, Stance)
end
do
    local Stealthed = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local boolean = auraState:GetAura("player", "stealthed_buff") or IsStealthed()
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("isstealthed", false, Stealthed)
    OvaleCondition:RegisterCondition("stealthed", false, Stealthed)
end
do
    local LastSwing = function(positionalParams, namedParams, state, atTime)
        local swing = positionalParams[1]
        local comparator, limit
        local start
        if swing and swing == "main" or swing == "off" then
            comparator, limit = positionalParams[2], positionalParams[3]
            start = 0
        else
            comparator, limit = positionalParams[1], positionalParams[2]
            start = 0
        end
        Ovale:OneTimeMessage("Warning: 'LastSwing()' is not implemented.")
        return TestValue(start, INFINITY, 0, start, 1, comparator, limit)
    end

    local NextSwing = function(positionalParams, namedParams, state, atTime)
        local swing = positionalParams[1]
        local comparator, limit
        local ending
        if swing and swing == "main" or swing == "off" then
            comparator, limit = positionalParams[2], positionalParams[3]
            ending = 0
        else
            comparator, limit = positionalParams[1], positionalParams[2]
            ending = 0
        end
        Ovale:OneTimeMessage("Warning: 'NextSwing()' is not implemented.")
        return TestValue(0, ending, 0, ending, -1, comparator, limit)
    end

    OvaleCondition:RegisterCondition("lastswing", false, LastSwing)
    OvaleCondition:RegisterCondition("nextswing", false, NextSwing)
end
do
    local Talent = function(positionalParams, namedParams, state, atTime)
        local talentId, yesno = positionalParams[1], positionalParams[2]
        local boolean = (OvaleSpellBook:GetTalentPoints(talentId) > 0)
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("talent", false, Talent)
end
do
    local TalentPoints = function(positionalParams, namedParams, state, atTime)
        local talent, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = OvaleSpellBook:GetTalentPoints(talent)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("talentpoints", false, TalentPoints)
end
do
    local TargetIsPlayer = function(positionalParams, namedParams, state, atTime)
        local yesno = positionalParams[1]
        local target = ParseCondition(positionalParams, namedParams, state)
        local boolean = UnitIsUnit("player", target .. "target")
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("istargetingplayer", false, TargetIsPlayer)
    OvaleCondition:RegisterCondition("targetisplayer", false, TargetIsPlayer)
end
do
    local Threat = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local _, _, value = UnitDetailedThreatSituation("player", target)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("threat", false, Threat)
end
do
    local TickTime = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        local tickTime
        if auraState:IsActiveAura(aura, atTime) then
            tickTime = aura.tick
        else
            tickTime = OvaleData:GetTickLength(auraId, state)
        end
        if tickTime and tickTime > 0 then
            return Compare(tickTime, comparator, limit)
        end
        return Compare(INFINITY, comparator, limit)
    end

    OvaleCondition:RegisterCondition("ticktime", false, TickTime)
end
do
    local TicksRemaining = function(positionalParams, namedParams, state, atTime)
        local auraId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target, filter, mine = ParseCondition(positionalParams, namedParams, state)
        local aura = auraState:GetAura(target, auraId, filter, mine)
        if aura then
            local gain, _, ending, tick = aura.gain, aura.start, aura.ending, aura.tick
            if tick and tick > 0 then
                return TestValue(gain, INFINITY, 1, ending, -1 / tick, comparator, limit)
            end
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("ticksremaining", false, TicksRemaining)
    OvaleCondition:RegisterCondition("ticksremain", false, TicksRemaining)
end
do
    local TimeInCombat = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        if state.inCombat then
            local start = futureState.combatStartTime
            return TestValue(start, INFINITY, 0, start, 1, comparator, limit)
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("timeincombat", false, TimeInCombat)
end
do
    local TimeSincePreviousSpell = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local t = futureState:TimeOfLastCast(spellId)
        return TestValue(0, INFINITY, 0, t, 1, comparator, limit)
    end

    OvaleCondition:RegisterCondition("timesincepreviousspell", false, TimeSincePreviousSpell)
end
do
    local TimeToBloodlust = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = 3600
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("timetobloodlust", false, TimeToBloodlust)
end
do
    local TimeToEclipse = function(positionalParams, namedParams, state, atTime)
        local _, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local value = 3600 * 24 * 7
        Ovale:OneTimeMessage("Warning: 'TimeToEclipse()' is not implemented.")
        return TestValue(0, INFINITY, value, atTime, -1, comparator, limit)
    end

    OvaleCondition:RegisterCondition("timetoeclipse", false, TimeToEclipse)
end
do
    local TimeToPower = function(powerType, level, comparator, limit, state, atTime)
        level = level or 0
        local power = powerState[powerType] or 0
        local powerRegen = powerState.powerRate[powerType] or 1
        if powerRegen == 0 then
            if power == level then
                return Compare(0, comparator, limit)
            end
            return Compare(INFINITY, comparator, limit)
        else
            local t = (level - power) / powerRegen
            if t > 0 then
                local ending = state.currentTime + t
                return TestValue(0, ending, 0, ending, -1, comparator, limit)
            end
            return Compare(0, comparator, limit)
        end
    end

    local TimeToEnergy = function(positionalParams, namedParams, state, atTime)
        local level, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        return TimeToPower("energy", level, comparator, limit, state, atTime)
    end

    local TimeToMaxEnergy = function(positionalParams, namedParams, state, atTime)
        local powerType = "energy"
        local comparator, limit = positionalParams[1], positionalParams[2]
        local level = OvalePower.maxPower[powerType] or 0
        return TimeToPower(powerType, level, comparator, limit, state, atTime)
    end

    local TimeToFocus = function(positionalParams, namedParams, state, atTime)
        local level, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        return TimeToPower("focus", level, comparator, limit, state, atTime)
    end

    local TimeToMaxFocus = function(positionalParams, namedParams, state, atTime)
        local powerType = "focus"
        local comparator, limit = positionalParams[1], positionalParams[2]
        local level = OvalePower.maxPower[powerType] or 0
        return TimeToPower(powerType, level, comparator, limit, state, atTime)
    end

    OvaleCondition:RegisterCondition("timetoenergy", false, TimeToEnergy)
    OvaleCondition:RegisterCondition("timetofocus", false, TimeToFocus)
    OvaleCondition:RegisterCondition("timetomaxenergy", false, TimeToMaxEnergy)
    OvaleCondition:RegisterCondition("timetomaxfocus", false, TimeToMaxFocus)
end
do
    local TimeToPowerFor = function(powerType, positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        if  not powerType then
            local _, pt = OvalePower:GetSpellCost(spellId)
            powerType = pt
        end
        local seconds = powerState:TimeToPower(spellId, atTime, OvaleGUID:UnitGUID(target), powerType)
        if seconds == 0 then
            return Compare(0, comparator, limit)
        elseif seconds < INFINITY then
            return TestValue(0, state.currentTime + seconds, seconds, state.currentTime, -1, comparator, limit)
        else
            return Compare(INFINITY, comparator, limit)
        end
    end

    local TimeToEnergyFor = function(positionalParams, namedParams, state, atTime)
        return TimeToPowerFor("energy", positionalParams, namedParams, state, atTime)
    end

    local TimeToFocusFor = function(positionalParams, namedParams, state, atTime)
        return TimeToPowerFor("focus", positionalParams, namedParams, state, atTime)
    end

    OvaleCondition:RegisterCondition("timetoenergyfor", true, TimeToEnergyFor)
    OvaleCondition:RegisterCondition("timetofocusfor", true, TimeToFocusFor)
end
do
    local TimeToSpell = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local target = ParseCondition(positionalParams, namedParams, state, "target")
        local seconds = spellBookState:GetTimeToSpell(spellId, atTime, OvaleGUID:UnitGUID(target))
        if seconds == 0 then
            return Compare(0, comparator, limit)
        elseif seconds < INFINITY then
            return TestValue(0, state.currentTime + seconds, seconds, state.currentTime, -1, comparator, limit)
        else
            return Compare(INFINITY, comparator, limit)
        end
    end

    OvaleCondition:RegisterCondition("timetospell", true, TimeToSpell)
end
do
    local TimeWithHaste = function(positionalParams, namedParams, state, atTime)
        local seconds, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local haste = namedParams.haste or "spell"
        local value = GetHastedTime(seconds, haste, state)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("timewithhaste", false, TimeWithHaste)
end
do
    local TotemExpires = function(positionalParams, namedParams, state, atTime)
        local id, seconds = positionalParams[1], positionalParams[2]
        seconds = seconds or 0
        if type(id) == "string" then
            local _, _, startTime, duration = totemState:GetTotemInfo(id)
            if startTime then
                return startTime + duration - seconds, INFINITY
            end
        else
            local count, _, ending = totemState:GetTotemCount(id, atTime)
            if count > 0 then
                return ending - seconds, INFINITY
            end
        end
        return 0, INFINITY
    end

    local TotemPresent = function(positionalParams, namedParams, state, atTime)
        local id = positionalParams[1]
        if type(id) == "string" then
            local _, _, startTime, duration = totemState:GetTotemInfo(id)
            if startTime and duration > 0 then
                return startTime, startTime + duration
            end
        else
            local count, start, ending = totemState:GetTotemCount(id, atTime)
            if count > 0 then
                return start, ending
            end
        end
        return nil
    end

    OvaleCondition:RegisterCondition("totemexpires", false, TotemExpires)
    OvaleCondition:RegisterCondition("totempresent", false, TotemPresent)
    local TotemRemaining = function(positionalParams, namedParams, state, atTime)
        local id, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        if type(id) == "string" then
            local _, _, startTime, duration = totemState:GetTotemInfo(id)
            if startTime and duration > 0 then
                local start, ending = startTime, startTime + duration
                return TestValue(start, ending, 0, ending, -1, comparator, limit)
            end
        else
            local count, start, ending = totemState:GetTotemCount(id, atTime)
            if count > 0 then
                return TestValue(start, ending, 0, ending, -1, comparator, limit)
            end
        end
        return Compare(0, comparator, limit)
    end

    OvaleCondition:RegisterCondition("totemremaining", false, TotemRemaining)
    OvaleCondition:RegisterCondition("totemremains", false, TotemRemaining)
end
do
    local Tracking = function(positionalParams, namedParams, state, atTime)
        local spellId, yesno = positionalParams[1], positionalParams[2]
        local spellName = OvaleSpellBook:GetSpellName(spellId)
        local numTrackingTypes = GetNumTrackingTypes()
        local boolean = false
        for i = 1, numTrackingTypes, 1 do
            local name, _, active = GetTrackingInfo(i)
            if name and name == spellName then
                boolean = (active == 1)
                break
            end
        end
        return TestBoolean(boolean, yesno)
    end

    OvaleCondition:RegisterCondition("tracking", false, Tracking)
end
do
    local TravelTime = function(positionalParams, namedParams, state, atTime)
        local spellId, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3]
        local si = spellId and OvaleData.spellInfo[spellId]
        local travelTime = 0
        if si then
            travelTime = si.travel_time or si.max_travel_time or 0
        end
        if travelTime > 0 then
            local estimatedTravelTime = 1
            if travelTime < estimatedTravelTime then
                travelTime = estimatedTravelTime
            end
        end
        return Compare(travelTime, comparator, limit)
    end

    OvaleCondition:RegisterCondition("traveltime", true, TravelTime)
    OvaleCondition:RegisterCondition("maxtraveltime", true, TravelTime)
end
do
    local True = function(positionalParams, namedParams, state, atTime)
        return 0, INFINITY
    end

    OvaleCondition:RegisterCondition("true", false, True)
end
do
    local WeaponDamage = function(positionalParams, namedParams, state, atTime)
        local hand = positionalParams[1]
        local comparator, limit
        local value = 0
        if hand == "offhand" or hand == "off" then
            comparator, limit = positionalParams[2], positionalParams[3]
            value = paperDollState.offHandWeaponDamage
        elseif hand == "mainhand" or hand == "main" then
            comparator, limit = positionalParams[2], positionalParams[3]
            value = paperDollState.mainHandWeaponDamage
        else
            comparator, limit = positionalParams[1], positionalParams[2]
            value = paperDollState.mainHandWeaponDamage
        end
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("weapondamage", false, WeaponDamage)
end
do
    local WeaponEnchantExpires = function(positionalParams, namedParams, state, atTime)
        local hand, seconds = positionalParams[1], positionalParams[2]
        seconds = seconds or 0
        local hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo()
        local now = GetTime()
        if hand == "mainhand" or hand == "main" then
            if hasMainHandEnchant then
                mainHandExpiration = mainHandExpiration / 1000
                return now + mainHandExpiration - seconds, INFINITY
            end
        elseif hand == "offhand" or hand == "off" then
            if hasOffHandEnchant then
                offHandExpiration = offHandExpiration / 1000
                return now + offHandExpiration - seconds, INFINITY
            end
        end
        return 0, INFINITY
    end

    OvaleCondition:RegisterCondition("weaponenchantexpires", false, WeaponEnchantExpires)
end
do
    local SigilCharging = function(positionalParams, namedParams, state, atTime)
        local charging = false
        for _, v in ipairs(positionalParams) do
            charging = charging or sigilState:IsSigilCharging(v, atTime)
        end
        return TestBoolean(charging, "yes")
    end

    OvaleCondition:RegisterCondition("sigilcharging", false, SigilCharging)
end
do
    local IsBossFight = function(positionalParams, namedParams, state, atTime)
        local bossEngaged = state.inCombat and OvaleBossMod:IsBossEngaged(state)
        return TestBoolean(bossEngaged, "yes")
    end

    OvaleCondition:RegisterCondition("isbossfight", false, IsBossFight)
end
do
    local Race = function(positionalParams, namedParams, state, atTime)
        local isRace = false
        local target = namedParams.target or "player"
        local _, targetRaceId = UnitRace(target)
        for _, v in ipairs(positionalParams) do
            isRace = isRace or (v == targetRaceId)
        end
        return TestBoolean(isRace, "yes")
    end

    OvaleCondition:RegisterCondition("race", false, Race)
end
do
    local UnitInRaidCond = function(positionalParams, namedParams, state, atTime)
        local target = namedParams.target or "player"
        local raidIndex = UnitInRaid(target)
        return TestBoolean(raidIndex ~= nil, "yes")
    end

    OvaleCondition:RegisterCondition("unitinraid", false, UnitInRaidCond)
end
do
    local SoulFragments = function(positionalParams, namedParams, state, atTime)
        local comparator, limit = positionalParams[1], positionalParams[2]
        local value = demonHunterSoulFragmentsState:SoulFragments(atTime)
        return Compare(value, comparator, limit)
    end

    OvaleCondition:RegisterCondition("soulfragments", false, SoulFragments)
end