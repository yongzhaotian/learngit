<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: DWģ���б�ҳ��
		author: yzheng
		date: 2013-6-6
	 */
	String PG_TITLE = "DWģ���б�ҳ��";
	//���ҳ�����
	String doNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DoNo"));
	String readOnly =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReadOnly"));
	String codeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	
	if(codeNo==null) codeNo="";
	if(readOnly==null) readOnly="";   //0: ֻ������ģʽ
	if(doNo==null) doNo="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "DWTemplateList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(!doNo.equals("")){
		doTemp.WhereClause += " and TemplateNo = '" + doNo + "' ";  //������ָ��ģ��
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{readOnly.equals("0") ? "false" : "true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{readOnly.equals("0") ? "false" : "true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{readOnly.equals("0") ? "false" : "true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{readOnly.equals("0") ? "true" : "false","","Button","����","����","goBack()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTemplateInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var templateNo = getItemValue(0,getRow(),"TemplateNo");
		
		if (typeof(templateNo)=="undefined" || templateNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var templateNo=getItemValue(0,getRow(),"TemplateNo");
		
		if (typeof(templateNo)=="undefined" || templateNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTemplateInfo.jsp","TemplateNo="+templateNo,"_self","");
	}

	function goBack(){
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeUsageDetailList.jsp","CodeNo=<%=codeNo%>","_self");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
