package com.amarsoft.app.awe.framecase.formatdoc.template01;

import java.io.Serializable;
import java.text.NumberFormat;

import com.amarsoft.are.ARE;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.biz.formatdoc.model.TestExtClass;

public class D001_00 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String operateOrgName = "";
	private String customerName = "";
	private String businessTypeName = "";
	private String contractSerialNo = "";
	private String objectNo = "";
	private String customerID = "";
	private String loanType = "";
	private String businessCurrency = "";
	private String gatheringName = "";
	private String businessSum = "";
	private String putOutDate = "";
	private String maturity = "";
	private String businessRate = "";
	private String disburseDate = "";
	private String opinion1MultiSelect = "";
	private String opinion1 = "";
	private String opinion2SingleSelect = "";
	private String opinion2 = "";
	//private String opinion3 = "abc";
	
	private String lineChart = "";
	private String pieChart = "";
	private String barChart = "";
	
	private TestExtClass[] extobj1;
	
	private TestExtClass extobj0;
	
	// TODO 如何实现循环赋值
	//private Object obj; 

	

	public String getLineChart() {
		return lineChart;
	}

	public void setLineChart(String lineChart) {
		this.lineChart = lineChart;
	}

	public String getPieChart() {
		return pieChart;
	}

	public void setPieChart(String pieChart) {
		this.pieChart = pieChart;
	}

	public String getBarChart() {
		return barChart;
	}

	public void setBarChart(String barChart) {
		this.barChart = barChart;
	}

	public TestExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(TestExtClass extobj0) {
		this.extobj0 = extobj0;
	}

	public TestExtClass[] getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(TestExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}

	public String getOperateOrgName() {
		return operateOrgName;
	}

	public void setOperateOrgName(String operateOrgName) {
		this.operateOrgName = operateOrgName;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getBusinessTypeName() {
		return businessTypeName;
	}

	public void setBusinessTypeName(String businessTypeName) {
		this.businessTypeName = businessTypeName;
	}

	public String getContractSerialNo() {
		return contractSerialNo;
	}

	public void setContractSerialNo(String contractSerialNo) {
		this.contractSerialNo = contractSerialNo;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getLoanType() {
		return loanType;
	}

	public void setLoanType(String loanType) {
		this.loanType = loanType;
	}

	public String getBusinessCurrency() {
		return businessCurrency;
	}

	public void setBusinessCurrency(String businessCurrency) {
		this.businessCurrency = businessCurrency;
	}

	public String getGatheringName() {
		return gatheringName;
	}

	public void setGatheringName(String gatheringName) {
		this.gatheringName = gatheringName;
	}

	public String getBusinessSum() {
		return businessSum;
	}

	public void setBusinessSum(String businessSum) {
		this.businessSum = businessSum;
	}

	public String getPutOutDate() {
		return putOutDate;
	}

	public void setPutOutDate(String putOutDate) {
		this.putOutDate = putOutDate;
	}

	public String getMaturity() {
		return maturity;
	}

	public void setMaturity(String maturity) {
		this.maturity = maturity;
	}

	public String getBusinessRate() {
		return businessRate;
	}

	public void setBusinessRate(String businessRate) {
		this.businessRate = businessRate;
	}

	public String getDisburseDate() {
		return disburseDate;
	}

	public void setDisburseDate(String disburseDate) {
		this.disburseDate = disburseDate;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}

	public String getOpinion1MultiSelect() {
		return opinion1MultiSelect;
	}

	public void setOpinion1MultiSelect(String opinion1MultiSelect) {
		this.opinion1MultiSelect = opinion1MultiSelect;
	}

	public String getOpinion2SingleSelect() {
		return opinion2SingleSelect;
	}

	public void setOpinion2SingleSelect(String opinion2SingleSelect) {
		this.opinion2SingleSelect = opinion2SingleSelect;
	}
	
	public D001_00() {

	}
	
	/**
	 * 设置是否图表控件
	 */
	protected void setChartTag(){
		this.chartList.add(this.barChart);
		this.chartList.add(this.lineChart);
		this.chartList.add(this.pieChart);
	}

	/**
	 * 设置复合控件：如：radio,checkbox
	 */
	public void setMultiInputs(){
		ARE.getLog().trace(this.getClass().getName()+".setUpdateFields()");
		this.setMultiInputs("opinion1MultiSelect,opinion2SingleSelect,extobj0.attr1", true);
		super.setMultiInputs();
	}

	

	public boolean initObjectForRead() {
		ARE.getLog().trace(this.getClass().getName()+".initObjectForRead()");

		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(6);

        //only属性
        operateOrgName = "测试支行";
		customerName = "天津诗香电子";
		businessTypeName = "短期流动资金贷款";
		contractSerialNo = "2009120200000011";
		objectNo = "2009120200000010";
		customerID = "2009120100000001";
		loanType = "信用贷款";
		businessCurrency = "人民币";
		gatheringName = "";
        businessSum = nf.format(10000.0);
		putOutDate = "2009/12/01";
		maturity = "2009/12/31";
		businessRate = "5.000000";
		disburseDate = "2011年03月01日";		
		
		//对象.属性
		if(extobj0==null)
			extobj0 = new TestExtClass();
		extobj0.setAttr5("5000");
		extobj0.setAttr6("8000");
		
		//初始化图表
		lineChart = D001_00_LineChart.class.getName();
		pieChart = D001_00_PieChart.class.getName();
		barChart = D001_00_BarChart.class.getName();
		
		return true;
	}

	public boolean initObjectForEdit() {
		ARE.getLog().trace(this.getClass().getName()+".initObjectForEdit()");

		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(6);

		opinion1 = "<请输入意见1>";
		opinion2 = "<请输入意见2>";
		opinion1MultiSelect = "";
		opinion2SingleSelect = "2";		
		
		//对象.属性
		if(extobj0==null)
			extobj0 = new TestExtClass();
		extobj0.setAttr1("1");
		//extobj0.setAttr2("2");
		extobj0.setAttr3("扩展属性3");
		extobj0.setAttr4("扩展属性4");

		return true;
	}

/*	public boolean fillObject(HttpServletRequest request) throws Exception {
		ARE.getLog().trace(this.getClass().getName()+".fillObject()");
		
		for(java.util.Enumeration enum1 = request.getParameterNames(); enum1.hasMoreElements();){
			String sParaName = (String)enum1.nextElement();
			System.out.println(sParaName+":"+(String)request.getParameter(sParaName));
		}
		
		return super.fillObject(request);
	}*/	

	/*
	public boolean saveObject() {
		ARE.getLog().trace(this.getClass().getName()+".saveObject()");

		//TODO
		//可以保存到自定义的表中：insert into temp1() values (attr1,attr2)
		
		//缺省保存到FormatDoc_Data中
		return super.saveObject();
	}
	*/

}
