<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ȹ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	��������ˮ�š��������͡������š�ҵ�����͡��ͻ����͡��ͻ�ID
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	ASDataObject doTemp = new ASDataObject("RelativeCreditInfo",Sqlca);	
	CreditObjectAction  creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);
	sObjectType = creditObjectAction.getRealCreditObjectType();
	String customerID = creditObjectAction.creditObject.getAttribute("CustomerID").getString();
	if(creditObjectAction.getCustomerType().startsWith("01")){ //��˾�ͻ�
		doTemp.setDDDWCodeTable("LmtCatalog","3005,��˾�ۺ����Ŷ��,3040,������˾�������");
	}else if (creditObjectAction.getCustomerType().startsWith("03")){ //���˿ͻ�
		//doTemp.setDDDWCodeTable("LmtCatalog","3008,�����ۺ����Ŷ��,3040,���������Ŷ��");
		doTemp.setDDDWCodeTable("LmtCatalog","3030,���������Ŷ��");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","����","����","saveRecord()",sResourcesPath},		
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{				
		if(checkLineRelative()){
			initSerialNo();
			as_save("myiframe0");
			goBack();
		}			
	}
    
    /*~[Describe=ȡ��������ȹ�����¼;InputParam=��;OutPutParam=ȡ����־;]~*/
	function goBack()
	{		
		OpenPage("/CreditManage/CreditApply/CreditLineRelaList.jsp","_self","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	/*~[Describe=��ȹ���У��;InputParam=��;OutPutParam=��;]~*/
	function checkLineRelative()
	{
		lmtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		sReturnValue = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CheckCreditLineType","checkCLType","CreditObjectType=<%=sObjectType%>,ApplySerialNo=<%=sObjectNo%>,LmtCatalog="+lmtCatalog);
		if(sReturnValue == "SUCCESS"){
			return true;
		}else{
			alert(sReturnValue);
			return false;
		}
	}
	
	/*~[Describe=���ݶ�����ͣ��ҵ���Ӧ�Ķ��Э���ѡ����ͼ;InputParam=��;OutPutParam=��;]~*/
	function selectLineNo()
	{
		lmtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		if(typeof(lmtCatalog) == "undefined" || lmtCatalog.length == 0){
			alert("����ѡ�������ͣ�");
			return;
		}
		selectCreditLine(lmtCatalog);
	}
	
	/*~[Describe=�������Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditLine(businessType)
	{	
		var sCustomerID = "<%=customerID%>";
		var sObjectType = "<%=sObjectType%>";
		var imtCatalog=getItemValue(0,getRow(),"LmtCatalog");
		var sParaString = "ObjectNo"+","+"<%=sObjectNo%>"+","+"ObjectType"+","+sObjectType+","+"CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>"+",BusinessType,"+businessType;

		if(imtCatalog == "3005")  //��˾
		{
			sReturn = setObjectValue("SelectCLContract",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");			
		}
		else if(imtCatalog == "3040"){  //����
			sReturn = setObjectValue("SelectCLContract2",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");
		}
		else if(imtCatalog == "3030"){ //������
			//���غ�ͬ��ˮ��,���,ҵ��Ʒ��,�ͻ�����,��ͬ���,����
			sReturn = setObjectValue("SelectCLContract1",sParaString,"@RelativeSerialNo@0@CustomerName@1@BusinessTypeName@2@BusinessSum@3@ExposureSum@4@PutOutDate@5@Maturity@6",0,0,"");
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_OCCUPY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼			
			//��������
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			//������
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");	
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