// 'gui_name_enchanted_item'
/*
	Renames an item w/ the input-string.
	Callback always runs with the player's OwnedPC as OBJECT_SELF.
*/
// ChazM 5/24/06
// ChazM 5/31/06 Update to reflect where Item object is now stored
// ChazM 9/29/06 Just comments
// kevL 160913 - delete a bunch of comments.
// kevL 160914 - fix.


#include "crafting_inc_const"

void main(string sLabel)
{
	//SendMessageToPC(GetFirstPC(FALSE), "run ( gui_name_enchanted_item ) " + GetName(OBJECT_SELF) + " " + GetTag(OBJECT_SELF));
	//SendMessageToPC(GetFirstPC(FALSE), ". sLabel= _" + sLabel + "_");

	// local_object is stored on the Owned PC of the controlled-character that opened the GUI panel.
	// NOTE: GUI sends 'sLabel' with a space tacked on the end, even if blank.
	// NOTE: GUI considers Escape-key as Okay instead of Cancel.
	// NOTE: 'backoutkey=false' doesn't work in GUI.

	string sSpace = " ";
	while (sLabel != "" && GetStringLeft(sLabel, 1) == sSpace)
		sLabel = GetStringRight(sLabel, GetStringLength(sLabel) - 1);
	//SendMessageToPC(GetFirstPC(FALSE), ". trimLeft label= _" + sLabel + "_");

	while (sLabel != "" && GetStringRight(sLabel, 1) == sSpace)
		sLabel = GetStringLeft(sLabel, GetStringLength(sLabel) - 1);
	//SendMessageToPC(GetFirstPC(FALSE), ". trimRight label= _" + sLabel + "_");

	if (sLabel != "")
	{
		//SendMessageToPC(GetFirstPC(FALSE), ". label= _" + sLabel + "_");
		object oItem = GetLocalObject(GetModule(), VAR_ENCHANTED_ITEM_OBJECT);
//		if (GetIsObjectValid(oItem)) // better be darn valid.
		SetFirstName(oItem, sLabel);
	}

	DeleteLocalObject(GetModule(), VAR_ENCHANTED_ITEM_OBJECT);
}