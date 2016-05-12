package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddRelation extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRelativeID = (String)this.getAttribute("RelativeID");
		String sRelationShip = (String)this.getAttribute("RelationShip");
		
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";
		if(sRelationShip == null) sRelationShip = "";
		
		SqlObject so = null; //��������
		//�������
		String sSql = "";
		String sNewRelation = "";
		
		String sCustomerName = "";
		String sCertType = "";
		String sCertID = "";
		ASResultSet rs = null;
				
		//ȡ������ϵ����
		sSql = 	" select ItemDescribe from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo =:ItemNo ";
		sNewRelation = Sqlca.getString(new SqlObject(sSql).setParameter("ItemNo", sRelationShip));
		if(sNewRelation == null) sNewRelation = "";
		
		//ȡ���ͻ��Լ��Ŀͻ����ƣ�֤�����ͣ�֤������
		sSql = 	" select CustomerName,CertType,CertID from CUSTOMER_INFO where CustomerID =:CustomerID";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));	
		if (rs.next()){
			sCustomerName = rs.getString("CustomerName");	
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
			if(sCustomerName == null) sCustomerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
		}
		rs.getStatement().close();
		
		//��ɾ������ϵ����ֹ����ʧ��
		sSql =  " delete from CUSTOMER_RELATIVE where CustomerID=:CustomerID and RelativeID=:RelativeID and RelationShip=:RelationShip ";
		so = new SqlObject(sSql).setParameter("CustomerID", sRelativeID).setParameter("RelativeID", sCustomerID).setParameter("RelationShip", sNewRelation);
		Sqlca.executeSQL(so);
		
		//���뷴��ϵ��¼�������ֶ���ͬ����ϵ���룬�ͻ����֣�֤�����ͣ�֤��������ȡ����ֵ����
		sSql =  " insert into CUSTOMER_RELATIVE(CustomerID,RelativeID,RelationShip,CustomerName,"+
				" CertType,CertID,FictitiousPerson,CurrencyType,InvestmentSum,OughtSum,InvestmentProp,"+
				" InvestDate,Duty,Telephone,"+
				" Describe,InputOrgID,InputUserID,InputDate,UpdateDate,Remark,EFFSTATUS) "+
				" select RelativeID,CustomerID,'"+sNewRelation+"','"+sCustomerName+"','"+sCertType+"','"+sCertID+"',"+
				" FictitiousPerson,CurrencyType,InvestmentSum,OughtSum,InvestmentProp,"+
				" InvestDate,Duty,Telephone,"+
				" Describe,InputOrgID,InputUserID,"+
				" InputDate,UpdateDate,Remark,EFFSTATUS FROM CUSTOMER_RELATIVE "+
				" where CustomerID=:CustomerID and RelativeID=:RelativeID and RelationShip=:RelationShip2";
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID).setParameter("RelativeID", sRelativeID).setParameter("RelationShip2", sRelationShip);
		Sqlca.executeSQL(so);
		
		return "1";
	}

}
