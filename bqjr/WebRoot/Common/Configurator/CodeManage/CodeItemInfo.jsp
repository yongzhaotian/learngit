<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 代码表详情
		Input Param:
                    CodeNo：    代码编号
                    ItemNo：    项目编号（新增是不传入）
	 */
	String PG_TITLE = "代码表详情"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String sDiaLogTitle = "";
	
	//获得组件参数	
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo"));
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	String sCodeName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeName"));
	//将空值转化为空字符串
	if(sCodeNo == null) sCodeNo = "";
	if(sItemNo == null) sItemNo = "";
	if(sCodeName == null) sCodeName = "";
	
	if(sCodeNo.equals("")){
		sDiaLogTitle = "【 代码库新增配置 】";
	}else{
		if(sItemNo==null || sItemNo.equals("")){
			sItemNo="";
			sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』新增配置";
		}else{
			sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』查看修改配置";
		}
	}
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CodeItemInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
	if(!sCodeNo.equals("")){
		doTemp.setVisible("CodeNo",false); 
	}else{
		doTemp.setRequired("CodeNo",true);
	} 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.getUserID()+","+sCodeNo+")");
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCodeNo+","+sItemNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {		
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并新增","保存后新增","saveAndNew()",sResourcesPath}			
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(sPostEvents){
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndNew(){
		saveRecord("newRecord()");
	}
   
	function newRecord(){
        OpenComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","_self");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	setDialogTitle("<%=sDiaLogTitle%>");
</script>	
<%@ include file="/IncludeEnd.jsp"%>