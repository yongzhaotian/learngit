<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "�ʲ�ת��Э���б�ҳ��";
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ʲ�ת��ɸѡ&nbsp;&nbsp;";
 %>
 <% 
	//�״�ת�û���ת���жϱ�ʶ
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	String sTempleteNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TempleteNo"));
	if(sTempleteNo==null) sTempleteNo="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempleteNo,Sqlca);
	
	doTemp.WhereClause+=" and T.applyType='"+sApplyType+"'";
	
	if("0010".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='01'";
	}
	if("0020".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='02'";
	}
	
	if("0030".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='03'";
	}
	
	if("0040".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='04'";
	}
	
	if("0050".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='05'";
	}
	
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
		{"true","","Button","�����ʲ���","�����ʲ���","newRecord()",sResourcesPath},
		{"true","","Button","�ʲ�������","�鿴�ʲ�������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ʲ�ת��Э��","deleteRecord()",sResourcesPath},
		{"true","","Button","���ɸѡ","�ʲ����ɸѡ","finishedRecord()",sResourcesPath},
		{"true","","Button","����ɸѡ","����ɸѡ�ʲ�","restartRecord()",sResourcesPath},
	};
	
	if("0010".equals(sTransferType)){
		sButtons[4][0]="false";
	}
	
	if("0020".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}
	
	if("0030".equals(sTransferType)||"0040".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}
	if("0050".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	/*~~[�����ʲ�ת��Э��]~~*/
	function newRecord(){
		var array = setObjectValue("SelectDealInfo","","",0,0,"");
		if(typeof(array)=="undefined"||array.length==0||array==null){
			return;
		}
		var serialNo = array.split("@")[0];
		
		if(serialNo=="_CLEAR_"){
			return;
		}
		//����ǿ��Э�飬һ��Э���ܽ��ж���ʲ�ת�ã���֮����
		var sReturn = RunMethod("���÷���","GetColValue","Transfer_Group,count(*),RelativeSerialNo='"+serialNo+"' and IsFlag='2'");
		
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			alert("�ǿ��Э��,�����ظ������ʲ���");
			return;
		}
		
		var applyType = "<%=sApplyType%>";
		var userID = "<%=CurUser.getUserID()%>";
		//var sReturnSerialNo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddProperTySelectInfo","initDealInfo","ObjectType="+applyType+",ObjectNo="+serialNo+",UserID="+userID);
		//if(typeof(sReturnSerialNo)=="undefined"||sReturnSerialNo==""||sReturnSerialNo==null){
		//	alert("�ʲ�ɸѡ�Ǽ�Э��ʧ��");
		//	return;
		//}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealSelectTab.jsp","SSerialNo="+serialNo+"&TransferType="+"<%=sTransferType%>"+"&AdpplyType="+applyType,"_blank","");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddProperTySelectInfo","delSelPropertyInfo","ObjectNo="+sSerialNo);
			if(sReturn=="Success"){
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sRelativeSerialNo = getItemValue(0,getRow(),"RelativeSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealSelectTab.jsp","SSerialNo="+sRelativeSerialNo+"&ApplySerialNo="+sSerialNo+"&TransferType="+"<%=sTransferType%>","_blank","");
		
		
	}
	
	function finishedRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sCount = RunMethod("���÷���","GetColValue","dealcontract_reative,count(*),SerialNo='"+sSerialNo+"'");
		if(typeof(sCount)!="undefined"&&parseInt(sCount)==0.0){
			alert("�뵼���ͬ��Ϣ");
			return ;
		}
		var sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@02,transfer_group,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("ɸѡʧ��");//�Ǽ�ʧ�ܣ�
			return;
		}else
		{
			reloadSelf();
			alert("���ɸѡ");//��ɵǼǣ�
		}
	}
	
	function restartRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@01,transfer_group,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("����ɸѡʧ��");//�Ǽ�ʧ�ܣ�
			return;
		}else
		{
			reloadSelf();
			alert("����ɸѡ�ɹ�");//��ɵǼǣ�
		}
	}	
	
	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>