<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-20
		Tester:
		Content: 功能定义列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "功能定义列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
	//获得组件参数	
	String sCompID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID"));
	if(sCompID == null) sCompID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
					{"FunctionID","FunctionID"},
					{"CompID","CompID"},
					{"PageID","PageID"},
					{"FunctionName","FunctionName"},
					{"RightID","RightID"},
					{"TargetComp","TargetComp"},
					{"InfoRightType","InfoRightType"},
					{"DefaultForm","DefaultForm"},
					{"TargetPage","TargetPage"},
					{"Remark","备注"},
					{"InputUserName","输入人"},
					{"InputUser","输入人"},
					{"InputOrgName","输入机构"},
					{"InputOrg","输入机构"},
					{"InputTime","输入时间"},
					{"UpdateTimeName","更新人"},
					{"UpdateUser","更新人"},
					{"UpdateTime","更新时间"}
			       };  

	sSql = 	" Select  "+
			"FunctionID,"+
			"CompID,"+
			"PageID,"+
			"FunctionName,"+
			"RightID,"+
			"TargetComp,"+
			"InfoRightType,"+
			"DefaultForm,"+
			"TargetPage,"+
			"Remark,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime "+
			"From REG_FUNCTION_DEF where 1=1 ";
	if(!sCompID.equals("")) sSql = sSql + " and CompID = '"+sCompID+"' ";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_FUNCTION_DEF";
	doTemp.setKey("FunctionID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("FunctionID"," style={width:160px} ");
	doTemp.setHTMLStyle("CompID"," style={width:160px} ");
	doTemp.setHTMLStyle("PageID"," style={width:160px} ");
	doTemp.setHTMLStyle("FunctionName"," style={width:160px} ");
	doTemp.setHTMLStyle("RightID"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetComp"," style={width:160px} ");
	doTemp.setHTMLStyle("InfoRightType"," style={width:160px} ");
	doTemp.setHTMLStyle("DefaultForm"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetPage"," style={width:160px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setHTMLStyle("Remark"," style={width:400px} ");
	
	doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputTime,UpdateTime",true);
	doTemp.setVisible("CommentText,Remark,InputUser,InputOrg,UpdateUser,InputUserName,InputOrgName,UpdateUserName",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	//查询
 	doTemp.setColumnAttribute("FunctionID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	
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
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurFunctionID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("FunctionInfo","/Common/Configurator/FunctionManage/FunctionInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/FunctionManage/FunctionList.jsp","_self","");    
                }
            }
        }
        
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sFunctionID = getItemValue(0,getRow(),"FunctionID");
        if(typeof(sFunctionID)=="undefined" || sFunctionID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        
        sReturn=popComp("FunctionInfo","/Common/Configurator/FunctionManage/FunctionInfo.jsp","FunctionID="+sFunctionID,"");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/FunctionManage/FunctionList.jsp?FunctionID="+sFunctionID,"_self","");           
            }
        }
	}
    
    /*~[Describe=查看及修改组件详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditComp()
	{
        sFunctionID = getItemValue(0,getRow(),"FunctionID");
        if(typeof(sFunctionID)=="undefined" || sFunctionID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        OpenPage("/Common/Configurator/CompManage/CompList.jsp?FunctionID="+sFunctionID,"_self","");    
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sFunctionID = getItemValue(0,getRow(),"FunctionID");
        if(typeof(sFunctionID)=="undefined" || sFunctionID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
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
