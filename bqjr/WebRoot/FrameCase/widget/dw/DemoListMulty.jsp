<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <script>
 function setHilightRows(){
	 var iRows = prompt("����ѡ���У�����ö��ŷָ�",getSelRows(0));
	 selectRows(0,iRows);
 }
 function getChecked(){
	 var arr = getCheckedRows(0);
	 if(arr.length < 1){
		 alert("��û�й�ѡ�κ��У�");
	 }else{
		 alert(arr);
	 }
 }
 </script>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
doTemp.setLockCount(2);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.MultiSelect = true;//�����ѡ
	dwTemp.ReadOnly = "1";//�༭ģʽ
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","���Զ�ѡ��ֵ[ע���̨��ӡ��Ϣ]","���Զ�ѡ��ֵ","as_doAction(0,undefined,'test')","","","",""},
		{"true","","Button","����ѡ�е���","����ѡ�е���","setHilightRows()","","","",""},
		{"true","","Button","��ø�����","��ø�����","alert(	getRow(0))","","","",""},
		{"true","","Button","���ѡ�е���","���ѡ����","alert(getSelRows(0))","","","",""},
		{"true","","Button","��ù�ѡ����","��ù�ѡ����","getChecked()","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
