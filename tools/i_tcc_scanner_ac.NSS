// 'i_tcc_scanner_ac'
//
// Associated with the TCC scanner item.
// - script is run when the item's special ability is used
// - target an item with the ability to use it
// - echoes item property information to the chat window
//
// Created by Dashiel Nemeth, 12/12/06
// - for The Complete Craftsman
//
// kevL 2016 oct 9 - rewritten & updated.


#include "ginc_crafting"


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

// Gets the TCC material type from a specified tag.
int GetMaterial(string sTag);
// Gets a description for the specified material.
string GetMaterialDescription(int iMaterial);
// Gets a description for the specified baseitem type.
string GetBaseTypeDescription(int iBaseType);
// Gets a description for the specified tcc-item type.
string GetTccTypeDescription(int iTccType);
// Gets a description for the specified armorrule stat.
string GetArmorRuleStatDescription(int iStat);


// ___________
// ** MAIN ***
// -----------
void main()
{
	//SendMessageToPC(oPC, "Run ( i_tcc_scanner_ac ) " + GetName(OBJECT_SELF) + " ( " + GetTag(OBJECT_SELF) + " )");

	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	// early out
	if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
	{
		SendMessageToPC(oPC, "<c=firebrick>ERROR : Only items can be targeted !</c>");
		return;
	}

	string sTag;

	// general info
	sTag = GetTag(oTarget);
	SendMessageToPC(oPC, "\nTCC Scan : <c=cornflowerblue>" + GetName(oTarget) + "</c> ( " + sTag + " )");

	if (GetItemStackSize(oTarget) != 1)
		SendMessageToPC(oPC, "<c=coral>WARNING : Variables on items in stacks might not be consistent.</c>");

	SendMessageToPC(oPC, ". resref : " + GetResRef(oTarget));
	SendMessageToPC(oPC, ". plot : " + IntToString(GetPlotFlag(oTarget)));

	int iVal;

	// item type
	iVal = GetBaseItemType(oTarget);
	SendMessageToPC(oPC, ". Base Type : " + IntToString(iVal) + GetBaseTypeDescription(iVal));
	iVal = GetTccType(oTarget);
	SendMessageToPC(oPC, ". TCC Type : "  + IntToString(iVal) + GetTccTypeDescription(iVal));

	// armor rule
	iVal = GetArmorRulesType(oTarget);
	SendMessageToPC(oPC, ". Armor Rule Stat : " + IntToString(iVal) + GetArmorRuleStatDescription(iVal));

	// material
	iVal = GetItemBaseMaterialType(oTarget);
	SendMessageToPC(oPC, ". Base Material : " + IntToString(iVal) + material(iVal));
	iVal = GetLocalInt(oTarget, TCC_VAR_MATERIAL);
	SendMessageToPC(oPC, ". TCC Material Int : " + IntToString(iVal) + GetMaterialDescription(iVal));
	iVal = GetMaterial(sTag);
	SendMessageToPC(oPC, ". TCC Material String : " + IntToString(iVal) + GetMaterialDescription(iVal));

	// masterwork
	SendMessageToPC(oPC, ". TCC Masterwork Int : " + IntToString(GetLocalInt(oTarget, TCC_VAR_MASTERWORK)));
	sTag = GetStringRight(sTag, 5);
	if (GetStringLowerCase(sTag) != TCC_MASTER_TAG)
		sTag = "";
	SendMessageToPC(oPC, ". TCC Masterwork String : " + sTag);

	// property Set
	SendMessageToPC(oPC, ". TCC disallow as part of a Set : " + IntToString(GetLocalInt(oTarget, TCC_VAR_SET_NOT)));
	SendMessageToPC(oPC, ". TCC Set Label : " + GetLocalString(oTarget, TCC_VAR_SET_LABEL));
	int iLength = GetStringLength(TCC_VAR_SET_GROUP_PRE);
	string sVar;
	int i;
	int iVars = GetVariableCount(oTarget);
	for (i = 0; i != iVars; ++i)
	{
		sVar = GetVariableName(oTarget, i);
		if (GetStringLeft(sVar, iLength) == TCC_VAR_SET_GROUP_PRE)
			SendMessageToPC(oPC, ". . TCC Set Group : "
					+ GetStringRight(sVar, GetStringLength(sVar) - iLength)
					+ " ip : " + GetLocalString(oTarget, sVar));
	}
	SendMessageToPC(oPC, ". TCC Set part ready : " + IntToString(GetLocalInt(oTarget, TCC_VAR_SET_FLAG)));

	// itemproperties
	int iPropType, iDurType, iSubType, iCostTable, iCostValue, iPar1Table, iPar1Value;
	i = 0;
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
	string sRet = GetStringByStrRef(StringToInt(Get2DAString(ITEM_PROP_DEF_2DA, "Name", iPropType)));
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
	string sRet = Get2DAString(ITEM_PROP_DEF_2DA, "SubTypeResRef", iPropType);
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

// Gets the TCC material type from a specified tag.
// note: This mimics GetMaterialCode() in 'ginc_crafting' but both could
// probably use the hard function, FindSubString(). or not ...
int GetMaterial(string sTag)
{
	string sMaterial;
	int iLength = GetStringLength(sTag);
	if (iLength > 4)
	{
		iLength -= 4;
		int i;
		for (i = 0; i != iLength; ++i)
		{
			sMaterial = GetStringLowerCase(GetSubString(sTag, i, 5));

			if (sMaterial == "_ada_") return  1; // MAT_ADA
			if (sMaterial == "_cld_") return  2; // MAT_CLD
			if (sMaterial == "_drk_") return  3; // MAT_DRK
			if (sMaterial == "_dsk_") return  4; // MAT_DSK
			if (sMaterial == "_mth_") return  5; // MAT_MTH
			if (sMaterial == "_rdh_") return  6; // MAT_RDH
			if (sMaterial == "_shd_") return  7; // MAT_SHD
			if (sMaterial == "_slh_") return  8; // MAT_SLH
			if (sMaterial == "_slv_") return  9; // MAT_SLV
			if (sMaterial == "_uhh_") return 10; // MAT_UHH
			if (sMaterial == "_wyh_") return 11; // MAT_WYH
			if (sMaterial == "_zal_") return 12; // MAT_ZAL
			if (sMaterial == "_wwf_") return 13; // MAT_WWF
			if (sMaterial == "_fmp_") return 14; // MAT_FMP
			if (sMaterial == "_imp_") return 15; // MAT_IMP
		}
	}
	return 0; // MAT_NUL - nothing was found, assume no particular material
}

// Gets a description for the specified material.
string GetMaterialDescription(int iMaterial)
{
	string sRet = " <c=cornflowerblue>( ";
	switch (iMaterial)
	{
		case  0: sRet += "none";				break;
		case  1: sRet += "adamantine";			break;
		case  2: sRet += "cold iron";			break;
		case  3: sRet += "dark steel";			break;
		case  4: sRet += "duskwood";			break;
		case  5: sRet += "mithral";				break;
		case  6: sRet += "red dragon hide";		break;
		case  7: sRet += "shederran";			break;
		case  8: sRet += "salamander hide";		break;
		case  9: sRet += "alchemical silver";	break;
		case 10: sRet += "umberhulk hide";		break;
		case 11: sRet += "wyvern hide";			break;
		case 12: sRet += "zalantar";			break;
		case 13: sRet += "winterwolf pelt";		break;
		case 14: sRet += "fire imp pelt";		break;
		case 15: sRet += "ice imp pelt";		break;
		default: sRet += "<c=firebrick>ERROR : invalid TCC material type</c>";
	}
	return sRet += " )</c>";
}

// Gets a description for the specified baseitem type.
string GetBaseTypeDescription(int iBaseType)
{
	string sRet = " <c=cornflowerblue>( ";
	sRet += Get2DAString("baseitems", "label", iBaseType);
	return sRet += " )</c>";
}

// Gets a description for the specified tcc-item type.
string GetTccTypeDescription(int iTccType)
{
	string sRet = " <c=cornflowerblue>( ";
	switch (iTccType)
	{
		case TCC_TYPE_NONE:			sRet += "none";			break;
		case TCC_TYPE_HELMET:		sRet += "helmet";		break;
		case TCC_TYPE_AMULET:		sRet += "amulet";		break;
		case TCC_TYPE_BELT:			sRet += "belt";			break;
		case TCC_TYPE_BOOTS:		sRet += "boots";		break;
		case TCC_TYPE_GLOVES:		sRet += "gloves";		break;
		case TCC_TYPE_RING:			sRet += "ring";			break;
		case TCC_TYPE_BRACER:		sRet += "bracer";		break;
		case TCC_TYPE_CLOAK:		sRet += "cloak";		break;
		case TCC_TYPE_INSTRUMENT:	sRet += "instrument";	break;
		case TCC_TYPE_CONTAINER:	sRet += "container";	break;
		case TCC_TYPE_ARMOR:		sRet += "armor";		break;
		case TCC_TYPE_SHIELD:		sRet += "shield";		break;
		case TCC_TYPE_BOW:			sRet += "bow";			break;
		case TCC_TYPE_XBOW:			sRet += "xbow";			break;
		case TCC_TYPE_SLING:		sRet += "sling";		break;
		case TCC_TYPE_AMMO:			sRet += "ammo";			break;
		case TCC_TYPE_MELEE:		sRet += "melee";		break;
		case TCC_TYPE_OTHER:		sRet += "other";		break;
		default:					sRet += "<c=firebrick>ERROR : invalid TCC type</c>";
	}
	return sRet += " )</c>";
}

// Gets a description for the specified armorrule stat.
string GetArmorRuleStatDescription(int iStat)
{
	string sRet = " <c=cornflowerblue>( ";
	sRet += Get2DAString("armorrulestats", "Label", iStat);
	return sRet += " )</c>";
}
