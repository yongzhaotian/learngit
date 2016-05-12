<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 工作量统计页面
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
		
		HistoryLog: 20150829 jiangyuanlin 优化版本去掉在线人数查询功能
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "工作量统计"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sCreditAttribute = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreditAttribute"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	System.out.println("-----------1111---------------"+sCreditAttribute);
	System.out.println("------------222222--------------"+sSerialNo);
	
	if(sCreditAttribute == null) sCreditAttribute = "";
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%


	String sHeaders[][] = {	{"NowTime","当前时间"},
	                        {"AuditSum","等待审核的单量"},
							{"EndTimeTen","过去10分钟申请的单量"},
							{"EndTime","过去60分钟申请的单量"},
							{"MaxiMum","最大等待时长"},
// 							{"OnLineSum","当前在线的审核人员数量"},
							{"DoSubmitSum","当前销售当日提交合同总数"}                      //add by clhuang 2015/07/20 CCS-876 显示销售人员当日当时提交的所有合同总数目
	                       }; 
	String AuditSum="";
	String MaxiMum="";
	String OnLineSum="";
	//审核部与风控部不同用户登录时不同的查询  update huzp 20150611
	if(CurUser.getOrgID().equals("10")){//风控部登录后执行只查询出CE专家审核的单量
		 AuditSum =Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1', 'NCIIC_AUTO', 'WF_OFFICETEST', 'RESUBMITTION', 'TEST1') and FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename = 'CE专家审核' ");
		 MaxiMum=	Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy/mm/dd HH24:MI:SS')) * 60 * 24), 0)) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and bc.contractstatus <> '100' and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename = 'CE专家审核'  ) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' ");	
// 		 OnLineSum=Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '101%') and isCar = '02') group by userid)");		

	}else if(CurUser.getOrgID().equals("11")){//审核部登录后执行只查询出审核专员的单量
		 AuditSum =Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1', 'NCIIC_AUTO', 'WF_OFFICETEST', 'RESUBMITTION', 'TEST1') and FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename not in('CE专家审核','自动审批暂停')");
		 MaxiMum=	Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy/mm/dd HH24:MI:SS')) * 60 * 24), 0)) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and bc.contractstatus <> '100' and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename not in('CE专家审核','自动审批暂停')) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' ");	
// 		 OnLineSum=Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02') group by userid)");		
	}else{//否则避免权限配错造成页面报错。查询出所有的单量
		 AuditSum =Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1', 'NCIIC_AUTO', 'WF_OFFICETEST', 'RESUBMITTION', 'TEST1') and FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020' ");
		 MaxiMum  =Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy/mm/dd HH24:MI:SS')) * 60 * 24), 0)) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and bc.contractstatus <> '100' and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002') a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' ");	
// 		 OnLineSum=Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo in ('101','102')) and isCar = '02') group by userid)");		
	}
	//String sSql = " select NowTime,AuditSum,EndTimeTen,EndTime,MaxiMum,OnLineSum from dept_count_vw ";
	String EndTimeTen =Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 10 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')");
	String EndTime =Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 60 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')");
	//add by clhuang 2015/07/20 CCS-876 显示销售人员当日当时提交的所有合同总数目
	String DoSubmitSum = Sqlca.getString("select count(1) from business_contract bc, batch_bc_engine bbe where bc.serialno = bbe.CONTRACTNO and SUBSTR(bbe.inputdate, 0, 10) = to_char(sysdate, 'yyyy/mm/dd')");
	System.out.println("======AuditSum:"+AuditSum+"&&&&&&&&&EndTimeTen:"+EndTimeTen+"#########EndTime:"+EndTime+"@@@@@@@@@@@@MaxiMum="+MaxiMum+"***********OnLineSum="+OnLineSum+"----------------------DoSubmitSum="+DoSubmitSum);

	/*
	String sSql = " select to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') as NowTime," + 
					"(select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1') and FT.GroupInfo like '%110003%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename <> 'CE专家审核'  ) as AuditSum," + 
					"(select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.begintime >= to_char(sysdate - 10 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')  and f.phaseno = '0010') as EndTimeTen," + 
					"(select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.begintime >= to_char(sysdate - 60 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')  and f.phaseno = '0010') as EndTime," + 
					"(select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy-mm-dd hh24:mi:ss')) * 60 * 24), 0), 2) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename <> 'CE专家审核'  ) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020'  ) as MaxiMum,"+ 
					"(select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02') group by userid)) as OnLineSum " + 
					" from dual ";*/
	String sSql = " select to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') as NowTime,'"+AuditSum+"' as AuditSum,'"+EndTimeTen+"' as EndTimeTen,'"+EndTime+"' as EndTime,'"+MaxiMum+"' as MaxiMum,'"+DoSubmitSum+"' as DoSubmitSum from dual ";				
					
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//doTemp.UpdateTable = "LC_INFO";
	//doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //为后面的删除
	//设置不可见项
	//doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//设置不可见项
	//doTemp.setVisible("InputOrgID,InputUserID",false);
	//doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	//doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	//doTemp.setUpdateable("",false);
	//doTemp.setAlign("LCSum","3");
	//doTemp.setCheckFormat("LCSum","2");

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
		{"false","","Button","详情","查看贸易单据详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除贸易单据信息","deleteRecord()",sResourcesPath}
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
		/* OpenPage("/CreditManage/CreditApply/RelativeAllLCInfo.jsp?Templet=SecuritiesInfo","_self",""); */ //SecuritiesInfo是废弃模板
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
		/* SecuritiesInfo为废弃模板
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			OpenPage("/CreditManage/CreditApply/RelativeAllLCInfo.jsp?Templet=SecuritiesInfo&SerialNo="+sSerialNo, "_self","");
		} */
	}
	
	
	function initRow(){
		setTimeout("reloadSelf()", "60000");
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

<%@	include file="/IncludeEnd.jsp"%>
