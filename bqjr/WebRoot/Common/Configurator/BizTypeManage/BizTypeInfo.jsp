<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ��Ʒ��Ϣ����
	 */
	String PG_TITLE = "��Ʒ��Ϣ����";
	
	//����������	TypeNo��    ��Ʒ���
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if(sTypeNo==null) sTypeNo="";

	String[][] sHeaders = {
			{"TypeNo","���ͱ�ţ����ã�"},
			{"SortNo","������"},
			{"TypeName","��������"},
			{"IsInUse","�Ƿ���Ч"},
			{"TypesortNo","�������"},
			{"SubtypeCode","������"},
			{"InfoSet","��Ϣ����"},
			{"ApplyDetailNo","������ʾģ��"},
			{"ApproveDetailNo","�������������ʾģ��"},
			{"ContractDetailNo","��ͬ��ʾģ��"},
			{"DisplayTemplet","������ʾģ��"},
			{"Attribute1","����1"},
			{"Attribute2","����2"},
			{"Attribute3","����3"},
			{"Attribute4","����4"},
			{"Attribute5","����5"},
			{"Attribute6","����6"},
			{"Attribute7","����7"},
			{"Attribute8","����8"},
			{"Attribute9","����9"},
			{"Attribute10","����10"},
			{"Remark","��ע"},
			{"InputUserName","�Ǽ���"},
			{"InputUser","�Ǽ���"},
			{"InputOrgName","�Ǽǻ���"},
			{"InputOrg","�Ǽǻ���"},
			{"InputTime","�Ǽ�ʱ��"},
			{"UpdateUserName","������"},
			{"UpdateUser","������"},
			{"UpdateTime","����ʱ��"},
			{"Attribute11","����11"},
			{"Attribute12","����12"},
			{"Attribute13","����13"},
			{"Attribute14","����14"},
			{"Attribute15","����15"},
			{"Attribute16","����16"},
			{"Attribute17","����17"},
			{"Attribute18","����18"},
			{"Attribute19","����19"},
			{"Attribute20","����20"},
			{"Attribute21","����21"},
			{"Attribute22","����22"},
			{"Attribute23","����23"},
			{"Attribute24","����24"},
			{"Attribute25","����25"},
		};
	String sSql = "select "+
			"TypeNo,SortNo,TypeName,IsInUse,TypesortNo,SubtypeCode,InfoSet,"+
			"ApplyDetailNo,ApproveDetailNo,ContractDetailNo,DisplayTemplet,"+
			"Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,"+
			"Attribute6,Attribute7,Attribute8,Attribute9,Attribute10,Remark,"+
			"getUserName(InputUser) as InputUserName,InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,InputOrg,InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,UpdateUser,UpdateTime,"+
			"Attribute11,Attribute12,Attribute13,Attribute14,Attribute15,"+
			"Attribute16,Attribute17,Attribute18,Attribute19,Attribute20,"+
			"Attribute21,Attribute22,Attribute23,Attribute24,Attribute25 "+
			"from BUSINESS_TYPE Where TypeNo = '"+sTypeNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_TYPE";
	doTemp.setKey("TypeNo",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setRequired("TypeNo,SortNo,TypeName",true);
	doTemp.setDDDWCode("IsInUse","IsInUse");
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("Remark",120);

 	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndBack()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndBack(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
 		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","newRecord()");      
	}
    
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"TypeNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
		OpenComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
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
</script>	
<%@ include file="/IncludeEnd.jsp"%>