// 'gui_tcc_constructset'
//
// Copies and re-tags Set Property members as Set items.
// kL 16.09.25 - moved ConvertToSetPart() here from 'ginc_crafting'.


#include "ginc_crafting"

// ___________________
// ** DECLARATIONS ***
// -------------------

// Creates a re-tagged annotated copy of oOriginal for sSetLabel.
void ConvertToSetPart(object oOriginal,
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

	// TODO: handle a blank string.

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
			ConvertToSetPart(oItem, sSetLabel, oContainer, oCrafter);

		// is it wise to be inserting objects into a container that is looping
		// over those objects ... CopyObject() below_ probably waits until the
		// script is finished. probably ... but actually it doesn't.

		oItem = GetNextItemInInventory(oContainer);
	}

	DeleteLocalObject(oModule, TCC_VAR_SET_CRAFTER);
	DeleteLocalObject(oModule, TCC_VAR_SET_CONTAINER);
}


// __________________
// ** DEFINITIONS ***
// ------------------

// Creates a re-tagged annotated copy of oOriginal for sSetLabel.
void ConvertToSetPart(object oOriginal, string sSetLabel, object oContainer, object oCrafter)
{
	if (GetPlotFlag(oOriginal) || GetLocalInt(oOriginal, TCC_VAR_SET_NOT)) // NOTE: local_int can be set on blueprints to prevent them becoming part of a Set.
	{
		NotifyPlayer(oCrafter, -1, GetName(oOriginal) + " can't be made part of an item Set.");
		return;
	}

	// if Set re-tagging is on and oOriginal is already tagged then reject
	if (StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, 1)) // TCC_Toggle_AllowSetNameChange
		&& GetLocalString(oOriginal, TCC_VAR_SET_LABEL) != "")
	{
		NotifyPlayer(oCrafter, -1, GetName(oOriginal) + " is already part of an item Set.");
		return;
	}

	// btw ... should all that have been done already in DoMagicCrafting().

	// Copy the original item with the Set item-tag -------- WHY!
	// Because in the dark ages there was no function:
	// void SetTag(object oObject, string sNewTag);
	object oCopy = CopyObject(oOriginal, GetLocation(oOriginal), oContainer, TCC_SET_TAG);
//	object CopyObject(object oSource, location locLocation, object oOwner = OBJECT_INVALID, string sNewTag = "");

	itemproperty ipProp = GetFirstItemProperty(oOriginal);
	while (GetIsItemPropertyValid(ipProp))
	{
		IPSafeAddItemProperty(oCopy, ipProp);
		ipProp = GetNextItemProperty(oOriginal);
	}

	if (GetStringRight(GetTag(oOriginal), 5) == TCC_MASTER_TAG)
		SetLocalInt(oCopy, TCC_VAR_MASTERWORK, TRUE);

	int iMaterial = GetMaterialCode(oOriginal);
	if (iMaterial != 0) // MAT_NUL
		SetLocalInt(oCopy, TCC_VAR_MATERIAL, iMaterial);

	SetLocalString(oCopy, TCC_VAR_SET_LABEL, sSetLabel);
	SetFirstName(oCopy, sSetLabel + " " + GetName(oOriginal));
	DestroyObject(oOriginal);
}