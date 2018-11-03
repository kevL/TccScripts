// 'ginc_crafting'
/*
	Crafting related functions
*/
// ChazM 12/15/05
// kL 16.09.28 - rewritten.


// _______________
// ** INCLUDES ***
//----------------
#include "ginc_item"			// GetIsEquippable()
//#include "x2_inc_itemprop"	// IPSafeAddItemProperty(), IPGetIsMeleeWeapon(), IPGetWeaponEnhancementBonus()
								// X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING
#include "ginc_param_const"		// GetIntParam(), GetStringParam()
#include "ginc_2da"				// GetIsLegalItemProp()
#include "x2_inc_switches"		// CAMPAIGN_SWITCH_CRAFTING_USE_TOTAL_LEVEL
#include "crafting_inc_const"

//#include "x0_i0_stringlib"	// Sort(), FindListElementIndex(), GetNumberTokens(), GetTokenByPosition(),
								// GetStringTokenizer(), HasMoreTokens(), AdvanceToNextToken(), GetNextToken()

// ______________
// ** STRUCTS ***
// --------------
// A container for defining 2da ranges.
struct range2da
{
	int first;
	int last;
};


// ________________
// ** CONSTANTS ***
// ----------------
const int TELLCRAFT = FALSE; // toggle for debug.


// ___________________
// ** DECLARATIONS ***
// -------------------

// Debug function for printing feedback to chat and logfile.
void TellCraft(string sText);

// Notifies the player of success or failure-type.
void NotifyPlayer(object oCrafter,
				  int iStrRef = OK_CRAFTING_SUCCESS,
				  string sInfo = "");


// -----------------------------------------------------------------------------
// functions that check for valid placeable-containers:

// Checks if oTarget is any of the 3 valid bench-types (magical/smith/alchemy).
int IsWorkbench(object oTarget);

// Checks if oTarget is a valid Magical Workbench (trigger = spell).
int IsMagicalWorkbench(object oTarget);
// Checks if oTarget is a valid Smith Workbench (trigger = smithhammer).
int IsSmithWorkbench(object oTarget);
// Checks if oTarget is a valid Alchemy Workbench (trigger = mortar & pestle).
int IsAlchemyWorkbench(object oTarget);


// -----------------------------------------------------------------------------
// public functions for crafting:

// Does crafting at a Magical Workbench with a triggerspell.
void DoMagicCrafting(int iSpellId, object oCrafter);

// Does crafting at a Smith Workbench with a smith's hammer.
void DoMundaneCrafting(object oCrafter);

// Does crafting at an Alchemy Workbench with a mortar & pestle.
void DoAlchemyCrafting(object oCrafter);

// Distills oItem when mortar & pestle is used directly on it.
void DoDistillation(object oItem, object oCrafter);

// Helper for DoDistillation() -- but also used directly by the mortar & pestle
// on Fairy Dust and Shadow Reaver Bones.
void ExecuteDistillation(int iSkillRankReq,
						 object oItem,
						 object oCrafter,
						 string sResrefList);


// -----------------------------------------------------------------------------
// functions for general crafting:

// Gets the row of Crafting.2da that matches input-variables.
int GetInventoryRecipeMatch(string sTrigger, object oItem = OBJECT_INVALID);
// Gets all reagents sorted into an alphabetical list (case-sensitive).
string GetSortedReagents(int bEnchant = FALSE, object oContainer = OBJECT_SELF);
// Gets a list of tags for any stacksize of oItem.
string GetRepeatTags(object oItem);
// Gets the first row in Crafting.2da that's within a determined range of rows
// and that matches sReagentTags, sTrigger, and is the correct TCC-type (TAGS).
int GetRecipeMatch(string sReagentTags,
				   string sTrigger,
				   object oItem = OBJECT_INVALID);
// Gets a list of comma-delimited indices into Crafting.2da that will be valid
// recipes for SPELL_IMBUE_ITEM.
string GetRecipeMatches(object oItem);
// Finds and effectively deletes Crafting.2da indices that given the same
// reagents would result in the same applied-ip or construction-resref.
string PruneRecipeMatches(string sRecipeMatches, string sCol);
// Takes a list of Crafting.2da indices and tells player what the candidate
// triggers for SPELL_IMBUE_ITEM are.
int ParseRecipeMatches(string sRecipeMatches, object oCrafter);
// Gets the first and last rows in Crafting.2da for sTrigger.
struct range2da GetTriggerRange(string sTrigger);
// Gets the first row for sTrigger in Crafting.2da.
int GetTriggerStart(string sTrigger);
// Checks if sTrigger is a spell-ID (is purely numeric).
int isSpellId(string sTrigger);
// Finds the first match in Crafting.2da for a sorted string of reagent-tags.
int SearchForReagents(string sReagentTags, int iStartRow, int iStopRow);
// Checks if the type of oItem matches permitted values in Crafting.2da TAGS.
int isTypeMatch(object oItem, string sTypes);
// Gets the TCC-type of oItem.
int GetTccType(object oItem);

// Destroys all items in oContainer that are not equippable.
void DestroyItemsInInventory(int bEnchant = FALSE, object oContainer = OBJECT_SELF);
// Creates the items of sResrefList in the inventory of oContainer.
void CreateListOfItemsInInventory(string sResrefList,
								  object oContainer = OBJECT_SELF,
								  int bIdentify = TRUE,
								  int bMasterwork = FALSE,
								  int bFullStack = FALSE);


// -----------------------------------------------------------------------------
// private functions for Magical Crafting:

// Gets the first equippable item in the crafting-container if any.
object GetFirstEquippableItem(object oContainer = OBJECT_SELF);
// Checks if oItem should be excepted and not considered an equippable item.
int isInExceptionList(object oItem);
// Gets if oItem has an ip that excludes that of iRecipeMatch.
int hasExcludedProp(object oItem, int iRecipeMatch);
// Gets the material of oItem if any.
int GetMaterialCode(object oItem);
// Gets the quantity of ip's of iPropType on oItem.
int GetQtyPropsOfType(object oItem, int iPropType);

// Clears a corresponding Attack bonus when upgrading to an Enhancement bonus
// that is equal or greater.
int ReplaceAttackBonus(object oItem,
					   int iPropType,
					   int iCost,
					   int iSubtype);
// Clears iPropType from oItem if iCost is higher or equal to existing CostValue.
int ClearIpType(object oItem,
				int iPropType,
				int iCost,
				int iSubtype = -1);

// Searches oItem for an ip similar to ipProp.
int isIpUpgrade(object oItem, itemproperty ipProp);
// Gets variable prop-costs already used on oItem.
int GetCostSlotsUsed(object oItem);
// Gets the quantity of ip's on oItem.
int GetPropSlotsUsed(object oItem);

// Checks if an already existing ip should be ignored.
int isIgnoredIp(itemproperty ip);
// Checks if adding an ip should ignore subtype.
int isIgnoredSubtype(itemproperty ip);
// Checks for +1 attack bonus on Masterwork weapons.
int hasMasterworkAttackBonus(object oItem);

// Converts an EncodedIP and returns a constructed IP.
itemproperty GetItemPropertyByID(int iType, int iPar1 = 0, int iPar2 = 0, int iPar3 = 0, int iPar4 = 0);


// -----------------------------------------------------------------------------
// functions for Property Sets:

// Gets the quantity of Property Set latent-ip strings stored on oItem.
int GetQtyLatentIps(object oItem);
// Sets the group of a Property Set to indicate that the next ip added should be
// part of that Set.
void SetLatentPartReady(object oItem, int iGroup);
// Gets the group of the Property Set that's about to be added to oItem.
int GetLatentPartReady(object oItem);
// Adds sEncodedIp to oItem.
void AddLatentIp(object oItem,
				 int iGroup,
				 string sEncodedIp,
				 object oCrafter);

// Gets the quantity of equipped parts of the specified Property Set.
int GetQtyLatentPartsEquipped(string sSetLabel, object oPC);
// Activates or deactivates Property Set ip's of the appropriate group.
void ToggleSetGroup(string sSetLabel, int iPartsEquipped, object oPC);
// Clears all active Property Set ip's from oItem.
void DeactivateLatentIps(object oItem);
// Adds the Property Set ip if any of the specified group.
void ActivateLatentIp(object oItem, int iLevel, object oPC);


// -----------------------------------------------------------------------------
// private functions for salvage operations:

// Scans the ip's of oItem and produces salvaged materials.
void ExecuteSalvage(object oItem, object oCrafter);

// -----------------------------------------------------------------------------
// helper functions for salvaging:

// Gets the index of the salvage row associated with ipProp.
int GetSalvageIndex(itemproperty ipProp);
// Gets the salvage grade for ipProp.
int GetSalvageGrade(itemproperty ipProp, int iIndex);
// Gets the skill DC related by iIndex and iGrade.
int GetSalvageDC(int iIndex, int iGrade);
// Gets the tag of the essence related by iIndex and iGrade.
string GetSalvageEssence(int iIndex, int iGrade);
// Gets the tag of the gem related by iIndex and iGrade.
string GetSalvageGem(int iIndex, int iGrade);


// -----------------------------------------------------------------------------
// functions that invoke GUI-inputboxes:

// Invokes a GUI-inputbox for player to relabel oItem.
void SetEnchantedItemName(object oCrafter, object oItem);

// Opens a GUI inputbox for entering an Imbue_Item triggerspell.
void SetTriggerSpell(object oCrafter);

// Opens a GUI-inputbox that allows player to label a Set.
void ConstructSet(object oCrafter);


// -----------------------------------------------------------------------------
// public functions for mortar & pestle and shaper's alembic:

// Sets up a list of up to 10 elements.
string MakeList(string sReagent1,
				string sReagent2  = "",
				string sReagent3  = "",
				string sReagent4  = "",
				string sReagent5  = "",
				string sReagent6  = "",
				string sReagent7  = "",
				string sReagent8  = "",
				string sReagent9  = "",
				string sReagent10 = "");


// -----------------------------------------------------------------------------
// functions for SoZ crafting:

// Checks if all sEncodedIps qualify as an upgrade.
int GetAreAllEncodedEffectsAnUpgrade(object oItem, string sEncodedIps);
// Checks if sEncodedIp is an upgrade.
int GetIsEncodedEffectAnUpgrade(object oItem, string sEncodedIp);
// Constructs an ip from sEncodedIp.
itemproperty GetEncodedEffectItemProperty(string sEncodedIp);
// Gets whether ip will be treated as an upgrade.
int GetIsItemPropertyAnUpgrade(object oItem, itemproperty ip);
// Applies all sEncodedIps to oItem.
void ApplyEncodedEffectsToItem(object oItem, string sEncodedIps);
// Adds sEncodedIp to oItem.
void AddEncodedIp(object oItem, string sEncodedIp);


// -----------------------------------------------------------------------------
// functions that were factored into others or are unused:

//
//string MakeEncodedEffect(int iPropType, int iPar1 = 0, int iPar2 = 0, int iPar3 = 0, int iPar4 = 0);
//
//void AddItemPropertyAutoPolicy(object oItem, itemproperty ip, float fDuration = 0.f);

// revised enchantment targeting
// not used.
//object GetEnchantmentTarget(string sTagList, object oContainer);


// __________________
// ** DEFINITIONS ***
// ------------------

// Debug function for printing feedback to chat and logfile.
void TellCraft(string sText)
{
	if (TELLCRAFT)
	{
		PrintString(sText);
		SendMessageToPC(GetFirstPC(FALSE), sText);
	}
}

// Notifies the player of success or failure-type.
// - if (iStrRef=-1) then send player sInfo
void NotifyPlayer(object oCrafter,
				  int iStrRef = OK_CRAFTING_SUCCESS,
				  string sInfo = "")
{
	if (iStrRef != -1)
		SendMessageToPCByStrRef(oCrafter, iStrRef);
	else
		SendMessageToPC(oCrafter, sInfo);
}


// -----------------------------------------------------------------------------
// functions that check for valid placeable-containers
// -----------------------------------------------------------------------------

// Checks if oTarget is any of the 3 valid bench-types (magical/smith/alchemy).
int IsWorkbench(object oTarget)
{
	if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{
		string sTagPre = GetStringLeft(GetTag(oTarget), TAG_PREFIX_LENGTH);
		if (sTagPre == TAG_WORKBENCH_PREFIX1 || sTagPre == TAG_WORKBENCH_PREFIX2)
			return TRUE;
	}

	if (   IsMagicalWorkbench(oTarget)
		|| IsSmithWorkbench(oTarget)
		|| IsAlchemyWorkbench(oTarget))
	{
		return TRUE;
	}

	return FALSE;
}

// Checks if oTarget is a valid Magical Workbench (trigger = spell).
// - magical workbench can be identified by its tag or by a local variable
int IsMagicalWorkbench(object oTarget)
{
	if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{
		if (GetLocalInt(oTarget, VAR_MAGICAL))
			return TRUE;

		string sTargetTag = GetTag(oTarget);
		if (   sTargetTag == TAG_MAGICAL_BENCH1
			|| sTargetTag == TAG_MAGICAL_BENCH2
			|| sTargetTag == TAG_MAGICAL_BENCH3
			|| sTargetTag == TAG_MAGICAL_BENCH4)
		{
			return TRUE;
		}
	}

	return FALSE;
}

// Checks if oTarget is a valid Smith Workbench (trigger = smithhammer).
// - smith workbench can be identified by its tag or by a local variable
int IsSmithWorkbench(object oTarget)
{
	if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{
		if (GetLocalInt(oTarget, VAR_BLACKSMITH))
			return TRUE;

		string sTargetTag = GetTag(oTarget);
		if (   sTargetTag == TAG_WORKBENCH1
			|| sTargetTag == TAG_WORKBENCH2
			|| sTargetTag == TAG_WORKBENCH3
			|| sTargetTag == TAG_WORKBENCH4)
		{
			return TRUE;
		}
	}

	return FALSE;
}

// Checks if oTarget is a valid Alchemy Workbench (trigger = mortar & pestle).
// - alchemy workbench can be identified by its tag or by a local variable
int IsAlchemyWorkbench(object oTarget)
{
	if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{
		if (GetLocalInt(oTarget, VAR_ALCHEMY))
			return TRUE;

		string sTargetTag = GetTag(oTarget);
		if (   sTargetTag == TAG_ALCHEMY_BENCH1
			|| sTargetTag == TAG_ALCHEMY_BENCH2
			|| sTargetTag == TAG_ALCHEMY_BENCH3
			|| sTargetTag == TAG_ALCHEMY_BENCH4)
		{
			return TRUE;
		}
	}

	return FALSE;
}


// -----------------------------------------------------------------------------
// public functions for crafting
// -----------------------------------------------------------------------------
// kL: TODO
/* int GetPrestigeCasterLevelByClassLevel(int nClass, int nClassLevel, object oTarget); 'cmi_includes'

int GetWarlockCasterLevel(object oCaster); 'cmi_ginc_spells'
int GetBlackguardCasterLevel(object oCaster);
int GetAssassinCasterLevel(object oCaster);

int GetPalRngCasterLevel(object oCaster = OBJECT_SELF); 'cmi_ginc_palrng'
int GetCasterLevelForPaladins(object oCaster = OBJECT_SELF);
int GetCasterLevelForRangers(object oCaster = OBJECT_SELF);
int GetRawPaladinCasterLevel(object oCaster = OBJECT_SELF);
int GetRawRangerCasterLevel(object oCaster = OBJECT_SELF);

int GetBardicClassLevelForUses(object oCrafter); 'cmi_ginc_chars'
int GetBardicClassLevelForSongs(object oCrafter);
*/
// ____________________________________________________________________________
//  ----------------------------------------------------------------------------
//   MAGICAL CRAFTING
// ____________________________________________________________________________
//  ----------------------------------------------------------------------------

// __________________
// ** SCRIPT VARS ***
// ------------------
int _iRecipeMatch_ii;


