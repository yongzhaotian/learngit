<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ������ͳ��ҳ��
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog: 20150829 jiangyuanlin �Ż��汾ȥ������������ѯ����
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sCreditAttribute = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreditAttribute"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	System.out.println("-----------1111---------------"+sCreditAttribute);
	System.out.println("------------222222--------------"+sSerialNo);
	
	if(sCreditAttribute == null) sCreditAttribute = "";
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%


	String sHeaders[][] = {	{"NowTime","��ǰʱ��"},
	                        {"AuditSum","�ȴ���˵ĵ���"},
							{"EndTimeTen","��ȥ10��������ĵ���"},
							{"EndTime","��ȥ60��������ĵ���"},
							{"MaxiMum","���ȴ�ʱ��"},
// 							{"OnLineSum","��ǰ���ߵ������Ա����"},
							{"DoSubmitSum","��ǰ���۵����ύ��ͬ����"}                      //add by clhuang 2015/07/20 CCS-876 ��ʾ������Ա���յ�ʱ�ύ�����к�ͬ����Ŀ
	                       }; 
	String AuditSum="";
	String MaxiMum="";
	String OnLineSum="";
	//��˲����ز���ͬ�û���¼ʱ��ͬ�Ĳ�ѯ  update huzp 20150611
	if(CurUser.getOrgID().equals("10")){//��ز���¼��ִ��ֻ��ѯ��CEר����˵ĵ���
		 AuditSum =Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1', 'NCIIC_AUTO', 'WF_OFFICETEST', 'RESUBMITTION', 'TEST1') and FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename = 'CEר�����' ");
		 MaxiMum=	Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy/mm/dd HH24:MI:SS')) * 60 * 24), 0)) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and bc.contractstatus <> '100' and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename = 'CEר�����'  ) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' ");	
// 		 OnLineSum=Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '101%') and isCar = '02') group by userid)");		

	}else if(CurUser.getOrgID().equals("11")){//��˲���¼��ִ��ֻ��ѯ�����רԱ�ĵ���
		 AuditSum =Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1', 'NCIIC_AUTO', 'WF_OFFICETEST', 'RESUBMITTION', 'TEST1') and FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename not in('CEר�����','�Զ�������ͣ')");
		 MaxiMum=	Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy/mm/dd HH24:MI:SS')) * 60 * 24), 0)) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and bc.contractstatus <> '100' and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename not in('CEר�����','�Զ�������ͣ')) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' ");	
// 		 OnLineSum=Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02') group by userid)");		
	}else{//�������Ȩ��������ҳ�汨����ѯ�����еĵ���
		 AuditSum =Sqlca.getString("select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1', 'NCIIC_AUTO', 'WF_OFFICETEST', 'RESUBMITTION', 'TEST1') and FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020' ");
		 MaxiMum  =Sqlca.getString("select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy/mm/dd HH24:MI:SS')) * 60 * 24), 0)) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='') and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='') and bc.contractstatus <> '100' and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002') a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020' ");	
// 		 OnLineSum=Sqlca.getString("select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo in ('101','102')) and isCar = '02') group by userid)");		
	}
	//String sSql = " select NowTime,AuditSum,EndTimeTen,EndTime,MaxiMum,OnLineSum from dept_count_vw ";
	String EndTimeTen =Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 10 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')");
	String EndTime =Sqlca.getString("select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.phaseopinion4 is not null and f.phasetype = '1010' and f.phaseopinion4 <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.phaseopinion4 >= to_char(sysdate - 60 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')");
	//add by clhuang 2015/07/20 CCS-876 ��ʾ������Ա���յ�ʱ�ύ�����к�ͬ����Ŀ
	String DoSubmitSum = Sqlca.getString("select count(1) from business_contract bc, batch_bc_engine bbe where bc.serialno = bbe.CONTRACTNO and SUBSTR(bbe.inputdate, 0, 10) = to_char(sysdate, 'yyyy/mm/dd')");
	System.out.println("======AuditSum:"+AuditSum+"&&&&&&&&&EndTimeTen:"+EndTimeTen+"#########EndTime:"+EndTime+"@@@@@@@@@@@@MaxiMum="+MaxiMum+"***********OnLineSum="+OnLineSum+"----------------------DoSubmitSum="+DoSubmitSum);

	/*
	String sSql = " select to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') as NowTime," + 
					"(select count(1) from FLOW_TASK FT, BUSINESS_CONTRACT BC where FT.ObjectType = 'BusinessContract' and FT.Objectno = BC.Serialno and FT.FlowNo in ('WF_MEDIUM02', 'WF_HARD02', 'WF_EASY02', 'WF_MEDIUM', 'WF_HARD',  'WF_EASY',  'WF_EASY03', 'WF_Fork', 'NCIIC_AUTO15', 'CreditFlow', 'CashLoanFlow', 'WF_NCL1', 'WF_CCCL','CE_RRefenrence_2','CE_REJECTINFERENCE1') and FT.GroupInfo like '%110003%' and FT.UserID is null and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '') and ft.phasetype ='1020'  and ft.phasename <> 'CEר�����'  ) as AuditSum," + 
					"(select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.begintime >= to_char(sysdate - 10 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')  and f.phaseno = '0010') as EndTimeTen," + 
					"(select count(1) from flow_task f, business_contract b where f.objectno = b.serialno and f.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and f.begintime >= to_char(sysdate - 60 / 24 / 60, 'yyyy/mm/dd HH24:MI:SS')  and f.phaseno = '0010') as EndTime," + 
					"(select trunc(nvl(max((sysdate - to_date(begintime, 'yyyy-mm-dd hh24:mi:ss')) * 60 * 24), 0), 2) from flow_task t, (select ft.objectno as objectno from flow_task ft, business_contract bc where bc.serialno = ft.objectno and ft.objecttype = 'BusinessContract' and ft.phasetype ='1020'  and (ft.UserID is null or ft.UserID = '') and (FT.EndTime is null or FT.EndTime = ' ' or FT.EndTime = '')  and ft.flowno <> 'CreditFlow'  and ft.phaseopinion1 is null  and CreditAttribute = '0002'  and ft.phasename <> 'CEר�����'  ) a where t.objectno = a.objectno  and t.serialno = (select max(serialno) from flow_task where objectno = a.objectno) and t.phasetype ='1020'  ) as MaxiMum,"+ 
					"(select count(1)  from (select count(1) from user_list ul  where ul.begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and ul.begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and ul.endtime is null and ul.userid in (select userid from USER_INFO  where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02') group by userid)) as OnLineSum " + 
					" from dual ";*/
	String sSql = " select to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') as NowTime,'"+AuditSum+"' as AuditSum,'"+EndTimeTen+"' as EndTimeTen,'"+EndTime+"' as EndTime,'"+MaxiMum+"' as MaxiMum,'"+DoSubmitSum+"' as DoSubmitSum from dual ";				
					
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//doTemp.UpdateTable = "LC_INFO";
	//doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	//doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//���ò��ɼ���
	//doTemp.setVisible("InputOrgID,InputUserID",false);
	//doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	//doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	//doTemp.setUpdateable("",false);
	//doTemp.setAlign("LCSum","3");
	//doTemp.setCheckFormat("LCSum","2");

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"false","","Button","����","�鿴ó�׵�������","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ��ó�׵�����Ϣ","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		/* OpenPage("/CreditManage/CreditApply/RelativeAllLCInfo.jsp?Templet=SecuritiesInfo","_self",""); */ //SecuritiesInfo�Ƿ���ģ��
	}


	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		/* SecuritiesInfoΪ����ģ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
