<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ���ֶ��б�ҳ��
		author:yzheng
		date:2013-6-8
	 */
	String PG_TITLE = "���ֶ��б�ҳ��";
	//���ҳ�����
	String tableNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableNo"));
	String colName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColName"));
	String readOnly =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReadOnly"));
	String codeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	
	if(codeNo==null) codeNo="";
	if(readOnly==null) readOnly="";   //0: ֻ������ģʽ
	if(colName==null) colName="";
	if(tableNo==null) tableNo="";
	//��������
	String viewType = "";  // 1:�ɱ��ѯ�ֶ�   2: ֱ�Ӳ�ѯ�ֶ�
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "TableColList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(!tableNo.equals("")){  //�ɱ��ѯ�ֶ�
		doTemp.WhereClause += "where TABLECOL_INFO.TableNo='" + tableNo + "' and DWTEMPLATE_INFO.TemplateNo=TABLECOL_INFO.UsageInfo";
		viewType = "1";
	}
	else{  //ֱ�Ӳ�ѯ�ֶ�
		doTemp.WhereClause += "where DWTEMPLATE_INFO.TemplateNo=TABLECOL_INFO.UsageInfo";
		if(!colName.equals("")){
			doTemp.WhereClause += " and TABLECOL_INFO.ColName = '" + colName + "' ";
		}
		viewType = "2";
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(tableNo);
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
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColInfo.jsp","TableNo=<%=tableNo%>","_self","");
	}
	
	function deleteRecord(){
		var tableNo = getItemValue(0,getRow(),"TableNo");
		if (typeof(tableNo)=="undefined" || tableNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var tableNo=getItemValue(0,getRow(),"TableNo");
		var colName=getItemValue(0,getRow(),"ColName");
		if (typeof(tableNo)=="undefined" || tableNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColInfo.jsp","TableNo="+tableNo + "&ColName=" + colName + "&ViewType=<%=viewType%>","_self","");
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
