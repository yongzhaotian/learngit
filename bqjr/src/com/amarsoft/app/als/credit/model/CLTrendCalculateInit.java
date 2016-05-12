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
			ficly = fic.getLYReport(-12);//上年年报
			ficbly = fic.getLYReport(-24);//上两年年报
			
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
				
				//优先取调整值
				if(sValue2==null||"".equals(sValue2)){
					s = sValue1;
				}
				else{
					s = sValue2;
				}
				
				if(s==null)s="";
				
				map.put(sSubjectNo, s);
			}
			
			sBomText.append("R_LIMIT2.R_CYCLE.R_CYCLE_10="+(String)map.get("1.1.2")+";");//前两年主营业务成本的平均增长率a
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_001="+(String)map.get("2.5.5")+";");//长期递延资产
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_002="+(String)map.get("2.3")+";");//长期负债
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_004="+(String)map.get("2.5.1")+";");//长期股权投资
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_006="+(String)map.get("2.5.2")+";");//长期债权投资
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_007="+(String)map.get("2.4.4")+";");//待摊费用
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_008="+(String)map.get("2.2.1")+";");//短期借款
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_009="+(String)map.get("2.4.1")+";");//短期投资
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_012="+(String)map.get("2.5.3")+";");//固定资产
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_013="+(String)map.get("1.1.1")+";");//基期的主营业务成本K0
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_014="+(String)map.get("2.5.6")+";");//其他长期资产
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_016="+(String)map.get("2.4.7")+";");//其他流动资产
			
			//其他未交款、预提费用、应付股利、其他流动负债
			double d = ("".equals(((String)map.get("2.2.4")))?0:Double.parseDouble(((String)map.get("2.2.4"))))+
			("".equals(((String)map.get("2.2.5")))?0:Double.parseDouble(((String)map.get("2.2.5"))))+
			("".equals(((String)map.get("2.2.6")))?0:Double.parseDouble(((String)map.get("2.2.6"))))+
			("".equals(((String)map.get("2.2.7")))?0:Double.parseDouble(((String)map.get("2.2.7"))));
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_018="+String.format("%.2f",d)+";");
			
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_019="+(String)map.get("2.2.3")+";");//其他应付款
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_020="+(String)map.get("2.4.3")+";");//其他应收款
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_022="+(String)map.get("2.1")+";");//所有者权益小计
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_024="+(String)map.get("2.5.4")+";");//无形资产
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_025="+(String)map.get("2.4.5")+";");//一年到期的投资
			
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
			
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_026="+String.format("%.2f",d1)+";");//应付票据
			sBomText.append("R_LIMIT2.R_FINS.R_FINS_027="+(String)map.get("2.4.2")+";");////应收股利
			
			sBomText.append("R_LIMIT2.R.R_01="+(String)map.get("3")+";");//本行敞口授信余额B
			sBomText.append("R_LIMIT2.R.R_03="+(String)map.get("1.2")+";");//经营周期c
			sBomText.append("R_LIMIT2.R.R_04="+(String)map.get("4")+";");//他行敞口授信余额C
			
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
	 * 更新科目值
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
	 * 更新其他字符型科目值
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
	 * 获取财务指标
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
	 * 获取财务指标
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
	 * 初始化基础财务数据
	 */
	protected void initFinanceData(JBOTransaction tx) throws Exception{
		
		//非经营性的流动负债=短期借款+应付票据+其他应付款+未交款合计+预提费用+应付股利+其他流动负债
		double b2 = 	fic.getCol2Value("200")+
							fic.getCol2Value("204")+
							fic.getCol2Value("218")+
							fic.getCol2Value("571")+
							fic.getCol2Value("219")+
							fic.getCol2Value("216")+
							fic.getCol2Value("222");
		
		//非经营性的流动资产=短期投资净额+应收股利+其他应收款+待摊费用+一年内到期的非流动资产+待处理流动资产净损失+其他流动资产
		double b4 = 	fic.getCol2Value("106")+
							fic.getCol2Value("113")+
							fic.getCol2Value("115")+
							fic.getCol2Value("120")+
							fic.getCol2Value("119")+
							fic.getCol2Value("122")+
							fic.getCol2Value("121");
		
		//长期资产=长期股权投资+长期债权投资+固定资产+无形资产+其他非流动资产
		double b5 = 	fic.getCol2Value("133")+
							fic.getCol2Value("134")+
							fic.getCol2Value("137")+
							fic.getCol2Value("149")+
							fic.getCol2Value("159")+fic.getCol2Value("154");
		
		setFinanceData(tx,"2.1",fic.getCol2Value("266"));//所有者权益
		setFinanceData(tx,"2.2.1",fic.getCol2Value("200"));//短期借款
		setFinanceData(tx,"2.2.2",fic.getCol2Value("204"));//应付票据
		setFinanceData(tx,"2.2.3",fic.getCol2Value("218"));//其他应付款
		setFinanceData(tx,"2.2.4",fic.getCol2Value("223"));//未交款合计
		setFinanceData(tx,"2.2.5",fic.getCol2Value("219"));//预提费用
		setFinanceData(tx,"2.2.6",fic.getCol2Value("216"));//应付股利
		setFinanceData(tx,"2.2.7",fic.getCol2Value("222"));//其他流动负债
		setFinanceData(tx,"2.2",b2);					//非经营性的流动负债
		
		setFinanceData(tx,"2.3",fic.getCol2Value("237"));//长期负债
		
		setFinanceData(tx,"2.4.1",fic.getCol2Value("106"));//短期投资净额
		setFinanceData(tx,"2.4.2",fic.getCol2Value("113"));//应收股利
		setFinanceData(tx,"2.4.3",fic.getCol2Value("115"));//其他应收款
		setFinanceData(tx,"2.4.4",fic.getCol2Value("120"));//待摊费用
		setFinanceData(tx,"2.4.5",fic.getCol2Value("119"));//一年内到期的非流动资产
		setFinanceData(tx,"2.4.6",fic.getCol2Value("122"));//待处理流动资产净损失
		setFinanceData(tx,"2.4.7",fic.getCol2Value("121"));//其他流动资产
		setFinanceData(tx,"2.4",b4);					//非经营性的流动资产
		
		setFinanceData(tx,"2.5.1",fic.getCol2Value("133"));//长期股权投资
		setFinanceData(tx,"2.5.2",fic.getCol2Value("134"));//长期债权投资
		//这里需判断报表类型
		String sFinanceBelong = fso.getFinanceBelong();
		if("020".equals(sFinanceBelong)){
			setFinanceData(tx,"2.5.3",fic.getCol2Value("154"));//固定资产
		}
		else{
			setFinanceData(tx,"2.5.3",fic.getCol2Value("137"));//固定资产
		}
		
		setFinanceData(tx,"2.5.4",fic.getCol2Value("149"));//无形资产
		setFinanceData(tx,"2.5.5",0.00);				   //长期递延资产
		setFinanceData(tx,"2.5.6",fic.getCol2Value("159"));//其他长期资产
		setFinanceData(tx,"2.5",b5);					  //长期资产
		
		
		setFinanceData(tx,"1.1.2.1",getMainBiz(ficly,ficbly));//前两年主营业务增长率
		setFinanceData(tx,"1.1.2.2",getMainBiz(fic,ficly));//前一年主营业务增长率
		setFinanceData(tx,"1.1.2",(getMainBiz(ficly,ficbly)+getMainBiz(fic,ficly))/2);//前两年主营业务平均增长率
		
		setFinanceData(tx,"1.1.1",fic.getCol2Value("303"));//主营业务成本
		
		setStringData(tx,"1.2.1.1",getFinanceSubValueString(fic,FinancialConstants.ACCOUNT_TURN_OVER_DAYS));//前一年应收账款周转天数
		setStringData(tx,"1.2.1.2",getFinanceSubValueString(fic,FinancialConstants.STOCK_TURN_OVER_DAYS));//前一年存货周转天数
		setStringData(tx,"1.2.1.3",getFinanceSubValueString(fic,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS));//前一年应付账款周转天数
		setStringData(tx,"1.2.1.4",getFinanceSubValueString(fic,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS));//前一年预付账款周转天数
		setStringData(tx,"1.2.1.5",getFinanceSubValueString(fic,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS));//前一年预收账款周转天数
		
		//前一年的经营周期=应收账款周转天数+存货周转天数-应付账款周转天数+预付账款周转天数-预收账款周转天数
		double d1 = getFinanceSubValue(fic,FinancialConstants.ACCOUNT_TURN_OVER_DAYS)+
					getFinanceSubValue(fic,FinancialConstants.STOCK_TURN_OVER_DAYS)-
					getFinanceSubValue(fic,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS)+
					getFinanceSubValue(fic,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS)-
					getFinanceSubValue(fic,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS);
		
		setFinanceData(tx,"1.2.1",d1);					  //前一年经营周期
		
		setStringData(tx,"1.2.2.1",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNT_TURN_OVER_DAYS));//前两年应收账款周转天数
		setStringData(tx,"1.2.2.2",getFinanceSubValueString(ficly,FinancialConstants.STOCK_TURN_OVER_DAYS));//前两年存货周转天数
		setStringData(tx,"1.2.2.3",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS));//前两年应付账款周转天数
		setStringData(tx,"1.2.2.4",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS));//前两年预付账款周转天数
		setStringData(tx,"1.2.2.5",getFinanceSubValueString(ficly,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS));//前两年预收账款周转天数
		
		//前两年的经营周期=应收账款周转天数+存货周转天数-应付账款周转天数+预付账款周转天数-预收账款周转天数
		double d2 = getFinanceSubValue(ficly,FinancialConstants.ACCOUNT_TURN_OVER_DAYS)+
					getFinanceSubValue(ficly,FinancialConstants.STOCK_TURN_OVER_DAYS)-
					getFinanceSubValue(ficly,FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS)+
					getFinanceSubValue(ficly,FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS)-
					getFinanceSubValue(ficly,FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS);
		
		setFinanceData(tx,"1.2.2",d2);				      //前两年经营周期
		setFinanceData(tx,"1.2",(d1+d2)/2);				  //未来一年的经营周期			
	}
}
