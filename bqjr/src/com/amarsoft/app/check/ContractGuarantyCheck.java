package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���Ǻ�ͬ������Ϣ�����Լ��
 * @author jschen
 * @since 2010/03/24
 */
public class ContractGuarantyCheck extends AlarmBiz {
	
	
	String sCount="";	
	String sSql="";
	SqlObject so = null;//��������
	
	
	public Object run(Transaction Sqlca) throws Exception {
		
		BizObject jboContract = (BizObject)this.getAttribute("BusinessContract");		//ȡ����ͬJBO����
		String sContractSerialNo = jboContract.getAttribute("SerialNo").getString();
		String sVouchType = jboContract.getAttribute("VouchType").getString();
		
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sVouchType == null) sVouchType = "";
		if(sVouchType.length()>=3) {
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,�������뱣֤������Ϣ
			if(sVouchType.substring(0,3).equals("010")){
				//��鵣����ͬ��Ϣ���Ƿ���ڱ�֤����
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from Contract_RELATIVE where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '010%' having count(SerialNo) > 0 ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sContractSerialNo);
		        sCount = Sqlca.getString(so);
				
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("��ͬ��Ϣ����Ҫ������ʽΪ��֤����û�������뱣֤�йصĵ�����Ϣ");	
					//��֤��Ϣ����Ƿ�ͨ�����õ������У������֤��Ϣû����д������������֤����Ϣ��飨ģ��010910-010970��
				}
			}
			
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,���������Ѻ������Ϣ�����һ���Ҫ����Ӧ�ĵ�Ѻ����Ϣ
			if(sVouchType.substring(0,3).equals("020"))	{
				//��鵣����ͬ��Ϣ���Ƿ���ڵ�Ѻ����
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from Contract_RELATIVE where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '050%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sContractSerialNo);
		        sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("��ͬ��Ϣ����Ҫ������ʽΪ��Ѻ����û���������Ѻ�йصĵ�����Ϣ");						
				}else{							
					sSql = 	" select count(GuarantyID) from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
							" from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo =:ObjectNo) "+
							" and GuarantyType like '010%' ";
					so = new SqlObject(sSql);
					so.setParameter("ObjectNo", sContractSerialNo);
			        sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("��ͬ��Ϣ����Ҫ������ʽΪ��Ѻ��������ĵ�Ѻ������Ϣû�е�Ѻ����Ϣ");						
					}
				}												
			}
			
			
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,����������Ѻ������Ϣ�����һ���Ҫ����Ӧ��������Ϣ
			if(sVouchType.substring(0,3).equals("040"))	{
				//��鵣����ͬ��Ϣ���Ƿ������Ѻ����
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from Contract_RELATIVE where SerialNo=:SerialNo  and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '060%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sContractSerialNo);
		        sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("��ͬ��Ϣ����Ҫ������ʽΪ��Ѻ����û����������Ѻ�йصĵ�����Ϣ");						
				}else{
					sSql = 	" select count(GuarantyID) from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
							" from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo =:ObjectNo ) "+
							" and GuarantyType like '020%' ";
					so = new SqlObject(sSql);
					so.setParameter("ObjectNo", sContractSerialNo);
			        sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("��ͬ��Ϣ����Ҫ������ʽΪ��Ѻ�����������Ѻ������Ϣû��������Ϣ");						
					}							
				}						
			}
		}
		
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
