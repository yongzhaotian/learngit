<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-20
		Tester:
		Content: ���ݿ�������Ϣ����
		Input Param:
                    DBConnID��    ���ݿ����ӱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ݿ�������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
	String sDBConnID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DBConnID"));
	if(sDBConnID==null) sDBConnID="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

   	String sHeaders[][] = {
				{"DBConnectionID","DBConnectionID"},
				{"DBConnectionName DBConnectionName"},
				{"ConnType","ConnType"},
				{"ContextFactory","ContextFactory"},
				{"DataSourceName","DataSourceName"},
				{"DBURL","DBURL",""},
				{"DriverClass","DriverClass"},
				{"UserID","UserID"},
				{"Password","Password"},
				{"ProviderURL","ProviderURL"},
				{"DBChange","DBChange"},
			       };  

	sSql = " Select  "+
				"DBConnectionID,"+
				"DBConnectionName,"+
				"ConnType,"+
				"ContextFactory,"+
				"DataSourceName,"+
				"DBURL,"+
				"DriverClass,"+
				"UserID,"+
				"Password,"+
				"ProviderURL,"+
				"DBChange "+ 
				"From REG_DBCONN_DEF Where DBConnectionID ='"+sDBConnID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_DBCONN_DEF";
	doTemp.setKey("DBConnectionID",true);
	doTemp.setHeader(sHeaders);

	if (!sDBConnID.equals(""))
	{
		doTemp.setReadOnly("DBConnectionID",true);	
	}
	else
	{
		doTemp.setRequired("DBConnectionID",true);
	}
	doTemp.setHTMLStyle("DBConnectionID"," style={width:160px} ");
	doTemp.setHTMLStyle("DBConnectionName"," style={width:160px} ");
	doTemp.setHTMLStyle("ConnType"," style={width:160px} ");
	doTemp.setHTMLStyle("ContextFactory"," style={width:600px} ");
	doTemp.setHTMLStyle("DataSourceName"," style={width:160px} ");
	doTemp.setHTMLStyle("DBURL"," style={width:600px} ");
	doTemp.setHTMLStyle("UserID"," style={width:160px} ");
	doTemp.setHTMLStyle("Password"," style={width:160px} ");
	doTemp.setHTMLStyle("ProviderURL"," style={width:460px} ");
	doTemp.setHTMLStyle("DBChange"," style={width:160px} ");

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurDBConnID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
        as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"DBConnectionID");
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
