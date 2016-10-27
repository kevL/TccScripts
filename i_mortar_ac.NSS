// 'i_mortar_ac'
/*
	when the mortar and pestle is used on an item, new items may be distilled!
*/
// ChazM 1/31/06
// ChazM 3/23/06 added fairy dust and shadow reaver bones special cases
// ChazM 3/28/06 Crafting call interface change
// ChazM 6/7/06 fix - assigned DoAlchemyCrafting() to workbench
// ChazM 8/8/06 added ERROR_UNRECOGNIZED_MORTAR_USAGE, added additional tags and local var setting for alchemy bench.
// ChazM 8/16/06 moved stuff to ginc_crafting
// ChazM 9/10/06 fix - was comparing tag of mortar instead of target

#include "ginc_crafting"

// ________________
// ** CONSTANTS ***
// ----------------
const string FIRE	= "cft_ess_fire";
const string WATER	= "cft_ess_water";
const string AIR	= "cft_ess_air";
const string EARTH	= "cft_ess_earth";
const string POWER	= "cft_ess_power";
const string POWER3	= "cft_ess_power3";

const string FAIRY_DUST				= "NW_IT_MSMLMISC19";
const string SHADOW_REAVER_BONES	= "N2_CRFT_DIST028";


// __________________
// ** DEFINITIONS ***
// ------------------

// Fairy Dust should always yield one Essence of random type
// (Power, Air, Earth, Fire, or Water) and power level (1-4).
void DistillFairyDust(object oDistilledItem, object oPC)
{
	string sEssence;
	switch (Random(5))
	{
		case 0: sEssence = FIRE;	break;
		case 1: sEssence = WATER;	break;
		case 2: sEssence = AIR;		break;
		case 3: sEssence = EARTH;	break;
		case 4: sEssence = POWER;
	}

	sEssence += IntToString(d4());
	string sOutputList = MakeList(sEssence);
	ExecuteDistillation(8, oDistilledItem, oPC, sOutputList);
}


// Shadow Reaver Bones should always yield one Glowing (Level 3) Power Essence
// AND one random elemental (Air, Earth, Fire, or Water) Essence of either
// level 3 or 4 (random).
void DistillShadowReaverBones(object oDistilledItem, object oPC)
{
	string sEssence;
	switch (Random(4))
	{
		case 0: sEssence = FIRE;	break;
		case 1: sEssence = WATER;	break;
		case 2: sEssence = AIR;		break;
		case 3: sEssence = EARTH;
	}

	sEssence += IntToString(d2() + 2);
	string sOutputList = MakeList(POWER3, sEssence);
	ExecuteDistillation(8, oDistilledItem, oPC, sOutputList);
}


// ___________
// ** MAIN ***
// -----------
void main()
{
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	if (IsAlchemyWorkbench(oTarget))
		AssignCommand(oTarget, DoAlchemyCrafting(oPC));
	else if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		string sTargetTag = GetTag(oTarget);
		if (sTargetTag == FAIRY_DUST)
			DistillFairyDust(oTarget, oPC);
		else if (sTargetTag == SHADOW_REAVER_BONES)
			DistillShadowReaverBones(oTarget, oPC);
		else
			DoDistillation(oTarget, oPC);
	}
	else
		NotifyPlayer(oPC, ERROR_UNRECOGNIZED_MORTAR_USAGE);
}