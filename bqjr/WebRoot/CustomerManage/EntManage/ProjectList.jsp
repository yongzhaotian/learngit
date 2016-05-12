<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	  Author:   2005-7-25 fbkang 
	  Tester:
	  Content: --相关项目信息
	  Input Param:
	           ObjectType：--对象类型(Enterprise,BusinessApply,BusinessApprove,BusinessContract)
	           ObjectNo: --对象编号
	  Output param:
	            ObjectType：--对象类型
	       	    ObjectNo:--对象编号
	            ProjectNo：--项目编号
	                   
	  History Log:
 
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "项目信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sObjectNo="";//--对象编号
	String sCustomerID="";//--客户代码
	//获得页面参数	
	
	//获得组件参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("Customer"))
	{
	 	sObjectNo=  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	}else
	{
		sObjectNo   =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	}
		       
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProjectList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
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
		{"true","All","Button","新增","新增项目信息","newRecord()",sResourcesPath},
		{"true","All","Button","引入","引入项目","doImport()",sResourcesPath},
		{"true","","Button","详情","查看项目详情","viewAndEdit()",sResourcesPath},
		{"true","All","Button","删除","删除项目信息","deleteRecord()",sResourcesPath},
		};
	if(sObjectType!=null && sObjectType.equals("Customer"))
		sButtons[1][0]="false";
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var thisObjectInfo = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>";
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{		
		var sProjectInfo = PopPage("/CustomerManage/EntManage/AddProjectDialog.jsp?"+thisObjectInfo,"","resizable=yes;dialogWidth=20;dialogHeight=11;center:yes;status:no;statusbar:no");
		if(typeof(sProjectInfo) != "undefined" && sProjectInfo.length != 0)
		{			
			sProjectInfo = sProjectInfo.split("@");
			sProjectType = sProjectInfo[0];
			sProjectName= sProjectInfo[1];
			var sReturnValue=PopPageAjax("/CustomerManage/EntManage/AddProjectActionAjax.jsp?"+thisObjectInfo+sProjectInfo,"","resizable=yes;dialogWidth=21;dialogHeight=19;center:yes;status:no;statusbar:no");
			if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0)	
			OpenComp("ProjectView","/CustomerManage/EntManage/ProjectView.jsp","ComponentName=项目信息视图&ComponentType=MainWindow&ObjectNo="+sReturnValue+"&ObjectType=<%=sObjectType%>","_blank",OpenStyle)
		  	reloadSelf();
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserID");//--用户号码
		sProjectNo = getItemValue(0,getRow(),"ProjectNo");//--项目编号	
	    //判断是否有删除权限
		var sReturnValue=PopPageAjax("/CustomerManage/EntManage/AddCheckProjectActionAjax.jsp?ObjectNo=<%=sObjectNo%>&ProjectNo="+sProjectNo,"","");
		//返回值为‘YES’可以删除，返回值为'NO'不能删除
		if (sReturnValue=="NO")
		{
			 alert(getBusinessMessage('157'));//此项目在业务信息中已经录入，不能删除！
			 return;
		}
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));		
	}
	
	/*~[Describe=引入项目信息;InputParam=sObjectType,ObjectNo;OutPutParam=无;]~*/
	function doImport()
	{   
		//获取业务关联的项目流水号	
		sParaString = "ObjectType"+","+"Customer"+","+"ObjectNo"+","+"<%=sCustomerID%>";
		var sProjectInfo = setObjectValue("SelectProject",sParaString,"",0,0,"");
		if(typeof(sProjectInfo) != "undefined" && sProjectInfo != "") 
		{
			sProjectInfo = sProjectInfo.split('@');
			sProjectNo = sProjectInfo[0];
		}
		
		//如果选择了项目信息，则判断该项目是否已和当前的业务建立了关联，否则建立关联关系。
		if(typeof(sProjectNo) != "undefined" && sProjectNo != "" && sProjectNo != "_CLEAR_") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ProjectNo,PROJECT_RELATIVE,String@ObjectNo@" + "<%=sObjectNo%>" + "@String@ObjectType@" + "<%=sObjectType%>" + "@String@ProjectNo@" + sProjectNo);
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
						if(sReturnInfo[0] == "projectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sProjectNo)
							{
								alert(getBusinessMessage('158'));//所选项目已被该业务引入,不能再次引入！
								return;
							}
						}				
					}
				}			
			}
			else{
				//新增业务与所选项目的关联关系
				sReturn = RunMethod("ProjectManage","InsertProjectRelative","<%=sObjectNo%>"+","+"<%=sObjectType%>"+","+sProjectNo+",PROJECT_RELATIVE");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert(getBusinessMessage('159'));//引入关联项目成功！
					OpenPage("/CustomerManage/EntManage/ProjectList.jsp","right","");	
				}
				else
				{
					alert(getBusinessMessage('160'));//引入关联项目失败！
					return;
				}
			}
		}		
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var currentType = "<%=sObjectType%>";
		sProjectNo   = getItemValue(0,getRow(),"ProjectNo");//--项目号码
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{     
			if(currentType == "Customer" ){
				openObject("Project",sProjectNo,"000");			
			}else{
				openObject("Project",sProjectNo,"000");			
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