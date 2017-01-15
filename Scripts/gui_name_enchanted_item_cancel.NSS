// 'gui_name_enchanted_item cancel'
/*
	Cancels renaming an item.
	Callback always runs with the player's OwnedPC as OBJECT_SELF.
*/
// kevL 160913 - create file.


#include "crafting_inc_const"

void main()
{
	//SendMessageToPC(GetFirstPC(FALSE), "run ( gui_name_enchanted_item cancel ) " + GetName(OBJECT_SELF) + " " + GetTag(OBJECT_SELF));

	DeleteLocalObject(GetModule(), VAR_ENCHANTED_ITEM_OBJECT);
}
