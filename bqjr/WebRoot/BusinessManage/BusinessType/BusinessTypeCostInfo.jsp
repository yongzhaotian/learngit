<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��Ʒ��������
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
	String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
    System.out.println(sTypeNo+"----------------");
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	 
	ASDataObject doTemp = new ASDataObject("BusinessTypeCostInfo",Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var bCostID  = getItemValue(0,getRow(),"bCostID");
		var sUnique = RunMethod("Unique","uniques","business_type_cost,count(1),bCostID='"+bCostID+"'");
		if(bIsInsert && sUnique=="1.0"){
			alert("�ò�Ʒ����Ѿ���ռ��,�������µı��");
			return;
		}
		bIsInsert = false;
	    as_save("myiframe0");
	}
    
    /*~[Describe=����;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{   
		OpenPage("/BusinessManage/BusinessType/BusinessTypeCostList.jsp","_self","");
	}
    
	/*~[Describe=�����������Ψһ��;InputParam=;OutPutParam=�Ƿ��м�¼;]~*/
    function beforeSave()
    {
    	var bCostID  = getItemValue(0,getRow(),"bCostID");
		var sPara = "TypeNo=" + bCostID;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.product.BusinessTypeUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"TypeNo");
	    parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	/*~[Describe=��������ҵ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectECRBusiCode()
	{
		sParaString = "CodeNo"+",CreditType";		
		setObjectValue("SelectCode",sParaString,"@Attribute15@0@Attribute15Name@1",0,0,"");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=������������/����ҵ������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectFinancingType()
	{
		sParaString = "CodeNo"+",FinancingType";		
		setObjectValue("SelectCode",sParaString,"@Attribute25@0@Attribute25Name@1",0,0,"");
	}
	
	function initRow(){
		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼	
			setItemValue(0,0,"typeNo","<%=sTypeNo%>");
			setItemValue(0,0,"bCostID",getSerialNo("business_type_cost", "bCostID", ""));
			setItemValue(0,0,"bCostInputOrg", "<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"bCostInputUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"bCostInputTime", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"updateOrg", "<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}
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
