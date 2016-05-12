<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2005-1-5
		Tester:
		Content: 任务阶段模型列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "任务阶段模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
    String sWizardNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("WizardNo"));
	if(sWizardNo==null) sWizardNo="";

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
		{"WizardNo","向导模型编号"},
		{"PhaseNo","阶段号"},
		{"PhaseType","阶段类型"},
		{"PhaseName","阶段名称"},
		{"PhaseDescribe","阶段描述"},
		{"PhaseAttribute","阶段属性"},
		{"HelpID","帮助编号[停用]"},
		{"SkipScript","跳越Script"},
		{"PreScript","前沿执行Script"},
		{"InitScript","相关组件Script"},
		{"PhaseRemark","阶段备注"},
		{"ActionScript","动作生成Script"},
		{"FinishScript","完备性Script"},
		{"PostScript","后续阶段Scripit"}
	};
	
	sSql =  "select "+
			"WizardNo,"+
			"PhaseNo,"+
			"PhaseType,"+
			"PhaseName,"+
			"PhaseDescribe,"+
			"PhaseAttribute,"+
			"HelpID "+
		"from WZD_PHASE_DEF ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "WZD_PHASE_DEF";
	doTemp.setKey("WizardNo,PhaseNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("PhaseNo"," style={width:60px} ");
	doTemp.setHTMLStyle("PhaseName"," style={width:220px} ");
	doTemp.setHTMLStyle("PhaseDescribe"," style={width:300px} ");
	doTemp.setHTMLStyle("PhaseAttribute"," style={width:100px} ");
	doTemp.setVisible("HelpID",false);
	
	//查询
 	doTemp.setColumnAttribute("WizardNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);
    
	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelPhaseInput(#WizardNo,#PhaseNo) + !Configurator.DelPhaseOutput(#WizardNo,#PhaseNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sWizardNo);
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
		{"true","","Button","组件输入列表","查看/修改组件输入参数定义列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","组件输出列表","查看/修改组件输出参数定义列表","viewAndEdit3()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
        	// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回","doReturn('N')",sResourcesPath}
		};
    %> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurRowNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("PhaseDefInfo","/Common/Configurator/WizardManage/PhaseDefInfo.jsp","WizardNo=<%=sWizardNo%>","");
        reloadSelf();            
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        sReturn=popComp("PhaseDefInfo","/Common/Configurator/WizardManage/PhaseDefInfo.jsp","WizardNo="+sWizardNo+"~PhaseNo="+sPhaseNo,"");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/WizardManage/PhaseDefList.jsp","_self","");           
            }
        }
	}

    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        popComp("PhaseInputList","/Common/Configurator/WizardManage/PhaseInputList.jsp","WizardNo="+sWizardNo+"~PhaseNo="+sPhaseNo,"");
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit3()
	{
    	sWizardNo = getItemValue(0,getRow(),"WizardNo");
    	sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    	if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
    	    return ;
		}
        popComp("PhaseOutputList","/Common/Configurator/WizardManage/PhaseOutputList.jsp","WizardNo="+sWizardNo+"~PhaseNo="+sPhaseNo,"");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    	if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
        	return ;
		}
		
		if(confirm(getHtmlMessage('53'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"PhaseNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
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
