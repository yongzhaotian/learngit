package com.amarsoft.app.als.credit.model;


import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.als.customer.evaluate.model.FinancialConstants;
import com.amarsoft.app.als.customer.evaluate.model.FinancialIndexCalculator;
import com.amarsoft.app.als.finance.report.FSRecordOperate;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CLTrendCalculateInit extends AbstractCLCalculateInit {

	private FinancialIndexCalculator fic = null;
	private FinancialIndexCalculator ficly = null;
	private FinancialIndexCalculator ficbly = null;
	FSRecordOperate fso = null;
	
	@Override
	protected void initModelData(JBOTransaction tx) throws JBOException {
		// TODO Auto-generated method stub
		try{
			fso = new FSRecordOperate();
			fso.setRecordNo(this.getFsRecordNo());
			fso.setReportInfo();
			fic = new FinancialIndexCalculator(fso.getCustomerID(),fso.getReportDate(),fso.getReportScope(),fso.getReportPeriod(),fso.getAuditFlag());
			ficly = fic.getLYReport(-12);//�����걨
			ficbly = fic.getLYReport(-24);//�������걨
			
			initFinanceData(tx);
		}
		catch(JBOException jbx){
			
		}
		catch(Exception ex){
			
		}

	}

	protected String combineBomItem(JBOTransaction tx) throws JBOException {
		// TODO Auto-generated method stub
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
				
				if(s==null)s="";
				
				map.put(sSubjectNo, s);
			}
			
			sBomText.append("R_LIMIT2.R_CYCLE.R_CYCLE_10="+(String)map.get("1.1.2")+";");//ǰ������Ӫҵ��ɱ���ƽ��������a
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_001="+(String)map.get("2.5.5")+";");//���ڵ����ʲ�
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_002="+(String)map.get("2.3")+";");//���ڸ�ծ
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_004="+(String)map.get("2.5.1")+";");//���ڹ�ȨͶ��
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_006="+(String)map.get("2.5.2")+";");//����ծȨͶ��
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_007="+(String)map.get("2.4.4")+";");//��̯����
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_008="+(String)map.get("2.2.1")+";");//���ڽ��
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_009="+(String)map.get("2.4.1")+";");//����Ͷ��
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_012="+(String)map.get("2.5.3")+";");//�̶��ʲ�
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_013="+(String)map.get("1.1.1")+";");//���ڵ���Ӫҵ��ɱ�K0
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_014="+(String)map.get("2.5.6")+";");//���������ʲ�
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_016="+(String)map.get("2.4.7")+";");//���������ʲ�
			
			//����δ���Ԥ����á�Ӧ������������������ծ
			double d = ("".equals(((String)map.get("2.2.4")))?0:Double.parseDouble(((String)map.get("2.2.4"))))+
			("".equals(((String)map.get("2.2.5")))?0:Double.parseDouble(((String)map.get("2.2.5"))))+
			("".equals(((String)map.get("2.2.6")))?0:Double.parseDouble(((String)map.get("2.2.6"))))+
			("".equals(((String)map.get("2.2.7")))?0:Double.parseDouble(((String)map.get("2.2.7"))));
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_018="+String.format("%.2f",d)+";");
			
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_019="+(String)map.get("2.2.3")+";");//����Ӧ����
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_020="+(String)map.get("2.4.3")+";");//����Ӧ�տ�
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_022="+(String)map.get("2.1")+";");//������Ȩ��С��
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_024="+(String)map.get("2.5.4")+";");//�����ʲ�
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_025="+(String)map.get("2.4.5")+";");//һ�굽�ڵ�Ͷ��
			
			double d1 = ("".equals(((String)map.get("2.2.2")))?0:Double.parseDouble(((String)map.get("2.2.2"))))-
						("".equals(((String)map.get("2.2.2.1")))?0:Double.parseDouble(((String)map.get("2.2.2.1"))));
			
			double d22 = Double.parseDouble(((String)map.get("2.2.1")))+
						Double.parseDouble(((String)map.get("2.2.2")))-
						("".equals(((String)map.get("2.2.2.1")))?0:Double.parseDouble(((String)map.get("2.2.2.1"))))+
						Double.parseDouble(((String)map.get("2.2.3")))+
						Double.parseDouble(((String)map.get("2.2.4")))+
						Double.parseDouble(((String)map.get("2.2.5")))+
						Double.parseDouble(((String)map.get("2.2.6")))+
						Double.parseDouble(((String)map.get("2.2.7")));
			
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_026="+String.format("%.2f",d1)+";");//Ӧ��Ʊ��
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_027="+(String)map.get("2.4.2")+";");////Ӧ�չ���
			
			sBomText.append("R_LIMIT2.R.R_01="+(String)map.get("3")+";");//���г����������B
			sBomText.append("R_LIMIT2.R.R_03="+(String)map.get("1.2")+";");//��Ӫ����c
			sBomText.append("R_LIMIT2.R.R_04="+(String)map.get("4")+";");//���г����������C
			
			setFinanceData(tx,"2.2",d22);
		}
		catch(JBOException jbx){
			jbx.printStackTrace();
			return null;
		}
		return sBomText.toString();	
	} 
	
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
	
	private double getMainBiz(FinancialIndexCalculator cy,FinancialIndexCalculator ly){
		if(cy!=null&&ly!=null){
			double d1 = 0,d2 = 0;
			d1 = ly.getCol2Value("303");
			d2 = cy.getCol2Value("303");
			if(d1 == 0){
				return 0;
			}
			else{
				return (d2-d1)/d1*100;
			}
		}else{
			return 0.00;
		}
	}
	
	/**
	 * ��ȡ����ָ��
	 */
	private double getFinanceSubValue(FinancialIndexCalculator cy,String s){
		try{
			if(cy!=null){
				return cy.getColValue(s);
			}else{
				return 0.00;
			}
		}
		catch(Exception jbx){
			return 0.00;
		}
	}
	
	/**
	 * ��ȡ����ָ��
	 */
	private String getFinanceSubValueString(FinancialIndexCalculator cy,String s){
		try{
			if(cy!=null){
				return String.format("%.2f",cy.getColValue(s));
			}else{
				return "";
			}
		}
		catch(Exception jbx){
			return "";
		}
	}
	
	/**
	 * ��ʼ��������������
	 */
	protected void initFinanceData(JBOTransaction tx) throws Exception{
		
		//�Ǿ�Ӫ�Ե�������ծ=���ڽ��+Ӧ��Ʊ��+����Ӧ����+δ����ϼ�+Ԥ�����+Ӧ������+����������ծ
		double b2 = 	fic.getCol2Value("200")+
							fic.getCol2Value("204")+
							fic.getCol2Value("218")+
							fic.getCol2Value("571")+
							fic.getCol2Value("219")+
							fic.getCol2Value("216")+
							fic.getCol2Value("222");
		
		//�Ǿ�Ӫ�Ե������ʲ�=����Ͷ�ʾ���+Ӧ�չ���+����Ӧ�տ�+��̯����+һ���ڵ��ڵķ������ʲ�+�����������ʲ�����ʧ+���������ʲ�
		double b4 = 	fic.getCol2Value("106")+
							fic.getCol2Value("113")+
							fic.getCol2Value("115")+
							fic.getCol2Value("120")+
							fic.getCol2Value("119")+
							fic.getCol2Value("122")+
							fic.getCol2Value("121");
		
		//�����ʲ�=���ڹ�ȨͶ��+����ծȨͶ��+�̶��ʲ�+�����ʲ�+�����������ʲ�
		double b5 = 	fic.getCol2Value("133")+
							fic.getCol2Value("134")+
							fic.getCol2Value("137")+
							fic.getCol2Value("149")+
							fic.getCol2Value("159")+fic.getCol2Value("154");
		
		setFinanceData(tx,"2.1",fic.getCol2Value("266"));//������Ȩ��
		setFinanceData(tx,"2.2.1",fic.getCol2Value("200"));//���ڽ��
		setFinanceData(tx,"2.2.2",fic.getCol2Value("204"));//Ӧ��Ʊ��
		setFinanceData(tx,"2.2.3",fic.getCol2Value("218"));//����Ӧ����
		setFinanceData(tx,"2.2.4",fic.getCol2Value("223"));//δ����ϼ�
		setFinanceData(tx,"2.2.5",fic.getCol2Value("219"));//Ԥ�����
		setFinanceData(tx,"2.2.6",fic.getCol2Value("216"));//Ӧ������
		setFinanceData(tx,"2.2.7",fic.getCol2Value("222"));//����������ծ
		setFinanceData(tx,"2.2",b2);					//�Ǿ�Ӫ�Ե�������ծ
		
		setFinanceData(tx,"2.3",fic.getCol2Value("237"));//���ڸ�ծ
		
		setFinanceData(tx,"2.4.1",fic.getCol2Value("106"));//����Ͷ�ʾ���
		setFinanceData(tx,"2.4.2",fic.getCol2Value("113"));//Ӧ�չ���
		setFinanceData(tx,"2.4.3",fic.getCol2Value("115"));//����Ӧ�տ�
		setFinanceData(tx,"2.4.4",fic.getCol2Value("120"));//��̯����
		setFinanceData(tx,"2.4.5",fic.getCol2Value("119"));//һ���ڵ��ڵķ������ʲ�
		setFinanceData(tx,"2.4.6",fic.getCol2Value("122"));//�����������ʲ�����ʧ
		setFinanceData(tx,"2.4.7",fic.getCol2Value("121"));//���������ʲ�
		setFinanceData(tx,"2.4",b4);					//�Ǿ�Ӫ�Ե������ʲ�
		
		setFinanceData(tx,"2.5.1",fic.getCol2Value("133"));//���ڹ�ȨͶ��
		setFinanceData(tx,"2.5.2",fic.getCol2Value("134"));//����ծȨͶ��
		//�������жϱ�������
		String sFinanceBelong = fso.getFinanceBelong();
		if("020".equals(sFinanceBelong)){
			setFinanceData(tx,"2.5.3",fic.getCol2Value("154"));//�̶��ʲ�
		}
		else{
			setFinanceData(tx,"2.5.3",fic.getCol2Value("137"));//�̶��ʲ�
		}
		
		setFinanceData(tx,"2.5.4",fic.getCol2Value("149"));//�����ʲ�
		setFinanceData(tx,"2.5.5",0.00);				   //���ڵ����ʲ�
		setFinanceData(tx,"2.5.6",fic.getCol2Value("159"));//���������ʲ�
		setFinanceData(tx,"2.5",b5);					  //�����ʲ�
		
		
		setFinanceData(tx,"1.1.2.1",getMainBiz(ficly,ficbly));//ǰ������Ӫҵ��������
		setFinanceData(tx,"1.1.2.2",getMainBiz(fic,ficly));//ǰһ����Ӫҵ��������
		setFinanceData(tx,"1.1.2",(getMainBiz(ficly,ficbly)+getMainBiz(fic,ficly))/2);//ǰ������Ӫҵ��ƽ��������
		
		setFinanceData(tx,"1.1.1",fic.getCol2Value("303"));//��Ӫҵ��ɱ�
		
		setStringData(tx,"1.2.1.1",getFinanceSubValueString(fic,FinancialConstants.ACCOUNT_TURN_OVER_DAYS));//ǰһ��Ӧ���˿���ת����
		setStringData(tx,"1.2.1.2",getFinanceSubValueString(fic,FinancialConstants.STOCK_TURN_OVER_DAYS));//ǰһ������ת����
		setStringData(tx,"1.2.1.3",getFinanceSubValueString(fic,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS));//ǰһ��Ӧ���˿���ת����
		setStringData(tx,"1.2.1.4",getFinanceSubValueString(fic,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS));//ǰһ��Ԥ���˿���ת����
		setStringData(tx,"1.2.1.5",getFinanceSubValueString(fic,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS));//ǰһ��Ԥ���˿���ת����
		
		//ǰһ��ľ�Ӫ����=Ӧ���˿���ת����+�����ת����-Ӧ���˿���ת����+Ԥ���˿���ת����-Ԥ���˿���ת����
		double d1 = getFinanceSubValue(fic,FinancialConstants.ACCOUNT_TURN_OVER_DAYS)+
					getFinanceSubValue(fic,FinancialConstants.STOCK_TURN_OVER_DAYS)-
					getFinanceSubValue(fic,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS)+
					getFinanceSubValue(fic,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS)-
					getFinanceSubValue(fic,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS);
		
		setFinanceData(tx,"1.2.1",d1);					  //ǰһ�꾭Ӫ����
		
		setStringData(tx,"1.2.2.1",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNT_TURN_OVER_DAYS));//ǰ����Ӧ���˿���ת����
		setStringData(tx,"1.2.2.2",getFinanceSubValueString(ficly,FinancialConstants.STOCK_TURN_OVER_DAYS));//ǰ��������ת����
		setStringData(tx,"1.2.2.3",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS));//ǰ����Ӧ���˿���ת����
		setStringData(tx,"1.2.2.4",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS));//ǰ����Ԥ���˿���ת����
		setStringData(tx,"1.2.2.5",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS));//ǰ����Ԥ���˿���ת����
		
		//ǰ����ľ�Ӫ����=Ӧ���˿���ת����+�����ת����-Ӧ���˿���ת����+Ԥ���˿���ת����-Ԥ���˿���ת����
		double d2 = getFinanceSubValue(ficly,FinancialConstants.ACCOUNT_TURN_OVER_DAYS)+
					getFinanceSubValue(ficly,FinancialConstants.STOCK_TURN_OVER_DAYS)-
					getFinanceSubValue(ficly,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS)+
					getFinanceSubValue(ficly,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS)-
					getFinanceSubValue(ficly,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS);
		
		setFinanceData(tx,"1.2.2",d2);				      //ǰ���꾭Ӫ����
		setFinanceData(tx,"1.2",(d1+d2)/2);				  //δ��һ��ľ�Ӫ����			
	}
}
