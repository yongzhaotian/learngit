<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AgreeApprovemodel";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("AgreementApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","提交","提交所有修改","saveRecord()","","","","btn_icon_save",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">	
	//检查协议代码的重复性
	function checkAgreementCode(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sAgreementApproveCode = getItemValue(0,getRow(),"AgreementApproveCode");
		sAgreementApproveCode = sAgreementApproveCode.replace(" ","");
		setItemValue(0,0,"AgreementApproveCode",sAgreementApproveCode);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		var sReturnAgreementApproveCode = RunMethod("CustomerManage","SelectAgreementApproveCode",sAgreementApproveCode+","+sSerialNo);
		if((!(typeof(sAgreementApproveCode)=="undefined" || sAgreementApproveCode.length==0))&&sReturnAgreementApproveCode!="0.0"){
			alert("协议代码已存在，请重新填写！");
			return false;
		}
		return true;
	}
	function showAgreementCode(){
		var sAgreementApproveStatus=getItemValue(0, 0, "AgreementApproveStatus");
		var sAgreementApproveCode=getItemValue(0, 0, "AgreementApproveCode");
		if(sAgreementApproveStatus=="1"){
				setItemValue(0,0,"AgreementApproveCode",sAgreementApproveCode);
				showItem(0, 0, "AgreementApproveCode");
				setItemReadOnly(0, 0, "AgreementApproveCode", false);
				setItemRequired(0, 0, "AgreementApproveCode", true);
				//setItemDisabled(0,0,"AgreementCode",true)		
		}else{	
			hideItem(0, 0, "AgreementApproveCode");//隐藏
			setItemValue(0,0,"AgreementApproveCode","");
			setItemRequired(0, 0, "AgreementApproveCode", false);
	//		setItemDisabled(0,0,"AgreementCode",false);
		}
	}
	
	function saveRecord(sPostEvents){
		if(!checkAgreementCode()){
			return;
		}
		
		var serialno = getItemValue(0, 0, "SERIALNO"); //申请序号
		var agreementapprovestatus = getItemValue(0, 0, "AgreementApproveStatus"); //审核状态
		var agreementapprovetime = getItemValue(0, 0, "AgreementApproveTime"); //审核时间
		var agreementapproveman = getItemValue(0, 0, "agreementapproveman"); //审核人
		var agreementapprovecode = getItemValue(0, 0, "AgreementApproveCode"); //协议代码
		
		var parameter = "AllSerialNo="+serialno+",AgreementApproveStatus="+agreementapprovestatus+",AgreementApproveTime="+agreementapprovetime
				+",agreementapprovecode="+agreementapprovecode+",agreementapproveman="+agreementapproveman;
		
		/************begin CCS-1040, 处理协议代码为空也能保存的问题 huzp 20160126*****************************************************/
		if(agreementapprovestatus=="1" && agreementapprovecode.length==0){
			as_save("myiframe0",sPostEvents);
		}else{
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "agreementApproveRetail", parameter); //处理不通过数据状态
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectRnoIsBuild", "AllSerialNo="+serialno); // 更新零售商状态
			showAgreementCode();
			alert("审核成功");
		}
		/*************end*****************************************************/
		//as_save("myiframe0",sPostEvents);

		
	}
	
	function initRow(){
		setItemValue(0,0,"AgreementApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		setItemValue(0,0,"agreementapproveman","<%=CurUser.getUserID() %>");
		showAgreementCode();
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
