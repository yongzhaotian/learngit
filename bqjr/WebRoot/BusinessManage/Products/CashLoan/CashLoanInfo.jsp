<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	<%
	String PG_TITLE = "�����ֽ���ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����	��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//����
	if(sSerialNo==null) sSerialNo="";
	String sEventStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EventStatus"));//�״̬
	if(sEventStatus==null) sEventStatus="";

	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("CashLoanInfo",Sqlca);//���׶�������ģ��
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","����","SaveRecord()",sResourcesPath},
		{"true","","Button","����","����","goBack()",sResourcesPath},
	};
	//δ��ʼ�Ļ
	if("01".equals(sEventStatus))
	{
		sButtons[0][0] = "true";
	}
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>

	// ���ؽ����б�
	function goBack()
	{
		self.close();
	}
	
	function SaveRecord(){
		var sdate = getItemValue(0,getRow(),"BEGINDATE"); //��ʼ����
		var edate = getItemValue(0,getRow(),"ENDDATE"); //��������
		if (sdate != '' && edate != '') {
			sdate = sdate.split('/'); //�õ���ʱ��ؼ���ʽ��yyyy/MM/dd
			edate = edate.split('/');
			//��Ϊ��ǰʱ����·���Ҫ+1�����ڴ�-1����Ȼ�͵�ǰʱ�����Ƚϻ��жϴ���
			var start = new Date(sdate[0], sdate[1] - 1, sdate[2]); 
			var end = new Date(edate[0], edate[1] - 1, edate[2]);
			var date = new Date();//��ǰʱ��
			if (end <= date) {
				alert("�������ڱ�����ڵ�ǰ����");
				return;
			}
			if (start >= end) {
				alert("�������ڱ�����ڿ�ʼ���� ");
				return;
			}
		}
		
		as_save("myiframe0");
	}

	function initPage(){
		AsControl.OpenView("/BusinessManage/Products/CashLoan/CashLoanImportList.jsp","SerialNo=<%=sSerialNo%>&EventStatus=<%=sEventStatus%>","rightdown","");
	}
	
</script>	

<script language=javascript>
$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initPage();
});
</script>	

<%@ include file="/IncludeEnd.jsp"%>
