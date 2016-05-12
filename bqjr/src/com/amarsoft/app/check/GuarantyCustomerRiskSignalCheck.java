package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ��֤�˵�Ԥ���źż��
 * @author syang
 * @since 2009/09/15
 */
public class GuarantyCustomerRiskSignalCheck extends AlarmBiz {
	
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
		String sSql="";
		ASResultSet rs=null;
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
				
	        	while(rs.next()){
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//���ÿͻ��Ƿ��������Ч��Ԥ����Ϣ
	            	so = new SqlObject("select count(SerialNo) from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo =:ObjectNo and SignalType = '1'");
					so.setParameter("ObjectNo", sGuarantorID);
					sCount = Sqlca.getString(so);
	            	if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
						putMsg("��֤��["+sGuarantorName+"]������Ч��Ԥ���ź�");
					}					
				}
				rs.getStatement().close();
				rs  = null;
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
