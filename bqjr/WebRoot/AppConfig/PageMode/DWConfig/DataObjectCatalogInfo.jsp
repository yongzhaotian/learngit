 <%@ page contentType="text/html; charset=GBK"%>
 <%@ include file="/IncludeBegin.jsp"%>
 <%
   	String PG_TITLE = "显示模板目录信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
   	CurPage.setAttribute("ShowDetailArea","true");
   	CurPage.setAttribute("DetailAreaHeight","250");
    	
	//获得参数	
	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";
   
  //通过DW模型产生ASDataObject对象doTemp
  	String sTempletNo = "DataObjectCatalogInfo";//模型编号
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
        
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
        
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));    
    
    String sButtons[][] = {
        {"true","All","Button","保存","保存所有修改","as_save(0)","","","","btn_icon_save"},
    };
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">	
	setDialogTitle("显示模板配置");
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	OpenComp("DataObjectLibraryList","/AppConfig/PageMode/DWConfig/DataObjectLibraryList.jsp","DONO=<%=sDoNo%>","DetailFrame",""); 
</script>	
<%@ include file="/IncludeEnd.jsp"%>