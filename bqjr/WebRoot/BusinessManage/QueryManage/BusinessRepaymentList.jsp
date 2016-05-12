<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@page import="com.amarsoft.app.accounting.trans.TransactionFunctions"%>
<%@page import="com.amarsoft.app.accounting.product.ProductManage"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author: lwang 20140221
        Tester:
        Describe: ����ƻ���Ϣ�б�
        Input Param:
        Output Param:       
        HistoryLog:
     */
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "����ƻ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

    //�������

    //���ҳ�����
	BusinessObject simulationObject = null;//(BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");
	simulationObject=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
	
    
    //����������
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";
    
    String scount = Sqlca.getString(new SqlObject("select count(*) from Acct_Payment_Schedule where objectno in "+
    	       "(select serialno from acct_loan where putoutno = '"+sContractSerialNo+"')"+
    	       "or objectno in((select serialno from acct_fee where objectno in (select serialno from acct_loan where putoutno = '"+sContractSerialNo+"'))) ")) ;
    //��ͬ�ݴ���
    String TempSaveFlag = Sqlca.getString(new SqlObject("select TempSaveFlag from business_contract where serialno='"+sContractSerialNo+"' ")) ;//�Ƿ��ݴ�
    
    if(Integer.valueOf(scount)<=0 && TempSaveFlag.equals("2")){
		
		String productID = Sqlca.getString(new SqlObject("SELECT BusinessType FROM  business_contract  where serialno='"+sContractSerialNo+"' "));
		String PERIODS = Sqlca.getString(new SqlObject("SELECT PERIODS FROM  business_contract  where serialno='"+sContractSerialNo+"' "));//����
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
		documentObject.setAttributeValue("Maturity", Maturity);//��ͬ������
		BusinessObject transaction = TransactionFunctions.createTransaction(transactionCode, documentObject, relativeObject, userID, transactionDate, bom);

		transaction = TransactionFunctions.loadTransaction(transaction, bom);
		TransactionFunctions.runTransaction(transaction, bom);
		
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		session.setAttribute("SimulationObject_Loan",loan);
		loan.setRelativeObject(transaction);
	
		
    }
   
    
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
    //ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "BusinessRepaymentList";//ģ�ͱ��
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //����datawindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //����ΪGrid���
    dwTemp.ReadOnly = "1"; //����Ϊֻ��
    
    Vector vTemp = dwTemp.genHTMLDataWindow(sContractSerialNo);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
    <%
    //����Ϊ��
        //0.�Ƿ���ʾ
        //1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
        //2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
        //3.��ť����
        //4.˵������
        //5.�¼�
        //6.��ԴͼƬ·��

    String sButtons[][] = {
        	{"true","","Button","����","�鿴����","viewDetail()",sResourcesPath},
        	{"true","","Button","����˲�ѯ","�鿴�����","viewDetail()",sResourcesPath},
    	};
    %>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
    <script type="text/javascript">
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
    function viewDetail()
    {
        sObejctType = "BusinessRepayment";
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }
        else
        {
            openObject(sObejctType,sSerialNo,"001");
        }
    }
    

    function initRow(){
    	var scount = "<%=scount%>"
    	var TempSaveFlag = "<%=TempSaveFlag%>"//1:�ݴ棬2������
    	if(parseInt(scount, 10) < 1 && TempSaveFlag == "2"){
    		OpenComp("ACCT_LoanSimulationCashFlowTab","/Accounting/LoanSimulation/CashFlowTab.jsp","LoanType=XFD","_self");
    	}else{
    		
    	}
    	
    }
    </script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
    <script type="text/javascript">
    </script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init();
    my_load(2,0,'myiframe0');
    initRow();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>