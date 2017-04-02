// 'gui_tcc_constructset'
//
// Copies and re-tags Set Property members as Set items.
// kL 16.09.25 - moved ConvertToSetPart() here from 'ginc_crafting'.


#include "ginc_crafting"

// ___________________
// ** DECLARATIONS ***
// -------------------

// Re-tags oItem for sSetLabel-group.
void ConvertToSetPart(object oItem,
					  string sSetLabel,
					  object oContainer,
					  object oCrafter);


// ___________
// ** MAIN ***
// -----------
void main(string sSetLabel)
{
	string sSpace = " ";
	while (sSetLabel != "" && GetStringLeft(sSetLabel, 1) == sSpace)
		sSetLabel = GetStringRight(sSetLabel, GetStringLength(sSetLabel) - 1);
	//SendMessageToPC(GetFirstPC(FALSE), ". trimLeft label= _" + sSetLabel + "_");

	while (sSetLabel != "" && GetStringRight(sSetLabel, 1) == sSpace)
		sSetLabel = GetStringLeft(sSetLabel, GetStringLength(sSetLabel) - 1);
	//SendMessageToPC(GetFirstPC(FALSE), ". trimRight label= _" + sSetLabel + "_");

	// TODO: handle a blank string. (ie, what are the consequences of a blank string)

	object oModule = GetModule();
	object oCrafter = GetLocalObject(oModule, TCC_VAR_SET_CRAFTER);
	object oContainer = GetLocalObject(oModule, TCC_VAR_SET_CONTAINER);

	object oItem = GetFirstItemInInventory(oContainer);
	while (GetIsObjectValid(oItem))
	{
//		if (GetTccType(oItem) == TCC_TYPE_OTHER)
//		if (!GetIsEquippable(oItem))
//			DestroyObject(oItem); // should be done
//		else
		if (GetLocalString(oItem, TCC_VAR_SET_LABEL) != sSetLabel)
		{
			ConvertToSetPart(oItem, sSetLabel, oContainer, oCrafter);
		}
		oItem = GetNextItemInInventory(oContainer);
	}

	DeleteLocalObject(oModule, TCC_VAR_SET_CRAFTER);
	DeleteLocalObject(oModule, TCC_VAR_SET_CONTAINER);
}


// __________________
// ** DEFINITIONS ***
// ------------------

// Re-tags oItem for sSetLabel-group.
void ConvertToSetPart(object oItem, string sSetLabel, object oContainer, object oCrafter)
{
	TellCraft("\nConvertToSetPart : " + GetName(oItem) + " ( " + GetTag(oItem) + " )");
	TellCraft(". sSetLabel= " + sSetLabel);

	if (GetPlotFlag(oItem) || GetLocalInt(oItem, TCC_VAR_SET_NOT)) // NOTE: local_int can be set on blueprints to prevent them becoming part of a Set.
	{
		NotifyPlayer(oCrafter, -1, GetName(oItem) + " can't be made part of a Property Set.");
		return;
	}

	// if Set re-labelling is on and oItem is already labelled then reject -> wtf.
	if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 1)) // TCC_Toggle_AllowSetNameChange
		&& GetLocalString(oItem, TCC_VAR_SET_LABEL) != "")
	{
		NotifyPlayer(oCrafter, -1, GetName(oItem) + " is already part of a Property Set.");
		return;
	}

	// btw ... should those have been done already in DoMagicCrafting(). -> yes, check it/ TODO.

	if (GetStringLowerCase(GetStringRight(GetTag(oItem), 5)) == TCC_MASTER_TAG)
		SetLocalInt(oItem, TCC_VAR_MASTERWORK, TRUE);

	int iMaterial = GetMaterialCode(oItem);
	if (iMaterial != 0) // MAT_NUL
		SetLocalInt(oItem, TCC_VAR_MATERIAL, iMaterial);

	SetLocalString(oItem, TCC_VAR_SET_LABEL, sSetLabel);

	SetFirstName(oItem, sSetLabel + " " + GetName(oItem));

	SetTag(oItem, TCC_SET_TAG);
}
