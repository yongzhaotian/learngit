<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	String sUserID=CurUser.getUserID();
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ContractSignature";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause += " and SignatureFlag='2' ";
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�鿴���Ӻ�ͬ","�鿴���Ӻ�ͬ","viewAndEdit()",sResourcesPath},
		{"true","","Button","����ǩ��","����ǩ��","SignatureFlagChange()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=���µ���ǩ�±�ʾ;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/20~*/%>
	function SignatureFlagChange(){
		var sSerialno=getItemValue(0,getRow(),"serialno");
		if (typeof(sSerialno)=="undefined" || sSerialnos.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var sReturn=RunMethod("BusinessManage","UpdateSignatureFlag",sSerialno);
		if(parseInt(sReturn) == 1)
		{
			alert("�ύ�ɹ���");
			reloadSelf();
		}
	}


	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>