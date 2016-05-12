<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	//合同流水号
	String sContractNo = CurPage.getParameter("ContractNo"); 
	//标志；Flag=ReformScheme重组方案详情、Flag=ReformApply重组申请详情
	String sFlag = CurPage.getParameter("Flag"); 
	String sSql="",sReturn ="";
	ASResultSet rs = null;
  
  	if(sFlag.equals("ReformScheme")){ //重组方案详情
   		sSql = " select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType"+
    		" from BUSINESS_APPLY BA,APPLY_RELATIVE AR "+
    		" where  BA.SerialNo = AR.SerialNo and AR.ObjectNo =:ObjectNo and AR.ObjectType='BusinessContract' ";
      	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sContractNo)); 
      	if(rs.next()){
 			//获得申请流水号、申请类型（一般重组、还是扩盘重组）
 			 String sSerialNo = DataConvert.toString(rs.getString("SerialNo"));		
        	 String sApplyType = DataConvert.toString(rs.getString("ApplyType"));
        	 sReturn = sSerialNo+"@"+sApplyType; //返回申请号、申请类型
 		}
	 	rs.getStatement().close(); 
	}
	
	if(sFlag.equals("ReformApply")){ //重组贷款详情
   		sSql = " select ObjectNo from CONTRACT_RELATIVE where  SerialNo = :SerialNo and ObjectType='CreditApply' ";
      	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sContractNo)); 
      	if(rs.next()){
 			//获得申请流水号
			String sObjectNo = DataConvert.toString(rs.getString("ObjectNo"));
			sReturn = sObjectNo; //返回申请号
 		}
	 	rs.getStatement().close(); 
	 }

	out.println(sReturn);
%><%@ include file="/IncludeEndAJAX.jsp"%>