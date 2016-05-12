Function spreadsheetPrintout(data) 
	fileName= "c:\temporaryFile.xls"
	s = createTemporaryFile(fileName,data)
	
	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(fileName)
	
	xlBook.Sheets(1).PrintOut
	xlBook.Close 
end function


function spreadsheetprintPreview(data) 
	fileName= "c:\temporaryFile.xls"
	s = createTemporaryFile(fileName,data)
	
	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(fileName)
	
	xlApp.Application.Visible = True
	xlApp.windows(1).visible = True
	xlBook.Sheets(1).PrintPreview
	xlBook.Close 
end function

function spreadsheetTransfer(data) 
	fileName= "c:\temporaryFile.xls"
	s = createTemporaryFile(fileName,data)
	
	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(fileName)
	
	xlApp.Application.Visible = True
	xlApp.windows(1).visible = True
	
end function


function printPreviewSpreadsheet(data) 
	fileName= "c:\testfile.xls"
	s = createTemporaryFile(fileName,data)
	
	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(fileName)
	
	xlApp.Application.Visible = True
	xlApp.windows(1).visible = True
	xlBook.Sheets(1).PrintPreview
	xlBook.Close 
	
	
end function


function createTemporaryFile(fileName,data) 
	'fileName= "c:\tmp"+CStr(getRandomNumber())+".xls"
	'set objFS=CreateObject("Scripting.FileSystemObject")
	'set f = objFS.CreateTextFile(fileName, True, True)
	Dim fso,tfolder,tfile
	Const TemporaryFolder = 2
	Set fso = CreateObject("Scripting.FileSystemObject")	
	Set tfolder = fso.GetSpecialFolder(TemporaryFolder)
	fileName = tfolder+"\"+fso.GetTempName+".xls"    
	Set tfile = fso.CreateTextFile(fileName)	
	tfile.write("<html><head><meta http-equiv='Content-Type' content='text/html; charset=gb2312' /></head><body>"+data+"</body></html>")
	tfile.close
end function

function writeToTheEndOfFile(fileName,data) 
	set objFS=CreateObject("Scripting.FileSystemObject")
	set f = objFS.OpenTextFile(fileName, 8, true)
	f.write(data)
	f.close
end function

function generateKey()
	generateKey="date:2001/10/1"
end function

function myFormatNumber(dMoney,iType)  
    myFormatNumber = FormatNumber(dMoney,iType,-1,0,0)
end Function

function myUG(str)
	myUG=Hex(Asc(str))
end Function
	
function getRandomNumber()
	Randomize   ' Initialize random-number generator.
	getRandomNumber= Rnd
	
end function
