
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 
		Input Param:
			
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "电话详情信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sTempletNo = "AddPhoneInfo";
	//获得组件参数，客户代码
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
	System.out.println("--------aaaaa-----------"+sSerialNo);
	System.out.println("--------bbbbb-----------"+sCustomerID);
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//定义变量：查询结果集
	ASResultSet rs = null;
	String sSql = "",sCustomerName="";
	
    sSql=" select customername from ind_info where customerid=:CustomerID ";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
    if(rs.next()){
   	   sCustomerName = DataConvert.toString(rs.getString("customername"));//客户姓名
   	 
		//将空值转化成空字符串
		if(sCustomerName == null) sCustomerName = "";
    }
    rs.getStatement().close();
	
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly="0";

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
			{"false","","Button","确定","确定","doCreation()",sResourcesPath},

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
		if(!ValidityCheck()) return;
		doCreation();//确定
		as_save("myiframe0");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		 //区号
		sZipCode = getItemValue(0,getRow(),"ZipCode");
		//电话号码
		sPhoneCode = getItemValue(0,getRow(),"PhoneCode");
		//分机号
		sExtensionNo = getItemValue(0,getRow(),"ExtensionNo");
		
		if(sPhoneType=="02"||sPhoneType=="05"||sPhoneType=="06"){
			var reg1=/^\d{11}$/;
			var sSub1=sPhoneCode.substring(0,1);//截取手机号的第一个字符
			if(isNaN(sPhoneCode)==true){
				alert("手机号码必须是数字!");
				return false;
			}
			if(sPhoneCode!=""&&(sSub1!='1'||reg1.test(sPhoneCode)==false)){
				alert("手机号码格式填写错误!");
				return false;
			}
			
		}else if(sPhoneType=="01"||sPhoneType=="03"){
			//固定电话区号的校验
			var sSub=sZipCode.substring(0,1);//截取区号的第一个字符
			
			var reg=/^\d{3,4}$/;
			if(isNaN(sZipCode)==true){//区号
				alert("区号必须是数字!");
				return false;
			}
			if(sZipCode!=""&&(sSub!='0'||reg.test(sZipCode)==false)){
				alert("区号填写错误!");
				return false;
			}
			//固定电话号码的校验
			reg=/^\d{7,8}$/;
			if(isNaN(sPhoneCode)==true){
				alert("电话号码必须是数字!");
				return false;
			}
			if((sPhoneCode!="")&&reg.test(sPhoneCode)==false){
				alert("固定电话号码填写错误!");
				return false;
			}
			//分机号的校验
			reg=/^\d{1,8}$/;
			if(isNaN(sExtensionNo)==true){
				alert("分机号必须是数字!");
				return false;
			}
			if((sExtensionNo!="")&&reg.test(sExtensionNo)==false){
				alert("分机号码填写错误!");
				return false;
			}
			
		}else{
			return true;
		}
		return true;
	} 
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/AddPhoneList.jsp","_self","");
	}
	
	function doCreation()
	{
      doReturn();
	}
	
	/*~[Describe=确认;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sZipCode     = getItemValue(0,getRow(),"ZipCode");//区号
		sPhoneCode   = getItemValue(0,getRow(),"PhoneCode");//电话号码
		sExtensionNo    = getItemValue(0,getRow(),"ExtensionNo");//分机号码
		sPhoneType    = getItemValue(0,getRow(),"PhoneType");//电话类型

		//alert("-----"+sZipCode+"--------"+sPhoneCode+"-----"+sExtensionNo);
		top.returnValue = sZipCode+"@"+sPhoneCode+"@"+sExtensionNo+"@"+sPhoneType;
		//top.close();
	}
	
	/*~[Describe=电话类型;InputParam=无;OutPutParam=无;]~*/
	function selectPhone(){
		sPhoneType = getItemValue(0,getRow(),"PhoneType");
		
		if(sPhoneType=="01"){//固定电话
			setItemValue(0,0,"ZipCode","");
			showItem(0, 0, "ZipCode");//显示
			showItem(0, 0, "PhoneCode");//显示
			showItem(0, 0, "ExtensionNo");//显示
			showItem(0, 0, "Owner");//显示
			setItemRequired(0,0,"ZipCode",true);
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"PhoneCode",true);
			setItemDisabled(0,0, "ZipCode",false);
		}
		if(sPhoneType=="02"){//移动电话
			setItemValue(0,0,"ZipCode","+86");
			showItem(0, 0, "ZipCode");//显示
			showItem(0, 0, "PhoneCode");//显示
			hideItem(0, 0, "ExtensionNo");//隐藏
			showItem(0, 0, "Owner");//显示
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"PhoneCode",true);
			setItemRequired(0,0,"Annotation",false);
			//setItemReadOnly(0,0,"ZipCode",true);//灰化处理
			setItemDisabled(0,0, "ZipCode",true);
		}
		if(sPhoneType=="03"){//工作电话
			setItemValue(0,0,"ZipCode","");
			showItem(0, 0, "ZipCode");//显示
			showItem(0, 0, "PhoneCode");//显示
			showItem(0, 0, "ExtensionNo");//显示
			showItem(0, 0, "Owner");//显示
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"ZipCode",true);
			setItemRequired(0,0,"PhoneCode",true);
			setItemDisabled(0,0, "ZipCode",false);
		}
		if(sPhoneType=="04"){//其他信息
			hideItem(0, 0, "ZipCode");//隐藏
			hideItem(0, 0, "PhoneCode");//隐藏
			hideItem(0, 0, "ExtensionNo");//隐藏
			hideItem(0, 0, "Owner");//隐藏
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"Annotation",true);
			setItemDisabled(0,0, "ZipCode",false);
		}
		if(sPhoneType=="05"){//单位移动电话
			setItemValue(0,0,"ZipCode","+86");
			showItem(0, 0, "ZipCode");//显示
			showItem(0, 0, "PhoneCode");//显示
			hideItem(0, 0, "ExtensionNo");//隐藏
			showItem(0, 0, "Owner");//显示
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"PhoneCode",true);
			//setItemReadOnly(0,0,"ZipCode",true);
			setItemDisabled(0,0, "ZipCode",true);
		}
		if(sPhoneType=="06"){//家庭移动电话
			setItemValue(0,0,"ZipCode","+86");
			showItem(0, 0, "ZipCode");//显示
			showItem(0, 0, "PhoneCode");//显示
			hideItem(0, 0, "ExtensionNo");//隐藏
			showItem(0, 0, "Owner");//显示
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"PhoneCode",true);
			//setItemReadOnly(0,0,"ZipCode",true);
			setItemDisabled(0,0, "ZipCode",true);
		}
		if(sPhoneType==""){
			showItem(0, 0, "ZipCode");//显示
			showItem(0, 0, "PhoneCode");//显示
			showItem(0, 0, "ExtensionNo");//显示
			showItem(0, 0, "Owner");//显示
			
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"PhoneCode",false);
			setItemRequired(0,0,"ExtensionNo",false);
			setItemRequired(0,0,"Owner",false);
			
			setItemValue(0,0,"ZipCode","");
		}
	}
	
	/*~[Describe=客户关系;InputParam=无;OutPutParam=无;]~*/
	function selectRelative(){
		sRelation = getItemValue(0,getRow(),"Relation");
		
		if(sRelation=="010"){//本人
			setItemValue(0,0,"Owner","<%=sCustomerName%>");
		}else{
			setItemValue(0,0,"Owner","");
		}
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
			initSerialNo();
			//设置客户ID号
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var sTableName = "Phone_Info";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);*/
		var sSerialNo = '<%=DBKeyUtils.getSerialNo("PI")%>';
		/** --end --*/
		
		//将流水号置入对应字段
		setItemValue(0,getRow(),"SerialNo",sSerialNo);
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