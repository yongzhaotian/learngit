<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/%>
<%
/* 
  author:  zywei 2006/08/09 
  Tester:
  Content:  ���ſͻ�����
  Input Param:
			CustomerID���ͻ����
  Output param:
 
  History Log:     

               
 */
 %>
<%/*~END~*/%>

<%     
	
    //�������
    String sReturnValue = "";
    
    //����������
    
    //���ҳ���������Ŀ��š������š�
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
   	if(sCustomerID == null) sCustomerID = "";
   	
   	try
   	{
   		GroupSearch	groupSearch = new GroupSearch(sCustomerID,Sqlca);
		groupSearch.getSearchResult(Sqlca);
   		sReturnValue = "True";
   	}catch(Exception e)
   	{
   		sReturnValue = "False";
   		ARE.getLog().info("---------GroupMemberSearch-----------"+e.toString());
   	}
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
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>