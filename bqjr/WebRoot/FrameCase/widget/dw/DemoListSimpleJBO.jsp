<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.are.jbo.JBOFactory" %><%@
 page import="com.amarsoft.are.jbo.BizObjectManager" %>
<%
	//��ȡjbo��list
	BizObjectManager bomOne = JBOFactory.getFactory().getManager("jbo.ui.test.TEST_CUSTOMER_INFO");
	ASObjectModel doTemp = new ASObjectModel(bomOne);
	doTemp.setVisible("*",false); //ȱʡ��ʾȫ�����ԣ���������ȫ������ʾ��
	doTemp.setVisible("SERIALNO,CUSTOMERNAME,TELEPHONE",true);   //������ʾ��
	doTemp.setColumnFilter("CUSTOMERNAME",true);
	//doTemp.setDDDWCode("ISINUSE","YesNo"); 
	doTemp.setJboWhere("1=1");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(10);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
