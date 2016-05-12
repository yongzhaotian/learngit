<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "客户联系方式修改";
	//获得页面参数：
	String sCustomerID        = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
	System.out.println("-----"+sCustomerID);

	if(sCustomerID==null)        sCustomerID="";

	
	// 通过DW模型产生ASDataObject对象doTemp	
	String sTempletNo = "UpdateCustomerInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath}
	};
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------

	function saveRecord()
	{
	  if(!ValidityCheck()) return;
	  as_save("myiframe0");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		//3.电子邮箱
		var filter=/^\s*([A-Za-z0-9_-]+(\.\w+)*@(\w+\.)+\w{2,3})\s*$/;
		sEmailAdd = getItemValue(0,getRow(),"EmailAdd");
		
		if(!filter.test(sEmailAdd) && (sEmailAdd && sEmailAdd.trim().length>0)){
			alert("邮箱不正确请重新填写!");
			return false;
		}
		
		//2.QQ号码
		sQqNo = getItemValue(0,getRow(),"QQNo");//QQ
		if(isNaN(sQqNo)==true){
			alert("QQ号码必须是数字!");
			return false;
		}

		return true;
	}
	
	/*~[Describe=其他联系人号码选择;InputParam=无;OutPutParam=无;]~*/
	function getOtherlinkTelPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		if (sPhoneType=='01' || sPhoneType=='固定电话' || sPhoneType=='03' || sPhoneType=='工作电话') {// 电话
			sPhoneCode = sZipCode + '-' + sPhoneCode;
			sPhoneCode = (sExtensionNo.length>0)?(sPhoneCode+'-'+sExtensionNo):sPhoneCode;
		}else if (sPhoneType=='02' || sPhoneType=='移动电话' || sPhoneType=='05' || sPhoneType=='单位移动电话' || sPhoneType=='06' || sPhoneType=='家庭移动电话') {//移动电话
			
		}else if (sPhoneType=='04' || sPhoneType=='其他信息') {// 其他信息
			sPhoneCode='';
		}
		setItemValue(0,0,"ContactTel",sPhoneCode);//手机号码
		
	}
	
	/*~[Describe=手机号码选择;InputParam=无;OutPutParam=无;]~*/
	function getTelPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		setItemValue(0,0,"MobileTelephone",sPhoneCode);//手机号码
		
	}
	
	/*~[Describe=住宅电话选择;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		sFamilyTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FamilyTel",sFamilyTel);//住宅电话
		
	}
	
	/*~[Describe=工作电话选择;InputParam=无;OutPutParam=无;]~*/
	function getWorkPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"WorkTel",sWorkTel);//工作电话

	}
	
	/*~[Describe=传真号码;InputParam=无;OutPutParam=无;]~*/
	function getFaxNumber()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		sWorkTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FaxNumber",sWorkTel);//传真号码

	}
	
	/*~[Describe=户籍地址选择;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"NativePlace",sAddress);//地址ID
		setItemValue(0,0,"NativePlaceName",sAddressName);//地址NAME
		setItemValue(0,0,"Villagetown",sTownShip);//乡/镇
		setItemValue(0,0,"Street",sStreet);//街道/村
		setItemValue(0,0,"Community",sCell);//小区/楼盘
		setItemValue(0,0,"CellNo",sRoom);//栋/单元/房间号
	}
	
	/*~[Describe=现居地址选择;InputParam=无;OutPutParam=无;]~*/
	function getAddCode(){
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"FamilyAdd",sAddress);//现居住地址
		setItemValue(0,0,"FamilyAddName",sAddressName);
		setItemValue(0,0,"Countryside",sTownShip);//乡/镇(现居)
		setItemValue(0,0,"Villagecenter",sStreet);//街道/村（现居）
		setItemValue(0,0,"Plot",sCell);//小区/楼盘（现居）
		setItemValue(0,0,"Room",sRoom);//栋/单元/房间号（现居）
		
	}
	
	/*~[Describe=单位地址选择;InputParam=无;OutPutParam=无;]~*/
	function getCellRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"WorkAdd",sAddress);//地址ID
		setItemValue(0,0,"WorkAddName",sAddressName);//地址NAME
		setItemValue(0,0,"UnitCountryside",sTownShip);//乡/镇
		setItemValue(0,0,"UnitStreet",sStreet);//街道/村
		setItemValue(0,0,"UnitRoom",sCell);//小区/楼盘
		setItemValue(0,0,"UnitNo",sRoom);//栋/单元/房间号
	}	
	

	
	function initRow()
	{	
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			
            //登记人信息
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }

	</script>

<script language=javascript>	
	AsOne.AsInit();
	showFilterArea();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
