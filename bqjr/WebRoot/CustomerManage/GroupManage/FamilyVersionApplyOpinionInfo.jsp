<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   lyin 2012-12-20
		Tester:
		Content:  集团家谱提交复核页面
		Input Param:	  
		Output param:
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团家谱复核提交"; // 浏览器窗口标题
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//获取组件参数：集团客户ID、版本序号
	String sGroupID = CurPage.getParameter("GroupID");
	String sVersionSeq = CurPage.getParameter("VersionSeq");
	String sOldVersionSeq = CurPage.getParameter("CurrentVersionSeq");
	String sEditRight = CurPage.getParameter("EditRight");
	//将空值转化为空字符串
	if(sGroupID == null) sGroupID = "";
	if(sVersionSeq == null) sVersionSeq = "";
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	
		sTempletNo = "FamilyVersionApplyInfo";

		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		
	    doTemp.setDefaultValue("GroupID",sGroupID); //设置集团客户ID
	    doTemp.setDefaultValue("FamilySeq",sVersionSeq); 
	    doTemp.setDefaultValue("OldFamilySeq",sOldVersionSeq); 
		
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	    //dwTemp.setEvent("BeforeInsert","!CustomerManage.FamilyVersionApplyOpinionAction("+sGroupID+","+sVersionSeq+","+CurUser.getUserID()+")");
		
	    //生成HTMLDataWindow
	    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID+","+sVersionSeq);
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
			{("Readonly".equals(sEditRight)?"false":"true"),"All","Button","保存并提交复核","保存并提交复核","saveRecord()","","","",""},
			{"false","All","Button","返回","返回","returnBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	/*~[Describe=复核通过or复核退回;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()	
	{	
		var sGroupID= getItemValue(0,0,"GROUPID");
		var sVersionSeq=getItemValue(0,0,"FAMILYSEQ");
		var sSubmitOpinion=getItemValue(0,0,"SubmitOpinion");
		initSerialNo();
		as_save("myiframe0");
		if(typeof(sSubmitOpinion) != "undefined" && sSubmitOpinion != "") 
		{
			self.returnValue=checkApplyAction();
			self.close();
		}
		
	}
	
	/*~[Describe=集团家谱提交复核前更新GROUP_FAMILY_VERSION和GROUP_INFO;InputParam=无;OutPutParam=String;]~*/
	function checkApplyAction(){
		var sGroupID = "<%=sGroupID%>";
		var sVersionSeq = "<%=sVersionSeq%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sReturn = RunMethod("CustomerManage","FamilyVersionApplyOpinionAction",sGroupID+","+sVersionSeq+","+sUserID);
		if(typeof(sReturn) == "undefined" && sReturn == "") 
		{
			alert("集团家谱提交复核错误！");
			return "failed";
		}else
		{
			return "successed";
		}
	}

 	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function returnBack()
    {
    	self.close();
	} 
 	 	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "GROUP_FAMILY_OPINION";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
		setItemValue(0,getRow(),"SubmitUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"SubmitUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"SubmitDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
    }
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>