<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	if(sFlowNo==null) sFlowNo="";
	if(sPhaseNo==null) sPhaseNo="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailStoreTaskList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause = " where 1=1 and FLOW_TASK.ObjectType='RetailStoreApply'  and  FLOW_TASK.ObjectNo = RetailStoreApply.SerialNo and FLOW_Task.FlowNo='"+sFlowNo+"'  and FLOW_TASK.PhaseNo='"+sPhaseNo+"' and FLOW_TASK.UserID='"+CurUser.getUserID()+"'" +
		"  and (FLOW_TASK.EndTime is  null  or  FLOW_TASK.EndTime = '')  and (FLOW_TASK.TaskState is null or FLOW_TASK.TaskState='')";

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
		{"false","","Button","ȷ��","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","ȷ��","ȷ��","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","����","deleteRecord()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		/* var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		} */
		self.returnValue="";
		self.close();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		var sObjectNo = getItemValue(0, getRow(), "OBJECTNO");
		var sPhaseNo = getItemValue(0, getRow(), "PHASENO");
		var sObjectType = getItemValue(0, getRow(), "OBJECTTYPE");
		//alert(sSerialNo+"|"+sObjectNo+"|"+sPhaseNo+"|"+sObjectType);
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		self.returnValue=sSerialNo+"@"+sObjectNo+"@"+sPhaseNo+"@"+sObjectType;
		self.close(); 
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
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
