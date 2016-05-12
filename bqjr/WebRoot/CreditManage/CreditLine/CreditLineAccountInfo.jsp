
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
    <%
    /*
        Author:zywei 2005/08/29
        Tester:
        Content: ���Ŷ�Ȼ�����Ϣҳ��
        Input Param:
            LineID�����Ŷ�ȱ��            
        Output param:
        History Log: 
            2009-10-21 cbsu �����±���CL_INFO����ΪBUSINESS_CONTRACT

     */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "���Ŷ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
    CurPage.setAttribute("ShowDetailArea","true");
    CurPage.setAttribute("DetailAreaHeight","300");
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

    //������� add by cbsu 2009-10-20
    ASResultSet rs = null;//-- ��Ž����
    String sSql = "";
    //����������

    //���ҳ�����
    String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    //����ֵת��Ϊ���ַ���
    if(sSerialNo == null) sSerialNo = "";   

	sSql = " select LineID from CL_INFO where BCSerialNo=:BCSerialNo and (ParentLineID is null or ParentLineID='' or ParentLineID=' ') ";
	//������Ŷ����Э���
	String sParentLineID = Sqlca.getString(new SqlObject(sSql).setParameter("BCSerialNo",sSerialNo));
	if(sParentLineID==null) sParentLineID="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
    <%
    String[][] sHeaders = {                                            
                           {"CustomerID","�ͻ����"},
                           {"CustomerName","�ͻ�����"},
                           {"BusinessSum","��Ƚ��"},
                           {"TotalBalance","������"},
                           {"BusinessCurrency","����"},    
                           {"BeginDate","��Ч��"},
                           {"PutOutDate","��ʼ��"},
                           {"Maturity","������"},            
                           {"LimitationTerm","���ʹ���������"},                
                           {"UseTerm","�������ҵ����ٵ�������"},                
                           {"InputOrgName","�Ǽǻ���"},
                           {"InputUserName","�Ǽ���"},
                           {"InputDate","�Ǽ�����"},
                           {"UpdateDate","��������"}
            };
    sSql = " Select SerialNo, CustomerID, CustomerName, BusinessCurrency, BusinessSum,TotalBalance, " + //�ͻ���ţ��ͻ����ƣ���Ƚ�����
           " BeginDate, PutOutDate, Maturity, LimitationTerm, UseTerm, " + //�������ڣ���ʼ�գ������գ����ʹ��������ڣ��������ҵ����ٵ�������
           " InputOrgID, GetOrgName(InputOrgID) as InputOrgName," + //�Ǽǻ���
           " InputUserID, GetUserName(InputUserID) as InputUserName," + //�Ǽ���
           " InputDate, UpdateDate" + //�Ǽ����ڣ���������
           " From BUSINESS_CONTRACT" +
           " Where SerialNo = '" + sSerialNo + "'";
    
    ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.UpdateTable = "BUSINESS_CONTRACT";
    doTemp.setKey("SerialNo",true);    
    doTemp.setHeader(sHeaders);
    doTemp.setDDDWCode("BusinessCurrency","Currency");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
    doTemp.setHTMLStyle("BeginDate,PutOutDate,Maturity,LimitationTerm,UseTerm"," style={width:80px} ");
    //���ò��ɼ�����
    doTemp.setVisible("InputUserID,InputOrgID,SerialNo",false);
    //���ò��ɸ�������
    doTemp.setUpdateable("InputUserName,InputOrgName",false);
    //���ø�ʽ
    doTemp.setType("BusinessSum,TotalBalance","Number");
	doTemp.setCheckFormat("BusinessSum,TotalBalance","2");
    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
    dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
    //����setEvent
        
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow("");
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
            {"true","","Button","���Ŷ������ҵ��","������Ŷ������ҵ��","lineSubList()",sResourcesPath},        
            {"true","","Button","�鿴���ռ�����","�鿴���ռ�����","viewLineUsed()",sResourcesPath}        
        };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
    <script type="text/javascript">
    
    //---------------------���尴ť�¼�------------------------------------
    /*~[Describe=���Ŷ������ҵ��;InputParam=��;OutPutParam=��;]~*/
    function lineSubList()
    {        
        sSerialNo = "<%=sSerialNo%>";
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","LineNo="+sSerialNo,"","");
    }
    </script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
    <script type="text/javascript">
    /*~[Describe=�鿴���ռ�����;InputParam=��;OutPutParam=��;]~*/
    function viewLineUsed()
    {        
    	sSerialNo = "<%=sSerialNo%>";
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        sReturn = PopPage("/CreditManage/CreditLine/GetLineBalance.jsp?LineNo="+sSerialNo,"","dialogWidth=26;dialogHeight=14;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
       }
    
    </script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">    
    AsOne.AsInit();
    init();
    var bFreeFormMultiCol = true;
    my_load(2,0,'myiframe0');    
    OpenPage("/CreditManage/CreditLine/SubCreditLineAccountList.jsp?ParentLineID=<%=sParentLineID%>","DetailFrame","");
</script>    
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
