<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 2006-12-28
		Tester:
		Content: ֧�б���������Ч��ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������Ч��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����������Ч��ѯ&nbsp;&nbsp;";
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
							{"YApplySum","���������ܽ�Ԫ��"},
							{"CurrDealCount","Ŀǰ����������"},
							{"CurrDealSum","Ŀǰ��������Ԫ��"},
							{"YAggreeCount","������׼�ܱ���"},
							{"YDisagreeCount","�������ܱ���"},
							{"YAfloatCount","������;�ܱ���"},
							{"YAggreeTime","������׼�ܺ�ʱ���죩"},										
							{"YDisagreeTime","�������ܺ�ʱ���죩"},
							{"YAfloatTime","������;�ܺ�ʱ���죩"},
							{"YNApproveCount","����δǩ�����ܱ���"},
							{"YNApproveSum","����δǩ�����ܽ�Ԫ��"},
							{"YNContractCount","����δǩ��ͬ�ܱ���"},
							{"YNContractSum","����δǩ��ͬ�ܽ�Ԫ��"},
							{"YNPutoutCount","����δ�Ŵ��ܱ���"},
							{"YNPutoutSum","����δ�Ŵ��ܽ�Ԫ��"},
							{"YNormalSum","������������Ԫ��"},
							{"YAttentionSum","�����ע����Ԫ��"},
							{"YSecondarySum","����μ�����Ԫ��"},
							{"YShadinessSum","�����������Ԫ��"},
							{"YLossSum","������ʧ����Ԫ��"}
						   }; 
	
	sSql = 	" select StatisticDate,OrgID,getOrgName(OrgID) as OrgName,UserID, "+
			" getUserName(UserID) as UserName,sum(YApplySum) as YApplySum, "+
			" sum(CurrDealCount) as CurrDealCount,sum(CurrDealSum) as CurrDealSum, "+
			" sum(YAggreeCount) as YAggreeCount,sum(YDisagreeCount) as YDisagreeCount, "+
			" sum(YAfloatCount) as YAfloatCount,sum(YAggreeTime) as YAggreeTime, "+
			" sum(YDisagreeTime) as YDisagreeTime,sum(YAfloatTime) as YAfloatTime, "+
			" sum(YNApproveCount) as YNApproveCount,sum(YNApproveSum) as YNApproveSum, "+
			" sum(YNContractCount) as YNContractCount,sum(YNContractSum) as YNContractSum, "+
			" sum(YNPutoutCount) as YNPutoutCount,sum(YNPutoutSum) as YNPutoutSum, "+
			" sum(YNormalSum) as YNormalSum,sum(YAttentionSum) as YAttentionSum, "+
			" sum(YSecondarySum) as YSecondarySum,sum(YShadinessSum) as YShadinessSum, "+
			" sum(YLossSum) as YLossSum "+			
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
