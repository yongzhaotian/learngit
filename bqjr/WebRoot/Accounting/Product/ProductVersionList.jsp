<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "��Ʒ�汾��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
%>

<%
	//���ҳ�����,��Ʒ���
	String ProductID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeNo"));
	if(ProductID == null) ProductID = "";
%>

<%

	//����DW����
	String sTempletNo = "ProductVersionList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	//���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(10);
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(ProductID);
	for(int i=0;i<vTemp.size();i++)out.print((String)vTemp.get(i));

%>


<%
	String sButtons[][] = {
			{"true","","Button","�����汾","�����汾","newRecord()",sResourcesPath},
			{"true","","Button","���������ư汾","�����汾��Ϣ","copyRecord()",sResourcesPath},
			{"true","","Button","�汾����","�鿴ĳ���汾������Ϣ","viewAndEdit()",sResourcesPath},//�鿴�汾��Ϣʱ��������ʾ�����汾��Ϣ
			{"true","","Button","ɾ���汾","ɾ��δ��Ч�Ĳ�Ʒ�汾","deleteRecord()",sResourcesPath},
			{"true","","Button","�汾����","�汾����","changeVersionStatus(1)",sResourcesPath},
			{"true","","Button","�汾ͣ��","ͣ������Ч�Ĳ�Ʒ�汾","changeVersionStatus(2)",sResourcesPath},
	};
%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	//�����汾
	function newRecord(){
		var userID = "<%=CurUser.getUserID()%>";
		var newVersionID = AsControl.PopView("/Accounting/Product/CopyVersionDialog.jsp","","resizable=yes;dialogWidth=20;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(newVersionID) != "undefined" && newVersionID.length != 0 && newVersionID != '_CANCEL_'){
			var sReturn = RunMethod("ProductManage","CreateProductVersion",<%=ProductID%>+","+newVersionID+","+userID);
        	if(sReturn=="true") {
        		AsControl.OpenView("/Accounting/Product/ProductFunctionDef.jsp","ProductID=<%=ProductID%>"+"&VersionID="+newVersionID,"_blank",OpenStyle);
            	reloadSelf();
        	}else
            	alert("�����汾ʧ�ܣ�");
        	return;
		}
	}
	function copyRecord()
	{
		var userID = "<%=CurUser.getUserID()%>";
		var ProductID = getItemValue(0,getRow(),"ProductID");
		var versionID = getItemValue(0,getRow(),"VersionID");//--��ȡ�汾���
		//���������ư汾
		if(typeof(versionID)=="undefined" || versionID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}else{//���������ư汾
			var newVersionID = AsControl.PopView("/Accounting/Product/CopyVersionDialog.jsp","","resizable=yes;dialogWidth=20;dialogHeight=10;center:yes;status:no;statusbar:no");
			if(typeof(newVersionID) != "undefined" && newVersionID.length != 0 && newVersionID != '_CANCEL_'){
				var sReturn = RunMethod("ProductManage","CopyProductVersion",ProductID+","+versionID+","+newVersionID+","+userID);
	        	if(sReturn=="true") {
	        		AsControl.OpenView("/Accounting/Product/ProductFunctionDef.jsp","ProductID="+ProductID+"&VersionID="+newVersionID,"_blank",OpenStyle);
	            	reloadSelf();
	        	}
			}
		}		
	}

	function viewAndEdit()
	{
		var ProductID = getItemValue(0,getRow(),"ProductID");//--��ȡ��Ʒ���
		var versionID = getItemValue(0,getRow(),"VersionID");//--��ȡ�汾���
	    if(typeof(ProductID)=="undefined" || ProductID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    AsControl.OpenView("/Accounting/Product/ProductFunctionDef.jsp","ProductID="+ProductID+"&VersionID="+versionID,"_blank",OpenStyle);
        reloadSelf();
	}

	function changeVersionStatus(status)
	{	
		var productID = getItemValue(0,getRow(),"ProductID");//--��ȡ��Ʒ���
		var versionID = getItemValue(0,getRow(),"VersionID");//--��ȡ�汾���
		var isNew = getItemValue(0,getRow(),"IsNew");
	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		if(isNew==status){
			alert("�Ѿ��Ǹ�״̬��");
			return;
			}
		var sReturn = RunMethod("ProductManage","StartNewVersion",productID+","+versionID+","+status);//ִ�и��£����ظ��½��
		if(sReturn=="true"){
			alert("�汾���³ɹ���");
			reloadSelf();
		}else{
			alert("�汾����ʧ�ܣ�");
			reloadSelf();
		}
	}
	
	function deleteRecord()
	{
		VersionID = getItemValue(0,getRow(),"VersionID");
		ProductID   = getItemValue(0,getRow(),"ProductID");
		if (typeof(VersionID)=="undefined" || VersionID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(confirm("�������ɾ������Ϣ��")){
			sReturn = RunMethod("ProductManage","DeleteVersionInfo",ProductID+","+VersionID);
			if(sReturn=="true"){
	    		alert("�汾��Ϣɾ���ɹ�!");
			}else{
				alert("�汾��Ϣɾ��ʧ��!");
			}
   		}
   		reloadSelf();
	}
	
</script>
	
	<script language=javascript>	
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	</script>	


<%@ include file="/IncludeEnd.jsp"%>
