<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 %>
<%/*~END~*/%>
	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	String sHeaders[][] = { 							
		{"itemNo","��������"},
		{"itemName","������������"},
		{"bankNo","���Ŵ���"},
		{"sortNo","�����"},
		{"isInUse","�Ƿ�ʹ��"},
		{"inputUser","¼����"},
		{"inputTime","¼��ʱ��"},
		{"updateUser","������"},
		{"updateTime","����ʱ��"},
		{"remark","��ע"}
			
	};
	
	String sSql = " select t.itemno as itemNo,t.itemname as itemName, "
			    + " t.sortno as sortNo,(case  when  t.isinuse=1 then '��' else '��' end) as isInUse, "
			    + " t.inputuser as inputUser,t.inputtime as inputTime,t.updateuser as updateUser, "
			    + " t.updatetime as updateTime, t.remark as remark "
				+ " from code_library t where t.codeno = 'ErrorType' order by t.sortno asc ";
	
	ASDataObject doTemp = null;
	doTemp = new ASDataObject(sSql);//����ģ�ͣ�2013-5-9
	doTemp.setHeader(sHeaders);	
	//doTemp.setKey("itemNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�����������ݣ�2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","���ػ���","��Ʒ���������ϵͳ����������","reloadCacheRole()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/ErrorTypeInfo.jsp","","_self","");
	}

	function viewAndEdit(){
		var sItemNo = getItemValue(0,getRow(),"itemNo");
		if (typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/ErrorTypeInfo.jsp","itemNo="+sItemNo,"_self","");
	}
	
	<%/*~[Describe=ˢ�»���;]~*/%>
	function reloadCacheRole(){
		//AsDebug.reloadCacheAll();
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("���ز�������ɹ���");
		else alert("���ز�������ʧ�ܣ�");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
