<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
    /*
        Author:zwang 2008.11.11
        Tester:
        Content: ��ϼ�����Ϣҳ��
        Input Param:
            ����·ݣ�AccountMonth
            ��ݱ�ţ�DuebillNo
        Output param:
        History Log: 
            modify by jgao 20090424 ����
    */
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
    // ��������ڱ��� <title> PG_TITLE </title>
    String PG_TITLE = "��ϼ�����Ϣ"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sAccountMonth,sDuebillNo,sCustomerType;
    //����������
    
    //���ҳ�����            
    sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    sDuebillNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DuebillNo"));
    if(sAccountMonth == null) sAccountMonth = "";
    if(sDuebillNo == null) sDuebillNo = "";
    sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
    if(sCustomerType == null) sCustomerType = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
    //ͨ����ʾģ�����ASDataObject����doTemp
    String sTempletNo = "ReserveCompInfo";
    String sTempletFilter = "1=1";
    ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);    
    if(sCustomerType.equals("03"))
        doTemp.setVisible("IsMsIndustry,IndustryGrade,IsMarket,IndustryType,BelongArea",false);
   
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
    //����DW��� 1:Grid 2:Freeform
    dwTemp.Style="2";      
    //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.ReadOnly = "0"; 
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sDuebillNo);
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
            //{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
            //{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
    };
%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
<script type="text/javascript">
    
    //---------------------���尴ť�¼�------------------------------------
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
    function saveRecord(sPostEvents)
    {
        //����ǰ�����Զ���λ
        beforeUpdate();
        as_save("myiframe0",sPostEvents);
    }
    
    /*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
    function goBack()
    {
        OpenPage("/Reserve/ReserveComp/ReserveCompList.jsp","_self","");
    }
</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
        
    /*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
    function beforeUpdate()
    {
        //���������Զ���λ
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
    }
        
    /*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
    function initRow()
    {
        //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
        if (getRowCount(0)==0) 
        {
            //������¼
            as_add("myiframe0");
            bIsInsert = true;
        }
    }
</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init();
    var bFreeFormMultiCol = true;
    my_load(2,0,'myiframe0');
    //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
    initRow();
    var bCheckBeforeUnload = false;
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
