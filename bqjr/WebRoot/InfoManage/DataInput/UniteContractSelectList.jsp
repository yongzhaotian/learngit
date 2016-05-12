<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-26
		Tester:
		Describe1: 合同选择;
		Input Param:
		Output Param:

		HistoryLog:
		jytian 2004/12/28 区分授信额度合同
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同选择"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	String sWhereClause ="";
	String sTempletNo ="";
	
	//获得组件参数	
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	
	if(sContractNo==null || sContractNo.equals("")) sContractNo=" ";
	/*modified by  ttshao 20121026
	if(sContractNo==null) sContractNo=" ";
	*/
	if(sCustomerID==null) sCustomerID=" ";
	if(sBusinessType==null) sBusinessType=" ";
	
	String sSortNo=CurOrg.getSortNo();
	//定义表头文件
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	
	//doTemp.setHTMLStyle("BusinessCurrencyName,RecoveryUserName"," style={width:100px} ");

	//通过DW模型产生ASDataObject对象doTemp
	sTempletNo = "UniteContractSelectList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//多选
	doTemp.multiSelectionEnabled = true;
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContractNo+","+sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
				{"true","","Button","合并","合并所选合同","SelectSubmit()",sResourcesPath},
				{"true","","Button","详情","客户详情","CreditBusinessInfo()",sResourcesPath},
			};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
	
	/*~[Describe=详情;InputParam=无;OutPutParam=无;]~*/
	function CreditBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}


	
	/*~[Describe=合并合同;InputParam=无;OutPutParam=无;]~*/
	function SelectSubmit()
	{
		//获得合同流水号
		sObjectNoArray = getItemValueArray(0,"SerialNo");
		
		if (sObjectNoArray.length==0){
			alert("你没有选择信息，请在需要选择的信息前打√！ ");
			return;
		}		

		var iCount = 0;
		var sMessage1 = "";
		
		sMessage = "你已经选择了下列需要被合并的合同:\n\r"+"执行该操作后，被选中的合同将被彻底删除，无法恢复！\n\r\n\r";
		//找到第一笔选中的任务，并生成提示信息
		for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a == "√")
			{
				if (iCount == 0) 
				{
					sSerialNo = getItemValue(0,iMSR,"SerialNo");
					
				}
				
				iCount = iCount + 1;
				
				sMessage = sMessage+getItemValue(0,iMSR,"SerialNo")+"-";
				sMessage = sMessage+getItemValue(0,iMSR,"CustomerName")+"-";
				sMessage = sMessage+"\n\r";
				if(sMessage1=="")
				{
					sMessage1 = getItemValue(0,iMSR,"SerialNo");
				}else
				{
					sMessage1 = sMessage1+","+getItemValue(0,iMSR,"SerialNo");
				}
			}
		}

		sMessage = sMessage+"\n\r"+"确认要将所选合同与目标合同『<%=sContractNo%>』合并吗？";
		
		if (confirm(sMessage)==false){
			return;
		}		
				
		//var sReturn = PopPageAjax("/InfoManage/DataInput/UniteContractActionAjax.jsp?ContractNo=<%=sContractNo%>&ObjectNoArray="+sObjectNoArray,"","");
		var sReturn = RunMethod("信息补登","UniteContract","<%=sContractNo%>"+","+sObjectNoArray);
		if(sReturn=="true")
		{
			alert("被选合同『"+sMessage1+"』已经成功合并到目标合同『<%=sContractNo%>』!");
			self.returnValue =sReturn;
			self.close();
		}else
		{
			self.returnValue =sReturn;
			self.close();
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


<%@ include file="/IncludeEnd.jsp"%>