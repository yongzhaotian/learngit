<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "���㽻�׶����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	ASDataObject doTemp = new ASDataObject("TransactionConfigList", "",Sqlca);	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��һ����¼","delRecord()",sResourcesPath},
		{"true","","Button","����","��ϸ��Ϣ","myDetail()",sResourcesPath},
		{"true","","Button","��¼ģ��","��Ʒ�¼ģ�嶨��","viewTransEntry()",sResourcesPath,"btn_icon_detail"},
		{"true","","Button","���ײ����б�","���ײ����б�","viewDoNo()",sResourcesPath,"btn_icon_detail"},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	function newRecord(){
		AsControl.OpenView("/Accounting/Config/TransactionConfigInfo.jsp","","right","");
	}

	function viewDoNo(){
		//������δѡ���¼���Ե����ռ�¼�Ľ��档By ghshi 2013-07-30��
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ
			return;
		}
		
		var attribute1 = getItemValue(0,getRow(),"attribute1");
		if(typeof(attribute1) == "undefined" || attribute1=="")
			alert("û��������Ӧ����ʾģ�塣");
		else
			AsControl.OpenView("/Accounting/Config/TransactionParameterList.jsp","attribute1="+attribute1,"_blank","");
	}
	
	function myDetail(){
		var sitemno = getItemValue(0,getRow(),"ItemNo");
		var scodeno = getItemValue(0,getRow(),"CodeNo");
		if (typeof(sitemno) == "undefined" || sitemno.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.OpenView("/Accounting/Config/TransactionConfigInfo.jsp","ItemNo="+sitemno+"&CodeNo="+scodeno,"right","");
	}
	
	function viewTransEntry(){
		var sitemno = getItemValue(0,getRow(),"ItemNo");
		var status = getItemValue(0,getRow(),"Status");
		var attribute1 = getItemValue(0,getRow(),"attribute1");
		if (typeof(sitemno) == "undefined" || sitemno.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.OpenView("/Accounting/Config/TransEntryConfigList.jsp","ItemNo="+sitemno+"&attribute1="+attribute1,"_blank","");
	}
	
	
	function delRecord()
	{
		var sCodeno = getItemValue(0,getRow(),"CodeNo");
		var sItemNo=getItemValue(0,getRow(),"ItemNo");
		
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ
			return;
		}
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>