<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author: wlu 2009-2-17
		Tester:
		Content:    --授权管理详情
			
		Input Param:
        	
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权管理详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//-存放sql语句
	
	//获得组件参数	,产品编号
	String sSubjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubjectNo"));
	if(sSubjectNo == null) sSubjectNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
    //产生ASDataObject对象doTemp
	  String sTempletNo = "SubjectInfo"; //模版编号
	 ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	

 	//如果科目编号不为空，则不允许修改
 	//if(!sSubjectNo.equals(""))
 		//doTemp.setReadOnly("SubjectNo,SubjectName",true);

	 //设置不可见列
	//doTemp.setVisible("",false);		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSubjectNo);	
	for(int i=0;i<vTemp.size();i++) 
	out.print((String)vTemp.get(i));
	
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
			{"true","","Button","保存并返回","保存修改并返回","saveRecordAndBack()",sResourcesPath},
			{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号
	var bIsInsert = false; //标记DW是否处于“新增状态”
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
	   OpenComp("SubjectInfo","/Common/Configurator/SubjectPolicy/SubjectInfo.jsp","","_self","");	   
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{				
		if(bIsInsert){
			//录入数据有效性检查
			if (!ValidityCheck()) return;
			beforeInsert();
		}		
	    as_save("myiframe0","doReturn('Y');");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
		//录入数据有效性检查		
		if(bIsInsert){
			if (!ValidityCheck()) return;
			beforeInsert();
		}	
		as_save("myiframe0","newRecord()");      
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh)
    {
		sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
	    parent.sObjectInfo = sSubjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录	
			bIsInsert = true;		
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
		//检查录入的科目编号是否存在,也可以自己写个类，直接查有无记录
		sSubjectNo = getItemValue(0,0,"SubjectNo");	//用户编号
		if(typeof(sSubjectNo) != "undefined" && sSubjectNo != "")
		{
	        //获得流程编号
	        var sColName = "SubjectNo";
			var sTableName = "SUBJECT_INFO";
			var sWhereClause = "String@SubjectNo@"+sSubjectNo;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//查询科目号
						if(my_array2[n] == "subjectno")
							sSubjectNo = sReturnInfo[n+1];				
					}
				}
				if(typeof(sSubjectNo)!="undefined" && sSubjectNo != "")
				{
					alert("对不起，已存在该科目号！");
					return false;
				}						
			} 
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
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
