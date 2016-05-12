<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
    /*
        Author:zwang 2008.11.11
        Tester:
        Content: ��ϼ����б�ҳ��,���ݿͻ����ͣ�����·ݲ�ѯ���м����־Ϊ����ϼ��ᡱ�ļ�¼��
        Input Param:
            CustomerType: �ͻ�����
                01 ��˾�ͻ� 
                03 ���˿ͻ�
        Output param:
            ����·ݣ�AccountMonth
            ��ݱ�ţ�DuebillNo
        History Log: 
            modify by jgao 20090424 ����
    */
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
<%
    // ��������ڱ��� <title> PG_TITLE </title>
    String PG_TITLE = "��ϼ����б�"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    
    //����������
    
    //���ҳ�����
    String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
    if(sCustomerType == null) sCustomerType = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%  
    String sTempletNo = "ReserveCompList";
    String sManagerUserID=CurUser.getUserID();
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

    
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);  
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    //���ø�֧��ά����Ա��Ȩ�ޣ�ֻ������ά����Ա�ſ��Բ鿴ȫ�е���ϼ�������
   // doTemp.WhereClause += " and ManagerUserID = '"+CurUser.getUserID()+"'";
    if(!doTemp.haveReceivedFilterCriteria())
    {
        doTemp.WhereClause += " and AccountMonth = (select max(AccountMonth) from RESERVE_TOTAL where CalculateFlag = '10'  and CustomerType like '"+sCustomerType+"%')";
    } 
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    //����DW��� 1:Grid 2:Freeform
    dwTemp.Style="1"; 
    //�����Ƿ�ֻ�� 1:ֻ�� 0:��д     
    dwTemp.ReadOnly = "1"; 
    dwTemp.setPageSize(10);
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerType+","+sManagerUserID);
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
        {"true","","Button","��������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
    };
%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

    //---------------------���尴ť�¼�------------------------------------           
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
    function viewAndEdit()
    {
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        var sDueBillNo = getItemValue(0,getRow(),"DuebillNo");
        var sCustomerType = getItemValue(0,getRow(),"CustomerType");
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");
        
        if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0) 
            || (typeof(sDueBillNo) == "undefined" || sDueBillNo.length == 0))
        {
            alert("��ѡ��һ����¼��");
            return;
        }

        var sCompID = "ReserveTab";
        var sURL = "/Reserve/ReserveTab.jsp";
        var sParameter = "AccountMonth=" + sAccountMonth +
                         "&DueBillNo=" + sDueBillNo +
                         "&CustomerType=" + sCustomerType +
                         "&ReserveFlag=10" +
                         "&CustomerID=" + sCustomerID;
        popComp(sCompID,sURL,sParameter,"");
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
