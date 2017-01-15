// 'gp_forgemagic_ca'
//
// forge magic weapons on spell cast
// ChazM 12/15/05
// ChazM 3/28/06 Crafting call interface change


#include "ginc_crafting"

void main()
{
	//TellCraft("Run ( gp_forgemagic_ca ) " + GetName(OBJECT_SELF));
	object oCrafter = GetLastSpellCaster();
	int iSpellId = GetLastSpell();
	//TellCraft(". iSpellId= " + IntToString(iSpellId) + " crafter= " + GetName(oCrafter));

	DoMagicCrafting(iSpellId, oCrafter);
}
