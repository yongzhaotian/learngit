<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   
        Tester: 
        Content: ���ż��׸�����Ϣ�б�
        Input Param:   
        Output Param:  
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "���ż��׸���"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sCurBranchOrg=""; //��ǰ�û����ڷ���
	String sCurOrgLevel=CurOrg.getOrgLevel(); //��ǰ�û����ڻ����ļ���
	String sUserID = CurUser.getUserID();
	String sCurOrgID = CurOrg.getOrgID(); //��ǰ�û���������
	String sTempletNo = "";//��ʾģ����
	String isCollectMangage = "";//�Ƿ����м��й���
	
    //������ʾģ��ʹ�ã����м��ż���ά���ڵ�¼��Է����ύ�ġ������й����������ļ�¼�ɼ�
    if(CurUser.hasRole("026")||CurUser.hasRole("000")){
		isCollectMangage = "1";//�����м��й��� 
	}else if (CurUser.hasRole("226")){
		isCollectMangage = "2";//�����м��й��� 
	}
	
    //����������    ���Ƿ��Ѵ���
    String sFinishFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"));
    if(sFinishFlag == null) sFinishFlag = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	if(sFinishFlag.equals("N")){//δ����
		if(sCurOrgLevel.equals("0")){//0������  3:����  6��֧�� 
			sTempletNo = "FamilyVersionList01";
		}else{
			sTempletNo = "FamilyVersionList";
		} 
	}else{						//�Ѵ���
		sTempletNo = "FamilyVersionList02"; 
	}

    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //���ӹ����� 
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //����DataWindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    dwTemp.setPageSize(20); //������datawindows����ʾ������
    dwTemp.Style="1"; //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    Vector vTemp = null;
    
    //����HTMLDataWindow
    if(sFinishFlag.equals("N")){//δ����
    	 vTemp = dwTemp.genHTMLDataWindow(isCollectMangage+","+sCurOrgID);
	}else{						//�Ѵ���
		 vTemp = dwTemp.genHTMLDataWindow(isCollectMangage+","+sUserID);
	}
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
            {"true","","Button","��������","��������","viewTab()","","","","btn_icon_detail"},
            {(sFinishFlag.equals("N")?"true":"false"),"","Button","����","����","signCheckOpinion()","","","",""},
            {(sFinishFlag.equals("N")?"false":"true"),"","Button","�鿴�������","�鿴�������","viewCheckOpinion()","","","",""}
        };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

   
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	/*~[Describe=���� ;InputParam=��;OutPutParam=��;]~*/
	function signCheckOpinion() 
	{
		//��ü��ſͻ�ID
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sVersionSeq = getItemValue(0,getRow(),"VersionSeq");
		sOldFamilySeq = getItemValue(0,getRow(),"RefVersionSeq");
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sVersionSeq+"&OldFamilySeq="+sOldFamilySeq,"");
		reloadSelf();
	}	
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		var sGroupID = getItemValue(0,getRow(),"GroupID");
		var sRightType="ReadOnly";
		
     	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
     		 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		PopComp("CustomerDetailTab","/CustomerManage/CustomerDetailTab.jsp", "GroupID="+sGroupID+"&RightType="+sRightType, "");
	    reloadSelf();
	}
	
	/*~[Describe=�鿴ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCheckOpinion() 
	{
		//����������͡�������ˮ�š����̱�š��׶α�š�����������ˮ��
		sGroupID = getItemValue(0,getRow(),"GroupID");
		sFamilySEQ = getItemValue(0,getRow(),"VersionSeq");
		sOldFamilySEQ = getItemValue(0,getRow(),"RefVersionSeq");
		
		if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompURL = "/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionOpinionView.jsp";
		PopComp("FamilyVersionOpinionView",sCompURL,"GroupID="+sGroupID+"&FamilySeq="+sFamilySEQ+"&OldFamilySEQ="+sOldFamilySEQ+"&EditRight=Readonly","");
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