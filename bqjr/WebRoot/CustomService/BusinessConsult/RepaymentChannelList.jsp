<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 	String sOperateType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
 	if(sOperateType == null) sOperateType = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RepaymentChannelListNew";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

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
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sSerialNo = getSerialNo("BaseDataSet_Info","SERIALNO");
		AsControl.PopView("/CustomService/BusinessConsult/RepaymentChannelInfoFrame.jsp","SerialNo="+sSerialNo,"dialogwidth=900px;dialogheight=600px;");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			//as_del("myiframe0");
			//as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			RunMethod("���÷���", "DelByWhereClause", "BaseDataSet_Info,SerialNo='"+sSerialNo+"'");
		}
		reloadSelf();
	}

	function viewAndEdit(){
		setSessionValue("repaymentChannelSerialNo","");//����ˮ���Ƴ���session
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.PopView("/CustomService/BusinessConsult/RepaymentChannelInfoFrame.jsp","SerialNo="+sSerialNo+"&OperateType=<%=sOperateType%>","dialogwidth=900px;dialogheight=600px;");
		reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			RunJavaMethodSqlca("", "", "");
			Run
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
