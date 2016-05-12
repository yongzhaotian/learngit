<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 预审共同借款人
		Input Param:
			
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "共同借款人信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sTempletNo = "CommonPretrialInfo";	
	//获得组件参数，客户代码
	String sCustomerID       = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sSerialNo         = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	
	if(sCustomerID == null) sCustomerID = "";
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("CertType", "onChange=\"javascript:parent.isCardNo()\";style={background=\"#EEEEff\"}");
	
	doTemp.WhereClause = " where bc.SerialNo = cr.SerialNo and cr.objectno = ci.customerid 	 and cr.objectno = '"+sCustomerID+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly="0";

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(!InsertCustomer()){//插入客户信息表
			return;
		}
		
		//----插入信息岛关联表中-----
		//客户编号
		var sCustomerID = getItemValue(0,getRow(),"ObjectNo");
		//客户类型
		var sCustomerType = getItemValue(0,getRow(),"RelationStatus");
		//申请角色类型
		var sCustomerRole = getItemValue(0,getRow(),"CustomerRole");
		//出生日期
		var sBirthDay = getItemValue(0,getRow(),"BirthDay");
		//申请类型
		var sObjectType = "BusinessContract";
		//申请号
		var sSerialNo = "<%=sSerialNo%>";
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sCertID = getItemValue(0,0,"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		
// 		alert("获取客户编号："+sCustomerID+"申请角色:"+sCustomerRole+"客户类型:"+sCustomerType+"申请类型:"+sObjectType+"申请号:"+sSerialNo+"出生日期:"+sBirthDay);
		//判断关联表中是否存在记录
		var sReturn=RunMethod("BusinessManage","ContractYesNo",sSerialNo+","+sObjectType+","+sCustomerID);
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == "Null"){
			  //插入信息到关联表中
		      RunMethod("BusinessManage","AddContractRecord",sSerialNo+","+sObjectType+","+sCustomerID+","+sCustomerType+","+sCustomerRole+","+sBirthDay);
		      alert("保存成功！");
		}else{
			  //更新信息到关联表中
		      RunMethod("BusinessManage","UpdateContractRecord",sSerialNo+","+sObjectType+","+sCustomerID+","+sCustomerType+","+sCustomerRole+","+sCustomerName+","+sCertType+","+sCertID+","+sBirthDay);
			  alert("更新成功！");
		}
	    //as_save("myiframe0");
	}
	
	
	//插入客户信息表中
	function InsertCustomer(){
		//判断当前客户是否存在
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sCertID = getItemValue(0,0,"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		var sCustomerType = getItemValue(0,0,"RelationStatus");
		var sCustomerID = getItemValue(0,0,"ObjectNo");
		var sBirthDay  = getItemValue(0,0,"BirthDay");
		var sCustomerRole = getItemValue(0,0,"CustomerRole");
		
		if(sCustomerName==""){
			alert("请输入客户名称");
			return false;
		}
		if(sCertType==""){
			alert("请选择证件类型");
			return false;
		}
		if(sCertID==""){
			alert("请输入证件号码");
			return false;
		}
		if(sCustomerType==""){
			alert("请选择客户申请类型");
			return false;
		}
		if(sBirthDay==""){
			alert("请输入出生日期");
			return false;
		}
		if(sCustomerRole==""){
			alert("请选择申请角色");
			return false;
		}
		var sStatus = "01";
		var sCustomerOrgType = sCustomerType;
		var sHaveCustomerType = sCustomerType;
		//获取客户ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sCertID);
		var returnValue = RunMethod("公用方法","GetColValue","Customer_Info,CustomerID,CustomerID='"+sCustomerID+"' ");
		if(sReturn == "Null" &&  returnValue=="Null"){
			var sParam = "";
            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;
// 			alert(sParam);
			sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
        }else{
        	//如果客户存在，则把原来的客户编号取出
        	setItemValue(0,0,"ObjectNo",sReturn);
        }
		//判断是否存在客户编号
		var returnValue = RunMethod("公用方法","GetColValue","Customer_Info,CustomerID,CustomerID='"+sCustomerID+"' ");
		if(typeof(returnValue)!="undefind"  && returnValue==sCustomerID ){
			var sPara = "String@CustomerName@"+sCustomerName+"@String@CertType@"+sCertType+"@String@CertID@"+sCertID+",Customer_Info,String@CustomerID@"+sCustomerID;
			RunMethod("PublicMethod","UpdateColValue",sPara);
		}
		return true;
	}
	
	//根据客户类型，填写证件信息
	function selectCustomerType(){
		
		sCustomerType = getItemValue(0,getRow(),"RelationStatus");

		if(sCustomerType=="03"){//个人客户
			//设置证件类型为身份证
			setItemValue(0,0,"CertType","Ind01");
		}else if(sCustomerType=="04"){//自雇、公司客户
			setItemValue(0,0,"CertType","Ent02");
		}else if(sCustomerType=="05"){
			setItemValue(0,0,"CertType","Ent02");
		}else{
			setItemValue(0,0,"CertType","");
		}
	}
	
	//身份证正则表达校验
	function isCardNo()
	{
		var card = getItemValue(0,getRow(),"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		
		//只对身份证做验证
		if(sCertType=="Ind01"){
			if(!CheckLicense(card)){
				alert("身份证输入不合法！");
				setItemValue(0,0,"CertID","");
			}else{
				setBirthDay();//根据身份证设置生日
			}
		}
	}
	
	
	function setBirthDay(){
		//1:校验证件类型为身份证或临时身份证时，出生日期是否同证件编号中的日期一致
		sCertType = getItemValue(0,getRow(),"CertType");//证件类型
		sCertID = getItemValue(0,getRow(),"CertID");//证件编号
		sBirthday = getItemValue(0,getRow(),"BirthDay");//出生日期
		if(sCertType == 'Ind01' || sCertType == 'Ind08'){
				//校身份证或临时身份证的长度
				if(sCertID.length !=18){
					alert(getBusinessMessage('250')); //证件号码长度有误！							
					return false;
				}
				//将身份证中的日期自动赋给出生日期,把身份证中的性别赋给性别
				if(sCertID.length == 15){
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					if(sSex%2==0)//奇男偶女
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18){
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					if(sSex%2==0)//奇男偶女
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
			setItemValue(0,getRow(),"BirthDay",sCertID); 
		}	
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/PretrialManageList2.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			//获取流水号
			var sSerialNo = getSerialNo("Customer_Info","CustomerID","");
			//将流水号置入对应字段
			setItemValue(0,0,"ObjectNo",sSerialNo);
			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	//bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
