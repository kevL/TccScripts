// 'i_tcc_setitem_ue'
//
// Script runs whenever a TCC Set item is unequipped.
// - processes all equipped items setting properties based on TCC variables
// - properties set are also based on number of set items equipped


#include "ginc_crafting"

void main()
{
	object oPC = GetPCItemLastUnequippedBy();
	object oItem = GetPCItemLastUnequipped();

	string sSetLabel = GetLocalString(oItem, TCC_VAR_SET_LABEL);
	int iPartsEquipped = GetQtyLatentPartsEquipped(sSetLabel, oPC) - 1; // -1 'cause the item is still equipped

	ToggleSetGroup(sSetLabel, iPartsEquipped, oPC);
}
