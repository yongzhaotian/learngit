<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.upload.*,java.io.File" %>
<%@page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006/07/12
		Tester: 
  		Content: 将选择的Excel文件导入到数据库表中
  		Input Param:
  		Output param:
  		History Log:
			
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
		//定义变量
		BufferedReader br = null;	
		FileReader fr = null;	 
		String sValueStr = "",sSql = ""; 
		int n = 0;
				
		AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
		myAmarsoftUpload.initialize(pageContext);
		myAmarsoftUpload.upload(); 		
		String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName");
				
    	try
    	{
			System.out.println("------FileName------"+sFileName);
			//检查上载文件是否存在 
			File checkFile = new File(sFileName); 
			if(sFileName.indexOf(".xls")<0)
			{
	%>
			<script type="text/javascript">
			    alert("当前所选择文件不是Excel文件，请重新选择！");
			    self.close();
			</script>
	<%
			}else 
			{
				if(checkFile.exists())
				{
					//设定FileINputStream读取Excel档 
					FileInputStream finput = new FileInputStream(sFileName);
					POIFSFileSystem fs = new POIFSFileSystem(finput);
					HSSFWorkbook wb = new HSSFWorkbook(fs);
					HSSFSheet sheet = wb.getSheetAt(0);
					//读取第一个工作表，宣告其为sheet 
					finput.close();
					HSSFRow row = null;
					//宣告一列 
					HSSFCell cell = null;
					//宣告一个储存格 
					short i = 0;
					short j = 0;
					int iCount = 0;
 
					for (i = 0;i <= sheet.getLastRowNum();i++)
					{					
						//在导入下一笔数据前需初始化该变量
						sValueStr = "";
						row = sheet.getRow(i);
						for (j = 0;j < row.getLastCellNum();j++)
						{
							cell = row.getCell(j);
						
							//判断储存格的格式 
							switch ( cell.getCellType() )
							{
								case HSSFCell.CELL_TYPE_NUMERIC:
									sValueStr += cell.getNumericCellValue() + ",";								
									break;
								case HSSFCell.CELL_TYPE_STRING:
									sValueStr += "'" + cell.getStringCellValue() +"',";
									break;
								case HSSFCell.CELL_TYPE_FORMULA: 
									//读出公式储存格计算后的值
									//若要读出公式内容，可用cell.getCellFormula()
									sValueStr += cell.getNumericCellValue() + ",";						 
									break;
								default:
									sValueStr += "'不明的格式'" + ",";
									break;
							}							
						}
						
						//获得导入总记录数
						iCount = i + 1; 
						
						if(sValueStr.length() > 0)
							sValueStr = sValueStr.substring(0,sValueStr.length()-1);
						sSql = "insert into TEST_FILE values("+sValueStr+")"; 
						Sqlca.executeSQL(sSql); 
						System.out.println("共导入数据库"+iCount+"条记录"); 
					}
					//释放资源
					finput.close();
					fs = null;
					wb = null;
					sheet = null;
					row = null;
					cell = null;
				}					
			}
			myAmarsoftUpload = null;
        } 
		catch(Exception e) 
		{
        	out.println("An error occurs : " + e.toString());  
			//释放资源            
        	myAmarsoftUpload = null;        	
    	}
    
%>

<script type="text/javascript">
    alert("上传成功！");
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>