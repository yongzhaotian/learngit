package com.amarsoft.app.check;

import java.text.DecimalFormat;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ���������ܶ�ȼ�飨������µ������Ƿ񳬹������ܶ�ȣ�
 * @author syang
 * @since 2009/12/19
 * @updatesuer:yhshan
 * @updatedate:2012/09/11
 * ˵����	1.�ҳ��ñ���������Ķ����Ϣ
 *			2.�ҳ��ñʶ�����µ�����
 *			3.��������Ƿ񳬳��������ܶ��
 *
 */
public class ApplyGroupCreditLineCheck extends AlarmBiz {
	

	public Object run(Transaction Sqlca) throws Exception {
		
		/* ȡ���� */
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//ȡ������JBO����
		
		
		/* �������� */
		boolean bPass = true;
		double creditSum  = 0.0;			//���������ܶ��
		double underLineSum  = 0.0;			//�������Ŷ�����������ܽ��
		String sApplyNo = jboApply.getAttribute("SerialNo").getString();		//ȡ��ҵ�������
		
		/* ������ */
		//1.�ҳ��������������
		//	�ҳ�����������Ӷ��Э���

		SqlObject so=null; //��������
		String sSql = "select LineNo from CREDITLINE_RELA where ObjectNo =:ObjectNo and ObjectType='CreditApply'";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo", sApplyNo);
		String sLineNo = Sqlca.getString(so);
		
		// �����Ӷ������Э����Ϣ����Ҫ���ҹ����ļ������Ŷ�Ⱥ�
		sSql = "select GroupLineID from CL_INFO where LineID =:LineID ";
		so = new SqlObject(sSql);
		so.setParameter("LineID", sLineNo);
		String sGroupLineID = Sqlca.getString(so);
		if(sGroupLineID != null){
			// ���Ҽ���������Ϣ
			//sSql = "select LineSum1 from CL_INFO where LineID='"+sGroupLineID+"'";
			//creditSum = Sqlca.getDouble(sSql).doubleValue();
			sSql = "select LineSum1 from CL_INFO where LineID =:LineID";
			so = new SqlObject(sSql);
			so.setParameter("LineID", sGroupLineID);	
			creditSum = Sqlca.getDouble(so);

			DecimalFormat df = new DecimalFormat("###.##");
			String sCreditSum = df.format(creditSum);
			putMsg("���Ŷ������Э���:"+sGroupLineID+",�������Ŷ�ȣ�"+sCreditSum);
			//2.�ҳ����Ŷ����������
			sSql = "select BA.CustomerID as CustomerID,BA.CustomerName as CustomerName,BA.SerialNo as ApplyNo,BA.BusinessSum as BusinessSum "
					+" from CL_INFO CI,CREDITLINE_RELA CR,BUSINESS_APPLY BA "
					+" where CI.LineID=CR.LineNo"
					+" and CR.ObjectNo=BA.SerialNo"
					+" and CR.ObjectType='CreditApply'"
					+" and CI.GroupLineID=:GroupLineID"
					;
			so = new SqlObject(sSql);
			so.setParameter("GroupLineID", sGroupLineID);
			ASResultSet rs = Sqlca.getASResultSet(so);
			while(rs.next()){
				String rsCustomerID = rs.getString("CustomerID");
				String rsCustomerName = rs.getString("CustomerName");
				String rsApplyNo = rs.getString("ApplyNo");
				double rsBusinessSum = rs.getDouble("BusinessSum");
				putMsg("�ͻ��ţ�"+rsCustomerID+"���ͻ���:"+rsCustomerName+"������ţ�"+rsApplyNo+"��������:"+rsBusinessSum);
				underLineSum += rsBusinessSum;		//����ۼ�
			}
			rs.getStatement().close();
			rs = null;
			//�ж��Ƿ񳬳��ܽ��
			if(underLineSum > creditSum){
				putMsg("������������ҵ���ܶ���ڼ������Ŷ��");
				bPass = false;
			}else{
				bPass = true;
			}
		}else{
			putMsg("���ݲ�������û�ҵ���ؼ������Ŷ����Ϣ");
			bPass = false;
		}
		/* ���ؽ������ */
		setPass(bPass);
		return null;
	}
}