// Does crafting at a Magical Workbench with a spell trigger.
// - this covers two types of crafting:
// 1. Enchanting Item requires a set of reagents, an item to work on, and a
//    spell to activate it.
// 2. Constructing Item requires a set of reagents and creates a new item.
// - reagents cannot be equippable items including weapons, armor, shields,
//   rings, amulets, etc. because those are ignored when looking at reagent
//   components (unless they're in the exclusion list); if more than 1 equippable
//   item is included with the reagents the one that will be inspected/affected
//   is not defined.
void DoMagicCrafting(int iSpellId, object oCrafter)
{
	TellCraft("DoMagicCrafting() " + GetName(OBJECT_SELF) + " ( " + GetTag(OBJECT_SELF) + " )");
	TellCraft(". id= " + IntToString(iSpellId));
	TellCraft(". crafter : " + GetName(oCrafter));

	// Exit w/out message if there is no item in the bench/satchel
	if (!GetIsObjectValid(GetFirstItemInInventory()))
		return;

	// Enchanting occurs on the first equippable item if found
	object oItem = GetFirstEquippableItem();
	TellCraft(". oItem : " + GetName(oItem) + " ( " + GetTag(oItem) + " )");

	_iRecipeMatch_ii = -2; // init.

	if (iSpellId == SPELL_IMBUE_ITEM)
	{
		// Bypass SetTriggerSpell() GUI if there are no matches or there is only one match
		// - if no matches let regular code handle it
		// - if only one match set 'iRecipeMatch' with the script-var '_iRecipeMatch_ii'
		//   in ParseRecipeMatches() and proceed ...
		string sRecipeMatches = GetRecipeMatches(oItem);
		TellCraft(". . IMBUE_ITEM : sRecipeMatches= " + sRecipeMatches);
		if (sRecipeMatches != "")
		{
			string sCol;
			if (GetIsObjectValid(oItem))
				sCol = COL_CRAFTING_EFFECTS;
			else
				sCol = COL_CRAFTING_OUTPUT;

			sRecipeMatches = PruneRecipeMatches(sRecipeMatches, sCol);
			TellCraft(". . . pruned sRecipeMatches= " + sRecipeMatches);

			if (ParseRecipeMatches(sRecipeMatches, oCrafter) > 1)
			{
				TellCraft(". . . . call SetTriggerSpell() & exit");
				SetTriggerSpell(oCrafter);
				return;
			}

			// '_iRecipeMatch_ii' was set by ParseRecipeMatches()
			// assign it to 'iRecipeMatch' below
			TellCraft(". . . . only 1 trigger for Imbue_Item : proceed w/ recipe");
		}
		else
		{
			_iRecipeMatch_ii = -1;
			TellCraft(". . . no trigger for Imbue_Item : exit");
		}
	}

	int iRecipeMatch;
	switch (_iRecipeMatch_ii)
	{
		case -2:
			iRecipeMatch = GetInventoryRecipeMatch(IntToString(iSpellId), oItem); // for regular SpellId.
			break;
		case -1:
			iRecipeMatch = -1; // for Imbue_Item w/ no matches.
			break;
		default:
			iRecipeMatch = _iRecipeMatch_ii; // for Imbue_Item w/ only one match.
	}

	TellCraft(". iRecipeMatch= " + IntToString(iRecipeMatch));

	if (iRecipeMatch == -1 || StringToInt(Get2DAString(CRAFTING_2DA, "DISABLE", iRecipeMatch)))
	{
		NotifyPlayer(oCrafter, ERROR_RECIPE_NOT_FOUND);
		return;
	}

	// +++ check additional criteria +++

	// Check if caster is of sufficient level
	int iCasterLevel = GetCasterLevel(oCrafter);
	if (GetGlobalInt(CAMPAIGN_SWITCH_CRAFTING_USE_TOTAL_LEVEL))
	{
		int iTotalLevel = GetTotalLevels(oCrafter, FALSE);
		if (iCasterLevel < iTotalLevel)
			iCasterLevel = iTotalLevel;
	}
	TellCraft(". iCasterLevel= " + IntToString(iCasterLevel));
	TellCraft(". iCasterLevel required= " + Get2DAString(CRAFTING_2DA, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch));

	if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 2)) // TCC_Toggle_RequireCasterLevel
		&& iCasterLevel < StringToInt(Get2DAString(CRAFTING_2DA, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch)))
	{
		NotifyPlayer(oCrafter, ERROR_INSUFFICIENT_CASTER_LEVEL);
		return;
	}

	int iTccType = GetTccType(oItem);
	TellCraft(". iTccType= " + IntToString(iTccType));

	// Check if caster has the required feat if any
	if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 3))) // TCC_Toggle_RequireFeats
	{
		string sFeat = Get2DAString(CRAFTING_2DA, COL_CRAFTING_CRAFT_SKILL, iRecipeMatch);
		int iFeat = StringToInt(sFeat);
		if (sFeat == ""
			|| iFeat == -1	// TODO: update Crafting.2da column ("SKILL") values that currently read "0" to "-1" OR "****".
			|| iFeat ==  0)	// <- 0 is Alertness but should be removed altogether, both here and in the 2da.
		{
			switch (iTccType)
			{
				case TCC_TYPE_ARMOR:
				case TCC_TYPE_SHIELD:
				case TCC_TYPE_BOW:
				case TCC_TYPE_XBOW:
				case TCC_TYPE_SLING:
				case TCC_TYPE_AMMO:
				case TCC_TYPE_MELEE:
					iFeat = FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR;
					break;

				case TCC_TYPE_HELMET:
				case TCC_TYPE_AMULET:
				case TCC_TYPE_BELT:
				case TCC_TYPE_BOOTS:
				case TCC_TYPE_GLOVES:
				case TCC_TYPE_RING:
				case TCC_TYPE_BRACER:
				case TCC_TYPE_CLOAK:
				case TCC_TYPE_INSTRUMENT:
				case TCC_TYPE_CONTAINER:
				case TCC_TYPE_OTHER: // "Other" should never happen (perhaps).
					iFeat = FEAT_CRAFT_WONDROUS_ITEMS;
					break;

				default:
				case TCC_TYPE_NONE:	// <- construct "OUTPUT" Resref - these *need* a value
					break;			// under Crafting.2da "SKILL" ("0" won't cut it, see TODO above^)
			}
		}
		TellCraft(". iFeat= " + IntToString(iFeat));

		if (!GetHasFeat(iFeat, oCrafter))
		{
			int iFeatTitle = StringToInt(Get2DAString("feat", "FEAT", iFeat));
			string sError = "Crafting failed ! You do not have the " + GetStringByStrRef(iFeatTitle) + " feat.";
			NotifyPlayer(oCrafter, -1, sError);
			return;
/*			int iError;
			switch (iFeat)
			{
				case FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR:
					iError = ERROR_NO_CRAFT_MAGICAL_FEAT; break;
				case FEAT_CRAFT_WONDROUS_ITEMS:
					iError = ERROR_NO_CRAFT_WONDROUS_FEAT; break;
				default:
					iError = -1;
			}
			switch (iError)
			{
				case -1: SendMessageToCrafter(oCrafter, "You don't have the required Feat.");
					break;
				default: NotifyPlayer(oCrafter, iError);
			} */
		}
	}

	// Check gold if required
	object oOwnedPC = GetOwnedCharacter(oCrafter);

	int iGPCost = 0;
	if (Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 37) != "0") // TCC_Toggle_UseRecipeGPCosts
		iGPCost = StringToInt(Get2DAString(CRAFTING_2DA, "GP", iRecipeMatch));
	TellCraft(". iGPCost= " + IntToString(iGPCost));

	if (iGPCost > GetGold(oOwnedPC))
	{
		NotifyPlayer(oCrafter, -1, "You don't have enough gold to create that.");
		return;
	}

	// Check experience if required
	int iXPCost = 0;
	if (Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 36) != "0") // TCC_Toggle_UseRecipeXPCosts
		iXPCost = StringToInt(Get2DAString(CRAFTING_2DA, "XP", iRecipeMatch));
	TellCraft(". iXPCost= " + IntToString(iXPCost));

	if (iXPCost > GetXP(oOwnedPC))
	{
		NotifyPlayer(oCrafter, -1, "You don't have enough experience to create that.");
		return;
	}

	// Determine if a new item is getting constructed or an existing one is being enchanted
	string sResrefList = Get2DAString(CRAFTING_2DA, COL_CRAFTING_OUTPUT, iRecipeMatch);
	TellCraft(". sResrefList= " + sResrefList);

	int bEnchant = (sResrefList == "");
	TellCraft(". bEnchant= " + IntToString(bEnchant));

	if (!bEnchant) // CONSTRUCTION of a new Item
	{
		TellCraft(". . construct resref(s) !");
		DestroyItemsInInventory();
		// this could be sucked up by DestroyItemsInInventory() so must be done after!
		CreateListOfItemsInInventory(sResrefList, OBJECT_SELF, TRUE, FALSE, TRUE);
	}
	else // ENCHANTMENT OF EXISTING ITEM
	{
		// Validate that an item was succesfully retrieved
		if (!GetIsObjectValid(oItem))
		{
			NotifyPlayer(oCrafter, ERROR_TARGET_NOT_FOUND_FOR_RECIPE);
			return;
		}

		// Check for properties of oItem that arrogate iRecipeMatch
		if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 34)) // TCC_Toggle_UseRecipeExclusion
			&& hasExcludedProp(oItem, iRecipeMatch))
		{
			NotifyPlayer(oCrafter, -1, "This recipe can't be combined with properties already on the item.");
			return;
		}


		struct sStringTokenizer rEncodedIps;
		string sEncodedIp, sEncodedIpFirst;
		int iPropType;

		itemproperty ipEnchant;


		// Collect the required recipe information
		string sEncodedIps = Get2DAString(CRAFTING_2DA, COL_CRAFTING_EFFECTS, iRecipeMatch);
		TellCraft(". . sEncodedIps= " + sEncodedIps);

		int bPropSetRecipe = GetStringLength(sEncodedIps) == 1; // IMPORTANT: PropSet "EFFECTS" shall have only 1 digit.
		TellCraft(". . bPropSetRecipe= " + IntToString(bPropSetRecipe));

		if (bPropSetRecipe)
		{
			TellCraft(". . . is PropSetRecipe for creation or preparation");
		}
		else
		{
			int bFirstIp = TRUE;

			// Perform checks on each encoded-ip in the recipe
			rEncodedIps = GetStringTokenizer(sEncodedIps, ENCODED_IP_LIST_DELIMITER);
			while (HasMoreTokens(rEncodedIps))
			{
				rEncodedIps = AdvanceToNextToken(rEncodedIps);
				sEncodedIp = GetNextToken(rEncodedIps);

				iPropType = GetIntParam(sEncodedIp, 0);
				ipEnchant = GetItemPropertyByID(iPropType,
												GetIntParam(sEncodedIp, 1),
												GetIntParam(sEncodedIp, 2),
												GetIntParam(sEncodedIp, 3),
												GetIntParam(sEncodedIp, 4));
				if (bFirstIp)
				{
					bFirstIp = FALSE;
					sEncodedIpFirst = sEncodedIp;
				}

				TellCraft(". . . iPropType= " + IntToString(iPropType));

				// Do a validity check although it's probably not thorough
				if (!GetIsItemPropertyValid(ipEnchant))
				{
					TellCraft("ERROR : DoMagicCrafting() ipEnchant is invalid ( " + sEncodedIp
								+ " ) for iRecipeMatch= " + IntToString(iRecipeMatch));
					NotifyPlayer(oCrafter, -1, "ERROR : The itemproperty as defined in Crafting.2da"
												+ " is malformed for the recipe. Sry bout that");
					return;
				}

				// Check if the ip-type is legal for oItem's base-type
				if (!GetIsLegalItemProp(GetBaseItemType(oItem), iPropType))
				{
					NotifyPlayer(oCrafter, ERROR_TARGET_NOT_LEGAL_FOR_EFFECT);
					return;
				}
			}

			// Check for available slots on item for enchants;
			// if good, Do ENCHANTMENTS.
			if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 4))) // TCC_Toggle_LimitNumberOfProps
			{
				int bTCC_SetPropsAreFree = StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 27)); // TCC_Toggle_SetPropsAreFree

				// Check if latent-ips of Property Sets are free and this recipe will add one
				if (bTCC_SetPropsAreFree && GetLatentPartReady(oItem))
				{
					TellCraft(". . . is Property Set latent-ip recipe : free");
				}
				else
				{
					// Calculate the total cost of the enchantment, discounting properties that are replacing or upgrading existing ones
					int bTCC_LimitationPropsAreFree	= StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 24)); // TCC_Toggle_LimitationPropsAreFree
					int bTCC_LightPropsAreFree		= StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 25)); // TCC_Toggle_LightPropsAreFree
					int bTCC_VFXPropsAreFree		= StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 26)); // TCC_Toggle_VFXPropsAreFree

					int bTCC_UseVariableSlotCosts	= StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 35)); // TCC_Toggle_UseVariableSlotCosts

					int iRecipeCostTotal = 0;
					int bUpgradeOrFree;

					TellCraft(". . . check all encoded-ips for Upgrade or Free");
					rEncodedIps = GetStringTokenizer(sEncodedIps, ENCODED_IP_LIST_DELIMITER); // reset Tokenizer.
					while (HasMoreTokens(rEncodedIps))
					{
						bUpgradeOrFree = FALSE;

						rEncodedIps = AdvanceToNextToken(rEncodedIps);
						sEncodedIp = GetNextToken(rEncodedIps);

						iPropType = GetIntParam(sEncodedIp, 0);
						ipEnchant = GetItemPropertyByID(iPropType,
														GetIntParam(sEncodedIp, 1),
														GetIntParam(sEncodedIp, 2),
														GetIntParam(sEncodedIp, 3),
														GetIntParam(sEncodedIp, 4));

						TellCraft(". . . . check iPropType= " + IntToString(iPropType));

						// Check if an Enhancement bonus is equal or better than any existing Attack bonuses
						if (iTccType == TCC_TYPE_MELEE) // note: Not sure what else should do this ->
							bUpgradeOrFree = ReplaceAttackBonus(oItem,
																iPropType,
																GetItemPropertyCostTableValue(ipEnchant),
																GetItemPropertySubType(ipEnchant));

						if (!bUpgradeOrFree && (bUpgradeOrFree = isIpUpgrade(oItem, ipEnchant)))
						{
							TellCraft(". . . . . " + IntToString(iPropType) + " is an Upgrade");
						}

						if (!bUpgradeOrFree)
						{
							if (bTCC_UseVariableSlotCosts
								&& !StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_SLOTS, iPropType)))
							{
								TellCraft(". . . . . " + IntToString(iPropType) + " had no available cost");
								bUpgradeOrFree = TRUE; // could not find a cost for the property
							}
							else
							{
								switch (iPropType)
								{
									case ITEM_PROPERTY_USE_LIMITATION_CLASS:
									case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
									case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
									case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
										if (bTCC_LimitationPropsAreFree)
											bUpgradeOrFree = TRUE;
										TellCraft(". . . . . " + IntToString(iPropType) + " is a Limitation Prop");
										break;
									case ITEM_PROPERTY_LIGHT:
										if (bTCC_LightPropsAreFree)
											bUpgradeOrFree = TRUE;
										TellCraft(". . . . . " + IntToString(iPropType) + " is a Light Prop");
										break;
									case ITEM_PROPERTY_VISUALEFFECT:
										if (bTCC_VFXPropsAreFree)
											bUpgradeOrFree = TRUE;
										TellCraft(". . . . . " + IntToString(iPropType) + " is a VFX");
										break;
								}
							}
						}

						if (!bUpgradeOrFree) // add this ip's slot-cost to the total recipe cost.
						{
							if (!bTCC_UseVariableSlotCosts)
							{
								iRecipeCostTotal += 1;
							}
							else
							{
								iRecipeCostTotal += StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_SLOTS, iPropType));
							}
						}
					}
					TellCraft(". . . iRecipeCostTotal= " + IntToString(iRecipeCostTotal));

					if (iRecipeCostTotal > 0) // check if there are slots available for the total non-free/upgrade properties
					{
						int iBonus = 0;
						int iDiscount = 0;

						// Grant a bonus slot if the item is Masterwork
						if (GetLocalInt(oItem, TCC_VAR_MASTERWORK)
							|| GetStringLowerCase(GetStringRight(GetTag(oItem), 5)) == TCC_MASTER_TAG)
						{
							iBonus += StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 5)); // TCC_Value_GrantMasterworkBonusSlots
							TellCraft(". . . enchant on Masterwork item - iBonus= " + IntToString(iBonus));
							// Grant an extra slot for Masterwork weapons with a +1 Attack Bonus property
							if (hasMasterworkAttackBonus(oItem))
							{
								iDiscount += 1;
								TellCraft(". . . . Masterwork weapon with +1 Attack bonus - iDiscount= " + IntToString(iDiscount));
							}
						}

						if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 7))) // TCC_Toggle_GrantMaterialBonusSlots
						{
							// Increase bonus/discount by material-type if available
							// note: does not consider GMATERIAL_* values. These are
							// currently TCC-material-types only. See GetMaterialCode()
							string sType;
							switch (iTccType)
							{
								case TCC_TYPE_ARMOR:
								case TCC_TYPE_SHIELD:	sType = TCC_BONUS_ARMOR;
									break;
								case TCC_TYPE_BOW:
								case TCC_TYPE_XBOW:
								case TCC_TYPE_SLING:	sType = TCC_BONUS_RANGED;
									break;
								case TCC_TYPE_MELEE:
								case TCC_TYPE_AMMO:		sType = TCC_BONUS_WEAPON;
							}

							if (sType != "")
							{
								switch (GetMaterialCode(oItem))
								{
									case  1: // MAT_ADA
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 17)); // adamantine
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 17)); // TCC_Value_AdamantinePropSlots
										break;
									case  2: // MAT_CLD
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 16)); // cold iron
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 16)); // TCC_Value_ColdIronPropSlots
										break;
									case  3: // MAT_DRK
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS,  8)); // darksteel
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW,  8)); // TCC_Value_DarksteelPropSlots
										break;
									case  4: // MAT_DSK
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 13)); // duskwood
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 13)); // TCC_Value_DuskwoodPropSlots
										break;
									case  5: // MAT_MTH
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS,  9)); // mithral
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW,  9)); // TCC_Value_MithralPropSlots
										break;
									case  6: // MAT_RDH
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 19)); // red dragon hide
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 19)); // TCC_Value_RedDragonPropSlots
										break;
									case  7: // MAT_SHD
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 14)); // shederran
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 14)); // TCC_Value_ShederranPropSlots
										break;
									case  8: // MAT_SLH
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 10)); // salamander hide
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 10)); // TCC_Value_SalamanderPropSlots
										break;
									case  9: // MAT_SLV
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 15)); // alchemical silver
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 15)); // TCC_Value_AlchemicalSilverPropSlots
										break;
									case 10: // MAT_UHH
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 11)); // umber hulk hide
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 11)); // TCC_Value_UmberHulkPropSlots
										break;
									case 11: // MAT_WYH
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 12)); // wyvern hide
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 12)); // TCC_Value_WyvernPropSlots
										break;
									case 12: // MAT_ZAL
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 18)); // zalantar
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 18)); // TCC_Value_ZalantarPropSlots
									case 13: // MAT_WWF
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 20)); // winter wolf hide
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 20)); // TCC_Value_WinterWolfPropSlots
									case 14: // MAT_FMP
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 21)); // fire mephit
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 21)); // TCC_Value_FireMephitPropSlots
									case 15: // MAT_IMP
										iBonus    += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_BONUS, 22)); // ice mephit
										iDiscount += StringToInt(Get2DAString(TCC_CONFIG_2da, sType + TCC_ALLOW, 22)); // TCC_Value_IceMephitPropSlots
								}
							}
							TellCraft(". . . material modifier - iBonus= " + IntToString(iBonus) + " iDiscount= " + IntToString(iDiscount));
						}

						int iLimitationProps = 0; // each ip counts as 1
						int iLimitationSlots = 0; // each ip counts by value in ItemPropDef.2da "Slots"

						int iQty;
						int iLimitationType;
						for (iLimitationType = ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP; iLimitationType < ITEM_PROPERTY_BONUS_HITPOINTS; ++iLimitationType)
						{
							iQty = GetQtyPropsOfType(oItem, iLimitationType);

							iLimitationProps += iQty;
							iLimitationSlots += iQty * StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_SLOTS, iLimitationType));
							TellCraft(". . . check limitation propType= " + IntToString(iLimitationType) + " iQty= " + IntToString(iQty));
						}

						// Grant discount slot credit to offset each limitation property;
						// also grant a bonus slot if the item has any limitation property.
						if (iLimitationProps)
						{
							if (bTCC_LimitationPropsAreFree)
							{
								if (!bTCC_UseVariableSlotCosts)
									iDiscount += iLimitationProps;
								else
									iDiscount += iLimitationSlots;
							}

							if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 23))) // TCC_Toggle_GrantLimitationBonusSlot
								++iBonus;
						}
						TellCraft(". . limitation props - iBonus= " + IntToString(iBonus) + " iDiscount= " + IntToString(iDiscount));

						// Grant discount slot for each existing light effect
						if (bTCC_LightPropsAreFree)
						{
							int iLightProps = GetQtyPropsOfType(oItem, ITEM_PROPERTY_LIGHT);

							if (!bTCC_UseVariableSlotCosts)
								iDiscount += iLightProps;
							else
								iDiscount += iLightProps * StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_SLOTS, ITEM_PROPERTY_LIGHT));
						}
						TellCraft(". . light props - iBonus= " + IntToString(iBonus) + " iDiscount= " + IntToString(iDiscount));

						// Grant discount slot for each existing vFx property
						if (bTCC_VFXPropsAreFree)
						{
							int iVfxProps = GetQtyPropsOfType(oItem, ITEM_PROPERTY_VISUALEFFECT);

							if (!bTCC_UseVariableSlotCosts)
								iDiscount += iVfxProps;
							else
								iDiscount += iVfxProps * StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_SLOTS, ITEM_PROPERTY_VISUALEFFECT));
						}
						TellCraft(". . VFX props - iBonus= " + IntToString(iBonus) + " iDiscount= " + IntToString(iDiscount));

						// Look for quantity of existing ip's
						int iPropCount;
						if (!bTCC_UseVariableSlotCosts)
						{
							iPropCount = GetPropSlotsUsed(oItem);
						}
						else
						{
							iPropCount = GetCostSlotsUsed(oItem);
						}

						// Add the quantity of potential ip's from Set Properties
						if (!bTCC_SetPropsAreFree)
							iPropCount += GetQtyLatentIps(oItem);

						// Get basic qty of prop-slots per Tcc_Config.2da
						int iTCC_BasePropSlots = StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 6)); // TCC_Value_BasePropSlots
						TellCraft(". . iTCC_BasePropSlots= " + IntToString(iTCC_BasePropSlots));

						// Grant bonus slots if the caster is of Epic Level (21+) (default 0)
						if (iCasterLevel > 20)
						{
							iTCC_BasePropSlots += StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 38)); // TCC_Value_EpicCharacterBonusProp
							TellCraft(". . . EPIC iTCC_BasePropSlots= " + IntToString(iTCC_BasePropSlots));
						}

						TellCraft(". . iBonus= " + IntToString(iBonus));
						TellCraft(". . iDiscount= " + IntToString(iDiscount));
						TellCraft(". . Total Props Allowed= " + IntToString(iTCC_BasePropSlots + iBonus + iDiscount));
						TellCraft(". . iPropCount= " + IntToString(iPropCount));
						TellCraft(". . iRecipeCostTotal= " + IntToString(iRecipeCostTotal));
						TellCraft(". . Total Props After Enchantment= " + IntToString(iPropCount + iRecipeCostTotal));

						// Perform final slot check
						if (iPropCount - iDiscount + iRecipeCostTotal > iTCC_BasePropSlots + iBonus)
						{
							NotifyPlayer(oCrafter, ERROR_TARGET_HAS_MAX_ENCHANTMENTS);
							return;
						}
					}
				}
			}
		}


		// +++ all criteria good to go, add ItemProperty +++

		TellCraft(". ALL CHECKS PASSED");

		DestroyItemsInInventory(TRUE);


		// if this is a Property Set recipe handle it
		// TODO: Restrict allowed slots to body & hands -- no ammo allowed as
		// part of a Property Set, per GetQtyLatentPartsEquipped().
		// NOTE: Property Set recipes currently bypass GP & XP deductions.
		if (bPropSetRecipe)
		{
			// check Property Set creation:
			if (sEncodedIps == "0") // set up a new group of Set-items
			{
				ConstructSet(oCrafter);
				NotifyPlayer(oCrafter, -1, "The Property Set is forged !");
			}
			else // is Property Set preparation
			{
				// prepare Set-item to receive latent properties
				SetLatentPartReady(oItem, StringToInt(sEncodedIps));
				NotifyPlayer(oCrafter, -1, "The Set item is prepared ! The next property added"
						+ " will require " + sEncodedIps + " parts to activate !");
			}
			return;
		}

		// check add Property Set latent-ip
		int iParts = GetLatentPartReady(oItem);
		if (iParts) // add encoded-ip as a latent Property Set ip
		{
			AddLatentIp(oItem, iParts, sEncodedIpFirst, oCrafter);
			NotifyPlayer(oCrafter, -1, "The Set property has been added to the item !");
			return;
		}

		// not part of a Set
		rEncodedIps = GetStringTokenizer(sEncodedIps, ENCODED_IP_LIST_DELIMITER); // reset the Tokenizer
		while (HasMoreTokens(rEncodedIps))
		{
			rEncodedIps = AdvanceToNextToken(rEncodedIps);
			sEncodedIp = GetNextToken(rEncodedIps);

			iPropType = GetIntParam(sEncodedIp, 0);
			ipEnchant = GetItemPropertyByID(iPropType,
											GetIntParam(sEncodedIp, 1),
											GetIntParam(sEncodedIp, 2),
											GetIntParam(sEncodedIp, 3),
											GetIntParam(sEncodedIp, 4));

			TellCraft(". . add IP " + IntToString(iPropType) + " !");
			int iPolicy;
			if (isIgnoredIp(ipEnchant))
				iPolicy = X2_IP_ADDPROP_POLICY_IGNORE_EXISTING;
			else
				iPolicy = X2_IP_ADDPROP_POLICY_REPLACE_EXISTING;

			IPSafeAddItemProperty(oItem,
								  ipEnchant,
								  0.f,
								  iPolicy,
								  FALSE,
								  isIgnoredSubtype(ipEnchant));
		}
	}

	if (iGPCost > 0) // Charge gold coins if required
		TakeGoldFromCreature(iGPCost, oOwnedPC, TRUE);

	if (iXPCost != 0) // Charge experience points if required
		GiveXPToCreature(oOwnedPC, -iXPCost);	// note: Prob should use Get/GiveXP() so it affects only the OwnedPC.
