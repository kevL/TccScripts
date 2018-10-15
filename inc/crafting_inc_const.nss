// 'crafting_inc_const'
//
// kevL 2014 may 23: moved these here from 'ginc_crafting'


// TCC Constants
const string TCC_CONFIG_2da		= "tcc_config";
const string TCC_SALVAGE_2da	= "tcc_salvage";

const string TCC_COL_VALUE		= "Value1";

// WARNING: Do not use these because they may cause a conflict with
// other const int's when the internal Gui-script compiler runs.
//
// TCC Config.2da rows
//const int TCC_Value_SalvageDCModifier				=  0;
//const int TCC_Toggle_AllowSetNameChange			=  1;
//const int TCC_Toggle_RequireCasterLevel			=  2;
//const int TCC_Toggle_RequireFeats					=  3;
//const int TCC_Toggle_LimitNumberOfProps			=  4;
//const int TCC_Value_GrantMasterworkBonusSlots		=  5;
//const int TCC_Value_BasePropSlots					=  6;
//const int TCC_Toggle_GrantMaterialBonusSlots		=  7;
//const int TCC_Value_DarksteelPropSlots			=  8;
//const int TCC_Value_MithralPropSlots				=  9;
//const int TCC_Value_SalamanderPropSlots			= 10;
//const int TCC_Value_UmberHulkPropSlots			= 11;
//const int TCC_Value_WyvernPropSlots				= 12;
//const int TCC_Value_DuskwoodPropSlots				= 13;
//const int TCC_Value_ShederranPropSlots			= 14;
//const int TCC_Value_AlchemicalSilverPropSlots		= 15;
//const int TCC_Value_ColdIronPropSlots				= 16;
//const int TCC_Value_AdamantinePropSlots			= 17;
//const int TCC_Value_ZalantarPropSlots				= 18;
//const int TCC_Value_RedDragonPropSlots			= 19;
//const int TCC_Value_WinterWolfPropSlots			= 20;
//const int TCC_Value_FireMephitPropSlots			= 21;
//const int TCC_Value_IceMephitPropSlots			= 22;
//const int TCC_Toggle_GrantLimitationBonusSlot		= 23;
//const int TCC_Toggle_LimitationPropsAreFree		= 24;
//const int TCC_Toggle_LightPropsAreFree			= 25;
//const int TCC_Toggle_VFXPropsAreFree				= 26;
//const int TCC_Toggle_SetPropsAreFree				= 27;
//const int TCC_Toggle_CreateMasterworkItems		= 28;
//const int TCC_Toggle_AllowItemSalvaging			= 29;
//const int TCC_Toggle_SalvagingRequiresMinSkill	= 30;
//const int TCC_Toggle_SalvagingUsesSkillCheck		= 31;
//const int TCC_Toggle_AllowEasyItemRenaming		= 32;
//const int TCC_Value_MasterworkSkillModifier		= 33;
//const int TCC_Toggle_UseRecipeExclusion			= 34;
//const int TCC_Toggle_UseVariableSlotCosts			= 35;
//const int TCC_Toggle_UseRecipeXPCosts				= 36;
//const int TCC_Toggle_UseRecipeGPCosts				= 37;
//const int TCC_Value_EpicCharacterBonusProp		= 38;

// TCC general vars
const string TCC_VAR_MASTERWORK		= "tcc_masterwork";
const string TCC_VAR_MATERIAL		= "tcc_material";

const string TCC_MASTER_TAG			= "_mast";

const string TCC_BONUS_ARMOR		= "Arm";
const string TCC_BONUS_RANGED		= "Ran";
const string TCC_BONUS_WEAPON		= "Wep";

const string TCC_BONUS				= "_Bonus";
const string TCC_ALLOW				= "_Allow";

// TCC Set Property vars
const string TCC_VAR_SET_CRAFTER	= "tcc_setcrafter";
const string TCC_VAR_SET_CONTAINER	= "tcc_setcontainer";

const string TCC_VAR_SET_LABEL		= "tcc_setlabel";
const string TCC_VAR_SET_NOT		= "tcc_setnot";

