<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   --fmwu
		Tester:
		Content: --电子合同模板管理列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "电子文档模板管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";//--存放sql语句
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders = {
								{"EDocNo","文档编号"},
								{"EDocName","文档名称"},
								{"EDocType","文档类型"},
								{"StamperType","签章页类型"},
								{"IsInUse","是否有效"},
								{"FileNameFmt","格式文件"},
								{"FileNameDef","数据定义文件"},
								{"InputUserName","登记人"},
								{"InputOrgName","登记机构"},
								{"InputTime","登记时间"},
								{"UpdateUserName","更新人"},
								{"UpdateTime","更新时间"}
				             };
	sSql =  " select EDocNo,EDocName,FileNameFmt,FileNameDef,"+
	        " getItemName('YesNo',IsInUse) as IsInUse,"+
	        " getItemName('StamperType',StamperType) as StamperType,"+
	        " getItemName('EDocType',EDocType) as EDocType,"+
			" getUserName(InputUser) as InputUserName, "+
			" getOrgName(InputOrg) as InputOrgName,InputTime, "+
			" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
			" from EDOC_DEFINE "+
			" order by EDocNo ";

	//根据代码标判断是否存在不存在的模板，进行初始化
	String sSql1="select itemno from code_library a where  codeno='ElectronicContractType' and not exists (select 'X' from edoc_define b where a.itemno=b.edocno)";
	String itemno = Sqlca.getString(sSql1);
	if (itemno != null) {
		String sSql2="insert into EDOC_DEFINE(EDocNo,EDocName,IsInUse,EdocType,StamperType) select itemno,itemname,IsInUse,'010','020' from code_library a where codeno='ElectronicContractType' and not exists (select 'X' from edoc_define b where a.itemno=b.edocno)";
		Sqlca.executeSQL(sSql2);
	}

	//产生ASDataObject对象doTemp		
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置修改表名
	doTemp.UpdateTable = "EDOC_DEFINE";
	//设置主键
	doTemp.setKey("EDocNo",true);
	//设置列宽度
	doTemp.setHTMLStyle("EDocNo"," style={width:100px} ");
	doTemp.setHTMLStyle("EDocType,IsInUse"," style={width:60px} ");
 	doTemp.setHTMLStyle("TypeName,InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	
	//过滤查询
 	doTemp.setColumnAttribute("TypeNo,TypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//设置页面显示的列数
	dwTemp.setPageSize(20);
  	
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
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","格式文件上传","电子文档格式文件上传","TemplateUploadFmt()",sResourcesPath},			
			{"true","","Button","数据定义文件上传","电子文档数据定义文件上传","TemplateUploadDef()",sResourcesPath},			
			{"true","","Button","电子文档状态查看","电子文档状态查看","TemplateView()",sResourcesPath},				
			{"true","","Button","打印借款合同测试","打印借款合同案例","BCSample()",sResourcesPath},	//案例，上线前请删除		
			{"true","","Button","打印担保合同测试","打印担保合同案例","GCSample()",sResourcesPath}	//案例，上线前请删除			
		   };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn = popComp("EDOCTemplateInfo","/Common/EDOC/TemplateInfo.jsp","","");
        reloadSelf();
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	    sEDocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    sReturn=popComp("EDOCTemplateInfo","/Common/EDOC/TemplateInfo.jsp","EDocNo="+sEDocNo,"");
	    if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	    {
        	reloadSelf();
  	    }
	}
	
	/*~[Describe=电子文档格式文件上传;InputParam=无;OutPutParam=无;]~*/
	function TemplateUploadFmt()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		sFileName = getItemValue(0,getRow(),"FileNameFmt");//模板文件名称
	    if(typeof(sFileName)!="undefined" &&  sFileName.length!=0) {
			if(!confirm("电子文档格式文件已经存在，确定要覆盖上传吗？"))
			{
			    return;
			}
		}
		popComp("EDocTemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+sEDocNo+"&DocType=Fmt","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=电子文档模板上传;InputParam=无;OutPutParam=无;]~*/
	function TemplateUploadDef()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		sFileName = getItemValue(0,getRow(),"FileNameDef");//模板文件名称
	    if(typeof(sFileName)!="undefined" &&  sFileName.length!=0) {
			if(!confirm("电子文档数据定义文件已经存在，确定要覆盖上传吗？"))
			{
			    return;
			}
		}
		popComp("EDocTemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+sEDocNo+"&DocType=Def","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=电子文档状态查看;InputParam=无;OutPutParam=无;]~*/
	function TemplateView()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}

		popComp("TemplateState","/Common/EDOC/TemplateState.jsp","EDocNo="+sEDocNo);
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--永久类型编号
        if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm("确定要删除该模板吗？如果该模板在代码表中存在定义！下次进入该页面会自动初始化该记录！")) 
		{
			RunMethod("Configurator","DeleteEDocRelative",sEDocNo);
			sReturn = RunMethod("Configurator","DeleteEDocPath",sEDocNo);
			if(sReturn != "1") {
				alert("电子合同模板文件路径不存在，删除文件失败！");
			}
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=案例，上线前请删除;InputParam=无;OutPutParam=无;]~*/
	function BCSample()
	{
		var sManageUserID = "test11";
		sParaString = "ManageUserID," +sManageUserID;
		var sReturns = setObjectValue("SelectEDocContract",sParaString,"",0,0,"");
		var sReturn = sReturns.split("@");
		sObjectNo = sReturn[0];
		sObjectType = sReturn[1];
		sEDocNo = PopPage("/Common/EDOC/EDocNo.jsp?ObjectType="+sObjectType,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		if(sReturn == "nodef")
		{
			alert("没有对应的模板，电子合同生成失败！");
			return;
		}
		if(sReturn == "nodoc")
		{
			sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=150;dialogHeight=100;center:no;status:no;statusbar:no");
		}
		sSerialNo = sReturn;
		OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		
		reloadSelf();
	}
	
	/*~[Describe=案例，上线前请删除;InputParam=无;OutPutParam=无;]~*/
	function GCSample()
	{
		alert("123123");
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