//		SetXP(oOwnedPC, iBaseXP - iXPCost);		// note: If a negative value is set in Crafting.2da crafters can earn XP.

	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_MAGIC), OBJECT_SELF);
	NotifyPlayer(oCrafter);

	if (bEnchant) SetEnchantedItemName(oCrafter, oItem);
}


// -----------------------------------------------------------------------------
// functions for general crafting
// -----------------------------------------------------------------------------

// Gets the row of Crafting.2da that matches input-variables.
// - sTrigger		: the trigger (spell/mold/alchemy-suffix)
// - oItem			: item required only if enchanting
// - return			: the row of the reagents for sTrigger (-1 if not found)
// note: Distillation uses GetRecipeMatch() directly.
int GetInventoryRecipeMatch(string sTrigger, object oItem = OBJECT_INVALID)
{
	//TellCraft(". . sTrigger= " + sTrigger);
	string sReagentTags = GetSortedReagents(GetIsObjectValid(oItem)); // list of reagents in workbench or satchel
	//TellCraft(". . sReagentTags= " + sReagentTags);
	return GetRecipeMatch(sReagentTags, sTrigger, oItem);
}

// Gets all reagents sorted into an alphabetical list (case-sensitive).
string GetSortedReagents(int bEnchant = FALSE, object oContainer = OBJECT_SELF)
{
	string sList;

	object oItem = GetFirstItemInInventory(oContainer);
	while (GetIsObjectValid(oItem))
	{
		if (!bEnchant						// if not enchanting, include everything
			|| !GetIsEquippable(oItem)		// if not equippable then must be part of recipe
			|| isInExceptionList(oItem))	// is equippable but in the exception list
		{
			if (sList != "") sList += REAGENT_LIST_DELIMITER;
			sList += GetRepeatTags(oItem);
		}
		oItem = GetNextItemInInventory(oContainer);
	}
	return Sort(sList); // note: List needs to be sorted before attempting GetRecipeMatch().
}

// Gets a list of tags for any stacksize of oItem.
// - never starts or ends w/ a delimiter so it can be a single tag
// - helper for GetSortedReagents()
string GetRepeatTags(object oItem)
{
	string sList;

	string sTag = GetTag(oItem);
	if (sTag != "")
	{
		int iStackSize = GetItemStackSize(oItem);
		int i;
		for (i = 0; i != iStackSize; ++i)
		{
			if (i != 0) sList += REAGENT_LIST_DELIMITER;
			sList += sTag;
		}
	}
	return sList;
}

// Gets the first row in Crafting.2da that's within a determined range of rows
// and that matches sReagentTags, sTrigger, and is the correct TCC-type (TAGS).
// - if oItem is invalid ITEM_CATEGORY_NONE should return a match.
// - returns index of sReagentTags for sTrigger (-1 if not found)
int GetRecipeMatch(string sReagentTags, string sTrigger, object oItem = OBJECT_INVALID)
{
	//TellCraft("GetRecipeMatch() sTrigger= " + sTrigger + " sReagentTags= " + sReagentTags);
	string sTypes;

	struct range2da rRange = GetTriggerRange(sTrigger); // Crafting.2da rows
	//TellCraft(". rRange.first= " + IntToString(rRange.first));
	//TellCraft(". rRange.last= " + IntToString(rRange.last));

	while (rRange.first != -1)
	{
		rRange.first = SearchForReagents(sReagentTags, rRange.first, rRange.last);
		switch (rRange.first)
		{
			case -1: return -1;
			default:
				sTypes = Get2DAString(CRAFTING_2DA, COL_CRAFTING_TAGS, rRange.first);
				//TellCraft(". . sTypes= " + sTypes);

				if (isTypeMatch(oItem, sTypes))
				{
					//TellCraft(". . TYPES MATCH ret= " + IntToString(rRange.first));
					return rRange.first;
				}
		}
		if (++rRange.first > rRange.last)
			break;
	}
	return -1;
}

// Gets a list of comma-delimited indices into Crafting.2da that will be valid
// recipes for SPELL_IMBUE_ITEM.
// @param oItem	- the equipable item in the crafting container if any.
// @return		- a comma-delimited list of ints that are Crafting.2da rows
//				  ie. the triggerspells for Imbue_Item recipes ("" if none found)
string GetRecipeMatches(object oItem)
{
	//TellCraft("GetRecipeMatches() ( " + (GetIsObjectValid(oItem) ? GetName(oItem) : "construction") + " )");
	string sMatches;

	string sReagentTags = GetSortedReagents(GetIsObjectValid(oItem));
	//TellCraft(". sReagentTags= " + sReagentTags);
	string sTypes;
	//int iPropType, bLegal;

	struct range2da rRange = GetTriggerRange(SPELL_IMBUE_ITEM_ST); // get Crafting.2da rows per Crafting_Index.2da for SPELL_IMBUE_ITEM
	//TellCraft(". rRange first= " + IntToString(rRange.first) + " last=" + IntToString(rRange.last));
	while (rRange.first != -1)
	{
		//TellCraft(". . Search first= " + IntToString(rRange.first));
		rRange.first = SearchForReagents(sReagentTags, rRange.first, rRange.last);
		switch (rRange.first)
		{
			case -1:
				//TellCraft(". . . RET sMatches= " + sMatches);
				return sMatches;

			default:
				sTypes = Get2DAString(CRAFTING_2DA, COL_CRAFTING_TAGS, rRange.first);
				//TellCraft(". . . sTypes= " + sTypes);
				if (isTypeMatch(oItem, sTypes)) // will handle enchantment or construction
				{
					//TellCraft(". . . . MATCHTYPE first= " + IntToString(rRange.first));

//					bLegal = FALSE;
//					if (GetIsObjectValid(oItem)) // enchantment
//					{
						//TellCraft(". . . . . check if prop-type is legal for base-type");
//						iPropType = GetIntParam(Get2DAString(CRAFTING_2DA, COL_CRAFTING_EFFECTS, rRange.first), 0);
//						if (GetIsLegalItemProp(GetBaseItemType(oItem), iPropType))
//						{
							//TellCraft(". . . . . . ip is Legal for type !");
//							bLegal = TRUE;
//						}
						//else TellCraft(". . . . . . ip is NOT Legal for type !");
//					}
//					else // construction
//					{
						//TellCraft(". . . . . is construction - bypass legality check");
//						bLegal = TRUE;
//					}

//					if (bLegal)
//					{
					if (sMatches != "") sMatches += REAGENT_LIST_DELIMITER;
					sMatches += IntToString(rRange.first);
//					}
				}
				//else TellCraft(". . . . Type does NOT match.");
		}

		if (++rRange.first > rRange.last)
		{
			//TellCraft(". . first > last endloop");
			break;
		}
	}

	//TellCraft(". sMatches= " + sMatches);
	return sMatches;
}

