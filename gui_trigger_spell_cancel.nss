// 'gui_trigger_spell_cancel'
//
// kevL 2016 sept 13
// Callback for the GUI-inputbox that cancels the trigger-spell to be used for
// crafting with ImbueItem.

#include "crafting_inc_const"

void main()
{
	SendMessageToPC(GetFirstPC(FALSE), "Run ( gui_trigger_spell_cancel ) " + GetName(OBJECT_SELF) + " " + GetTag(OBJECT_SELF));

	// clean up.
	DeleteLocalObject(GetModule(), II_VAR_CONTAINER);
}
