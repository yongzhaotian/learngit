package com.amarsoft.app.als.credit.model;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.als.customer.evaluate.model.FinancialIndexCalculator;
import com.amarsoft.app.als.finance.report.FSRecordOperate;
import com.amarsoft.app.als.rating.action.CustomerRatingManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CLAcceptCalculateInit extends AbstractCLCalculateInit {

	private FinancialIndexCalculator fic = null;
	
	@Override
	protected void initModelData(JBOTransaction tx) throws JBOException {
		try{
			FSRecordOperate fso = new FSRecordOperate();
			fso.setRecordNo(this.getFsRecordNo());
			fso.setReportInfo();
			fic = new FinancialIndexCalculator(fso.getCustomerID(),fso.getReportDate(),fso.getReportScope(),fso.getReportPeriod(),fso.getAuditFlag());
			
			initFinanceData(tx);
		}
		catch(JBOException jbx){
			
		}
		catch(Exception ex){
			
		}
	}
	
	@Override
	protected String combineBomItem(JBOTransaction tx) throws JBOException {
		// TODO Auto-generated method stub
		HashMap<String, String> map = new HashMap<String, String>();
		StringBuffer sBomText = new StringBuffer();
		try{
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_DATA");
			tx.join(bm);
			BizObjectQuery bq = bm.createQuery("SerialNo=:SerialNo");
			bq.setParameter("SerialNo", this.getSerialNo());
			List ls = bq.getResultList();
			
			for(int i=0;i<=ls.size()-1;i++){
				BizObject bo = (BizObject)ls.get(i);
				String sSubjectNo = bo.getAttribute("SubjectNo").getString();
				String sValue1 = bo.getAttribute("Value1").getString();
				String sValue2 = bo.getAttribute("Value2").getString();
				String s = null;
				
				//����ȡ����ֵ
				if(sValue2==null||"".equals(sValue2)){
					s = sValue1;
				}
				else{
					s = sValue2;
				}
				
				map.put(sSubjectNo, s);
			}
			
			double d111 = Double.parseDouble(((String)map.get("1.1.1")));//������
			double d112 = Double.parseDouble(((String)map.get("1.1.2")));//����˰
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_005="+(String)map.get("1.1.1")+";");
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_006="+(String)map.get("1.1.2")+";");
			
			double d1131 = Double.parseDouble(((String)map.get("1.1.3.1")));//�ڳ��ۼ��۾�
			double d1132 = Double.parseDouble(((String)map.get("1.1.3.2")));//��ĩ�ۼ��۾�
			double d1133 = Double.parseDouble(((String)map.get("1.1.3.3")).equals("")?"0":((String)map.get("1.1.3.3")));//�̶��ʲ��������۾�
			double d113 = d1132 - d1131 + d1133;
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_007="+String.format("%.2f",d113)+";");//�̶��ʲ��۾�
			
			double d1141 = Double.parseDouble(((String)map.get("1.1.4.1")));//�ڳ������ʲ�
			double d1142 = Double.parseDouble(((String)map.get("1.1.4.2")));//��ĩ�����ʲ�
			double d1143 = Double.parseDouble(((String)map.get("1.1.4.3")).equals("")?"0":((String)map.get("1.1.4.3")));//���������ʲ��ľ�ֵ
			double d1144 = Double.parseDouble(((String)map.get("1.1.4.4")).equals("")?"0":((String)map.get("1.1.4.4")));//���������ʲ���ԭֵ
			double d114 = d1141 - d1142 - d1143 + d1144;
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_008="+String.format("%.2f",d114)+";");//�����ʲ�̯��
			
			double d1151 = Double.parseDouble(((String)map.get("1.1.5.1")));//�ڳ����ڴ�̯����
			double d1152 = Double.parseDouble(((String)map.get("1.1.5.2")));//��ĩ���ڴ�̯����
			double d1153 = Double.parseDouble(((String)map.get("1.1.5.3")).equals("")?"0":((String)map.get("1.1.5.3")));//�������ڴ�̯����
			double d115 = d1151 - d1152 + d1153;
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_009="+String.format("%.2f",d115)+";");//���ڴ�̯����̯��
			
			double d1161 = Double.parseDouble(((String)map.get("1.1.6.1")));//�������
			double d1162 = Double.parseDouble(((String)map.get("1.1.6.2")));//�ڳ������ʽ�
			double d1163 = Double.parseDouble(((String)map.get("1.1.6.3")));//��ĩ�����ʽ�
			double d1164 = Double.parseDouble(((String)map.get("1.1.6.4")).equals("")?"0":((String)map.get("1.1.6.4")));//��������
			double d116 = d1161 + (d1162 + d1163)/2*d1164/100*0.8;
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_010="+String.format("%.2f",d116)+";");//������Ϣ��֧�����ֽ�
			
			double d11 = d111 + d112 + d113 + d114 + d115 + d116;//�ͻ�EBITDA
			
			sBomText.append("R_LIMIT1.R_LIMIT1_3.R_LIMIT1_P="+(String)map.get("1.2")+";");//�ܸ�ծ/EBITDAֵP
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_002="+(String)map.get("2.1")+";");//������Ȩ��
			sBomText.append("R_LIMIT1.R_LIMIT1_3.R_LIMIT1_K="+(String)map.get("2.2")+";");//�ʲ���ծ�ʿ����ߺ���ֵK
			sBomText.append("R_LIMIT1.R_LIMIT1_4.R_LIMIT1_S1="+(String)map.get("3.1")+";");//�ͻ����õȼ�
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_001="+(String)map.get("3.2")+";");//�ܸ�ծ
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_003="+(String)map.get("3.5")+";");//�ͻ��ڱ�������ҵ�񳨿�
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_004="+(String)map.get("3.3")+";");//�����Ŵ�ҵ�����
			sBomText.append("R_LIMIT1.R_LIMIT1_1.R_LIMIT1_FINS_012="+(String)map.get("3.4")+";");//Ӧ��Ʊ���б�֤����
			
			setFinanceData(tx,"1.1.3",d113);
			setFinanceData(tx,"1.1.4",d114);
			setFinanceData(tx,"1.1.5",d115);
			setFinanceData(tx,"1.1.6",d116);
			setFinanceData(tx,"1.1",d11);
		}
		catch(JBOException jbx){
			jbx.printStackTrace();
			return null;
		}
		return sBomText.toString();	
	}
	
	/**
	 * ɾ����������
	 */
	public void deleteModelData(JBOTransaction tx,String sSerialNo) throws JBOException{
		this.setSerialNo(sSerialNo);
		this.deleteModelData(tx);
	}
	
	/**
	 * ���¿�Ŀֵ
	 */
	public void setFinanceData(JBOTransaction tx,String sSubjectNo,double value1){
		try{
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_DATA");
			tx.join(bm);
			BizObjectQuery bq = bm.createQuery("update o set value1=:value1 where SerialNo=:SerialNo and SubjectNo=:SubjectNo");
			bq.setParameter("value1", String.format("%.2f",value1));
			bq.setParameter("SerialNo", this.getSerialNo());
			bq.setParameter("SubjectNo", sSubjectNo);
			
			bq.executeUpdate();
		}
		catch(JBOException jbx){
			jbx.printStackTrace();
		}		
	}
	
	/**
	 * ���������ַ��Ϳ�Ŀֵ
	 */
	protected void setStringData(JBOTransaction tx,String sSubjectNo,String value1){
		try{
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_DATA");
			tx.join(bm);
			BizObjectQuery bq = bm.createQuery("update o set value1=:value1 where SerialNo=:SerialNo and SubjectNo=:SubjectNo");
			bq.setParameter("value1", value1);
			bq.setParameter("SerialNo", this.getSerialNo());
			bq.setParameter("SubjectNo", sSubjectNo);
			
			bq.executeUpdate();
		}
		catch(JBOException jbx){
			jbx.printStackTrace();
		}
	}
	
	/**
	 * ��ʼ��������������
	 */
	protected void initFinanceData(JBOTransaction tx) throws Exception{
		setFinanceData(tx,"1.1.1",fic.getCol2Value("333"));//������
		setFinanceData(tx,"1.1.2",fic.getCol2Value("331"));//����˰
		setFinanceData(tx,"1.1.3.1",fic.getCol1Value("503"));//�ڳ��ۼ��۾�
		setFinanceData(tx,"1.1.3.2",fic.getCol2Value("503"));//��ĩ�ۼ��۾�
		setFinanceData(tx,"1.1.4.1",fic.getCol1Value("149"));//�ڳ������ʲ�
		setFinanceData(tx,"1.1.4.2",fic.getCol2Value("149"));//��ĩ�����ʲ�
		setFinanceData(tx,"1.1.5.1",fic.getCol1Value("507"));//�ڳ����ڴ�̯����
		setFinanceData(tx,"1.1.5.2",fic.getCol2Value("507"));//��ĩ���ڴ�̯����
		setFinanceData(tx,"1.1.6.1",fic.getCol2Value("311"));//�������
		setFinanceData(tx,"1.1.6.2",fic.getCol1Value("101"));//�ڳ������ʽ�
		setFinanceData(tx,"1.1.6.3",fic.getCol2Value("101"));//��ĩ�����ʽ�
		setFinanceData(tx,"2.1",fic.getCol2Value("266"));//������Ȩ��
		setFinanceData(tx,"3.2",fic.getCol2Value("246"));//�ܸ�ծ
		
		setFinanceData(tx,"1.2",7);//����ҵ���ܸ�ծ/EBITDA
		setFinanceData(tx,"2.2",0.8);//�ʲ���ծ�ʵĿ����ߺͺ���ֵ
		
		CustomerRatingManager crm = new CustomerRatingManager();
		setStringData(tx,"3.1",crm.getCusRatingResult(this.getCustomerID()));	
	}	
}