// Finds and effectively deletes Crafting.2da indices that given the same
// reagents would result in the same applied-ip or construction-resref.
// - if matches are found it will be the last index that is kept, however the
//   trigger itself will still be the first index.
// - at last 1 index will be kept and returned as long as sRecipeMatches is not
//   blank
// - note that blank strings can be handled albeit redundantly at the call pt.
string PruneRecipeMatches(string sRecipeMatches, string sCol)
{
	//TellCraft("PruneRecipeMatches() sRecipeMatches= " + sRecipeMatches);
	string sMatches;

	string sRecipeMatch, sCraftResult, sRecipeMatchTest, sCraftResultTest;
	int bFound;

	int iTokens = GetNumberTokens(sRecipeMatches, REAGENT_LIST_DELIMITER);
	//TellCraft(". iTokens= " + IntToString(iTokens));
	int i, j;
	for (i = 0; i != iTokens; ++i)
	{
		sRecipeMatch = GetTokenByPosition(sRecipeMatches, REAGENT_LIST_DELIMITER, i);
		sCraftResult = Get2DAString(CRAFTING_2DA, sCol, StringToInt(sRecipeMatch));
		//TellCraft(". . sRecipeMatch= " + sRecipeMatch + " / sCraftResult= " + sCraftResult);
		bFound = FALSE;

		for (j = i + 1; j != iTokens; ++j)
		{
			sRecipeMatchTest = GetTokenByPosition(sRecipeMatches, REAGENT_LIST_DELIMITER, j);
			sCraftResultTest = Get2DAString(CRAFTING_2DA, sCol, StringToInt(sRecipeMatchTest));
			//TellCraft(". . . sRecipeMatchTest= " + sRecipeMatchTest + " / sCraftResultTest= " + sCraftResultTest);

			if (sCraftResultTest == sCraftResult)
			{
				//TellCraft(". . . . MATCH bFound= TRUE");
				bFound = TRUE;
				break;
			}
		}

		if (!bFound)
		{
			//TellCraft(". . bFound is FALSE - add sRecipeMatch");
			if (sMatches != "") sMatches += REAGENT_LIST_DELIMITER;
			sMatches += sRecipeMatch;
		}
	}
	//TellCraft(". sMatches= " + sMatches);
	return sMatches;
}

// Takes a list of Crafting.2da indices and tells player what the candidate
// triggers for SPELL_IMBUE_ITEM are.
// @param sRecipeMatches	- a comma-delimited list of indices into Crafting.2da
// @param oCrafter			- the character to send the parsed info to
// @return					- how to proceed:
//								2+ - show triggerspell candidates
//								1  - don't show candidates, only one match, proceed with standard recipe
//								0  - no match found, abort recipe
// @note 'sRecipeMatches' will be in format: "234,34,0,2343" eg. -- no trailing
// delimiter to keep things compatible with 'x0_i0_stringlib'.
int ParseRecipeMatches(string sRecipeMatches, object oCrafter)
{
	//TellCraft("Parse sRecipeMatches= " + sRecipeMatches);
	int iProceed = 0;

	string sRef, sSpellId, sRecipeMatch, sInfo, sInfoSpells;
	int iSpellId;

	struct sStringTokenizer rTok = GetStringTokenizer(sRecipeMatches, REAGENT_LIST_DELIMITER);
	while (HasMoreTokens(rTok))
	{
		++iProceed;

		rTok = AdvanceToNextToken(rTok);
		sRecipeMatch = GetNextToken(rTok);

		sSpellId = Get2DAString(CRAFTING_2DA, COL_CRAFTING_CATEGORY, StringToInt(sRecipeMatch));
		iSpellId = StringToInt(sSpellId);
		sRef = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", iSpellId)));
		sInfoSpells += "<c=seagreen>Imbued Spell ID :</c> " + sSpellId
					+ " <c=seagreen>( " + sRef + " )</c>\n";
	}

	switch (iProceed)
	{
		case 0: return 0; // 'iProceed' will not be "0" as along as sRecipeMatches is not blank.

		case 1:
			_iRecipeMatch_ii = StringToInt(sRecipeMatch);
			sInfo = "<c=plum>_ Crafting :</c> ";
			break;
		default:
			sInfo = "\n<c=plum>_ Crafting :</c> Imbue Item : <c=slateblue>There is"
				  + " more than one recipe that is possible with your reagents."
				  + "\nEnter a Spell ID for the recipe you would like to attempt ...</c>\n\n";
	}
	NotifyPlayer(oCrafter, -1, sInfo + sInfoSpells);

	return iProceed;
}

// Gets the first and last rows in Crafting.2da for sTrigger.
// - note: Crafting_Index.2da shall not have blank rows.
// - note: Spells shall be arranged first in Crafting_Index.2da and therefore in
//   Crafting.2da also.
struct range2da GetTriggerRange(string sTrigger)
{
	//TellCraft("GetTriggerRange sTrigger= " + sTrigger);
	struct range2da rRange;

	int i = 0;
	if (sTrigger != SPELL_IMBUE_ITEM_ST) // note: ImbueItem acts as a trigger for any magical recipe.
	{
		i = GetTriggerStart(sTrigger);
		//TellCraft(". start per Index 2da= " + IntToString(i));
		switch (i)
		{
			case -1:
				//TellCraft(". . not found");
				rRange.first = -1;
				return rRange;

			default:
				rRange.first = StringToInt(Get2DAString(CRAFTING_INDEX_2DA, COL_CRAFTING_START_ROW, i));
				//TellCraft(". . rRange.first= " + IntToString(rRange.first));

				//TellCraft(". . total rows Index 2da= " + IntToString(GetNum2DARows(CRAFTING_INDEX_2DA)));
				if (GetNum2DARows(CRAFTING_INDEX_2DA) - 1 == i)
				{
					rRange.last = GetNum2DARows(CRAFTING_2DA) - 1;
					//TellCraft(". . . first row is last row Index 2da rRange.last= " + IntToString(rRange.last));
				}
				else
				{
					rRange.last = StringToInt(Get2DAString(CRAFTING_INDEX_2DA, COL_CRAFTING_START_ROW, i + 1)) - 1;
					//TellCraft(". . . first row is NOT last row Index 2da rRange.last= " + IntToString(rRange.last));
				}
		}
	}
	else // Imbue_Item will search all spellId's ->
	{
		while (isSpellId(Get2DAString(CRAFTING_INDEX_2DA, COL_CRAFTING_CATEGORY, i)))
			++i;

		// NOTE: This does not account for the fact that spell-triggers could go
		// to the end of the .2da's; ie, if there are not molds/alchemy/distillation
		// triggers at the end of the .2da's then 'rRange.last' needs to be handled
		// as above^
		rRange.last = StringToInt(Get2DAString(CRAFTING_INDEX_2DA, COL_CRAFTING_START_ROW, i)) - 1;
		rRange.first = 0;
	}

	return rRange;
}

// Gets the first row for sTrigger in Crafting.2da.
int GetTriggerStart(string sTrigger)
{
	int iTotal = GetNum2DARows(CRAFTING_INDEX_2DA);
	int i = 0;
	while (i != iTotal)
	{
		if (Get2DAString(CRAFTING_INDEX_2DA, COL_CRAFTING_CATEGORY, i) == sTrigger)
			return i;

		++i;
	}
	return -1;
}

// Checks if sTrigger is a spell-ID (is purely numeric).
int isSpellId(string sTrigger)
{
	int iLength = GetStringLength(sTrigger);
	int i;
	for (i = 0; i != iLength; ++i)
	{
		if (!TestStringAgainstPattern("**" + GetSubString(sTrigger, i, 1) + "**", DIGITS))
			return FALSE;
	}
	return TRUE;
}

// Finds the first match in Crafting.2da for a sorted string of reagent-tags.
// @param sReagentTags	- a sorted list of reagent-tags
// @param iStartRow		- the row in Crafting.2da to start the search on
// @param iStopRow		- the row in Crafting.2da to end the search on (inclusive)
// @return				- the row# if a match is found (-1 if none found)
// @note The search does NOT stop at an empty string.
int SearchForReagents(string sReagentTags, int iStartRow, int iStopRow)
{
	//TellCraft("SearchForReagents() sReagentTags= " + sReagentTags);
	//TellCraft(". iStart= " + IntToString(iStartRow) + " iStop= " + IntToString(iStopRow));
	while (iStartRow <= iStopRow)
	{
		//TellCraft(". . iStartRow= " + IntToString(iStartRow));
		if (Get2DAString(CRAFTING_2DA, COL_CRAFTING_REAGENTS, iStartRow) == sReagentTags)
		{
			//TellCraft(". . . FOUND iStartRow= " + IntToString(iStartRow));
			return iStartRow;
		}
		++iStartRow;
	}
	//TellCraft(". reagents NOT found ret -1");
	return -1;
}


// Destroys all items in oContainer that are not equippable.
void DestroyItemsInInventory(int bEnchant = FALSE, object oContainer = OBJECT_SELF)
{
	object oItem = GetFirstItemInInventory(oContainer);
	while (GetIsObjectValid(oItem))
	{
		if (!bEnchant || !GetIsEquippable(oItem))
			DestroyObject(oItem);

		oItem = GetNextItemInInventory(oContainer);
	}
}

// Creates the items of sResrefList in the inventory of oContainer.
// - bIdentify : -1 leave default
//				  0 set not identified
//				  1 set identified
void CreateListOfItemsInInventory(string sResrefList,
								  object oContainer = OBJECT_SELF,
								  int bIdentify = TRUE,
								  int bMasterwork = FALSE,
								  int bFullStack = FALSE)
{
	//TellCraft("CreateListOfItemsInInventory() ( " + sResrefList + " )");
	object oCreate;

	string sResrefMstrwork;

	int i = 0;
	string sResref = GetStringParam(sResrefList, i);
	while (sResref != "")
	{
		//TellCraft(". resref= " + sResref);
		oCreate = OBJECT_INVALID;

		if (bMasterwork)
		{
			sResrefMstrwork = sResref + TCC_MASTER_TAG;
			oCreate = CreateItemOnObject(sResrefMstrwork, oContainer);
			TellCraft(". . masterwork ! ( " + sResrefMstrwork + " )" + (!GetIsObjectValid(oCreate) ? " WARNING : no masterwork resref" : ""));
		}

		if (!GetIsObjectValid(oCreate))
		{
			//TellCraft(". creating : " + sResref);
			oCreate = CreateItemOnObject(sResref, oContainer);
		}

		if (GetIsObjectValid(oCreate))
		{
			if (bMasterwork) // set Masterwork flag whether or not item was created w/ a Masterwork-resref.
				SetLocalInt(oCreate, TCC_VAR_MASTERWORK, TRUE);

			if (bIdentify != -1)
				SetIdentified(oCreate, bIdentify);

			if (bFullStack)
				SetItemStackSize(oCreate,
								 StringToInt(Get2DAString("baseitems", "Stacking", GetBaseItemType(oCreate))));
		}
		//else TellCraft(". . ERROR : failed to create ( " + sResref + " )");

		sResref = GetStringParam(sResrefList, ++i);
	}
}

// -----------------------------------------------------------------------------
// private functions for Magical Crafting
// -----------------------------------------------------------------------------

// Gets the first equippable item in the crafting-container if any.
object GetFirstEquippableItem(object oContainer = OBJECT_SELF)
{
	object oItem = GetFirstItemInInventory(oContainer);
	while (GetIsObjectValid(oItem))
	{
		if (GetIsEquippable(oItem)			// if not equippable then must be part of recipe
			&& !isInExceptionList(oItem))	// is equippable but in the exception list
		{
			break;
		}
		oItem = GetNextItemInInventory(oContainer);
	}
	return oItem;
}

// Checks if oItem should be excepted and not considered an equippable item.
// - these items can be a reagent of a recipe but not the target
int isInExceptionList(object oItem)
{
	if (GetTag(oItem) == "NW_IT_MNECK022") // gold necklace for Mephasm charm
		return TRUE;

	return FALSE;
}

