<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ����ѡ�б�ҳ��
	 */
	String PG_TITLE = "ʾ����ѡ�б�ҳ��";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleList";
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","","_self","");
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
			var sReturn = AsControl.RunJavaMethodSqlca("demo.Example4RJM","deleteExampleByIds","ExampleId="+idstring);
			if(sReturn=="SUCCESS"){
				alert("ɾ���ɹ�!");
				reloadSelf();
			}	
		}
	}

	function viewAndEdit(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId+"&flag=02","_self","");
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>