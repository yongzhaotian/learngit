<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<!-- 
��ҳ��ͨ��parentno��ʽʵ�������
1 dataobject_catalog[������ҳ��������sql]����Ҫ����order by 
2 dataobject_library�б�������TREE_DEPTH�����ԣ���Ϊ���
3 ASObjectModel��Ҫ����Ϊ���ɷ�ҳ:doTemp.setPageSize(-1);//����Ϊ���ɷ�ҳ
4 ASObjectWindow��Ҫ����ΪTreeTable:dwTemp.TreeTable = true;
 -->
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfoForTree");
	//doTemp.setJboOrder("coalesce(PARENTNO,'')||SerialNO");//��������ʽ
	doTemp.setJboOrder("PARENTNO");//��������ʽ
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(-1);//����Ϊ���ɷ�ҳ
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.TreeTable = true;//����Ϊ���νṹ
	dwTemp.ReadOnly = "1";
	dwTemp.genHTMLObjectWindow("");
	

	String sButtons[][] = {
		
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
