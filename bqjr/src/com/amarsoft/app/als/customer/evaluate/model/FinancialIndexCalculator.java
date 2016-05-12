package com.amarsoft.app.als.customer.evaluate.model;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;

public class FinancialIndexCalculator {
	private HashMap<String, Double> reportData1 = null;
	private HashMap<String, Double> reportData2 = null;
	private HashMap<String, Double> reportData3 = null;
	private String customerID = null;
	private String reportDate = null;
	private String reportScope = null;
	private String reportPeriod = null;
	private String auditFlag = null;
	
	private boolean hasCurReport = false;
	private boolean hasLastYearEndReport = false;
	private boolean hasLastTermReport = false;
	
	private BizObjectManager m = null;
	private BizObjectQuery q = null;
	private BizObject bo = null;
	private List boList = null;
	
	public FinancialIndexCalculator(String sCustomerID,String sReportDate,String sReportScope,String sReportPeriod,String sAuditFlag) throws Exception{
		this.customerID = sCustomerID;
		this.reportDate = sReportDate;
		this.reportScope = sReportScope;
		this.reportPeriod = sReportPeriod;
		this.auditFlag = sAuditFlag;
		
		//期初值
		this.reportData1 = new HashMap<String, Double>();
		//期末值
		this.reportData2 = new HashMap<String, Double>();
		//上一期期初值
		this.reportData3 = new HashMap<String, Double>();
		init();
		initCol3Value();
	}
	
