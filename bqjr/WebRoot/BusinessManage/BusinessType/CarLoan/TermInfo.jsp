<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --期限参数
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
	String PG_TITLE = "期限参数"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数
	String sTypeNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
	String sCurItemID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("curItemID"));	
	if(sCurItemID==null)  sCurItemID="";
	if(sTypeNo==null) sTypeNo="";
	String sTempletNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	if(sCurItemID.equals("01")){
		sTempletNo = "TermInfo";
	}else{
		sTempletNo = "TermInfo1";
	};
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setUnit("loanFixedRate,highestFixedRate,shouFuRatio,floatingRate,sectionRatio,dealerCommissionRate,salesCommission,discountFixedRate,sectionFixedRate,salvageRate,BondRate", "%");
	doTemp.setAlign("loanFixedRate,highestFixedRate,shouFuRatio,floatingRate,sectionRatio,dealerCommissionRate,salesCommission,discountFixedRate,sectionFixedRate,salvageRate,BondRate", "3");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
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
			{"true","","Button","返回","返回","back()",sResourcesPath}

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
		var sTerm =getItemValue(0,getRow(),"term");
		var sUnique = RunMethod("Unique","uniques","term,count(1),term='"+sTerm+"' and typeNo='<%=sTypeNo %>'");
		if(bIsInsert && sUnique>="1.0"){
			alert("该期限已存在,请输入新的期限！！");
			return;
		}
	    as_save("myiframe0");
	    OpenComp("","/BusinessManage/BusinessType/CarLoan/TermList.jsp","typeNo=<%=sTypeNo%>&curItemID=<%=sCurItemID%>","right");
	}
    
    function back(){
		OpenPage("/BusinessManage/BusinessType/CarLoan/TermList.jsp","_self","");
    }

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
		setItemValue(0,0,"termID", getSerialNo("term", "termID", " "));
		setItemValue(0,0,"typeNo", "<%=sTypeNo%>");
		setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID%>");
		setItemValue(0,0,"inputOrgName", "<%=CurOrg.orgName%>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.orgID%>");
		setItemValue(0,0,"updateOrgName", "<%=CurOrg.orgName%>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
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
