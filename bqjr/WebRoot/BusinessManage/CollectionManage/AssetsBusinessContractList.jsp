<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ����ѡ�б�ҳ��--
	 */
	 
	String sProjectSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectSerialNo"));//��Ŀ���
	if(sProjectSerialNo==null) sProjectSerialNo="";
	out.println("��Ŀ���:"+sProjectSerialNo);

	
	String PG_TITLE = "ʾ����ѡ�б�ҳ��";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AssetsBusinessContractList";
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
		{"true","","Button","ȷ��","��ø�����","getAndReturnSelected()","","","",""},
		//{"true","","Button","��ù�ѡ����","��ù�ѡ����","getChecked()","","","",""},
		//{"true","","Button","ɾ����ѡ","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~~������Ŀ���º�ͬ���~~*/
	function getAndReturnSelected(){
		var sContractSerialNo = getItemValueArray(0,"SERIALNO");
		if(sContractSerialNo.length<1){
			if(!confirm("ȷ����ѡ���ͬ���رոú�ͬ�б������")){
				return;
			}
		}
		
		if(sContractSerialNo.length>1){
			alert("һ��ֻ��ѡ��һ����ͬ!");
			return;
		}
		self.returnValue=sContractSerialNo;
		self.close();
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