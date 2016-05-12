<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 页面信息详情
	 */
	String PG_TITLE = "页面管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sPageID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PageID"));
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID",10));
	if(sPageID==null) sPageID="";
	if(sCompID==null) sCompID="";

	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Distinct CompID from REG_COMP_Page where PageID=:PageID ").setParameter("PageID",sPageID));
	if(rs.next()){
		sCompID = rs.getString(1);
	}
	rs.getStatement().close();
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PageInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.UpdateTable = "REG_PAGE_DEF";
	doTemp.setKey("PageID",true);

	doTemp.setDDDWCode("JSPMODEL","JSPModel");
	doTemp.setRequired("PageName,CompID",true);

	doTemp.setHTMLStyle("PageID,PageURL,PageName,"," style={width:600px} ");

	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:600px;overflow:auto} ");
 	doTemp.setLimit("Remark",400);

	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputTime,UpdateTime,InputUserName,InputOrgName,UpdateUserName",true);
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	doTemp.setVisible("DoNo,JspModel,InputUser,UpdateUser,InputOrg",false);
	
	if(sCompID!=null) doTemp.setDefaultValue("CompID",sCompID);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	if(sCompID!=null && !sCompID.equals("")) dwTemp.setEvent("AfterInsert","!Configurator.InsertCompPage(#PageID,"+sCompID+")");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPageID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表","doReturn('N')",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	
	function saveRecord(){
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y');");        
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"PageID");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
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
		setItemValue(0,0,"CompID","<%=sCompID%>");
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>