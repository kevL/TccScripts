// 'i_tcc_setitem_eq'
//
// Script runs whenever a TCC Set item is equipped.
// - processes all equipped items setting properties based on TCC variables
// - properties set are also based on number of set items equipped


#include "ginc_crafting"

void main()
{
	object oPC = GetPCItemLastEquippedBy();
	object oItem = GetPCItemLastEquipped();

	string sSetLabel = GetLocalString(oItem, TCC_VAR_SET_LABEL);
	int iParts = GetQtyLatentPartsEquipped(sSetLabel, oPC);

	ActivateLatentGroup(sSetLabel, iParts, oPC);
}
