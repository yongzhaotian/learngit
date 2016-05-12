<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "手工匹配";

	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	
	String sBusinessDate = SystemConfig.getBusinessDate();

	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "BankLinkFileList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setReadOnly("", true); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	/* function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		
		as_save("myiframe0",sPostEvents);
	} */
	
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	function getCustomerID(){
		var returnValue = setObjectValue("SelectCustomerID","","",0,0,"");
		sCustomerID=returnValue.split("@")[0];
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			setItemValue(0, 0, "CUSTOMERID", "");
			return;
		}
		setItemValue(0, 0, "CUSTOMERID", sCustomerID);
		setItemValue(0,0,"MATCHINGFLAG","3");
		setItemValue(0, 0, "UPDATEORGID", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=sBusinessDate%>");
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		
		setItemValue(0, 0, "UPDATEORGID", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=sBusinessDate%>");
	}
	
	function deleteRecord(){
		var Serialno = getItemValue(0,getRow(),"serialno");
		if (typeof(Serialno)=="undefined" || Serialno.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var Serialno = getItemValue(0,getRow(),"serialno");
		if (typeof(Serialno)=="undefined" || Serialno.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/WithholdDetailsInfo.jsp","SerialNo="+Serialno,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
