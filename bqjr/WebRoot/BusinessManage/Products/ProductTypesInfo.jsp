<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --������Ʒϵ��
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
	String PG_TITLE = "������Ʒϵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
    //��Ʒ����
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
    if(null == sProductType) sProductType = "";
  //��Ʒ������
    String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));
    if(null == sSubProductType) sSubProductType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("ProductTypesInfo",Sqlca);
	//add by  ybpan CCS-583 --CCS-583  ----��������ԤԼ�ֽ�������ҵ��Ա�󶨲�Ʒ/���۴������ܳ���
    // ������ֽ���Ļ����Ͱ��ֽ���������ֶ����أ�����������ʾ
	if("020".equals(sProductType) || "7".equals(sSubProductType) ){	//ѧ�����Ѵ���ʾ��Ʒ�����ͣ� edit by dahl 
		doTemp.setVisible("SubProductType",true);
		doTemp.setVisible("ProductType",false);
	}
	//end by ybpan CCS-583 --CCS-583 at 20150411
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
		var productID  = getItemValue(0,getRow(),"productID");
		var sUnique = RunMethod("Unique","uniques","Product_Types,count(1),productID='"+productID+"'");
		if(bIsInsert && sUnique=="1.0"){
			alert("�ò�Ʒ����Ѿ���ռ��,�������µı��");
			return;
		}
		
		bIsInsert = false;
	    as_save("myiframe0");

	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/BusinessManage/Products/ProductTypesList.jsp","_self","");


	}
    
	/*~[Describe=�����������Ψһ��;InputParam=;OutPutParam=�Ƿ��м�¼;]~*/
    function beforeSave()
    {
    	var productID  = getItemValue(0,getRow(),"productID");
		var sPara = "TypeNo=" + productID;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.product.BusinessTypeUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"productID");
	    parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			//setItemValue(0,0,"productID", getSerialNo("Product_Types", "productID", " "));
			setItemValue(0,0,"productID", "<%=DBKeyHelp.getSerialNoXD("Product_Types", "productID", "yyyyMMdd", "000", new  Date(), Sqlca)%>");
			setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"updateUser","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"updateOrg","<%=CurOrg.orgID %>");
			setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"updateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ProductType","<%=sProductType%>");//add �ֽ������
			setItemValue(0,0,"SubProductType","<%=sSubProductType%>");//��Ʒ������   add by ybpan   CCS-583   --��������ԤԼ�ֽ�������ҵ��Ա�󶨲�Ʒ/���۴������ܳ���
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
