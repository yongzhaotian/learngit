<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   zhuang 2010-03-17
        Tester:
        Content: ��˾�ͻ����ٲ�ѯ
        Input Param:
        Output param:
        History Log: 
     */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "��˾�ͻ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;��˾�ͻ����ٲ�ѯ&nbsp;&nbsp;";
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sSql;//--���sql���
    //����������            
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%  
    
    //����sSql�������ݶ���
    String sSortNo=CurOrg.getSortNo();
	String sTempletNo="CPQueryList";
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);   
//     //���ñ�ͷ
//     doTemp.setHeader(sHeaders); 
//     //���ùؼ���
//     doTemp.setKey("CustomerID",true);    

//     //�����ֶ�����
//     doTemp.setCheckFormat("RegisterCapital,PaiclUpCapital","2");
//     doTemp.setType("RegisterCapital,PaiclUpCapital","Number");
//     doTemp.setVisible("CustomerType,IndustryType",false);
    
//     //���ɡ���ҵ���͡�������ѡ���
//     doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerType' and  ItemNo in ('0110','0120')");
//     doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
    
//     //���ɲ�ѯ��
//     doTemp.generateFilters(Sqlca);
//     doTemp.setFilter(Sqlca,"1","EnterpriseName","");
//     doTemp.setFilter(Sqlca,"2","CustomerID","");
//     doTemp.setFilter(Sqlca,"3","CorpID","");
//     doTemp.setFilter(Sqlca,"4","InputOrgName","");
//     doTemp.setFilter(Sqlca,"5","CustomerType","Operators=EqualsString;");
//     doTemp.setFilter(Sqlca,"6","IndustryType","Operators=BeginsWith;");
//     doTemp.setFilter(Sqlca,"7","RegisterCapital","");
//     doTemp.setFilter(Sqlca,"8","RegisterAdd","");
//     doTemp.setFilter(Sqlca,"9","OfficeAdd","");
//     doTemp.setFilter(Sqlca,"10","LicenseNo","");
//     doTemp.setFilter(Sqlca,"11","MostBusiness","");
//     doTemp.setAlign("EmployeeNumber","3");
    
    doTemp.parseFilterData(request,iPostChange);
    if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); 

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(21);  //��������ҳ

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
        {"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
    };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
    <script type="text/javascript">
    //---------------------���尴ť�¼�------------------------------------

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
    function viewAndEdit()
    {
        //��ÿͻ����
        sCustomerID=getItemValue(0,getRow(),"CustomerID");  
        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
        {
            alert(getHtmlMessage(1));  //��ѡ��һ����¼��
            return;
        }else
        {
            openObject("Customer",sCustomerID,"002");
        }

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
