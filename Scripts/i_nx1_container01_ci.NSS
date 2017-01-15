// 'i_nx1_container01_ci'
/*
	Tag-based OnSpellCastAt script.
	This code runs when a PC or DM casts a spell from one of the standard
	spellbooks on the MotB enchanter's satchel.
*/
// ChazM 8/2/06


#include "ginc_crafting"
#include "x2_inc_switches"


void main()
{
	object oCrafter = OBJECT_SELF;
	object oSatchel = GetSpellTargetObject();
	int iSpellId = GetSpellId();

	// store these variables for use in 'gr_DoMagicCrafting'
	SetLocalObject(oSatchel, SATCHEL_VAR_CRAFTER, oCrafter);
	SetLocalInt(oSatchel, SATCHEL_VAR_SPELLID, iSpellId);

	ExecuteScript("gr_domagiccrafting", oSatchel);

	SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);		// prevent the spellscript from executing
//	SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);	// this would allow the spell to take effect
}
