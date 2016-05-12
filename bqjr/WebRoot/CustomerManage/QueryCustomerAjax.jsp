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
	 * Content: �����Ĳ�ѯ�ͻ�������Ϣ
	 * Input Param:
	 * 		CertID��֤������
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
	String sCertType = "";
	
	//���ҳ�����	
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID")); 		
	//����ֵת��Ϊ���ַ���
	if(sCertID == null) sCertID = "";
	
	try {
		manager = OTIManager.getManager();
		//��ȡ����
		conn = manager.getConnectionInstance("CoreBankingClient");
		conn.open();
		//��ȡ����
		ARE.getLog().trace("tradeNo:"+"Q001");
		trans = manager.getTransactionInstance("Q001");
		ARE.getLog().trace("paraWhere="+" CertID = '"+sCertID+"'");
		//trans.initRequestBody("select CertId, CertType from CUSTOMER_INFO where CertID = '"+sCertID+"'","");
		trans.initRequestBody("select R.CertId, R.CertType from jbo.oti.KHBody R where R.CertID = '"+sCertID+"'");
		
		//��ʼ������ͷ
		DataElement de	= null;
		BizObject bo = trans.getRequestHeader();
		
		de = bo.getAttribute("TradeNo");
		de.setValue("Q001");
		
		//ȡ֤������
		TXMessageBody requestBody = trans.getRequestBody();
		bo = requestBody.getObject(0);
		sCertType = bo.getAttribute("CertType").getString();	
		
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
		BizObject bore = trans.getResponseHeader();
		int length = 0;		
		for(int j=0; j<bore.getAttributeNumber(); j++){
			length += bore.getAttribute(j).getLength();
			ARE.getLog().trace("�����ֶ�����"+bore.getAttribute(j).getName()+"  �ֶ�ֵ:"+bore.getAttribute(j).getString());
		}
		
		BizObject bo = trans.getRequestHeader();
		TXMessageBody responsBody = trans.getResponseBody();
		if(responsBody != null){
		   ARE.getLog().trace("���������峤�ȣ�"+responsBody.size());
		   for(int i=0; i<responsBody.size();i++){
			   bo = responsBody.getObject(i);
			   String mfCustomerID = bo.getAttribute("CustomId").getString();
			   String sNewSql = "update CUSTOMER_INFO  set mfcustomerid =:mfcustomerid where CertID = :CertID and CertType = :CertType";
			   SqlObject so = new SqlObject(sNewSql);
			   so.setParameter("mfcustomerid",mfCustomerID);
			   so.setParameter("CertID",sCertID);
			   so.setParameter("CertType",sCertType);
			   Sqlca.executeSQL(so);
			   //Sqlca.executeSQL("update CUSTOMER_INFO  set mfcustomerid ='"+mfCustomerID+"' where CertID = '"+sCertID+"'"+"and CertType = '"+sCertType+"'");
			   sReturn = "0@" + mfCustomerID;
			   for(int j=0; j<bo.getAttributeNumber(); j++){
				   length += bo.getAttribute(j).getLength();
				   ARE.getLog().trace("�ֶ�����"+bo.getAttribute(j).getName()+"  �ֶ�ֵ:"+bo.getAttribute(j).getString());
			   }
		   }
		}else{
			ARE.getLog().trace("����������Ϊ��");
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
	sReturn = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturn);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>