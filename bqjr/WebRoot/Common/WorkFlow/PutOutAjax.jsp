<%@ page contentType="text/html; charset=GBK"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.are.lang.DataElement"%>
<%@page import="com.amarsoft.oti.*"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@page import="java.net.ConnectException"%>

<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
	/* Author:   djia  2009.07.30
	 * Tester:
	 * Content: 发送放款信息到核心
	 * Input Param:
	 * 		SerialNo：出账号
	 * 		BusinessType：业务类型
	 * 		OccurType：发生方式
	 * 		TradeNo：交易类型
	 * 		ContractSerialno: 合同号
	 * Output param:
	 *      sReturn: 交易结果	 
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
	
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 		
	String sOperateType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sOperateType == null) sOperateType = "";
	
    //获取发生方式（使用一次JBO，用两表连接查询方法）
    String sql = " select O.OccurType from O,jbo.oti.DKBody R where O.SerialNo = R.ContractSerialNo and R.Serialno = '"+sSerialNo+"'";
    BizObjectManager m = JBOFactory.getFactory().getManager("jbo.oti.OccurType");
    BizObjectQuery q =  m.createQuery(sql);
    BizObject bizObject = q.getSingleResult();
    sOccurType = bizObject.getAttribute("OccurType").getString();
    if(sOccurType == null) throw new Exception("取发生方式错误：没有找到发生方式"+sSerialNo);
    
    //获取业务类型
    m = JBOFactory.getFactory().getManager("jbo.oti.BusinessType");
    BizObjectKey k = m.getBizObjectKey();
    k.getAttribute("TypeNo").setValue(sBusinessType);
    BizObject bt = m.getBizObject(k);
    if(bt==null){//没有定义的业务类型
    	throw new Exception("没有定义的业务类型"+sBusinessType);
    }else{   
	    if(sOperateType.equals("10")){
			//属于放款操作	
	        sTradeNo = bt.getAttribute("Attribute13").getString();
		}else if(sOperateType.equals("20")){
			//属于冲销操作
		    sTradeNo = bt.getAttribute("Attribute14").getString();
		}else{
			//属于支付交易--add by qfang 2011-6-21
			sTradeNo = bt.getAttribute("Attribute15").getString();
		}
    }
    
	if(sOccurType.equals("015")){
		//属于展期交易	
		if(sOperateType.equals("10")){
			jTradeNo = "P003";
		}else{
			jTradeNo = "P004";
		}
	}else if(sOccurType.equals("010") && sOperateType.equals("30")){
		//属于支付交易--add by qfang 2011-6-21
		jTradeNo = "P011";
	}else{
		//其他类型交易
		jTradeNo = sTradeNo;	
	}
	
	try {
		manager = OTIManager.getManager();
		//获取连接
		conn = manager.getConnectionInstance("CoreBankingClient");
		conn.open();
		//获取交易
		ARE.getLog().trace("tradeNo:"+jTradeNo);
		trans = manager.getTransactionInstance(jTradeNo);
		ARE.getLog().trace("paraWhere="+" Serialno = '"+sSerialNo+"'");
		if(jTradeNo.equals("P001")){
		    //对P001交易进行BC和BP两表连接查询
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
					rb.setAttributesValue(dueBill); //利用BizObject的高级方法，可以直接设置报文体对象各属性
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
		
		//初始化报文头
		DataElement de	= null;
		BizObject bo = trans.getRequestHeader();
		
		de = bo.getAttribute("TradeNo");
		de.setValue(jTradeNo);
		
		//发送交易
		result = conn.executeTransaction(trans);
		ARE.getLog().trace(result.toString());
	}catch(TXException e){
		e.printStackTrace();
		ARE.getLog().debug(e);
		throw new Exception(e.toString());
	}
	
	if(result.getStatus() == 0){
		//成功
		sReturn = "0@"+jTradeNo;
	}else{
		//失败
		sReturn = "1@"+jTradeNo+"@"+result.getMessage();
	}
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturn);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>