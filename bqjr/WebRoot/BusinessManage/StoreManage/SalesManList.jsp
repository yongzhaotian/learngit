<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	if(sSNo == null) sSNo = "";
	
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreSalesmanList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    doTemp.WhereClause+=" and SType is null";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(30);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  ����  ����  �ر�  ��ʱ�ر�  ȡ���ر�
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�����","�����","deleteRecord()",sResourcesPath},
	};
	
	//add CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
	//add CCS-1283 �ر����۾����ŵ�ӽ�����۴����Ȩ��
	if(CurUser.hasRole("1005")){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
	//PRM-831 ���۾���������Ա�Ӱ���ȡ�� add by zty 20160411
	if(CurUser.hasRole("1005") || CurUser.hasRole("1004") || CurUser.hasRole("1008")){
		sButtons[1][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	
	function newRecord(){
		
		AsControl.OpenView("/BusinessManage/StoreManage/SalesmanInfo.jsp","SNo=<%=sSNo %>","_self","");
	}
	
	/**
	 * �Ӵ��� --update CCS-884:�ŵ��Ż� tangyb 20150720 start--
	 */
	function deleteRecord(){
		//var sSalesManager = getItemValue(0, getRow(), "SALEMANAGERNO"); //���۾���
		var sno = getItemValue(0, 0, "SNO"); // �ŵ����
		var sSalesman = getItemValue(0, getRow(), "SALESMANNO"); //������Ա
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO"); //�ŵ����
		
		var userid = "<%=CurUser.getUserID()%>"; //��¼�û�
		var orgid = "<%=CurOrg.orgID%>"; //�������
		var stime = getTime(); //��ȡ��ǰʱ��

		//alert("sno="+sno+",userid="+userid+",orgid="+orgid);
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("����������󶨸���Ϣ��")){
			//as_del("myiframe0");
			//as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			//var sParam = "type=02,sNo="+sno+",salesmanNos="+sSalesman+",salesManager="+sSalesManager+",userid="+userid+",orgid="+orgid;
			//alert(sParam);
			//RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","insertHistory",sParam);
			
			//��ѯ������Ա���ŵ꾭�������ŵ��Ƿ񻹴��ڹ�ϵ (0:��,1:��)
			var isThere = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreInfo", "querySalesManagerRelation", "sno="+sno+",salesmanno="+sSalesman);
			if(isThere == "0"){
				// ���������Ա���ŵ꾭���ϵ
				RunMethod("���÷���", "UpdateColValue", "User_Info,SuperId,,UserId='"+sSalesman+"' and IsCar='02' and Status='1'");
			} 
			
			var successType = RunMethod("PublicMethod","UpdateColValue","String@updateorg@"+orgid+"@String@updateuser@"+userid+"@String@updatedate@"+stime+"@String@stype@02,storerelativesalesman,String@serialno@"+sSerialNo);
			if(successType == "TRUE"){
				alert("�ύ�ɹ�");
			}
			
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/StoreManage/SalesmanInfo.jsp","SerialNo="+sSerialNo+"&ActionType=Detail&VIWEFLAG=2&Status=<%=sStatus %>","_self","");
		
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	//��ȡ��ǰ����(yyyy/MM/dd HH:mm:ss) 20150720 tangyb add
	function getTime(){
		var date = new Date(); //��ǰ����
		var myyear = date.getFullYear(); //��
		var mymonth = date.getMonth() + 1; //��
		var myweekday = date.getDate(); //��
		if (mymonth < 10) {
			mymonth = "0" + mymonth;
		}
		if (myweekday < 10) {
			myweekday = "0" + myweekday;
		}
		//ȡʱ�� 
		var hh = date.getHours(); //��ȡСʱ����8 
		var mm = date.getMinutes(); //��ȡ���ӣ���34 
		var ss = date.getTime() % 60000; //��ȡʱ�䣬��Ϊϵͳ��ʱ�����Ժ������ģ� ������Ҫͨ����60000�õ���
		ss = (ss - (ss % 1000)) / 1000; //Ȼ�󣬽��õ��ĺ������ٴ������ 
		return (myyear + "/" + mymonth + "/" + myweekday + " " + hh + ":" + mm + ":" + ss);
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>