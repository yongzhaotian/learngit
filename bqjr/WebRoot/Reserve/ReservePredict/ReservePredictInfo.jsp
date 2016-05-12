<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   pwang  20091021
		Tester:
		Content:  Ԥ���ֽ���
		Input Param:
			SerialNo:�ֽ�����ˮ��
			AccountMonth:����·�
			DuebillNo����ݱ��
			
		Output param:
		History Log:

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���ֽ�����Ϣ"; // ��������ڱ��� 
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//����������
	String sSql = "";
	double dContractRate = 0.0,dAuditRate=0.0;
	String sCustomerName= "",sAccountMonth="",sDuebillNo="";
	String sCustomerType= "";
	String sCurrency="";

	//���ҳ�����
	//�ֽ�����ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	//������ˮ��
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";

	//���Ϊ����ʱ
	if(sSerialNo.equals("")){
		sSql = "select AccountMonth,DuebillNo,CustomerName,CustomerType,Currency,ContractRate,AuditRate from  RESERVE_APPLY where SerialNo= :SerialNo ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));		
	 	if(rs.next()){
	 		//����·�
	 		sAccountMonth = rs.getString("AccountMonth");
	 		//��ݺ�
	 		sDuebillNo = rs.getString("DuebillNo");
	 		sCustomerName = rs.getString("CustomerName");
	 		sCustomerType = rs.getString("CustomerType");
	 		sCurrency = rs.getString("Currency");
	 		//��ͬ����
	 		dContractRate = rs.getDouble("ContractRate");	
	 		//ʵ������
			dAuditRate = rs.getDouble("AuditRate");
		}
		rs.getStatement().close();
	}
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReservePredictInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform	
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//ִ�в�����߸��²����������Reserve_Total,Reserve_Apply�ֶ�
	dwTemp.setEvent("AfterInsert","!ReserveManage.FinishPredictData(#AccountMonth,#DuebillNo,#ObjectNo)");
	dwTemp.setEvent("AfterUpdate","!ReserveManage.FinishPredictData(#AccountMonth,#DuebillNo,#ObjectNo)");
		
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
		//6.��ԴͼƬ·��(sAbleToSee.equals("true"))?"true":"false"
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
	

		if(bIsInsert){
			initSerialNo();
			bIsInsert = false;
		}
		//��������ֵ	
		if(!calDiscountValue()) return;
		as_save("myiframe0",sPostEvents);		
	}


	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "RESERVE_PREDICTDATA";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	/*~[Describe=�����ֽ����ܶ�;InputParam=��;OutPutParam=��;]~*/
	function calDueSum(){
	    if(allowCalDueSum() == false){
	       return;
	    }
	    var dPredictValue = getItemValue(0,getRow(),"PredictValue");				
	    var dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");			
	    var dEnsureValue = getItemValue(0,getRow(),"EnsureValue");
	    var dSubstituteValue = getItemValue(0,getRow(),"SubstituteValue");
	    var dOtherWayValue = getItemValue(0,getRow(),"OtherWayValue");
	    var dDueSum = dPredictValue + dGuarantyValue + dEnsureValue + dSubstituteValue + dOtherWayValue;
	    setItemValue(0,getRow(),"PredictSum",dDueSum);	
	}
	/*~[Describe=�ֽ����ܶ����У��;InputParam=��;OutPutParam=��;]~*/
	function allowCalDueSum(){
		var dPredictValue = getItemValue(0,getRow(),"PredictValue");			
      	if (typeof(dPredictValue) == "undefined" || dPredictValue.length == 0){
			return false;
		}			
      	var dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");
      	if (typeof(dGuarantyValue) == "undefined" || dGuarantyValue.length == 0){
			return false;
		}
      	var dEnsureValue = getItemValue(0,getRow(),"EnsureValue");
      	if (typeof(dEnsureValue) == "undefined" || dEnsureValue.length == 0){
			return false;
		}
      	var dSubstituteValue = getItemValue(0,getRow(),"SubstituteValue");
      	if (typeof(dSubstituteValue) == "undefined" || dSubstituteValue.length == 0){
			return false;
		}
      	var dOtherWayValue = getItemValue(0,getRow(),"OtherWayValue");
      	if (typeof(dOtherWayValue) == "undefined" || dOtherWayValue.length == 0){
			return false;
		}
		return true;	   
	}
	/*~[Describe=����ֵ����;InputParam=��;OutPutParam=��;]~*/
	function calDiscountValue(){
		var dDiscountRate = getItemValue(0,getRow(),"DiscountRate");
	   	//��ʾ������Ϊ����λ�����ʣ���Ҫת��ΪС����ʽ��ʵ��ֵ //����������ʣ������1000������������ʣ������10000	  
	   	var dDiscountRate = dDiscountRate/1000;
	   	var sBaseDate = getItemValue(0,getRow(),"BaseDate");
	   	if(typeof(sBaseDate)=="undefined" || sBaseDate.length ==0){
	   		alert("����ҵ��Ļ������ݻ�׼���ڲ����ڣ����鱾�·ݵĻ������ݣ�");
	   		return false;
	   	}
	   	var sReturnDate = getItemValue(0,getRow(),"ReturnDate");
	   	if(typeof(sReturnDate)=="undefined" || sReturnDate.length ==0){
	   		alert("����ҵ��Ļ�������Ԥ�����ڲ����ڣ����鱾�·ݵĻ������ݣ�");
	   		return false;
	   	}
	   	var dPredictSum = getItemValue(0,getRow(),"PredictSum");	
	   	if(typeof(dPredictSum)=="undefined" || dPredictSum.length ==0){
	   		alert("����ҵ��Ļ��������ֽ����ܼƲ����ڣ����鱾�·ݵĻ������ݣ�");
	   		return false;
	   	}
		//����Ԥ��δ���ֽ�������ֵ��
		var sReturn = RunMethod("ReserveManage","ReservePredictCF",dDiscountRate+","+dPredictSum+",<%=sObjectNo%>,"+sReturnDate+","+sBaseDate);
		if(sReturn==null ||sReturn=="undefined"){
			alert("δ���ֽ���Ԥ�����û�н����");
		}else{
			dDiscountValue =sReturn;
		}
		if(isNaN(dDiscountValue)){
			setItemValue(0,getRow(),"DiscountSum","");	
		}else{	   		
		  	setItemValue(0,getRow(),"DiscountSum",dDiscountValue);
	    }
	   return true;
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	function initRow(){
		var sReturn ="";
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"DuebillNo","<%=sDuebillNo%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
			setItemValue(0,getRow(),"CustomerType","<%=sCustomerType%>");
			setItemValue(0,getRow(),"Currency","<%=sCurrency%>");
			setItemValue(0,getRow(),"PredictValue","<%=0.00%>");
			setItemValue(0,getRow(),"GuarantyValue","<%=0.00%>");
			setItemValue(0,getRow(),"EnsureValue","<%=0.00%>");
			setItemValue(0,getRow(),"SubstituteValue","<%=0.00%>");
			setItemValue(0,getRow(),"OtherWayValue","<%=0.00%>");
			setItemValue(0,getRow(),"PredictSum","<%=0.00%>");
			setItemValue(0,getRow(),"DiscountSum","<%=0.00%>");
			//���ݲ�ͬ����ĿҪ�����ò�ͬ��������:ʵ�����ʻ��ߺ�ͬ����
			//ĿǰĬ��Ϊ��ͬ����
			setItemValue(0,getRow(),"DiscountRate","<%=dContractRate%>");
			sReturn = RunMethod("ReserveManage","GetReserveBaseDate","<%=sObjectNo%>");
			if(sReturn==null ||sReturn=="undefined"){
				alert("��û�׼���ڴ���");
				sReturn ="";
			}			
			setItemValue(0,getRow(),"BaseDate",sReturn);			
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
