<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//��ò���	
	String sFunctionID =  CurPage.getParameter("FunctionID");
	String sModuleID =  CurPage.getParameter("ModuleID");
	String sModuleName =  CurPage.getParameter("ModuleName");
	if(sModuleID==null) sModuleID="";
	if(sModuleName==null) sModuleName="";
	if(sFunctionID==null) sFunctionID="";

	ASObjectModel doTemp = new ASObjectModel("FunctionInfo");
	
   	//�����Ϊ����ҳ�棬�������ID�����޸�
	if(sFunctionID.length() != 0 ){
		doTemp.setReadOnly("FunctionID,ModuleID,ModuleName",true);
	}
   	doTemp.setDefaultValue("ModuleID",sModuleID);
   	doTemp.setDefaultValue("ModuleName",sModuleName);
   	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sFunctionID);

	String sButtons[][] = {
		{"true","","Button","����","","saveRecord()","","","",""},
		{"true","","Button","���ÿɼ���ɫ","","selectFunctionRoles()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","afterOpen();"); //ˢ��treeʹ��
	}
	
	function afterOpen(){
		var sFunctionID=getItemValue(0,getRow(),"FunctionID");
		AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp","DefaultNode="+sFunctionID,"frameleft","");
	}
	
	/*~[Describe=ѡ��ɼ���ɫ;InputParam=��;OutPutParam=��;]~*/
	function selectFunctionRoles(){
	    var sFunctionName=getItemValue(0,getRow(),"FunctionName");
	    AsControl.PopView("/AppConfig/FunctionManage/SelectFuncRoleTree.jsp","FunctionID=<%=sFunctionID%>&FunctionName="+sFunctionName,"dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>