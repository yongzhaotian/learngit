<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-04-20 
		Tester:
		Describe: 电子合同模板管理详情
		Input Param:
			EDocNo：
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "电子文档模板管理详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	String sEDocNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocNo"));
	if(sEDocNo==null) sEDocNo="";
	
	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
    	 String sHeaders[][] = { 
								{"EDocNo","模板编号"},
								{"EDocName","模板名称"},
								{"EDocType","电子文档类型"},
								{"StamperType","签章页类型"},
								{"IsInUse","是否有效"},
								{"FileNameFmt","格式文件"},
								{"FileNameDef","数据定义文件"},
								{"InputUserName","登记人"},
								{"InputOrgName","登记机构"},
								{"InputTime","登记时间"},
								{"UpdateUserName","更新人"},
								{"UpdateOrgName","更新机构"},
								{"UpdateTime","更新时间"}
				            }; 	 

	String sSql = " select EDocNo,EDocName,EDocType,StamperType,IsInUse,FileNameFmt,FileNameDef," +
				  " getUserName(InputUser) as InputUserName,InputUser," + 
				  " getOrgName(InputOrg) as InputOrgName,InputOrg,InputTime," +
		          " getUserName(UpdateUser) as UpdateUserName,UpdateUser," + 
		          " getOrgName(UpdateOrg) as UpdateOrgName,UpdateOrg,UpdateTime " +
		          " from EDOC_DEFINE"+
		          " where EDocNo = '"+sEDocNo+"' ";	
                	
    ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EDOC_DEFINE"; 

	doTemp.setVisible("InputOrg,UpdateOrg,InputUser,UpdateUser,UpdateUserName,UpdateOrgName,UpdateTime",false);
	
	doTemp.setKey("EDocNo",true);
	doTemp.setReadOnly("FileNameFmt,FileNameDef,InputUserName,InputOrgName,InputTime,UpdateUserName,UpdateOrgName,UpdateTime,",true);
	if (sEDocNo != "") {
		doTemp.setReadOnly("EDocNo,EDocName",true);
		doTemp.setVisible("UpdateUserName,UpdateOrgName,UpdateTime",true);
		doTemp.setVisible("InputUserName,InputOrgName,InputTime",false);
	}
	doTemp.setDDDWCode("IsInUse","YesNo");
	doTemp.setDDDWCode("EDocType","EDocType");
	doTemp.setDDDWCode("StamperType","StamperType");
	doTemp.setRequired("EDocNo,EDocName,EdocType",true);
	doTemp.setUnit("FileNameFmt","<input type=button class=inputDate   value=\" 查看..\" name=button2 onClick=\"javascript:parent.TemplateViewFmt();\"> ");
	doTemp.setUnit("FileNameDef","<input type=button class=inputDate   value=\" 查看..\" name=button4 onClick=\"javascript:parent.TemplateViewDef();\"> ");
	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName,UpdateOrgName",false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			sEDocNo = getItemValue(0,getRow(),"EDocNo");
			sReturn = RunMethod("Configurator","CheckEDocNoExist",sEDocNo);
			if(sReturn == sEDocNo)
			{
				alert("["+sEDocNo+"]模板编号已经存在，请输入新的模板编号");
				bIsInsert = true;
				return;	
			}
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		//打开业务类型关联页面
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		sEDocType = getItemValue(0,getRow(),"EDocType");
		OpenPage("/Common/EDOC/EDocRelativeList.jsp?EDocNo="+sEDocNo+"&EDocType="+sEDocType,"DetailFrame","");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Common/EDOC/TemplateList.jsp","","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
		}
		else
		{
			setItemValue(0,getRow(),"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
		}
    }
	
	/*~[Describe=格式文件查看;InputParam=无;OutPutParam=无;]~*/
	function TemplateViewFmt()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
		sFileName = getItemValue(0,getRow(),"FileNameFmt");//--格式文件
	    if(typeof(sFileName)=="undefined" || sFileName.length==0) {
			alert("文件未上传！");//请选择一条信息！
	        return ;
		}
		popComp("EDocTemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Fmt");
	}

	/*~[Describe=定义文件查看;InputParam=无;OutPutParam=无;]~*/
	function TemplateViewDef()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
		sFileName = getItemValue(0,getRow(),"FileNameDef");//--格式文件
	    if(typeof(sFileName)=="undefined" || sFileName.length==0) {
			alert("文件未上传！");//请选择一条信息！
	        return ;
		}
		popComp("EDocTemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Def");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	if(!bIsInsert) 
	{
		sEDocType = getItemValue(0,getRow(),"EDocType");
		OpenPage("/Common/EDOC/EDocRelativeList.jsp?EDocNo=<%=sEDocNo%>&EDocType="+sEDocType ,"DetailFrame","");
	}
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
