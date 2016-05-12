/*
 * excel处理的脚本，由原来的xls.vbs改造而来
 * xhgao 2012/08/13
 */
function spreadsheetPrintout(data){
	var fileName = createTemporaryFile(data);
	
	lApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.open(fileName);
	
	xlBook.Sheets(1).PrintOut();
	xlBook.Close();
}

function spreadsheetprintPreview(data){
	var fileName = createTemporaryFile(data);
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.open(fileName);
	
	xlApp.Application.Visible = true;
	xlApp.windows.visible = true;
	xlBook.Sheets.PrintPreview();
	xlBook.Close();
}

function spreadsheetTransfer(data){
	var fileName = createTemporaryFile(data);
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.open(fileName);
	
	xlApp.Application.Visible = true;
	xlApp.windows(1).visible = true;
}

function printPreviewSpreadsheet(data){
	var fileName = createTemporaryFile(data);
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.open(fileName);
	
	xlApp.Application.Visible = true;
	xlApp.windows(1).visible = true;
	xlBook.Sheets(1).PrintPreview();
	xlBook.Close();
}

function createTemporaryFile(data){
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var TemporaryFolder = 2;
	var tfolder = fso.GetSpecialFolder(TemporaryFolder);
	var fileName = tfolder+"\\"+fso.GetTempName()+".xls";
	var tfile = fso.CreateTextFile(fileName);
	tfile.write("<html><head><meta http-equiv='Content-Type' content='text/html; charset=gb2312' /></head><body>"+data+"</body></html>");
	tfile.close();
	return fileName;
}

function writeToTheEndOfFile(fileName,data) {
	var objFS = new ActiveXObject("Scripting.FileSystemObject");
	f = objFS.OpenTextFile(fileName, 8, true);
	f.write(data);
	f.close();
}

function myFormatNumber(dMoney,iType){
	return FormatNumber(dMoney,iType,-1,0,0);
}

/*
function myUG(str){
	//return execScript("hex(asc(str))", "vbscript");
	//myUG=hex(asc(str));
	var myUG2 = parseInt(str.charCodeAt(0),10).toString(16);
	return myUG2;
}*/
