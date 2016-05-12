<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产品类型配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//产品类型
	String sInsuranceNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));

	if(null == sInsuranceNo) sInsuranceNo = "";
	if(null == sFlag) sFlag = "";

	String sSerialNo = DBKeyHelp.getSerialNo("INSURANCECITY_INFO","SerialNo",Sqlca);

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("InsuranceAddProductType",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	if("addProduct".equals(sFlag)){
		doTemp.WhereClause += " and itemno not in (select distinct(subproducttype) from insurancecity_info where insuranceno ='"+sInsuranceNo+"' and subproducttype is not null)";
	}
	if("addCity".equals(sFlag)){
		doTemp.WhereClause += " and itemno in (select distinct(subproducttype) from insurancecity_info where insuranceno ='"+sInsuranceNo+"' and subproducttype is not null)";
	}
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
			{"true","","Button","提交新增","提交新增","doSubmitAddProduct()",sResourcesPath},
			{"true","","Button","返回","返回产品配置","saveRecordAndBackProduct()",sResourcesPath},
			{"true","","Button","添加产品关联城市","添加产品关联城市","doAddCity()",sResourcesPath},
			{"true","","Button","返回","返回城市配置","BackCity()",sResourcesPath}

		    };
    if("addProduct".equals(sFlag)){
	    sButtons[2][0]="false";
	    sButtons[3][0]="false";   
    }else if("addCity".equals(sFlag)){
	    sButtons[0][0]="false";
	    sButtons[1][0]="false";  
    }
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function doSubmitAddProduct(){
	    var	sItemNo=getItemValue(0,getRow(),"ItemNo");
		var sInsuranceNo = <%=sInsuranceNo%>;
		var sSerialNo = <%=sSerialNo%>;

		if(typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("请选择要添加的产品类型！");
			return;
		}
		if(confirm("您确定新增吗？")){
			RunMethod("InsertInsuranceProduct","DoInsert",sSerialNo+","+sInsuranceNo+","+sItemNo); 
			as_save("myiframe0"); 
		}
		saveRecordAndBackProduct();
	}
	function doAddCity(){
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		var sInsuranceNo = <%=sInsuranceNo%>;
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("请选择要添加的产品类型！");
			return;
		}
		PopPage("/BusinessManage/BusinessType/AddInsuranceCity.jsp?insuranceNo="+sInsuranceNo+"&subproductType="+sItemNo,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");      
		self.close();
	}
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBackProduct()
	{
		OpenPage("/BusinessManage/BusinessType/InsuranceProductList.jsp","_self","");
	}   
	function BackCity()
	{
		self.close();
	}   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	

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
