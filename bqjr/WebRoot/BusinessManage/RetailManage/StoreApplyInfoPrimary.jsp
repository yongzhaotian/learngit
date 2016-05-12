<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	ARE.getLog().info("sSerialNo============================================"+sSerialNo);
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreApplyInfoPrimary";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("PrimaryApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","提交","提交所有修改","saveRecord()","","","","btn_icon_save",""},
			{"true","","Button","返回","返回列表页面","goBack()","","","","",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function selectStatus(){
		var sPrimaryApproveStatus = getItemValue(0,getRow(),"PrimaryApproveStatus");
		if(sPrimaryApproveStatus=="1"){
			hideItem(0, 0, "PrimaryRefuseReason");//隐藏
			setItemValue(0, 0, "PrimaryRefuseReason", "");
			setItemRequired(0,0, "PrimaryRefuseReason", false);
			}else if (sPrimaryApproveStatus=="2"){
				showItem(0, 0, "PrimaryRefuseReason");//显示
		        setItemRequired(0,0, "PrimaryRefuseReason", true);
			}
	}
	
	function saveRecord(sPostEvents){
		var sssSerialNo="<%=sSerialNo%>";
		var sPrimaryApproveStatus=getItemValue(0,0,"PrimaryApproveStatus");
		var sRemark=getItemValue(0,0,"REMARK");
		var sPrimaryRefuseReason=getItemValue(0,0,"PrimaryRefuseReason");
		var sPrimaryApproveTime=getItemValue(0,0,"PRIMARYAPPROVETIME");
		var sPrimaryApprovePerson=getItemValue(0,0,"PRIMARYAPPROVEPERSON");
		if(sPrimaryApproveStatus=="4"){
			alert("请选择初审状态！");
			return;
		}

		//提交
		var AllSerialNo = sssSerialNo.replace(/,/g,"|");//替换掉所有,
		var para = "AllSerialNo="+AllSerialNo+",PrimaryApproveStatus="+sPrimaryApproveStatus
			+",Remark="+sRemark+",PrimaryRefuseReason="+sPrimaryRefuseReason
			+",PrimaryApproveTime="+sPrimaryApproveTime+",PrimaryApprovePerson="+sPrimaryApprovePerson;
		RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno","PrimaryApproveStore", para);
		
		as_save("myiframe0",sPostEvents);
		selectStatus();
	}
	
	// 返回交易列表
	function goBack()
	{
		//AsControl.OpenView("/BusinessManage/ChannelManage/RetailStoreApplyList.jsp","","_self");
		self.close();
	}
	
	function initRow(){
		setItemValue(0,0,"PRIMARYAPPROVETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		setItemValue(0,0,"PRIMARYAPPROVEPERSON","<%=CurUser.getUserID()%>");
		selectStatus();
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SERIALNO","<%=sSerialNo%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
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
