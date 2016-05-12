<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		/*
		Content:    格式化报告定义信息详情
		Input Param:
                    DocID：    格式化调查报告编号
                    DirID：    格式化报告目录编号
	 */
	String PG_TITLE = "格式化报告定义信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));
	String sDirID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DirID"));
	if(sDocID == null) sDocID = "";
	if(sDirID == null) sDirID = "";

	String[][] sHeaders={
			{"DocID","报告编号"},
			{"DirID","目录编号"},
			{"DirName","目录名称"},
			{"JspFileName","JSP文件"},
			{"HTMLFileName","HTML文件"},
			{"ArrangeAttr","排列属性"},
			{"CircleAttr","循环属性"},
			{"Attribute1","属性一"},
			{"Attribute2","属性二"},
			{"OrgID","机构名称"},
			{"OrgName","机构名称"},
			{"UserID","人员编号"},
			{"UserName","人员名称"},
			{"InputDate","输入日期"},
			{"UpdateDate","更新日期"}
		};

	String sSql = "Select DocID,DirID,DirName,JspFileName,HTMLFileName,"+
			"ArrangeAttr,CircleAttr,Attribute1,Attribute2,"+
			"OrgID,getOrgName(OrgID) as OrgName,"+
			"UserID,getUserName(UserID) as UserName,"+
			"InputDate,UpdateDate "+
			"From FormatDoc_Def "+
			"where DocID='"+sDocID+"' and DirID='"+sDocID+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Def";
	doTemp.setKey("DocID,DirID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID,DirID"," style={width:60px} ");
	doTemp.setHTMLStyle("DirName"," style={width:180px} ");
	doTemp.setEditStyle("Attribute1,Attribute2,ArrangeAttr,CircleAttr","3");
	doTemp.setRequired("DocID,DirID,DirName",true);   //必输项
	doTemp.setVisible("OrgID,UserID",false);
	doTemp.setUpdateable("OrgName,UserName",false);
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID+","+sDirID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y');");        
	}
    
    function doReturn(sIsRefresh){
		sDocID = getItemValue(0,getRow(),"DocID");
       parent.sObjectInfo = sDocID+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			if("<%=sDocID%>"!=""){
				setItemValue(0,0,"DocID","<%=sDocID%>");
			}
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>