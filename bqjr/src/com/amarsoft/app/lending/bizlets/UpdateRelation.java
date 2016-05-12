
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateRelation extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ	
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sRelativeID   = (String)this.getAttribute("RelativeID");
		String sRelationShip = (String)this.getAttribute("RelationShip");
		
		
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";
		if(sRelationShip == null) sRelationShip = "";
		
		//�������
		ASResultSet rs = null;
		SqlObject so;
		String sItemDescribe = "";
		String sCurrencyType = "",sInvestDate = "",sEffstatus = "";
		double dInvestmentSum = 0.0,dOughtSum = 0.0,dInvestmentProp=0.0;
		String sSql = "";
		//ȡ������ϵ����
		sSql=" select ItemDescribe from CODE_LIBRARY where CODENO = 'RelationShip' and ITEMNO =:ITEMNO";
		so = new SqlObject(sSql).setParameter("ITEMNO", sRelationShip);
		rs = Sqlca.getResultSet(so);
	    if(rs.next())
	    {
	    	sItemDescribe = rs.getString(1);
	    }
	    rs.getStatement().close();
	    //ȡ��Ͷ�ʽ���������ֵ
	    sSql=" select CurrencyType,nvl(InvestmentSum,0),nvl(OughtSum,0),nvl(InvestmentProp,0),InvestDate,Effstatus "+
		     " from CUSTOMER_RELATIVE "+
		     " where CustomerID=:CustomerID and RelativeID=:RelativeID and RelationShip=:RelationShip ";
	    so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("RelativeID", sRelativeID)
	    .setParameter("RelationShip", sRelationShip);
	    rs = Sqlca.getResultSet(so);
	    if(rs.next())
	    {
	    	sCurrencyType = rs.getString(1);
	    	dInvestmentSum = rs.getDouble(2);
	    	dOughtSum = rs.getDouble(3);
	    	dInvestmentProp = rs.getDouble(4);
	    	sInvestDate = rs.getString(5);
	    	sEffstatus = rs.getString(6);
	    }
	    if(sInvestDate== null) sInvestDate = "";
	    rs.getStatement().close();
	   
	    //���·���ϵͶ�ʽ���������ֵ
	    sSql= " update CUSTOMER_RELATIVE set CURRENCYTYPE=:CURRENCYTYPE,INVESTMENTSUM=:INVESTMENTSUM,"+
		      " OUGHTSUM=:OUGHTSUM,INVESTMENTPROP=:INVESTMENTPROP,INVESTDATE=:INVESTDATE,EFFSTATUS=:EFFSTATUS "+
		      " where CUSTOMERID=:CUSTOMERID and RELATIVEID=:RELATIVEID and RELATIONSHIP=:RELATIONSHIP" ;
	    so = new SqlObject(sSql).setParameter("CURRENCYTYPE", sCurrencyType).setParameter("INVESTMENTSUM", dInvestmentSum)
	    .setParameter("OUGHTSUM", dOughtSum).setParameter("INVESTMENTPROP", dInvestmentProp).setParameter("INVESTDATE", sInvestDate)
	    .setParameter("EFFSTATUS", sEffstatus).setParameter("CUSTOMERID", sCustomerID).setParameter("RELATIVEID", sRelativeID)
	    .setParameter("RELATIONSHIP", sRelationShip);
	    Sqlca.executeSQL(so);
	    
	    //���·���ϵͶ�ʽ���������ֵ
	    sSql= " update CUSTOMER_RELATIVE set CURRENCYTYPE=:CURRENCYTYPE,INVESTMENTSUM=:INVESTMENTSUM,"+
		      " OUGHTSUM=:OUGHTSUM,INVESTMENTPROP=:INVESTMENTPROP,INVESTDATE=:INVESTDATE,EFFSTATUS=:EFFSTATUS "+
		      " where CUSTOMERID=:CUSTOMERID and RELATIVEID=:RELATIVEID and RELATIONSHIP=:RELATIONSHIP" ;
	    so = new SqlObject(sSql).setParameter("CURRENCYTYPE", sCurrencyType).setParameter("INVESTMENTSUM", dInvestmentSum)
	    .setParameter("OUGHTSUM", dOughtSum).setParameter("INVESTMENTPROP", dInvestmentProp).setParameter("INVESTDATE", sInvestDate)
	    .setParameter("EFFSTATUS", sEffstatus).setParameter("CUSTOMERID", sRelativeID).setParameter("RELATIVEID", sCustomerID)
	    .setParameter("RELATIONSHIP", sItemDescribe);
	    Sqlca.executeSQL(so);
	    return "1";
	 }
}