	public void init() throws Exception{
		//初始化当期报表科目值
		String sReportNos = "";
		m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_RECORD");
		String sSql = "select ReportNo from O where " +
			"ObjectNo = :ObjectNo and " +
			"ReportDate = :ReportDate and " +
			"ReportScope = :ReportScope";
		q = m.createQuery(sSql);
		q.setParameter("ObjectNo",customerID);
		q.setParameter("ReportDate",reportDate);
		q.setParameter("ReportScope",reportScope);
		boList = q.getResultList();

		for (int i = 0;i<boList.size();i++){
			bo = (BizObject)boList.get(i);
			sReportNos += ",'"+bo.getAttribute("ReportNo")+"'";
		}
		
		if(sReportNos.length()>1){
			sReportNos = sReportNos.substring(1);
			this.hasCurReport = true;
		}else{
			throw new Exception("找不到对应报表！["+customerID+"]["+reportDate+"]["+reportScope+"]");
		}
		
		m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_DATA");

		sSql = "select RowSubject,Col1Value,Col2Value,RowDimType from O where ReportNo in ("+sReportNos+")";
		q = m.createQuery(sSql);
		boList = q.getResultList();
		for (int i = 0;i<boList.size();i++){
			bo = (BizObject)boList.get(i);
			String col1Value =  bo.getAttribute("Col1Value").toString();
			if(col1Value==null)col1Value="0";
			String col2Value =  bo.getAttribute("Col2Value").toString();
			if(col2Value==null)col2Value="0";
			
			String sRowType = bo.getAttribute("RowDimType").toString();
			//百分比科目值
			if("2".equals(sRowType)){
				String sFinanceItemNo = bo.getAttribute("RowSubject").toString();
				String sItem1Value = col1Value;
				String sItem2Value = col2Value;
				//设置期初值
				if(sItem1Value==null){
					reportData1.put(sFinanceItemNo, null);
				}
				else{
					double dbvalue = new Double(col1Value);
					dbvalue = dbvalue*100;
					if(reportData1.get(sFinanceItemNo) == null || reportData1.get(sFinanceItemNo) == 0)
						reportData1.put(sFinanceItemNo, new Double(dbvalue));
				}
				//设置期末值
				if(sItem2Value==null){
					reportData2.put(sFinanceItemNo, null);
				}
				else{
					double dbvalue = new Double(col2Value);
					dbvalue = dbvalue*100;
					if(reportData2.get(sFinanceItemNo) == null || reportData2.get(sFinanceItemNo) == 0)
						reportData2.put(sFinanceItemNo, new Double(dbvalue));
				}
			}
			//非百分比科目值
			else{
				String sFinanceItemNo = bo.getAttribute("RowSubject").toString();
				String sItem1Value = col1Value;
				String sItem2Value = col2Value;
				if(reportData1.get(sFinanceItemNo) == null || reportData1.get(sFinanceItemNo) == 0)
					reportData1.put(sFinanceItemNo, new Double(sItem1Value));
				if(reportData2.get(sFinanceItemNo) == null || reportData2.get(sFinanceItemNo) == 0)
					reportData2.put(sFinanceItemNo, new Double(sItem2Value));
			}
		}
		//初始化去年年末年报科目值
		String reportDateLY = StringFunction.getRelativeMonth(reportDate+"/01", -12).substring(0,4)+"/12";
		sReportNos = "";
		m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_RECORD");
		sSql = "select ReportNo from O where " +
			"ObjectNo = :ObjectNo and " +
			"ReportDate = :ReportDate and " +
			"ReportScope = :ReportScope";
		q = m.createQuery(sSql);
		q.setParameter("ObjectNo",customerID);
		q.setParameter("ReportDate",reportDateLY);
		q.setParameter("ReportScope",reportScope);
		boList = q.getResultList();
		
		for (int i = 0;i<boList.size();i++){
			bo = (BizObject)boList.get(i);
			sReportNos += ",'"+bo.getAttribute("ReportNo")+"'";
			this.hasLastYearEndReport = true;
		}
		
		if(sReportNos.length()>1){
			sReportNos = sReportNos.substring(1);
			m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_DATA");
			
			sSql = "select RowSubject,Col1Value,Col2Value,RowDimType from O where ReportNo in ("+sReportNos+")";
			q = m.createQuery(sSql);
			boList = q.getResultList();
			for (int i = 0;i<boList.size();i++){
				bo = (BizObject)boList.get(i);
				String col2Value =  bo.getAttribute("Col2Value").toString();
				if(col2Value==null)col2Value="0";
				
				String sRowType = bo.getAttribute("RowDimType").getString();
				//百分比科目值
				if("2".equals(sRowType)){
					String sFinanceItemNo = bo.getAttribute("RowSubject").getString();
					String sItem2Value = col2Value;
					if(sItem2Value==null){
						reportData1.put(sFinanceItemNo, null);
					}
					else{
						double dbvalue = new Double(col2Value);
						dbvalue = dbvalue*100;
						if(reportData1.get(sFinanceItemNo) == null || reportData1.get(sFinanceItemNo) == 0)
							reportData1.put(sFinanceItemNo, new Double(dbvalue));
					}
				}
				else{
					String sFinanceItemNo = bo.getAttribute("RowSubject").getString();
					String sItem2Value = col2Value;
					if(reportData1.get(sFinanceItemNo) == null || reportData1.get(sFinanceItemNo) == 0)
						reportData1.put(sFinanceItemNo, new Double(sItem2Value));
				}
			}
		}
		
		//初始化上期报表科目值
		String reportDateLY2 = "";
		if (reportPeriod.equals("04")) // 年报
			reportDateLY2 = StringFunction.getRelativeAccountMonth(reportDate, "Year", -1);
		if (reportPeriod.equals("03")) // 半年报
			reportDateLY2 = StringFunction.getRelativeAccountMonth(reportDate, "Month", -6);
		else if (reportPeriod.equals("02")) // 季报
			reportDateLY2 = StringFunction.getRelativeAccountMonth(reportDate, "Month", -3);
		else if (reportPeriod.equals("01")) // 月报
			reportDateLY2 = StringFunction.getRelativeAccountMonth(reportDate, "Month", -1);
		
		sReportNos = "";
		m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_RECORD");
		sSql = "select ReportNo from O where " +
			"ObjectNo =:ObjectNo and " +
			"ReportDate = :ReportDate and " +
			"ReportScope = :ReportScope";
		q = m.createQuery(sSql);
		q.setParameter("ObjectNo",customerID);
		q.setParameter("ReportDate",reportDateLY2);
		q.setParameter("ReportScope",reportScope);
		q.setParameter("ReportPeriod",reportPeriod);
		boList = q.getResultList();
		
		for (int i = 0;i<boList.size();i++){
			bo = (BizObject)boList.get(i);
			sReportNos += ",'"+bo.getAttribute("ReportNo")+"'";
			this.hasLastTermReport = true;
		}
		
		if(sReportNos.length()>1){
			sReportNos = sReportNos.substring(1);
			m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_DATA");
			
			sSql = "select RowSubject,Col1Value,Col2Value,RowDimType from O where ReportNo in ("+sReportNos+")";
			q = m.createQuery(sSql);
			boList = q.getResultList();
			for (int i = 0;i<boList.size();i++){
				bo = (BizObject)boList.get(i);
				String col2Value =  bo.getAttribute("Col2Value").toString();
				if(col2Value==null)col2Value="0";
				
				String sRowType = bo.getAttribute("RowDimType").toString();
				//百分比科目值
				if("2".equals(sRowType)){
					String sFinanceItemNo = bo.getAttribute("RowSubject").toString();
					String sItem2Value = col2Value;
					if(sItem2Value==null){
						reportData3.put(sFinanceItemNo, null);
					}
					else{
						double dbvalue = new Double(col2Value);
						dbvalue = dbvalue*100;
						if(reportData3.get(sFinanceItemNo) == null || reportData3.get(sFinanceItemNo) == 0)
							reportData3.put(sFinanceItemNo, new Double(dbvalue));
					}
				}
				else{
					String sFinanceItemNo = bo.getAttribute("RowSubject").toString();
					String sItem2Value = col2Value;
					if(reportData3.get(sFinanceItemNo) == null || reportData3.get(sFinanceItemNo) == 0)
						reportData3.put(sFinanceItemNo, new Double(sItem2Value));
				}
			}
		}
	}
	
