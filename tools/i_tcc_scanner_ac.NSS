// 'i_tcc_scanner_ac'
//
// Associated with the TCC scanner gem item
// Script is run when the item's special ability is used
// Target an item with the ability to use it
// Echoes item property information to the chat window
//
// Created by Dashiel Nemeth, 12/12/06
// for The Complete Craftsman Hak Pak


#include "ginc_crafting"

void main()
{
	// Get essential targeting variables
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		int iPropType,
			iPropSubType,
			iPropFirstParam,
			iPropParamValue,
			iPropCostTable,
			iPropCostTableValue;

		SendMessageToPC(oPC, "Scanning <b>" + GetName(oTarget) + "</b> ( " + GetTag(oTarget) + " )");
		SendMessageToPC(oPC, "TCC Type : <b>" + IntToString(GetTccType(oTarget)) + "</b>");

		string sSetLabel = GetLocalString(oTarget, TCC_VAR_SET_LABEL);
		if (sSetLabel == "")
			sSetLabel = "None";

		string sProperty1 = GetLocalString(oTarget, "tcc_setprop_2");
		if (sProperty1 == "")
			sProperty1 = "None";

		string sProperty2 = GetLocalString(oTarget, "tcc_setprop_3");
		if (sProperty2 == "")
			sProperty2 = "None";

		string sProperty3 = GetLocalString(oTarget, "tcc_setprop_4");
		if (sProperty3 == "")
			sProperty3 = "None";

		string sProperty4 = GetLocalString(oTarget, "tcc_setprop_5");
		if (sProperty4 == "")
			sProperty4 = "None";

		SendMessageToPC(oPC, "Set : <b>" + sSetLabel  + "</b> ( SP2 : <b>"
										 + sProperty1 + "</b> SP3 : <b>"
										 + sProperty2 + "</b> SP4 : <b>"
										 + sProperty3 + "</b> SP5 : <b>"
										 + sProperty4 + "</b> )");

		int iLocalMat = GetLocalInt(oTarget, TCC_VAR_MATERIAL);

		string sLocalMasterwork = IntToString(GetLocalInt(oTarget, TCC_VAR_MASTERWORK));
		if (sLocalMasterwork == "0")
			sLocalMasterwork = "False";
		else
			sLocalMasterwork = "True";

		string sLocalSetTag = IntToString(GetLocalInt(oTarget, TCC_VAR_SET_FLAG));
		if (sLocalSetTag == "0")
			sLocalSetTag = "None";

		SendMessageToPC(oPC, "Local Material : <b>" + IntToString(iLocalMat)
						+ "</b> Local Masterwork : <b>" + sLocalMasterwork
						+ "</b> Local Set Prepared : <b>" + sLocalSetTag + "</b>");

		int iPropCounter = 0;
		itemproperty ipScan = GetFirstItemProperty(oTarget);
		while (GetIsItemPropertyValid(ipScan))
		{
			++iPropCounter;

			iPropType			= GetItemPropertyType(ipScan);
			iPropSubType		= GetItemPropertySubType(ipScan);
			iPropFirstParam		= GetItemPropertyParam1(ipScan);
			iPropParamValue		= GetItemPropertyParam1Value(ipScan);
			iPropCostTable		= GetItemPropertyCostTable(ipScan);
			iPropCostTableValue	= GetItemPropertyCostTableValue(ipScan);

			SendMessageToPC(oPC, "<b>Property #" + IntToString(iPropCounter)
							+ "</b> ( <b>Type :</b> " + IntToString(iPropType)
							+ ", <b>Subtype :</b> " + IntToString(iPropSubType)
							+ ", <b>Cost Value :</b> " + IntToString(iPropCostTableValue) + " )");

			ipScan = GetNextItemProperty(oTarget);
		}

		if (!iPropCounter)
			SendMessageToPC(oPC, "No properties found on the item.");
	}
	else
		SendMessageToPC(oPC, "You must target an item !");
}
