<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%@
 page import="com.amarsoft.are.jbo.BizObject"%><%@
 page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%><%
	/*
		页面说明: 额度分配基本信息页面
	 */
	String PG_TITLE = "额度分配基本信息";
	//获得页面参数	
	String sObjectNo=CurPage.getParameter("ObjectNo"); //额度申请编号
	String sObjectType=CurPage.getParameter("ObjectType"); //额度申请类型
	String sSerialNo=CurPage.getParameter("SerialNo");  //分配额度编号
	if(sSerialNo==null) sSerialNo="";

	ASDataObject doTemp = new ASDataObject("ClDivideInfo",Sqlca);
	CreditObjectAction creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	BizObject biz = creditObjectAction.creditObject;
	String sBusinessCurrency=biz.getAttribute("BusinessCurrency").getString();		
	String sCycleFlag=biz.getAttribute("CycleFlag").getString();//cjyu 是否循环
 	if("2".equals(sCycleFlag)){
		doTemp.setReadOnly("CycleFlag",true);
		doTemp.setDefaultValue("CycleFlag","2");

	} 
	doTemp.setDefaultValue("ObjectNo",sObjectNo);
	doTemp.setDefaultValue("ObjectType",creditObjectAction.getRealCreditObjectType());  //modified by yzheng 2013-6-25
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly="1";
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回到额度分配列表","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		
	    beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack(){
		OpenPage("/CreditLineManage/CreditLineAccount/SubCreditLineList.jsp","_self","");
	}
	
	<%/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"SerialNo",getSerialNo("CL_DIVIDE","SerialNo"));
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~modify by hwang 20090617,修改业务类型选择树图 用于授信额度分配新增子额度时，业务品种可以选择“流动资金贷款、票据融资等”大项~*/
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectDivideName(){
		sBusinessTypeInfo = AsControl.PopView("/Common/ToolsA/BusinessTypeSelect.jsp","Status=<%=creditObjectAction.getCustomerType()%>","dialogWidth=600px;dialogHeight=500px;center:yes;status:no;statusbar:no");
		//alert(sBusinessTypeInfo);
		
		if(typeof(sBusinessTypeInfo) != "undefined" && sBusinessTypeInfo != ""){
			sBusinessTypeInfo = sBusinessTypeInfo.split('@');
			sBusinessTypeValue = sBusinessTypeInfo[0];//-- 代码
			sBusinessTypeName = sBusinessTypeInfo[1];//--名称
			setItemValue(0,getRow(),"DivideCode",sBusinessTypeValue);
			setItemValue(0,getRow(),"DivideName",sBusinessTypeName);				
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
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