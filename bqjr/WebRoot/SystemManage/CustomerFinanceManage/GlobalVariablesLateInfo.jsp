<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --huzp 
		Tester:
		Content:    --后期BIB设置界面
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
 			
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%//CCS-769 关于全局变量修改为BIB设置的事宜 update huzp 20150520
	String PG_TITLE = "BIB设置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
    String GlobalVariables="GlobalVariablesLate";
	ASDataObject doTemp = new ASDataObject("GlobalVariablesLateInfo",Sqlca); 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//第一个参数："BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(GlobalVariables);
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
			{"true","","Button","保存","保存","saveAndGoBack()",sResourcesPath},
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
    
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	//20150526 update huzp
	function goBack(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesLateInfo.jsp","","right","");
		var SERIALNO = getSerialNo("BASEDATASET_INFO","SERIALNO","");
		var ATTRSTR1= getItemValue(0,getRow(),"ATTRSTR1");
		var TYPECODE="<%=GlobalVariables%>";
		var BIBVALUE=ATTRSTR1;
		var FLAG="A";
		var UPDATEORG="<%=CurUser.getOrgID()%>";
		var UPDATEUSER="<%=CurUser.getUserID()%>";
		var UPDATEDATE="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		
		var args ="SERIALNO="+SERIALNO+",TypeCode="+TYPECODE+",BibValue="+BIBVALUE+",Flag="+FLAG+",UpDateOrg="+UPDATEORG+",UpDateUser="+UPDATEUSER+",UpDateDate="+UPDATEDATE;
		RunJavaMethodSqlca("com.amarsoft.app.billions.InsertBibHistoryInfo","addBibHistoryInfo",args);
	}

	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	
	function beforeInsert(){
		var SERIALNO = getSerialNo("basedataset_info","SERIALNO","");
		setItemValue(0,0,"SERIALNO", SERIALNO);
		setItemValue(0,0,"TYPECODE", "<%=GlobalVariables%>");
		setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"TYPECODE", "<%=GlobalVariables%>");
			setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
