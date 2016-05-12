<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 代扣账户变更完成查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "代扣账户变更完成查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;代扣账户变更完成查询&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";

	String sCustomerID = Sqlca.getString(new SqlObject("SELECT CustomerID FROM  business_contract   where serialno='"+sObjectNo+"' "));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	



			String sHeaders[][] = {	{"SerialNo","变更流水号"},
									{"ContractSerialNo","合同编号"},
									{"CustomerID","客户号"},
									{"CustomerName","客户名称"},
									{"CertID","身份证号"},
									{"TelPhone","手机号码"},
									{"OldAccountName","原代扣账户户名"},
									{"NewAccountName","新代扣账户户名"},
									{"OldAccount","原代扣账户账号"},
									{"NewAccount","新代扣账户账号"},
									{"OldBankName","原代扣账户开户行"},
									{"NewBankName","新代扣账户开户行"},
									{"InputDate","录入日期"},
									{"UpdateUserName","更新用户"},
									{"UpdateOrgName","更新机构"},
									{"UpdateDate","更新日期"},
									{"StatusName","处理状态"}
			                       }; 
			
			
			String sSql = " select wci.SerialNo as SerialNo,wci.ContractSerialNo as ContractSerialNo,wci.CustomerID as CustomerID,wci.CustomerName as CustomerName,wci.CertID as CertID,wci.TelPhone as TelPhone,"+
						  " wci.OldAccountName as OldAccountName,wci.NewAccountName as NewAccountName,wci.OldAccount as OldAccount,wci.NewAccount as NewAccount,getitemname('BankCode',wci.OldBankName) as OldBankName,"+
					      " getitemname('BankCode',wci.NewBankName) as NewBankName, "+
						  " wci.InputDate as InputDate,getUserName(wci.UpdateUserID) as UpdateUserName,getOrgName(wci.UpdateOrgID) as UpdateOrgName,wci.UpdateDate as UpdateDate,getItemName('Status',wci.Status) as StatusName "+
						  " from WITHHOLD_CHARGE_INFO wci,BUSINESS_CONTRACT BC where wci.Customerid = BC.Customerid and wci.contractserialno = bc.serialno "+
						  " and BC.customerid = '"+sCustomerID+"'";

			//由SQL语句生成窗体对象。
			ASDataObject doTemp = new ASDataObject(sSql);
			doTemp.setHeader(sHeaders);
			doTemp.UpdateTable = "WITHHOLD_CHARGE_INFO";
			doTemp.setKey("SerialNo",true);	 //为后面的删除
			//设置不可见项
			doTemp.setVisible("ContractSerialNo",false);
			//doTemp.setUpdateable("UserName,OrgName",false);
			//doTemp.setHTMLStyle("InterSerialNo,AboutBankID,UserName"," style={width:80px} ");
			//doTemp.setType("BillSum","number");
			//doTemp.setAlign("BillSum","3");
			
			//生成datawindow
			ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
			dwTemp.Style="1";      //设置为Grid风格
			dwTemp.ReadOnly = "1"; //设置为只读
			
			Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},

	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		 sCompID = "ChargeApplyInfo1";
		sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo1.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	}
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sExchangeType = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//检查出帐通知单是否已经生成
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //未生成出帐通知单
			//生成出帐通知单	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//获得加密后的出帐流水号
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
		
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
