<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author: lwang 20140221
        Tester:
        Describe: ��ͬ�µķ�����Ϣ�б�
        Input Param:
        Output Param:       
        HistoryLog:
     */
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

    //�������

    //���ҳ�����SELECT defaultvalue FROM product_term_para where paraid='FeeRate' and objectno='';

    //����������
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";
    //�Ƿ�Ͷ��
    String sCreditCycle = Sqlca.getString(new SqlObject("SELECT CreditCycle FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
    if(sCreditCycle == null)sCreditCycle="2";
    
    String bxFeeRate = "0.0";
	String bxFeeAmt = "";
	double bxFeeAmount = 0.0;
	
	String bxFeeAmounts = "0.0";
	double yearbxFeeRate = 0.0;
	String YearSecurety = "0.0";
	double yearbxFeeamt = 0.0;
	String YearSecure = "0.0";
    if(sCreditCycle.equals("1")){
   
	    String BusinessSum = Sqlca.getString(new SqlObject("SELECT BusinessSum FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
	    if(BusinessSum == null)BusinessSum="0.0";
	    
	    String Periods = Sqlca.getString(new SqlObject("SELECT PERIODS FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
	    String BusinessType = Sqlca.getString(new SqlObject("SELECT businesstype FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
		String ObjectNo = BusinessType+"-V1.0";
		String bxftermid = Sqlca.getString(new SqlObject("SELECT termid FROM product_term_library where subtermtype='A12' and objectno='"+ObjectNo+"' "));
		if(bxftermid == null ) bxftermid = "";
		
		String bxFeeCalType = Sqlca.getString(new SqlObject("SELECT defaultvalue FROM product_term_para where termid='"+bxftermid+"' and paraid='FeeCalType' and objectno='"+ObjectNo+"' "));
		if(bxFeeCalType == null ) bxFeeCalType = "";
		
		if(!bxFeeCalType.equals("")){
			if("01".equals(bxFeeCalType)){//�̶����
				bxFeeAmt = Sqlca.getString(new SqlObject("SELECT defaultvalue FROM product_term_para where termid='"+bxftermid+"' and paraid='FeeAmount' and objectno='"+ObjectNo+"' "));
				if(bxFeeAmt == null ) bxFeeAmt = "";
				bxFeeAmount = Double.parseDouble(bxFeeAmt);
			}else if("02".equals(bxFeeCalType)){//������*����
				bxFeeRate = Sqlca.getString(new SqlObject("SELECT defaultvalue FROM product_term_para where termid='"+bxftermid+"' and paraid='FeeRate' and objectno='"+ObjectNo+"' "));
				if(bxFeeRate == null ) bxFeeRate = "";
				bxFeeAmount = Double.parseDouble(BusinessSum)*(Double.parseDouble(bxFeeRate)*0.01);//ÿ�±��շ�
			}
			
			bxFeeAmounts = String.valueOf(bxFeeAmount);
			yearbxFeeRate = Double.parseDouble(bxFeeRate)*12;
			YearSecurety = String.valueOf(yearbxFeeRate);
			yearbxFeeamt = bxFeeAmount*12;
			YearSecure = String.valueOf(yearbxFeeamt);
		}
    }
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
    //ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "BusinessRateList";//ģ�ͱ��
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
        {"false","","Button","��������","�鿴��������","viewDetail()",sResourcesPath},
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
        sObejctType = "BusinessRate";
      // sObejctType = "BusinessContract";
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }
        else
        {
        	//alert(sObejctType+"======="+sSerialNo);
            openObject(sObejctType,sSerialNo,"003");
        }
    } 

    function initRow()
    {
    	var MonthSecure = "<%=bxFeeAmounts%>";
    	var MonthSecurety = "<%=bxFeeRate%>";
    	var YearSecure = "<%=YearSecure%>";
    	var YearSecurety = "<%=YearSecurety%>";
		setItemValue(0,0,"MonthSecure",parseFloat(MonthSecure).toFixed(2)+"");	//��ͬ�����±��շ�(Ԫ)
		setItemValue(0,0,"MonthSecurety",parseFloat(MonthSecurety).toFixed(2)+"");//��ͬ�����±��շ���(%)
		setItemValue(0,0,"YearSecure",parseFloat(YearSecure).toFixed(2)+"");	//��ͬ�����걣�շ�(Ԫ)
		setItemValue(0,0,"YearSecurety",parseFloat(YearSecurety).toFixed(2)+"");//��ͬ�����걣�շ���(%)
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