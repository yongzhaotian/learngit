<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-29
		Tester:
		Describe: 最终审批意见拟引入的担保合同所对应的保证人基本信息详情;
		Input Param:
			ObjectType：对象类型
			ObjectNo: 对象编号
			ContractNo: 担保信息编号
			GuarantyID：保证编号			
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "保证人基本信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";//--模板号码
	String sTempletFilter = "";//模板过滤变量
	String sSql = "";//Sql语句
	String sGuarantyType = "";//担保类型	
	
	//获得页面参数：对象类型、对象编号、担保信息编号、保证编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractNo"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyID"));
	
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractNo == null) sContractNo = "";
	if(sGuarantyID == null) sGuarantyID = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%		        
	//获取担保信息中的担保类型
	sSql ="select GuarantyType from GUARANTY_CONTRACT where SerialNo =:SerialNo";
	sGuarantyType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sContractNo));
	//将空值转化为空字符串
	if(sGuarantyType == null) sGuarantyType = "";
	
	//根据担保类型取得显示模版号
	if(sGuarantyType.equals("010010")){	//保证 		
		sSql = "select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030010'";
	}else if(sGuarantyType.equals("010020")){	//履约保险保证		
		sSql = "select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030020'";
	}else if(sGuarantyType.equals("010030")){	//保函保证		
		sSql = "select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030030'";
	}else if(sGuarantyType.equals("010040")){	//保证金      		
		sSql = "select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030040'";
	}
	sTempletNo = Sqlca.getString(sSql);	
	//将空值转化为空字符串
	if(sTempletNo == null) sTempletNo = "";
	
	//设置过滤条件	
	sTempletFilter = " (ColAttribute like '%BusinessContract%' ) ";

	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
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
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/GuarantyManage/ApproveGuarantorList2.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo=<%=sContractNo%>","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