const string TCC_VAR_SET_GROUP_PRE	= "tcc_setgroup_";
const string TCC_VAR_SET_FLAG		= "tcc_setflag";

const string TCC_SET_TAG			= "tcc_setitem";


// TCC-types
// Note: types below that are commented out are NOT compared as ints against
// 'oItem's true basetype. Instead they are string-values under TAGS in
// Crafting.2da (and they specify 2+ of the *other* TCC-types). So I'm
// commenting them out here to avoid confusion; only constants that are defined
// here are possible returns from GetTccType() (a funct that converts 'oItem's
// true basetype to its corresponding TCC-type).
// NOTE: TCC_TYPE_EQUIPPABLE excludes Weapons/Armor/Shields (ie, left/right hand slots and chest slot).
//const int TCC_TYPE_EQUIPPABLE		= -2; // TCC_TYPE_HELMET, TCC_TYPE_AMULET, TCC_TYPE_BELT, TCC_TYPE_BOOTS, TCC_TYPE_GLOVES, TCC_TYPE_RING, TCC_TYPE_BRACER, TCC_TYPE_CLOAK
//const int TCC_TYPE_ANY			= -1; // Any. really: if "-1" is specified as the TAG then the basetype isn't even checked against.
const int TCC_TYPE_NONE				=  0; // special value ... is a return from GetTccType() for an invalid object AND is used in other ways here 'n there
const int TCC_TYPE_MELEE			=  1;
//const int TCC_TYPE_ARMOR_SHIELD	=  2; // TCC_TYPE_ARMOR, TCC_TYPE_SHIELD
const int TCC_TYPE_BOW				=  3;
const int TCC_TYPE_XBOW				=  4;
const int TCC_TYPE_SLING			=  5;
const int TCC_TYPE_AMMO				=  6;
const int TCC_TYPE_ARMOR			=  7;
const int TCC_TYPE_SHIELD			=  8;
const int TCC_TYPE_OTHER			=  9;
//const int TCC_TYPE_RANGED			= 10; // TCC_TYPE_BOW, TCC_TYPE_XBOW, TCC_TYPE_SLING
//const int TCC_TYPE_WRISTS			= 11; // TCC_TYPE_GLOVES, TCC_TYPE_BRACER
const int TCC_TYPE_INSTRUMENT		= 15;
const int TCC_TYPE_CONTAINER		= 16;

const int TCC_TYPE_HELMET			= 17; // = BASE_ITEM_HELMET // these integers are equivalent to corresponding basetypes in BaseItems.2da ->
const int TCC_TYPE_AMULET			= 19; // = BASE_ITEM_AMULET
const int TCC_TYPE_BELT				= 21; // = BASE_ITEM_BELT
const int TCC_TYPE_BOOTS			= 26; // = BASE_ITEM_BOOTS
const int TCC_TYPE_GLOVES			= 36; // = BASE_ITEM_GLOVES
const int TCC_TYPE_RING				= 52; // = BASE_ITEM_RING
const int TCC_TYPE_BRACER			= 78; // = BASE_ITEM_BRACER
const int TCC_TYPE_CLOAK			= 80; // = BASE_ITEM_CLOAK


// WARNING: Do not use these because they may cause a conflict with
// other const int's when the internal Gui-script compiler runs.
//
// material types
//const int MAT_NUL =  0; // none.
//const int MAT_ADA =  1; // "_ada_"
//const int MAT_CLD =  2; // "_cld_"
//const int MAT_DRK =  3; // "_drk_"
//const int MAT_DSK =  4; // "_dsk_"
//const int MAT_MTH =  5; // "_mth_"
//const int MAT_RDH =  6; // "_rdh_"
//const int MAT_SHD =  7; // "_shd_"
//const int MAT_SLH =  8; // "_slh_"
//const int MAT_SLV =  9; // "_slv_"
//const int MAT_UHH = 10; // "_uhh_"
//const int MAT_WYH = 11; // "_wyh_"
//const int MAT_ZAL = 12; // "_zal_"
//const int MAT_WWF = 13; // "_wwf_"
//const int MAT_FMP = 14; // "_fmp_"
//const int MAT_IMP = 15; // "_imp_"



