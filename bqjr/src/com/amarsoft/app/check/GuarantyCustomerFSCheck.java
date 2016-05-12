package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ��֤�˲�����Ϣ���
 * @author syang
 * @since 2009/09/15
 */
public class GuarantyCustomerFSCheck extends AlarmBiz {
	
	/** ��Ա�������� **/
	String sCount="";

	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//ȡ������JBO����
		String sApplySerialNo = jboApply.getAttribute("SerialNo").getString();
		String sVouchType = jboApply.getAttribute("VouchType").getString();
		
		if(sApplySerialNo == null) sApplySerialNo = "";
		if(sVouchType == null) sVouchType = "";
		
		/** �������� **/
		ASResultSet rs=null;
		String sSql="";
		String sGuarantorID="";	
		String sGuarantorName="";
		SqlObject so = null;//��������
		
		/** ������ **/
		if(sVouchType.length()>=3) {
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,���ѯ����֤�˿ͻ�����
			if(sVouchType.substring(0,3).equals("010")){
				sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT "+
						" where SerialNo in (select ObjectNo from APPLY_RELATIVE "+
						" where SerialNo =:SerialNo "+
						" and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '010%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sApplySerialNo);
		        rs = Sqlca.getASResultSet(so);
	        	while(rs.next())
	        	{
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//�������
					String sAccMonth = "";//����·�
					String sMinAccMonth = "";//ǰ����								
					String sCurToday = StringFunction.getToday();//��ǰ����
					sAccMonth = sCurToday.substring(0,7);//����·�
					sMinAccMonth = StringFunction.getRelativeAccountMonth(sAccMonth,"Month",-3);
					so = new SqlObject("select count(RecordNo) from CUSTOMER_FSRECORD where CustomerID =:CustomerID And ReportDate >=:ReportDate");
					so.setParameter("CustomerID", sGuarantorID);
					so.setParameter("ReportDate", sMinAccMonth);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("��֤��["+sGuarantorName+"]�Ѿ���������û�еǼǲ��񱨱�");
					}			            						
				}
				rs.getStatement().close();					
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
