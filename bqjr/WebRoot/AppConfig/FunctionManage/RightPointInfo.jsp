<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//��ò���	
	String sFunctionID =  CurPage.getParameter("FunctionID");
	String sSerialNo =  CurPage.getParameter("SerialNo");
	if(sFunctionID==null) sFunctionID="";
	if(sSerialNo==null) sSerialNo="";

	ASObjectModel doTemp = new ASObjectModel("RightPointInfo");
	doTemp.setDefaultValue("FunctionID",sFunctionID);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
		{"true","","Button","����","","saveRecord()","","","",""},
		{"true","","Button","���ÿɼ���ɫ","","selectRoles()","","","",""},
	};
	
	String sOtherHtml="<table style='margin-bottom:2px;margin-left:2px;margin-right:2px;margin-top:2px;width:95%;height:30px;border:1px solid #9fc0e3;'>" 
		+"<tr><td><b>��Դ·����ʽΪ����ӦJSPȫ·������/Ϊ�ָ�����+��_��+��ť����<b></td></tr>"
		+"</table>";
%><%out.print(sOtherHtml);%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("Ȩ�޵�����");
	function saveRecord(){
		as_save("myiframe0","afterOpen();"); //ˢ��treeʹ��
	}
	
	function afterOpen(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp","DefaultNode="+sSerialNo,"frameleft","");
	}
	
	/*~[Describe=ѡ��ɼ���ɫ;]~*/
	function selectRoles(){
	    var sRightPointName=getItemValue(0,getRow(),"RightPointName");
	    var sURL=getItemValue(0,getRow(),"URL");
	    if(typeof(sURL)=="undefined" || sURL.length == 0){
	    	alert("�뽫��Դ·����д������");
	    	return;
	    }
       AsControl.PopView("/AppConfig/FunctionManage/SelectRightRoleTree.jsp", "RightPointURL="+sURL+"&RightPointName="+sRightPointName, "dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>