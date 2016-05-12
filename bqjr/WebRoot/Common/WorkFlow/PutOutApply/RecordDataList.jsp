<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 质量和地标记录
		
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
	String PG_TITLE = "质量和地标记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sRelativeQualityGrade="";//上级质量等级
	String sNowQualityGrade="";//当前状态下的质量等级
	String sNowLandmarkStatus="";//当期状态下的地标
	String sRelativeSerialNo="";//上级流水号
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));
	String sQualityGrade  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("qualityGrade"));	
	String sLandmarkStatus  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("landmarkStatus"));	
	String oldLandmark  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("oldLandmark"));//上次未更改地标的状态 
	if(oldLandmark==null) oldLandmark="";	
	if(sSerialNo==null) sSerialNo="";	
	if(sQualityGrade==null) sQualityGrade="";	
	if(sLandmarkStatus==null) sLandmarkStatus="";
	
	 ASDataObject doTemp = null;
	 String	 sTempletNo = "RecordData";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//当前合同的质量等级
	String realQualityGrade = Sqlca.getString("select * from (select q.qualitygrade from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = '"+sSerialNo+"' order by c.itemattribute asc) where rownum=1");
	sRelativeQualityGrade = Sqlca.getString("select startQualityGrade from record_Data where recordID=(select max(recordID) from record_Data where artificialNo='"+sSerialNo+"')");
	if(sRelativeQualityGrade==null){
		sRelativeQualityGrade="合格";
	}
	if(realQualityGrade != null && realQualityGrade != ""){
		sNowQualityGrade = Sqlca.getString("select itemname from code_library where codeno='QualityGrade' and isinuse='1' and itemno='"+realQualityGrade+"' ");
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
		{"false","","Button","删除","删除记录","deleteRecord()",sResourcesPath},
		};
	  
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List0577.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	
	
	function deleteRecord(){
		var sRecordID=getItemValue(0,getRow(),"recordID");
		if (typeof(sRecordID)=="undefined" || sRecordID.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
		
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

