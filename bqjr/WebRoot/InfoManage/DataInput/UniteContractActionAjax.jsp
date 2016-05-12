<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: slliu  2005-02-23 
		Tester:
		Content: 补登完成校验
		Input Param:                                                           
    			   
		Output param:                                                          
			        
		History Log: 
	 */
	%>
<%/*~END~*/%>




<html>
<head>
<title>补登完成校验 </title>
</head>


<%
	//定义变量
	ASResultSet rs = null;
	double sBusinessSum=0.00;
	double sClassifySum1=0.00;
	double sClassifySum2=0.00;
	double sClassifySum3=0.00;
	double sClassifySum4=0.00;
	double sClassifySum5=0.00;
	
	double sPutOutSum=0.00;
	double sActualPutOutSum=0.00;
	double sBalance=0.00;
	double sNormalBalance=0.00;
	double sOverdueBalance=0.00;
	double sDullBalance=0.00;
	double sBadBalance=0.00;
	double sInterestBalance1=0.00;
	double sInterestBalance2=0.00;
	
	double sShiftBalance=0.00;
	double sFineBalance=0.00;
	double sTABalance=0.00;
	double sTAInterestBalance=0.00;
	
	String sSql="",sReturnValue="";
	String sArtificialNo="";
	SqlObject so = null;
	
	
	//目标合同流水号、被合并的合同流水号及数量
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sObjectNoArray =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNoArray"));
	
