<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��Ʒ����";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ProductCategory";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.setColumnAttribute("ProductCategoryName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","��������¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�����¼","myDetail()",sResourcesPath},	
	        {"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}, 
			
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function mySelectRow(){
		var sProductCategoryID = getItemValue(0,getRow(),"ProductCategoryID");
		if(typeof(sProductCategoryID)=="undefined" || sProductCategoryID.length==0) {
			alert(getHtmlMessage(1));
		}else{
			AsControl.OpenView("/BusinessManage/Products/ProductCTypeList.jsp", "productCategoryID="+sProductCategoryID, "rightdown","");
		}
	}
	
	//������¼
	function newRecord(){
		var sProductCategoryID = getItemValue(0,getRow(),"ProductCategoryID");
		sCompID = "ProductCTypeInfo";
		sCompURL = "/BusinessManage/Products/ProductCategoryInfo.jsp";
	    popComp(sCompID,sCompURL,"productCategoryID= ","dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
    
	function myDetail(){
		var sProductCategoryID = getItemValue(0,getRow(),"ProductCategoryID");
		if(typeof(sProductCategoryID)=="undefined" || sProductCategoryID.length==0) {
			alert(getHtmlMessage(1));
		}else {
			AsControl.OpenView("/BusinessManage/Products/ProductCategoryInfo.jsp", "productCategoryID="+sProductCategoryID, "_self","");
		}
	}
	
	function deleteRecord(){
		var sProductCategoryID =getItemValue(0,getRow(),"ProductCategoryID");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sProductCategoryID)=="undefined" || sProductCategoryID.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			RunMethod("DeleteNumber","GetDeleteNumber1","Product_CType,productcategoryid='"+sProductCategoryID+"'");
			parent.reloadSelf();
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>