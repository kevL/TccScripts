// 'gui_trigger_spell_set'
//
// kevL 2016 sept 13
// Callback for the GUI-inputbox that sets the trigger-spell to be used for
// crafting with ImbueItem.


#include "ginc_crafting"

void main(string sSpell)
{
	SendMessageToPC(GetFirstPC(FALSE), "Run ( gui_trigger_spell_set ) " + GetName(OBJECT_SELF) + " " + GetTag(OBJECT_SELF));
	//SendMessageToPC(GetFirstPC(FALSE), ". sSpell= _" + sSpell + "_");

	object oModule = GetModule();

	// NOTE: GUI sends 'sSpell' with a space tacked on the end, even if blank.
	// NOTE: GUI considers Escape-key as Okay instead of Cancel.
	// NOTE: 'backoutkey=false' doesn't work in GUI.

	string sSpace = " ";
	while (sSpell != "" && GetStringLeft(sSpell, 1) == sSpace)
		sSpell = GetStringRight(sSpell, GetStringLength(sSpell) - 1);
	//SendMessageToPC(GetFirstPC(FALSE), ". trimLeft spell= _" + sSpell + "_");

	while (sSpell != "" && GetStringRight(sSpell, 1) == sSpace)
		sSpell = GetStringLeft(sSpell, GetStringLength(sSpell) - 1);
	//SendMessageToPC(GetFirstPC(FALSE), ". trimRight spell= _" + sSpell + "_");

	if (sSpell != "" && isSpellId(sSpell))
	{
		SendMessageToPC(GetFirstPC(FALSE), ". spell= _" + sSpell + "_");

		object oCrafter = GetControlledCharacter(OBJECT_SELF);

		if (sSpell == SPELL_IMBUE_ITEM_ST) // Imbue_Item is NOT allowed here.
		{
			NotifyPlayer(oCrafter, -1,
					"<c=plum>_ Crafting :</c> <c=firebrick>Spell ID :</c> " + SPELL_IMBUE_ITEM_ST
					+ " <c=firebrick>( Imbue Item ) is NOT allowed. Try again.</c>");
		}
		else
		{
			SetLocalObject(oModule, II_VAR_CRAFTER, oCrafter);

			int iSpellId = StringToInt(sSpell);
			SetLocalInt(oModule, II_VAR_SPELLID, iSpellId);

			string sRef = Get2DAString("spells", "Name", iSpellId);
			sRef = GetStringByStrRef(StringToInt(sRef));
			NotifyPlayer(oCrafter, -1,
						"<c=plum>_ Crafting :</c> <c=seagreen>Spell ID :</c> <c=slateblue>"
						+ sSpell + "</c> <c=seagreen>( " + sRef + " )</c>\n");

			object oContainer = GetLocalObject(oModule, II_VAR_CONTAINER);
			ExecuteScript("ii_trigger_spell", oContainer);

			// clean up.
			DeleteLocalInt(oModule, II_VAR_SPELLID);
			DeleteLocalObject(oModule, II_VAR_CRAFTER);
		}
	}

	// clean up.
	DeleteLocalObject(oModule, II_VAR_CONTAINER);
}