// Checks if the type of oItem matches allowed values in Crafting.2da "TAGS".
// - if TAGS is prepended with a "B" the search is by BaseItem.2da type
// - if not then search is done by TCC-type
int isTypeMatch(object oItem, string sTypes)
{
	//TellCraft("isTypeMatch() ( " + GetName(oItem) + " BaseType= "
	//		+ IntToString(GetBaseItemType(oItem)) + " ) sTypes= " + sTypes);

	if (!GetIsObjectValid(oItem))
	{
		//TellCraft(". object invalid");
		if (FindSubString(sTypes, REAGENT_LIST_DELIMITER) == -1	// is not multi-TAG'd (would convert to 0)
			&& StringToInt(sTypes) == 0)						// TAGS shall be "0" or "****" only.
		{
			//TellCraft(". . ret TRUE");
			return TRUE;
		}
		//TellCraft(". . ret FALSE");
		return FALSE;
	}

	if (GetStringLeft(sTypes, 1) == "B")
	{
		//TellCraft(". search by Base-types for " + IntToString(GetBaseItemType(oItem)));
		sTypes = GetStringRight(sTypes, GetStringLength(sTypes) - 1);
		if (FindListElementIndex(sTypes, IntToString(GetBaseItemType(oItem))) != -1)
		{
			//TellCraft(". . ret TRUE");
			return TRUE;
		}
	}
	else
	{
		//TellCraft(". search by TCC-type");
		int iType = GetTccType(oItem);
		//TellCraft(". TCC iType= " + IntToString(iType));

		if (sTypes == "-1") // TCC_TYPE_ANY: TAGS shall be "-1" only.
		{
			//TellCraft(". . match Any ret TRUE");
			return TRUE;
		}

		switch (iType) // cases include only the possible returns from GetTccType()
		{
			case TCC_TYPE_MELEE:									//  1
				//TellCraft(". . . oItem is TCC_TYPE_MELEE");
				if (FindListElementIndex(sTypes, "1") != -1)
					return TRUE;
				break;

			case TCC_TYPE_BOW:										//  3
				//TellCraft(". . . oItem is TCC_TYPE_BOW");
				if (   FindListElementIndex(sTypes,  "3") != -1
					|| FindListElementIndex(sTypes, "10") != -1)	// TCC_TYPE_RANGED
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_XBOW:										//  4
				//TellCraft(". . . oItem is TCC_TYPE_XBOW");
				if (   FindListElementIndex(sTypes,  "4") != -1
					|| FindListElementIndex(sTypes, "10") != -1)	// TCC_TYPE_RANGED
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_SLING:									//  5
				//TellCraft(". . . oItem is TCC_TYPE_SLING");
				if (   FindListElementIndex(sTypes,  "5") != -1
					|| FindListElementIndex(sTypes, "10") != -1)	// TCC_TYPE_RANGED
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_AMMO:										//  6
				//TellCraft(". . . oItem is TCC_TYPE_AMMO");
				if (FindListElementIndex(sTypes, "6") != -1)
					return TRUE;
				break;

			case TCC_TYPE_ARMOR:									//  7
				//TellCraft(". . . oItem is TCC_TYPE_ARMOR");
				if (   FindListElementIndex(sTypes, "7") != -1
					|| FindListElementIndex(sTypes, "2") != -1)		// TCC_TYPE_ARMOR_SHIELD
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_SHIELD:									//  8
				//TellCraft(". . . oItem is TCC_TYPE_SHIELD");
				if (   FindListElementIndex(sTypes, "8") != -1
					|| FindListElementIndex(sTypes, "2") != -1)		// TCC_TYPE_ARMOR_SHIELD
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_OTHER:									//  9
				//TellCraft(". . . oItem is TCC_TYPE_OTHER");
				if (FindListElementIndex(sTypes, "9") != -1)
					return TRUE;
				break;

			case TCC_TYPE_INSTRUMENT:								// 15
				//TellCraft(". . . oItem is TCC_TYPE_INSTRUMENT");
				if (FindListElementIndex(sTypes, "15") != -1)
					return TRUE;
				break;

			case TCC_TYPE_CONTAINER:								// 16
				//TellCraft(". . . oItem is TCC_TYPE_CONTAINER");
				if (FindListElementIndex(sTypes, "16") != -1)
					return TRUE;
				break;

			case TCC_TYPE_HELMET:									// 17
				//TellCraft(". . . oItem is TCC_TYPE_HELMET");
				if (   FindListElementIndex(sTypes, "17") != -1
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_AMULET:									// 19
				//TellCraft(". . . oItem is TCC_TYPE_AMULET");
				if (   FindListElementIndex(sTypes, "19") != -1
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_BELT:										// 21
				//TellCraft(". . . oItem is TCC_TYPE_BELT");
				if (   FindListElementIndex(sTypes, "21") != -1
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_BOOTS:									// 26
				//TellCraft(". . . oItem is TCC_TYPE_BOOTS");
				if (   FindListElementIndex(sTypes, "26") != -1
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_GLOVES:									// 36
				//TellCraft(". . . oItem is TCC_TYPE_GLOVES");
				if (   FindListElementIndex(sTypes, "36") != -1
					|| FindListElementIndex(sTypes, "11") != -1		// TCC_TYPE_WRISTS
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_RING:										// 52
				//TellCraft(". . . oItem is TCC_TYPE_RING");
				if (   FindListElementIndex(sTypes, "52") != -1
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_BRACER:									// 78
				//TellCraft(". . . oItem is TCC_TYPE_BRACER");
				if (   FindListElementIndex(sTypes, "78") != -1
					|| FindListElementIndex(sTypes, "11") != -1		// TCC_TYPE_WRISTS
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
				break;

			case TCC_TYPE_CLOAK:									// 80
				//TellCraft(". . . oItem is TCC_TYPE_CLOAK");
				if (   FindListElementIndex(sTypes, "80") != -1
					|| FindListElementIndex(sTypes, "-2") != -1)	// TCC_TYPE_EQUIPPABLE
				{
					return TRUE;
				}
		}
	}

	//TellCraft(". ret FALSE");
	return FALSE;
}
/*
const int TCC_TYPE_EQUIPPABLE	= -2;
const int TCC_TYPE_ANY			= -1;
const int TCC_TYPE_NONE			=  0;
const int TCC_TYPE_MELEE		=  1;
const int TCC_TYPE_ARMOR_SHIELD	=  2;
const int TCC_TYPE_BOW			=  3;
const int TCC_TYPE_XBOW			=  4;
const int TCC_TYPE_SLING		=  5;
const int TCC_TYPE_AMMO			=  6;
const int TCC_TYPE_ARMOR		=  7;
const int TCC_TYPE_SHIELD		=  8;
const int TCC_TYPE_OTHER		=  9;
const int TCC_TYPE_RANGED		= 10;
const int TCC_TYPE_WRISTS		= 11;
const int TCC_TYPE_INSTRUMENT	= 15;
const int TCC_TYPE_CONTAINER	= 16;

const int TCC_TYPE_HELMET		= 17; // BASE_ITEM_HELMET // note: These constants are equivalent to those in BaseItems.2da ->
const int TCC_TYPE_AMULET		= 19; // BASE_ITEM_AMULET
const int TCC_TYPE_BELT			= 21; // BASE_ITEM_BELT
const int TCC_TYPE_BOOTS		= 26; // BASE_ITEM_BOOTS
const int TCC_TYPE_GLOVES		= 36; // BASE_ITEM_GLOVES
const int TCC_TYPE_RING			= 52; // BASE_ITEM_RING
const int TCC_TYPE_BRACER		= 78; // BASE_ITEM_BRACER
const int TCC_TYPE_CLOAK		= 80; // BASE_ITEM_CLOAK
*/

// Gets the TCC-type of oItem.
// - this returns one of the following TCC-types. If oItem needs to be compared
//   to a multi-TCC-type like TCC_TYPE_EQUIPPABLE or TCC_TYPE_ARMOR_SHIELD that
//   needs to be done elsewhere, eg. isTypeMatch()
// @return -
// - TCC_TYPE_NONE
// - TCC_TYPE_HELMET
// - TCC_TYPE_AMULET
// - TCC_TYPE_BELT
// - TCC_TYPE_BOOTS
// - TCC_TYPE_GLOVES
// - TCC_TYPE_BRACER
// - TCC_TYPE_RING
// - TCC_TYPE_CLOAK
// - TCC_TYPE_INSTRUMENT
// - TCC_TYPE_CONTAINER
// - TCC_TYPE_ARMOR
// - TCC_TYPE_SHIELD
// - TCC_TYPE_BOW
// - TCC_TYPE_XBOW
// - TCC_TYPE_SLING
// - TCC_TYPE_AMMO
// - TCC_TYPE_MELEE
// - TCC_TYPE_OTHER
int GetTccType(object oItem)
{
	if (!GetIsObjectValid(oItem))		return TCC_TYPE_NONE;

	switch (GetBaseItemType(oItem))
	{
		case BASE_ITEM_HELMET:			return TCC_TYPE_HELMET;
		case BASE_ITEM_AMULET:			return TCC_TYPE_AMULET;
		case BASE_ITEM_BELT:			return TCC_TYPE_BELT;
		case BASE_ITEM_BOOTS:			return TCC_TYPE_BOOTS;
		case BASE_ITEM_GLOVES:			return TCC_TYPE_GLOVES; // also, kPrC #201 spiked gloves, #202 bladed gloves
		case BASE_ITEM_BRACER:			return TCC_TYPE_BRACER;
		case BASE_ITEM_RING:			return TCC_TYPE_RING;
		case BASE_ITEM_CLOAK:			return TCC_TYPE_CLOAK;

		case BASE_ITEM_DRUM:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_MANDOLIN:		return TCC_TYPE_INSTRUMENT;

		case BASE_ITEM_LARGEBOX:
		case BASE_ITEM_BAG:				return TCC_TYPE_CONTAINER;

		case BASE_ITEM_ARMOR:			return TCC_TYPE_ARMOR;

		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_TOWERSHIELD:		return TCC_TYPE_SHIELD;

		case BASE_ITEM_LONGBOW:
		case BASE_ITEM_SHORTBOW:		return TCC_TYPE_BOW;

		case BASE_ITEM_HEAVYCROSSBOW:
		case BASE_ITEM_LIGHTCROSSBOW:	return TCC_TYPE_XBOW;

		case BASE_ITEM_SLING:			return TCC_TYPE_SLING;

		case BASE_ITEM_ARROW:
		case BASE_ITEM_BOLT:
		case BASE_ITEM_BULLET:			return TCC_TYPE_AMMO;

		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_LONGSWORD:
		case BASE_ITEM_BATTLEAXE:
		case BASE_ITEM_BASTARDSWORD:
		case BASE_ITEM_LIGHTFLAIL:
		case BASE_ITEM_WARHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_HALBERD:
		case BASE_ITEM_GREATSWORD:
		case BASE_ITEM_GREATAXE:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_CLUB:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_KAMA:
		case BASE_ITEM_KATANA:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_MORNINGSTAR:
		case BASE_ITEM_QUARTERSTAFF:
		case BASE_ITEM_RAPIER:
		case BASE_ITEM_SCIMITAR:
		case BASE_ITEM_SCYTHE:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_BALORSWORD:
		case BASE_ITEM_BALORFALCHION:
		case BASE_ITEM_DWARVENWARAXE:
		case BASE_ITEM_WHIP:
		case BASE_ITEM_FALCHION:
		case BASE_ITEM_FLAIL:
		case BASE_ITEM_SPEAR:
		case BASE_ITEM_GREATCLUB:
		case BASE_ITEM_TRAINING_CLUB:
		case BASE_ITEM_WARMACE:
		case BASE_ITEM_STEIN: // needs test.
		case BASE_ITEM_SPOON: // needs test.
		case BASE_ITEM_CGIANT_SWORD:
		case BASE_ITEM_CGIANT_AXE:
		case BASE_ITEM_ALLUSE_SWORD:	return TCC_TYPE_MELEE;
	}
	return TCC_TYPE_OTHER;	// incl. torch, spoon, book, scroll, potion, rod/staff/wand,
}							// gem/essence, trapkit, key, inkwell, largebox, misc's, etc.

/* int isMelee(object oItem)
{
	int iType = GetBaseItemType(oItem);
	return StringToInt(Get2DAString(BASEITEMS, "DieToRoll", iType)) != 0
		&& StringToInt(Get2DAString(BASEITEMS, "RangedWeapon", iType)) == 0; // isRanged()=FALSE.
}
int isRanged(object oItem)
{
	int iType = GetBaseItemType(oItem);
	return StringToInt(Get2DAString(BASEITEMS, "RangedWeapon", iType)) != 0;
}
int isArmor(object oItem)
{
	int iType = GetBaseItemType(oItem);
	string sSlots = Get2DAString(BASEITEMS, "EquipableSlots", iType);
	int iSlots = kL_HexStringToInt(sSlots);
	if (iSlots != -1) return (iSlots & 2); // 0x2 (2) is chest-slot.

	return FALSE;
}
int isShield(object oItem)
{
	int iType = GetBaseItemType(oItem);
	if (StringToInt(Get2DAString(BASEITEMS, "BaseAC", iType)) != 0)
	{
		string sSlots = Get2DAString(BASEITEMS, "EquipableSlots", iType);
		int iSlots = kL_HexStringToInt(sSlots);
		if (iSlots != -1) return (iSlots & 32); // 0x20 (32) is lefthand-slot.
	}
	return FALSE;
} */

// Gets if oItem has an ip that excludes that of iRecipeMatch.
int hasExcludedProp(object oItem, int iRecipeMatch)
{
	string sExclusions = Get2DAString(CRAFTING_2DA, "EXCLUDE", iRecipeMatch);
	if (sExclusions != "")
	{
		itemproperty ipScan;

		int iTokens = GetNumberTokens(sExclusions, REAGENT_LIST_DELIMITER);
		int i;
		for (i = 0; i != iTokens; ++i)
		{
			ipScan = GetFirstItemProperty(oItem);
			while (GetIsItemPropertyValid(ipScan))
			{
				if (GetItemPropertyDurationType(ipScan) == DURATION_TYPE_PERMANENT
					&& GetItemPropertyType(ipScan) == GetIntParam(sExclusions, i))
				{
					return TRUE;
				}
				ipScan = GetNextItemProperty(oItem);
			}
		}
	}
	return FALSE;
}

// Gets the material of oItem if any.
// @note TCC-materials disregard stock GMATERIAL_* values. Possible TODO.
int GetMaterialCode(object oItem)
{
	//TellCraft("GetMaterialCode() " + GetTag(oItem));
	int iMaterial = GetLocalInt(oItem, TCC_VAR_MATERIAL);
	if (iMaterial != 0) // MAT_NUL
	{
		//TellCraft(". local material= " + IntToString(iMaterial));
		return iMaterial;
	}

	string sMaterial;

	string sTag = GetTag(oItem);
	int iLength = GetStringLength(sTag);
	if (iLength > 4)
	{
		iLength -= 4;
		int i;
		for (i = 0; i != iLength; ++i)
		{
			sMaterial = GetStringLowerCase(GetSubString(sTag, i, 5));
			//TellCraft(". . test= " + sMaterial);
			if (sMaterial == "_ada_") return  1; // MAT_ADA
			if (sMaterial == "_cld_") return  2; // MAT_CLD
			if (sMaterial == "_drk_") return  3; // MAT_DRK
			if (sMaterial == "_dsk_") return  4; // MAT_DSK
			if (sMaterial == "_mth_") return  5; // MAT_MTH
			if (sMaterial == "_rdh_") return  6; // MAT_RDH
			if (sMaterial == "_shd_") return  7; // MAT_SHD
			if (sMaterial == "_slh_") return  8; // MAT_SLH
			if (sMaterial == "_slv_") return  9; // MAT_SLV
			if (sMaterial == "_uhh_") return 10; // MAT_UHH
			if (sMaterial == "_wyh_") return 11; // MAT_WYH
			if (sMaterial == "_zal_") return 12; // MAT_ZAL
			if (sMaterial == "_wwf_") return 13; // MAT_WWF
			if (sMaterial == "_fmp_") return 14; // MAT_FMP
			if (sMaterial == "_imp_") return 15; // MAT_IMP
		}
	}
	return 0; // MAT_NUL - nothing was found, assume no particular material
}

// Gets the quantity of ip's of iPropType on oItem.
int GetQtyPropsOfType(object oItem, int iPropType)
{
	int i = 0;

	itemproperty ipScan = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipScan))
	{
		if (GetItemPropertyDurationType(ipScan) == DURATION_TYPE_PERMANENT
			&& GetItemPropertyType(ipScan) == iPropType)
		{
			++i;
		}
		ipScan = GetNextItemProperty(oItem);
	}
	return i;
}

// Clears a corresponding Attack bonus ip when upgrading to an Enhancement bonus
// ip that is equal or greater.
// - the AttackBonus can be safely removed because w/ bUpgrade the enchanting
//   will go through w/ Success.
int ReplaceAttackBonus(object oItem, int iPropType, int iCost, int iSubtype)
{
	switch (iPropType)
	{
		case ITEM_PROPERTY_ENHANCEMENT_BONUS:
		{
			int bFound = ClearIpType(oItem, ITEM_PROPERTY_ATTACK_BONUS, iCost);
			bFound = ClearIpType(oItem,
								 ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP,
								 iCost) || bFound;
			bFound = ClearIpType(oItem,
								 ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP,
								 iCost) || bFound;
			bFound = ClearIpType(oItem,
								 ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT,
								 iCost) || bFound;
			return bFound;
		}

		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
			return ClearIpType(oItem,
							   ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP,
							   iCost,
							   iSubtype);

		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
			return ClearIpType(oItem,
							   ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP,
							   iCost,
							   iSubtype);

		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
			return ClearIpType(oItem,
							   ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT,
							   iCost,
							   iSubtype);
	}
	return FALSE;
}

// Clears iPropType from oItem if iCost is higher or equal to existing CostValue.
int ClearIpType(object oItem, int iPropType, int iCost, int iSubtype = -1)
{
	int bFound = FALSE;

	itemproperty ipScan = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipScan))
	{
		if (GetItemPropertyDurationType(ipScan) == DURATION_TYPE_PERMANENT
			&& GetItemPropertyType(ipScan) == iPropType
			&& (iSubtype == -1 || GetItemPropertySubType(ipScan) == iSubtype) // iSubtype will always have a valid value when called by ReplaceAttackBonus()
			&& GetItemPropertyCostTableValue(ipScan) <= iCost)
		{
			bFound = TRUE;
			RemoveItemProperty(oItem, ipScan);
			ipScan = GetFirstItemProperty(oItem);
		}
		else
			ipScan = GetNextItemProperty(oItem);
	}
	return bFound;
}

// Searches oItem for an ip similar to ipProp.
// - this is functionally identical to GetIsItemPropertyAnUpgrade()
// - similar properties have the same type and subtype but may have different
//   parameters beyond that
// - only permanent ip's are checked
// - returns TRUE if a suitable match is found for ipProp
int isIpUpgrade(object oItem, itemproperty ipProp)
{
	//TellCraft("isIpUpgrade() ipProp= " + IntToString(GetItemPropertyType(ipProp)));
	if (!isIgnoredIp(ipProp))
	{
		int iPropType = GetItemPropertyType(ipProp);
		int bIgnoreSub = isIgnoredSubtype(ipProp);
		//TellCraft(". bIgnoreSub= " + IntToString(bIgnoreSub));

		itemproperty ipScan = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(ipScan))
		{
			//TellCraft(". test vs PropType= " + IntToString(GetItemPropertyType(ipScan)));
			//TellCraft(". are Subtypes equal= " + IntToString(GetItemPropertySubType(ipScan) == GetItemPropertySubType(ipProp)));

			if (GetItemPropertyDurationType(ipScan) == DURATION_TYPE_PERMANENT
				&& GetItemPropertyType(ipScan) == iPropType
				&& (bIgnoreSub || GetItemPropertySubType(ipScan) == GetItemPropertySubType(ipProp)))
			{
				//TellCraft(". . is an Upgrade");
				return TRUE;
			}
			ipScan = GetNextItemProperty(oItem);
		}
	}
	//TellCraft(". is NOT an Upgrade");
	return FALSE;
}

// Gets variable prop-costs already used on oItem.
int GetCostSlotsUsed(object oItem)
{
	int i = 0;

	itemproperty ipScan = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipScan))
	{
		if (GetItemPropertyDurationType(ipScan) == DURATION_TYPE_PERMANENT)
			i += StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_SLOTS, GetItemPropertyType(ipScan)));

		ipScan = GetNextItemProperty(oItem);
	}
	return i;
}

