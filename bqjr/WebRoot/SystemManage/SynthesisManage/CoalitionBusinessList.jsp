<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: 客户业务合并
		Input Param:
		Output Param:
		HistoryLog: zywei on 2005/08/14 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户业务合并"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：sql语句
	String sSql = "";			 
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
		//设置列表显示标题			
	String sHeaders[][] = {							
							{"CustomerID","客户编号"},								
							{"CustomerName","客户名称"},
							{"CustomerType","客户类型"},
							{"OrgName","管户机构"},
							{"UserName","管户客户经理"}								
				          };
   
   sSql = " select CI.CustomerID,CI.CustomerName,CB.OrgID, "+
   		  " getItemName('CustomerType',CI.CustomerType) as CustomerType, "+
   		  " getOrgName(CB.OrgID) as OrgName,CB.UserID,getUserName(CB.UserID) as UserName "+
          " from CUSTOMER_BELONG CB, CUSTOMER_INFO CI where CB.CustomerID = CI.CustomerID "+
          " and exists (select OI.OrgID from ORG_INFO OI where OI.OrgID = CB.OrgID "+
          " and OI.SortNo like '"+CurOrg.getSortNo()+"%') and CB.BelongAttribute1 = '1' ";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "CUSTOMER_INFO";
	//设置主键
	doTemp.setKey("CustomerID",true);
	//设置字段是否可见
	doTemp.setVisible("OrgID,UserID",false);
	
	//设置html风格	
    doTemp.setHTMLStyle("CustomerName"," style={width:200px}");
		
	//生成查询条件
	doTemp.setColumnAttribute("CustomerID,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

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
			{"true","","Button","业务合并","合并业务信息","UniteBusiness()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
		
	/*~[Describe=合并业务;InputParam=无;OutPutParam=无;]~*/
	function UniteBusiness()
    {    	
    	var sFromCustomerID = "";
		var sFromCustomerName = "";			
		var sToCustomerID = "";
		var sToCustomerName = "";
		sFromCustomerID = getItemValue(0,getRow(),"CustomerID");
		sFromCustomerName = getItemValue(0,getRow(),"CustomerName");
		if(typeof(sFromCustomerID) == "undefined" || sFromCustomerID == "")
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

    	if (confirm(getBusinessMessage("931")))//确认合并该客户的业务吗？
    	{				
			//获取合并后的客户	
			var sParaStr = "CertType, ";
			sCustomerInfo = setObjectValue("SelectOwner",sParaStr,"",0,0);				
		    if (sCustomerInfo == "" || sCustomerInfo == "_CANCEL_" || sCustomerInfo == "_NONE_" || sCustomerInfo == "_CLEAR_" || typeof(sCustomerInfo) == "undefined") 
		    {
			    alert(getBusinessMessage("932"));//请选择合并后的客户！
			    return;
		    }else
		    {
			    sCustomerInfo = sCustomerInfo.split('@');
			    sToCustomerID = sCustomerInfo[0];
			    sToCustomerName = sCustomerInfo[1];	
			    sToCertType = sCustomerInfo[2];
			    sToCertID = sCustomerInfo[3];
			    sToLoanCardNo = sCustomerInfo[4];
			    
				if(sFromCustomerID == sToCustomerID)
				{
					alert(getBusinessMessage("933"));//不允许在同一客户间进行业务合并操作，请重新选择合并后的客户！
					return;						
				}																						
				//调用页面更新
				sReturn = PopPageAjax("/SystemManage/SynthesisManage/CoalitionBusinessActionAjax.jsp?FromCustomerID="+sFromCustomerID+"&FromCustomerName="+sFromCustomerName+"&ToCustomerID="+sToCustomerID+"&ToCustomerName="+sToCustomerName+"&ToCertType="+sToCertType+"&ToCertID="+sToCertID+"&ToLoanCardNo="+sToLoanCardNo,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
				if(sReturn == "TRUE")
					alert("客户编号("+sFromCustomerID+"),"+getBusinessMessage("934"));//业务合并成功！
				else if(sReturn == "FALSE")
					alert("客户编号("+sFromCustomerID+"),"+getBusinessMessage("935"));//业务合并失败！
				reloadSelf();	
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


<%@ include file="/IncludeEnd.jsp"%>
