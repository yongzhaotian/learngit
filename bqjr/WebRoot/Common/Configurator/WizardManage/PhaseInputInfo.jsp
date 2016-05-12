<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    组件输入参数定义详情
		Input Param:
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "组件输入参数定义详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
	//获得组件参数	
	String sWizardNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("WizardNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sParameterID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ParameterID"));
	String sIsNew =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("IsNew"));
	if(sWizardNo==null) sWizardNo="";
	if(sPhaseNo==null) sPhaseNo="";
	if(sParameterID==null) sParameterID="";
	if(sIsNew.equals("Y") && !sParameterID.equals("")) sParameterID="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
		{"WizardNo","向导模型编号"},
		{"PhaseNo","PhaseNo"},
		{"ParameterID","参数编号"},
		{"ParameterName","参数名称"},
		{"CalculateScript","默认值计算公式"}
	};
	sSql = "select "+
		   "WizardNo,"+
		   "PhaseNo,"+
		   "ParameterID,"+
		   "ParameterName,"+
		   "CalculateScript "+
		  "from WZD_PHASE_INPUT Where WizardNo = '"+sWizardNo+"' and PhaseNo = '"+sPhaseNo+"' and ParameterID = '"+sParameterID+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "WZD_PHASE_INPUT";
	doTemp.setKey("WizardNo,PhaseNo,ParameterID",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setRequired("WizardNo,PhaseNo,ParameterID",true);
	doTemp.setEditStyle("CalculateScript","3");
	doTemp.setHTMLStyle("CalculateScript"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("CalculateScript",120);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sWizardNo+","+sPhaseNo+","+sParameterID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
		// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurPhaseNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
        as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ParameterID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sWizardNo = getItemValue(0,getRow(),"WizardNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        OpenComp("PhaseInputInfo","/Common/Configurator/WizardManage/PhaseInputInfo.jsp","WizardNo="+sWizardNo+"&PhaseNo="+sPhaseNo+"&IsNew=Y","_self",""); 
        //OpenPage("/Common/Configurator/WizardManage/PhaseInputInfo.jsp?WizardNo="+sWizardNo+"&PhaseNo="+sPhaseNo,"_self","");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            if ("<%=sWizardNo%>" !="") 
            {
                setItemValue(0,0,"WizardNo","<%=sWizardNo%>");
            }
            if ("<%=sPhaseNo%>" !="") 
            {
                setItemValue(0,0,"PhaseNo","<%=sPhaseNo%>");
            }
		    bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
