<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ע���������Ϣ����
		Input Param:
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ע���������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
	String sCommentItemID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CommentItemID"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sIsNew =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsNew"));
	
    if(sCommentItemID==null) sCommentItemID="";
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(sIsNew==null) sIsNew="";

    if(sIsNew.equals("Y") && !sObjectType.equals("")) sObjectType="";
    if(sIsNew.equals("Y") && !sObjectNo.equals("")) sObjectNo="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

   	String sHeaders[][] = {
				{"CommentItemID","ע������"},
				{"ObjectType","ע�Ͷ�������"},
				{"ObjectNo","ע�Ͷ���ID"},
				{"SortNo","�����"},
			       };  

	sSql = " Select  CommentItemID,"+
				"ObjectType,"+
				"ObjectNo,"+
				"SortNo "+
				"From REG_COMMENT_RELA " +
				"Where CommentItemID='"+sCommentItemID+"' And ObjectType ='"+sObjectType+"' And ObjectNo ='"+sObjectNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMMENT_RELA";
	doTemp.setKey("CommentItemID,ObjectType,ObjectNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setReadOnly("CommentItemID",true);
	doTemp.setDDDWSql("ObjectType","select ObjectType,ObjectName from OBJECTTYPE_CATALOG");
	doTemp.setRequired("ObjectType,ObjectNo",true);

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
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurCommentItemID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","newRecord()");
	}

    	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CommentItemID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sCommentItemID = getItemValue(0,getRow(),"CommentItemID");
        OpenComp("CommentRelaInfo","/Common/Configurator/CommentManage/CommentRelaInfo.jsp","CommentItemID="+sCommentItemID+"&IsNew=Y","_self","");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            if ("<%=sCommentItemID%>" !="") 
            {
                setItemValue(0,0,"CommentItemID","<%=sCommentItemID%>");
            }
		    setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
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
