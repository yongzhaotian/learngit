<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29  ndeng 2004-11-30
		Tester:
		Describe: ���Ʊ����Ϣ
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
			SerialNo:	��ˮ��
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sBusinessType ="";  //ҵ��Ʒ��
	ASResultSet rs =null ;
	
	//����������
	String sObjectType    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType.equals("AfterLoan")) sObjectType = "BusinessContract";
	
	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
	String sSql = "";

	//************************changed by slliu 2005/03/04*******************************	
	if(sObjectType.equals("CreditApply")){
		sSql = "select BusinessType from BUSINESS_APPLY where SerialNo =:SerialNo";
	}else if(sObjectType.equals("ApproveApply")){
		sSql = "select BusinessType from BUSINESS_APPROVE where SerialNo =:SerialNo";
	}else if(sObjectType.equals("BusinessContract")){
		sSql = "select BusinessType from BUSINESS_CONTRACT where SerialNo =:SerialNo";
	}
	
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if (rs.next()){
		sBusinessType = rs.getString("BusinessType");  
	}  
	rs.getStatement().close();
	
	//************************changed by slliu 2005/03/04*******************************	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	String sTempletFilter = "";
	
	if(sBusinessType.equals("1020010")) //���гжһ�Ʊ����
	{
		sTempletNo = "BillInfo";
	}
	else if(sBusinessType.equals("1020020")) //��ҵ�жһ�Ʊ����
	{
		sTempletNo = "BillInfo";
		sTempletFilter = " colattribute like '%2%'";
	}
	else if(sBusinessType.equals("1020030")) //Э�鸶ϢƱ������
	{
		sTempletNo = "BillInfo";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//if(!sBusinessType.equals("1020020")) //���гжһ�Ʊ/Э�鸶ϢƱ������
	//{
		//����ʵ����ʵ����Ϣ
	//	doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate,EndorseTimes,Rate"," onChange=\"javascript:parent.getSum()\" ");
	//	doTemp.setReadOnly("actualSum,actualint",true);
	//}
	//else
	//{
	//    doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate"," onChange=\"javascript:parent.getSum()\" ");
	//}
	
	//���ý��Ϊ��λһ������
//	doTemp.setType("actualSum,actualint","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	//doTemp.setCheckFormat("actualSum,actualint","2");
//	doTemp.setCheckFormat("Rate","16"); /*��ʾС�����6λ*/
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
//	doTemp.setAlign("actualSum,actualint","3");
	   
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		
	    //���ҵ��Ʒ��
		sBusinessType = "<%=sBusinessType%>";

        //������ҵ��Ʒ��Ϊ�жһ�Ʊ���ֵ�Ʊ����Ϣʱ���������Ʊ�ݺŽ���Ψһ�Լ�顣add by cbsu 2009-11-10
        //1020010�����гжһ�Ʊ���� 1020020����ҵ�жһ�Ʊ���� 1020030��Э�鸶ϢƱ������ 1020040����ҵ�жһ�Ʊ����
        if (bIsInsert) {
			if (sBusinessType == "1020010" || sBusinessType == "1020020" || sBusinessType == "1020030" || sBusinessType == "1020040") {
				if (!validateCheck()) {
				    return;
				} 
			}
        }
		getSum();
		if(bIsInsert)
		{
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/RelativeBillList.jsp","_self","");
	}
	//����ʵ������ʵ����Ϣ
	function getSum()
	{
		//Ʊ�ݽ�Ʊ�ݵ����ա�Ʊ����������
		sBillSum = getItemValue(0,getRow(),"BillSum");
		sMaturity = getItemValue(0,getRow(),"Maturity");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
				
		//����������������
		sEndorseTimes = getItemValue(0,getRow(),"EndorseTimes");
		sRate = getItemValue(0,getRow(),"Rate");
				
		//��ʼ��ʵ����ʵ����Ϣ
		setItemValue(0,0,"actualSum",sBillSum);
		setItemValue(0,0,"actualint",0.00);
		
		if(typeof(sRate)=="undefined" || sRate.length==0) sRate=0; 
		if(typeof(sEndorseTimes)=="undefined" || sEndorseTimes.length==0) sEndorseTimes=0;
		if(typeof(sMaturity)=="undefined" || sMaturity.length==0) return;
		if(typeof(sFinishDate)=="undefined" || sFinishDate.length==0) return;
		
		sTerms = PopPageAjax("/CreditManage/CreditApply/getDayActionAjax.jsp?Maturity="+sMaturity+"&FinishDate="+sFinishDate,"","");
				
		if(typeof(sTerms)=="undefined" || sTerms.length==0) sTerms=0; 
				
		//����ʵ����Ϣ=(������ - ��������+��������)*������/30*Ʊ�ݽ��
		sActualint = sTerms*sRate*sBillSum/30000+sEndorseTimes*sRate*sBillSum/30000;
				
		//����ʵ�����=Ʊ�ݽ�� - ʵ����Ϣ
		sActualSum =  sBillSum - sActualint;
	
		//����ʵ����ʵ����Ϣ
		setItemValue(0,0,"actualSum",roundOff(sActualSum,2));
		setItemValue(0,0,"actualint",roundOff(sActualint,2));
		
	}

	/*~[Describe=�����������Ʊ�ݺ��Ƿ��Ѿ�����;InputParam=��;OutPutParam=��;]~*/
	//add by cbsu 2009-11-10
    function validateCheck() {
        var sBillNo = getItemValue(0,getRow(),"BillNo");
        var sContractSerialNo = "<%=sObjectNo%>";
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if (typeof(sBillNo) != "undefined" && sBillNo.length != 0) {
            var sParaString = sObjectType + "," + sContractSerialNo + "," + sBillNo;
            sReturn = RunMethod("BusinessManage","CheckApplyDupilicateBill",sParaString);
            //��������Ʊ�ݺ��Ѿ����ڣ��������������������
            if (sReturn != 0) {
                 alert("Ʊ�ݺ�:" + sBillNo + "�Ѵ��ڣ������¼�������Ʊ�ݺ��Ƿ���ȷ��");
                 return false;
            } else {
                return true;
            }
        }
        else{
        	alert("������Ʊ�ݱ�ţ�")
        	return false;
        }
    }
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BILL_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>