<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: 人员转移
		Input Param:
		Output Param:
		HistoryLog: zywei on 2005/08/14 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "人员转移"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sHeaders[][] = {
							{"Status","是否转移"},
							{"UserID","用户编号"},							
							{"UserName","用户名称"},
							{"OrgName","所属机构"}							
					   	};

	sSql = " select '' as Status,UserID,UserName,BelongOrg,getOrgName(BelongOrg) as OrgName "+
           " from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";
	              
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "USER_INFO";
	//设置主键
	doTemp.setKey("UserID",true);	
	
	//设置不可见性
	doTemp.setVisible("BelongOrg",false);
	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	doTemp.setUpdateable("OrgName",false);
	//设置html风格
	doTemp.setAlign("Status","2");
	doTemp.setHTMLStyle("Status","style={width:60px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");		
	//增加过滤器
	doTemp.setColumnAttribute("UserID,UserName,OrgName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
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
		   {"true","","Button","转移","转移用户信息","transferUser()",sResourcesPath},
		   {"true","","PlainText","(双击左键选择/取消 是否转移)","(双击左键选择或取消 是否转移)","style={color:red}",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=右击选择需交接的客户;InputParam=无;OutPutParam=无;]~*/
	function onDBClickStatus()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
		{
			setItemValue(0,getRow(),"Status","√");
		}
		else
			setItemValue(0,getRow(),"Status","");

	}
	
	/*~[Describe=选择记录;InputParam=无;OutPutParam=无;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"Status");
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

	/*~[Describe=转移用户;InputParam=无;OutPutParam=无;]~*/
	function transferUser()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage('952')))//确认转移该人员吗？
    	{			
			var sUserID = "";
			var sFromOrgID = "";
			var sFromOrgName = "";			
			var sToOrgID = "";
			var sToOrgName = "";
			//获取当前用户
			sOrgID = "<%=CurOrg.getOrgID()%>";			
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('953'));//请选择转移后的机构！
			    return;
		    }else
		    {
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];				    	    
		   
				//需判定是否至少有一个用户被选定待转移了。把有的找出来
				var b = getRowCount(0);
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "√")
					{
						sUserID = getItemValue(0,i,"UserID");	
						sFromOrgID = getItemValue(0,i,"BelongOrg");
						sFromOrgName = getItemValue(0,i,"OrgName");	
						if(sFromOrgID == sToOrgID)	
						{
							alert(getBusinessMessage('954'));//不允许人员转移在同一机构中进行，请重新选择转移后机构！
							return;
						}														
						//调用页面更新
						sReturn = PopPageAjax("/SystemManage/SynthesisManage/UserShiftActionAjax.jsp?UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("人员编号("+sUserID+"),"+getBusinessMessage("955"));//人员转移成功！
						else if(sReturn == "FALSE")
							alert("人员编号("+sUserID+"),"+getBusinessMessage("956"));//人员转移失败！					
					}
				}				
			}
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


<%@ include file="/IncludeEnd.jsp"%>
