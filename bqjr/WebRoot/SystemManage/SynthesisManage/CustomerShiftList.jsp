<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 客户交接_List
		Input Param:
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户交接"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CustomerShiftList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(100);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurOrg.getSortNo());
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
			{"true","","Button","交接","交接客户信息","transferCustomer()",sResourcesPath},
			{"true","","PlainText","(双击左键选择/取消 是否交接)","(双击左键选择或取消 是否交接)","style={color:red}",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	
	/*~[Describe=右击选择需交接的客户;InputParam=无;OutPutParam=无;]~*/
	function onDBClick()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
			setItemValue(0,getRow(),"Status","√");
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

	/*~[Describe=交接客户;InputParam=无;OutPutParam=无;]~*/
	function transferCustomer()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage("942")))//确认交接该客户吗？
    	{			
			var sCustomerID = "";
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//获取交接用户			
			sSortNo = "<%=CurOrg.getSortNo()%>";
			sParaStr = "SortNo,"+sSortNo;
			sUserInfo = setObjectValue("SelectUserInOrg",sParaStr,"",0,0);		
		    if(sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    //alert(getBusinessMessage("943"));//请选择交接后的客户经理！
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//获取更新信息类型,对于同时选择多条记录交接的，此处选择只出现一次	
				sChangeObject = PopPage("/SystemManage/SynthesisManage/CustomerShiftDialog.jsp","","dialogWidth=24;dialogHeight=16;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 					
				if(sChangeObject != "_CANCEL_" && typeof(sChangeObject) != "undefined")
				{
					//需判定是否至少有一个客户被选定待交接了。把有的找出来
					var b = getRowCount(0);
					for(var i = 0 ; i < b ; i++)
					{
						var a = getItemValue(0,i,"Status");
						if(a == "√")
						{
							sCustomerID = getItemValue(0,i,"CI.CustomerID");	
							sFromOrgID = getItemValue(0,i,"OrgID");
							sFromOrgName = getItemValue(0,i,"OrgName");
							sFromUserID = getItemValue(0,i,"UserID");
							sFromUserName = getItemValue(0,i,"UserName");
							if(sFromUserID == sToUserID)
							{
								alert(getBusinessMessage("944"));//不允许在同一客户经理间进行客户交接操作，请重新选择交接后的客户经理！
								return;						
							}
						
							//调用页面更新
							sReturn = PopPageAjax("/SystemManage/SynthesisManage/CustomerShiftActionAjax.jsp?CustomerID="+sCustomerID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"&ChangeObject="+sChangeObject,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
							if(sReturn == "TRUE")
								alert("客户编号("+sCustomerID+"),"+getBusinessMessage("945"));//客户交接成功！
							else if(sReturn == "FALSE")
								alert("客户编号("+sCustomerID+"),"+getBusinessMessage("946"));//客户交接失败！
							else if(sReturn == "UNFINISHAPPLY")
								alert("客户编号("+sCustomerID+")还存在在途业务申请,"+getBusinessMessage("957"));//请先处理完在途业务申请再进行客户交接！
						}	
					}
				}
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
