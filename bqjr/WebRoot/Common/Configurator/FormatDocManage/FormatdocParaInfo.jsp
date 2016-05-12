<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    格式化报告参数信息详情
		Input Param:
                    DocID： 格式化调查报告编号
                    OrgID： 使用机构  
	 */
	String PG_TITLE = "格式化报告参数信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sDocID == null) sDocID = "";
	if(sOrgID == null) sOrgID = "";

	String[][] sHeaders={
			{"OrgID","机构编号"},
			{"DocID","文档编号"},
			{"DocName","文档名称"},
			{"DefaultValue","缺省节点组合"},			
			{"Attribute1","属性一"},
			{"Attribute2","属性二"},
			{"InputUser","登记人员"},
			{"InputUserName","登记人员"},
			{"InputTime","登记时间"},
			{"UpdateUser","更新人员"},
			{"UpdateUserName","更新人员"},
			{"UpdateDate","更新日期"}
		};

	String sSql = "Select OrgID,DocID,DocName,DefaultValue,Attribute1,Attribute2,"+
			"InputUser,getUserName(InputUser) as InputUserName,InputTime,"+
			"UpdateUser,getUserName(UpdateUser) as UpdateUserName,UpdateDate "+
			"From FormatDoc_Para "+
			"where DocID='"+sDocID+"' and OrgID='"+sOrgID+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Para";
	doTemp.setKey("DocID,OrgID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWSql("OrgID","select OrgID,OrgName from Org_Info ");
	doTemp.setHTMLStyle("DocID"," style={width:60px} ");
	doTemp.setHTMLStyle("DocName"," style={width:250px} ");
	doTemp.setEditStyle("Attribute1,Attribute2,DefaultValue","3");
	doTemp.setRequired("OrgID,DocID,DocName,DefaultValue",true);   //必输项
	doTemp.setVisible("InputUser,UpdateUser",false);
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("DocID,DocName,InputUserName,UpdateUserName,InputTime,UpdateDate",true);
	doTemp.setUnit("DocName"," <input type=button class=inputdate value=.. onclick=parent.getDocName()>");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID+","+sOrgID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
       setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
       as_save("myiframe0","doReturn('Y');");        
	}
    
    function doReturn(sIsRefresh){
		sDocID = getItemValue(0,getRow(),"DocID");
		parent.sObjectInfo = sDocID+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	/*~[Describe=弹出格式化报告文档名称选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getDocName(){	
		sParaString = "";			
		setObjectValue("SelectFormatDoc",sParaString,"@DocID@0@DocName@1",0,0,"");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>