<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
    <%
    /*
    Content: ������ҳ��_Main
    Input Param:
        ApplyType����������
            ��CreditLineApply/���Ŷ������
            ��DependentApply/�����������    
            ��IndependentApply/��������ҵ������    
            ��ApproveApplyList/���ύ���������������
            ��PutOutApply/���ύ��˳���               
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;������ҳ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
    String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
    String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
    <%
    //�������
    String sItemName = "";//���������������
    String sItemDescribe = "";//���ApplyMainҳ�������ͼ��CodeNo
    String sCompID = "";//������
    String sCompName = "";//�������

    //����������    :��������
    String sApplyType = "MobilePosApply";//����ֱ�Ӹ�Ϊд����ApplyType
    String sPhaseType = DataConvert.toRealString(iPostChange,(CurComp.getParameter("PhaseType")));    
    //����ֵת���ɿ��ַ���
    if(sApplyType == null) sApplyType = "";
    if(sPhaseType == null) sPhaseType = "1010";
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
    <%
    //�����������ʹӴ����CODE_LIBRARY�в�ѯ��ApplyMain����ͼ�Լ�������Ľ׶Ρ������������ơ����ID�����Name
    String sSql = " select ItemDescribe,ItemName,Attribute7,Attribute8 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo = :ItemNo ";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
    if(rs.next()){
        sItemDescribe = rs.getString("ItemDescribe");
        sItemName = rs.getString("ItemName");
        sCompID = rs.getString("Attribute7");
        sCompName = rs.getString("Attribute8");
        //����ֵת���ɿ��ַ���
        if(sItemDescribe == null) sItemDescribe = "";
        if(sItemName == null) sItemName = "";
        if(sCompID == null) sCompID = "";
        if(sCompName == null) sCompName = "";
        
        //���ô��ڱ���
        PG_TITLE = sItemName;
        PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
    }else{
        throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApplyType:"+sApplyType+"����");
    }
    rs.getStatement().close();

    //����Treeview
    HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,sItemName,"right");
    tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
    tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
    tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

    //������ͼ�ṹ���Ӵ����CODE_LIBRARY�в�ѯ��ApplyMainҳ�������Ч�����Ͳ˵���Ϣ
    String sSqlTreeView = "from CODE_LIBRARY where CodeNo = '"+sItemDescribe+"'  and IsInUse = '1' ";
    tviTemp.initWithSql("SortNo","ItemName","Attribute5","","",sSqlTreeView,"Order By SortNo",Sqlca);
    //����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
    %>
<%/*~END~*/%>
 

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
    <script type="text/javascript"> 
    <%/*~[Describe=treeview����ѡ���¼�;]~*/%>
    function TreeViewOnClick(){
        var sCurItemDescribe = getCurTVItem().value;        
        sCurItemDescribe = sCurItemDescribe.split("@");
        sCurItemDescribe1 = sCurItemDescribe[0];
        sCurItemDescribe2 = sCurItemDescribe[1];
        sApplyType = "<%=sApplyType%>";
    
        if(sCurItemDescribe1 != "root"){
            AsControl.OpenView(sCurItemDescribe1,"ComponentName=���������б�&ApplyType=<%=sApplyType%>&PhaseType="+getCurTVItem().id,"right");
            setTitle(getCurTVItem().name);
        }
    }
    
    <%/*~[Describe=����treeview;]~*/%>
    function initTreeView(){
        <%=tviTemp.generateHTMLTreeView()%>
    }
    </script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
    <script type="text/javascript">
    initTreeView();
    expandNode('root');
    selectItem('<%=sPhaseType%>');       
    sApplyType = "<%=sApplyType%>";
    //�����������������ұ�ҳ���������
    if(sApplyType == 'CreditLineApply' || sApplyType == 'DependentApply' || sApplyType == 'IndependentApply')
        setTitle("����������");
    else if(sApplyType == 'PutOutApply')
        setTitle("���ύ��˷Ŵ�");
    else if(sApplyType == 'ApproveApply')
        setTitle("���ύ���������������");    
    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>