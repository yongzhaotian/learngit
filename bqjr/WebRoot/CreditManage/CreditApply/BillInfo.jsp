<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-21  
		Tester:
		Describe: Ʊ����Ϣ��������ʱ��Ʊ����Ϣ
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
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
	ASResultSet rs =null ;
	
	//����������
	String sContractSerialNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sBusinessType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	if(sSerialNo == null ) sSerialNo = ""; 
    if(sObjectNo == null) sObjectNo = ""; 
    if(sContractSerialNo == null) sContractSerialNo = ""; 
    if(sBusinessType == null) sBusinessType = ""; 

    String sObjectType = "BusinessContract";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	if(sBusinessType.equals("2010")) //���гжһ�Ʊ
	{
		sTempletNo = "BillInfo1";
	}
	else
	{
		sTempletNo = "BillInfo2";
	}

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//add by sjchuan ����һ�γ���������Գ�����Ʊ�ݵĹ���
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertPutoutRelative("+sObjectNo+",#SerialNo,"+StringFunction.getToday()+","+CurUser.getUserID()+","+sBusinessType+")");	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		//������Ʊ����Ϣʱ�����ҵ��Ʒ��Ϊ"���гжһ�Ʊ����"��ִ����֤��顣add by cbsu 2009-11-03
		//��Ϊ"���гжһ�Ʊ"��Ʊ�ݺ�Ҳ��Ψһ�ģ���������˶�Ʊ�ݺŵļ�顣add by cbsu 2009-11-09
		//2010�����гжһ�Ʊ 1020010�����гжһ�Ʊ���� 1020020����ҵ�жһ�Ʊ���� 1020030��Э�鸶ϢƱ������ 1020040����ҵ�жһ�Ʊ����
		if (bIsInsert) {
            if (sBusinessType == "2010" || sBusinessType == "1020010" || sBusinessType == "1020020"
                || sBusinessType == "1020030" || sBusinessType == "1020040") {
                if (!validateCheck()) {
                    return;
                }
            }
        }
		
	
		getSum();
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();		
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/BillList.jsp","_self","");
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
		
		if(typeof(sRate)=="undefined" || sRate == null || sRate.length==0) sRate=0; 
		if(typeof(sEndorseTimes)=="undefined" || sEndorseTimes == null || sEndorseTimes.length==0) sEndorseTimes=0;
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
			setItemValue(0,0,"ObjectNo","<%=sContractSerialNo%>");
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

	/*~[Describe=������ǰ��֤�����Ʊ�ݺ��Ƿ��Ѿ����ڻ�����;InputParam=��;OutPutParam=��;]~*/
	//add by cbsu 2009-11-03
	function validateCheck() {
		var sBillNo = getItemValue(0,getRow(),"BillNo");
		var sContractSerialNo = "<%=sContractSerialNo%>";
		var sPutOutNo = "<%=sObjectNo%>";
		if (typeof(sBillNo) != "undefined" && sBillNo.length != 0) {
			var sParaString = sBillNo + "," + sContractSerialNo + "," + sPutOutNo;
		    sReturn = RunMethod("BusinessManage","CheckDuplicateBill",sParaString);
		    //��������Ʊ�ݺ��Ѿ����ڣ��������������������
	        if (sReturn == "Failed") {
	             alert("Ʊ�ݺ�:" + sBillNo + "�Ѵ��ڣ�");
	             return false;
	         }
	         //��������Ʊ�ݺſ������룬�����롣
	         else if (sReturn == "Import") {
	             var sBillSerialNo = RunMethod("BusinessManage","GetBillSerialNo",sBillNo);
	             sParaString = sPutOutNo + "," + sBillSerialNo + "," + 
	                           "<%=StringFunction.getToday()%>" + "," + "<%=CurUser.getUserID()%>" + "," + "<%=sBusinessType%>";
	             RunMethod("BusinessManage","InsertPutoutRelative",sParaString);            
	             alert("Ʊ�ݺ�:" + sBillNo + "����ɹ���");
	             return false;
	         } else {
	             return true;
	         }
		} else {
			return true;
		}
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