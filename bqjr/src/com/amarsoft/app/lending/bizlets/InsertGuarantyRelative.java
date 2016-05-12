package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-12
Tester:
Describe: --���롢������������ͺ�ͬ�н�������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ�����ϵ
		  --Ŀǰ����ҳ�棺ApplyImpawnInfo1��ApplyPawnInfo1��ApproveImpawnInfo1��
		  ApprovePawnInfo1��ContractImpawnInfo1��ContractPawnInfo1
Input Param:
		ObjectType����������
		ObjectNo��������
		ContractNo: ������ͬ���
		GuarantyID: ����Ѻ����
		Channel��������Դ��New��������Copy��������
Output Param:
		
HistoryLog:
*/

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		String sChannel = (String)this.getAttribute("Channel");
		String sType = (String)this.getAttribute("Type");
		
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";	
		if(sChannel == null) sChannel = "";
		if(sType == null) sType = "";
				
		//�������		
		ASResultSet rs = null;//��ѯ�����
		String sSql = "";//Sql���
		String sReturnFlag = "";//���ر�־
		int iCount = 0;//��¼��	
		SqlObject so;
		
		//��֤������ϵ�Ƿ��Ѵ���
		sSql = 	" select count(ObjectNo) from GUARANTY_RELATIVE "+
		" where ObjectType =:ObjectType "+
		" and ObjectNo =:ObjectNo "+
		" and ContractNo =:ContractNo "+
		" and GuarantyID =:GuarantyID ";
		so = new SqlObject(sSql);
		so.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo)
		.setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
		rs = Sqlca.getASResultSet(so);
		if (rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		//��������ڹ�����ϵ�����½�������ϵ
		if(iCount < 1)
		{
			//��������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ����ϵ
			//�������ͣ���ͬ��BusinessContract���������ţ���ͬ��ţ���������ͬ��š�����Ѻ���š�������ϵ��Դ������������New��������Copy������Ч��־��1����Ч��2����Ч����������Դ���ͣ�Add��������Import�����룩
			sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type)"+
			" values(:ObjectType,:ObjectNo,:ContractNo,:GuarantyID,:Channel,'1',:Type) ";
			so = new SqlObject(sSql);
			so.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sContractNo)
			.setParameter("GuarantyID", sGuarantyID).setParameter("Channel", sChannel).setParameter("Type", sType);
	
			Sqlca.executeSQL(so);
			sReturnFlag = "1";//������ϵ�Ѿ��ɹ�����
		}else
		{
			sReturnFlag = "0";//������ϵ�Ѿ����ڣ�����Ҫ�ٽ��н���
		}
				
		return sReturnFlag;
	}		
}
