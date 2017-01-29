// 'tcc_indexer'
//
// kevL 2017 jan 19
//
// This script tabulates and prints the contents for a new Crafting_Index.2da
// based on the Crafting.2da that currently has priority IG.
//
// Load NWN2 and run from the console:
// `
// debugmode 1
// rs tcc_indexer
// debugmode 0
// `
//
// The output should appear in the NWN2 logfile[*] in your user directory.
// Copy the lines between the hyphenated delimiters and paste it into a new
// "crafting_index.2da" plain textfile. Save. It might then be a good idea to
// open it in a decent NWN2 2da-editor[**] that will check for mistakes, and
// re-save the file using that editor.
//
// [*] Logging has to be on. See:
// http://nwn2.wikia.com/wiki/Logs
//
// [**] eg. NWN_2daEditor
// https://neverwintervault.org/project/nwn2/other/tool/nwn2daeditor
//
// PS. it's always a good idea to back-up your current Crafting_Index.2da first!


void main()
{
	int iRows = GetNum2DARows("crafting");
	if (iRows > 0)
	{
		PrintString("");
		PrintString("----------------");
		PrintString("2DA V2.0");
		PrintString("");
		PrintString(" CATEGORY START_ROW");

		string
			sTrigger,
			sTriggerTest = "",
			sPrint;

		int
			iRowCraft = 0,
			iRowInd = 0;
		do
		{
			sTrigger = Get2DAString("crafting", "CATEGORY", iRowCraft);
			if (sTrigger != sTriggerTest)
			{
				sTriggerTest = sTrigger;

				if (sTrigger != "")
				{
					sPrint = IntToString(iRowInd++);
					sPrint += " ";
					sPrint += sTrigger;
					sPrint += " ";
					sPrint += IntToString(iRowCraft);

					PrintString(sPrint);
				}
			}
		}
		while (++iRowCraft != iRows);

		PrintString("----------------");
		PrintString("");
	}
	else
	{
		string sError = "ERROR : Crafting.2da was not found or has no entries.";
		PrintString("[tcc_indexer] " + sError);

		SendMessageToPC(GetFirstPC(FALSE), "<c=red>" + sError + "</c>");
	}
}
