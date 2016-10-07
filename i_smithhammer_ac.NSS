// 'i_smithhammer_ac'
/*
	When the smith hammer is used on the workbench, an item may be created!
	Also, rename an item.
*/
// ChazM 1/31/06
// ChazM 3/28/06 Crafting call interface change
// ChazM 4/7/06 fix - assigned DoMundaneCrafting() to workbench
// ChazM 8/8/06 added ERROR_UNRECOGNIZED_HAMMER_USAGE,
//				added additional tags and local var setting for identifying blacksmith bench.
// ChazM 8/16/06 moved stuff to ginc_crafting
// ChazM 6/11/07 If campaign switch enabled, smith hammer can be used to rename any item.
// Moved and revised item renaming feature to work directly from hammer
// kevL 2014 may 22: remove unused code.


#include "ginc_crafting"

void main()
{
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	if (IsSmithWorkbench(oTarget))
		AssignCommand(oTarget, DoMundaneCrafting(oPC));
	else if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		if (!GetPlotFlag(oTarget))
		{
			if (GetGlobalInt(CAMPAIGN_SWITCH_SMITH_HAMMER_RENAME_ITEM)
				|| StringToInt(Get2DAString(TCC_CONFIG_2da, TCC_COL_VALUE, TCC_Toggle_AllowEasyItemRenaming)))
			{
				SetEnchantedLabel(oPC, oTarget);
			}
			else
				NotifyPlayer(oPC, -1, "Renaming items is not allowed.");
		}
		else
			NotifyPlayer(oPC, -1, "Plot items cannot be renamed.");
	}
	else
		NotifyPlayer(oPC, ERROR_UNRECOGNIZED_HAMMER_USAGE);
}
