<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Describe: 出账信息中的票据信息列表
		Input Param:
		Output Param:		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "商品范畴 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
    if(sBusinessType == null) sBusinessType = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>

<%

	String sSql1="";
	String sProductcategory="";
	String[] sProductcategorys;
	
	StringBuffer sb=new StringBuffer();
	ASResultSet rs =null;
	SqlObject so;
	//根据组合计提转单项计提的申请流水号，在表RESERVE_COMPTOSIN取得会计月份和借据号
	sSql1 = "select productcategory from business_type where typeno=:BusinessType";
	so = new SqlObject(sSql1).setParameter("BusinessType", sBusinessType);
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		sProductcategory = rs.getString("productcategory");
		sProductcategorys=sProductcategory.split(",");
		for(int i=0;i<sProductcategorys.length;i++){
			sb.append("'");
			sb.append(sProductcategorys[i]);
			sb.append("'");
			sb.append(",");
		}
	}
	rs.getStatement().close();
	sProductcategory=sb.toString().substring(0, sb.toString().lastIndexOf(","));    


	String sHeaders[][] = {	{"productcategoryid","范畴编号"},
							{"productcategoryname","范畴名称"}
	                       }; 
	String sSql = " select productcategoryid,productcategoryname from product_category where "
			   +"productcategoryid in ("+sProductcategory+")";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo,PutoutNo",true);	 //为后面的删除
//	doTemp.multiSelectionEnabled=true;
	
	//设置金额为三位一逗数字
//	doTemp.setType("BillSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
//	doTemp.setCheckFormat("BillSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
//	doTemp.setAlign("BillSum","3");
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
    
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
		{"true","","Button","确定","确定","doSubmit()",sResourcesPath},
		{"true","","Button","取消 ","取消","doNo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/BillInfo.jsp","_self","");
	}

	function doSubmit(){
		var sProductcategoryid = getItemValue(0,getRow(),"productcategoryid");
		var sProductcategoryname = getItemValue(0,getRow(),"productcategoryname");
		if(typeof(sProductcategoryid) == "undefined" || sProductcategoryid == "")
		{
			alert("请选择一条!");
			return;
		}
		top.returnValue=sProductcategoryid+"@"+sProductcategoryname;
		top.close();
	}
	
	function doNo(){
		top.returnValue = "_CANCEL_";
		top.close();
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
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
