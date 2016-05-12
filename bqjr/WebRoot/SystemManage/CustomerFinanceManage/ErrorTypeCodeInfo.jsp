<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ErrorTypeCodeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	System.out.println("SerialNo==============================" + sSerialNo);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	// 检查错误代码是否已经存在
	function checkErrorCode() {
		var sCode = getItemValue(0, 0, "ErrorCode");
		var sErrorSerialNo = RunMethod("公用方法", "GetColValue", "ErrorTypecode_Info,SerialNo,ErrorCode='"+sCode+"'");
		//alert(sErrorSerialNo+"|"+typeof(sErrorSerialNo));
		if (sErrorSerialNo!="Null") {
			alert("该错误代码已经存在，请重新输入！");
			setItemValue(0, 0, "ErrorCode", "");
			return;
		}
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/ErrorTypeCodeList.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
	}
	//通过选择质量等级进行对应的判断
	function changeValue(){
		var a =getItemValue(0,getRow(),"qualitygradecodeno");//质量等级
		if(a==1||a==2){//alert("为关键与非关键时，下面3个下拉框必填！");
			setItemReadOnly(0,getRow(),"ErrorCode",false);//设置不可填
			setItemReadOnly(0,getRow(),"ErrorType",false);//设置不可填
			setItemReadOnly(0,getRow(),"ErrorContent",false);//设置不可填
			
			setItemValue(0, getRow(), "ErrorCode", "");//先清空选项
			setItemValue(0, getRow(), "ErrorType", "");//先清空选项
			setItemValue(0, getRow(), "ErrorContent", "");//先清空选项

			setItemRequired(0,getRow(),"ErrorCode",1);//设置必填项
			setItemRequired(0,getRow(),"ErrorType",1);//设置必填项
			setItemRequired(0,getRow(),"ErrorContent",1);//设置必填项
		}else if(a==3){//alert("为合格时，下面3个下拉框不可填！");
			setItemValue(0, getRow(), "ErrorCode", "");//先清空选项
			setItemValue(0, getRow(), "ErrorType", "");//先清空选项
			setItemValue(0, getRow(), "ErrorContent", "");//先清空选项
			
			setItemReadOnly(0,getRow(),"ErrorCode",true);//设置不可填
			setItemReadOnly(0,getRow(),"ErrorType",true);//设置不可填
			setItemReadOnly(0,getRow(),"ErrorContent",true);//设置不可填
			
			setItemRequired(0,getRow(),"ErrorCode",0);//设置非必填项
			setItemRequired(0,getRow(),"ErrorType",0);//设置非必填项
			setItemRequired(0,getRow(),"ErrorContent",0);//设置必填项

		}else if (a==4 || a==5||a==6){//alert("为特办时，下面3个下拉框可填可不填！");
			setItemValue(0, getRow(), "ErrorCode", "");//先清空选项
			setItemValue(0, getRow(), "ErrorType", "");//先清空选项
			setItemValue(0, getRow(), "ErrorContent", "");//先清空选项

			setItemReadOnly(0,getRow(),"ErrorCode",false);//设置可填
			setItemReadOnly(0,getRow(),"ErrorType",false);//设置可填
			setItemReadOnly(0,getRow(),"ErrorContent",false);//设置可填
			
			setItemRequired(0,getRow(),"ErrorCode",0);//设置为非必填项
			setItemRequired(0,getRow(),"ErrorType",0);//设置为非必填项
			setItemRequired(0,getRow(),"ErrorContent",0);//设置必填项

		}else{
			setItemReadOnly(0,getRow(),"ErrorCode",true);

		}
	}
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = getSerialNo("ErrorTypeCode_Info","SerialNo");// 获取流水号`
			setItemValue(0,getRow(),"SerialNo",sSerialNo);
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");

			setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
