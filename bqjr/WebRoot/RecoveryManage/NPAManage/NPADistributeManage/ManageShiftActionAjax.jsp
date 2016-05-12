<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* Content:  ����ָ����ͬ�Ĳ����ʲ������� */
	 //��ͬ��ˮ��
	String sSerialNo = CurPage.getParameter("SerialNo");
	//ԭ�ƽ����͡����ƽ�����	
	String sOldShiftType = CurPage.getParameter("OldShiftType"); 
	String sShiftType = CurPage.getParameter("ShiftType"); 
	String sSql = "";
	SqlObject so = null;

	//ѡ����ѡ��ͬ��ԭ�ƽ�����
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
			//���¶�Ӧ��ͬ���ƽ�����
	        sSql= " UPDATE BUSINESS_CONTRACT SET ShiftType=:ShiftType WHERE  SerialNo=:SerialNo";
	        so = new SqlObject(sSql).setParameter("ShiftType",sShiftType).setParameter("SerialNo",sSerialNo);                	       	
		   	Sqlca.executeSQL(so);
		    	
		    String sSql1 = "";
		    	
		    //��SHIFTCHANGE_INFO���в����ƽ����ͱ����¼
			String sSerialNo1 = DBKeyHelp.getSerialNo("SHIFTCHANGE_INFO","SerialNo",Sqlca);
	        sSql1= " insert into SHIFTCHANGE_INFO(SerialNo,ContractNo,OldShift,NewShift,InputUserID,InputOrgID,InputDate) "+
			       " values(:SerialNo,:ContractNo,:OldShift,:NewShift,:InputUserID,:InputOrgID,:InputDate)";
	        so = new SqlObject(sSql1).setParameter("SerialNo",sSerialNo1).setParameter("ContractNo",sSerialNo)
	        .setParameter("OldShift",sOldShift).setParameter("NewShift",sShiftType).setParameter("InputUserID",CurUser.getUserID())
	        .setParameter("InputOrgID",CurOrg.getOrgID()).setParameter("InputDate",StringFunction.getToday());
		   	Sqlca.executeSQL(so);
		   			   	
		   	if(sOldShiftType.equals("020")){ //����ǿͻ��ƽ���������ƽ�
		   		
		   	}
		   	sReturnValue="true";
		}catch(Exception e){
			sReturnValue="false";
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}
	}
	
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>