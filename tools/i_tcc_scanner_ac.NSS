// 'i_tcc_scanner_ac'
//
// Associated with the TCC scanner gem item.
// - script is run when the item's special ability is used
// - target an item with the ability to use it
// - echoes item property information to the chat window
//
// Created by Dashiel Nemeth, 12/12/06
// - for The Complete Craftsman
//
// kevL 2016 oct 9 - rewritten & updated.


#include "ginc_crafting"

const string COL_ITEM_PROP_DEF_NAME		= "Name";
const string COL_ITEM_PROP_DEF_SUBTYPE	= "SubTypeResRef";


// ___________________
// ** DECLARATIONS ***
// -------------------

// Gets property-type as a string.
string prop(int iPropType);
// Gets duration as a string.
string dur(int iDurType);
// Gets subtype as a string.
string subtype(int iPropType, int iSubType);
// Gets cost-table as a string.
string costtable(int iCostTable);
// Gets cost-value as a string.
string costvalue(int iCostValue, int iCostTable);
// Gets parameter-1 as a string.
string par1(int iPar1Table, int iPropType);
// Gets parameter-1 value as a string.
string par1value(int iPar1Value, int iPar1Table, int iPropType);

// Gets the base-material as a string.
string material(int iBaseMaterial);


// ___________
// ** MAIN ***
// -----------
void main()
{
	//SendMessageToPC(oPC, "Run ( i_tcc_scanner_ac ) " + GetName(OBJECT_SELF) + " ( " + GetTag(OBJECT_SELF) + " )");

	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
	{
		SendMessageToPC(oPC, "error : Only items can be targeted !");
		return;
	}

	if (GetItemStackSize(oTarget) != 1)
		SendMessageToPC(oPC, "warning : Variables on items in stacks might not be consistent.");


	SendMessageToPC(oPC, "\nTCC Scan : <c=cornflowerblue>" + GetName(oTarget) + "</c> ( " + GetTag(oTarget) + " )");

	SendMessageToPC(oPC, ". plot : " + IntToString(GetPlotFlag(oTarget)));

	SendMessageToPC(oPC, ". Base Type : " + IntToString(GetBaseItemType(oTarget)));
	SendMessageToPC(oPC, ". TCC Type : "  + IntToString(GetTccType(oTarget)));

	int iBaseMaterial = GetItemBaseMaterialType(oTarget);
	SendMessageToPC(oPC, ". Base Material : " + IntToString(iBaseMaterial) + material(iBaseMaterial));
	int iMaterial = GetLocalInt(oTarget, TCC_VAR_MATERIAL); //GetMaterialType(oTarget) - not comprehensive, See tag.
	SendMessageToPC(oPC, ". TCC Material : " + IntToString(iMaterial));

	int bMasterwork = GetLocalInt(oTarget, TCC_VAR_MASTERWORK); //|| GetStringRight(GetTag(oTarget), 5) == TCC_MASTERWORK_SUF - not comprehensive, See tag.
	SendMessageToPC(oPC, ". TCC Masterwork : " + IntToString(bMasterwork));

//	int iGroup = GetLocalInt(oTarget, TCC_VAR_SET_GROUP);
//	if (iGroup)
//	{
//		SendMessageToPC(oPC, ". TCC Property Set");
//		SendMessageToPC(oPC, ". . group : "		+ IntToString(iGroup));
//		SendMessageToPC(oPC, ". . parts : "		+ IntToString(GetLocalInt(oTarget, TCC_VAR_SET_PARTS)));
//		SendMessageToPC(oPC, ". . prepared : "	+ IntToString(GetLocalInt(oTarget, TCC_VAR_SET_PREP_ITEM)));
//		SendMessageToPC(oPC, ". . latentip : "	+ GetLocalString(oTarget, TCC_VAR_SET_IP));
//		// NOTE: Set Label does not get stored.
//	}
//	else
//		SendMessageToPC(oPC, ". TCC Property Set : no Set");


	int iPropType, iDurType, iSubType, iCostTable, iCostValue, iPar1Table, iPar1Value;

	int i = 0;
	itemproperty ipScan = GetFirstItemProperty(oTarget);
	while (GetIsItemPropertyValid(ipScan))
	{
		SendMessageToPC(oPC, ". ip " + IntToString(++i));

		iPropType	= GetItemPropertyType(ipScan);
		iDurType	= GetItemPropertyDurationType(ipScan);
		iSubType	= GetItemPropertySubType(ipScan);
		iCostTable	= GetItemPropertyCostTable(ipScan);
		iCostValue	= GetItemPropertyCostTableValue(ipScan);
		iPar1Table	= GetItemPropertyParam1(ipScan);
		iPar1Value	= GetItemPropertyParam1Value(ipScan);

		SendMessageToPC(oPC, ". . PropType = "	+ IntToString(iPropType)	+ prop(iPropType));
		SendMessageToPC(oPC, ". . DurType = "	+ IntToString(iDurType)		+ dur(iDurType));
		SendMessageToPC(oPC, ". . SubType = "	+ IntToString(iSubType)		+ subtype(iPropType, iSubType));
		SendMessageToPC(oPC, ". . CostTable = "	+ IntToString(iCostTable)	+ costtable(iCostTable));
		SendMessageToPC(oPC, ". . CostValue = "	+ IntToString(iCostValue)	+ costvalue(iCostValue, iCostTable));
		SendMessageToPC(oPC, ". . Par1 = "		+ IntToString(iPar1Table)	+ par1(iPar1Table, iPropType));
		SendMessageToPC(oPC, ". . Par1Value = "	+ IntToString(iPar1Value)	+ par1value(iPar1Value, iPar1Table, iPropType));

		ipScan = GetNextItemProperty(oTarget);
	}
	if (!i) SendMessageToPC(oPC, ". no IP");
}