	public void initCol3Value()throws Exception{
		
		String sReportNos = "";
		String reportDate2 = (Integer.parseInt(reportDate.substring(0,4))-1)+"/12";
		String reportDate3 = (Integer.parseInt(reportDate.substring(0,4))-2)+"/12";
		
		//取上年年报指标值
		m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_RECORD");
		String sSql = "select ReportNo from O where " +
			"ObjectNo = :ObjectNo and " +
			"ReportDate = :ReportDate and " +
			"ReportScope = :ReportScope";
		q = m.createQuery(sSql);
		q.setParameter("ObjectNo",customerID);
		q.setParameter("ReportDate",reportDate2);
		q.setParameter("ReportScope",reportScope);
		boList = q.getResultList();

		for (int i = 0;i<boList.size();i++){
			bo = (BizObject)boList.get(i);
			sReportNos += ",'"+bo.getAttribute("ReportNo")+"'";
		}
		if(sReportNos.length()>1){
			sReportNos = sReportNos.substring(1);
			String sSql2 = "select RowSubject, Col2Value ,Col1Value from O where ReportNo in ("+sReportNos+") and rowSubject in ('333','301','329')";
			BizObjectManager bm2 = JBOFactory.getFactory().getManager("jbo.sys.REPORT_DATA");
			BizObjectQuery bq2 = bm2.createQuery(sSql2);
			List<BizObject> bo2List = bq2.getResultList();
			for(int i = 0; i < bo2List.size();i++){
				String rowSubject = bo2List.get(i).getAttribute("rowSubject").getString();
				if(rowSubject==null)rowSubject = "";
				String col1Value = bo2List.get(i).getAttribute("Col1Value").getString();
				if(col1Value==null)col1Value="0";
				String col2Value =  bo2List.get(i).getAttribute("Col2Value").getString();
				if(col2Value == null)col2Value="0";

				if("333".equals(rowSubject)){
					reportData3.put("3332",new Double(col2Value));
					reportData3.put("33321", new Double(col1Value));
				}
				if("301".equals(rowSubject)){
					reportData3.put("3012",new Double(col2Value));
					reportData3.put("30121",new Double(col1Value));
				}
				if("329".equals(rowSubject)){
					 
				}
			}
		}else{
			ARE.getLog("未找到上年年报！");
		}
		
		
		//取三年前年报指标
		BizObjectManager bm3 = JBOFactory.getFactory().getManager("jbo.sys.REPORT_RECORD");
		String  sSql3 = "select ReportNo from O where " +
			"ObjectNo = :ObjectNo and " +
			"ReportDate = :ReportDate and " +
			"ReportScope = :ReportScope";
		BizObjectQuery bq3  = bm3.createQuery(sSql);
		bq3.setParameter("ObjectNo",customerID);
		bq3.setParameter("ReportDate",reportDate3);
		bq3.setParameter("ReportScope",reportScope);
		List<Object> bo3List = bq3.getResultList();
		String sReportNos2="";
		for (int i = 0;i<bo3List.size();i++){
			BizObject bo3 = (BizObject)bo3List.get(i);
			sReportNos2 += ",'"+bo3.getAttribute("ReportNo")+"'";
		}
		if(sReportNos2.length()>1){
			sReportNos2 = sReportNos2.substring(1);
			String sSql4 = "select RowSubject, Col2Value ,Col1Value from O where ReportNo in ("+sReportNos+") and rowSubject in ('333','301')";
			BizObjectManager bm2 = JBOFactory.getFactory().getManager("jbo.sys.REPORT_DATA");
			BizObjectQuery bq2 = bm2.createQuery(sSql4);
			List<BizObject> bo2List = bq2.getResultList();
			for(int i = 0; i < bo2List.size();i++){
				String rowSubject = bo2List.get(i).getAttribute("rowSubject").getString();
				if(rowSubject==null)rowSubject="";
				String col1Value =  bo2List.get(i).getAttribute("Col1Value").getString();
				if(col1Value==null)col1Value="0";
				String col2Value = bo2List.get(i).getAttribute("Col2Value").getString();
				if(col2Value == null)col2Value="0";
				if("333".equals(rowSubject))
					reportData3.put("3333",new Double(col2Value));
				
				if("301".equals(rowSubject))
					reportData3.put("3013",new Double(col2Value));
			}
		}else{
			ARE.getLog("未找到三年前年报！");
		}
		// 取特殊指标项
		//this.getExposureSum();
		//取上一阶段评级结果
		this.getBeforeScore();
		//获得企业相关信息
		this.getEntInfoValue();
		//事业单位毛利率
		this.getTotalRate();
	}
	
