<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "门店包裹新增页面";

	// 获得页面参数
	String sPackNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PackNo"));

	if(sPackNo==null) sPackNo="";
	
    //销售门店
    //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
    String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
    if(sNo == null) sNo = "";
    System.out.println("-------销售门店-------"+sNo);

	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ShopPackageInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPackNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”

	
	/*~[Describe=获取包裹流水号;InputParam=无;OutPutParam=无;]~*/
	function getSerialNo(sTableName,sColumnName,sPrefix){
		//使用GetSerialNo.jsp来抢占一个流水号
		if(typeof(sPrefix)=="undefined" || sPrefix=="") sPrefix="";
		return RunJspAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix);
	}
	
	function saveRecord(sPostEvents){
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack(){
		//AsControl.OpenView("/BusinessManage/ContractManage/MailingPackageList.jsp","","_self");
	}

	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var serialNo = getSerialNo("Package_Info","PackNo");// 获取流水号
			setItemValue(0,getRow(),"PackNo",serialNo);
			//包裹类型：01门店包裹
			setItemValue(0,0,"PackType","01");
			//包裹状态：01待邮寄；02已邮寄
			setItemValue(0,0,"Status","01");
			//获取门店编号
			setItemValue(0,0,"SNo","<%=sNo%>");
			
			setItemValue(0,0,"CreateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"CreateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"CreateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
