<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@page import="com.amarsoft.app.accounting.util.FeeFunctions"%>

<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*	 各种费用数值 	
	 */
	String Maturity =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Maturity")));//到期日
	String Premium =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Premium")));//还款保险费
	String FinalPaymentSum =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FinalPaymentSum")));//尾款金额
	String Premiums =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Premiums")));//延保费
	String RevenueTax =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RevenueTax")));//车辆购置税
	String InsureSum =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InsureSum")));//保险费
	String AssureService =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssureService")));//担保服务费
	String ProcedureFee =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProcedureFee")));//手续费
	String BusinessSum =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSum")));//贷款本金
	String BusinessRate =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessRate")));//贷款年利率
	 
	%>
<%/*~END~*/%>

<html>
<head>
<title>Session保存信息</title>
<%
	String productVersion="V1.0";
	String businessObjectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessObjectType")));
	if(businessObjectType==null ) businessObjectType = "";
	int rowCount = DataConvert.toInt(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RowCount")));
	String colNames = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColNames")));
	String CreditType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CreditType")));
	String productID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID")));
	String CustomerID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	//if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");
	
	String parentObjectType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentObjectType")));
	String parentObjectNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentObjectNo")));


	BusinessObject parentObject=null;
	if(parentObjectType!=null&&parentObjectType.length()>0){
		parentObject = simulationObject.getRelativeObject(parentObjectType, parentObjectNo);
		if(parentObject==null){
			throw new Exception("未找到对象{"+parentObjectType+"-"+parentObjectNo+"}!");
		}
	}
	else{
		parentObject=simulationObject;
	}
	/* ````````````````````````````````````````````````````````````````````````````````````````````````` */
	
if(productID!=null&&productID.length()>0){
	//获得页面参数
	ProductManage productManage = new ProductManage(Sqlca);
	if(!productID.equals(simulationObject.getString("ProductID"))&&productID!=null&&productID.length()>0){
		simulationObject.setAttributeValue("BusinessType",productID);
		simulationObject.setAttributeValue("CustomerID",CustomerID);
		simulationObject.setAttributeValue("ProductID",productID);
		simulationObject.setAttributeValue("BusinessCurrency","01");
		simulationObject.setAttributeValue("ProductVersion",productVersion);
		simulationObject.setAttributeValue("ProductName",ProductConfig.getProductName(productID));
		simulationObject.setAttributeValue("BusinessTypeName",ProductConfig.getProductName(productID));
		simulationObject.setAttributeValue("Maturity",Maturity);//合同到期日
		productManage.createTermObject(simulationObject);
	}
	if(productID==null||productID.length()==0){
		productID=simulationObject.getString("BusinessType");
		//productVersion = simulationObject.getString("ProductVersion");
	}
	if(productID!=null&&productID.length()>0){
		productManage.initBusinessObject(simulationObject);
	}
	String rightType="";
	if(simulationObject!=null&&BUSINESSOBJECT_CONSTATNTS.loan.equals(simulationObject.getObjectType()))
		rightType="ReadOnly";
	
	String objectType = "jbo.app.BUSINESS_CONTRACT";
	String objectNo = simulationObject.getObjectNo();
	if(productID != null && productID.length()>0){
		//AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		List<BusinessObject> RPTBusinessObject=productManage.createTermObject("RPT17", simulationObject);//还款方式
		//增加尾款金额
		ArrayList<BusinessObject> rptSegmentList = parentObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			if(rptSegmentList!=null){
				for(BusinessObject a:rptSegmentList){
					a.setAttributeValue("segrptamount", FinalPaymentSum);
				}
			}
		//利率信息
		List<BusinessObject> RATBusinessObject=productManage.createTermObject("RAT002", simulationObject);
		ArrayList<BusinessObject> rateSegmentList = parentObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
			if(rptSegmentList!=null){
				for(BusinessObject a:rateSegmentList){
					a.setAttributeValue("BusinessRate", BusinessRate);
				}
			}
		
		List<BusinessObject> DBFWFee=productManage.createTermObject("N300", simulationObject);//担保服务费
		for(BusinessObject BusinessObject1:DBFWFee){
			BusinessObject1.setAttributeValue("AMOUNT", AssureService);
		}
		List<BusinessObject> HKBXFee=productManage.createTermObject("N500", simulationObject);//还款保险费
		for(BusinessObject BusinessObject1:DBFWFee){
			BusinessObject1.setAttributeValue("AMOUNT", Premium);
		}
		List<BusinessObject> YBFee=productManage.createTermObject("YB100", simulationObject);//延保费
		for(BusinessObject BusinessObject_YB100:YBFee){
			BusinessObject_YB100.setAttributeValue("AMOUNT", Premiums);
		} 
		List<BusinessObject> GZFee=productManage.createTermObject("GZ100", simulationObject);//购置税
		for(BusinessObject BusinessObject_GZ100:GZFee){
			BusinessObject_GZ100.setAttributeValue("AMOUNT", RevenueTax);
		} 
		List<BusinessObject> SXFee=productManage.createTermObject("N400", simulationObject);//手续费
		for(BusinessObject BusinessObject_SXFee:SXFee){
			BusinessObject_SXFee.setAttributeValue("AMOUNT", ProcedureFee);
		} 
		
		AbstractBusinessObjectManager bom=new DefaultBusinessObjectManager(Sqlca);
		
		BusinessObject depositAccount =new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_accounts,bom);
		depositAccount.setAttributeValue("objectno", simulationObject.getObjectNo());
		depositAccount.setAttributeValue("ObjectType", simulationObject.getObjectType());
		depositAccount.setAttributeValue("accounttype", "01");
		depositAccount.setAttributeValue("accountno", "987654321");
		depositAccount.setAttributeValue("accountcurrency", "01");
		depositAccount.setAttributeValue("accountname", "dkzx");
		depositAccount.setAttributeValue("accountflag", "1");
		depositAccount.setAttributeValue("PRI", "1");
		depositAccount.setAttributeValue("AccountIndicator", "00");
		depositAccount.setAttributeValue("status", "0");
		bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, depositAccount);//插入
		
	
	}
	
}		

	
	/* ````````````````````````````````````````````````````````````````````````````````````````````````` */
	
	
	
	
	
	
	
	
	
	
	//取字段更新到业务对象中
	String[] colList=colNames.split(",");
	for(int i=1;i<=rowCount;i++){
		BusinessObject businessObject=null;
		if(businessObjectType.equals(simulationObject.getObjectType())){//咨询对象
			businessObject=simulationObject;
		}else{//附属对象
			String serialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"+i)));
			if(serialNo!=null&&serialNo.length()>0){
				businessObject=parentObject.getRelativeObject(businessObjectType, serialNo);
			}
			if(businessObject==null){
				businessObject=new BusinessObject(businessObjectType,new DefaultBusinessObjectManager(Sqlca));
				parentObject.setRelativeObject(businessObject);
			}
		}
		for(int j=0;j<colList.length;j++){
			String paraName=colList[j]+i;
			String value = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter(paraName)));
			if("".equals(value)||value==null||value.equals("null")||value.equals("Null")) continue;
			
			businessObject.setAttributeValue(colList[j], value);
		}
	}
%>
<script language=javascript>
	//返回检查状态值和客户号
	self.returnValue = "true";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>