	public double getCol1Value(String subjectNo){
		if(reportData1 == null)
			return 0;
		else
			return  reportData1.get(subjectNo)==null?0:reportData1.get(subjectNo);
	}
	public double getCol2Value(String subjectNo){
		if(reportData2 == null)
			return 0;
		else{
			return reportData2.get(subjectNo)==null?0:reportData2.get(subjectNo);
		}
	}
	public double getCol3Value(String subjectNo){
		if(reportData3 == null)
			return 0;
		else{
			return reportData3.get(subjectNo)==null?0:reportData3.get(subjectNo);
		}
	}
	
	public double getItemValue(String subjectNo){
		double itemValue = 0.00;
		String[]  strs = subjectNo.split("@");
		if("0".equals(strs[0]))
			itemValue = this.getCol2Value(strs[1]);
		if("1".equals(strs[0]))
			itemValue = this.getCol1Value(strs[1]);
		if("2".equals(strs[0]))
			itemValue = this.getCol3Value(strs[1]);
		
		return itemValue;
	}
	/**
	 * 获得指定客户在我行的授信敞口金额和敞口余额。
	 * @return
	 * @throws JBOException
	 */
	private Double getExposureSum() throws JBOException{
		Double exposureSum=0.00;
		Double usableExposureSum =0.00;
		Double usedExposureSum = 0.00;
		String currency = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CL_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID =:CustomerID and status in('Efficient','Thawy') and endDate > :endDate");	
		bq.setParameter("CustomerID",customerID);
		bq.setParameter("endDate",StringFunction.getToday());
		BizObject bo = bq.getSingleResult();
		if(bo!= null){
			exposureSum = bo.getAttribute("EXPOSURESUM").getDouble();
			usableExposureSum = bo.getAttribute("USABLEEXPOSURESUM").getDouble();
			usedExposureSum = bo.getAttribute("USEDEXPOSURESUM").getDouble();
			currency = bo.getAttribute("CURRENCY").getString();
			double currencyD = GetCompareERate.getConvertToRMBERate(currency);
			exposureSum = currencyD*exposureSum;
			usableExposureSum = currencyD*usableExposureSum;
			usedExposureSum = currencyD*usedExposureSum;
			reportData3.put("ExposureSum",exposureSum);
			reportData3.put("ExposureBalance",usableExposureSum);
			reportData3.put("UsedExposureSum",usedExposureSum);
		}
		return exposureSum;
	}
	
