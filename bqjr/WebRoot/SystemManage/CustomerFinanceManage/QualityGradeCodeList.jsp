<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   phe  2015/03/17
		Tester:
		Content: ҵ�������Ϣ   CCS-213 PRM-26 ������ע �����ļ�����
	 */
	%>
<%/*~END~*/%>
 <%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�����ȼ�ά��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "QualityGradeCodeList";//ģ�ͱ��
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
		{"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","���ػ���","��Ʒ���������ϵͳ����������","reloadCacheRole()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/QualityGradeCodeInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CODENO");
		var sItemNo = getItemValue(0,getRow(),"ITEMNO");
		if (typeof(sCodeNo)=="undefined" || sCodeNo.length==0||typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}
	
	<%/*~[Describe=ˢ�»���;]~*/%>
	function reloadCacheRole(){
		//AsDebug.reloadCacheAll();
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("���ز�������ɹ���");
		else alert("���ز�������ʧ�ܣ�");
	}
	
	function viewAndEdit(){
		var sCodeNo = getItemValue(0,getRow(),"CODENO");
		var sItemNo = getItemValue(0,getRow(),"ITEMNO");
		if (typeof(sCodeNo)=="undefined" || sCodeNo.length==0||typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/QualityGradeCodeInfo.jsp","CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"_self","");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
