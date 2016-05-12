<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: 债权收现登记管理;
*	Input Param:
*		ObjectType:对象类型															
*		ObjectNo  :合同编号
*	Output Param:     
*        	SerialNo  :收现流水号
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "债权收现登记管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     //合同编号	
	
	String sSql="";
	String sArtificialNo="";
	String sCustomerName="";
	String sCurrency="";
	
	sSql =  "  select ArtificialNo,CustomerName,BusinessCurrency "+
   	 	 	"  from BUSINESS_CONTRACT "+
            "  where SerialNo =:SerialNo ";
   	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo)); 
   	if(rs.next()){
		//合同编号、客户名称、币种
		sArtificialNo = DataConvert.toString(rs.getString("ArtificialNo"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
		sCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
   	String sHeaders[][] = {
					{"SerialNo","收现流水号"},
					{"CashBackType","收回方式"},
					{"FormerCurrency","原币种"},
					{"ReclaimCurrency","收现币种"},
					{"ReclaimSum","收现金额(元)"},
					{"EnterAccountDate","入账日期"},			
					{"ReclaimDate","收现日期"},
					{"InputUserName","登记人"},
					{"InputOrgName","登记机构"},
					{"InputDate","登记日期"}
			       };  

	sSql = 	" select  SerialNo,"+
			" getItemName('CashBackType2',CashBackType) as CashBackType,"+
			" getItemName('Currency',FormerCurrency) as FormerCurrency,"+
			" getItemName('Currency',ReclaimCurrency) as ReclaimCurrency,"+
			" ReclaimSum,"+
			" EnterAccountDate,"+			
			" ReclaimDate,"+
			" getUserName(InputUserID) as InputUserName," +	
			" getOrgName(InputOrgID) as InputOrgName," +																																																							
			" InputDate " +	
			" from RECLAIM_INFO " +
			" where ObjectType='"+sObjectType+"' "+
			" and ObjectNo='"+sObjectNo+"' "+
			" order by InputDate desc";

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "RECLAIM_INFO";

	doTemp.setType("ReclaimSum","Number");
	//靠右
	doTemp.setAlign("ReclaimSum","3");
	
	//设置共用格式
	doTemp.setVisible("SerialNo",false);
    
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("ReclaimSum","2");
	doTemp.setHTMLStyle("CashBackType"," style={width:80px} ");
	doTemp.setHTMLStyle("FormerCurrency,ReclaimCurrency"," style={width:90px} ");
	doTemp.setHTMLStyle("SerialNo,ReclaimDate,EnterAccountDate,InputDate,InputUserName"," style={width:80px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);  //服务器分页

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
		{"true","","Button","新增","新增客户持有债券信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看客户持有债券详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除客户持有债券信息","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/CashInfo.jsp?ArtificialNo=<%=sArtificialNo%>&Currency=<%=sCurrency%>&CustomerName=<%=sCustomerName%>","_self","");
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
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/CashInfo.jsp?SerialNo="+sSerialNo+"&ArtificialNo=<%=sArtificialNo%>&Currency=<%=sCurrency%>&CustomerName=<%=sCustomerName%>","_self","");
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

<%@include file="/IncludeEnd.jsp"%>