// Gets the quantity of ip's on oItem.
int GetPropSlotsUsed(object oItem)
{
	int i = 0;

	itemproperty ipScan = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipScan))
	{
		if (GetItemPropertyDurationType(ipScan) == DURATION_TYPE_PERMANENT)
			++i;

		ipScan = GetNextItemProperty(oItem);
	}
	return i;
}

// Checks if an already existing ip should be ignored.
int isIgnoredIp(itemproperty ip)
{
	if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N)
		return TRUE;

	return FALSE;
}

// Checks if adding an ip should ignore subtype.
int isIgnoredSubtype(itemproperty ip)
{
	int iPropType = GetItemPropertyType(ip);
	if (iPropType == ITEM_PROPERTY_VISUALEFFECT
		|| iPropType == ITEM_PROPERTY_UNLIMITED_AMMUNITION
//		|| iPropType == ITEM_PROPERTY_AC_BONUS									// <- dodge/deflection/etc. should be okay (is handled globally by BaseItems.2da).
		|| Get2DAString(ITEM_PROP_DEF_2DA, "SubTypeResRef", iPropType) == "")	// NOTE: Determine if subType needs to be compared;
	{																			// because even if there is no subType to an ip,
		return TRUE;															// it might be set at "-1" or "0", etc. doh!
	}
	return FALSE;
}

// Checks for +1 attack bonus on Masterwork weapons.
int hasMasterworkAttackBonus(object oItem)
{
	itemproperty ipScan = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipScan))
	{
		if (GetItemPropertyDurationType(ipScan) == DURATION_TYPE_PERMANENT
			&& GetItemPropertyType(ipScan) == ITEM_PROPERTY_ATTACK_BONUS
			&& GetItemPropertyCostTableValue(ipScan) == 1)
		{
			return TRUE;
		}
		ipScan = GetNextItemProperty(oItem);
	}
	return FALSE;
}

