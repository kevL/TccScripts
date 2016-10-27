// 'gr_domagiccrafting'
/*
	Calls magic crafting on item
*/
// MDiekmann_3/14/07


#include "ginc_crafting"

void main()
{
	//TellCraft("Run ( gr_domagiccrafting ) " + GetName(OBJECT_SELF));
	object oCrafter = GetLocalObject(OBJECT_SELF, SATCHEL_VAR_CRAFTER);
	int iSpellId = GetLocalInt(OBJECT_SELF, SATCHEL_VAR_SPELLID);
	//TellCraft(". iSpellId= " + IntToString(iSpellId) + " crafter= " + GetName(oCrafter));

	DoMagicCrafting(iSpellId, oCrafter);
}