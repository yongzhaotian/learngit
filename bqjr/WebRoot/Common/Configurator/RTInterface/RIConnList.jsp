<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content:
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ӹ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
    //����������	

	//���ҳ�����
	String sCONNECTID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CONNECTID"));
    if (sCONNECTID == null) 
        sCONNECTID = "";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"CONNECTID","CONNECTID"},
		{"CONNECTDESC","CONNECTDESC"},
		{"CONNHOST","CONNHOST"},
		{"CONNPORT","CONNPORT"},
	};
	sSql = "select "+
		   "CONNECTID,"+
		   "CONNECTDESC,"+
		   "CONNHOST,"+
		   "CONNPORT "+
		  "from RI_CONNECTDEF where 1=1";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "RI_CONNECTDEF";
	doTemp.setKey("CONNECTID",true);
	doTemp.setHeader(sHeaders);

	//����С����ʾ״̬,
	doTemp.setAlign("CONNECTID,CONNPORT","3");
	doTemp.setType("CONNECTID,CONNPORT","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("CONNECTID,CONNPORT","2");
	

	//��ѯ
 	doTemp.setColumnAttribute("CONNECTID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
   	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sReturn=popComp("RIConnInfo","/Common/Configurator/RTInterface/RIConnInfo.jsp","","");
		//�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0 && sReturn=='HasModified') 
		{
			reloadSelf();
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sCONNECTID = getItemValue(0,getRow(),"CONNECTID");
		if(typeof(sCONNECTID)=="undefined" || sCONNECTID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
        sReturn=popComp("RIConnInfo","/Common/Configurator/RTInterface/RIConnInfo.jsp","CONNECTID="+sCONNECTID,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0 && sReturn=='HasModified') 
        {
			reloadSelf();
        }
	}
    
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		as_save("myiframe0","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCONNECTID = getItemValue(0,getRow(),"CONNECTID");
		if(typeof(sCONNECTID)=="undefined" || sCONNECTID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
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
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
