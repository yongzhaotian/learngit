<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ����ѡ�б�ҳ��--
	 */
	String PG_TITLE = "ʾ����ѡ�б�ҳ��";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ProductTypes";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//���ÿɶ�ѡ
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"false","","Button","��ø�����","��ø�����","alert(	getRow(0))","","","",""},
		{"false","","Button","��ù�ѡ����","��ù�ѡ����","getChecked()","","","",""},
		{"false","","Button","ɾ����ѡ","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function test(){
		var sReturnValue = "";
		try{
			var b = getRowCount(0);
			sReturnValue = "";
			for(var iMSR = 0 ; iMSR < b ; iMSR++){
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");				
				if(a == "��"){
					sReturnValue = sReturnValue+getItemValue(0,iMSR,"productID")+"@";
				}
			}
		}catch(e){
			return;
		}
		//alert(sReturnValue);
		return sReturnValue;
	}

	function getChecked(){
		 var arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else{
			 alert(arr);
		 }
	}
	
	function deleteRecord(){
		var sExampleIds = getItemValueArray(0,"ExampleId");//��ȡѡ�еĶ�����¼ID			
		if (typeof(sExampleIds)=="undefined" || sExampleIds.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		var idstring = sExampleIds.toString();
		var re =/,/g; 
		idstring = idstring.replace(re,"@");	
		if(confirm("�������ɾ������Ϣ��")){
			var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.awe.framecase.Example4RJM","deleteExampleByIds","ExampleId="+idstring);
			if(sReturn=="SUCCESS"){
				alert("ɾ���ɹ�!");
				reloadSelf();
			}	
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>