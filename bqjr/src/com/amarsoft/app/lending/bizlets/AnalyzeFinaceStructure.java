package com.amarsoft.app.lending.bizlets;

import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 获取财务分析结果
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

	//从REPORT_DATA表获取最新一期的财务分析结果数据
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
	//获取实际得分，计算方法：根据给出的最大得分逐步扣分
	//计算公式是：实际得分=最大得分-（基准值-实际值）*步长
	private double getItemScorebyMinus(double MaxScore,double MinScore,double NormValue,double ActualValue,double Step){
		double ActualScore=0.0;
		ActualScore=MaxScore-(NormValue-ActualValue)*Step;
		//实际得分不能大于最大得分
		if(ActualScore>MaxScore)ActualScore=MaxScore;
		//实际得分不能小于最小得分
		return ActualScore;
	}
	//获取实际得分，计算方法：根据给出的最小得分逐步加分
	//计算公式是：实际得分=最小得分+（实际值-基准值）*步长
	private double getItemScorebyAplus(double MaxScore,double MinScore,double NormValue,double ActualValue,double Step){
		double ActualScore=0.0;
		ActualScore=MinScore+(ActualValue-NormValue)*Step;
		//实际得分不能大于最大得分
		if(ActualScore>MaxScore)ActualScore=MaxScore;
		//实际得分不能小于最小得分
		return ActualScore;
	}
	//根据财务分析结果项、最大得分、最小得分、基准值、实际值的极值、步长
	private double getItemScore(String RowSubject, double MaxScore,double MinScore,double NormValue,double LimitValue,double Step,int CalculateMethod){
		//定义实际得分、实际值
		double ActualScore=0.0,ActualValue=0.0;
		ActualValue=getItemValue(RowSubject);
		//根据给出的最大得分逐步扣分
		if(CalculateMethod==Minus){
			//基准值是最大值，实际值的极值是最小值
			if(NormValue>=LimitValue){
				if(ActualValue>=NormValue)ActualScore=MaxScore;
				else if(ActualValue<=LimitValue)ActualScore=MinScore;
				else ActualScore=getItemScorebyMinus(MaxScore,MinScore,NormValue,ActualValue,Step);
			}
			//基准值是最小值，实际值的极值是最大值
			else{
				if(ActualValue<=NormValue)ActualScore=MaxScore;
				else if(ActualValue>=LimitValue)ActualScore=MinScore;
				//因为基准值是最小值，Step应该是负数，才能计算出实际得分小于最大得分
				else ActualScore=getItemScorebyMinus(MaxScore,MinScore,NormValue,ActualValue,-Step);
			}
		}
		//根据给出的最小得分逐步加分
		else if(CalculateMethod==Aplus){
			//基准值是最小值，实际值的极值是最大值
			if(NormValue<=LimitValue){
				if(ActualValue<=NormValue)ActualScore=MinScore;
				else if(ActualValue>=LimitValue)ActualScore=MaxScore;
				else ActualScore=getItemScorebyAplus(MaxScore,MinScore,NormValue,ActualValue,Step);
			}else{
				//基准值是最大值，实际值的极值是最小值
				if(ActualValue>=NormValue)ActualScore=MinScore;
				else if(ActualValue<=LimitValue)ActualScore=MaxScore;
				//因为基准值是最大值，Step应该是负数，才能计算出实际得分大于最小得分
				else ActualScore=getItemScorebyAplus(MaxScore,MinScore,NormValue,ActualValue,-Step);
			}
		}
		return ActualScore;
	}
	//获取财务相应项的评估结果
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
	//获取财务结构得分
	private double getFinaceScore(){
		double ActualScore=0.0;
		//获取净资产与年末贷款余额比率得分
		ActualScore+=getItemScore("923",6,0,1,0.4,10,Minus);
		//获取资产负债率得分
		//获取净资产
		double ActualAssetsValue=getItemValue("808");
		if(ActualAssetsValue<1000000000.0)
			ActualScore+=getItemScore("911",7,0,0.6,0.88,25,Minus);
		else
			ActualScore+=getItemScore("911",7,0,0.65,0.88,31,Minus);
		//获取资本固定化比率得分
		ActualScore+=getItemScore("924",4,0,0.8,2,3.3,Minus);
		return ActualScore;
	}
	//获取偿债能力得分
	private double getRefundScore(){
		double ActualScore=0.0;
		//获取流动比率得分
		ActualScore+=getItemScore("915",6,0,1.5,1,12,Minus);//modify by hlhu
		//获取速动比率得分
		ActualScore+=getItemScore("916",6,0,1,5,12,Minus);
		//获取非筹资性现金净流入与流动负债比率得分
		ActualScore+=getItemScore("925",6,0,0.15,0,40,Minus);
		//获取利息保障倍数得分
		//获取净资产
		double ActualAssetsValue=getItemValue("808");
		if(ActualAssetsValue<1000000000.0)
			ActualScore+=getItemScore("914",6,0,3,1,3,Minus);
		else if(ActualAssetsValue>=1000000000.0&&ActualAssetsValue<2000000000.0)
			ActualScore+=getItemScore("914",6,0,2.5,1,4,Minus);
		else
			ActualScore+=getItemScore("914",6,0,2,1,6,Minus);
		//获取担保比率得分
		ActualScore+=getItemScore("929",5,0,0.5,1,10,Minus);
		return ActualScore;
	}
	//获取经营能力得分
	private double getManagementSocre(){
		double ActualScore=0.0;
		//获取主营收入现金率得分
		ActualScore+=getItemScore("934",6,0,1,0.5,12,Minus);//modify by hlhu
		//获取应收帐款周转速度得分
		ActualScore+=getItemScore("907",4,0,7,2,0.8,Minus);
		//获取存货周转速动得分
		ActualScore+=getItemScore("908",4,0,5,1,1,Minus);
		return ActualScore;
	}
	//获取经营效益得分
	private double getBenefitScore(){
		double ActualScore=0.0;
		//获取毛利率得分
		ActualScore+=getItemScore("931",4,0,0.2,0.04,25,Minus);//modify by hlhu
		//获取营业利润率得分
		ActualScore+=getItemScore("902",4,0,0.1,0.02,50,Minus);//modify by hlhu
		//获取净资产收益率得分
		//获取净资产
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
			ActualScore+=getItemScore("909",4,0,0.04,0.01,13.3,Minus);//modify by hlhu ？？？
		else
			ActualScore+=getItemScore("909",4,0,0.03,0.01,200,Minus);
		return ActualScore;
	}
	//获取财务状况得分
	private double getTotalFinaceScore(){
		double ActualScore=0.0;
		//获取财务结构得分
		ActualScore+=getFinaceScore();//17
		//获取偿债能力得分
		ActualScore+=getRefundScore();//29
		//获取经营能力得分
		ActualScore+=getManagementSocre();//14
		//获取经营效益得分
		ActualScore+=getBenefitScore();//16
		//获取有形长期资产得分
		double  LongAssetsValue=getItemValue("125");
		if(LongAssetsValue>4000000000.0)
			ActualScore+=10;
		else if(LongAssetsValue<=4000000000.0&&LongAssetsValue>2000000000.0)
			ActualScore+=8;
		else if(LongAssetsValue<=2000000000.0&&LongAssetsValue>200000000.0)
			ActualScore+=5;
		else
			ActualScore+=LongAssetsValue/200000000.0*5;
		//获取净资产得分
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
	//获取财务状况分析结果
	private String getFinanceStructureAnalyzeResult(){
		String result="";
		//获取财务状况得分
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
		//获取财务分析数据
		getReportData(Sqlca,sCustomerID,sFSAccountMonth,sReportScope);
		//获取财务状况分析结果
		String result=getFinanceStructureAnalyzeResult();
		return result;
	}

}
