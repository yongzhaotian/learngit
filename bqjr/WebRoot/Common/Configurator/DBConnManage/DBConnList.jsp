<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-20
		Tester:
		Content: ���ݿ����ӹ����б�
		Input Param:
                    DBConnID��    ���ݿ����ӱ��
                    DBConnName��  ���ݿ���������
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ݿ����ӹ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	

	//���ҳ�����	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
   	String sHeaders[][] = {
				{"DBConnectionID","DBConnectionID"},
				{"DBConnectionName","DBConnectionName"},
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
				"From REG_DBCONN_DEF where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_DBCONN_DEF";
	doTemp.setKey("DBConnectionID",true);
	doTemp.setHeader(sHeaders);

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

	//��ѯ
 	doTemp.setColumnAttribute("DBConnectionID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
   
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
	
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("DBConnInfo","/Common/Configurator/DBConnManage/DBConnInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    reloadSelf(); 
                }
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sDBConnID = getItemValue(0,getRow(),"DBConnectionID");
        if(typeof(sDBConnID)=="undefined" || sDBConnID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        
        sReturn=popComp("DBConnInfo","/Common/Configurator/DBConnManage/DBConnInfo.jsp","DBConnID="+sDBConnID,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                reloadSelf();
            }
        }
	}
    
    /*~[Describe=�鿴���޸Ĵ�������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditCode()
	{
        sDBConnID = getItemValue(0,getRow(),"DBConnectionID");
        if(typeof(sDBConnID)=="undefined" || sDBConnID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        OpenPage("/Common/Configurator/DBConnManage/DBConnList.jsp?DBConnID="+sDBConnID,"_self","");    
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sDBConnID = getItemValue(0,getRow(),"DBConnectionID");
        if(typeof(sDBConnID)=="undefined" || sDBConnID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('46'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
