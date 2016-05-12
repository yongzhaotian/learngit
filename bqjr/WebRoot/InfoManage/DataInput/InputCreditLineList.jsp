<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Author: jschen  2010.03.17
		Describe: ���ҵ�񲹵��б�;
		Input Param:
			ReinforceFlag��110 �貹�Ƕ��ҵ��
			               120 �Ѳ��Ƕ��ҵ��
	 */
	String PG_TITLE = "���ҵ�񲹵��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql="";
	String sClauseWhere="";
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";
	

	String sTempletNo="InputCreditLineList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(sReinforceFlag.equals("110")){  //�����ǻ������Ķ��ҵ��
		doTemp.WhereClause += " and ManageUserID ='"+CurUser.getUserID()+"'";
	}
	
	if(sReinforceFlag.equals("120")){  //���ǻ�������ɵĶ��ҵ��
		doTemp.WhereClause += " and ManageUserID ='"+CurUser.getUserID()+"'";
	}
	doTemp.OrderClause +=" order by SerialNo";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//ɾ�������¼�
	dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(ReinforceContract,#SerialNo,DeleteBusiness)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sReinforceFlag);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {		
				{"true","","Button","����","����","NewCreditBusiness()",sResourcesPath},
				{"true","","Button","����","����","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","ɾ��","ɾ��","DeleteBusinessInfo()",sResourcesPath},
				{"true","","Button","�������","�������","FinishCreditBusiness()",sResourcesPath},
				{"true","","Button","���²���","���²���","secondFinishCreditBusiness()",sResourcesPath},
			};
	
	//�貹�Ƕ��ҵ��
	if(sReinforceFlag.equals("110")){
		sButtons[4][0] = "false";
	}
	//������ɶ��ҵ��
	if(sReinforceFlag.equals("120")){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=ɾ�����ҵ���¼;InputParam=��;OutPutParam=��;]~*/
	function DeleteBusinessInfo(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";

        var sReturn = RunMethod("PublicMethod","GetCreditLineCounts",sSerialNo);   
        if( parseFloat(sReturn) > 0){
            alert("�ö���ѱ�����������ɾ����");  
            return;
        }		
						
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����			
		}
	}
	
	/*~[Describe=��Ⱥ�ͬ����;InputParam=��;OutPutParam=��;]~*/
	function CreditBusinessInfo(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			if(sReinforceFlag=="110"){
				sParamString = "ViewID=001&ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				reloadSelf();
			}else{
				sParamString = "ViewID=002&ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				reloadSelf();
			}
		}
	}

	/*~[Describe=�������ҵ��;InputParam=��;OutPutParam=��;]~*/
	function NewCreditBusiness(){
		sCompID = "CreditLineInputCreationInfo";
		sCompURL = "/InfoManage/DataInput/CreditLineInputCreationInfo.jsp";		

		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");		
		if(sReturn != '_CANCEL_' && typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn != "_NONE_"){
			//���Э����
			var sObjectNo = sReturn;
			sReturnValue = RunMethod("��Ϣ����","InitialInputCLInfo",sObjectNo);
			var sReinforceFlag = "<%=sReinforceFlag%>";
			if(sReinforceFlag=="110") {
				//������Ƚ�������ҳ��
				openObject("ReinforceContract",sObjectNo,"000");
			}
			reloadSelf();	
		}
	}

	/*~[Describe=�ö����ɲ��Ǳ�־;InputParam=��;OutPutParam=��;]~*/
	function FinishCreditBusiness(){
		//��ͬ��ˮ�š��ͻ���š�ҵ��Ʒ��
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		//��ʾ���ǽ����б�
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else {						
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
				alert("������Ϊ�գ����Ȳ��Ƕ�����");
				return;
			}else{	
				var sExistFlag = autoRiskScan("013","ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID,10);   
				if(sExistFlag!=true){
					return;
				}else{
					RunMethod("��Ϣ����","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag+","+sBusinessType);
					sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&ObjectNo="+sSerialNo,"","");
					if(sReturn == "true"){
						alert("������ɣ���ҵ����ת������������Ŷ���б�!");
					}
					reloadSelf();	
				}
			}
		}
	}

	/*~[Describe=���²���;InputParam=��;OutPutParam=��;]~*/
	function secondFinishCreditBusiness(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else {
			RunMethod("��Ϣ����","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag);
			sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&Pigeonholed=Y&ObjectNo="+sSerialNo,"","");
			if(sReturn == "true"){
				alert("�ñʶ��ҵ���ѷ����貹�����Ŷ���б������²���!");
			}
			reloadSelf();		
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>