<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: 变更客户信息
		Input Param:
		Output Param:
		HistoryLog: fbkang on 2005/08/14 
		HistoryLog: fwang on 2009/06/15 删掉必输项，判断4个修改项是否全为空，全为空不能保存
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%	
	String PG_TITLE = "变更客户信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得变量：客户编号
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//定义变量：sql语句
	String sSql = "";			 
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//根据客户编号获取客户类型
	String sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";
	
		// 通过DW模型产生ASDataObject对象doTemp
		String sTempletNo = "ChangeCustomerInfo";//模型编号
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//传入参数,逗号分割
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		   {"true","","Button","保存","保存变更客户信息","saveRecord()",sResourcesPath},
		   {"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//定义一个流水号的变量
	var sSerialNo;
	//---------------------定义按钮事件------------------------------------	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		sCustomerType = "<%=sCustomerType%>";
		//获取变更后的客户名称、证件类型、证件编号、贷款卡编号
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sNewCustomerName = getItemValue(0,getRow(),"NewCustomerName");
		sNewCertType = getItemValue(0,getRow(),"NewCertType");
		sNewCertID = getItemValue(0,getRow(),"NewCertID");
		sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");
		if(sCustomerType == '03') //个人
		{		
			if (!(typeof(sNewCustomerName) == "undefined" || sNewCustomerName != "" 
			|| typeof(sNewCertType) == "undefined" || sNewCertType != "" 
			|| typeof(sNewCertID) == "undefined" || sNewCertID != ""))
			{
				alert(getBusinessMessage('923'));//请输入需变更的客户信息！
				return;
			}
		}else
		{
			if (!(typeof(sNewCustomerName) == "undefined" || sNewCustomerName != ""
			|| typeof(sNewCertType) == "undefined" || sNewCertType != ""
			|| typeof(sNewCertID) == "undefined" || sNewCertID != ""
			|| typeof(sNewLoanCardNo) == "undefined" || sNewLoanCardNo != ""))
			{
				alert(getBusinessMessage('923'));//请输入需变更的客户信息！
				return;
			}
		}
		//录入数据有效性检查
		if (!ValidityCheck()) return;
	
		initSerialNo();//初始化流水号字段
		
		//变更客户信息
		sCustomerID =sCustomerID + "@" + "<%=CurUser.getUserID()%>"+ "@" + "<%=CurUser.getOrgID()%>"+ "@" + "<%=StringFunction.getToday()%>"+"@"+sSerialNo;	
		sReturnValue = RunMethod("CustomerManage","UpdateCustomerInfo",sCustomerID+","+sNewCustomerName+","+sNewCertType+","+sNewCertID+","+sNewLoanCardNo);
	    /* if(typeof(sReturnValue) != "undefined" && sReturnValue != "") 
		{
			alert(getBusinessMessage('924'));//变更客户信息成功!
			return;
		}else
		{
			alert(getBusinessMessage('925'));//变更客户信息失败!
			return;
		} */
		as_save("myiframe0","");;
	}	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ChangeCustomerList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		if(sCustomerType == '0110' || sCustomerType == '0120') //公司客户
		{		
			//检查组织机构代码证的有效性	
			sNewCertType = getItemValue(0,getRow(),"NewCertType");
			sNewCertID = getItemValue(0,getRow(),"NewCertID");
			
			//检查贷款卡号的有效性
			sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");			
			if(typeof(sNewLoanCardNo) != "undefined" && sNewLoanCardNo != "" )
			{
				
				//检验贷款卡编号唯一性
				sCustomerID = getItemValue(0,getRow(),"CustomerID");
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sNewLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('227'));//该贷款卡编号已被其他客户占用！							
					return false;
				}						
			}						
		}
				
	
		return true;	
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_INFO_CHANGE ";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
