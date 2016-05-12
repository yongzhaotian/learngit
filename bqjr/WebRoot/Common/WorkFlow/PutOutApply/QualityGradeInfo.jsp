<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --新增变更质量等级
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增变更质量等级"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));	
	String sQualityGrade  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("qualityGrade"));
	String sCustomerName =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	if(sSerialNo==null) sSerialNo="";
	if(sQualityGrade==null) sQualityGrade="";	
	if(sCustomerName==null) sCustomerName="";	

	ASDataObject doTemp = new ASDataObject("QualityGradeInfo",Sqlca);
	//doTemp.setDDDWSql("errorType", "select distinct ErrorType,getitemname('ErrorType',ErrorType) from ErrorTypeCode_Info");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

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
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","saveRecordAndBack()",sResourcesPath}
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
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var qualityGrade =getItemValue(0,getRow(),"qualityGrade");//质量等级
		var qualityTagging =getItemValue(0,getRow(),"qualityTagging"); //质量标注
		var errorType =getItemValue(0,getRow(),"errorType"); // 错误类型
		var qualityFile = getItemValue(0,getRow(),"QualityFile"); //文件名称
		//var serialNoss = getSerialNo("record_Data", "recordID", ""); // 当前的序列号
		var serialNoss = '<%=DBKeyUtils.getSerialNo("rd")%>'; // 当前的序列号
		var contractNo = '<%=sSerialNo%>';
		var upUserName = '<%=CurUser.getUserID()%>';
		bIsInsert = false;
		if(!vI_all("myiframe0")){
			return;
		}
		
		//是否执行保存操作状态(modified by chiqizhong)
		var flag = true;
		//有关键或非关键错误的数量
		var errorCount = RunMethod("Unique","uniques","quality_grade,count(1),artificialNo='<%=sSerialNo%>' and qualityGrade<>'3' ");
		//有合格的数量
		var qualityCount = RunMethod("Unique","uniques","quality_grade,count(1),artificialNo='<%=sSerialNo%>' and qualityGrade='3' ");
		//当录入的质量等级为合格时
		if('3' == qualityGrade && errorCount > 0){
			flag = false;
			alert("您好，如需添加'合格'标注，必须先把'关键错误'或'非关键错误'删除！");
		}
		//当录入的质量等级为关键或非关键错误或特办
		if(qualityGrade != '3' && qualityCount > 0){
			flag = false;
			alert("您好，已经有合格的质量等级，不能添加别的质量等级！");
		}
		
		//是否执行保存
		if(flag){
			var args = "contractNo="+contractNo+",reSerialNo=" + serialNoss + ",upUserName="+upUserName+",errorType="+errorType+",qualityTagging="+qualityTagging+",qualityFile="+qualityFile+",currentQG="+qualityGrade;
			var result = RunJavaMethodSqlca("com.amarsoft.app.billions.RunInTransaction", "insQualityGrade", args)
			if(result=="success"){
				as_save("myiframe0");
			}else if(result=="sysBusy"){
				alert("系统繁忙删除失败，请稍候重新操作");
			}else if(result=="sysException"){
				alert("系统异常，请稍候再试");
			}
		}
		parent.reloadSelf();
	}
    
    
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/Common/WorkFlow/PutOutApply/QualityGradeList.jsp","_self","");
	}
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
		
	/***********CCS-871 质量标注界面字段逻辑关联 add huzp 20150610******************************/
	function changeValue(object)//控制页面上下拉框操作
	{
		var a =object.value;//获得下拉框列表中值。1：关键错误。2：非关键错误。3，合格。4，待办
		if(a==1||a==2){//alert("为关键与非关键时，下面3个下拉框必填！");
			setItemValue(0, getRow(), "errorTypeName", "");//先清空选项
			setItemValue(0, getRow(), "QualityFileName", "");//先清空选项
			setItemValue(0, getRow(), "qualityTaggingName", "");//先清空选项
			
			setItemRequired(0,getRow(),"qualityTaggingName",1);
			setItemRequired(0,getRow(),"errorTypeName",1);
			setItemRequired(0,getRow(),"QualityFileName",1);
		}else if(a==3){//alert("为合格时，下面3个下拉框不可填！");
			setItemRequired(0,getRow(),"qualityTaggingName",0);
			setItemRequired(0,getRow(),"errorTypeName",0);
			setItemRequired(0,getRow(),"QualityFileName",0);

			setItemValue(0, getRow(), "errorTypeName", "");//先清空选项
			setItemValue(0, getRow(), "QualityFileName", "");//先清空选项
			setItemValue(0, getRow(), "qualityTaggingName", "");//先清空选项
		}else{//alert("为特办时，下面3个下拉框可填可不填！");
			setItemRequired(0,getRow(),"qualityTaggingName",0);
			setItemRequired(0,getRow(),"errorTypeName",0);
			setItemRequired(0,getRow(),"QualityFileName",0);
			
			setItemValue(0, getRow(), "errorTypeName", "");//先清空选项
			setItemValue(0, getRow(), "QualityFileName", "");//先清空选项
			setItemValue(0, getRow(), "qualityTaggingName", "");//先清空选项
		}
	}
	/*~[Describe=弹出多选框选择错误类型;InputParam=无;OutPutParam=无;]~*/
	function selectErrorTypeMulti() {
		var qualityGrade= getItemValue(0,getRow(),"qualityGrade");
		if(qualityGrade==""){
			alert("请选择对应质量等级!");
			return;
		}
		var qualitygradecodeno ="qualitygradecodeno,"+qualityGrade;
		
		var sRetVal = setObjectValue("SelectErrorType", qualitygradecodeno,"@qualitygradecodeno@0" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择错误类型");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "errorType", sCTypeIds.substring(0, sCTypeIds.length-1));  
		setItemValue(0, 0, "errorTypeName", SCTypeNames.substring(0, SCTypeNames.length-1));

		return;
	}
	
	/*~[Describe=弹出多选框选择文件名称;InputParam=无;OutPutParam=无;]~*/
	function selectFileNameMulti() {
		var qualityGrade= getItemValue(0,getRow(),"qualityGrade");//质量等级
		var errorType= getItemValue(0,getRow(),"errorType");//错误类型
		if(qualityGrade==""){
			alert("请选择对应质量等级!");
			return;
		}
		if(errorType==""){
			alert("请选择对应错误类型!");
			return;
		}
		var sParaString ="ATTRIBUTE7"+","+qualityGrade+","+"ATTRIBUTE8"+","+errorType;
		var sRetVal = setObjectValue("SelectFileName", sParaString,"@itemno@0@itemname@1" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择错误类型或文件名称");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "QualityFile", sCTypeIds.substring(0, sCTypeIds.length-1));  
		setItemValue(0, 0, "QualityFileName", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	/*~[Describe=弹出多选框选择质量标注;InputParam=无;OutPutParam=无;]~*/
	function selectQualityGradeMulti() {
		var qualityGrade= getItemValue(0,getRow(),"qualityGrade");//质量等级
		var errorType= getItemValue(0,getRow(),"errorType");//错误类型
		var QualityFile= getItemValue(0,getRow(),"QualityFile");//文件名称
		if(qualityGrade==""){
			alert("请选择对应质量等级!");
			return;
		}
		if(errorType==""){
			alert("请选择对应错误类型!");
			return;
		}
		if(QualityFile==""){
			alert("请选择对应文件名称!");
			return;
		}
		var sParaString ="ATTRIBUTE7"+","+qualityGrade+","+"ATTRIBUTE8"+","+errorType+","+"ATTRIBUTE6"+","+QualityFile;
		var sRetVal = setObjectValue("SelectQualityGrade", sParaString,"@itemno@0@itemname@1" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择错误类型或文件名称");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "qualityTagging", sCTypeIds.substring(0, sCTypeIds.length-1));  
		setItemValue(0, 0, "qualityTaggingName", SCTypeNames.substring(0, SCTypeNames.length-1));

		return;
	}
	/********************end**********************************************************/
	
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"artificialNo", "<%=sSerialNo%>");
			//直接通过工具类获取流水号
			setItemValue(0,0,"serialNo", "<%=DBKeyUtils.getSerialNo("qg")%>");
			//登记日期			
			setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			//登记人
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			//登记机构
			setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
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