	//获得上一阶段评级结果
	public void getBeforeScore()throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq = bm.createQuery("customerID=:customerID and status <>'1'");
		BizObject bo = bq.setParameter("customerID",customerID).getSingleResult();
		if(bo != null){
			reportData3.put("score",bo.getAttribute("att01").getDouble());
		}else 
			reportData3.put("score", 0.00);
	}
	
	//获得企业信息
	public void getEntInfoValue()throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID");
		bq.setParameter("CustomerID",customerID);
		BizObject bo = bq.getSingleResult();
		String segisterCapital= bo.getAttribute("REGISTERCAPITAL").getString();
		if(segisterCapital==null||"".equals(segisterCapital))
			segisterCapital="0.00";
		String setupDate = bo.getAttribute("setupDate").getString();
		if(setupDate == null || "".equals(setupDate))
			setupDate = "0.00";
		else 
			setupDate = setupDate.substring(0,4);
		setupDate = setupDate.substring(0,4);
		String creditDate = bo.getAttribute("CreditDate").getString();
		if(creditDate == null || "".equals(creditDate))
			creditDate = "0.00";
		else
			creditDate = creditDate.substring(0,4);
		reportData3.put("RegisterCapital",new Double(segisterCapital));
		reportData3.put("SetupDate", new Double(setupDate));
		reportData3.put("CreditDate", new Double(creditDate));
	}
	
	
	/**
	 * 对事业单位进行毛利率的计算
	 */
	private void getTotalRate()throws Exception{
		BizObject reportData  = null;
		String sReportNos ="";
		String financeBelong = "";
		double totalRate = 0.00;
		double  runIncome = 0.00;//经营收入
		double careuseIncome = 0.00;//事业收入
		double runCost = 0.00;//经营支出
		double careuseCost = 0.00;//事业支出
		double eduRunCost = 0.00;//经营事业支出
		double eduCareuseIncome = 0.00;//教育事业收入
		double sciCareuseIncome =0.00;//科研事业收入
		double sciRunCost = 0.00;//科研事业支出
		double otherRunCost = 0.00;//其他事业支出
		double hosInCome = 0.00;//医疗收入
		double medInCome = 0.00;//药品收入
		double hosCost = 0.00;//医疗支出
		double medCost = 0.00;//药品支出
	/*	BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
		BizObjectQuery bq = bm.createQuery("select FINANCEBELONG from O where " +
				"CustomerID = :CustomerID and " +
				"ReportDate = :ReportDate and " +
				"ReportScope = :ReportScope and " +
				"ReportPeriod = :ReportPeriod and " +
				"AuditFlag = :AuditFlag");
		bq.setParameter("CustomerID",this.customerID);
		bq.setParameter("ReportDate",this.reportDate);
		bq.setParameter("ReportScope",this.reportScope);
		bq.setParameter("ReportPeriod",this.reportPeriod);
		bq.setParameter("AuditFlag",this.auditFlag);
		BizObject bo = bq.getSingleResult();		
		if(bo != null){
			financeBelong = bo.getAttribute("FINANCEBELONG").getString();//财报类型
*/			
			BizObjectManager bm1 = JBOFactory.getFactory().getManager("jbo.sys.REPORT_RECORD");
			String sSql = "select ReportNo from O where " +
				"ObjectNo = :ObjectNo and " +
				"ReportDate = :ReportDate and " +
				"ReportScope = :ReportScope";
			BizObjectQuery bq1 = bm1.createQuery(sSql);
			bq1.setParameter("ObjectNo",customerID);
			bq1.setParameter("ReportDate",reportDate);
			bq1.setParameter("ReportScope",reportScope);
			List boList1 = bq1.getResultList();
			for (int i = 0;i<boList1.size();i++){
				BizObject bo1 = (BizObject)boList1.get(i);
				sReportNos += ",'"+bo1.getAttribute("ReportNo")+"'";
			}
			if(sReportNos.length()>1){
				sReportNos = sReportNos.substring(1);
			}else{
				throw new Exception("找不到对应报表！["+customerID+"]["+reportDate+"]["+reportScope+"]");
			}
			BizObjectManager bm2 = JBOFactory.getFactory().getManager("jbo.sys.REPORT_DATA");
			sSql = "select RowSubject,Col1Value,Col2Value,RowDimType from O where ReportNo in ("+sReportNos+")";
			BizObjectQuery bq2 = bm2.createQuery(sSql);
			List<BizObject> boList2 = bq2.getResultList();
			//根据报表类型初始化数据
			//if("030".equals(financeBelong)){//其他事业单位类型报表
				for(int i = 0;i < boList2.size();i++){
					reportData  = boList2.get(i);
					if("355".equals(reportData.getAttribute("RowSubject").getString()))
						runIncome = reportData.getAttribute("Col2Value").getDouble();
					if("351".equals(reportData.getAttribute("RowSubject").getString()))
						careuseIncome = reportData.getAttribute("Col2Value").getDouble();	
					if("373".equals(reportData.getAttribute("RowSubject").getString()))
						runCost = reportData.getAttribute("Col2Value").getDouble();
					if("371".equals(reportData.getAttribute("RowSubject").getString()))
						careuseCost = reportData.getAttribute("Col2Value").getDouble();
				}
				//计算毛利率
				if((runIncome+careuseIncome)!=0){
					totalRate = (runIncome+careuseIncome-runCost-careuseCost)/(runIncome+careuseIncome);
					totalRate = totalRate*100;
					reportData3.put("DG003", totalRate);
				}	
			/*}
			if("040".equals(financeBelong)){//教育行业类型报表
				//根据报表类型初始化数据
				for(int i = 0;i < boList2.size();i++){
					reportData  = boList2.get(i);
					if("355".equals(reportData.getAttribute("RowSubject").getString()))
						runIncome = reportData.getAttribute("Col2Value").getDouble();
					if("336".equals(reportData.getAttribute("RowSubject").getString()))
						eduCareuseIncome = reportData.getAttribute("Col2Value").getDouble();	
					if("338".equals(reportData.getAttribute("RowSubject").getString()))
						sciCareuseIncome = reportData.getAttribute("Col2Value").getDouble();
					if("373".equals(reportData.getAttribute("RowSubject").getString()))
						runCost = reportData.getAttribute("Col2Value").getDouble();
					if("342".equals(reportData.getAttribute("RowSubject").getString()))
						eduRunCost = reportData.getAttribute("Col2Value").getDouble();
					if("344".equals(reportData.getAttribute("RowSubject").getString()))
						sciRunCost = reportData.getAttribute("Col2Value").getDouble();
					if("346".equals(reportData.getAttribute("RowSubject").getString()))
						otherRunCost = reportData.getAttribute("Col2Value").getDouble();
				}
					 //计算毛利率
				if((runIncome+eduCareuseIncome+sciCareuseIncome)!=0){
					totalRate = (runIncome+eduCareuseIncome+sciCareuseIncome-sciRunCost-runCost-eduRunCost-otherRunCost)/(runIncome+eduCareuseIncome+sciCareuseIncome);
					totalRate = totalRate*100;
					reportData3.put("DG003", totalRate);
				}
			}
			if("050".equals(financeBelong)){//医疗机构类型报表
				//医疗收入+药品收入-医疗支出-药品支出/医疗收入+药品收入
				for(int i = 0;i < boList2.size();i++){
					reportData  = boList2.get(i);
					if("372".equals(reportData.getAttribute("RowSubject").getString()))
						hosInCome = reportData.getAttribute("Col2Value").getDouble();
					if("374".equals(reportData.getAttribute("RowSubject").getString()))
						medInCome = reportData.getAttribute("Col2Value").getDouble();	
					if("376".equals(reportData.getAttribute("RowSubject").getString()))
						hosCost = reportData.getAttribute("Col2Value").getDouble();
					if("378".equals(reportData.getAttribute("RowSubject").getString()))
						medCost = reportData.getAttribute("Col2Value").getDouble();
				}
				//计算毛利率
				if((hosInCome+medInCome) !=0 ){
					totalRate = (hosInCome+medInCome+hosCost-medCost)/(runIncome+eduCareuseIncome+sciCareuseIncome);
					totalRate = totalRate*100;
					reportData3.put("DG003", totalRate);
				}	
			}
		}else{
			ARE.getLog("找不到对应报表！["+customerID+"]["+reportDate+"]["+reportScope+"]["+reportPeriod+"]["+auditFlag+"]");
			throw new Exception("找不到对应报表");
		}*/
	}
	
	private double getTotalCapitalPay(){
		double d1 = this.getCol2Value("311");
		double d2 = this.getCol2Value("331");
		double d3 = this.getCol2Value("333");
		double d4 = this.getCol2Value("165");
		double d5 = this.getCol1Value("165");
		
		if(d4+d5 == 0)
			return 0;
		else
			return (d1+d2+d3)/(d4+d5)*100;
	}
	
	private double getInterestMultiple(){
		double d1 = this.getCol2Value("321");
		double d2 = this.getCol2Value("311");
		
		if(d2 == 0)
			return 0;
		else
			return (d1+d2)/d2*100;
	}
	
	private double getAssetIncrementRate(){
		double d1 = this.getCol1Value("266");
		double d2 = this.getCol2Value("333");
		
		if(d1 == 0)
			return 0;
		else
			return (d1+d2)/d1*100;
	}
	
	private double getSaleIncrementRate(){
		double d1 = this.getCol1Value("301");
		double d2 = this.getCol2Value("301");
		
		if(d1 == 0)
			return 0;
		else
			return (d2-d1)/d1*100;
	}
	
	
	private double getSaleIncrementRate3Y() throws Exception{
		double d1 =  this.getCol2Value("301");
		double d2 = 0;
		String relativeYear = StringFunction.getRelativeMonth(this.reportDate+"/01", -36).substring(0,4)+"/12";
		
		m = JBOFactory.getFactory().getManager("jbo.sys.REPORT_DATA");
		String sSql = "select Col1Value,Col2Value " +
			"from O where ReportNo in (" +
			"select ReportNo from REPORT_RECORD where " +
			"ObjectNo = :ObjectNo and " +
			"ReportDate = :ReportDate and " +
			"ReportPeriod = '04') and " +
			"RowSubject = '301'";
		q = m.createQuery(sSql);
		q.setParameter("ObjectNo",customerID);
		q.setParameter("ReportDate",relativeYear);
		bo = q.getSingleResult();
		
		if(bo!=null){
			d2 = bo.getAttribute("Col2Value").getDouble();
		}
		
		if(d2 == 0)
			return 0;
		else
			return (Math.pow((d1/d2), 1/3)-1)*100;
	}
	
	public double getFastnessAssetIncrement(){
		double d1 = this.getCol1Value("146");
		double d2 = this.getCol2Value("146");
		
		if(d1 == 0)
			return 0;
		else
			return (d2-d1)/d1*100;
	}
	
	public double getDebtCapitalRate(){
		double d1 = this.getCol2Value("246");
		double d2 = this.getCol2Value("266");
		
		if(d2 == 0)
			return 999;
		else
			return d1/d2*100;
	}
	
	public double getAccountTurnOverDays(){
		double d1 = this.getCol2Value("650");
		if(d1 == 0)
			return 9999;
		else
			return 360/d1;
	}
	
	public double getStockTurnOverDays(){
		double d1 = this.getCol2Value("652");
		if(d1 == 0)
			return 9999;
		else
			return 360/d1;
	}
	
	public double getColValue(String subjectNo) throws Exception{
		if(FinancialConstants.NET_CAPITAL_YIELD.equals(subjectNo)){
			return this.getCol2Value("648");
		}
		else if(FinancialConstants.MAIN_BIZ_PROFIT_MARGIN.equals(subjectNo)){
			return this.getCol2Value("642");
		}
		else if(FinancialConstants.TOTAL_CAPITAL_PAY.equals(subjectNo)){
			return getTotalCapitalPay();
		}
		else if(FinancialConstants.TOTAL_TURN_OVER.equals(subjectNo)){
			return this.getCol2Value("662");
		}
		else if(FinancialConstants.STOCK_TURN_OVER.equals(subjectNo)){
			return this.getCol2Value("652");
		}
		else if(FinancialConstants.ACCOUNT_TURN_OVER.equals(subjectNo)){
			return this.getCol2Value("650");
		}
		else if(FinancialConstants.INTEREST_MULTIPLE.equals(subjectNo)){
			return getInterestMultiple();
		}
		else if(FinancialConstants.ASSET_DEBT_RATE.equals(subjectNo)){
			return this.getCol2Value("612");
		}
		else if(FinancialConstants.QUICK_ASSET_RATE.equals(subjectNo)){
			return this.getCol2Value("602");
		}
		else if(FinancialConstants.ASSET_INCREMENT_RATE.equals(subjectNo)){
			return getAssetIncrementRate();
		}
		else if(FinancialConstants.SALE_INCREMENT_RATE.equals(subjectNo)){
			return getSaleIncrementRate();
		}
		else if(FinancialConstants.SALE_INCREMENT_RATE_3Y.equals(subjectNo)){
			return getSaleIncrementRate3Y();
		}
		else if(FinancialConstants.FASTNESS_ASSET_NET.equals(subjectNo)){
			return getCol2Value("146");
		}
		else if(FinancialConstants.FASTNESS_ASSET_INCREMENT.equals(subjectNo)){
			return getFastnessAssetIncrement();
		}
		else if(FinancialConstants.DEBT_CAPITAL_RATE.equals(subjectNo)){
			return getDebtCapitalRate();
		}
		else if(FinancialConstants.ACCOUNT_TURN_OVER_DAYS.equals(subjectNo)){
			return getAccountTurnOverDays();
		}
		else if(FinancialConstants.STOCK_TURN_OVER_DAYS.equals(subjectNo)){
			return getStockTurnOverDays();
		}
		else if(FinancialConstants.ACCOUNTPAY_TURN_OVER_DAYS.equals(subjectNo)){
			//应付账款周转天数
			return getCol2Value("654")==0?0:(360/getCol2Value("654"));
		}
		else if(FinancialConstants.ACCOUNTPREPAY_TURN_OVER_DAYS.equals(subjectNo)){
			//预付账款周转天数
			return getCol2Value("301")*getCol2Value("109")==0?0:(360/getCol2Value("301")*getCol2Value("109"));
		}
		else if(FinancialConstants.ACCOUNTPREGET_TURN_OVER_DAYS.equals(subjectNo)){
			//预收账款周转天数
			return getCol2Value("303")*getCol2Value("208")==0?0:(360/getCol2Value("303")*getCol2Value("208"));
		}
		else{
			throw new Exception("参数错误");
		}
	}
	


	public HashMap<String, Double> getReportData1() {
		return reportData1;
	}

	public HashMap<String, Double> getReportData2() {
		return reportData2;
	}

	public HashMap<String, Double> getReportData3() {
		return reportData3;
	}

	public String getCustomerID() {
		return customerID;
	}

	public String getReportDate() {
		return reportDate;
	}

	public String getReportScope() {
		return reportScope;
	}

	public String getReportPeriod() {
		return reportPeriod;
	}

	public String getAuditFlag() {
		return auditFlag;
	}

	public boolean isHasCurReport() {
		return hasCurReport;
	}

	public boolean isHasLastYearEndReport() {
		return hasLastYearEndReport;
	}

	public boolean isHasLastTermReport() {
		return hasLastTermReport;
	}
	
	/**
	 * 返回当期报表的上n年的年报报表，month须是12整数倍，暂不做校验
	 */
	public FinancialIndexCalculator getLYReport(int month){
		try{
			BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
			BizObjectQuery boq = bom.createQuery("CustomerID=:CustomerID and ReportDate=:ReportDate and ReportScope=:ReportScope and ReportPeriod=:ReportPeriod and ReportStatus in ('02','1') order by AuditFlag Asc");
			boq.setParameter("CustomerID", customerID);
			boq.setParameter("ReportDate", StringFunction.getRelativeMonth(reportDate+"/01", month).substring(0,4)+"/12");
			boq.setParameter("ReportScope", reportScope);
			boq.setParameter("ReportPeriod", "04");
			BizObject bo = boq.getSingleResult();
			
			if(bo!=null){
				String sReportDate = bo.getAttribute("ReportDate").getString();
				String sReportPeriod = bo.getAttribute("ReportPeriod").getString();
				String sAuditFlag = bo.getAttribute("AuditFlag").getString();
				return new FinancialIndexCalculator(customerID,sReportDate,reportScope,sReportPeriod,sAuditFlag);
			}
			else{
				return null;
			}
		}
		catch(JBOException jbx){
			return null;
		}
		catch(Exception ex){
			return null;
		}
	}
}
