<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ���׶���ѡ���б����--
	 */
	String PG_TITLE = "���׶���ѡ���б����";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("AssetTransferList",Sqlca);
	//doTemp.multiSelectionEnabled=true;//���ÿɶ�ѡ
	//��ѯ����
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
		//{"true","","Button","��ø�����","��ø�����","alert(	getRow(0))","","","",""},
		{"true","","Button","ȷ��","ȷ��","getAndReturnChecked()","","","",""},
		//{"true","","Button","ɾ����ѡ","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function getAndReturnChecked(){
		 var arr0 = getItemValue(0,getRow(),"SERIALNO");
		 var arr1 = getItemValue(0,getRow(),"SERVICEPROVIDERSNAME");
		 if(typeof(arr0)=="undefined"||arr0==""){
			 alert("��ѡ��һ������");
			 return;
		 }
		 var sRec = arr0+"@"+arr1;
		 self.returnValue=sRec;
		 self.close();
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