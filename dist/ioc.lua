local __exports = LibStub:NewLibrary("ovale/ioc", 80201)
if not __exports then return end
local __class = LibStub:GetLibrary("tslib").newClass
local __Ovale = LibStub:GetLibrary("ovale/Ovale")
local OvaleClass = __Ovale.OvaleClass
local __Scripts = LibStub:GetLibrary("ovale/Scripts")
local OvaleScriptsClass = __Scripts.OvaleScriptsClass
local __Options = LibStub:GetLibrary("ovale/Options")
local OvaleOptionsClass = __Options.OvaleOptionsClass
local __PaperDoll = LibStub:GetLibrary("ovale/PaperDoll")
local OvalePaperDollClass = __PaperDoll.OvalePaperDollClass
local __ActionBar = LibStub:GetLibrary("ovale/ActionBar")
local OvaleActionBarClass = __ActionBar.OvaleActionBarClass
local __Artifact = LibStub:GetLibrary("ovale/Artifact")
local OvaleArtifactClass = __Artifact.OvaleArtifactClass
local __AST = LibStub:GetLibrary("ovale/AST")
local OvaleASTClass = __AST.OvaleASTClass
local __Aura = LibStub:GetLibrary("ovale/Aura")
local OvaleAuraClass = __Aura.OvaleAuraClass
local __AzeriteArmor = LibStub:GetLibrary("ovale/AzeriteArmor")
local OvaleAzeriteArmor = __AzeriteArmor.OvaleAzeriteArmor
local __AzeriteEssence = LibStub:GetLibrary("ovale/AzeriteEssence")
local OvaleAzeriteEssenceClass = __AzeriteEssence.OvaleAzeriteEssenceClass
local __BaseState = LibStub:GetLibrary("ovale/BaseState")
local BaseState = __BaseState.BaseState
local __BestAction = LibStub:GetLibrary("ovale/BestAction")
local OvaleBestActionClass = __BestAction.OvaleBestActionClass
local __Compile = LibStub:GetLibrary("ovale/Compile")
local OvaleCompileClass = __Compile.OvaleCompileClass
local __Condition = LibStub:GetLibrary("ovale/Condition")
local OvaleConditionClass = __Condition.OvaleConditionClass
local __Cooldown = LibStub:GetLibrary("ovale/Cooldown")
local OvaleCooldownClass = __Cooldown.OvaleCooldownClass
local __CooldownState = LibStub:GetLibrary("ovale/CooldownState")
local CooldownState = __CooldownState.CooldownState
local __DamageTaken = LibStub:GetLibrary("ovale/DamageTaken")
local OvaleDamageTakenClass = __DamageTaken.OvaleDamageTakenClass
local __Data = LibStub:GetLibrary("ovale/Data")
local OvaleDataClass = __Data.OvaleDataClass
local __DataBroker = LibStub:GetLibrary("ovale/DataBroker")
local OvaleDataBrokerClass = __DataBroker.OvaleDataBrokerClass
local __Debug = LibStub:GetLibrary("ovale/Debug")
local OvaleDebugClass = __Debug.OvaleDebugClass
local __DemonHunterSoulFragments = LibStub:GetLibrary("ovale/DemonHunterSoulFragments")
local OvaleDemonHunterSoulFragmentsClass = __DemonHunterSoulFragments.OvaleDemonHunterSoulFragmentsClass
local __DemonHunterSigils = LibStub:GetLibrary("ovale/DemonHunterSigils")
local OvaleSigilClass = __DemonHunterSigils.OvaleSigilClass
local __Enemies = LibStub:GetLibrary("ovale/Enemies")
local OvaleEnemiesClass = __Enemies.OvaleEnemiesClass
local __Equipment = LibStub:GetLibrary("ovale/Equipment")
local OvaleEquipmentClass = __Equipment.OvaleEquipmentClass
local __Frame = LibStub:GetLibrary("ovale/Frame")
local OvaleFrameModuleClass = __Frame.OvaleFrameModuleClass
local __Future = LibStub:GetLibrary("ovale/Future")
local OvaleFutureClass = __Future.OvaleFutureClass
local __GUID = LibStub:GetLibrary("ovale/GUID")
local OvaleGUIDClass = __GUID.OvaleGUIDClass
local __Health = LibStub:GetLibrary("ovale/Health")
local OvaleHealthClass = __Health.OvaleHealthClass
local __LastSpell = LibStub:GetLibrary("ovale/LastSpell")
local LastSpell = __LastSpell.LastSpell
local __LossOfControl = LibStub:GetLibrary("ovale/LossOfControl")
local OvaleLossOfControlClass = __LossOfControl.OvaleLossOfControlClass
local __Power = LibStub:GetLibrary("ovale/Power")
local OvalePowerClass = __Power.OvalePowerClass
local __Profiler = LibStub:GetLibrary("ovale/Profiler")
local OvaleProfilerClass = __Profiler.OvaleProfilerClass
local __Runes = LibStub:GetLibrary("ovale/Runes")
local OvaleRunesClass = __Runes.OvaleRunesClass
local __Score = LibStub:GetLibrary("ovale/Score")
local OvaleScoreClass = __Score.OvaleScoreClass
local __SpellBook = LibStub:GetLibrary("ovale/SpellBook")
local OvaleSpellBookClass = __SpellBook.OvaleSpellBookClass
local __SpellDamage = LibStub:GetLibrary("ovale/SpellDamage")
local OvaleSpellDamageClass = __SpellDamage.OvaleSpellDamageClass
local __SpellFlash = LibStub:GetLibrary("ovale/SpellFlash")
local OvaleSpellFlashClass = __SpellFlash.OvaleSpellFlashClass
local __Stagger = LibStub:GetLibrary("ovale/Stagger")
local OvaleStaggerClass = __Stagger.OvaleStaggerClass
local __Stance = LibStub:GetLibrary("ovale/Stance")
local OvaleStanceClass = __Stance.OvaleStanceClass
local __State = LibStub:GetLibrary("ovale/State")
local OvaleStateClass = __State.OvaleStateClass
local __Totem = LibStub:GetLibrary("ovale/Totem")
local OvaleTotemClass = __Totem.OvaleTotemClass
local __Variables = LibStub:GetLibrary("ovale/Variables")
local Variables = __Variables.Variables
local __Version = LibStub:GetLibrary("ovale/Version")
local OvaleVersionClass = __Version.OvaleVersionClass
local __Warlock = LibStub:GetLibrary("ovale/Warlock")
local OvaleWarlockClass = __Warlock.OvaleWarlockClass
local __conditions = LibStub:GetLibrary("ovale/conditions")
local OvaleConditions = __conditions.OvaleConditions
local __simulationcraftSimulationCraft = LibStub:GetLibrary("ovale/simulationcraft/SimulationCraft")
local OvaleSimulationCraftClass = __simulationcraftSimulationCraft.OvaleSimulationCraftClass
local __simulationcraftemiter = LibStub:GetLibrary("ovale/simulationcraft/emiter")
local Emiter = __simulationcraftemiter.Emiter
local __simulationcraftparser = LibStub:GetLibrary("ovale/simulationcraft/parser")
local Parser = __simulationcraftparser.Parser
local __simulationcraftunparser = LibStub:GetLibrary("ovale/simulationcraft/unparser")
local Unparser = __simulationcraftunparser.Unparser
local __simulationcraftsplitter = LibStub:GetLibrary("ovale/simulationcraft/splitter")
local Splitter = __simulationcraftsplitter.Splitter
local __Requirement = LibStub:GetLibrary("ovale/Requirement")
local OvaleRequirement = __Requirement.OvaleRequirement
__exports.IoC = __class(nil, {
    constructor = function(self)
        self.ovale = OvaleClass()
        self.options = OvaleOptionsClass(self.ovale)
        self.debug = OvaleDebugClass(self.ovale, self.options)
        self.profiler = OvaleProfilerClass(self.options, self.ovale)
        self.equipment = OvaleEquipmentClass(self.ovale, self.debug, self.profiler)
        self.lastSpell = LastSpell()
        self.paperDoll = OvalePaperDollClass(self.equipment, self.ovale, self.debug, self.profiler, self.lastSpell)
        self.baseState = BaseState()
        self.guid = OvaleGUIDClass(self.ovale, self.debug)
        self.requirement = OvaleRequirement(self.ovale, self.baseState, self.guid)
        self.data = OvaleDataClass(self.baseState, self.guid, self.ovale, self.requirement)
        self.spellBook = OvaleSpellBookClass(self.ovale, self.debug)
        self.cooldown = OvaleCooldownClass(self.paperDoll, self.data, self.lastSpell, self.ovale, self.debug, self.profiler, self.spellBook, self.requirement)
        self.cooldownState = CooldownState(self.cooldown, self.profiler, self.debug)
        self.demonHunterSigils = OvaleSigilClass(self.paperDoll, self.ovale, self.spellBook)
        self.demonHunterSoulFragments = OvaleDemonHunterSoulFragmentsClass(self.aura, self.ovale)
        self.enemies = OvaleEnemiesClass(self.guid, self.ovale, self.profiler, self.debug)
        self.state = OvaleStateClass()
        self.aura = OvaleAuraClass(self.state, self.paperDoll, self.baseState, self.data, self.guid, self.lastSpell, self.options, self.debug, self.ovale, self.profiler, self.spellBook, self.requirement)
        self.future = OvaleFutureClass(self.data, self.aura, self.paperDoll, self.baseState, self.cooldown, self.state, self.guid, self.lastSpell, self.ovale, self.debug, self.profiler, self.stance, self.requirement, self.spellBook)
        self.health = OvaleHealthClass(self.guid, self.baseState, self.ovale, self.options, self.debug, self.profiler, self.requirement)
        self.lossOfControl = OvaleLossOfControlClass(self.ovale, self.debug, self.requirement)
        self.azeriteEssence = OvaleAzeriteEssenceClass(self.ovale, self.debug)
        self.azeriteArmor = OvaleAzeriteArmor(self.equipment, self.ovale, self.debug)
        self.condition = OvaleConditionClass(self.baseState)
        self.scripts = OvaleScriptsClass(self.ovale, self.options, self.paperDoll)
        self.ast = OvaleASTClass(self.condition, self.debug, self.profiler, self.scripts, self.spellBook)
        self.score = OvaleScoreClass(self.ovale, self.future, self.debug, self.spellBook)
        self.compile = OvaleCompileClass(self.azeriteArmor, self.equipment, self.ast, self.condition, self.cooldown, self.paperDoll, self.data, self.profiler, self.debug, self.options, self.ovale, self.score, self.spellBook, self.stance)
        self.spellFlash = OvaleSpellFlashClass(self.options, self.ovale, self.future, self.data, self.spellBook, self.stance)
        self.power = OvalePowerClass(self.debug, self.ovale, self.profiler, self.data, self.future, self.baseState, self.aura, self.paperDoll, self.requirement)
        self.stagger = OvaleStaggerClass(self.ovale, self.future)
        self.stance = OvaleStanceClass(self.debug, self.ovale, self.profiler, self.data, self.requirement)
        self.totem = OvaleTotemClass(self.ovale, self.profiler, self.data, self.future, self.aura, self.spellBook)
        self.variables = Variables(self.future, self.baseState, self.debug)
        self.warlock = OvaleWarlockClass(self.ovale, self.aura, self.paperDoll, self.spellBook)
        self.version = OvaleVersionClass(self.ovale, self.options, self.debug)
        self.artifact = OvaleArtifactClass(self.debug)
        self.damageTaken = OvaleDamageTakenClass(self.ovale, self.profiler, self.debug)
        self.spellDamage = OvaleSpellDamageClass(self.ovale, self.profiler)
        self.demonHunterSoulFragments = OvaleDemonHunterSoulFragmentsClass(self.aura, self.ovale)
        self.conditions = OvaleConditions(self.condition, self.data, self.compile, self.paperDoll, self.ovale, self.artifact, self.azeriteArmor, self.azeriteEssence, self.aura, self.baseState, self.cooldown, self.future, self.spellBook, self.frame, self.guid, self.damageTaken, self.warlock, self.power, self.enemies, self.variables, self.lastSpell, self.equipment, self.health, self.options, self.lossOfControl, self.spellDamage, self.stagger, self.totem, self.demonHunterSigils, self.demonHunterSoulFragments, self.bestAction, self.runes, self.stance, self.bossMod)
        self.dataBroker = OvaleDataBrokerClass(self.paperDoll, self.frame, self.options, self.ovale, self.debug, self.scripts, self.version)
        self.actionBar = OvaleActionBarClass(self.debug, self.ovale, self.profiler, self.spellBook)
        self.bestAction = OvaleBestActionClass(self.equipment, self.actionBar, self.data, self.cooldown, self.state, self.baseState, self.paperDoll, self.compile, self.condition, self.ovale, self.guid, self.power, self.future, self.spellBook, self.profiler, self.debug, self.variables, self.runes)
        self.frame = OvaleFrameModuleClass(self.state, self.compile, self.future, self.baseState, self.enemies, self.ovale, self.options, self.debug, self.guid, self.spellFlash, self.spellBook, self.bestAction)
        self.runes = OvaleRunesClass(self.ovale, self.debug, self.profiler, self.data, self.power, self.paperDoll)
        self.unparser = Unparser(self.debug)
        self.emiter = Emiter(self.debug, self.ast, self.data, self.unparser)
        self.parser = Parser(self.debug)
        self.splitter = Splitter(self.ast, self.debug, self.data)
        self.simulationCraft = OvaleSimulationCraftClass(self.options, self.data, self.emiter, self.ast, self.parser, self.unparser, self.debug, self.compile, self.splitter, self.generator, self.ovale)
        self.state:RegisterState(self.cooldownState)
        self.state:RegisterState(self.paperDoll)
        self.state:RegisterState(self.baseState)
        self.state:RegisterState(self.demonHunterSigils)
        self.state:RegisterState(self.enemies)
        self.state:RegisterState(self.future)
        self.state:RegisterState(self.health)
        self.state:RegisterState(self.lossOfControl)
        self.state:RegisterState(self.power)
        self.state:RegisterState(self.stagger)
        self.state:RegisterState(self.stance)
        self.state:RegisterState(self.totem)
        self.state:RegisterState(self.variables)
        self.state:RegisterState(self.warlock)
        self.state:RegisterState(self.runes)
    end,
})
