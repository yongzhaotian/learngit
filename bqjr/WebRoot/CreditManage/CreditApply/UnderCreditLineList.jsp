<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%> 
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: �������ҵ��
		Input Param:
			ObjectType: �׶α��
			ObjectNo��ҵ����ˮ��
		Output Param:

		HistoryLog: 
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCustomerID="",sBusinessType="";
	String sSql = ""; 
	String sWhereCondition="";
	ASResultSet rs=null;

	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�õ�ҵ��Ʒ�ֺͿͻ�
	sSql="select CustomerID,BusinessType  from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
	}
	rs.getStatement().close(); 
	
	sWhereCondition= " where BUSINESS_CONTRACT.BusinessType not in ('5010','5020') and (BUSINESS_CONTRACT.FinishDate = ' ' or BUSINESS_CONTRACT.FinishDate is null) and BUSINESS_CONTRACT.ContractFlag='010'";

	//ͨ����ʾģ�����ASDataObject����doTemp
    String sTempletNo = "UnderCreditLineList";
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    if(sBusinessType.equals("5010")){
	    doTemp.WhereClause = doTemp.WhereClause+" and BUSINESS_CONTRACT.CustomerID = '"+sCustomerID+"' ";
    }
    else if(sBusinessType.equals("5020")){
	    doTemp.WhereClause = doTemp.WhereClause+" and BUSINESS_CONTRACT.CreditAggreement = '"+sObjectNo+"' ";
    }
    
    doTemp.WhereClause += sWhereCondition;

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"true","","Button","����","�鿴�������ҵ������","viewAndEdit()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function viewAndEdit(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			openObject("BusinessContract",sObjectNo,"001");
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

<%@	include file="/IncludeEnd.jsp"%>
