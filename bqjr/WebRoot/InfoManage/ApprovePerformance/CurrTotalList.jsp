<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 2006-12-28
		Tester:
		Content: ֧��Ŀǰ�ۼ�������Ч��ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ŀǰ�ۼ�������Ч��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;Ŀǰ�ۼ�������Ч��ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ��ǰ����
	String sCurDate = StringFunction.getToday();
	//��ȡǰʮ�������
	String sBeforeDate =  StringFunction.getRelativeDate(sCurDate,-10);
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"StatisticDate","ͳ������"},
							{"OrgName","��������������"},
							{"UserName","����������"},
							{"CApplySum","Ŀǰ�ۼ������ܽ�Ԫ��"},
							{"CurrDealCount","Ŀǰ����������"},
							{"CurrDealSum","Ŀǰ��������Ԫ��"},
							{"CAggreeCount","Ŀǰ�ۼ���׼�ܱ���"},
							{"CDisagreeCount","Ŀǰ�ۼƷ���ܱ���"},
							{"CAfloatCount","Ŀǰ�ۼ���;�ܱ���"},
							{"CAggreeTime","Ŀǰ�ۼ���׼�ܺ�ʱ���죩"},										
							{"CDisagreeTime","Ŀǰ�ۼƷ���ܺ�ʱ���죩"},
							{"CAfloatTime","Ŀǰ�ۼ���;�ܺ�ʱ���죩"},
							{"CNApproveCount","Ŀǰ�ۼ�δǩ�����ܱ���"},
							{"CNApproveSum","Ŀǰ�ۼ�δǩ�����ܽ�Ԫ��"},
							{"CNContractCount","Ŀǰ�ۼ�δǩ��ͬ�ܱ���"},
							{"CNContractSum","Ŀǰ�ۼ�δǩ��ͬ�ܽ�Ԫ��"},
							{"CNPutoutCount","Ŀǰ�ۼ�δ�Ŵ��ܱ���"},
							{"CNPutoutSum","Ŀǰ�ۼ�δ�Ŵ��ܽ�Ԫ��"},
							{"CNormalSum","Ŀǰ�ۼ���������Ԫ��"},
							{"CAttentionSum","Ŀǰ�ۼƹ�ע����Ԫ��"},
							{"CSecondarySum","Ŀǰ�ۼƴμ�����Ԫ��"},
							{"CShadinessSum","Ŀǰ�ۼƿ�������Ԫ��"},
							{"CLossSum","Ŀǰ�ۼ���ʧ����Ԫ��"}
						   }; 
	
	sSql = 	" select StatisticDate,OrgID,getOrgName(OrgID) as OrgName,UserID, "+
			" getUserName(UserID) as UserName,sum(CApplySum) as CApplySum, "+
			" sum(CurrDealCount) as CurrDealCount,sum(CurrDealSum) as CurrDealSum, "+
			" sum(CAggreeCount) as CAggreeCount,sum(CDisagreeCount) as CDisagreeCount, "+
			" sum(CAfloatCount) as CAfloatCount,sum(CAggreeTime) as CAggreeTime, "+
			" sum(CDisagreeTime) as CDisagreeTime,sum(CAfloatTime) as CAfloatTime, "+
			" sum(CNApproveCount) as CNApproveCount,sum(CNApproveSum) as CNApproveSum, "+
			" sum(CNContractCount) as CNContractCount,sum(CNContractSum) as CNContractSum, "+
			" sum(CNPutoutCount) as CNPutoutCount,sum(CNPutoutSum) as CNPutoutSum, "+
			" sum(CNormalSum) as CNormalSum,sum(CAttentionSum) as CAttentionSum, "+
			" sum(CSecondarySum) as CSecondarySum,sum(CShadinessSum) as CShadinessSum, "+
			" sum(CLossSum) as CLossSum "+			
			" from APPROVE_PERFORMANCE "+
			" where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') "+
			" group by StatisticDate,OrgID,UserID ";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);   
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	
	//���ÿɼ�����
	doTemp.setVisible("OrgID,UserID",false);	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","StatisticDate","");
	doTemp.setFilter(Sqlca,"2","OrgName","");
	doTemp.setFilter(Sqlca,"3","UserName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and StatisticDate < '"+sCurDate+"' and StatisticDate >= '"+sBeforeDate+"'";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------//
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
