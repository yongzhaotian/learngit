<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@page import="com.amarsoft.app.accounting.trans.TransactionFunctions"%>
<%@page import="com.amarsoft.app.accounting.product.ProductManage"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author: lwang 20140221
        Tester:
        Describe: 还款计划信息列表
        Input Param:
        Output Param:       
        HistoryLog:
     */
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "还款计划信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

    //定义变量

    //获得页面参数
	BusinessObject simulationObject = null;//(BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");
	simulationObject=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
	
    
    //获得组件参数
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";
    
    String scount = Sqlca.getString(new SqlObject("select count(*) from Acct_Payment_Schedule where objectno in "+
    	       "(select serialno from acct_loan where putoutno = '"+sContractSerialNo+"')"+
    	       "or objectno in((select serialno from acct_fee where objectno in (select serialno from acct_loan where putoutno = '"+sContractSerialNo+"'))) ")) ;
    //合同暂存标记
    String TempSaveFlag = Sqlca.getString(new SqlObject("select TempSaveFlag from business_contract where serialno='"+sContractSerialNo+"' ")) ;//是否暂存
    
    if(Integer.valueOf(scount)<=0 && TempSaveFlag.equals("2")){
		
		String productID = Sqlca.getString(new SqlObject("SELECT BusinessType FROM  business_contract  where serialno='"+sContractSerialNo+"' "));
		String PERIODS = Sqlca.getString(new SqlObject("SELECT PERIODS FROM  business_contract  where serialno='"+sContractSerialNo+"' "));//期数
		String productVersion = "V1.0";
		/* ProductManage productManage = new ProductManage(Sqlca);
		
		productManage.createTermObject(simulationObject);
		
		if(productID!=null&&productID.length()>0){
			productManage.initBusinessObject(simulationObject);			
		} */
		
		AbstractBusinessObjectManager bom=new DefaultBusinessObjectManager(Sqlca);
		String ObjectType = "jbo.app.BUSINESS_CONTRACT";
		BusinessObject documentObject = bom.loadObjectWithKey(ObjectType, sContractSerialNo);
		
		BusinessObject relativeObject =null;
	
		if(relativeObject==null) relativeObject = documentObject;
		simulationObject = documentObject;
		session.setAttribute("SimulationObject_BusinessContract",simulationObject);
		
		String transactionCode = "0020";
		String userID = CurUser.getUserID();
		String transactionDate = SystemConfig.getBusinessDate();
		int term = Integer.valueOf(PERIODS);
		String Maturity = documentObject.getString("Maturity");
		if(Maturity==null||Maturity.length()==0)
			Maturity = DateFunctions.getRelativeDate(transactionDate, DateFunctions.TERM_UNIT_MONTH, term);
		documentObject.setAttributeValue("Maturity", Maturity);//合同到期日
		BusinessObject transaction = TransactionFunctions.createTransaction(transactionCode, documentObject, relativeObject, userID, transactionDate, bom);

		transaction = TransactionFunctions.loadTransaction(transaction, bom);
		TransactionFunctions.runTransaction(transaction, bom);
		
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		session.setAttribute("SimulationObject_Loan",loan);
		loan.setRelativeObject(transaction);
	
		
    }
   
    
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
    //通过DW模型产生ASDataObject对象doTemp
  	String sTempletNo = "BusinessRepaymentList";//模型编号
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //生成datawindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //设置为Grid风格
    dwTemp.ReadOnly = "1"; //设置为只读
    
    Vector vTemp = dwTemp.genHTMLDataWindow(sContractSerialNo);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
    <%
    //依次为：
        //0.是否显示
        //1.注册目标组件号(为空则自动取当前组件)
        //2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
        //3.按钮文字
        //4.说明文字
        //5.事件
        //6.资源图片路径

    String sButtons[][] = {
        	{"true","","Button","详情","查看详情","viewDetail()",sResourcesPath},
        	{"true","","Button","还款到账查询","查看还款到账","viewDetail()",sResourcesPath},
    	};
    %>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
    function viewDetail()
    {
        sObejctType = "BusinessRepayment";
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
            alert(getHtmlMessage('1'));//请选择一条信息！
        }
        else
        {
            openObject(sObejctType,sSerialNo,"001");
        }
    }
    

    function initRow(){
    	var scount = "<%=scount%>"
    	var TempSaveFlag = "<%=TempSaveFlag%>"//1:暂存，2：保存
    	if(parseInt(scount, 10) < 1 && TempSaveFlag == "2"){
    		OpenComp("ACCT_LoanSimulationCashFlowTab","/Accounting/LoanSimulation/CashFlowTab.jsp","LoanType=XFD","_self");
    	}else{
    		
    	}
    	
    }
    </script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
    </script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init();
    my_load(2,0,'myiframe0');
    initRow();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>