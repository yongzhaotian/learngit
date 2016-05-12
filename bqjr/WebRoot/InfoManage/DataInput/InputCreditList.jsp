<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 信贷数据补登列表;
		Input Param:
					DataInputType：010需补登信贷业务
									020补登完成信贷业务
		Output Param:
			
		HistoryLog:
			     pwang 2009-10-19      增加垫款补登功能
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信贷数据补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	
	String sClauseWhere="";
	//获得页面参数
	
	//获得组件参数
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";

	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
 String sTempletNo="InputCreditList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(sReinforceFlag.equals("010") || sReinforceFlag.equals("110"))  //待补登或新增的业务
	{	
		doTemp.WhereClause += " and ManageOrgID ='"+CurOrg.getOrgID()+"' and (DeleteFlag ='' or DeleteFlag =' ' or  DeleteFlag is null)";
	}
	
	if(sReinforceFlag.equals("020") || sReinforceFlag.equals("120"))  //补登或新增完成的业务
	{
		doTemp.WhereClause += " and ManageOrgID ='"+CurOrg.getOrgID()+"' and (DeleteFlag ='' or DeleteFlag =' ' or  DeleteFlag is null)";
	}
	
	doTemp.OrderClause +=" order by CustomerID,PutOutDate";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

	Vector vTemp = dwTemp.genHTMLDataWindow(sReinforceFlag);
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
				{"true","","Button","补登客户","补登客户信息","InputCustomerInfo()",sResourcesPath},
				{"true","","Button","补登业务","补登业务信息","InputBusinessInfo()",sResourcesPath},
				{"true","","Button","新增额度","新增额度","NewContract()",sResourcesPath},
				{"true","","Button","额度详情","额度详情","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","删除额度","删除额度","DeleteContract()",sResourcesPath},
				{"true","","Button","补登客户信息","补登客户信息","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","补登完成","补登完成","Finished()",sResourcesPath},
				{"true","","Button","客户详情","客户详情","CustomerInfo()",sResourcesPath},
				{"true","","Button","业务详情","业务详情","BusinessInfo()",sResourcesPath},
				{"true","","Button","再次补登","再次补登","secondFinished()",sResourcesPath},
				{"false","","Button","改变业务品种","改变业务品种","changeBusinessType()",sResourcesPath},
				{"true","","Button","客户规模转换","客户规模转换","changeCustomerType()",sResourcesPath},
				{"true","","Button","合同合并","合同合并","UniteContract()",sResourcesPath},
				{"false","","Button","新增合同","新增合同","NewContract()",sResourcesPath},
				{"false","","Button","删除合同","删除合同","DeleteContract()",sResourcesPath},
				{"true","","Button","垫款关联原表外业务","垫款关联原表外业务","RelativeBusiness()",sResourcesPath},
				
			};
	String sButtons2[][] = {
				{"true","","Button","垫款关联原表外业务","垫款关联原表外业务","RelativeBusiness()",sResourcesPath},
				{"true","","Button","终结信息登记","终结信息登记","Account()",sResourcesPath},
				{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}
			};
	
	//需补登信贷业务
	if(sReinforceFlag.equals("010")) 
	{
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons2[0][0] = "true";
	}
	
	//补登完成信贷业务
	if(sReinforceFlag.equals("020")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";		
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";
		sButtons2[0][0] = "false";
		
	}
	
	//新增额度
	if(sReinforceFlag.equals("110")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";		
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";
		sButtons2[0][0] = "false";
		
	}
	
	//补登完成额度
	if(sReinforceFlag.equals("120")) 
	{		
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";		
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";
		sButtons2[0][0] = "false";
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function DeleteContract()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
				
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{			
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句			
		}
	}
	
	/*~[Describe=客户详情;InputParam=无;OutPutParam=无;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sReturn = PopPageAjax("/InfoManage/DataInput/CustomerQueryActionAjax.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("要查询的客户信息不存在！");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("要查询的客户类型为空，请选择客户类型！");
			}
			
			openObject("ReinforceCustomer",sCustomerID,"002");
		}
	}

	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(sReinforceFlag=="110") 
			{
				openObject("AfterLoan",sSerialNo,"000");
			}
			else
			{
				openObject("AfterLoan",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=额度合同详情;InputParam=无;OutPutParam=无;]~*/
	function CreditBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(sReinforceFlag=="110") 
			{
				openObject("ReinforceContract",sSerialNo,"000");
			}else
			{
				openObject("ReinforceContract",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=补登客户信息;InputParam=无;OutPutParam=无;]~*/
	function InputCustomerInfo()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sReturn = PopPageAjax("/InfoManage/DataInput/CustomerQueryActionAjax.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("要补登的客户信息不存在！");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("要补登的客户类型为空，请选择客户类型！");
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
				if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
				sCustomerType = sReturn;
				sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputCustomerActionAjax.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			}
			openObject("ReinforceCustomer",sCustomerID,"000");
		}
	}

	/*~[Describe=补登业务信息;InputParam=无;OutPutParam=无;]~*/
	function InputBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{				
				sReturn=setObjectValue("SelectBusinessType","","",0,0,"");				
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];									
					sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputContractActionAjax.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				}else if (sReturn=='_CLEAR_')
				{
					return;
				}else 
				{
					return;
				}
			}
			
			openObject("ReinforceContract",sSerialNo,"001");
			reloadSelf();
		}
	}

	/*~[Describe=改变客户类型;InputParam=无;OutPutParam=无;]~*/
	function changeCustomerType()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sReturn=PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=350px;dialogHeight=110px;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
			if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
			sCustomerType = sReturn;
			sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputCustomerActionAjax.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			reloadSelf();
		}
	}

	/*~[Describe=改变业务品种;InputParam=无;OutPutParam=无;]~*/
	function changeBusinessType()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{			
			sReturn=setObjectValue("SelectBusinessType","","",0,0,"");
			if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
			{
				sss1 = sReturn.split("@");
				sBusinessType=sss1[0];
				sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputContractActionAjax.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				reloadSelf();				
			}else if (sReturn=='_CLEAR_')
			{
				return;
			}else 
			{
				return;
			}
		
		}
	}

	/*~[Describe=新增合同;InputParam=无;OutPutParam=无;]~*/
	function NewContract()
	{		
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
				
		if(sReinforceFlag=="010")
		{  
			//新增合同进入
			var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G");
		}else
		{
			//新增额度进入
			var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag);
		}
		
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sss = sReturn.split("@");
		sSerialNo=sss[0];

		openObject("ReinforceContract",sSerialNo,"000");
		reloadSelf();		
	}

	/*~[Describe=置完成补登标志;InputParam=无;OutPutParam=无;]~*/
	function Finished()
	{
		//合同流水号、客户编号、业务品种
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		//表示补登进入列表
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm("真的要补登完成吗？")) 
		{						
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				alert("业务品种为空，请先补登业务品种！");
				return;
			}else
			{	
				var sExistFlag = PopPageAjax("/InfoManage/DataInput/ReinforceCheckActionAjax.jsp?ContractNo="+sSerialNo+"&CustomerID="+sCustomerID,"","");
				
				if(sExistFlag!="true")
				{
					alert(sExistFlag);
					return;
				}else
				{					
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag,"","");
					if(sReturn == "succeed")
					{
						if(sReinforceFlag == "010")
						{
							alert("补登完成，该业务已转到补登完成信贷业务列表!");
						}else
						{
							alert("补登完成，该业务已转到补登完成额度列表!");
						}
						
					}
					reloadSelf();	
				}
			}
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=再次补登;InputParam=无;OutPutParam=无;]~*/
	function secondFinished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm("真的要再次补登吗？")) 
		{
			sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag1=SecondFlag","","");
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				if(sReinforceFlag == "020")
				{
					alert("再次补登，所选数据将回到需补登业务列表!");
				}else
				{
					alert("再次补登，所选数据将回到新增额度列表!");
				}
			}
			
			if(sReturn == "false")
			{
				alert("所选资产已经分发,不能再次补登!");
			}
			reloadSelf();		
		}
	}


	/*~[Describe=合并合同;InputParam=无;OutPutParam=无;]~*/
	function UniteContract()
	{
		//合同流水号、客户编号、合同编号
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{			
			 var sReturn = popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&ArtificialNo="+sArtificialNo+"&CustomerID="+sCustomerID,"dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
			 }	
		}
	}

	/*~[Describe=已合并合同查询;InputParam=无;OutPutParam=无;]~*/
	function QueryContract()
	{
		//合同流水号、客户编号、合同编号
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{			
			 popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=QueryContract","_self","dialogWidth=100;dialogHeight=20;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		}
	}

	function RelativeBusiness()
	{
		//合同流水号、客户编号、合同编号
		var sBCSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var OriBDSerialNo ;
		var sRelativeContractNo;
		var sReturn ;
		var sParaString;
		
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			if (sBusinessType == '1130010' || sBusinessType == '1130020' || sBusinessType == '1130030' || sBusinessType == '1130040' || sBusinessType == '1130050')
			{
				sParaString = "CustomerID"+","+sCustomerID;
				sRelativeContractNo=setObjectValue("SelectOriDuebill",sParaString,"",0,0,"");				
				
				if(typeof(sRelativeContractNo)=="undefined" || sRelativeContractNo.length==0 || sRelativeContractNo == "_CANCEL_" || sRelativeContractNo == "_CLEAR_")
				{
				    return;
				}
				sRelativeContractNo = sRelativeContractNo.split("@");
				sRelativeContractNo=sRelativeContractNo[0];

				sReturn = RunMethod("InfoManage","DataInputLater",sBCSerialNo+","+sRelativeContractNo);
				if(sReturn == "1")
				{
					alert("关联成功");
				}else{
					if(sReturn == "2"){
					   alert("没有关联该合同的借据.")
					}
					else
						 alert("出错");
				}
			}else
			{
				alert("当前业务不是垫款业务，请选择一笔垫款业务开展。");
			}
		}
		reloadSelf();
	}

	/*~[Describe=台帐管理;InputParam=无;OutPutParam=无;]~*/
	function Account()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBalance   = getItemValue(0,getRow(),"Balance");
		sInterestbalance1   = getItemValue(0,getRow(),"Interestbalance1");
		sInterestbalance2   = getItemValue(0,getRow(),"Interestbalance2");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if((sBalance=="0" || sBalance=="") && (sInterestbalance1=="0" || sInterestbalance1=="") && (sInterestbalance2=="0" || sInterestbalance2==""))
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","cando=Y&ComponentName=终结信息&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
			else
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","ComponentName=终结信息&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
		}
	}
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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

<%@	include file="/IncludeEnd.jsp"%>
