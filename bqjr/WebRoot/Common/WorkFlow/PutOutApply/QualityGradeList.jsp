<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>
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
	//获取合同来源
    String sSureType = Sqlca.getString(new SqlObject("select SureType from business_contract  where serialNo=:serialNo").setParameter("serialNo", sSerialNo));

	//当前合同的质量等级
	String realQualityGrade = Sqlca.getString("select * from (select q.qualitygrade from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = '"+sSerialNo+"' order by c.itemattribute asc) where rownum=1");
	//判断是否曾有关键错误
	String sTFError = Sqlca.getString("select count(*) from record_Data where artificialNo='"+sSerialNo+"' and (UPDATEQUALITYGRADE='关键错误' or STARTQUALITYGRADE='关键错误')");
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
	
	String AppUrl = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String JQMUrl = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String FCUrl = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
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
		{"true","","Button","电子合同调阅","电子合同调阅","viewApplyReport()",sResourcesPath},
		{"true","","Button","第三方协议调阅","第三方协议调阅","creatThirdTable()",sResourcesPath},
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
		parent.AsControl.OpenView("/Common/WorkFlow/PutOutApply/ContrackRegistrationList.jsp","doWhere=<%=sDoWhere%>","_self");		
	}
	
//  ==============================  打印格式化报告  公共方法  add by phe   ============================================================
	
	/*~[Describe=打印格式化报告;InputParam=无;OutPutParam=无;]~*/
	function printTable(type){
			var sObjectNo = "<%=sSerialNo %>";
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert("没有获取到合同编号!");//请选择一条信息！
				return;
			}		
			//打印APP端的合同
			var sSureType = "<%=sSureType%>";
			var url = "";
			if(sSureType=="app"||sSureType=="APP"){
				//sObjectNo="19151136003";
				alert("此合同来源于APP!");
				url="<%=AppUrl%>"+sObjectNo;
				window.open(url);
				return;
			}else if(sSureType=="JQM"){
				alert("此合同来源于借钱么!");
				url="<%=JQMUrl%>"+sObjectNo;
				window.open(url);
				return;
			}else if(sSureType=="FC"){
				alert("此合同来源于蜂巢!");
				url="<%=FCUrl%>"+sObjectNo;
				window.open(url);
				return;
			}
			
			var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
			if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("请联系系统管理员检查合同模板配置和合同信息!");
				return;
			}
			var sDocID = 	returnValue.split("@")[0];
			var sUrl = returnValue.split("@")[1];
			var sObjectType = type;
			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "serialNo", "TS");
			//alert(sObjectNo+"sObjectNo,sSerialNo="+sSerialNo);
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}else{
				//检查出帐通知单是否已经生成
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if (sReturn == "false"){ //未生成出帐通知单
					//生成出帐通知单	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
					//记录生成动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
				}else{
					//记录查看动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
				}
				//获得加密后的出帐流水号
				var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
				//通过　serverlet 打开页面
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
				//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
				OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	//   ============================== end  打印格式化报告 ============================================================
	
		
	/*~[Describe= 查看电子合同;]~*/
    function viewApplyReport(){
    		printTable("ApplySettle");
    }
	
	/*~[Describe=打印第三方协议;]~*/
	function creatThirdTable(){
			printTable("ThirdSettle");
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

