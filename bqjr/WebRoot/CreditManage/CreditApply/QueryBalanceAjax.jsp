<%@ page contentType="text/html; charset=GBK"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.are.lang.DataElement"%>
<%@page import="com.amarsoft.oti.*"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/* Author:   djia  2009.08.03
	 * Tester:
	 * Content: �����Ĳ�ѯ��������Ϣ
	 * Input Param:
	 * 		SerialNo����ݺ�
	 * 		OrgID����������
	 * Output param:
	 *      sReturn: ���׽��	 
	 * History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
	OTIManager manager = null;
	OTIConnection conn = null;
	OTITransaction trans = null;
    TXResult result = null;
	String sReturn = "";
	String sReturnValue="";
	
	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 		
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	
	try {
		manager = OTIManager.getManager();
		//��ȡ����
		conn = manager.getConnectionInstance("CoreBankingClient");
		conn.open();
		//��ȡ����
		ARE.getLog().trace("tradeNo:"+"Q002");
		trans = manager.getTransactionInstance("Q002");
		ARE.getLog().trace("paraWhere="+" SerialNo = '"+sSerialNo+"'");
		trans.initRequestBody("select R.SerialNo from jbo.oti.JYBody R where R.SerialNo = '"+sSerialNo+"'");
		
		//��ʼ������ͷ
		DataElement de	= null;
		BizObject bo = trans.getRequestHeader();
		
		de = bo.getAttribute("TradeNo");
		de.setValue("Q002");
		
		//���ͽ���
		result = conn.executeTransaction(trans);
		ARE.getLog().trace(result.toString());		
	}catch(TXException e){
		e.printStackTrace();
		ARE.getLog().debug(e);
		throw new Exception("������������ĵĽ������ӡ�");
	}
	
	if(result.getStatus() == 0){
		//�ɹ�
		TXMessageBody responsBody = trans.getResponseBody();
		BizObject bo = null;
		if(responsBody != null)
			ARE.getLog().trace("���������峤�ȣ�"+responsBody.size());
			for(int i=0; i<responsBody.size();i++){
				//��ȡ�����������еĵ�i����¼
				bo = responsBody.getObject(i);
				String d = bo.getAttribute("Balance").getString();
				sReturn = "0@"+d;
			}
	}else{
		//ʧ��
		sReturn = "1@"+result.getMessage();
	}

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturn);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>