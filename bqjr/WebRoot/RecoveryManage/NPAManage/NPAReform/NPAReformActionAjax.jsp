<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	//��ͬ��ˮ��
	String sContractNo = CurPage.getParameter("ContractNo"); 
	//��־��Flag=ReformScheme���鷽�����顢Flag=ReformApply������������
	String sFlag = CurPage.getParameter("Flag"); 
	String sSql="",sReturn ="";
	ASResultSet rs = null;
  
  	if(sFlag.equals("ReformScheme")){ //���鷽������
   		sSql = " select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType"+
    		" from BUSINESS_APPLY BA,APPLY_RELATIVE AR "+
    		" where  BA.SerialNo = AR.SerialNo and AR.ObjectNo =:ObjectNo and AR.ObjectType='BusinessContract' ";
      	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sContractNo)); 
      	if(rs.next()){
 			//���������ˮ�š��������ͣ�һ�����顢�����������飩
 			 String sSerialNo = DataConvert.toString(rs.getString("SerialNo"));		
        	 String sApplyType = DataConvert.toString(rs.getString("ApplyType"));
        	 sReturn = sSerialNo+"@"+sApplyType; //��������š���������
 		}
	 	rs.getStatement().close(); 
	}
	
	if(sFlag.equals("ReformApply")){ //�����������
   		sSql = " select ObjectNo from CONTRACT_RELATIVE where  SerialNo = :SerialNo and ObjectType='CreditApply' ";
      	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sContractNo)); 
      	if(rs.next()){
 			//���������ˮ��
			String sObjectNo = DataConvert.toString(rs.getString("ObjectNo"));
			sReturn = sObjectNo; //���������
 		}
	 	rs.getStatement().close(); 
	 }

	out.println(sReturn);
%><%@ include file="/IncludeEndAJAX.jsp"%>