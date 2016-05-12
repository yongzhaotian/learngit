/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: �����弶��������������õķ���ھ�(��ݻ��ߺ�ͬ)����ȡ��ݻ��ߺ�ͬ����ˮ��
 *	Input Param:
 *			ObjectType:��������
 *			ObjectNo:������
 *	Output Param:
 *	HistoryLog:
 *
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetClassifySerialNo extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception {
		//��������:���BusinessDueBill���ߺ�ͬBusinessContract
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		SqlObject so=null; //��������
		//���������SQL���
		String sSerialNo = "";
		String sRelativeSerialNo = "";
		String sSql = "";
		String sClassifyType = "";
		//��ѯ���ñ������õ��弶�������ý�ݻ��Ǻ�ͬ��Ĭ�����ý�ݡ�
		sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'"; 
		sClassifyType = Sqlca.getString(sSql);
		if(!sClassifyType.equals("BusinessDueBill") && !sClassifyType.equals("BusinessContract")) {
			sClassifyType = "BusinessDueBill";
        }	
		
		//����弶���ఴ���������
		if(sClassifyType.equals("BusinessDueBill")){
			//��������Ϊ��ݶ���
			if(sObjectType.equals("BusinessDueBill")){
				//����������ˮ�Ż�ý����ˮ��
				 sSql = "select distinct ObjectNo from CLASSIFY_RECORD where SerialNo =:SerialNo ";
				 so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				 sSerialNo =  Sqlca.getString(so); 
			}
			
			//��������Ϊ��ͬ����
			if(sObjectType.equals("BusinessContract")){
				//����������ˮ�Ż�ý����ˮ��
				so = new SqlObject("select distinct ObjectNo from CLASSIFY_RECORD where SerialNo =:SerialNo ").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo =  Sqlca.getString(so);
				//���ݽ����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
		
		//����弶���ఴ�պ�ͬ������
		if(sClassifyType.equals("BusinessContract")){
			//��������Ϊ��ͬ�ݶ���
			if(sObjectType.equals("BusinessContract")){
				//����������ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct ObjectNo from CLASSIFY_RECORD where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}//�����������Ϊ���
			if(sObjectType.equals("BusinessDueBill")){
				throw new Exception("�弶���ఴ�պ�ͬ���У�����չʾ�����Ϣ��");
			}
		}
		return sSerialNo;
	}
}