<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   
        Tester: 
        Content: ���ż��׸������
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "���ż��׸������"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
	String sTempletNo = "";//ģ��
     
    //����������    ���ͻ�����    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID == null) sGroupID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%    
    //ȡ��ģ���
    sTempletNo = "GroupApproveOpinionList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    
    //����DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
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
        //6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
        String sButtons[][] = {
    		//ֻ�м��ż��ױ������ʾ�ð�ť
    		{"true","","Button","�������","�������","viewOpinions()","","","",""},
    		{"true","","Button","�������ײݸ���Ϣ","�������ײݸ���Ϣ","viewGroupStemma()","","","",""}
    		
    	};
    %> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	function viewOpinions()
	{
		//��ü��ſͻ�ID
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //���º���װ汾�ţ��£�
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //����ǰ���װ汾�ţ��ɣ�
		
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ+"&EditRight=Readonly","");
		reloadSelf();
	}
	/*~[Describe=�鿴���ż��ײݸ���Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewGroupStemma()
	{
		//��ȡҵ����Ϣ
		sGroupID="<%=sGroupID%>";     //���ſͻ����
		sFamilySEQ = getItemValue(0,getRow(),"FamilySEQ");    			  //���º���װ汾�ţ��£�
		sOldFamilySEQ = getItemValue(0,getRow(),"OldFamilySEQ");    			  //���º���װ汾�ţ��£�
		
		if(typeof(sFamilySEQ)=="undefined" || sFamilySEQ.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		var sArgs="GroupID="+ sGroupID+"&FamilySEQ="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ;
		//���ż��ײݸ���Ϣ
		PopComp("FamilyVersionInternalList","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalList.jsp",sArgs,"");
        //ˢ��Listҳ��
		reloadSelf();
	}
    </script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
    my_load(2,0,'myiframe0');
</script>   
<%/*~END~*/%>

   
<%@ include file="/IncludeEnd.jsp"%>