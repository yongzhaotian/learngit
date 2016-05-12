<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: 相关业务信息
		Input Param:
			ObjectType: 阶段编号
			ObjectNo：业务流水号
			CustomerID:客户编号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "相关业务信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sRTableName = "";
	String sSql = "";
	
	//获得页面参数

	//获得组件参数
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sCustomerID = CurPage.getParameter("CustomerID");
	String sOccurType = CurPage.getParameter("OccurType");
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(sCustomerID==null) sCustomerID="";
	if(sOccurType==null) sOccurType="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//根据sObjectType的不同，得到不同的关联表名和模版名
	sSql = " select RelativeTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
	sRTableName = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType));

	String sTempletNo = "";//模型编号
	
	if(sRTableName.equals("APPROVE_RELATIVE")){
		sTempletNo = "RelativeBusinessList2";
	}
	else if(sRTableName.equals("APPLY_RELATIVE")){
		sTempletNo = "RelativeBusinessList1";
	}
	else if(sRTableName.equals("CONTRACT_RELATIVE")){
		sTempletNo = "RelativeBusinessList";
	}

	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
			{(sOccurType.equals("020")?"true":"false"),"","Button","添加关联借据","关联一笔已有的业务","newRecord()",sResourcesPath},
			{"true","","Button","借据详情","查看借据详情","view()",sResourcesPath},
			{"true","","Button","相关合同详情","查看相关合同详情","viewTab()",sResourcesPath},
			{(sOccurType.equals("020")?"true":"false"),"","Button","删除","删除关联","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"RELATIVESERIALNO2");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function newRecord()
	{		
		var sRelativeSerialNo = "";			
		//按照合同关联	
		//sParaString = "CustomerID,<%=sCustomerID%>,ManageUserID,<%=CurUser.getUserID()%>";
		//var sContractInfo = setObjectValue("SelectExtendContract",sParaString,"",0,0,"");
		//if(typeof(sContractInfo) != "undefined" && sContractInfo != "") 
		//{
		//	sContractInfo = sContractInfo.split('@');
		//	sRelativeSerialNo = sContractInfo[0];
		//}
		//按照借据关联	
		sParaString = "CustomerID,<%=sCustomerID%>,OperateUserID,<%=CurUser.getUserID()%>";
		var sDueBillInfo = setObjectValue("SelectExtendDueBill",sParaString,"",0,0,"");			
		if(typeof(sDueBillInfo) != "undefined" && sDueBillInfo != "") 
		{
			sDueBillInfo = sDueBillInfo.split('@');
			sRelativeSerialNo = sDueBillInfo[0];
		}
		//如果选择了合同/借据信息，则判断该合同是否已和当前的业务建立了关联，否则建立关联关系。
		if(typeof(sRelativeSerialNo) != "undefined" && sRelativeSerialNo != "") 
		{
			//按照合同关联	
			//sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,"+<%=sRTableName%>+",String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeSerialNo);
			//按照借据关联	
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,"+"<%=sRTableName%>"+",String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessDueBill@String@ObjectNo@"+sRelativeSerialNo);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array.length;j++)
				{
					sReturnInfo = my_array[j].split('@');				
					if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
					{						
						if(sReturnInfo[0] == "objectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeSerialNo)
							{
								alert("所选合同已被该业务引入,不能再次引入！");
								//alert("所选借据已被该业务引入,不能再次引入！");
								return;
							}
						}				
					}
				}			
			}
			//新增业务与所选合同的关联关系
			//sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",BusinessContract,"+sRelativeSerialNo+","+<%=sRTableName%>);
			//新增业务与所选借据的关联关系
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",BusinessDueBill,"+sRelativeSerialNo+","+"<%=sRTableName%>");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				//alert("引入关联合同成功！");
				alert("引入关联借据成功！");
				reloadSelf();	
			}else
			{
				//alert("引入关联合同失败，请重新操作！");
				alert("引入关联借据失败，请重新操作！");
				return;
			}
		}
	}
	
	function view()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//alert(sObjectNo);
		
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}		
		else 
		{
			openObject("BusinessDueBill",sObjectNo,"002");
		}
	}
	
	function deleteRecord()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">


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