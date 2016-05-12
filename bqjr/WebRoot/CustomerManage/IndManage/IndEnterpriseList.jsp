<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan
		       
		Tester:	
		Content: 客户信息列表
		Input Param:
			CustomerType：客户类型
				01：公司客户；
				0110：大型企业客户；
				0120：中小型企业客户；
				02：集团客户；
				0210：实体集团客户；
				0220：虚拟集团客户；
				03：个人客户
				0310：个人客户；
				0320：个体经营户；
            CustomerListTemplet：客户列表模板代码          
		以上参数统一由代码表:--MainMenu主菜单得到配置
		Output param:
		   CustomerID：客户编号
           CustomerType：客户类型		                				
           CustomerName：客户名称
           CertType：客户证件类型						                
           CertID：客户证件号码
		History Log: 
			DATE	CHANGER		CONTENT
			2005-07-20	fbkang	页面重整
			2005/09/10 zywei 重检代码
			2009/08/13 djia 整合AmarOTI --> queryCusomerInfo()
			2009/10/12 pwang 修改本页面的涉及客户类型判断的内容。
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户信息列表"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句	
	String sUserID = CurUser.getUserID(); //用户ID
	String sOrgID = CurOrg.getOrgID(); //机构ID
	
	//个人经营户显示模板
	String sTempletNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	//关联客户号，个人经营户客户号
	String sRelativeSerialno = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//个人经营户客户类型：默认为中小企业0120
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NoteType"));

	//将空值转化为空字符串
	if(sCustomerType == null) sCustomerType = "";
	if(sRelativeSerialno == null) sRelativeSerialno = "";
	if(sTempletNo == null) sTempletNo = "";
	//获得页面参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//增加过滤器	
    doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20);
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRelativeSerialno+","+sUserID+","+sCustomerType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sbCustomerType = sCustomerType.substring(0,2);
	
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件 
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"false","","Button","引入","引入已存在的客户","importCustomer()",sResourcesPath},
			};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		var sCustomerType="<%=sCustomerType%>";//客户类型
		var sCustomerID ='';									//客户ID
		var sReturn ='';											//返回值，客户的录入信息是否成功
		var sReturnStatus = '';								//客户信息检查结果
		var sStatus = '';											//客户信息检查状态		
		var sReturnValue = '';								//客户输入信息
		var sCustomerOrgType ='';							//客户类型性质
		
		sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=14;center:yes;status:no;statusbar:no");
		if(typeof(sReturnValue) == "undefined" || sReturnValue.length == 0 || sReturnValue == '_CANCEL_'){
			return;
		}
		sReturnValue = sReturnValue.split("@");
		//得到客户输入信息
		sCustomerOrgType = sReturnValue[0];
		sCustomerName = sReturnValue[1];
		sCertType = sReturnValue[2];
		sCertID = sReturnValue[3];
	
		//检查客户信息存在状态
		//参数格式：CustomerType,CustomerName,CertType,CertID,UserID
		sReturnStatus = RunMethod("CustomerManage","CheckCustomerAction",sCustomerType+","+sCustomerName+","+sCertType+","+sCertID+",<%=CurUser.getUserID()%>");
		//得到客户信息检查结果和客户号
		var sReturnStatus1 = sReturnStatus.split("@");
		//01 无该客户 
		//02 当前用户已与该客户建立关联 
		//04 当前用户没有与该客户建立关联,且没有和任何客户建立主办权 
		//05 当前用户没有与该客户建立关联,但和其他客户建立主办权 
		sStatus = sReturnStatus1[0];
		sCustomerID = sReturnStatus1[1];
		sHaveCustomerType = sReturnStatus1[2];
		//sHaveCustomerTypeName = sReturnStatus1[3];
		//sHaveStatus = sReturnStatus1[4];
		var realCustomerName = sReturnStatus1[5];
		

		
		//01为该客户不存在
		if(sStatus == "01"){				
			//生成客户号
			sCustomerID = getNewCustomerID();
			//参数说明CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			var sParam = (sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID)
			sParam += (","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
			//新增客户信息
			sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
			//已经新增客户
			if(sReturn == "1"){
				//更新CI表的Status字段为0(中小企业认定)
				RunMethod("CustomerManage","UpdateCustomerStatus",sCustomerID+",0");
				//建立关联
				RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
				alert(getBusinessMessage('109')); //新增客户成功
				openObject("Customer",sCustomerID,"001");
			}else{
				alert("新增客户出错");
				return;
			}
		//如果该客户存在本系统中  			
		}else if(sStatus == "02"){
			if(sHaveCustomerType != "0120"){  //增加仅引入中小企业判断 added by yzheng 2013-7-2
				alert("请重新选择客户,仅能引入中小企业.");
				return;
			}
			
			if(!confirm("当前用户已与该客户建立关联 ，确定引入客户【" + realCustomerName +"】吗？")){
				return;
			}		
			//建立关联
			RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
		}else if(sStatus == "04"){
			if(!confirm("当前用户没有与该客户建立关联,且没有和任何客户建立主办权 ，确定引入吗并获得其主办权吗？")){
				return;
			}				
			//参数说明CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			var sParam = (sCustomerID+",,,,")
			sParam += (","+sStatus+",,<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
			//新增客户信息
			RunMethod("CustomerManage","AddCustomerAction",sParam);
			//建立关联
			RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
		}else if(sStatus == "05"){
			if(!confirm("当前用户没有与该客户建立关联,但和其他客户建立主办权，确定引入吗？")){
				return;
			}
			//参数说明CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			var sParam = (sCustomerID+",,,,")
			sParam += (","+sStatus+",,<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
			//新增客户信息
			RunMethod("CustomerManage","AddCustomerAction",sParam);
			//建立关联
			RunMethod("CustomerManage","InsertSmeCustRela",sCustomerID+",<%=sRelativeSerialno%>");
		}
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			sReturn = RunMethod("CustomerManage","DelIndEntRela",sCustomerID+","+"<%=CurUser.getUserID()%>");
			if(sReturn == "1"){
				alert("该客户删除成功！");
				reloadSelf();
			}else{
				alert("该客户删除失败！");
				return;
			}
		}
	}


	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}		
		var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        	return;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];                        
        if(sReturnValue1 == "Y"){
    		openObject("Customer",sCustomerID,"001");           
    		reloadSelf();
		}else{
		    alert(getBusinessMessage('115'));//对不起，你没有查看该客户的权限！
		}
	}

	/*~[Describe=引入;InputParam=无;OutPutParam=无;]~*/
	function importCustomer(){
		sReturnValue = PopPage("/CustomerManage/IndManage/ImportIndEntpriseDialog.jsp","","resizable=yes;dialogWidth=25;dialogHeight=14;center:yes;status:no;statusbar:no");
		if(typeof(sReturnValue) == "undefined" || sReturnValue.length == 0 || sReturnValue == "_CANCEL_"){
			return;
		}
		var sReturn = sReturnValue.split("@");
		var sCustomerName = sReturn[0];
		var sCertType = sReturn[1];
		var sCertID = sReturn[2];
		var sRelativeSerialno = "<%=sRelativeSerialno%>";
		var sValue = PopPageAjax("/CustomerManage/IndManage/ImportIndEntpriseActionAjax.jsp?CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID+"&RelativeSerialNo="+sRelativeSerialno,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sValue) == "undefined" || sValue.length == 0){
			alert("引入个人经营户企业失败！");
			return;
		}
		if(sValue=="01"){
			alert("该客户不存在，请检查输入的证件类型与证件号码是否正确！");
			return;
		}
		if(sValue=="02"){
			alert("该客户不是中小企业类型，请把转变企业类型后再引入！");
			return;
		}
		if(sValue=="04"){
			alert("该客户已存在列表中，请勿重复引入！");
			return;
		}
		if(sValue=="06"){
			alert("该中小企业客户未通过认定，请检查！");
			return;
		}
		if(sValue=="07"){
			alert("您没有该客户的主办权，不能引入！");
			return;
		}
		if(sValue=="10"){
			alert("该客户存在未终结的合同信息，不能引入！");
			return;
		}
		if(sValue=="11"){
			alert("该客户存在未完成的最终审批意见信息，不能引入！");
			return;
		}
		if(sValue=="12"){
			alert("该客户存在未完成的业务申请信息，不能引入！");
			return;
		}
		if(sValue=="09"){
			alert("引入个人经营户企业成功！");
			reloadSelf();
		}
	}

	/**
	 *生成新客户号
	 */
	function getNewCustomerID(){
		var sTableName = "CUSTOMER_INFO";//表名
		var sColumnName = "CustomerID";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		return sSerialNo;
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();	
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>