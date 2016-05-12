<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Content: �����ݹ�����ͬ
	 */
	//�������
	ASResultSet rs = null;
	double sBusinessSum=0.00;		
	double sBalance=0.00;
	double sNormalBalance=0.00;
	double sOverdueBalance=0.00;
	double sDullBalance=0.00;
	double sBadBalance=0.00;
	double sInterestBalance1=0.00;
	double sInterestBalance2=0.00;	
	double sShiftBalance=0.00;
	double sFineBalance1=0.00;
	double sFineBalance2=0.00;
	double sTABalance=0.00;
	double sTAInterestBalance=0.00;
	
	String sSql="",sReturnValue="";
	SqlObject so = null;
	
	//ԭ��ͬ��ˮ�š��º�ͬ��ˮ�ż���ݺ�
	String sOldContractNo = CurPage.getParameter("OldContractNo");
	String sContractNo =   CurPage.getParameter("ContractNo");
	String sDueBillNo =   CurPage.getParameter("DueBillNo");

	//---------------------------��ý�ݵĽ�������-----------------------------------------
    //���½�ݱ���ԭ��ͬ�Ÿ���ΪĿ���ͬ��
    try{
	   	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2=:RelativeSerialNo2 where RelativeSerialNo2=:OldRelativeSerialNo2 and SerialNo=:SerialNo ";
	   	so = new SqlObject(sSql).setParameter("RelativeSerialNo2",sContractNo)
	   	.setParameter("OldRelativeSerialNo2",sOldContractNo).setParameter("SerialNo",sDueBillNo);
		Sqlca.executeSQL(so);
		
		//���ݺ�ͬ�µĽ�����¼���ԭ��ͬ����ؽ��
		sSql = 	" select sum(BusinessSum) as BusinessSum,sum(Balance) as Balance,sum(NormalBalance) as NormalBalance,"+
				" sum(OverdueBalance) as OverdueBalance,sum(DullBalance) as DullBalance,sum(BadBalance) as BadBalance,"+
				" sum(InterestBalance1) as InterestBalance1,sum(InterestBalance2) as InterestBalance2,"+
				" sum(FineBalance1) as FineBalance1,sum(FineBalance2) as FineBalance2,sum(TABalance) as TABalance, "+
				" sum(TAInterestBalance) as TAInterestBalance"+
				" from BUSINESS_DUEBILL where RelativeSerialNo2=:RelativeSerialNo2 ";
		so = new SqlObject(sSql).setParameter("RelativeSerialNo2",sOldContractNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sBusinessSum =rs.getDouble("BusinessSum");
			sBalance = rs.getDouble("Balance");		
			sNormalBalance = rs.getDouble("NormalBalance");
			sOverdueBalance =  rs.getDouble("OverdueBalance");
			sDullBalance =  rs.getDouble("DullBalance");
			sBadBalance = rs.getDouble("BadBalance");
			sInterestBalance1 = rs.getDouble("InterestBalance1");
			sInterestBalance2 = rs.getDouble("InterestBalance2");		
			sFineBalance1 = rs.getDouble("FineBalance1");
			sFineBalance2 = rs.getDouble("FineBalance2");
			sTABalance = rs.getDouble("TABalance");
			sTAInterestBalance = rs.getDouble("TAInterestBalance");		
	   	}
	   			
	    java.text.DecimalFormat df = new java.text.DecimalFormat("#.00");
		
		//����ԭ��ͬ�������Ϣ
		sSql="UPDATE BUSINESS_CONTRACT SET BusinessSum =:BusinessSum,"+
			" Balance =:Balance,"+
			" NormalBalance =:NormalBalance,"+
			" OverdueBalance =:OverdueBalance,"+
			" DullBalance =:DullBalance,"+
			" BadBalance =:BadBalance,"+
			" InterestBalance1 =:InterestBalance1,"+
			" InterestBalance2 =:InterestBalance2,"+		
			" FineBalance1 =:FineBalance1,"+
			" FineBalance2 =:FineBalance2,"+
			" TABalance =:TABalance,"+
			" TAInterestBalance =:TAInterestBalance "+		
			" where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("BusinessSum",df.format(sBusinessSum)).setParameter("Balance",df.format(sBalance))
		.setParameter("NormalBalance",df.format(sNormalBalance)).setParameter("OverdueBalance",df.format(sOverdueBalance))
		.setParameter("DullBalance",df.format(sDullBalance)).setParameter("BadBalance",df.format(sBadBalance))
		.setParameter("InterestBalance1",df.format(sInterestBalance1)).setParameter("InterestBalance2",df.format(sInterestBalance2))
		.setParameter("FineBalance1",df.format(sFineBalance1)).setParameter("FineBalance2",df.format(sFineBalance2))
		.setParameter("TABalance",df.format(sTABalance)).setParameter("TAInterestBalance",df.format(sTAInterestBalance))
		.setParameter("SerialNo",sOldContractNo);
		Sqlca.executeSQL(so);
		rs.getStatement().close();
	      	
		//���ݺ�ͬ�µĽ�����¼����º�ͬ����ؽ��
		sSql = " select sum(BusinessSum) as BusinessSum,sum(Balance) as Balance,sum(NormalBalance) as NormalBalance,"+
				" sum(OverdueBalance) as OverdueBalance,sum(DullBalance) as DullBalance,sum(BadBalance) as BadBalance,"+
				" sum(InterestBalance1) as InterestBalance1,sum(InterestBalance2) as InterestBalance2,"+
				" sum(FineBalance1) as FineBalance1,sum(FineBalance2) as FineBalance2,sum(TABalance) as TABalance, "+
				" sum(TAInterestBalance) as TAInterestBalance"+
		        " from BUSINESS_DUEBILL where RelativeSerialNo2=:RelativeSerialNo2 ";
		so = new SqlObject(sSql).setParameter("RelativeSerialNo2",sContractNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sBusinessSum =rs.getDouble("BusinessSum");
			sBalance = rs.getDouble("Balance");		
			sNormalBalance = rs.getDouble("NormalBalance");
			sOverdueBalance =  rs.getDouble("OverdueBalance");
			sDullBalance =  rs.getDouble("DullBalance");
			sBadBalance = rs.getDouble("BadBalance");
			sInterestBalance1 = rs.getDouble("InterestBalance1");
			sInterestBalance2 = rs.getDouble("InterestBalance2");
			sFineBalance1 = rs.getDouble("FineBalance1");
			sFineBalance2 = rs.getDouble("FineBalance2");
			sTABalance = rs.getDouble("TABalance");
			sTAInterestBalance = rs.getDouble("TAInterestBalance");		
	    }
	       
		//�����º�ͬ�������Ϣ
		sSql="UPDATE BUSINESS_CONTRACT SET BusinessSum =:BusinessSum,"+
				" Balance =:Balance,"+
				" NormalBalance =:NormalBalance,"+
				" OverdueBalance =:OverdueBalance,"+
				" DullBalance =:DullBalance,"+
				" BadBalance =:BadBalance,"+
				" InterestBalance1 =:InterestBalance1,"+
				" InterestBalance2 =:InterestBalance2,"+		
				" FineBalance1 =:FineBalance1,"+
				" FineBalance2 =:FineBalance2,"+
				" TABalance =:TABalance,"+
				" TAInterestBalance =:TAInterestBalance "+		
				" where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("BusinessSum",df.format(sBusinessSum)).setParameter("Balance",df.format(sBalance))
			.setParameter("NormalBalance",df.format(sNormalBalance)).setParameter("OverdueBalance",df.format(sOverdueBalance))
			.setParameter("DullBalance",df.format(sDullBalance)).setParameter("BadBalance",df.format(sBadBalance))
			.setParameter("InterestBalance1",df.format(sInterestBalance1)).setParameter("InterestBalance2",df.format(sInterestBalance2))
			.setParameter("FineBalance1",df.format(sFineBalance1)).setParameter("FineBalance2",df.format(sFineBalance2))
			.setParameter("TABalance",df.format(sTABalance)).setParameter("TAInterestBalance",df.format(sTAInterestBalance))
			.setParameter("SerialNo",sOldContractNo);
		Sqlca.executeSQL(so);
		rs.getStatement().close();
		sReturnValue="true";
    }catch(Exception e){
    	e.fillInStackTrace();
    }
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>