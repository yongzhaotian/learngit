<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: XWu 2004-12-04
*	Tester:
*	Describe: 未分发不良资产信息列表
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :保全部管理员ID
*   		SerialNo	:合同流水号
*		sShiftType	:移交类型
*	
	HistoryLog:slliu 2004.12.17
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未分发不良资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSerialNo = "" ;    
	String sItemID = "" ; 
	String sFlag = "" ; 
	String sQueryFlag = "" ; 
	String sSql ="";

	//获得页面参数
	//获得组件参数
	//申请流水号	
	sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	//列表标识
	sItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sItemID==null) sItemID="";
	
	//标识Flag=ReformCredit表示查看重组贷款详情
	sFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	
	//标识QueryFlag=Query表示从快速查询进入查看重组贷款详情
	sQueryFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("QueryFlag"));
	if(sQueryFlag==null) sQueryFlag="";
	
	
	String sHeaders[][] = {
				{"SerialNo","合同流水号"},
				{"ArtificialNo","合同编号"},
				{"BusinessTypeName","业务品种"},
				{"OccurTypeName","发生类型"},
				{"CustomerName","客户名称"},
				{"BusinessCurrencyName","币种"},
				{"BusinessSum","金额(元)"},
				{"ShiftBalance","移交余额(元)"},
				{"Balance","当前余额(元)"},
				{"Maturity","到期日期"},				
				{"ClassifyResultName","五级分类"},
				{"ShiftTypeName","移交类型"},
				{"ManageUserName","原管户人"},
				{"ManageOrgName","原管户机构"}
			}; 
	
	if(sFlag.equals("ReformCredit")) //表示查看重组贷款详情
	{
		sSql = 	" select BC.SerialNo as SerialNo,BC.ArtificialNo as ArtificialNo," + 	
			   	" BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
			   	" getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
			 	" BC.CustomerName as CustomerName," + 
			 	" getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
			 	" BC.BusinessSum as BusinessSum,BC.Balance as Balance," + 
			 	" BC.FinishDate as FinishDate,BC.ClassifyResult as ClassifyResult,BC.Maturity as Maturity," +  
			 	" getUserName(BC.ManageUserID) as ManageUserName, " + 
			 	" getUserName(BC.ManageOrgID) as ManageOrgName " + 			
			 	" from BUSINESS_CONTRACT BC ,CONTRACT_RELATIVE CR " +		
			 	" where BC.SerialNo = CR.SerialNo "+			
			 	" and  CR.ObjectType = 'NPAReformApply' " +
			 	" and CR.ObjectNo = '"+sSerialNo+"' " ;
	
	}
	else
	{
 		sSql = " select SerialNo,ArtificialNo," + 	
			   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
			   " getItemName('OccurType',OccurType) as OccurTypeName," + 
			   " CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
			   " BusinessSum,ShiftBalance,Balance,Maturity, "+
			   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
			   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
			   " getUserName(ManageUserID) as ManageUserName," + 
			   " getOrgName(ManageOrgID) as ManageOrgName" + 
			   " from BUSINESS_CONTRACT " +
			   " Where  SerialNo in (select ObjectNo from APPLY_RELATIVE where SerialNo='"+sSerialNo+"' and ObjectType='BusinessContract') "+
			   " order by SerialNo desc,ArtificialNo " ;
	}
	//out.println(sSql);	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("ArtificialNo,ShiftType,BusinessType,FinishType,FinishDate,ClassifyResult",false);
    
	//设置更新表
	//doTemp.UpdateTable = "BUSINESS_CONTRACT";

	//设置选项双击及行宽	
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum","3");
	
	//生成查询框
	doTemp.setColumnAttribute("ArtificialNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
				{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
				{"true","","Button","申请详情","查看申请详情","viewApply()",sResourcesPath},
				{"true","","Button","返回","返回上一页面","goBack()",sResourcesPath}
		};
	
	if(!sFlag.equals("ReformCredit")) //表示查看重组贷款详情
	{
		sButtons[1][0]="false";
	}
	
	if(sQueryFlag.equals("Query")) //表示从快速查询进入查看重组贷款详情
	{
		sButtons[2][0]="false";
	}

%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	
	function mySelectRow()
	{ 
		if(myiframe0.event.srcElement.tagName=="BODY") return;
		setColor();		
	}
	
	//重组申请信息
	function viewApply()
	{
		//获得合同流水号
		var sContractNo=getItemValue(0,getRow(),"SerialNo");  //合同流水号或对象编号
		
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}

		sReinforceFlag = RunMethod("信息补登","GetReinforceFlag",sContractNo);
		if(sReinforceFlag == '020' || sReinforceFlag == '120'){
			alert("补登完成的合同不能查看申请详情！");
			return;
		}
		
		var sReturn = PopPageAjax("/RecoveryManage/NPAManage/NPAReform/NPAReformActionAjax.jsp?ContractNo="+sContractNo+"&Flag=ReformApply","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		
		if(typeof(sReturn) != "undefined" && sReturn.length != 0 && sReturn != '')
		{
			
			var sObjectNo = sReturn;
			var sObjectType = 'CreditApply';
			
			openObject(sObjectType,sObjectNo,"002");
		}
	}
    	
		
	/*~[Describe=返回;InputParam=无;OutPutParam=SerialNo;]~*/
	function goBack()
	{
		OpenComp("NPAReformList","/RecoveryManage/NPAManage/NPAReform/NPAReformList.jsp","ComponentName=重组方案列表&ComponentType=MainWindow&ItemID=<%=sItemID%>","right",OpenStyle);
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
