<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CancelOffList";//ģ�ͱ��
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
		{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">	

	function viewAndEdit(){
		var sSerialnos = getItemValueArray(0,"LoanSerialno");//��ȡѡ�еĶ�����¼ID			
		if (typeof(sSerialnos)=="undefined" || sSerialnos.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		//��ȡ��ݺ�
		var idstring = sSerialnos.toString();
		var re =/,/g; 
		idstring = idstring.replace(re,"@");
		var str=new Array();
		str=idstring.split("@");
		
		var Loan="";
		var TransactionLoan="";
		var j=0;
		var transactionCode ="0080";
		var relativeObjectType = "jbo.app.ACCT_LOAN";
		var relativeObjectNo = "";
		var transactionDate="";
		var objectType="TransactionApply";
		var returnValue ="";
		var transactionSerialNo="";
		if(confirm("��������������Ϣ��")){
			for(i=0;i<str.length;i++){
				LoanSerialno=str[i];
				relativeObjectNo = LoanSerialno;
				
				returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
				if(returnValue.substring(0,5) != "true@") {
					alert("���"+LoanSerialno+"����ʧ�ܣ�����ԭ��-"+returnValue);
					continue;
				}
				
				returnValue = returnValue.split("@");
				transactionSerialNo = returnValue[1];
				if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
					alert("���"+LoanSerialno+"����ʧ�ܣ�����ԭ��-"+returnValue);
					continue;
				}
				if(j==0){
					Loan += LoanSerialno;
					TransactionLoan += transactionSerialNo;		
				}else{
					Loan += "@"+LoanSerialno;
					TransactionLoan += "@"+transactionSerialNo;
				}
				j++;
			
			}
			
			var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CancelOffList","updateLoanInfo","Loan="+Loan+",TransactionLoan="+TransactionLoan);
			if(sReturn=="SUCCESS"){
				alert("�����ɹ�!");
				reloadSelf();
			}	
		} 
	}
	


	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>