// __________________
// ** DEFINITIONS ***
// ------------------

// Gets property-type as a string.
string prop(int iPropType)
{
	string sRet = GetStringByStrRef(StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_NAME, iPropType)));
	return " <c=cornflowerblue>( " + sRet + " )</c>";
}

// Gets duration as a string.
string dur(int iDurType)
{
	string sRet = " <c=cornflowerblue>( ";
	switch (iDurType)
	{
		case DURATION_TYPE_TEMPORARY: sRet += "TEMPORARY"; break; // 1
		case DURATION_TYPE_PERMANENT: sRet += "PERMANENT"; break; // 2

		default: sRet += "error";
	}
	return sRet + " )</c>";
}

// Gets subtype as a string.
string subtype(int iPropType, int iSubType)
{
	string sRet = Get2DAString(ITEM_PROP_DEF_2DA, COL_ITEM_PROP_DEF_SUBTYPE, iPropType);
	if (sRet != "")
	{
		string sRet1 = GetStringByStrRef(StringToInt(Get2DAString(sRet, "Name", iSubType)));
		return " <c=cornflowerblue>( " + sRet + " / " + sRet1 + " )</c>";
	}
	return " <c=cornflowerblue>( none )</c>";
}

// Gets cost-table as a string.
string costtable(int iCostTable)
{
	string sRet = Get2DAString("iprp_costtable", "Name", iCostTable);
	if (sRet == "") sRet = "none";
	return " <c=cornflowerblue>( " + sRet + " )</c>";
}

// Gets cost-value as a string.
string costvalue(int iCostValue, int iCostTable)
{
	string sRet = Get2DAString("iprp_costtable", "Name", iCostTable);
	if (sRet != "")
		sRet = GetStringByStrRef(StringToInt(Get2DAString(sRet, "Name", iCostValue)));
	else
		sRet = "none";
	return " <c=cornflowerblue>( " + sRet + " )</c>";
}

// Gets parameter-1 as a string.
string par1(int iPar1Table, int iPropType)
{
	if (Get2DAString(ITEM_PROP_DEF_2DA, "Param1ResRef", iPropType) != "")
	{
		string sRet = GetStringByStrRef(StringToInt(Get2DAString("iprp_paramtable", "Name", iPar1Table)));
		return " ( " + sRet + " )</c>";
	}
	return " <c=cornflowerblue>( none )</c>";
}

// Gets parameter-1 value as a string.
string par1value(int iPar1Value, int iPar1Table, int iPropType)
{
	if (Get2DAString(ITEM_PROP_DEF_2DA, "Param1ResRef", iPropType) != "")
	{
		string sRet = Get2DAString("iprp_paramtable", "TableResRef", iPar1Table);
		sRet = GetStringByStrRef(StringToInt(Get2DAString(sRet, "Name", iPar1Value)));
		return " <c=cornflowerblue>( " + sRet + " )</c>";
	}
	return " <c=cornflowerblue>( none )</c>";
}

// Gets the base-material as a string.
string material(int iBaseMaterial)
{
	string sRet = GetStringByStrRef(StringToInt(Get2DAString("iprp_materials", "NAME", iBaseMaterial)));
	return " <c=cornflowerblue>( " + sRet + " )</c>";
}
