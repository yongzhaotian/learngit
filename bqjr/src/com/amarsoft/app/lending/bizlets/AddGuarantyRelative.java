package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-12
Tester:
Describe: --������ͬ�����н�������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ�����ϵ
		  --Ŀǰ����ҳ�棺ValidAssureImpawnInfo1��ValidAssureImpawnInfo2��
		  ValidAssurePawnInfo1��ValidAssurePawnInfo2
Input Param:
		ContractNo: ������ͬ���
		GuarantyID: ����Ѻ����
Output Param:

HistoryLog:
*/

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		String sChannel = (String)this.getAttribute("Channel");
		String sType = (String)this.getAttribute("Type");
		
		//����ֵת��Ϊ���ַ���
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
		if(sChannel == null) sChannel = "";
		if(sType == null) sType = "";
				
		SqlObject so = null; //��������
		//�������		
		ASResultSet rs = null;//��ѯ�����
		String sSql = "";//Sql���
		String sSerialNo = "";//��ͬ���			
		int iCount = 0;//��¼��	
		
		//���ݵ�����ͬ��Ż�ȡ���ҵ���ͬ���
		sSql = 	" select SerialNo from CONTRACT_RELATIVE "+
		" where ObjectType = 'GuarantyContract' "+
		" and ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sContractNo);
		
		//ĿǰALS6.5�汾ֻ���������������߶����ͬ����ObjectNo��һ��Ĭ��ֵ��NewGC��,û�и��κε�ҵ���ͬ������add by jgao1
		boolean IsExist = false;//��ʾ�Ƿ����ҵ���ͬ�ţ�Ĭ��Ϊ������
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			IsExist = true;//��ʾ����ҵ���ͬ��
		}
		rs.getStatement().close();
		if(IsExist)	{	
			rs = Sqlca.getASResultSet(so);
			while (rs.next())
			{
				sSerialNo = rs.getString("SerialNo");
				//��֤�ù�����ϵ�Ƿ��Ѵ���
				sSql = 	" select count(ObjectNo) from GUARANTY_RELATIVE "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo =:ObjectNo "+
				" and ContractNo =:ContractNo "+
				" and GuarantyID =:GuarantyID ";
				so = new SqlObject(sSql);
				so.setParameter("ObjectNo", sSerialNo).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
				ASResultSet rs1 = Sqlca.getASResultSet(so);
				if (rs1.next())
					iCount = rs1.getInt(1);
				rs1.getStatement().close();
			
				//��������ڹ�����ϵ����������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ����ϵ
				if(iCount < 1)
				{
					//�������ͣ���ͬ��BusinessContract���������ţ���ͬ��ţ���������ͬ��š�����Ѻ���š�������ϵ��Դ������������New��������Copy������Ч��־��1����Ч��2����Ч����������Դ���ͣ�Add��������Import�����룩
					sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type,RelationStatus)"+
					" values('BusinessContract',:ObjectNo,:ContractNo,:GuarantyID,:Channel,'1',:Type,'010') ";
					so = new SqlObject(sSql);
					so.setParameter("ObjectNo", sSerialNo).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID)
					.setParameter("Channel", sChannel).setParameter("Type", sType);
					Sqlca.executeSQL(so);
					
				}
			}		
			rs.getStatement().close();
		}else{
			//��֤�ù�����ϵ�Ƿ��Ѵ���
			sSql = 	" select count(ContractNo) from GUARANTY_RELATIVE "+
			" where ObjectType = 'BusinessContract' "+
			" and ContractNo =:ContractNo "+
			" and GuarantyID =:GuarantyID ";
			so =  new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
			ASResultSet rs1 = Sqlca.getASResultSet(so);
			if (rs1.next())
				iCount = rs1.getInt(1);
			rs1.getStatement().close();
		
			//��������ڹ�����ϵ����������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ����ϵ
			if(iCount < 1)
			{
				//�������ͣ���ͬ��BusinessContract���������ţ���ͬ��ţ���������ͬ��š�����Ѻ���š�������ϵ��Դ������������New��������Copy������Ч��־��1����Ч��2����Ч����������Դ���ͣ�Add��������Import�����룩
				sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type,RelationStatus)"+
				" values('BusinessContract','NewGC',:ContractNo,:GuarantyID,:Channel,'1',:Type,'010') ";
				so = new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID).setParameter("Channel", sChannel).setParameter("Type", sType);
				Sqlca.executeSQL(so);
			}
			else{    //added by yzheng 2013-06-20
				String relationStatus = "";
				sSql = 	" select RelationStatus from GUARANTY_RELATIVE where ContractNo=:ContractNo and GuarantyID=:GuarantyID ";
				so = new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
				rs1 = Sqlca.getASResultSet(so);
				if (rs1.next())
					relationStatus = rs1.getString("RelationStatus");
				rs1.getStatement().close();
				
				if(relationStatus.equals("010")){  //�ظ�����
					return "2";  
				}
				else{  //֮ǰ������ֱ�ɾ��
					sSql = 	" update GUARANTY_RELATIVE set RelationStatus = '010' where ContractNo=:ContractNo and GuarantyID=:GuarantyID ";
					so = new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
					Sqlca.executeSQL(so);
				}
			}
		}				
		return "1";
	}		
}
