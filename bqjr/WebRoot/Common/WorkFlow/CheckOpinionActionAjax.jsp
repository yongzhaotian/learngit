<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-17
		Tester:
		Describe: �������Ƿ�ǩ��һ���������ύǰ���
		Input Param:
			SerialNo:������ˮ��
		Output Param:
		HistoryLog:zywei 2005/08/01
			
	 */
	%>
<%/*~END~*/%> 


<% 
	//��ȡ������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sReturnValue="";
	SqlObject so = null;
	//����ֵת���ɿ��ַ���
	if(sSerialNo == null) sSerialNo = "";
	
	//���������SQL��䡢�������
	String sSql = "",sPhaseOpinion = "";
	
	//����������ˮ�Ŵ����������¼���в�ѯǩ������
	sSql = "select PhaseOpinion from FLOW_OPINION where SerialNo=:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
	sPhaseOpinion = Sqlca.getString(so);
	//����ֵת���ɿ��ַ���
	if (sPhaseOpinion == null) {
		sPhaseOpinion = "";
	}else{ 
		sPhaseOpinion = "�Ѿ�ǩ�����";//��ֹ�лس��������
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sPhaseOpinion);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
