<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �ڵ���Ϣ�б�ҳ��
		author: yzheng
		date: 2013/05/22
	 */
	String PG_TITLE = "�ڵ���Ϣ�б�ҳ��";
	//���ҳ�����

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PRDNodeManageList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/SynthesisManage/PRDNodeManageInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sNodeID = getItemValue(0,getRow(),"NodeID");
		var result = "";
		var sPara = "NodeIDArr=" + sNodeID;
		
		result =  RunJavaMethodSqlca("com.amarsoft.app.als.product.CVNodeDBManipulateController","check4Delete",sPara);
		
		if(result != "NOT EXISTS"){
			var prdName = result.split("@").join("|");
			var msg = "�޷�ɾ��. ��Ʒ (" + prdName.substring(0,prdName.length-1) + ") �������ýڵ�.";
			alert(msg);
			
			return;
		}
		
		if (typeof(sNodeID)=="undefined" || sNodeID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sNodeID=getItemValue(0,getRow(),"NodeID");
		if (typeof(sNodeID)=="undefined" || sNodeID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/SynthesisManage/PRDNodeManageInfo.jsp","NodeID="+sNodeID,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
