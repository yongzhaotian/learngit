<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sFlowName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowName"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	//��ȡ��ǰҵ������̽׶α�� 
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sTemp = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sObjectNo==null) sObjectNo="";
	if(sTemp==null) sTemp="";
	String sSql = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "VetoApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sType.equals("1")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute1 = '1'";
	}
	if(sType.equals("2")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute2 = '1'";
	}
	if(sType.equals("3")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute3 = '1'";
	}
	if(sType.equals("4")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute4 = '1'";
	}
	if(sType.equals("5")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute5 = '1'";
	}
	if(sType.equals("6")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute6 = '1'";
	}
	//���۴���ʹ�õ�ȡ��ԭ��     add by awang 2014/12/29
     if(sType.equals("7")){
			sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute7='1'";
		}
	//���ר��ʹ�õ�ȡ��ԭ��
		if(sType.equals("8")){
			sSql="select ItemNo,ItemName from Code_Library where CodeNo = 'VetoApplyCode' and Attribute8='1'";
		}
	//�������ѡ��Ϊ��ѡ��
	doTemp.setVRadioSql("Attribute1", sSql);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","ȡ��","�����б�ҳ��","goBack()",sResourcesPath}
	};
	if(sTemp.equals("temp")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		var sPhaseOpinion1=getItemValue(0,0,"Attribute1");
		var sSerialNo=getItemValue(0,0,"SerialNo");
		var sInputOrg=getItemValue(0,0,"InputOrg");
		var sInputOrgName=getItemValue(0,0,"InputOrgName");
		var sInputUser=getItemValue(0,0,"InputUser");
		var sInputUserName=getItemValue(0,0,"InputUserName");
		var sInputTime=getItemValue(0,0,"InputTime");
		var sRemark=getItemValue(0,0,"Remark");
		
		
		if(typeof(sPhaseOpinion1)=="undefined" || sPhaseOpinion1.length==0){
			alert("��ѡ��ȡ��ԭ���ٵ��ȷ��");
			return;
		}
		/**20150515 update tangyb ��CEר��ȡ������ע��Ϊ������ start*/
		var sCE=<%=CurUser.hasRole("1027")%>;
		//alert("sCE��"+sCE);
		if(sCE){ //CEר��ȡ��
			if(sPhaseOpinion1=="0180"){
				var sRemark=getItemValue(0,0,"Remark");
				if(typeof(sRemark)=="undefined" || sRemark.length==0){
					alert("ѡ��ԭ��Ϊ����ʱ����עΪ������");
					return;
				}
			}
		}else{
			if(typeof(sRemark)=="undefined" || sRemark.length==0){
				alert("��עΪ�����������");
				return;
			}
		}
		/**20150515 update tangyb ��CEר��ȡ������ע��Ϊ������ end*/
		
		var sCount=RunMethod("BusinessManage","selectOpinoinCount",sSerialNo);
		if(sCount!=0.0){
			alert("�˺�ͬ�˽׶��Ѵ���");
			self.close();
		}
		if(bIsInsert){
			beforeInsert();
		}
		
		var sOpinionNo=getItemValue(0,0,"OpinionNo");
		as_save("myiframe0",sPostEvents);
		alert("�����ͬ�ɹ���");
		vetoApply();
	}
	
	function goBack(){
		window.close();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		//var serialNo = getSerialNo("FLOW_OPINION","OpinionNo");// ��ȡ��ˮ��
		var serialNo = "<%=DBKeyUtils.getSerialNo("FO")%>";// ��ȡ��ˮ��

		setItemValue(0,getRow(),"OpinionNo",serialNo);

		bIsInsert = false;
	}
	
	function vetoApply(){
		//����������͡�������ˮ�š��׶α��
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sUserName = "<%=CurUser.getUserName()%>";
		var sOrgName = "<%=CurUser.getOrgName()%>";
		var sOrgID = "<%=CurUser.getOrgID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sFlowName = "<%=sFlowName%>";
		var sApplyType = "<%=sApplyType%>";
		
		//�������н׶εĺ�ͬ������ˮ�ţ����Ƿ���׶ε�relativeserialno�ֶε�ֵ
		var sSerialNo = "<%=sSerialNo%>";	
		sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","vetoApply","serialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID+",userName="+sUserName+",orgName="+sOrgName+",orgID="+sOrgID+",flowNo="+sFlowNo+",flowName="+sFlowName+",applyType="+sApplyType);
		
		// ���º�ͬ״̬
		RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			
			var sCancelType="020";
		  	//��ȡ�����Ͳ����Flow_Opinion��
		    RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+sCancelType);
			
			
			<%-- �����ͬ����Ҫ���// add by tbzeng 2104/07/15 ��¼��ͬȡ���¼����¼����ͼ�¼060
			var sEvtSerialNo = getSerialNo("Event_Info", "Serialno", "");
			var sCols = "Serialno@Eventname@Eventtime@Contractno@Inputuser@Inputorg@Type@Remarks";
			var sVals = sEvtSerialNo+"@��ͬȡ��@<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>@"+sObjectNo+"@<%=CurUser.getUserID()%>@<%=CurOrg.orgID%>@060@ȡ����ͬ�¼���¼";
			RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.InsertEvalue", "recordEvent", "colName="+sCols+",colValue="+sVals);
			// end 2014/07/15 --%>
			
			
		    
			window.returnValue = "NotSameUser";
			window.close();

			//ˢ�¼�����ҳ��
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	function getValue(obj){
		/**20150515 update tangyb ��CEר��ȡ������ע��Ϊ������  start */
		var sCE=<%=CurUser.hasRole("1027")%>;
		if(sCE){ //CEר��ȡ��
			if(obj.value=="0180"){
	    		setItemRequired(0, 0, "Remark", true);
	    	}else{
	    		setItemRequired(0, 0, "Remark", false);
	    	}
		} else {
			setItemRequired(0, 0, "Remark", true);
		}
    	/**20150515 update tangyb ��CEר��ȡ������ע��Ϊ������  end */
    }
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		bCheckBeforeUnload = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
