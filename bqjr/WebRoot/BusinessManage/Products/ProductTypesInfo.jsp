<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --新增产品系列
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
	String PG_TITLE = "新增产品系列"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
    //产品类型
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
    if(null == sProductType) sProductType = "";
  //产品子类型
    String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));
    if(null == sSubProductType) sSubProductType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("ProductTypesInfo",Sqlca);
	//add by  ybpan CCS-583 --CCS-583  ----车主、无预约现金贷仍需绑定业务员绑定产品/销售代表后才能出单
    // 如果是现金贷的话，就把现金贷主类型字段隐藏，把子类型显示
	if("020".equals(sProductType) || "7".equals(sSubProductType) ){	//学生消费贷显示产品子类型， edit by dahl 
		doTemp.setVisible("SubProductType",true);
		doTemp.setVisible("ProductType",false);
	}
	//end by ybpan CCS-583 --CCS-583 at 20150411
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
		var productID  = getItemValue(0,getRow(),"productID");
		var sUnique = RunMethod("Unique","uniques","Product_Types,count(1),productID='"+productID+"'");
		if(bIsInsert && sUnique=="1.0"){
			alert("该产品编号已经被占用,请输入新的编号");
			return;
		}
		
		bIsInsert = false;
	    as_save("myiframe0");

	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/BusinessManage/Products/ProductTypesList.jsp","_self","");


	}
    
	/*~[Describe=检验插入数据唯一性;InputParam=;OutPutParam=是否有记录;]~*/
    function beforeSave()
    {
    	var productID  = getItemValue(0,getRow(),"productID");
		var sPara = "TypeNo=" + productID;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.product.BusinessTypeUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"productID");
	    parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			//setItemValue(0,0,"productID", getSerialNo("Product_Types", "productID", " "));
			setItemValue(0,0,"productID", "<%=DBKeyHelp.getSerialNoXD("Product_Types", "productID", "yyyyMMdd", "000", new  Date(), Sqlca)%>");
			setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"updateUser","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"updateOrg","<%=CurOrg.orgID %>");
			setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"updateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ProductType","<%=sProductType%>");//add 现金贷需求
			setItemValue(0,0,"SubProductType","<%=sSubProductType%>");//产品子类型   add by ybpan   CCS-583   --车主、无预约现金贷仍需绑定业务员绑定产品/销售代表后才能出单
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
