<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: ������ɵļ�鱨�����
		Input Param:
			 SerialNo: ��ˮ��
			 ObjectType����������
			 ObjectNo��������
		Output param:
		
		History Log: zywei 2006/09/11 �ؼ����
			
	 */
	%>
<%/*~END~*/%>

<%
	//�������
	String sSql = "";
	SqlObject so = null;
	//��ȡҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sReturnValue="succeed";
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	try{
		//����Ǵ�����;����
		if(sObjectType.equals("BusinessContract"))
		{
			sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '010010'"+
					" where SerialNo =:SerialNo "+
					" and ObjectNo =:ObjectNo "+
					" and ObjectType =:ObjectType";
			so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo)
			.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
			Sqlca.executeSQL(so);
		}
		//�ͻ���鱨�棬
		else if(sObjectType.equals("Customer"))
		{		
			sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '020010'"+
		   			" where SerialNo =:SerialNo "+
		   			" and ObjectNo =:ObjectNo "+
		   			" and ObjectType =:ObjectType ";
		   	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo)
			.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
			Sqlca.executeSQL(so);
		}
	}catch(Exception e){
		e.printStackTrace();
		sReturnValue="failed";
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>