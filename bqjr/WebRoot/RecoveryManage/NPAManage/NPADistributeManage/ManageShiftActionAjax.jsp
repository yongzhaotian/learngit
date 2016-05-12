<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* Content:  更新指定合同的不良资产管理人 */
	 //合同流水号
	String sSerialNo = CurPage.getParameter("SerialNo");
	//原移交类型、新移交类型	
	String sOldShiftType = CurPage.getParameter("OldShiftType"); 
	String sShiftType = CurPage.getParameter("ShiftType"); 
	String sSql = "";
	SqlObject so = null;

	//选择所选合同的原移交类型
	ASResultSet rs = null;
	ASResultSet rs1 = null;
	int sCount = 0;
	String sOldShift = "";
	String sRecoveryOrgid = "";
	String sRecoveryUserid = "";
	String sReturnValue="";
	boolean AddFlag = false;
	
	sSql= " select  ShiftType,RecoveryOrgid,RecoveryUserid from BUSINESS_CONTRACT "+
          " WHERE  SerialNo=:SerialNo";
	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);                
    rs = Sqlca.getASResultSet(so); 
  	if(rs.next()){
       AddFlag = true;
       sOldShift = DataConvert.toString(rs.getString("ShiftType"));
       sRecoveryOrgid = DataConvert.toString(rs.getString("RecoveryOrgid")); 
       sRecoveryUserid = DataConvert.toString(rs.getString("RecoveryUserid"));        
	}
	rs.getStatement().close();
	
	if (AddFlag) {
		try {
			//更新对应合同的移交类型
	        sSql= " UPDATE BUSINESS_CONTRACT SET ShiftType=:ShiftType WHERE  SerialNo=:SerialNo";
	        so = new SqlObject(sSql).setParameter("ShiftType",sShiftType).setParameter("SerialNo",sSerialNo);                	       	
		   	Sqlca.executeSQL(so);
		    	
		    String sSql1 = "";
		    	
		    //向SHIFTCHANGE_INFO表中插入移交类型变更记录
			String sSerialNo1 = DBKeyHelp.getSerialNo("SHIFTCHANGE_INFO","SerialNo",Sqlca);
	        sSql1= " insert into SHIFTCHANGE_INFO(SerialNo,ContractNo,OldShift,NewShift,InputUserID,InputOrgID,InputDate) "+
			       " values(:SerialNo,:ContractNo,:OldShift,:NewShift,:InputUserID,:InputOrgID,:InputDate)";
	        so = new SqlObject(sSql1).setParameter("SerialNo",sSerialNo1).setParameter("ContractNo",sSerialNo)
	        .setParameter("OldShift",sOldShift).setParameter("NewShift",sShiftType).setParameter("InputUserID",CurUser.getUserID())
	        .setParameter("InputOrgID",CurOrg.getOrgID()).setParameter("InputDate",StringFunction.getToday());
		   	Sqlca.executeSQL(so);
		   			   	
		   	if(sOldShiftType.equals("020")){ //如果是客户移交变成审批移交
		   		
		   	}
		   	sReturnValue="true";
		}catch(Exception e){
			sReturnValue="false";
			throw new Exception("事务处理失败！"+e.getMessage());
		}
	}
	
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>