//---------------------------计算被合并合同的金额总和-----------------------------------------
	try{
		String sNewContractNo[]=sObjectNoArray.split(",");
		
	        for (int i=0;i<sNewContractNo.length;i++)
	        {
	        	
	        	sSql = " select BusinessSum,ClassifySum1,ClassifySum2,ClassifySum3,ClassifySum4,ClassifySum5,"+
	        		" PutOutSum,ActualPutOutSum,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
	        		" InterestBalance1,InterestBalance2,ShiftBalance,FineBalance,TABalance,TAInterestBalance "+        		
		               " from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
	        so = new SqlObject(sSql).setParameter("SerialNo",sNewContractNo[i]); 
			rs = Sqlca.getASResultSet(so);
			if(rs.next())
			{
				sBusinessSum = sBusinessSum + rs.getDouble("BusinessSum");
				sClassifySum1 = sClassifySum1 + rs.getDouble("ClassifySum1");
				sClassifySum2 = sClassifySum2 + rs.getDouble("ClassifySum2");
				sClassifySum3 = sClassifySum3 + rs.getDouble("ClassifySum3");
				sClassifySum4 = sClassifySum4 + rs.getDouble("ClassifySum4");
				sClassifySum5 = sClassifySum5 + rs.getDouble("ClassifySum5");
				
				sPutOutSum = sPutOutSum + rs.getDouble("PutOutSum");
				sActualPutOutSum = sActualPutOutSum + rs.getDouble("ActualPutOutSum");
				sBalance = sBalance + rs.getDouble("Balance");
				sNormalBalance = sNormalBalance + rs.getDouble("NormalBalance");
				sOverdueBalance = sOverdueBalance + rs.getDouble("OverdueBalance");
				sDullBalance = sDullBalance + rs.getDouble("DullBalance");
				sBadBalance = sBadBalance + rs.getDouble("BadBalance");
				sInterestBalance1 = sInterestBalance1 + rs.getDouble("InterestBalance1");
				sInterestBalance2 = sInterestBalance2 + rs.getDouble("InterestBalance2");
				
				sShiftBalance = sShiftBalance + rs.getDouble("ShiftBalance");
				sFineBalance = sFineBalance + rs.getDouble("FineBalance");
				sTABalance = sTABalance + rs.getDouble("TABalance");
				sTAInterestBalance = sTAInterestBalance + rs.getDouble("TAInterestBalance");
				
		       	}
		       	rs.getStatement().close();
		       	
			
			//获得目标合同流水号对应的手工编号      	
		     
		       	sSql = " select ArtificialNo "+
	        	         " from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
		       	so = new SqlObject(sSql).setParameter("SerialNo",sContractNo); 
				rs = Sqlca.getASResultSet(so);
			if(rs.next())
			{
				sArtificialNo = rs.getString("ArtificialNo");
		     	}
		       	rs.getStatement().close();
		       	
		       	//更新借据表，将原合同号更新为目标合同号
		       	sSql="UPDATE BUSINESS_DUEBILL SET RelativeSerialNo2=:RelativeSerialNo2 where RelativeSerialNo2=:RelativeSerialNo2";
		       	so = new SqlObject(sSql).setParameter("RelativeSerialNo2",sContractNo).setParameter("RelativeSerialNo2",sNewContractNo[i]);
	      		Sqlca.executeSQL(so);
	      		
	      		//更新合同表，将被合并合同的合并标志置为已合并
	      		sSql="UPDATE BUSINESS_CONTRACT SET DeleteFlag='01',RelativeSerialNo=:RelativeSerialNo where SerialNo=:SerialNo";
	      		so = new SqlObject(sSql).setParameter("RelativeSerialNo2",sArtificialNo).setParameter("RelativeSerialNo2",sNewContractNo[i]);
	      		Sqlca.executeSQL(so);
	        }
	        
	        java.text.DecimalFormat df = new java.text.DecimalFormat("#.00");
	
		//更新合同表，将被合并合同的金额总和加到目标合同上
			String sBusinessSum1 = "BusinessSum"+df.format(sBusinessSum);
			String sClassifySum11 = "ClassifySum1"+df.format(sClassifySum1);
			String sClassifySum21 = "ClassifySum2"+df.format(sClassifySum2);
			String sClassifySum31 = "ClassifySum3"+df.format(sClassifySum3);
			String sClassifySum41 = "ClassifySum4"+df.format(sClassifySum4);
			String sClassifySum51 = "ClassifySum5"+df.format(sClassifySum5);
			String sPutOutSum1 = "PutOutSum"+df.format(sPutOutSum);
			String sActualPutOutSum1 = "ActualPutOutSum"+df.format(sActualPutOutSum);
			String sBalance1 = "Balance"+df.format(sBalance);
			String sNormalBalance1 = "NormalBalance"+df.format(sNormalBalance);
			String sOverdueBalance1 = "OverdueBalance"+df.format(sOverdueBalance);
			//String sBusinessSum1 = "BusinessSum"+df.format(sBusinessSum);
			String sBadBalance1 = "DullBalance"+df.format(sBadBalance);
			String sInterestBalance11 = "InterestBalance1"+df.format(sInterestBalance1);
			String sInterestBalance21 = "InterestBalance2"+df.format(sInterestBalance2);
			String sShiftBalance1 = "ShiftBalance"+df.format(sShiftBalance);
			String sFineBalance1 = "FineBalance"+df.format(sFineBalance);
			String sTABalance1 = "TABalance"+df.format(sTABalance);
			String sTAInterestBalance1 = "TAInterestBalance"+df.format(sTAInterestBalance);
		sSql="UPDATE BUSINESS_CONTRACT SET BusinessSum =:BusinessSum,"+
			" ClassifySum1 =:ClassifySum1,"+
			" ClassifySum2 =:ClassifySum2,"+
			" ClassifySum3 =:ClassifySum3,"+
			" ClassifySum4 =:ClassifySum4,"+
			" ClassifySum5 =:ClassifySum5,"+
			
			" PutOutSum =:PutOutSum,"+
			" ActualPutOutSum =:ActualPutOutSum,"+
			" Balance =:Balance,"+
			" NormalBalance =:NormalBalance,"+
			" OverdueBalance =:OverdueBalance,"+
			" DullBalance =:DullBalance,"+
			" BadBalance =:BadBalance,"+
			" InterestBalance1 =:InterestBalance1,"+
			" InterestBalance2 =:InterestBalance2,"+
			
			" ShiftBalance =:ShiftBalance,"+
			" FineBalance =:FineBalance,"+
			" TABalance =:TABalance,"+
			" TAInterestBalance =:TAInterestBalance "+
			
			" where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("BusinessSum",sBusinessSum1).setParameter("ClassifySum1",sClassifySum11)
		.setParameter("ClassifySum2",sClassifySum21).setParameter("ClassifySum3",sClassifySum31)
		.setParameter("ClassifySum4",sClassifySum41).setParameter("ClassifySum5",sClassifySum51)
		.setParameter("PutOutSum",sPutOutSum1).setParameter("ActualPutOutSum",sActualPutOutSum1)
		.setParameter("Balance",sBalance1).setParameter("NormalBalance",sNormalBalance1)
		.setParameter("OverdueBalance",sOverdueBalance1).setParameter("DullBalance",df.format(sDullBalance))
		.setParameter("BadBalance",sBadBalance1).setParameter("InterestBalance1",sInterestBalance11)
		.setParameter("InterestBalance2",sInterestBalance21).setParameter("ShiftBalance",sShiftBalance1)
		.setParameter("FineBalance",sFineBalance1).setParameter("TABalance",sTABalance1)
		.setParameter("TAInterestBalance",sTAInterestBalance1).setParameter("SerialNo",sContractNo);
		Sqlca.executeSQL(so);
		sReturnValue="true";
	}catch(Exception e){
		e.fillInStackTrace();
	}
%>



</html>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>