/**
 * 		Author: --zywei 2005-08-13
 * 		Tester:
 * 		Describe: --̽���ͬ����
 * 		Input Param:
 * 				ObjectType: ��������
 * 				ObjectNo: ������
 * 		Output Param:
 * 				Message��������ʾ��Ϣ
 * 		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckContractRisk extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
				
		//�����������ʾ��Ϣ��SQL��䡢ҵ�����Ʒ����
		String sMessage = "",sSql = "",sBusinessSum = "",sBusinessType = "";
		//�����������Ҫ������ʽ�������������������
		String sVouchType = "",sMainTable = "",sRelativeTable = "";
		//����������ݴ��־,��������־
		String sTempSaveFlag = "",sContinueCheckFlag = "TRUE";		
		//���������Ʊ������
		int iBillNum = 0,iNum = 0;
		//�����������ѯ�����
		ASResultSet rs = null,rs1 = null;			
		
		//���ݶ������ͻ�ȡ�������
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = :ObjectType ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType));
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//����ֵת���ɿ��ַ���
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------��һ��������ͬ��Ϣ�Ƿ�ȫ������---------------
			//����Ӧ�Ķ���������л�ȡ����Ʒ���͡�Ʊ����������������
			sSql = 	" select TempSaveFlag,BusinessSum,BusinessType,BillNum,VouchType "+
					" from "+sMainTable+" where SerialNo = :SerialNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				sBusinessSum = rs.getString("BusinessSum");				
				sBusinessType = rs.getString("BusinessType");
				iBillNum = rs.getInt("BillNum");
				sVouchType = rs.getString("VouchType");
				
				//����ֵת���ɿ��ַ���
				if (sTempSaveFlag == null) sTempSaveFlag = "";
				if (sBusinessSum == null) sBusinessSum = "";
				if (sBusinessType == null) sBusinessType = "";
				if (sVouchType == null) sVouchType = "";
								
				if (sTempSaveFlag.equals("010")) {			
					sMessage = "��ͬ������ϢΪ�ݴ�״̬��������д���ͬ������Ϣ��������水ť��"+"@";
					sContinueCheckFlag = "FALSE";							
				}			
			}
			rs.getStatement().close(); 
		}
		
		if(sContinueCheckFlag.equals("TRUE"))
		{					
			//--------------�ڶ�������鵣����ͬ�Ƿ�ȫ������---------------
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ���ã����ж��Ƿ����뵣����Ϣ����������˵�����Ϣ������ʾ
			if (sVouchType.equals("005")) {
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType='GuarantyContract') having count(SerialNo) > 0";

				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum > 0)
					sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ���ã���Ӧ�����뵣����Ϣ���������Ҫ������ʽ��ɾ��������Ϣ��"+"@";
			}else //����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤�����Ѻ������Ѻ�����ж��Ƿ����뵣����Ϣ
			{
				if(sVouchType.length()>=3) {
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,�������뱣֤������Ϣ
					if(sVouchType.substring(0,3).equals("010"))
					{
						//��鵣����ͬ��Ϣ���Ƿ���ڱ�֤����
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '010%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��֤����û�������뱣֤�йصĵ�����Ϣ���������Ҫ������ʽ�����뱣֤������Ϣ��"+"@";
					}
					
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,���������Ѻ������Ϣ�����һ���Ҫ����Ӧ�ĵ�Ѻ����Ϣ
					if(sVouchType.substring(0,3).equals("020"))	{
						//��鵣����ͬ��Ϣ���Ƿ���ڵ�Ѻ����
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '050%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û���������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ�������Ѻ������Ϣ��"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= :SerialNo and ObjectType = 'GuarantyContract') and GuarantyType in ('050')";
							rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
							while(rs.next()) //ѭ���ж�ÿ����Ѻ��ͬ
							{
								String sGCNo =  rs.getString("SerialNo");  //��õ�����ͬ��ˮ��
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType=:ObjectType"+
								       " and ObjectNo =:ObjectNo and ContractNo = :ContractNo) "; 
								rs1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("ObjectType", sObjectType).
										setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sGCNo));
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//�жϵ�����ͬ�����Ƿ��ж�Ӧ��
								if (iNum <= 0)
								{
								    sMessage="������ͬ���Ϊ:"+sGCNo+"�ĵ�����ͬ�����޶�Ӧ�ĵ�Ѻ��Ϣ��@";
								}
						     }
						     rs.getStatement().close();
						}										
					}
					
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,����������Ѻ������Ϣ�����һ���Ҫ����Ӧ��������Ϣ
					if(sVouchType.substring(0,3).equals("040"))	{
						//��鵣����ͬ��Ϣ���Ƿ������Ѻ����
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '060%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						if(iNum == 0)								
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û����������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ��������Ѻ������Ϣ��"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= :SerialNo and ObjectType = 'GuarantyContract') and GuarantyType in ('060')";
							rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
							while(rs.next()) //ѭ���ж�ÿ����Ѻ��ͬ
							{
								String sGCNo =  rs.getString("SerialNo");  //��õ�����ͬ��ˮ��
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType=:ObjectType"+
								       " and ObjectNo =:ObjectNo and ContractNo = :ContractNo) "; 
								rs1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("ObjectType", sObjectType)
										.setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sGCNo));
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//�жϵ�����ͬ�����Ƿ��ж�Ӧ��
								if (iNum <= 0)
								{
								    sMessage="������ͬ���Ϊ:"+sGCNo+"�ĵ�����ͬ�����޶�Ӧ����Ѻ��Ϣ��@";
								}
						     }
						     rs.getStatement().close();
						}												
					}	
				}else{
					if(!sBusinessType.substring(0,4).equals("1020")){
						sMessage  += "�ñʺ�ͬû����д��Ҫ������ʽ��"+"@";
					}
					//sMessage  += "������ж������Ҫ������ʽ���С��3λ��CODE_LIBRARY.VouchType:"+sVouchType+"���������ĳЩ����Ҫ�ز���̽���������˶Ժ�������̽�⣡"+"@";
				}
			}
			
			//--------------���������������ҵ�����Ʊ��ҵ����Ϣһ��---------------
			if(sBusinessType.length()>=4) {
				//�����Ʒ����Ϊ����ҵ��
				if(sBusinessType.substring(0,4).equals("1020"))	{
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = :ObjectType and ObjectNo = :ObjectNo "+
							" having sum(BillSum) = :BusinessSum ";
					rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType)
							.setParameter("ObjectNo", sObjectNo).setParameter("BusinessSum", sBusinessSum));
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage  += "ҵ�����Ʊ�ݽ���ܺͲ�����"+"@";
										
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = :ObjectType and ObjectNo = :ObjectNo "+
							" having count(SerialNo) = :BillNum ";
					rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType)
							.setParameter("ObjectNo", sObjectNo).setParameter("BillNum", iBillNum));
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage += "ҵ���������Ʊ�������������Ʊ������������"+"@";
				}					
			}else{
				sMessage  += "��Ʒ���ж���Ĳ�Ʒ���С��4λ��BUSINESS_TYPE.TypeNo:"+sBusinessType+"���������ĳЩ����Ҫ�ز���̽���������˶Ժ�������̽�⣡"+"@";
			}	
		}
		
		return sMessage;
	 }
	 

}
