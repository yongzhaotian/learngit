<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ��ѯ�����Ӧ����
		Input Param:
			CodeType���ֶ�����
			ItemNo : ѡ�е�ֵ
		Output Param:
		HistoryLog:   
			
	 */
	%>
<%/*~END~*/%> 

<%	
    String  sReturnValue = "";
	ASResultSet rs = null;
	//������� 
	
	//��ȡҳ�������
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sProductType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sProductType == null) sProductType = "";
	
		rs = Sqlca.getASResultSet("select itemname from code_library where codeno='AreaCode' and exists (select AreaCode from ProvidersCity where ProvidersCity.AreaCode=code_library.itemno and SerialNo='"+sSerialNo+"' and ProductType='"+sProductType+"')");
		while (rs.next()){
			sReturnValue+=","+rs.getString("itemname");
		}
		rs.getStatement().close();
	 ARE.getLog().debug("����"+sReturnValue);
		
	if(!"".equals(sReturnValue))
	 	sReturnValue = sReturnValue.substring(1);
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%@ include file="/IncludeEndAJAX.jsp"%>