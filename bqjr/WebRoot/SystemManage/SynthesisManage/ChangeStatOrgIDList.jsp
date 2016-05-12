<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 业务入账机构转移列表界面
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务入账机构转移"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%		
	//定义变量
	String sSql;
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String sHeaders[][] = {
			                    {"BCFlag","是否转移"},
			                    {"SerialNo","合同流水号"},				                                    
						        {"CustomerName","客户名称"},
						        {"StatOrgName","合同入帐机构"},
						        {"BusinessTypeName","业务品种"},
						        {"CurrencyName","币种"},
						        {"BusinessSum","金额"},
						        {"PutOutDate","起始日"},
						        {"Maturity","到期日"}	
			               };
		
	sSql = sSql = " select '' as BCFlag,SerialNo,CustomerName,getOrgName(StatOrgID) as StatOrgName, "+
				  " StatOrgID,getBusinessName(BusinessType) as BusinessTypeName, "+
	              " getItemName('Currency',BusinessCurrency) as CurrencyName,BusinessSum, "+
	              " PutOutDate,Maturity from BUSINESS_CONTRACT where ManageOrgID in "+
	              " (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";

	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setType("BusinessSum","Number");
    doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("BCFlag","2");
	//设置字段不可见
	doTemp.setVisible("StatOrgID",false);
	//设置字段显示宽度
	doTemp.setHTMLStyle("BusinessTypeName,CustomerName,StatOrgName"," style={width:200px} ");	
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");	
	doTemp.setHTMLStyle("BCFlag","style={width:60px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");

	//置字段是否可更新
	doTemp.setUpdateable("BusinessTypeName,StatOrgName,CurrencyName",false);
	
	//生成查询条件	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
		
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	
	//生成ASDataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置为Grid风格
	dwTemp.Style="1";
	//设置为只读
	dwTemp.ReadOnly = "1";

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		{"true","","Button","转移","转移入账机构信息","transferContract()",sResourcesPath}	,	
		{"true","","PlainText","(双击左键选择/取消 是否转移)","(双击左键选择或取消 是否转移)","style={color:red}",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=转移合同;InputParam=无;OutPutParam=无;]~*/	
	function transferContract()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage('926')))//确认转移该合同的入账机构吗？
    	{			
			var iCount = 0;
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";			
			var sToOrgID = "";
			var sToOrgName = "";
			//获取当前机构
			sOrgID = "<%=CurOrg.getOrgID()%>";
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('927'));//请选择转移后的入账机构！
			    return;
		    }else
		    {
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];			    
		   
				//需判定是否至少有一个合同被选定待交接了。把有的找出来
				var b = getRowCount(0);				
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"BCFlag");
					if(a == "√")
					{
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sFromOrgID = getItemValue(0,i,"StatOrgID");
						sFromOrgName = getItemValue(0,i,"StatOrgName");
						if(sFromOrgID == sToOrgID)	
						{
							alert(getBusinessMessage('928'));//不允许业务入账机构转移在同一机构中进行，请重新选择转移后的入账机构！
							return;
						}														
						//调用页面更新
						sReturn = PopPageAjax("/SystemManage/SynthesisManage/ChangeStatOrgIDActionAjax.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("929"));//入账机构转移成功！
						else if(sReturn == "FALSE")
							alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("930"));//入账机构转移失败！
						
					}
				}				
				reloadSelf();				
			}
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=右击选择记录;InputParam=无;OutPutParam=无;]~*/
	function onDBClickStatus()
	{
		sBCFlag = getItemValue(0,getRow(),"BCFlag") ;
		if (typeof(sBCFlag) == "undefined" || sBCFlag == "")
			setItemValue(0,getRow(),"BCFlag","√");
		else
			setItemValue(0,getRow(),"BCFlag","");

	}
	
	/*~[Describe=选择记录;InputParam=无;OutPutParam=无;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"BCFlag");
			if(a == "√")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert(getHtmlMessage('24'));//请至少选择一条信息！
			return false;
		}
		
		return true;
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
