<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "��Ʒ����";

	// ���ҳ�����
	String sProductCategoryID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("productCategoryID"));
	if(sProductCategoryID==null) sProductCategoryID = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ProductCType";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause += " and IsinUse='1' ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProductCategoryID);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","��������¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�����¼","myDetail()",sResourcesPath},	
	        {"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}, 		
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/Products/ProductCTypeInfo.jsp","productCategoryID=<%=sProductCategoryID %>","_self");
	}
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function deleteRecord(){
		var sProductCTypeID = getItemValue(0,getRow(),"ProductCTypeID");	//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sProductCTypeID)=="undefined" || sProductCTypeID.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}
	
	function myDetail(){
		var sProductCTypeID = getItemValue(0,getRow(),"ProductCTypeID");
		//AsControl.OpenView("/BusinessManage/Products/ProductCTypeInfo.jsp","productCTypeID="+sProductCTypeID,"_self");
		OpenPage("/BusinessManage/Products/ProductCTypeInfo.jsp?productCTypeID="+sProductCTypeID,"_self","");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
