<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "显示模板分组信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sDONo = CurPage.getParameter("DONo");
	if(sDONo == null) sDONo = "";
	
        
  //通过DW模型产生ASDataObject对象doTemp
  	String sTempletNo = "DataObjectGroupList";//模型编号
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
   	
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
        
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDONo);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true", "All","Button","快速新增","当前页面新增","afterAdd()","","",""},
		{"true", "All","Button","快速保存","快速保存当前页面","afterSave()","","",""},
		{"true", "All", "Button", "删除", "", "deleteRecord()", "", "", ""},
	};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var sDONo = "<%=sDONo%>";
	function afterSave(){
		as_save("myiframe0");
	}
	
	//快速新增
	function afterAdd(){
		as_add("myiframe0");
		//快速新增时候给定默认值
		setItemValue(0,getRow(),"DONO",sDONo);
	}
	
	//快速删除
	function deleteRecord(){
		var sDockId = getItemValue(0,getRow(),"DOCKID");
		if (typeof(sDockId)=="undefined" || sDockId.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage("2"))){ //您真的想删除该信息吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>