// Converts an EncodedIP and returns a constructed IP.
// - based on IPGetItemPropertyByID() in 'x2_inc_itemprop'
itemproperty GetItemPropertyByID(int iType, int iPar1 = 0, int iPar2 = 0, int iPar3 = 0, int iPar4 = 0)
{
	itemproperty ipRet;

	switch (iType)
	{
		case ITEM_PROPERTY_ABILITY_BONUS:								// 0
			ipRet = ItemPropertyAbilityBonus(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_AC_BONUS:									// 1
			ipRet = ItemPropertyACBonus(iPar1);
			break;
		case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:					// 2
			ipRet = ItemPropertyACBonusVsAlign(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:						// 3
			ipRet = ItemPropertyACBonusVsDmgType(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:					// 4
			ipRet = ItemPropertyACBonusVsRace(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:				// 5
			ipRet = ItemPropertyACBonusVsSAlign(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:						// 84
			ipRet = ItemPropertyArcaneSpellFailure(iPar1);
			break;
		case ITEM_PROPERTY_ATTACK_BONUS:								// 56
			ipRet = ItemPropertyAttackBonus(iPar1);
			break;
		case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:				// 57
			ipRet = ItemPropertyAttackBonusVsAlign(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:				// 58
			ipRet = ItemPropertyAttackBonusVsRace(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:			// 59
			ipRet = ItemPropertyAttackBonusVsSAlign(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:					// 11
			ipRet = ItemPropertyWeightReduction(iPar1);
			break;
		case ITEM_PROPERTY_BONUS_FEAT:									// 12
			ipRet = ItemPropertyBonusFeat(iPar1);
			break;
		case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:					// 13
			ipRet = ItemPropertyBonusLevelSpell(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_CAST_SPELL:									// 15
			ipRet = ItemPropertyCastSpell(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DAMAGE_BONUS:								// 16
			ipRet = ItemPropertyDamageBonus(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:				// 17
			ipRet = ItemPropertyDamageBonusVsAlign(iPar1, iPar2, iPar3);
			break;
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:				// 18
			ipRet = ItemPropertyDamageBonusVsRace(iPar1, iPar2, iPar3);
			break;
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:			// 19
			ipRet = ItemPropertyDamageBonusVsSAlign(iPar1, iPar2, iPar3);
			break;
//		case ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED:					// 22
		case ITEM_PROPERTY_DAMAGE_REDUCTION:							// 90	// JLR-OEI 04/03/06: NOW it is 85 (old one is deprecated!)
			ipRet = ItemPropertyDamageReduction(iPar1, iPar2, iPar3, iPar4);	// kevL: NOW it is 90!!! No it's not: in fact, itemproperty DamageReduction
			break;																// cannot be scripted at all; it can be added in the toolset only.
		case ITEM_PROPERTY_DAMAGE_RESISTANCE:							// 23
			ipRet = ItemPropertyDamageResistance(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DAMAGE_VULNERABILITY:						// 24
			ipRet = ItemPropertyDamageVulnerability(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DARKVISION:									// 26
			ipRet = ItemPropertyDarkvision();
			break;
		case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:						// 27
			ipRet = ItemPropertyDecreaseAbility(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DECREASED_AC:								// 28
			ipRet = ItemPropertyDecreaseAC(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:					// 60
			ipRet = ItemPropertyAttackPenalty(iPar1);
			break;
		case ITEM_PROPERTY_DECREASED_DAMAGE:							// 21
			ipRet = ItemPropertyDamagePenalty(iPar1);
			break;
		case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:				// 10
			ipRet = ItemPropertyEnhancementPenalty(iPar1);
			break;
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS:						// 49
			ipRet = ItemPropertyReducedSavingThrow(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:			// 50
			ipRet = ItemPropertyReducedSavingThrowVsX(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:					// 29
			ipRet = ItemPropertyDecreaseSkill(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:			// 32
			ipRet = ItemPropertyContainerReducedWeight(iPar1);
			break;
		case ITEM_PROPERTY_ENHANCEMENT_BONUS:							// 6
			ipRet = ItemPropertyEnhancementBonus(iPar1);
			break;
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:		// 7
			ipRet = ItemPropertyEnhancementBonusVsAlign(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:			// 8
			ipRet = ItemPropertyEnhancementBonusVsRace(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:	// 9
			ipRet = ItemPropertyEnhancementBonusVsSAlign(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:						// 33
			ipRet = ItemPropertyExtraMeleeDamageType(iPar1);
			break;
		case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:					// 34
			ipRet = ItemPropertyExtraRangeDamageType(iPar1);
			break;
		case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:							// 75
			ipRet = ItemPropertyFreeAction();
			break;
		case ITEM_PROPERTY_HASTE:										// 35
			ipRet = ItemPropertyHaste();
			break;
		case ITEM_PROPERTY_HEALERS_KIT:									// 80
			ipRet = ItemPropertyHealersKit(iPar1);
			break;
		case ITEM_PROPERTY_HOLY_AVENGER:								// 36
			ipRet = ItemPropertyHolyAvenger();
			break;
		case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:						// 20
			ipRet = ItemPropertyDamageImmunity(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:						// 37
			ipRet = ItemPropertyImmunityMisc(iPar1);
			break;
		case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:						// 53
			ipRet = ItemPropertySpellImmunitySpecific(iPar1);
			break;
		case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:						// 54
			ipRet = ItemPropertySpellImmunitySchool(iPar1);
			break;
		case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:					// 78
			ipRet = ItemPropertyImmunityToSpellLevel(iPar1);
			break;
		case ITEM_PROPERTY_IMPROVED_EVASION:							// 38
			ipRet = ItemPropertyImprovedEvasion();
			break;
		case ITEM_PROPERTY_KEEN:										// 43
			ipRet = ItemPropertyKeen();
			break;
		case ITEM_PROPERTY_LIGHT:										// 44
			ipRet = ItemPropertyLight(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_MASSIVE_CRITICALS:							// 74
			ipRet = ItemPropertyMassiveCritical(iPar1);
			break;
		case ITEM_PROPERTY_MIGHTY:										// 45 - kL_fix.
			ipRet = ItemPropertyMaxRangeStrengthMod(iPar1);
			break;
//		case ITEM_PROPERTY_MIND_BLANK:									// 46
//			ipRet = ?(iPar1);
//			break;
		case ITEM_PROPERTY_MONSTER_DAMAGE:								// 77
			ipRet = ItemPropertyMonsterDamage(iPar1);
			break;
		case ITEM_PROPERTY_NO_DAMAGE:									// 47
			ipRet = ItemPropertyNoDamage();
			break;
		case ITEM_PROPERTY_ON_HIT_PROPERTIES:							// 48
			ipRet = ItemPropertyOnHitProps(iPar1, iPar2, iPar3);
			break;
		case ITEM_PROPERTY_ON_MONSTER_HIT:								// 72
			ipRet = ItemPropertyOnMonsterHitProperties(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_ONHITCASTSPELL:								// 82
			ipRet = ItemPropertyOnHitCastSpell(iPar1, iPar2);
			break;
//		case ITEM_PROPERTY_POISON:										// 76
//			// NWSCRIPT.nss: no longer working, poison is now a on_hit subtype
//			ipRet = ();
//			break;
		case ITEM_PROPERTY_REGENERATION:								// 51
			ipRet = ItemPropertyRegeneration(iPar1);
			break;
		case ITEM_PROPERTY_REGENERATION_VAMPIRIC:						// 67
			ipRet = ItemPropertyVampiricRegeneration(iPar1);
			break;
		case ITEM_PROPERTY_SAVING_THROW_BONUS:							// 40
			ipRet = ItemPropertyBonusSavingThrow(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:					// 41
			ipRet = ItemPropertyBonusSavingThrowVsX(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_SKILL_BONUS:									// 52
			ipRet = ItemPropertySkillBonus(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_SPECIAL_WALK:								// 79
			ipRet = ItemPropertySpecialWalk(iPar1);
			break;
		case ITEM_PROPERTY_SPELL_RESISTANCE:
			ipRet = ItemPropertyBonusSpellResistance(iPar1);			// 39
			break;
		case ITEM_PROPERTY_THIEVES_TOOLS:
			ipRet = ItemPropertyThievesTools(iPar1);					// 55
			break;
		case ITEM_PROPERTY_TRAP:										// 70
			ipRet = ItemPropertyTrap(iPar1, iPar2);
			break;
		case ITEM_PROPERTY_TRUE_SEEING:									// 71
			ipRet = ItemPropertyTrueSeeing();
			break;
		case ITEM_PROPERTY_TURN_RESISTANCE:								// 73
			ipRet = ItemPropertyTurnResistance(iPar1);
			break;
		case ITEM_PROPERTY_UNLIMITED_AMMUNITION:						// 61
			ipRet = ItemPropertyUnlimitedAmmo(iPar1);
			break;
		case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:				// 62
			ipRet = ItemPropertyLimitUseByAlign(iPar1);
			break;
		case ITEM_PROPERTY_USE_LIMITATION_CLASS:						// 63
			ipRet = ItemPropertyLimitUseByClass(iPar1);
			break;
		case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:					// 64
			ipRet = ItemPropertyLimitUseByRace(iPar1);
			break;
		case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:			// 65
			ipRet = ItemPropertyLimitUseBySAlign(iPar1);
			break;
		case ITEM_PROPERTY_VISUALEFFECT:								// 83
			ipRet = ItemPropertyVisualEffect(iPar1);
			break;
		case ITEM_PROPERTY_WEIGHT_INCREASE:								// 81
			ipRet = ItemPropertyWeightIncrease(iPar1);
			break;
		case ITEM_PROPERTY_BONUS_HITPOINTS:								// 66
			ipRet = ItemPropertyBonusHitpoints(iPar1);
			break;
	}

	return ipRet;
}

// -----------------------------------------------------------------------------
// functions for Property Sets
// -----------------------------------------------------------------------------

// Gets the quantity of Property Set latent-ip strings stored on oItem.
int GetQtyLatentIps(object oItem)
{
	// TODO: can the string-var be set w/ a blank string, or is it true that if
	// there's a var present it will always define a latent-ip ...

	int iTotal = 0;

	int iLength = GetStringLength(TCC_VAR_SET_GROUP_PRE);

	int i;
	int iVars = GetVariableCount(oItem);
	for (i = 0; i != iVars; ++i)
	{
		string sVar = GetVariableName(oItem, i);
		if (GetStringLeft(sVar, iLength) == TCC_VAR_SET_GROUP_PRE)
			++iTotal;
	}
	return iTotal;
}

// Sets the group of a Property Set to indicate that the next ip added should be
// part of that Set.
// - this variable will be deleted once it has been interpreted and added to oItem
void SetLatentPartReady(object oItem, int iGroup)
{
	SetLocalInt(oItem, TCC_VAR_SET_FLAG, iGroup);
}

// Gets the group of the Property Set that's about to be added to oItem.
// - 0 indicates a non-SetProperty (ie. regular) ip
int GetLatentPartReady(object oItem)
{
	return GetLocalInt(oItem, TCC_VAR_SET_FLAG);
}

// Adds sEncodedIp to oItem.
// - iGroup		: the quantity of parts required to activate the ip (the group)
// - sEncodedIp	: the encoded-ip per Crafting.2da EFFECTS
// @note The actual ip will be constructed/deconstructed by tag-based scripts.
void AddLatentIp(object oItem, int iGroup, string sEncodedIp, object oCrafter)
{
	if (GetLocalString(oItem, TCC_VAR_SET_LABEL) != "")
	{
		SetLocalString(oItem, TCC_VAR_SET_GROUP_PRE + IntToString(iGroup), sEncodedIp);
		DeleteLocalInt(oItem, TCC_VAR_SET_FLAG);
	}
	else
		NotifyPlayer(oCrafter, -1, "This item is not part of an item Set!");
}


// Gets the quantity of equipped parts of the specified Property Set.
int GetQtyLatentPartsEquipped(string sSetLabel, object oPC)
{
	int iParts = 0;

	object oItem;
	int iSlot;
	for (iSlot = INVENTORY_SLOT_HEAD; iSlot != INVENTORY_SLOT_ARROWS; ++iSlot)
	{
		oItem = GetItemInSlot(iSlot, oPC);
		if (GetIsObjectValid(oItem)
			&& GetLocalString(oItem, TCC_VAR_SET_LABEL) == sSetLabel)
		{
			++iParts;
		}
	}
	return iParts;
}

// Activates or deactivates Property Set ip's of the appropriate group.
// kL_NOTE: I don't trust the code to work well with any items that are parts of
// more than one Property Set. Mainly because it relies on the variable
// TCC_VAR_SET_LABEL, which is specified in 'gui_tcc_constructset' and can be
// the same as other Sets or blank at the discretion of the player. It also
// seems possible for a SetLabel to be overwritten by another if/when an item is
// subsumed into another Set after it's been assigned to its first Set (unless
// the tcc_config value is turned on/off, in which case the part may be rejected
// and all reagents would be lost regardless). In sum: plenty of holes for
// things to go borky.
void ToggleSetGroup(string sSetLabel, int iPartsEquipped, object oPC)
{
	TellCraft("\nTOGGLE SET GROUP");

	int iLength = GetStringLength(TCC_VAR_SET_GROUP_PRE);
	int iGroup;

	object oItem;
	string sVar;

	int iSlot;
	for (iSlot = INVENTORY_SLOT_HEAD; iSlot != INVENTORY_SLOT_ARROWS; ++iSlot)
	{
		oItem = GetItemInSlot(iSlot, oPC);
		if (GetIsObjectValid(oItem)
			&& GetLocalString(oItem, TCC_VAR_SET_LABEL) == sSetLabel)
		{
			DeactivateLatentIps(oItem);

			int i;
			int iVars = GetVariableCount(oItem);
			for (i = 0; i != iVars; ++i)
			{
				sVar = GetVariableName(oItem, i);
				if (GetStringLeft(sVar, iLength) == TCC_VAR_SET_GROUP_PRE)
				{
					iGroup = StringToInt(GetStringRight(sVar, GetStringLength(sVar) - iLength));
					if (iGroup <= iPartsEquipped) //&& GetLocalString(oItem, TCC_VAR_SET_GROUP_PRE + IntToString(iParts)) != "")
						ActivateLatentIp(oItem, iGroup, oPC);
				}
			}
		}
	}
}

// Clears all active Property Set ip's from oItem.
void DeactivateLatentIps(object oItem)
{
	TellCraft("DeactivateLatentIps : " + GetName(oItem) + " ( " + GetTag(oItem) + " )");

	itemproperty ipProp, ipScan;

	int iPropType, iPropSubType, iPropCostTable, iPropCostTableValue;
	int iScanType, iScanSubType, iScanCostTable, iScanCostTableValue;

	string sVar, sLatentIp;

	int iLength = GetStringLength(TCC_VAR_SET_GROUP_PRE);

	int i;
	int iVars = GetVariableCount(oItem);
	for (i = 0; i != iVars; ++i)
	{
		sVar = GetVariableName(oItem, i);
		if (GetStringLeft(sVar, iLength) == TCC_VAR_SET_GROUP_PRE)
		{
			TellCraft(". check var : " + sVar);

			sLatentIp = GetLocalString(oItem, sVar);
			if (sLatentIp != "") // if a SetProp exists de-activate it
			{
				TellCraft(". . check ip : " + sLatentIp);

				ipProp = GetItemPropertyByID(GetIntParam(sLatentIp, 0), // TODO: Check if 'sLatentIp' can really be used by GetIntParam().
											 GetIntParam(sLatentIp, 1),
											 GetIntParam(sLatentIp, 2),
											 GetIntParam(sLatentIp, 3),
											 GetIntParam(sLatentIp, 4));

				iPropType			= GetItemPropertyType(ipProp);
				iPropSubType		= GetItemPropertySubType(ipProp);
				iPropCostTable		= GetItemPropertyCostTable(ipProp);
				iPropCostTableValue	= GetItemPropertyCostTableValue(ipProp);

				//TellCraft(". . . iPropType= "				+ IntToString(iPropType));
				//TellCraft(". . . iPropSubType= "			+ IntToString(iPropSubType));
				//TellCraft(". . . iPropCostTable= "		+ IntToString(iPropCostTable));
				//TellCraft(". . . iPropCostTableValue= "	+ IntToString(iPropCostTableValue));

				ipScan = GetFirstItemProperty(oItem);
				while (GetIsItemPropertyValid(ipScan))
				{
					iScanType			= GetItemPropertyType(ipScan);
					iScanSubType		= GetItemPropertySubType(ipScan);
					iScanCostTable		= GetItemPropertyCostTable(ipScan);
					iScanCostTableValue	= GetItemPropertyCostTableValue(ipScan);

					//TellCraft(". . . . iScanType= "			+ IntToString(iScanType));
					//TellCraft(". . . . iScanSubType= "		+ IntToString(iScanSubType));
					//TellCraft(". . . . iScanCostTable= "		+ IntToString(iScanCostTable));
					//TellCraft(". . . . iScanCostTableValue= "	+ IntToString(iScanCostTableValue));

					if (isIgnoredSubtype(ipScan))
					{
						//TellCraft(". . . . . ignore subtype");
						iScanSubType = iPropSubType;
					}

					//TellCraft(". type match= "			+ IntToString(iScanType				== iPropType));
					//TellCraft(". subtype match= "			+ IntToString(iScanSubType			== iPropSubType));
					//TellCraft(". costtable match= "		+ IntToString(iScanCostTable		== iPropCostTable));
					//TellCraft(". costtablevalue match= "	+ IntToString(iScanCostTableValue	== iPropCostTableValue));

					if (   iScanType			== iPropType
						&& iScanSubType			== iPropSubType
						&& iScanCostTable		== iPropCostTable
						&& iScanCostTableValue	== iPropCostTableValue)
					{
						TellCraft(". . . clear ip");
						RemoveItemProperty(oItem, ipScan);
						ipScan = GetFirstItemProperty(oItem);
					}
					else
					{
						TellCraft(". . . no match");
						ipScan = GetNextItemProperty(oItem);
					}
				}
			}
		}
	}
}

// Adds the Property Set ip if any of the specified group.
void ActivateLatentIp(object oItem, int iGroup, object oPC)
{
	string sSetProp = GetLocalString(oItem, TCC_VAR_SET_GROUP_PRE + IntToString(iGroup));
	NotifyPlayer(oPC, -1, // TODO: a better player-notice.
			"Activating ( " + sSetProp + " ) on " + GetName(oItem) + " ( parts " + IntToString(iGroup) + " )");

	itemproperty ipProp = GetItemPropertyByID(GetIntParam(sSetProp, 0),
											  GetIntParam(sSetProp, 1),
											  GetIntParam(sSetProp, 2),
											  GetIntParam(sSetProp, 3),
											  GetIntParam(sSetProp, 4));

	IPSafeAddItemProperty(oItem, ipProp, 0.f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}


// ____________________________________________________________________________
//  ----------------------------------------------------------------------------
//   MUNDANE CRAFTING
// ____________________________________________________________________________
//  ----------------------------------------------------------------------------

// Does crafting at a Smith Workbench with a smith's hammer.
// - requires a set of reagents, a specific skill level, and a smith hammer to
//   activate it.
// - reagents can be of any item type
void DoMundaneCrafting(object oCrafter)
{
	string sTriggerId;

	int iPrefixLength = GetStringLength(MUNDANE_RECIPE_TRIGGER);
	string sTag;
	object oItem = GetFirstItemInInventory();
	while (GetIsObjectValid(oItem))
	{
		sTag = GetTag(oItem);
		if (GetStringLeft(sTag, iPrefixLength) == MUNDANE_RECIPE_TRIGGER)
		{
			sTriggerId = sTag;
			break;
		}
		oItem = GetNextItemInInventory();
	}
	//TellCraft("DoMundaneCrafting() sTriggerId= " + sTriggerId);

	if (sTriggerId == "")
	{
		NotifyPlayer(oCrafter, ERROR_MISSING_REQUIRED_MOLD);
		return;
	}

	int iRecipeMatch = GetInventoryRecipeMatch(sTriggerId);
	//TellCraft(". iRecipeMatch= " + IntToString(iRecipeMatch));
	if (iRecipeMatch == -1)
	{
		NotifyPlayer(oCrafter, ERROR_RECIPE_NOT_FOUND);
		return;
	}

	int iSkillRankReq	= StringToInt(Get2DAString(CRAFTING_2DA, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch));
	int iSkill			= StringToInt(Get2DAString(CRAFTING_2DA, COL_CRAFTING_CRAFT_SKILL, iRecipeMatch));
	int iSkillRankPC	= GetSkillRank(iSkill, oCrafter);

	if (iSkillRankPC < iSkillRankReq)
	{
		int iError;
		switch (iSkill)
		{
			default:
			case SKILL_CRAFT_WEAPON:
				iError = ERROR_INSUFFICIENT_CRAFT_WEAPON_SKILL;
				break;
			case SKILL_CRAFT_ARMOR:
				iError = ERROR_INSUFFICIENT_CRAFT_ARMOR_SKILL;
				break;
			case SKILL_CRAFT_TRAP:
				iError = ERROR_INSUFFICIENT_CRAFT_TRAP_SKILL;
		}
		NotifyPlayer(oCrafter, iError);
		return;
	}

	DestroyItemsInInventory();


	string sResrefList = Get2DAString(CRAFTING_2DA, COL_CRAFTING_OUTPUT, iRecipeMatch);
	int bMasterwork = FALSE;

	if (Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 28) != "0") // TCC_Toggle_CreateMasterworkItems
	{
		int iTCC_MasterworkSkillModifier = StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 33)); // TCC_Value_MasterworkSkillModifier
		if (iTCC_MasterworkSkillModifier + iSkillRankReq <= iSkillRankPC)
		{
			NotifyPlayer(oCrafter, -1, "You have created a masterpiece !");

			bMasterwork = TRUE;
		}
	}
	CreateListOfItemsInInventory(sResrefList, OBJECT_SELF, TRUE, bMasterwork, TRUE);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_BLACKSMITH), OBJECT_SELF);
	NotifyPlayer(oCrafter);
}


// ____________________________________________________________________________
//  ----------------------------------------------------------------------------
//   ALCHEMICAL CRAFTING
// ____________________________________________________________________________
//  ----------------------------------------------------------------------------

// Does crafting at an Alchemy Workbench with a mortar & pestle.
// - alchemy crafting requires a set of reagents, a specific skill level in
//   Alchemy, and a mortar & pestle to activate it
// - reagents can be of any item type
// - alchemy has no index
void DoAlchemyCrafting(object oCrafter)
{
	int iRecipeMatch = GetInventoryRecipeMatch(ALCHEMY_RECIPE_TRIGGER);
	//TellCraft("iRecipeMatch = " + IntToString(iRecipeMatch));
	if (iRecipeMatch == -1)
	{
		NotifyPlayer(oCrafter, ERROR_RECIPE_NOT_FOUND);
		return;
	}

	int iSkillRankReq = StringToInt(Get2DAString(CRAFTING_2DA, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch));
	if (GetSkillRank(SKILL_CRAFT_ALCHEMY, oCrafter) < iSkillRankReq)
	{
		NotifyPlayer(oCrafter, ERROR_INSUFFICIENT_CRAFT_ALCHEMY_SKILL);
		return;
	}

	DestroyItemsInInventory();

	string sResrefList = Get2DAString(CRAFTING_2DA, COL_CRAFTING_OUTPUT, iRecipeMatch);
	CreateListOfItemsInInventory(sResrefList);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_ALCHEMY), OBJECT_SELF);
	NotifyPlayer(oCrafter);
}


// ____________________________________________________________________________
//  ----------------------------------------------------------------------------
//   DISTILLATION
// ____________________________________________________________________________
//  ----------------------------------------------------------------------------

// Distills oItem when mortar & pestle is used directly on it.
// - distillation requires an acted upon item (reagent), a specific skill level
//   in Alchemy, and a mortar & pestle to activate it
// - reagent can be of any item type
// - also begins a salavage operation
// - distillation has no index
void DoDistillation(object oItem, object oCrafter)
{
	//TellCraft("\nDoDistillation : " + GetName(oItem) + " ( " + GetTag(oItem) + " )");

	int iRecipeMatch = GetRecipeMatch(GetTag(oItem), DISTILLATION_RECIPE_TRIGGER);
	//TellCraft(". iRecipeMatch = " + IntToString(iRecipeMatch));

	if (iRecipeMatch != -1)
	{
		//TellCraft(". . distilling");
		int iSkillRankReq = StringToInt(Get2DAString(CRAFTING_2DA, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch));
		string sResrefList = Get2DAString(CRAFTING_2DA, COL_CRAFTING_OUTPUT, iRecipeMatch);
		ExecuteDistillation(iSkillRankReq, oItem, oCrafter, sResrefList);
	}
	else if (!StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 29))) // TCC_Toggle_AllowItemSalvaging
	{
		//TellCraft(". . salvaging not allowed");
		NotifyPlayer(oCrafter, ERROR_ITEM_NOT_DISTILLABLE);
	}
	else // ITEM SALVAGE SECTION ->
	{
		//TellCraft(". . salvaging TCC-type : " + IntToString(GetTccType(oItem)));
		switch (GetTccType(oItem))
		{
			default:
				if (!GetPlotFlag(oItem))
				{
					//TellCraft(". . . not plot ExecuteSalvage");
					ExecuteSalvage(oItem, oCrafter);
					break;
				}
				// no break;

			case TCC_TYPE_NONE:
			case TCC_TYPE_OTHER:
				NotifyPlayer(oCrafter, -1, "You cannot distill or salvage any materials !");
		}
	}
}


// Helper for DoDistillation() -- but also used directly by the mortar & pestle
// on Fairy Dust and Shadow Reaver Bones.
void ExecuteDistillation(int iSkillRankReq, object oItem, object oCrafter, string sResrefList)
{
	if (GetSkillRank(SKILL_CRAFT_ALCHEMY, oCrafter) < iSkillRankReq)
	{
		NotifyPlayer(oCrafter, ERROR_INSUFFICIENT_CRAFT_ALCHEMY_SKILL);
		return;
	}

	int iStackSize = GetItemStackSize(oItem); // can distill multiple objects at once.
	DestroyObject(oItem);

	int i;
	for (i = 0; i != iStackSize; ++i)
	{
		CreateListOfItemsInInventory(sResrefList, oCrafter);
	}

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_SELF), GetLocation(oCrafter));
	NotifyPlayer(oCrafter);
}


// -----------------------------------------------------------------------------
// private functions for salvage operations
// -----------------------------------------------------------------------------

// Scans the ip's of oItem and produces salvaged materials.
// - creates salvaged materials in the same way as distilled items
void ExecuteSalvage(object oItem, object oCrafter)
{
	int iSalvageIndex, iSalvageGrade, iScanDC;

	int iSalvageDC = 1;
	int iSkillRankReq = 9999;

	string sFailureProduct = "";
	string sSuccessProduct = "";

	string sEss;

	itemproperty ipScan = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipScan))
	{
		iSalvageIndex = GetSalvageIndex(ipScan);
		if (iSalvageIndex != -1)									// process only if ip is valid for salvage
		{
			iSalvageGrade = GetSalvageGrade(ipScan, iSalvageIndex);

			iScanDC = GetSalvageDC(iSalvageIndex, iSalvageGrade);	// 'iSalvageDC' will be the highest DC
			if (iScanDC > iSalvageDC)
				iSalvageDC = iScanDC;

			if (iScanDC < iSkillRankReq)							// 'iSkillRankReq' will be the lowest DC
				iSkillRankReq = iScanDC;

			if (sFailureProduct != "")								// assemble each ip's salvage-product
				sFailureProduct += ",";

			if (sSuccessProduct != "")
				sSuccessProduct += ",";

			sEss = GetSalvageEssence(iSalvageIndex, iSalvageGrade);
			sFailureProduct += sEss;
			sSuccessProduct += sEss + "," + GetSalvageGem(iSalvageIndex, iSalvageGrade);
		}
		ipScan = GetNextItemProperty(oItem);
	}

	if (sFailureProduct == "")
	{
		NotifyPlayer(oCrafter, -1, "There are no materials that can be salvaged.");
		return;
	}

	if (iSkillRankReq - 5 > GetSkillRank(SKILL_SPELLCRAFT, oCrafter) // check required skill level
		&& StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 30))) // TCC_Toggle_SalvagingRequiresMinSkill
	{
		NotifyPlayer(oCrafter, -1, "Your Spellcraft skill is not high enough to salvage any materials.");
		return;
	}

	int iStackMax = StringToInt(Get2DAString("baseitems", "Stacking", GetBaseItemType(oItem)));
	if (iStackMax > 1) // check the chance of distilling a stack
	{
		int iStackSize = GetItemStackSize(oItem);
		int iChance = FloatToInt(100.f * (IntToFloat(iStackSize) / IntToFloat(iStackMax)));

		int iRoll = d100();
		if (iRoll > iChance) // fail.
		{
			NotifyPlayer(oCrafter, -1, "<c=turquoise>Salvage Stack :</c> <c=red>* Failure *</c> <c=blue>( d100 : "
								  + IntToString(iRoll) + " vs " + IntToString(iChance) + " )</c>");
			NotifyPlayer(oCrafter, -1, "There was not enough left of the stack to salvage anything.");

			DestroyObject(oItem);
			return;
		}
		else
			NotifyPlayer(oCrafter, -1, "<c=turquoise>Salvage Stack :</c> <c=green>* Success *</c> <c=blue>( d100 : "
								  + IntToString(iRoll) + " vs " + IntToString(iChance) + " )</c>");
	}

	string sProduct; // do a skill check and create the products - auto success if no skillcheck required
	if (!StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 31)) // TCC_Toggle_SalvagingUsesSkillCheck
		|| GetIsSkillSuccessful(oCrafter, SKILL_SPELLCRAFT, iSalvageDC))
	{
		sProduct = sSuccessProduct;
	}
	else
		sProduct = sFailureProduct;

	DestroyObject(oItem);
	CreateListOfItemsInInventory(sProduct, oCrafter);
}

// -----------------------------------------------------------------------------
// helper functions for salvaging
// -----------------------------------------------------------------------------

// Gets the index of the salvage row associated with ipProp.
// -1 if there is no match
int GetSalvageIndex(itemproperty ipProp)
{
	int iPropType = GetItemPropertyType(ipProp);

	int iTotal = GetNum2DARows(TCC_SALVAGE_2da);
	int i;
	for (i = 0; i != iTotal; ++i)
	{
		if (StringToInt(Get2DAString(TCC_SALVAGE_2da, "PROPERTY", i)) == iPropType)
			return i;
	}
	return -1;
}

// Gets the salvage grade for ipProp.
// - returns 1..4
int GetSalvageGrade(itemproperty ipProp, int iIndex)
{
	int iRange = StringToInt(Get2DAString(TCC_SALVAGE_2da, "RANGE", iIndex));
	if (iRange == 1) // note: Range 1 properties require only Grade 1 skillz.
		return 1;

	int iCost = GetItemPropertyCostTableValue(ipProp); // else solve for the ip-cost
	if (iCost <= iRange / 4)
		return 1;

	if (iCost <= iRange / 2)
		return 2;

	if (iCost <= iRange * 3 / 4)
		return 3;

	return 4;
}

// Gets the skill DC related by iIndex and iGrade.
int GetSalvageDC(int iIndex, int iGrade)
{
	int iDC;
	switch (iGrade)
	{
		default: // should never happen.
		case 1: iDC = StringToInt(Get2DAString(TCC_SALVAGE_2da, "SKILL1", iIndex));
		case 2: iDC = StringToInt(Get2DAString(TCC_SALVAGE_2da, "SKILL2", iIndex));
		case 3: iDC = StringToInt(Get2DAString(TCC_SALVAGE_2da, "SKILL3", iIndex));
		case 4: iDC = StringToInt(Get2DAString(TCC_SALVAGE_2da, "SKILL4", iIndex));
	}
	return iDC + StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 0)); // TCC_Value_SalvageDCModifier
}

// Gets the tag of the essence related by iIndex and iGrade.
// - should be the resref but whatever. See Tcc_Salvage.2da
string GetSalvageEssence(int iIndex, int iGrade)
{
	switch (iGrade)
	{
		case 1: return Get2DAString(TCC_SALVAGE_2da, "ESSENCE1", iIndex);
		case 2: return Get2DAString(TCC_SALVAGE_2da, "ESSENCE2", iIndex);
		case 3: return Get2DAString(TCC_SALVAGE_2da, "ESSENCE3", iIndex);
		case 4: return Get2DAString(TCC_SALVAGE_2da, "ESSENCE4", iIndex);
	}
	return ""; // should never happen.
}

// Gets the tag of the gem related by iIndex and iGrade.
// - should be the resref but whatever. See Tcc_Salvage.2da
string GetSalvageGem(int iIndex, int iGrade)
{
	switch (iGrade)
	{
		case 1: return Get2DAString(TCC_SALVAGE_2da, "GEM1", iIndex);
		case 2: return Get2DAString(TCC_SALVAGE_2da, "GEM2", iIndex);
		case 3: return Get2DAString(TCC_SALVAGE_2da, "GEM3", iIndex);
		case 4: return Get2DAString(TCC_SALVAGE_2da, "GEM4", iIndex);
	}
	return ""; // should never happen.
}


// -----------------------------------------------------------------------------
// functions that invoke GUI-inputboxes
// -----------------------------------------------------------------------------

// Invokes a GUI-inputbox for player to relabel oItem.
// @param oCrafter	- a currently controlled character;
//					  either the crafter or the user of a Smith Hammer on oItem
// @param oItem		- the item to relabel
void SetEnchantedItemName(object oCrafter, object oItem)
{
	SetLocalObject(GetModule(), VAR_ENCHANTED_ITEM_OBJECT, oItem);

	int iMessageStrRef		= 181743;	// "How shall this item be known henceforth?"
	string sMessage 		= "";
	string sOkCB			= "gui_name_enchanted_item";
	string sCancelCB		= "gui_name_enchanted_item_cancel";
	int bShowCancel 		= TRUE;		// kL_note: was FALSE; but it shows anyway.
	string sScreenName		= "";		// SCREEN_STRINGINPUT_MESSAGEBOX (default)
	int iOkStrRef			= 181744;	// "Okay"
	string sOkString		= "";
	int iCancelStrRef		= 181745;	// "Cancel"
	string sCancelString	= "";
	string sDefaultString	= GetFirstName(oItem);
	string sVariableString	= "";

	// The gui-script will always run on the Owned PC regardless of who the
	// player has possessed. So switch player-controlled-character to Owned PC
	// for this purpose only. Note that this is not strictly necessary to do
	// explicitly.

	DisplayInputBox(GetOwnedCharacter(oCrafter),
					iMessageStrRef,
					sMessage,
					sOkCB,
					sCancelCB,
					bShowCancel,
					sScreenName,
					iOkStrRef,
					sOkString,
					iCancelStrRef,
					sCancelString,
					sDefaultString,
					sVariableString);
}

// Opens a GUI inputbox for entering an Imbue_Item triggerspell.
// @param oCrafter - the crafter
void SetTriggerSpell(object oCrafter)
{
	SetLocalObject(GetModule(), II_VAR_CONTAINER, OBJECT_SELF);	// set the crafting container as a local_object; it
																// will be used to run DoMagicCrafting() again shortly.
	int iMessageStrRef		= -1;
	string sMessage 		= "Enter a Spell ID ( see chat for options )";
	string sOkCB			= "gui_trigger_spell_set";
	string sCancelCB		= "gui_trigger_spell_cancel";
	int bShowCancel 		= TRUE;
	string sScreenName		= "";		// SCREEN_STRINGINPUT_MESSAGEBOX (default)
	int iOkStrRef			= 181744;	// "Okay"
	string sOkString		= "";
	int iCancelStrRef		= 181745;	// "Cancel"
	string sCancelString	= "";
	string sDefaultString	= "";
	string sVariableString	= "";

	// The gui-script will always run on the Owned PC regardless of who the
	// player has possessed. So switch oCrafter to Owned PC for this purpose
	// only. Note that this is not strictly necessary to do explicitly.

	DisplayInputBox(GetOwnedCharacter(oCrafter),
					iMessageStrRef,
					sMessage,
					sOkCB,
					sCancelCB,
					bShowCancel,
					sScreenName,
					iOkStrRef,
					sOkString,
					iCancelStrRef,
					sCancelString,
					sDefaultString,
					sVariableString);
}

// Opens a GUI-inputbox that allows player to label a Set.
// - this will convert all Set-flagged items in the crafting container into
//   Set-parts and destroy any reagent items
void ConstructSet(object oCrafter)
{
	object oModule = GetModule();
	SetLocalObject(oModule, TCC_VAR_SET_CONTAINER, OBJECT_SELF);
	SetLocalObject(oModule, TCC_VAR_SET_CRAFTER, oCrafter);

	int iMessageStrRef		= -1;
	string sMessage 		= "Give your set a unique label :";
	string sOkCB			= "gui_tcc_constructset";
	string sCancelCB		= "";
	int bShowCancel 		= FALSE;
	string sScreenName		= "";		// SCREEN_STRINGINPUT_MESSAGEBOX (default)
	int iOkStrRef			= 181744;	// "Okay"
	string sOkString		= "";
	int iCancelStrRef		= -1;
	string sCancelString	= "";
	string sDefaultString	= "Set";
	string sVariableString	= "";

	// The gui-script will always run on the Owned PC regardless of who the
	// player has possessed. So switch oCrafter to Owned PC for this purpose
	// only. Note that this is not strictly necessary to do explicitly.

	DisplayInputBox(GetOwnedCharacter(oCrafter),
					iMessageStrRef,
					sMessage,
					sOkCB,
					sCancelCB,
					bShowCancel,
					sScreenName,
					iOkStrRef,
					sOkString,
					iCancelStrRef,
					sCancelString,
					sDefaultString,
					sVariableString);
}

// -----------------------------------------------------------------------------
// public functions for mortar & pestle and shaper's alembic
// -----------------------------------------------------------------------------

// Sets up a list of up to 10 elements.
// - the list is simply a comma delimited string
// - only first element is required
string MakeList(string sReagent1,
				string sReagent2  = "",
				string sReagent3  = "",
				string sReagent4  = "",
				string sReagent5  = "",
				string sReagent6  = "",
				string sReagent7  = "",
				string sReagent8  = "",
				string sReagent9  = "",
				string sReagent10 = "")
{
	string sList = sReagent1;

	if (sReagent2  != "") sList += REAGENT_LIST_DELIMITER + sReagent2;
	if (sReagent3  != "") sList += REAGENT_LIST_DELIMITER + sReagent3;
	if (sReagent4  != "") sList += REAGENT_LIST_DELIMITER + sReagent4;
	if (sReagent5  != "") sList += REAGENT_LIST_DELIMITER + sReagent5;
	if (sReagent6  != "") sList += REAGENT_LIST_DELIMITER + sReagent6;
	if (sReagent7  != "") sList += REAGENT_LIST_DELIMITER + sReagent7;
	if (sReagent8  != "") sList += REAGENT_LIST_DELIMITER + sReagent8;
	if (sReagent9  != "") sList += REAGENT_LIST_DELIMITER + sReagent9;
	if (sReagent10 != "") sList += REAGENT_LIST_DELIMITER + sReagent10;

	return sList;
}



// -----------------------------------------------------------------------------
// functions for SoZ crafting
// -----------------------------------------------------------------------------

// Checks if all sEncodedIps qualify as an upgrade.
int GetAreAllEncodedEffectsAnUpgrade(object oItem, string sEncodedIps)
{
	string sEncodedIp;
	struct sStringTokenizer rEncodedIps = GetStringTokenizer(sEncodedIps, ENCODED_IP_LIST_DELIMITER);
	while (HasMoreTokens(rEncodedIps))
	{
		rEncodedIps = AdvanceToNextToken(rEncodedIps);
		sEncodedIp = GetNextToken(rEncodedIps);

		if (!GetIsEncodedEffectAnUpgrade(oItem, sEncodedIp))
			return FALSE; // if any is not an upgrade then all are not an upgrade
	}
	return TRUE;
}

// Checks if sEncodedIp is an upgrade.
int GetIsEncodedEffectAnUpgrade(object oItem, string sEncodedIp)
{
	itemproperty ip = GetEncodedEffectItemProperty(sEncodedIp);
	if (GetIsItemPropertyValid(ip))
		return GetIsItemPropertyAnUpgrade(oItem, ip);

	return FALSE;
}

// Constructs an ip from sEncodedIp.
itemproperty GetEncodedEffectItemProperty(string sEncodedIp)
{
	return GetItemPropertyByID(GetIntParam(sEncodedIp, 0),
							   GetIntParam(sEncodedIp, 1),
							   GetIntParam(sEncodedIp, 2),
							   GetIntParam(sEncodedIp, 3),
							   GetIntParam(sEncodedIp, 4));
}

// Gets whether ip will be treated as an upgrade.
// - this is functionally identical to isIpUpgrade()
int GetIsItemPropertyAnUpgrade(object oItem, itemproperty ip)
{
	if (isIgnoredIp(ip))
		return FALSE;

	return IPGetItemHasProperty(oItem, ip, DURATION_TYPE_PERMANENT, isIgnoredSubtype(ip));
}

// Applies all sEncodedIps to oItem.
// - effects are delimited with a semicolon ";"
void ApplyEncodedEffectsToItem(object oItem, string sEncodedIps)
{
	//TellCraft("applying sEncodedIps " + sEncodedIps);
	string sEncodedIp;
	struct sStringTokenizer rEncodedIps = GetStringTokenizer(sEncodedIps, ENCODED_IP_LIST_DELIMITER);
	while (HasMoreTokens(rEncodedIps))
	{
		rEncodedIps = AdvanceToNextToken(rEncodedIps);
		sEncodedIp = GetNextToken(rEncodedIps);
		AddEncodedIp(oItem, sEncodedIp);
	}
}

// Adds sEncodedIp to oItem.
void AddEncodedIp(object oItem, string sEncodedIp)
{
	itemproperty ipEnchant = GetItemPropertyByID(GetIntParam(sEncodedIp, 0),
												 GetIntParam(sEncodedIp, 1),
												 GetIntParam(sEncodedIp, 2),
												 GetIntParam(sEncodedIp, 3),
												 GetIntParam(sEncodedIp, 4));
	if (GetIsItemPropertyValid(ipEnchant))
	{
		int iPolicy; // AddItemPropertyAutoPolicy(oItem, ipEnchant);
		if (isIgnoredIp(ipEnchant))
			iPolicy = X2_IP_ADDPROP_POLICY_IGNORE_EXISTING;
		else
			iPolicy = X2_IP_ADDPROP_POLICY_REPLACE_EXISTING;

		IPSafeAddItemProperty(oItem,
							  ipEnchant,
							  0.f,
							  iPolicy,
							  FALSE,
							  isIgnoredSubtype(ipEnchant));
	}
	//else TellCraft("ERROR : AddEncodedIp() ipEnchant is invalid ( " + sEncodedIp + " )");
}


// -----------------------------------------------------------------------------
// functions that were factored into others or are unused
// -----------------------------------------------------------------------------

/* Creates a list containing the property and parameters of an effect to apply.
// - property-ID required
// - see IPSafeAddItemProperty() in 'x2_inc_itemprop' for supported values
string MakeEncodedEffect(int iPropType, int iPar1 = 0, int iPar2 = 0, int iPar3 = 0, int iPar4 = 0)
{
	return IntToString(iPropType)
		 + REAGENT_LIST_DELIMITER + IntToString(iPar1)	// note: Yes these use commas.
		 + REAGENT_LIST_DELIMITER + IntToString(iPar2)	// But the delimiter between each encoded ip
		 + REAGENT_LIST_DELIMITER + IntToString(iPar3)	// when there are multiple encoded ip's
		 + REAGENT_LIST_DELIMITER + IntToString(iPar4);	// is ENCODED_IP_LIST_DELIMITER (semi-colon).
} */

/* Determine policies to use before sending off to IPSafeAddItemProperty()
void AddItemPropertyAutoPolicy(object oItem, itemproperty ip, float fDur = 0.f)
{
	int nAddItemPropertyPolicy = X2_IP_ADDPROP_POLICY_REPLACE_EXISTING;
	if (isIgnoredIp(ip))
		nAddItemPropertyPolicy = X2_IP_ADDPROP_POLICY_IGNORE_EXISTING;

	IPSafeAddItemProperty(oItem, ip, fDur, nAddItemPropertyPolicy, FALSE, isIgnoredSubtype(ip));
} */

// =============================================================================
// New Enchantment-tag Handling System
// =============================================================================
/* Looks in oContainer for an item of any of the types in sTagList.
object GetEnchantmentTarget(string sTagList, object oContainer)
{
	object oTarget;

	int i = 0;
	int iTag = GetIntParam(sTagList, i);
	while (iTag != 0)
	{
		if (GetIsObjectValid(oTarget = GetTargetOfTccType(iTag, oContainer)))
			return oTarget;
		iTag = GetIntParam(sTagList, ++i);
	}
	return OBJECT_INVALID;
} */
