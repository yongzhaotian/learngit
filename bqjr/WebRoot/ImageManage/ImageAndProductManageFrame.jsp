<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
 
	String PG_TITLE = "��Ʒ�����б�";
	//���ҳ�����
	String productTypeId = CurComp.getParameter("productTypeId");
    System.out.println("sProductTypeId==="+productTypeId);

	if (productTypeId == null) productTypeId = "";
 	
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	//myleft.width=10;
		
		AsControl.OpenView("/ImageManage/ProductListByProductType.jsp","productTypeId=<%=productTypeId%>", "rightup","");
		AsControl.OpenView("/ImageManage/ImageListByProductType.jsp", "productTypeId=<%=productTypeId%>", "rightdown","");
		
		function maintainProduct(){
			var sProductTypeId = getItemValue(0,getRow(),"PRODUCT_TYPE_ID");
			PopPage("/ImageManage/AddProduct.jsp?ProductTypeId="+<%=productTypeId%>,"","dialogWidth=550px;dialogHeight=350px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		}
		
		function maintainImage(){
			var sProductTypeId = getItemValue(0,getRow(),"PRODUCT_TYPE_ID");
			PopPage("/ImageManage/AddImageFile.jsp?ProductTypeId="+<%=productTypeId%>,"","dialogWidth=550px;dialogHeight=350px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		}


</script>
<%@ include file="/IncludeEnd.jsp"%>
