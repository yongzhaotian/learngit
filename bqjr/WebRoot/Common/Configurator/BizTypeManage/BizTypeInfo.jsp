<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    产品信息详情
	 */
	String PG_TITLE = "产品信息详情";
	
	//获得组件参数	TypeNo：    产品编号
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if(sTypeNo==null) sTypeNo="";

	String[][] sHeaders = {
			{"TypeNo","类型编号（永久）"},
			{"SortNo","排序编号"},
			{"TypeName","类型名称"},
			{"IsInUse","是否有效"},
			{"TypesortNo","类型序号"},
			{"SubtypeCode","分类编号"},
			{"InfoSet","信息设置"},
			{"ApplyDetailNo","申请显示模板"},
			{"ApproveDetailNo","最终审批意见显示模板"},
			{"ContractDetailNo","合同显示模板"},
			{"DisplayTemplet","出帐显示模板"},
			{"Attribute1","属性1"},
			{"Attribute2","属性2"},
			{"Attribute3","属性3"},
			{"Attribute4","属性4"},
			{"Attribute5","属性5"},
			{"Attribute6","属性6"},
			{"Attribute7","属性7"},
			{"Attribute8","属性8"},
			{"Attribute9","属性9"},
			{"Attribute10","属性10"},
			{"Remark","备注"},
			{"InputUserName","登记人"},
			{"InputUser","登记人"},
			{"InputOrgName","登记机构"},
			{"InputOrg","登记机构"},
			{"InputTime","登记时间"},
			{"UpdateUserName","更新人"},
			{"UpdateUser","更新人"},
			{"UpdateTime","更新时间"},
			{"Attribute11","属性11"},
			{"Attribute12","属性12"},
			{"Attribute13","属性13"},
			{"Attribute14","属性14"},
			{"Attribute15","属性15"},
			{"Attribute16","属性16"},
			{"Attribute17","属性17"},
			{"Attribute18","属性18"},
			{"Attribute19","属性19"},
			{"Attribute20","属性20"},
			{"Attribute21","属性21"},
			{"Attribute22","属性22"},
			{"Attribute23","属性23"},
			{"Attribute24","属性24"},
			{"Attribute25","属性25"},
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
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndBack()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
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