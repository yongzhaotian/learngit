<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author: lwang 20140221
        Tester:
        Describe: ����������Ϣ�б�
        Input Param:
        Output Param:       
        HistoryLog:
     */
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "����������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

    //�������

    //���ҳ�����

    //����������
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    String sChannelSerialNo = "";
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
    //ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "RepaymentChannelDetailList";//ģ�ͱ��
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  	String sSql = "select serialno from BaseDataSet_Info where TYPECODE='RepaymentChannel' and bigvalue "+
  					"=(select city from store_info si  where si.identtype='01' and "+
    				"si.sno=(select STORES from Business_Contract where SerialNo = :SerialNo))";
    //���������
    sChannelSerialNo = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo));
    if(null == sChannelSerialNo) sChannelSerialNo ="";
    //����datawindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //����ΪGrid���
    dwTemp.ReadOnly = "1"; //����Ϊֻ��
    
    Vector vTemp = dwTemp.genHTMLDataWindow(sChannelSerialNo);
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
    	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenPage("/CustomService/BusinessConsult/RepaymentChannelInfo.jsp","ChannelSerialNo=<%=sChannelSerialNo%>&detailSerialNo="+sSerialNo+"&OperateType=view&fromContractView=true","_self");
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