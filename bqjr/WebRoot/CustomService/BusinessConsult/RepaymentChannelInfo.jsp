<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "������������";

	// ���ҳ�����
	String sChannelSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChannelSerialNo"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("detailSerialNo"));
	String sOperateType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
	String sfromContractView =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("fromContractView"));//�Ƿ����Ժ�ͬ�鿴
 	if(sOperateType == null) sOperateType = "";
 	if(sChannelSerialNo==null || "".equals(sChannelSerialNo)) 
 	 	sChannelSerialNo = (String)session.getAttribute("repaymentChannelSerialNo");
 	if(sChannelSerialNo == null) sChannelSerialNo = "";
	if(sSerialNo==null) sSerialNo = "";
	if(sfromContractView == null) sfromContractView = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RepaymentChannelDetailList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(!"".equals(sSerialNo)){
		doTemp.WhereClause= " WHERE SERIALNO='"+sSerialNo+"'";
	}else{
		doTemp.WhereClause= " WHERE 1=2";
	}
	
	if(!sfromContractView.equals("")){
		doTemp.setReadOnly("BANKNAME,MOBILEBANK,ONLINEBANK,COUNTERTRANSFER,SELFTRANSFER", true);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
	}
	if(!"".equals(sfromContractView)){
		sButtons[0][0] = "false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��	

	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		var sfromContractView ="<%=sfromContractView%>";
		if("" ==sfromContractView){
			AsControl.OpenView("/CustomService/BusinessConsult/RepaymentChannelDetails.jsp","SerialNo=<%=sChannelSerialNo %>","_self");
		}else{
			AsControl.OpenView("/BusinessManage/QueryManage/BusinessChannelList.jsp","SerialNo=<%=sChannelSerialNo %>","_self");
		}
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"CHANNELSERIALNO","<%=sChannelSerialNo%>");
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
			
		var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
		//alert(retVal+"|"+typeof(retVal));
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		var cityItems = retVal.split("~");
		var sCityNos = "";
		var sCityNames = "";
		for (var i in cityItems) {
			sCityNos += cityItems[i].split("@")[0]+",";
			sCityNames += cityItems[i].split("@")[1]+",";
		}
		sCityNos = sCityNos.substring(0,sCityNos.length-1);
		sCityNames = sCityNames.substring(0,sCityNames.length-1);
		//setItemValue(0, 0, "NearCity", sCityNos);
		//setItemValue(0, 0, "NearCityName", sCityNames);
		setItemValue(0, 0, "BIGVALUE", sCityNos);    //�޸�Ϊ  wlq 
		setItemValue(0, 0, "BIGVALUENAME", sCityNames);
		
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("REPAYMENT_CHANNEL_LIST","SERIALNO");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			// temp set the defautl value is 02   01-Customer, 02-Car
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
