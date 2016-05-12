<%@ page contentType="text/html; charset=GBK"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.are.lang.DataElement"%>
<%@page import="com.amarsoft.oti.*"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@page import="java.net.ConnectException"%>

<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/* Author:   djia  2009.07.30
	 * Tester:
	 * Content: ���ͷſ���Ϣ������
	 * Input Param:
	 * 		SerialNo�����˺�
	 * 		BusinessType��ҵ������
	 * 		OccurType��������ʽ
	 * 		TradeNo����������
	 * 		ContractSerialno: ��ͬ��
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
	String sOccurType = null;
	String sContractSerialNo = null;
	String jTradeNo = "";
	String sTradeNo = "";
	String sReturnValue="";
	
	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 		
	String sOperateType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sOperateType == null) sOperateType = "";
	
    //��ȡ������ʽ��ʹ��һ��JBO�����������Ӳ�ѯ������
    String sql = " select O.OccurType from O,jbo.oti.DKBody R where O.SerialNo = R.ContractSerialNo and R.Serialno = '"+sSerialNo+"'";
    BizObjectManager m = JBOFactory.getFactory().getManager("jbo.oti.OccurType");
    BizObjectQuery q =  m.createQuery(sql);
    BizObject bizObject = q.getSingleResult();
    sOccurType = bizObject.getAttribute("OccurType").getString();
    if(sOccurType == null) throw new Exception("ȡ������ʽ����û���ҵ�������ʽ"+sSerialNo);
    
    //��ȡҵ������
    m = JBOFactory.getFactory().getManager("jbo.oti.BusinessType");
    BizObjectKey k = m.getBizObjectKey();
    k.getAttribute("TypeNo").setValue(sBusinessType);
    BizObject bt = m.getBizObject(k);
    if(bt==null){//û�ж����ҵ������
    	throw new Exception("û�ж����ҵ������"+sBusinessType);
    }else{   
	    if(sOperateType.equals("10")){
			//���ڷſ����	
	        sTradeNo = bt.getAttribute("Attribute13").getString();
		}else if(sOperateType.equals("20")){
			//���ڳ�������
		    sTradeNo = bt.getAttribute("Attribute14").getString();
		}else{
			//����֧������--add by qfang 2011-6-21
			sTradeNo = bt.getAttribute("Attribute15").getString();
		}
    }
    
	if(sOccurType.equals("015")){
		//����չ�ڽ���	
		if(sOperateType.equals("10")){
			jTradeNo = "P003";
		}else{
			jTradeNo = "P004";
		}
	}else if(sOccurType.equals("010") && sOperateType.equals("30")){
		//����֧������--add by qfang 2011-6-21
		jTradeNo = "P011";
	}else{
		//�������ͽ���
		jTradeNo = sTradeNo;	
	}
	
	try {
		manager = OTIManager.getManager();
		//��ȡ����
		conn = manager.getConnectionInstance("CoreBankingClient");
		conn.open();
		//��ȡ����
		ARE.getLog().trace("tradeNo:"+jTradeNo);
		trans = manager.getTransactionInstance(jTradeNo);
		ARE.getLog().trace("paraWhere="+" Serialno = '"+sSerialNo+"'");
		if(jTradeNo.equals("P001")){
		    //��P001���׽���BC��BP�������Ӳ�ѯ
		    trans.initRequestBody("select \"o.\\b((?!OccurType)\\w)+\\b.*\",ot.OccurType from O,jbo.oti.OccurType ot where o.ContractSerialNo=ot.SerialNo and o.SerialNo='"+sSerialNo+"'");
		}else if(jTradeNo.equals("P003")){
				TXMessageBody mb = trans.getRequestBody();
				BizObjectManager bizm = JBOFactory.getFactory().getManager("jbo.oti.PutOut");
				sql = "select O.SerialNo,"+
			    "dn.ObjectNo as V.DuebillSerialNo,CustomerId,ArtificialNo,"+
				"Maturity,BusinessRate,RateFloatType,"+
				"RateFloat from O,jbo.oti.DuebillNo dn "+
				"where O.ContractSerialNo = dn.SerialNo and  O.SerialNO = :SerialNO";

				BizObjectQuery bizq = bizm.createQuery(sql);
				bizq.setParameter("SerialNO", sSerialNo);
				BizObject dueBill = bizq.getSingleResult();
				if(dueBill!=null){ 
					BizObject rb = mb.createObject();
					rb.setAttributesValue(dueBill); //����BizObject�ĸ߼�����������ֱ�����ñ�������������
					mb.addObject(rb);
				}else throw new JBOException("Object not exists!");
				
		}else if (jTradeNo.equals("P005")){
			trans.initRequestBody("Serialno = '"+sSerialNo+"'");
		} else if (jTradeNo.equals("P007")) {
			trans.initRequestBody("Serialno = '"+sSerialNo+"'");		
		} else if (jTradeNo.equals("P009")) {
			trans.initRequestBody("Serialno = '"+sSerialNo+"'");
		} else if (jTradeNo.equals("P011")){
				TXMessageBody mb = trans.getRequestBody();
				BizObjectManager bizm = JBOFactory.getFactory().getManager("jbo.oti.PaymentBody");
				sql = "select O.SerialNo,CustomerID,CustomerName,PaymentMode,PaymentDate,"+
					"PayeeName,PayeeBank,PayeeAccount,Currency,PaymentSum,CapitalUse "+
					"from O,jbo.oti.PutOut po "+
					"where O.PutOutSerialNo = po.SerialNo and po.SerialNo = :SerialNO";
				BizObjectQuery bizq = bizm.createQuery(sql);
				bizq.setParameter("SerialNO",sSerialNo);
				List payments = bizq.getResultList();
				for(int i=0; i<payments.size(); i++){
					BizObject rb = mb.createObject();
					rb.setAttributesValue((BizObject)payments.get(i));
					mb.addObject(rb);
				}
		} else{
			throw new TXException();
		}
		
		//��ʼ������ͷ
		DataElement de	= null;
		BizObject bo = trans.getRequestHeader();
		
		de = bo.getAttribute("TradeNo");
		de.setValue(jTradeNo);
		
		//���ͽ���
		result = conn.executeTransaction(trans);
		ARE.getLog().trace(result.toString());
	}catch(TXException e){
		e.printStackTrace();
		ARE.getLog().debug(e);
		throw new Exception(e.toString());
	}
	
	if(result.getStatus() == 0){
		//�ɹ�
		sReturn = "0@"+jTradeNo;
	}else{
		//ʧ��
		sReturn = "1@"+jTradeNo+"@"+result.getMessage();
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