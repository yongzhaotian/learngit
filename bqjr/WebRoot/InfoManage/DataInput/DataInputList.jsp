<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-22
		Tester:
		Describe: 投资－企业债权投资;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			
		HistoryLog:slliua 2005-01-15
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信业务补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sClauseWhere="";
	 String sSql="";
	
	//获得页面参数
	
	//获得组件参数
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sFlag==null) sFlag="";
	
	//获得组件参数(8010企业投资、8020股权投资、8030拆借)
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	if(sBusinessType==null) sBusinessType="";
	
	//获得组件参数(010待补登业务、020补登完成业务)
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";
	
	
	//定义表头
	//企业债权投资
	String sHeaders1[][] = {	
				{"OldlcNo","投资对象编号"},
				{"CustomerName","投资对象名称"},
				{"BusinessSubTypeName","投资对象信用等级"},
				{"CargoInfo","债券名称"},
				{"UserName","登记人"},
				{"OrgName","登记机构"},
				{"InputDate","登记日期"} 
			 };
	
	//股权投资
	String sHeaders2[][] = {	
					{"OldlcNo","投资对象编号"},
					{"CustomerName","投资对象名称"},
					{"BusinessSubTypeName","投资对象信用等级"},
					{"ArtificialNo","合同编号"},
					{"UserName","登记人"},
					{"OrgName","登记机构"},
					{"InputDate","登记日期"}                                                                                                                                       			
				  };
	
	//拆借
	String sHeaders3[][] = {	
					{"SerialNo","流水号"},
					{"OldlcNo","拆借对手编号"},
					{"CustomerName","拆借对手名称"},
					{"ArtificialNo","拆借合同号"},
					{"BusinessSum","拆借合同金额(元)"},
					{"BeginDate","拆借起息日"},
					{"EndDate","拆借到期日"},					
					{"UserName","登记人"},
					{"OrgName","登记机构"},
					{"InputDate","登记日期"} 
			  };
	
	
	if(sReinforceFlag.equals("110"))  //待补登的业务
	{
		sClauseWhere = " and ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')"; //本机构辖下 Modi by wuxiong 20050709 
	}
	if(sReinforceFlag.equals("120"))  //补登完成的业务
	{
		sClauseWhere = " and ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')"; //本机构辖下 Modi by wuxiong 20050709 
	}
	
	//企业债权投资
	if(sBusinessType.equals("8010"))
	{
		
          	sSql = " select SerialNo,CustomerID,OldlcNo,CustomerName,getItemName('CreditGrade',BusinessSubType) as BusinessSubTypeName,CargoInfo," +
				   " InputOrgID,InputUserID,getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName ,InputDate"+
				   " from BUSINESS_CONTRACT " +
				   " where BusinessType='8010' "+
				   " and ReinforceFlag = '"+sReinforceFlag+"' "
				   +sClauseWhere;
	}
	
	//股权投资
	if(sBusinessType.equals("8020"))
	{
		
          	sSql = " select SerialNo,CustomerID,CustomerName,getItemName('CreditGrade',BusinessSubType) as BusinessSubTypeName,CargoInfo," +
				   " InputOrgID,InputUserID,getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName ,InputDate"+
				   " from BUSINESS_CONTRACT " +
				   " where BusinessType='8020' "+
				   " and ReinforceFlag = '"+sReinforceFlag+"' "
				   +sClauseWhere;
	}
	//拆借
	if(sBusinessType.equals("8030"))
	{
		
        	sSql = " select SerialNo,CustomerID,CustomerName,ArtificialNo,BusinessSum,BeginDate,EndDate," +
				   " InputOrgID,InputUserID,getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName,InputDate "+
				   " from BUSINESS_CONTRACT " +
				   " where BusinessType='8030' "+
				   " and ReinforceFlag = '"+sReinforceFlag+"' "
				   +sClauseWhere;
				 
	}

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//企业债权投资
	if(sBusinessType.equals("8010"))
	{
		doTemp.setHeader(sHeaders1);
	}
	
	//股权投资
	if(sBusinessType.equals("8020"))
	{
		doTemp.setHeader(sHeaders2);
	}
	
	//拆借
	if(sBusinessType.equals("8030"))
	{
		doTemp.setHeader(sHeaders3);
	}
	
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
   	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CustomerID,CargoInfo,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	//设置选项双击及行宽
	doTemp.setHTMLStyle("CustomerID,ArtificialNo,BusinessSubTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("CargoInfo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("UserName,BeginDate,EndDate,InputDate"," style={width:80px} ");
	
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

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
			{"true","","Button","新增","新增","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
			{"true","","Button","补登完成","补登完成","Finished()",sResourcesPath},
			{"true","","Button","再次补登","再次补登","secondFinished()",sResourcesPath}

		};
	
	
	if(sReinforceFlag.equals("120"))  //补登完成的业务
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
	
	if(sReinforceFlag.equals("110"))  //新增的业务
	{
		sButtons[4][0] = "false";
	}
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		var sCurItemDescribe3 = "<%=sBusinessType%>";
		OpenPage("/InfoManage/DataInput/DataInputInfo.jsp?Flag=<%=sFlag%>&CurItemDescribe3="+sCurItemDescribe3,"_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sReinforceFlag = "<%=sReinforceFlag%>";
		var sCurItemDescribe3 = "<%=sBusinessType%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(sReinforceFlag=="110") //待补登的可以修改
			{
				OpenPage("/InfoManage/DataInput/DataInputInfo.jsp?SerialNo="+sSerialNo+"&Flag=<%=sFlag%>&CurItemDescribe3=<%=sBusinessType%>", "_self","");

			}else
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=列表&ComponentType=MainWindow&SerialNo="+sSerialNo+"&Flag=Y&CurItemDescribe3="+sCurItemDescribe3+"","_blank",OpenStyle);
			}
		}
	}
	
	/*~[Describe=置完成补登标志;InputParam=无;OutPutParam=无;]~*/
	function Finished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm("真的要补登完成吗？")) 
		{
			
			var sFlag="<%=sFlag%>";
			
			if(sFlag=="Y")   //不良资产补登完成
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag,"","");
			}else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo,"","");
			}
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=再次补登;InputParam=无;OutPutParam=无;]~*/
	function secondFinished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm("真的要再次补登吗？")) 
		{
			
			var sFlag="<%=sFlag%>";
			
			var sFlag1 = "SecondFlag";
			
			if(sFlag=="Y")   //不良资产补登完成
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&Flag1="+sFlag1,"","");
			}
			else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&Flag1=SecondFlag","","");
			}
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				alert("再次补登，所选数据将回到需补登业务列表!");
			}
			
			if(sReturn == "false")
			{
				alert("所选资产已经分发,不能再次补登!");
			}
			reloadSelf();
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=移交保全部门;InputParam=无;OutPutParam=无;]~*/
	function ShiftRMDepart()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
		
			var sTrace= PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sTrace)!="undefined" && sTrace.length!=0)
			{
				
				var sTrace=sTrace.split("@");
				
				//获得移交类型、保全机构
				var sShiftType = sTrace[0];
				var sTraceOrgID = sTrace[1];
				var sTraceOrgName = sTrace[2];
				
				if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
				{
					var sReturn = PopPageAjax("/RecoveryManage/Public/NPAShiftActionAjax.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"","","");
					if(sReturn == "true") //刷新页面
					{
						alert("该不良资产成功移交到『"+sTraceOrgName+"』"); 
						self.location.reload();
					}else
					{
						alert("该不良资产已经移交，不能再次移交！"); 
						self.location.reload();
					}
				}
			}
	
		}
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
