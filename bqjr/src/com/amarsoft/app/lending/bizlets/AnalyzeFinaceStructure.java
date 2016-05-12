package com.amarsoft.app.lending.bizlets;

import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ��ȡ����������
 * @author sxwang
 * @modify hlhu 2009-10-20
 *
 */
public class AnalyzeFinaceStructure extends Bizlet {
	private Properties ReportData=null;
	private String sCustomerID="";
	private String sFSAccountMonth="";
	private String sReportScope="";
	private static int Minus=1;
	private static int Aplus=2;

	//��REPORT_DATA���ȡ����һ�ڵĲ�������������
	private Properties getReportData(Transaction Sqlca,String sCustomerID,String sFSAccountMonth,String sReportScope){
		if(sCustomerID==null)sCustomerID="";
		if(sFSAccountMonth==null)sFSAccountMonth="";
		if(sReportScope==null)sReportScope="";
		
		boolean bNeedGetData=false;
		if(ReportData!=null)
			if(!sCustomerID.equals(this.sCustomerID)||!sFSAccountMonth.equals(this.sFSAccountMonth)||!sReportScope.equals(this.sReportScope)){
				bNeedGetData=true;
				this.sCustomerID=sCustomerID;
				this.sFSAccountMonth=sFSAccountMonth;
				this.sReportScope=sReportScope;
			}				
		if(ReportData==null||bNeedGetData){
			if(ReportData!=null){
				ReportData.clear();
				ReportData=null;
			}
			ReportData=new Properties();
			try{
				String sSql = "SELECT RowSubject,nvl(Col2Value,0)as Col2Value FROM REPORT_DATA where ReportNo in (select ReportNo from REPORT_RECORD where ObjectNo =:ObjectNo and ReportDate=:ReportDate and ReportScope = :ReportScope)";
				ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", sCustomerID).setParameter("ReportDate", sFSAccountMonth).setParameter("ReportScope", sReportScope));
				while(rs.next()){
					String RowSubject=rs.getString("RowSubject");
					String  Col2Value=rs.getString("Col2Value");
					if(RowSubject==null)RowSubject="";
					if(Col2Value==null)Col2Value="";
					ReportData.setProperty(RowSubject, Col2Value);
				}
				rs.getStatement().close();
			}catch(Exception e){
				ARE.getLog().error(e.getMessage());
			}
		}
		return ReportData;
	}
	//��ȡʵ�ʵ÷֣����㷽�������ݸ��������÷��𲽿۷�
	//���㹫ʽ�ǣ�ʵ�ʵ÷�=���÷�-����׼ֵ-ʵ��ֵ��*����
	private double getItemScorebyMinus(double MaxScore,double MinScore,double NormValue,double ActualValue,double Step){
		double ActualScore=0.0;
		ActualScore=MaxScore-(NormValue-ActualValue)*Step;
		//ʵ�ʵ÷ֲ��ܴ������÷�
		if(ActualScore>MaxScore)ActualScore=MaxScore;
		//ʵ�ʵ÷ֲ���С����С�÷�
		return ActualScore;
	}
	//��ȡʵ�ʵ÷֣����㷽�������ݸ�������С�÷��𲽼ӷ�
	//���㹫ʽ�ǣ�ʵ�ʵ÷�=��С�÷�+��ʵ��ֵ-��׼ֵ��*����
	private double getItemScorebyAplus(double MaxScore,double MinScore,double NormValue,double ActualValue,double Step){
		double ActualScore=0.0;
		ActualScore=MinScore+(ActualValue-NormValue)*Step;
		//ʵ�ʵ÷ֲ��ܴ������÷�
		if(ActualScore>MaxScore)ActualScore=MaxScore;
		//ʵ�ʵ÷ֲ���С����С�÷�
		return ActualScore;
	}
	//���ݲ�������������÷֡���С�÷֡���׼ֵ��ʵ��ֵ�ļ�ֵ������
	private double getItemScore(String RowSubject, double MaxScore,double MinScore,double NormValue,double LimitValue,double Step,int CalculateMethod){
		//����ʵ�ʵ÷֡�ʵ��ֵ
		double ActualScore=0.0,ActualValue=0.0;
		ActualValue=getItemValue(RowSubject);
		//���ݸ��������÷��𲽿۷�
		if(CalculateMethod==Minus){
			//��׼ֵ�����ֵ��ʵ��ֵ�ļ�ֵ����Сֵ
			if(NormValue>=LimitValue){
				if(ActualValue>=NormValue)ActualScore=MaxScore;
				else if(ActualValue<=LimitValue)ActualScore=MinScore;
				else ActualScore=getItemScorebyMinus(MaxScore,MinScore,NormValue,ActualValue,Step);
			}
			//��׼ֵ����Сֵ��ʵ��ֵ�ļ�ֵ�����ֵ
			else{
				if(ActualValue<=NormValue)ActualScore=MaxScore;
				else if(ActualValue>=LimitValue)ActualScore=MinScore;
				//��Ϊ��׼ֵ����Сֵ��StepӦ���Ǹ��������ܼ����ʵ�ʵ÷�С�����÷�
				else ActualScore=getItemScorebyMinus(MaxScore,MinScore,NormValue,ActualValue,-Step);
			}
		}
		//���ݸ�������С�÷��𲽼ӷ�
		else if(CalculateMethod==Aplus){
			//��׼ֵ����Сֵ��ʵ��ֵ�ļ�ֵ�����ֵ
			if(NormValue<=LimitValue){
				if(ActualValue<=NormValue)ActualScore=MinScore;
				else if(ActualValue>=LimitValue)ActualScore=MaxScore;
				else ActualScore=getItemScorebyAplus(MaxScore,MinScore,NormValue,ActualValue,Step);
			}else{
				//��׼ֵ�����ֵ��ʵ��ֵ�ļ�ֵ����Сֵ
				if(ActualValue>=NormValue)ActualScore=MinScore;
				else if(ActualValue<=LimitValue)ActualScore=MaxScore;
				//��Ϊ��׼ֵ�����ֵ��StepӦ���Ǹ��������ܼ����ʵ�ʵ÷ִ�����С�÷�
				else ActualScore=getItemScorebyAplus(MaxScore,MinScore,NormValue,ActualValue,-Step);
			}
		}
		return ActualScore;
	}
	//��ȡ������Ӧ����������
	private double getItemValue(String RowSubject){
		double ActualValue=0.0;
		if(ReportData!=null&&RowSubject!=null){
			String Col2Value=ReportData.getProperty(RowSubject);
			if(Col2Value==null||Col2Value.trim().length()==0)
				ActualValue=0.0;
			else
				ActualValue=Double.parseDouble(Col2Value);
		}
		return ActualValue;
	}
	//��ȡ����ṹ�÷�
	private double getFinaceScore(){
		double ActualScore=0.0;
		//��ȡ���ʲ�����ĩ���������ʵ÷�
		ActualScore+=getItemScore("923",6,0,1,0.4,10,Minus);
		//��ȡ�ʲ���ծ�ʵ÷�
		//��ȡ���ʲ�
		double ActualAssetsValue=getItemValue("808");
		if(ActualAssetsValue<1000000000.0)
			ActualScore+=getItemScore("911",7,0,0.6,0.88,25,Minus);
		else
			ActualScore+=getItemScore("911",7,0,0.65,0.88,31,Minus);
		//��ȡ�ʱ��̶������ʵ÷�
		ActualScore+=getItemScore("924",4,0,0.8,2,3.3,Minus);
		return ActualScore;
	}
	//��ȡ��ծ�����÷�
	private double getRefundScore(){
		double ActualScore=0.0;
		//��ȡ�������ʵ÷�
		ActualScore+=getItemScore("915",6,0,1.5,1,12,Minus);//modify by hlhu
		//��ȡ�ٶ����ʵ÷�
		ActualScore+=getItemScore("916",6,0,1,5,12,Minus);
		//��ȡ�ǳ������ֽ�������������ծ���ʵ÷�
		ActualScore+=getItemScore("925",6,0,0.15,0,40,Minus);
		//��ȡ��Ϣ���ϱ����÷�
		//��ȡ���ʲ�
		double ActualAssetsValue=getItemValue("808");
		if(ActualAssetsValue<1000000000.0)
			ActualScore+=getItemScore("914",6,0,3,1,3,Minus);
		else if(ActualAssetsValue>=1000000000.0&&ActualAssetsValue<2000000000.0)
			ActualScore+=getItemScore("914",6,0,2.5,1,4,Minus);
		else
			ActualScore+=getItemScore("914",6,0,2,1,6,Minus);
		//��ȡ�������ʵ÷�
		ActualScore+=getItemScore("929",5,0,0.5,1,10,Minus);
		return ActualScore;
	}
	//��ȡ��Ӫ�����÷�
	private double getManagementSocre(){
		double ActualScore=0.0;
		//��ȡ��Ӫ�����ֽ��ʵ÷�
		ActualScore+=getItemScore("934",6,0,1,0.5,12,Minus);//modify by hlhu
		//��ȡӦ���ʿ���ת�ٶȵ÷�
		ActualScore+=getItemScore("907",4,0,7,2,0.8,Minus);
		//��ȡ�����ת�ٶ��÷�
		ActualScore+=getItemScore("908",4,0,5,1,1,Minus);
		return ActualScore;
	}
	//��ȡ��ӪЧ��÷�
	private double getBenefitScore(){
		double ActualScore=0.0;
		//��ȡë���ʵ÷�
		ActualScore+=getItemScore("931",4,0,0.2,0.04,25,Minus);//modify by hlhu
		//��ȡӪҵ�����ʵ÷�
		ActualScore+=getItemScore("902",4,0,0.1,0.02,50,Minus);//modify by hlhu
		//��ȡ���ʲ������ʵ÷�
		//��ȡ���ʲ�
		double ActualAssetsValue=getItemValue("808");
		if(ActualAssetsValue<1000000000.0)
			ActualScore+=getItemScore("932",4,0,0.08,0.01,57,Minus);
		else if(ActualAssetsValue>=1000000000.0&&ActualAssetsValue<2000000000.0)
			ActualScore+=getItemScore("932",4,0,0.06,0.01,80,Minus);
		else
			ActualScore+=getItemScore("932",4,0,0.04,0.01,130,Minus);
		if(ActualAssetsValue<1000000000)
			ActualScore+=getItemScore("909",4,0,0.06,0.01,80,Minus);
		else if(ActualAssetsValue>=1000000000.0&&ActualAssetsValue<2000000000.0)
			ActualScore+=getItemScore("909",4,0,0.04,0.01,13.3,Minus);//modify by hlhu ������
		else
			ActualScore+=getItemScore("909",4,0,0.03,0.01,200,Minus);
		return ActualScore;
	}
	//��ȡ����״���÷�
	private double getTotalFinaceScore(){
		double ActualScore=0.0;
		//��ȡ����ṹ�÷�
		ActualScore+=getFinaceScore();//17
		//��ȡ��ծ�����÷�
		ActualScore+=getRefundScore();//29
		//��ȡ��Ӫ�����÷�
		ActualScore+=getManagementSocre();//14
		//��ȡ��ӪЧ��÷�
		ActualScore+=getBenefitScore();//16
		//��ȡ���γ����ʲ��÷�
		double  LongAssetsValue=getItemValue("125");
		if(LongAssetsValue>4000000000.0)
			ActualScore+=10;
		else if(LongAssetsValue<=4000000000.0&&LongAssetsValue>2000000000.0)
			ActualScore+=8;
		else if(LongAssetsValue<=2000000000.0&&LongAssetsValue>200000000.0)
			ActualScore+=5;
		else
			ActualScore+=LongAssetsValue/200000000.0*5;
		//��ȡ���ʲ��÷�
		double ActualAssetsValue=getItemValue("808");
		if(ActualAssetsValue>2000000000.0)
			ActualScore+=14;
		else if(ActualAssetsValue<=2000000000.0&&ActualAssetsValue>1000000000.0)
			ActualScore+=11;
		else if(ActualAssetsValue<=1000000000.0&&ActualAssetsValue>10000000.0)
			ActualScore+=7;
		else
			ActualScore+=ActualAssetsValue/10000000.0*7;
		return ActualScore;
	}
	//��ȡ����״���������
	private String getFinanceStructureAnalyzeResult(){
		String result="";
		//��ȡ����״���÷�
		double ActualScore=getTotalFinaceScore();
		if(ActualScore>=75)result="01";
		else if(ActualScore>=60)result="02";
		else if(ActualScore>=50)result="03";
		else if(ActualScore>=40)result="04";
		else result="05";
		return result;
	}
	public Object run(Transaction Sqlca) throws Exception {
		String sCustomerID=(String)this.getAttribute("CustomerID");
		String sFSAccountMonth=(String)this.getAttribute("FSAccountMonth");
		String sReportScope=	(String)this.getAttribute("ReportScope");
		if(sCustomerID==null)sCustomerID="";
		if(sFSAccountMonth==null)sFSAccountMonth="";
		if(sReportScope==null)sReportScope="";		
		//��ȡ�����������
		getReportData(Sqlca,sCustomerID,sFSAccountMonth,sReportScope);
		//��ȡ����״���������
		String result=getFinanceStructureAnalyzeResult();
		return result;
	}

}
