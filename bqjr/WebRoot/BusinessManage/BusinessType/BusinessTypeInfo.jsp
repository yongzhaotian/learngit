<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --产品管理详情
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
	String PG_TITLE = "新增产品基本配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//产品类型
	String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
	String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));
	if(null == sProductType) sProductType = "";
	if(null == sSubProductType) sSubProductType = "";
    
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("BusinessTypeInfo",Sqlca);
	
	//add 现金贷需求
	doTemp.setReadOnly("productType",true);
	if("020".equals(sProductType)){ 
		doTemp.setVisible("productCategoryID",false);
		doTemp.setRequired("productCategoryID",false);
	}
	//end
	
	if( "7".equals(sSubProductType) ){	//学生消费贷显示产品子类型， add by dahl 
		doTemp.setVisible("SubProductType",true);
		doTemp.setVisible("ProductType",false);
	}
	
	doTemp.appendHTMLStyle("TypeNo"," onBlur=\"javascript:parent.checkTypeNo()\" ");
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
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		var sUnique = RunMethod("Unique","uniques","business_type,count(1),typeNo='"+sTypeNo+"'");
		var sFlag=checkTypeNo(sTypeNo);
		if(!sFlag) return;
		if(bIsInsert && sUnique=="1.0"){
			alert("该产品代码已经被占用,请输入新的产品代码");
			return;
		}
		bIsInsert = false;
	    as_save("myiframe0");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/BusinessManage/BusinessType/BusinessTypeList.jsp","_self","");

	}
     
    function checkTypeNo(sTypeNo){
    	var sTypeNo =getItemValue(0,getRow(),"TypeNo");
    	 var strExp=/^[A-Za-z0-9]+$/;
		 if(strExp.test(sTypeNo)){
		    return true;
		}else{
			alert("产品代码必须是数字或字母！");
		    return false;
		}
    }
	/*~[Describe=弹出多选框选择商品范畴;InputParam=无;OutPutParam=无;]~*/
	function selectProductCategoryMulti() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择商品范畴！");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "productCategory", sCTypeIds.substring(0, sCTypeIds.length-1));  //商品范畴ID
		setItemValue(0, 0, "productCategoryID", SCTypeNames.substring(0, SCTypeNames.length-1));//商品范畴名称
		return;
	}
	
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"productType","<%=sProductType%>");//add 现金贷需求
			setItemValue(0,0,"CreditAttribute", "0002");
			setItemValue(0,0,"Attribute3", "1");
			//update 现金贷需求
			if("020" == "<%=sProductType%>")
			{
				setItemValue(0,0,"ContractDetailNo", "ContractInfo1212");
			}else
			{
				setItemValue(0,0,"ContractDetailNo", "ContractInfo1210");
			}
			//end
			//ccs-733 学生消费贷  add by dahl
			if( "7" == "<%=sSubProductType%>"){
				setItemValue(0,0,"SubProductType", "7");
			}
			//end by dahl
			setItemValue(0,0,"SortNo", getSerialNo("business_type", "SortNo", " "));
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bCheckBeforeUnload = false;
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
