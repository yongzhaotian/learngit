<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: pli2 2015-4-3
		Tester:
		Describe: �����˹������м�¼�б�
		
		Input Param:
		SerialNo:��ˮ��
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����˵��Ӻ�ͬģ�� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����,�����˱��
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sSerialNo == null) sSerialNo = "";
	System.out.println(sSerialNo+"---");
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "LoanManEDocList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;	
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(100);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�����������ݣ�2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"false","","Button","����","����µĵ��Ӻ�ͬģ��","newRecord()",sResourcesPath},
		{"false","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�е�ģ��","deleteRecord()",sResourcesPath},
		{"false","","Button","ͣ��","ͣ�����е��Ӻ�ͬģ��","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/LoanManEDocInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSpSerialNoArr = getItemValueArray(0,"SpSerialNo");
		var sBusinessTypeArr = getItemValueArray(0,"BusinessType");
		var sSpSerialNo = sSpSerialNoArr[0];
		var sBusinessType = sBusinessTypeArr[0];
		var params = "";
		if (typeof(sSpSerialNo)=="undefined" || sSpSerialNo.length==0 || typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(confirm("�������ɾ������Ϣ��")){
			var strList = "";
			for(var i = 0; i < sSpSerialNoArr.length; i++){
				strList = strList + sSpSerialNoArr[i] + "@@" + sBusinessTypeArr[i] + "|";
			}
			if (strList != null && strList != "") {
				strList = strList.substring(0, strList.length - 1);
			}
			params = "paramList=" + strList;
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.DelectLoanCity",
					"deletePrint", params);				
		}
		if (result.split("@")[0] != "true") {
			alert(result.split("@")[1]);
			return;
		} else {
			alert("ɾ���ɹ���");
			reloadSelf();
			return;
		}
	}
	
	function viewAndEdit(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

