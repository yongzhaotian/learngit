<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	 /*
		Author:
		Tester:
		Describe: 用户角色转换
		Input Param:
		Output Param:
		HistoryLog: zywei on 2005/08/14 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "用户角色转换"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"Status","是否转换"},
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
		   {"true","","Button","转换","转换用户角色信息","transferRole()",sResourcesPath},
		   {"true","","PlainText","(双击左键选择/取消 是否转换)","(双击左键选择或取消 是否转换)","style={color:red}",sResourcesPath}			
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

	/*~[Describe=转换用户角色;InputParam=无;OutPutParam=无;]~*/
	function transferRole()
    {    	
    	//检查是否存在已选中的记录
    	var j = 0;
		var a = getRowCount(0);
		for(var i = 0 ; i < a ; i++)
		{				
			var sStatus = getItemValue(0,i,"Status");
			if(sStatus == "√")
				j=j+1;
		}
		if(j <= 0)
		{
			alert(getBusinessMessage('948'));//请选择用户！
			return;
		}
    	if (confirm(getBusinessMessage('949')))//确认转移该用户角色吗？
    	{			
			var sUserID = "";
			var sFromOrgID = "";			
			var sFromUserID = "";
			var sFromUserName = "";			
			var sToUserID = "";	
			
			//获取当前用户
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			var sParaString = "BelongOrg"+","+sOrgID
			sUserInfo = setObjectValue("SelectUserBelongOrg",sParaString,"",0);	
		    if (sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('950'));//请选择转移后的用户！
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];			   			    	    
		   
				//需判定是否至少有一个用户被选定待转移了。把有的找出来
				var b = getRowCount(0);
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "√")
					{
						sFromUserID = getItemValue(0,i,"UserID");	
						sFromUserName = getItemValue(0,i,"UserName");	
						sFromOrgID = getItemValue(0,i,"BelongOrg");
						if(sFromUserID == sToUserID)	
						{
							alert(getBusinessMessage('951'));//不允许用户角色转换在同一用户间进行，请重新选择转换后用户！
							return;
						}														
						//调用页面更新
						sReturn = PopPage("/SystemManage/SynthesisManage/RoleSetting.jsp?Action=UserRole&FromOrgID="+sFromOrgID+"&UserID="+sFromUserID+"&ToUserID="+sToUserID+"&UserName="+sFromUserName+"&rand="+randomNumber(),"","dialogWidth=45;dialogheight=17;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");	
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
