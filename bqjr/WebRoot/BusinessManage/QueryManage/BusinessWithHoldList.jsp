<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author: lwang 20140221
        Tester:
        Describe: ������Ϣ�б�
        Input Param:
        Output Param:       
        HistoryLog:
     */
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

    //�������

    //���ҳ�����

    //����������
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    
    System.out.println("--------"+sObjectType+"----------"+sContractSerialNo);
    
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
    //ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "BusinessWithHoldList";//ģ�ͱ��
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    //����datawindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //����ΪGrid���
    dwTemp.ReadOnly = "1"; //����Ϊֻ��
    
    Vector vTemp = dwTemp.genHTMLDataWindow(sContractSerialNo);
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
        {"true","","Button","����","�鿴����","viewDetail()",sResourcesPath},
        };
    %>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
    <script type="text/javascript">
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
    function viewDetail()
    {
        //sObejctType = "BusinessChannel";
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }
        else
        {
            //openObject(sObejctType,sSerialNo,"001");
        	OpenPage("/BusinessManage/QueryManage/BusinessWithHoldInfo.jsp?SerialNo="+sSerialNo, "_self","");
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