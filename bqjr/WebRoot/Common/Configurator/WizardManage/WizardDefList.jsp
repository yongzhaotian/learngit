<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 向导模型定义列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "向导模型定义列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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

	String[][] sHeaders = {
		{"WizardNo","向导模型编号"},
		{"WizardName","向导模型名称"},
		{"WizardType","向导类型"},
		{"WizardDescribe","向导模型流程描述"},
		{"InitPhase","向导初始阶段"}
	};
	sSql = "select "+
		   "WizardNo,"+
		   "WizardName,"+
		   "WizardType,"+
		   "WizardDescribe,"+
		   "InitPhase "+
		  "from WZD_WIZARD_DEF Where 1=1 ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "WZD_WIZARD_DEF";
	doTemp.setKey("WizardNo",true);
	doTemp.setHeader(sHeaders);
	

	//查询
 	doTemp.setColumnAttribute("WizardNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelWizardInput(#WizardNo) + !Configurator.DelWizardOutput(#WizardNo) + !Configurator.DelWizardPhase(#WizardNo)");
	
	//生成HTMLDataWindow
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","任务阶段列表","查看/修改任务阶段列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("WizardDefInfo","/Common/Configurator/WizardManage/WizardDefInfo.jsp","","");
        reloadSelf();        
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        if(typeof(sWizardNo)=="undefined" || sWizardNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}       
        popComp("WizardDefView","/Common/Configurator/WizardManage/WizardDefView.jsp","ObjectNo="+sWizardNo);
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
    	sWizardNo = getItemValue(0,getRow(),"WizardNo");
    	if(typeof(sWizardNo)=="undefined" || sWizardNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
        	return ;
		}
    	popComp("PhaseDefList","/Common/Configurator/WizardManage/PhaseDefList.jsp","WizardNo="+sWizardNo,"");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sWizardNo = getItemValue(0,getRow(),"WizardNo");
    	if(typeof(sWizardNo)=="undefined" || sWizardNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
        	return ;
		}
		
		if(confirm(getHtmlMessage('52'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
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
