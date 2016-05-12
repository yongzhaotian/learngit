<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
    String sSerialNo=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSql = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CancelApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sType.equals("1")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute1 = '1'";
	}
	if(sType.equals("2")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute2 = '1'";
	}
	if(sType.equals("3")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute3 = '1'";
	}
	if(sType.equals("4")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute4 = '1'";
	}
	if(sType.equals("5")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute5 = '1'";
	}
	if(sType.equals("6")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute6 = '1'";
	}
	//销售代表使用的取消原因     add by awang 2014/12/29
	if(sType.equals("7")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute7='1'";
	}
	//风控专家使用的取消原因
	if(sType.equals("8")){
		sSql="select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute8='1'";
	}
	//设置意见选项为单选框
	doTemp.setVRadioSql("PhaseOpinion1", sSql);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确定","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","取消","返回列表页面","goBack()",sResourcesPath}
	};
	
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	
	function saveRecord(sPostEvents){
		var sPhaseOpinion1=getItemValue(0,0,"PhaseOpinion1");
		var sSerialNo=getItemValue(0,0,"SerialNo");
		var sInputOrg=getItemValue(0,0,"InputOrg");
		var sInputOrgName=getItemValue(0,0,"InputOrgName");
		var sInputUser=getItemValue(0,0,"InputUser");
		var sInputUserName=getItemValue(0,0,"InputUserName");
		var sInputTime=getItemValue(0,0,"InputTime");
		var sRemark=getItemValue(0,0,"Remark");
		
		if(typeof(sPhaseOpinion1)=="undefined" || sPhaseOpinion1.length==0){
			alert("请选择取消原因再点击确定");
			return;
		}

		if(sPhaseOpinion1=="0180"){
			var sRemark=getItemValue(0,0,"Remark");
			if(typeof(sRemark)=="undefined" || sRemark.length==0){
				alert("选择原因为其他时，备注为必输项");
				return;
			}
		}

		var sCount=RunMethod("BusinessManage","selectOpinoinCount",sSerialNo);
		if(sCount!=0.0){
			alert("此合同此阶段已处理！");
			self.close();
		}
		if(bIsInsert){
			beforeInsert();
		}
		var sOpinionNo=getItemValue(0,0,"OpinionNo");
		as_save("myiframe0",sPostEvents);
		alert("取消合同成功！");
		self.returnValue="SUCCESS";
		self.close();
	}
	
	function goBack(){
		self.returnValue = "_CANCEL_";
		self.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var serialNo = getSerialNo("FLOW_OPINION","OpinionNo");// 获取流水号*/
		var serialNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		/** --end --*/
		
		setItemValue(0,getRow(),"OpinionNo",serialNo);
		
		bIsInsert = false;
	}
	
	
	
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		bCheckBeforeUnload = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
	
    function getValue(obj){      //取消原因在选择结果为【其它】时，备注为必填项。 edit by awang 2014-12-09
    	if(obj.value=="0180"){
    		setItemRequired(0, 0, "Remark", true);
    	}else{
    		setItemRequired(0, 0, "Remark", false);
    	}
    }
</script>
<%@ include file="/IncludeEnd.jsp"%>
