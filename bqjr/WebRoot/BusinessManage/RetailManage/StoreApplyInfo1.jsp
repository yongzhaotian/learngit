<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "门店准入审批";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String[] sSerialNoArr = null;
	String SerialNo="";
	if(sSerialNo==null){
		sSerialNo="";
	}else{
		sSerialNoArr = sSerialNo.split(",");
		SerialNo = sSerialNoArr[0];
	}
	
	System.out.print("------------"+sSerialNo);
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AgreeApproveStoremodel";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("AgreementApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","提交","提交所有修改","saveRecord()","","","","btn_icon_save",""},
			
			
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
 	function showAgreementCode(){
		var sAgreementApproveStatus=getItemValue(0, 0, "AgreementApproveStatus");
		var sAgreementCode=getItemValue(0, 0, "AgreementCode");
		var sRAgreementApproveCode=getItemValue(0, 0, "RAgreementApproveCode");
		if(sAgreementApproveStatus=="1"){
			if(sRAgreementApproveCode!=""&&sRAgreementApproveCode!=null){
				setItemValue(0,0,"AgreementCode",sRAgreementApproveCode);
				showItem(0, 0, "AgreementCode");
				setItemReadOnly(0, 0, "AgreementCode", true);
			}else{
				alert("请先审核商户！");
				return ;
			}
		}else{	
			hideItem(0, 0, "AgreementCode");//隐藏
			setItemValue(0,0,"AgreementCode","");
		}
		
	} 
	
	function saveRecord(sPostEvents){
		var sssSerialNo="<%=sSerialNo%>";
		if(sssSerialNo==null){
			alert("请选择一条记录！");
			return;
		}
		var ssSerialNo=sssSerialNo.split(",");
		var sAgreementApproveStatus=getItemValue(0, 0, "AgreementApproveStatus");
		var sAgreementCode=getItemValue(0, 0, "AgreementCode");
		var sRAgreementApproveCode=getItemValue(0, 0, "RAgreementApproveCode");
		var sAgreementApproveTime=getItemValue(0, 0, "AgreementApproveTime");
		var sAgreementApprovePerson=getItemValue(0,0,"AgreementApprovePerson");//协议审核人 add by tangyb CCS-992
		if(sRAgreementApproveCode==""){
			alert("请先审核商户！");
			return ;
		}
		
		//提交
		var AllSerialNo = sssSerialNo.replace(/,/g,"|");//替换掉所有,
		var para = "AllSerialNo="+AllSerialNo+",AgreementCode="+sAgreementCode+",AgreementApproveStatus="+sAgreementApproveStatus
					+",AgreementApproveTime="+sAgreementApproveTime+",agreementapproveperson="+sAgreementApprovePerson;
		RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno","AgreementApproveStore", para);
		
		var rt = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "AllSerialNo="+AllSerialNo);
	
		as_save("myiframe0",sPostEvents);
		showAgreementCode();
	}
	
	function initRow(){
		setItemValue(0,0,"AgreementApprovePerson","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"AgreementApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		showAgreementCode();
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");//新增记录
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
