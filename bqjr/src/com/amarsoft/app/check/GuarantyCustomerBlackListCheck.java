package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ��֤�˺��������
 * @author syang
 * @since 2009/09/15
 */
public class GuarantyCustomerBlackListCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//ȡ������JBO����
		String sApplySerialNo = jboApply.getAttribute("SerialNo").getString();
		String sVouchType = jboApply.getAttribute("VouchType").getString();
		
		if(sApplySerialNo == null) sApplySerialNo = "";
		if(sVouchType == null) sVouchType = "";
		
		/** �������� **/
		String sCount="";
		String sSql="";
		String sGuarantorID="";	
		String sGuarantorName="";	
		ASResultSet rs=null;
		SqlObject so = null;
		
		
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
				
	        	while(rs.next()){
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//��鱣֤���Ƿ���ں�������
					so = new SqlObject("select count(SerialNo) from CUSTOMER_SPECIAL where CustomerID =:CustomerID and SectionType = '40' ");
					so.setParameter("CustomerID", sGuarantorID);
					sCount = Sqlca.getString(so);
					if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
						putMsg( "��֤��["+sGuarantorName+"]���ں������ͻ�");
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
