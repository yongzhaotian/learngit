<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = " 协审信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
     //定义变量
      String sSql = "";//--存放sql语句
      String sTempSaveFlag="";//暂存标志
      ASResultSet rs = null;//-- 存放结果集
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sRightType==null) sRightType="";
	
	//取得暂存标志
		sSql = "select TempSaveFlag from AssistInvestigate where ObjectNo=:ObjectNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
		if(rs.next()){
			sTempSaveFlag = rs.getString("TempSaveFlag");
		}
//		rs.getStatement().close();
		if(sTempSaveFlag == null) sTempSaveFlag = ""; 
		
		
		rs.getStatement().close(); 
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		 				
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AssistInvestigateInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	
	//设置当陪同人为0是非必输项
	String sCompanyWith="";
	String sCheckPartner="";
	sSql = "select companyWith,checkPartner from AssistInvestigate where ObjectNo=:ObjectNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
	if(rs.next()){
		sCompanyWith = rs.getString("companyWith");
		sCheckPartner = rs.getString("checkPartner");
	}
	
	if(sCompanyWith == null) sCompanyWith = ""; 
	if(sCheckPartner == null) sCheckPartner = ""; 
	
	if(sCheckPartner.equals("2")){
		doTemp.setRequired("PartnerName",false);
		doTemp.setRequired("PartnerPhone",false);
	}

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Grid风格
	dwTemp.ReadOnly = "0"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
		{"false","All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath}
	};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
		if(sTempSaveFlag.equals("2"))
			sButtons[1][0] = "false";
		if ("ReadOnly".equals(sRightType))  {
			sButtons[0][0] = "false";
			sButtons[1][0] = "false";
		}

	//只要客户经理没有主办权,就不能修改本页面。
	/* String sRight = Sqlca.getString(new SqlObject(" select BelongAttribute2 from CUSTOMER_BELONG where CustomerID = :CustomerID and UserID = :UserID ").setParameter("CustomerID",sCustomerID).setParameter("UserID",CurUser.getUserID()));
	if(sRight != null && !sRight.equals("1")){
	 	sButtons[0][0] = "false";
	 	sButtons[1][0] = "false";
	} */
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
	function saveRecord(sPostEvents){
		setItemValue(0,0,"TempSaveFlag","2");
		as_save("myiframe0",sPostEvents);
		setRequired();
	}
	function setRequired(){
		var sCompanyWith=getItemValue(0,0,"companyWith");
		var sCheckPartner=getItemValue(0,0,"checkPartner");
		if(sCheckPartner=="2"){
			setItemRequired(0,0,"PartnerName",false);
			setItemRequired(0,0,"PartnerPhone",false);
		}else{
			setItemRequired(0,0,"PartnerName",true);
			setItemRequired(0,0,"PartnerPhone",true);
		}
	}
		
	function saveRecordTemp(){
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,0,"TempSaveFlag","1");//暂存标志（1：是；2：否）
		as_save("myiframe0");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来	
	}
    
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow()
	{
		 var sRightType="ReadOnly";
		 if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			 //只要不是只读，就可以新增记录
			// if(sRightType!="ReadOnly"){
			   as_add("myiframe0");//新增记录
			 //}
			beforeInsert();
			
		} 
		setItemValue(0,0,"Objectno","<%=sObjectNo%>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getTodayNow()%>");
    } 
	 function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
	} 
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sSerialNo = getSerialNo("AssistInvestigate","serialNo");
		setItemValue(0,0,"Serialno",sSerialNo);
	} 
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=有无陪同人员;InputParam=无;OutPutParam=无;]~*/
	function checkPartnerNo(obj){
		var sCompanyWith=getItemValue(0,0,"companyWith");
		//如果陪同人员为零
		if(sCompanyWith=="0"){
			setItemValue(0,0,"checkPartner","2");
			setItemRequired(0,0,"PartnerName",false);
			setItemRequired(0,0,"PartnerPhone",false);
			return;
		}
		setItemValue(0,0,"checkPartner","1");
		setItemRequired(0,0,"PartnerName",true);
		setItemRequired(0,0,"PartnerPhone",true);
	}
	/*~[Describe=陪同人员是否有申请;InputParam=无;OutPutParam=无;]~*/
	function checkPartner(obj){
		var sCompanyWith=getItemValue(0,0,"companyWith");
		if(sCompanyWith=="0"){
			setItemValue(0,0,"checkPartner","2");
		}
		var sCheckPartner=getItemValue(0,0,"checkPartner");
		if(sCheckPartner=="1"){
			setItemRequired(0,0,"PartnerName",true);
			setItemRequired(0,0,"PartnerPhone",true);
		}
		if(sCheckPartner=="2"){
			setItemRequired(0,0,"PartnerName",false);
			setItemRequired(0,0,"PartnerPhone",false);
		}
	}
	/*~[Describe=陪同人员手机号的校验;InputParam=无;OutPutParam=无;]~*/
	function checkPartnerPhone(obj){
		var sPartnerPhone=getItemValue(0,0,"PartnerPhone");
		if(typeof(sPartnerPhone) == "undefined" || sPartnerPhone.length==0){     
	    	return false;
	    }
		if(!(/^\d+$/.test(sPartnerPhone))){
			alert("手机号只能是数字");
			obj.focus();
			return false;
		}
	}
	
	/*~[Describe=姓名输入验证;InputParam=无;OutPutParam=无;]~*/
	function checkName(obj){
		var sName=obj.value;
		if(typeof(sName) == "undefined" || sName.length==0 ){
			return false;
		}else{
			
		if(/\s+/.test(sName)){
			alert("姓名含有空格，请重新输入");
			obj.focus();
			return false;
		}
		//姓名必须是中文或者字母
		if(!(/^[\u4e00-\u9fa5]{2,7}$|^[a-zA-Z]{1,30}$/.test(sName))){
			   // if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)·([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("姓名输入非法");
				obj.focus();
				return false;
			    //}
			}
		 }
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
	<script type="text/javascript">	
		AsOne.AsInit();
		init();
		bFreeFormMultiCol=true;
		my_load(2,0,'myiframe0');
		initRow(); //页面装载时，对DW当前记录进行初始化
	</script>	
	<%/*~END~*/%>
<%@	include file="/IncludeEnd.jsp"%>