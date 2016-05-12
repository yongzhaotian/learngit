package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ��������֤������������ҵ����
 * @author syang
 * @since 2009/11/12
 */
public class ApproveGuaCustOactivityCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApprove");		//ȡ������JBO����
		String sApproveSerialNo = jboApply.getAttribute("SerialNo").getString();
		String sVouchType = jboApply.getAttribute("VouchType").getString();
		
		if(sApproveSerialNo == null) sApproveSerialNo = "";
		if(sVouchType == null) sVouchType = "";
		
		/** �������� **/
		String sCount="";
		String sSql="";
		String sGuarantorID="";	
		String sGuarantorName="";	
		ASResultSet rs=null;
		ASResultSet rs1=null;
		SqlObject so = null;//��������
		
		/** ������ **/
		if(sVouchType.length()>=3) {
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,���ѯ����֤�˿ͻ�����
			if(sVouchType.substring(0,3).equals("010")){
				sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT "+
						" where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
						" where SerialNo =:SerialNo "+
						" and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '010%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sApproveSerialNo);
		        rs = Sqlca.getASResultSet(so);
				
	        	while(rs.next()){
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//���з�Χ��	
	            	sSql = 	" select count(*) from CUSTOMER_OACTIVITY "+
					" where CustomerID =:CustomerID "+					
					" and UptoDate <=:UptoDate ";
	            	so = new SqlObject(sSql);
					so.setParameter("CustomerID", sGuarantorID);
					so.setParameter("UptoDate", StringFunction.getToday());
			        sCount = Sqlca.getString(so);
	            	
					if( sCount != null && Integer.parseInt(sCount,10) > 0 ){	
						putMsg("��֤��["+sGuarantorName+"]������δ���������ҵ�������"+sCount);
						sSql = 	" select sum(BusinessSum*getERate(Currency,'01','')) as BusinessSum, "+
								" sum(Balance*getERate(Currency,'01','')) as BalanceSum "+
								" from CUSTOMER_OACTIVITY "+
								" where CustomerID =:CustomerID "+
								" and UptoDate <=:UptoDate ";
						so = new SqlObject(sSql);
						so.setParameter("CustomerID", sGuarantorID);
						so.setParameter("UptoDate", StringFunction.getToday());
				        rs1 = Sqlca.getResultSet(so);
						
						if(rs1.next()){
							String sBusinessSum = rs1.getString("BusinessSum");
							String sBalanceSum = rs1.getString("BalanceSum");
							if(sBusinessSum == null) sBusinessSum = "0.00";
							if(sBalanceSum == null) sBalanceSum = "0.00";
							putMsg("��֤��["+sGuarantorName+"]������δ���������ҵ�񷢷��ܽ�������ң���"+DataConvert.toMoney(sBusinessSum));
							putMsg("��֤��["+sGuarantorName+"]������δ���������ҵ������������ң���"+DataConvert.toMoney(sBalanceSum));
						}
						rs1.getStatement().close();
						rs1 = null;
					}		            	
				}
				rs.getStatement().close();
				rs = null;
			}
		}
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