// -----------------------------------------------------------------------------
// Constants
// -----------------------------------------------------------------------------
const string DIGITS							= "0123456789"; // for isSpellId()

const string ENCODED_IP_LIST_DELIMITER		= ";";
const string REAGENT_LIST_DELIMITER			= ",";

const string MUNDANE_RECIPE_TRIGGER			= "n2_crft_mold"; // tag of weapon/armor molds must always have this prefix.
const string ALCHEMY_RECIPE_TRIGGER			= "ALC";
const string DISTILLATION_RECIPE_TRIGGER	= "DIS";

//const string VAR_RECIPE_SPELLID_LIST		= "RECIPE_SPELLID_LIST";	// list of SpellID indexes
//const string VAR_RECIPE_RESREF_LIST 		= "RECIPE_RESREF_LIST"; 	// list of mold resref indexes

//const string VAR_ROW_NUMBER 				= "ROW_NUMBER"; 			// 2da row
//const string VAR_RECIPE_2DA_INDEXES 		= "RECIPE_2DA_INDEXES"; 	// list of info for index 2da

const string CRAFTING_2DA					= "crafting";	// Crafting.2da
const string COL_CRAFTING_CATEGORY			= "CATEGORY";	// magical/wondrous, mundane, alchemy, distillation
const string COL_CRAFTING_REAGENTS			= "REAGENTS";	// magical/wondrous, mundane, alchemy, distillation
const string COL_CRAFTING_TAGS				= "TAGS";		// magical/wondrous (Items Affected)
const string COL_CRAFTING_EFFECTS			= "EFFECTS";	// magical/wondrous (Encoded Effect)
const string COL_CRAFTING_OUTPUT			= "OUTPUT"; 	// magical/wondrous, mundane, alchemy, distillation
const string COL_CRAFTING_CRAFT_SKILL		= "SKILL";		// magical/wondrous (Feat), mundane (skill)
const string COL_CRAFTING_SKILL_LEVEL		= "LEVEL";		// magical/wondrous (caster level), mundane (skill level), alchemy (alchemy level), distillation (alchemy level)

const string CRAFTING_INDEX_2DA 			= "crafting_index";	// Crafting_Index.2da
const string COL_CRAFTING_START_ROW 		= "START_ROW";

const string ITEM_PROP_DEF_2DA				= "itempropdef";	// ItemPropDef.2da
const string COL_ITEM_PROP_DEF_SLOTS		= "Slots";

// Error codes - string refs
const int ERROR_ITEM_NOT_DISTILLABLE					= 174285; // "Distillation failed! This is not a distillable item."
const int ERROR_MISSING_REQUIRED_MOLD					= 174286; // "Crafting failed! No mold found."
const int ERROR_RECIPE_NOT_FOUND						= 174287; // "Crafting failed! This is not a valid recipe."
const int ERROR_TARGET_NOT_FOUND_FOR_RECIPE 			= 174288; // "Crafting failed! No base armor or weapon to be enchanted found."
const int ERROR_INSUFFICIENT_CASTER_LEVEL				= 174289; // "Crafting failed! Your caster level is not high enough to craft this item."
const int ERROR_INSUFFICIENT_CRAFT_ALCHEMY_SKILL		= 174290; // "Crafting failed! You do not have enough ranks in Craft Alchemy."
const int ERROR_INSUFFICIENT_CRAFT_ARMOR_SKILL			= 174291; // "Crafting failed! You do not have enough ranks in Craft Armor."
const int ERROR_INSUFFICIENT_CRAFT_WEAPON_SKILL 		= 174293; // "Crafting failed! You do not have enough ranks in Craft Weapon."
const int ERROR_INSUFFICIENT_CRAFT_TRAP_SKILL			= 208635; // "Crafting failed! You do not have enough ranks in Craft Trap."
//const int ERROR_NO_CRAFT_WONDROUS_FEAT				= 174294; // "Crafting failed! You do not have the Craft Wondrous Item feat."
//const int ERROR_NO_CRAFT_MAGICAL_FEAT					= 174295; // "Crafting failed! You do not have the Craft Magic Arms and Armor feat."
const int OK_CRAFTING_SUCCESS							= 174296; // "Crafting succeeded!"
const int ERROR_TARGET_HAS_MAX_ENCHANTMENTS 			= 182996; // "Item can not be further enchanted."
const int ERROR_TARGET_HAS_MAX_ENCHANTMENTS_NON_EPIC	= 207914; // "Item cannot be further enchanted. (Only an epic character can further enchant this item)"
const int ERROR_TARGET_NOT_LEGAL_FOR_EFFECT 			= 207917; // "Not a valid enchantment for that particular type of item."

