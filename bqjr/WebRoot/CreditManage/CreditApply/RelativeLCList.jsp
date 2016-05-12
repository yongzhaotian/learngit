<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: 相关信用证信息
		Input Param:
			ObjectType: 阶段编号
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "相关信用证信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%


/*	String sHeaders[][] = {	{"SerialNo","流水号"},
							{"LCNo","信用证编号"},
							{"LCTypeName","信用证类型"},
							{"IssueBank","开证行"},
	                        {"IssueState","开证国家"},
							{"IssueDate","开立日期"},
							{"Purpose","用途"},
							{"Applicant","申请人名称"},
	                        {"ApplicantAddress","申请人地址"},
							{"Beneficiary","收益人名称"},
							{"BeneficiaryAddress","收益人地址"},
	                        {"LCCurrencyName","信用证币种"},
							{"LCSum","信用证金额"},
	                        {"ImportCargo","进口货物"},
							{"Exporter","进口国"},
							{"VouchType","担保方式"},
							{"LoadingDate","信用证装期"},
	                        {"ValidDate","信用证效期"},
							{"DocumentDate","信用证交单期"},
							{"OrgName","登记机构"},
							{"UserName","登记人"}
	                       }; 


	String sSql =  " select "+
			" ObjectType,ObjectNo,SerialNo,LCNo,"+
			" getItemName('Currency',LCCurrency) as LCCurrencyName,LCSum,"+
			" InputUserID,getUserName(InputUserID) as UserName,InputOrgID,"+
			" getOrgName(InputOrgID) as OrgName"+
			" from LC_INFO "+
	     	" where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' ";
*/
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject("RelativeLCList",Sqlca);
/*	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LC_INFO";
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//设置不可见项
	doTemp.setVisible("InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	doTemp.setUpdateable("",false);
	doTemp.setAlign("LCSum","3");
	doTemp.setCheckFormat("LCSum","2");
*/
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","新增","新增信用证信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看信用证详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除信用证信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/CreditManage/CreditApply/RelativeLCInfo.jsp","_self","");
	}


	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			OpenPage("/CreditManage/CreditApply/RelativeLCInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
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
