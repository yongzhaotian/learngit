/*
Author:   bwang
Tester:
Describe: ���õȼ��϶�����Ҫ�����õȼ���¼���и���
Input Param:
		ObjectNo: ������
		sObjectType:��������
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishEvaluate extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//������
		String sObjectNo = (String)this.getAttribute("sObjectNo");
		String sObjectType = (String)this.getAttribute("sObjectType");

		String sFOSerialNo ="";//���������ˮ���
		double dUserScore=0;//�˹��϶�����
		String sUserResult="";//�˹��϶����
		String sCognReason="";//�˹��϶�����
		String sInputTime="";//�˹��϶�����
		String sInputUser="";//�˹��϶���
		String sInputOrg="";//�˹��϶�����
		String sCustomerID="";//�϶��ͻ����

		String sSql = "";
		ASResultSet rs=null;
		SqlObject so=null;
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		//��ѯ�϶���ɺ������϶��˵���������������
		sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
		" where ObjectType=:ObjectType "+
		" and ObjectNo=:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sFOSerialNo=rs.getString("OpinionNo");
		}
		if(sFOSerialNo==null)sFOSerialNo="";
		rs.getStatement().close();

		//ȡ�����϶������
		sSql = 	" select BailSum as CognScore,PhaseOpinion2 as CognResult,"+//�˹����������
		" InputTime,InputUser,InputOrg,"+//�˹��϶�����,�϶��� ���϶�����
		" PhaseOpinion as CognReason"+
		" from Flow_Opinion"+
		" where OpinionNo=:OpinionNo";
		so = new SqlObject(sSql).setParameter("OpinionNo", sFOSerialNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			dUserScore =rs.getDouble("CognScore");//�˹��϶�����
			sUserResult=rs.getString("CognResult");//�˹��϶����
			sCognReason=rs.getString("CognReason");//�˹��϶�����
			sInputTime =rs.getString("InputTime");//�˹��϶�����
			sInputUser =rs.getString("InputUser");//�˹��϶���
			sInputOrg  =rs.getString("InputOrg");//�˹��϶�����
		}
		if(sUserResult==null)sUserResult="";
		if(sCognReason==null)sCognReason="";
		if(sInputTime==null)sInputTime="";
		if(sInputUser==null)sInputUser="";
		if(sInputOrg==null)sInputOrg="";
		rs.getStatement().close();

		//�������õȼ���¼��
		sSql=" UPDATE EVALUATE_RECORD SET CognDate=:CognDate,"+
		" CognScore=:CognScore,CognResult=:CognResult,"+
		" CognReason=:CognReason,"+
		" FinishDate=:FinishDate,"+
		" CognOrgID=:CognOrgID,CognUserID=:CognUserID "+
		" WHERE SerialNo=:SerialNo AND ObjectType=:ObjectType ";
		so = new SqlObject(sSql);
		so.setParameter("CognDate", sInputTime).setParameter("CognScore", dUserScore).setParameter("CognResult", sUserResult)
		.setParameter("CognReason", sCognReason).setParameter("FinishDate", sInputTime).setParameter("CognOrgID", sInputOrg)
		.setParameter("CognUserID", sInputUser).setParameter("SerialNo", sObjectNo).setParameter("ObjectType", sObjectType);
		Sqlca.executeSQL(so);
		
		//��ѯ�϶��ͻ�CustomerID
		sSql = 	" select ObjectNo from EVALUATE_RECORD where ObjectType=:ObjectType and SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sCustomerID=rs.getString("ObjectNo");
		}
		if(sCustomerID==null)sCustomerID="";
		rs.getStatement().close();
		
		//�������õȼ����ռ�¼
		sSql=" UPDATE ENT_INFO SET EvaluateDate=:EvaluateDate,CreditLevel=:CreditLevel "+
		 " WHERE CustomerID=:CustomerID ";
		so = new SqlObject(sSql);
		so.setParameter("EvaluateDate", sInputTime).setParameter("CreditLevel", sUserResult).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		
		//�������õȼ����ռ�¼
		sSql=" UPDATE IND_INFO SET EvaluateDate=:EvaluateDate,CreditLevel=:CreditLevel "+
		 " WHERE CustomerID=:CustomerID ";
		so = new SqlObject(sSql).setParameter("EvaluateDate", sInputTime).setParameter("CreditLevel", sUserResult).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		
		return "1";

	}

}