const int ERROR_UNRECOGNIZED_HAMMER_USAGE				= 183205; // "The smith hammer must be used on a blacksmith's workbench."
const int ERROR_UNRECOGNIZED_MORTAR_USAGE				= 183206; // "The mortar & pestle must be used on an alchemist's workbench or on an item."

// this variable is stored on the Module so that scripts
// "gui_name_enchanted_item" and "gui_name_enchanted_item_cancel"
// can retrieve a reference to the item-object.
const string VAR_ENCHANTED_ITEM_OBJECT = "EnchantedObject";

// Standard Workbench Tag Prefixes
const int TAG_PREFIX_LENGTH = 13;

const string TAG_WORKBENCH_PREFIX1	= "PLC_MC_WBENCH";
const string TAG_WORKBENCH_PREFIX2	= "PLC_MC_CBENCH";

// Alchemy Workbench tags
const string TAG_ALCHEMY_BENCH1 	= "alchemy_bench";
const string TAG_ALCHEMY_BENCH2 	= "PLC_MC_CBENCH01";
const string TAG_ALCHEMY_BENCH3 	= "alchemy";
const string TAG_ALCHEMY_BENCH4 	= "PLC_MR_AWBench";

// Blacksmith Workbench tags
const string TAG_WORKBENCH1 		= "workbench";
const string TAG_WORKBENCH2 		= "PLC_MC_CBENCH02";
const string TAG_WORKBENCH3 		= "blacksmith";
const string TAG_WORKBENCH4 		= "PLC_MR_WWBench";

// Magical Workbench tags
const string TAG_MAGICAL_BENCH1 	= "magical_bench";
const string TAG_MAGICAL_BENCH2 	= "PLC_MC_CBENCH03";
const string TAG_MAGICAL_BENCH3 	= "magical";
const string TAG_MAGICAL_BENCH4 	= "PLC_MR_MWBench";

// workbench vars - set to 1 to indicate workbench
const string VAR_ALCHEMY			= "WB_alchemy";
const string VAR_BLACKSMITH 		= "WB_blacksmith";
const string VAR_MAGICAL			= "WB_magical";

// labels for using the MotB enchanter's satchel
const string SATCHEL_VAR_CRAFTER	= "SatchelCrafter";
const string SATCHEL_VAR_SPELLID	= "SatchelSpellId";

// labels for handling the Imbue_Item triggerspell GUI
const string II_VAR_CONTAINER		= "ii_CraftContainer";
const string II_VAR_CRAFTER			= "ii_CraftCrafter";
const string II_VAR_SPELLID			= "ii_CraftSpellId";


// -----------------------------------------------------------------------------
// extra Constants
// -----------------------------------------------------------------------------
const string SPELL_IMBUE_ITEM_ST = "1081";

// spellIds:
const int SPELL_IMBUE_ITEM					= 1081;

const int SPELL_SHAPERS_ALEMBIC_DIVIDE		= 1098;
const int SPELL_SHAPERS_ALEMBIC_COMBINE		= 1099;
const int SPELL_SHAPERS_ALEMBIC_CONVERT		= 1100;

// baseItems:
const int BASE_ITEM_BALORSWORD		= 82;
const int BASE_ITEM_BALORFALCHION	= 83;
const int BASE_ITEM_STEIN			= 127;
const int BASE_ITEM_BAG				= 131;
const int BASE_ITEM_SPOON			= 138;
