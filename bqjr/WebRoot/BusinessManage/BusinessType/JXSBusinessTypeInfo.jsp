<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --新增产品信息
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
	String PG_TITLE = "新增产品信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("JXSBusinessTypeInfo",Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//第一个参数："BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"
	dwTemp.setEvent("AfterInsert","!ProductManage.CreateProductVersion(#TypeNo,V1.0,"+CurUser.getUserID()+")+!ProductManage.StartNewVersion(#TypeNo,V1.0,1)");//

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
		var sTypeNo  = getItemValue(0,getRow(),"TypeNo");
		bIsInsert = false;
	    as_save("myiframe0");
	    var sUnique = RunMethod("Unique","uniques","business_type,count(1),typeNo='"+sTypeNo+"'");
	    if(sUnique=="1.0"){
	    	popComp("JXSBusinessTypeInfo1","/BusinessManage/BusinessType/JXSBusinessTypeInfo1.jsp","typeNo="+sTypeNo,"");
	    	window.close();			
	    }
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
        window.close();

	}
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"", "");
			setItemValue(0,0,"CreditAttribute", "0003");
			setItemValue(0,0,"TypeNo", getSerialNo("business_type", "TypeNo", " "));
			setItemValue(0,0,"effectiveStartDate", "<%=StringFunction.getToday()%>");
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
