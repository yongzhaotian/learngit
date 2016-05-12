<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 用款记录列表
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "变更质量等级"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sQualityGrade="";//质量等级
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));	
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	String sCustomerName  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));	
	if(sDoWhere==null) sDoWhere="";	
    if(sSerialNo==null) sSerialNo="";	
    if(sCustomerName==null) sCustomerName="";	
    
	
	 ASDataObject doTemp = null;
	 String	 sTempletNo = "QualityGrade";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
	 doTemp.setColumnAttribute("errorType,qualityGrade","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    
	//当前合同的质量等级
	String realQualityGrade = Sqlca.getString("select * from (select q.qualitygrade from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = '"+sSerialNo+"' order by c.itemattribute asc) where rownum=1");
	//判断是否曾有关键错误
	String sTFError = Sqlca.getString("select count(1) from record_Data where artificialNo='"+sSerialNo+"' and (UPDATEQUALITYGRADE='关键错误' or STARTQUALITYGRADE='关键错误')");
	if(!sTFError.equals("0")){
		Sqlca.executeSQL(new SqlObject("update Business_Contract set TFError=1 where serialNO=:serialNo")
		.setParameter("serialNo", sSerialNo));
	}else{
		Sqlca.executeSQL(new SqlObject("update Business_Contract set TFError=0 where serialNO=:serialNo")
		.setParameter("serialNo", sSerialNo));
	}
	if(realQualityGrade != null && realQualityGrade != ""){
		sQualityGrade = Sqlca.getString("select itemname from code_library where codeno='QualityGrade' and isinuse='1' and itemno='"+realQualityGrade+"' ");
	}
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
		{"true","","Button","删除","删除记录","deleteRecord()",sResourcesPath},
		{"true","","Button","返回","返回页面", "backRecord()",sResourcesPath},
		};
	  
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List0578.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/QualityGradeInfo.jsp","serialNo=<%=sSerialNo%>&qualityGrade=<%=sQualityGrade%>&CustomerName=<%=sCustomerName%>","_self");
	}
	
	function deleteRecord(){	
		var sSerialNo = getItemValue(0,getRow(),"serialNo");//获取删除记录的单元值
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		var qualityTagging =getItemValue(0,getRow(),"qualityTagging");//质量标注
		var errorType = getItemValue(0,getRow(),"ErrorTypeCode"); // 错误类型
		var qualityFile = getItemValue(0,getRow(),"QualityFile");//文件名称
		var serialNoss = '<%=DBKeyUtils.getSerialNo("rd")%>'; // 当前的序列号
		
		var contractNo = '<%=sSerialNo%>';
		var upUserName = '<%=CurUser.getUserID()%>';
		
		if(confirm("您真的想删除该信息吗？")){
			var args = "quSerialNo=" + sSerialNo+",contractNo="+contractNo+",reSerialNo=" + serialNoss + ",upUserName="+upUserName+",errorType="+errorType+",qualityTagging="+qualityTagging+",qualityFile="+qualityFile;
			var result = RunJavaMethodSqlca("com.amarsoft.app.billions.RunInTransaction", "delQualityGrade", args)
			if(result=="success"){
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}else if(result=="sysBusy"){
				alert("系统繁忙删除失败，请稍候重新操作");
			}else if(result=="sysException"){
				alert("系统异常，请稍候再试");
			}
		}	
		parent.reloadSelf();
	}
	
	function backRecord(){
		parent.AsControl.OpenView("/Common/WorkFlow/PutOutApply/ALDIContrackRegistrationList.jsp","doWhere=<%=sDoWhere%>","_self");		
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

<%@	include file="/IncludeEnd.jsp"%>

