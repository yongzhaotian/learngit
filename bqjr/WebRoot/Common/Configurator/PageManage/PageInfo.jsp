<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ҳ����Ϣ����
	 */
	String PG_TITLE = "ҳ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sPageID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PageID"));
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID",10));
	if(sPageID==null) sPageID="";
	if(sCompID==null) sCompID="";

	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Distinct CompID from REG_COMP_Page where PageID=:PageID ").setParameter("PageID",sPageID));
	if(rs.next()){
		sCompID = rs.getString(1);
	}
	rs.getStatement().close();
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PageInfo";//ģ�ͱ��
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
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	if(sCompID!=null && !sCompID.equals("")) dwTemp.setEvent("AfterInsert","!Configurator.InsertCompPage(#PageID,"+sCompID+")");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPageID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�","doReturn('N')",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	
	function saveRecord(){
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y');");        
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"PageID");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
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