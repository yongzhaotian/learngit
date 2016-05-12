<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ���õȼ��϶���Ϣ;
		Input Param:
			--SerialNo   : ��ˮ��
			--sObjectNo  ��������
			--sisReadOnly���԰�ť�Ĳ���Ȩ��־
	 */
	String PG_TITLE = "���õȼ��϶�"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql = "";//--���sql���
	String sUserID = "";//--�û�����
	String sUserName = "";//--�û�����
	String sRole = "";//--��ɫ
	String sResult="";//--���
	String sDate = "";//--����
	String sSourceValue = "";//--���¿ͻ���Ϣʱ�Ժͽ��Ϊ׼\
	String sButtonFlags="";
	
	//���ҳ�����,��ˮ���롢�����š���ť��־
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sIsReadOnly = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsReadOnly"));
	if(sSerialNo == null) sSerialNo = "";
	if(sIsReadOnly == null) sIsReadOnly = "";

	String sHeaders[][] = { {"AccountMonth","����·�"},
	                        {"ModelName","����ģ��"},
	                        {"EvaluateDate","ϵͳ��������"},
	                        {"EvaluateScore","ϵͳ�����÷�"},
	                        {"EvaluateResult","ϵͳ�������"},
							{"CognScore","�˹������÷�"},
							{"CognResult","�˹��������"},
							{"CognResult4","֧���϶����"},
							{"CognReason4","֧���϶�����"},
							{"FinishDate4","֧���϶��������"},							
							{"CognResult2","�����϶����"},
							{"CognReason2","�����϶�����"},
							{"FinishDate2","�����϶��������"},
							{"CognResult3","�����϶����"},
							{"CognReason3","�����϶�����"},
							{"FinishDate3","�����϶��������"},
							{"CognOrgName","������λ"},
							{"CognUserName","������"},
							{"CognUserName4","֧���϶���"},
							{"CognUserName2","�����϶���"},
							{"CognUserName3","�����϶���"},	         												
	                        {"Remark","����˵��"}
			              };   				   		
	
	sSql =  " select R.SerialNo,R.AccountMonth,C.ModelName,C.ModelNo,R.EvaluateDate,"+
			" R.EvaluateScore,R.EvaluateResult,R.CognScore,R.CognResult,R.CognResult4,"+
			" R.CognReason4,FinishDate4,R.CognResult2,"+
			" R.CognReason2,R.FinishDate2,R.CognResult3,R.CognReason3,R.FinishDate3,R.Remark,"+
			" R.CognOrgID,getOrgName(CognOrgID) as CognOrgName,"+
			" R.CognUserID,getUserName(CognUserID) as CognUserName,"+
			" CognUserID4,CognUserName4,"+
			" CognUserID2,CognUserName2,"+
			" CognUserID3,CognUserName3"+
			" from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
			" where R.ModelNo = C.ModelNo"+
			" and SerialNo='"+sSerialNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	//�ж��û��Ľ�ɫ 
	if(CurUser.hasRole("442")){ //֧�����õȼ��϶�Ա
 		doTemp.setRequired("CognResult4,CognReason4",true);
 		doTemp.setReadOnly("CognResult3,CognReason3,CognResult2,CognReason2",true);
 		sUserID = "CognUserID4";
 		sUserName = "CognUserName4";
 		sRole = "3";
 		sResult = "CognResult4";
 		sDate = "FinishDate4";
 	}else if(CurUser.hasRole("242")){ //�������õȼ��϶�Ա
 		doTemp.setRequired("CognResult2,CognReason2",true);
 		doTemp.setReadOnly("CognResult3,CognReason3,CognResult4,CognReason4",true);
 		sUserID = "CognUserID2";
 		sUserName = "CognUserName2";
 		sRole = "2";
 		sResult = "CognResult2";
 		sDate = "FinishDate2";
 	}else if(CurUser.hasRole("042")){ //�������õȼ��϶�Ա
 		doTemp.setRequired("CognResult3,CognReason3",true);
 		doTemp.setReadOnly("CognResult2,CognReason2,CognResult4,CognReason4",true);
 		sUserID = "CognUserID3";
 		sUserName = "CognUserName3";
 		sRole = "1";
 		sResult = "CognResult3";
 		sDate = "FinishDate3";
 		sButtonFlags="Y";
 	}else{
 	    doTemp.WhereClause += " and 1=2";
 	}
 	if(sIsReadOnly.equals("Y")){
        doTemp.setRequired("",false);
        doTemp.setReadOnly("",true);
 	}
	
	doTemp.setHeader(sHeaders);
	//�費�ɼ�
	doTemp.setVisible("SerialNo,ModelNo,CognUserID,CognOrgID,CognUserID2,CognUserID3,CognUserID4,FinishDate2,FinishDate3,FinishDate4",false);
	//Ϊ��ɾ��
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setUpdateable("ModelName,CognOrgName,CognUserName",false);
	
	//���ÿ��
	doTemp.setHTMLStyle("ModelName","style={width:300px} ");
	doTemp.setHTMLStyle("AccountMonth,EvaluateDate","  style={width:70px}  ");
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	doTemp.setCheckFormat("EvaluateScore,CognScore","2");
	doTemp.setType("EvaluateScore,CognScore","Number");
	doTemp.setDDDWSql("EvaluateResult,CognResult,CognResult2,CognResult3,CognResult4","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	doTemp.setReadOnly("AccountMonth,ModelName,EvaluateDate,EvaluateScore,EvaluateResult,CognOrgName,CognUserName,CognScore,CognResult,CognUserName2,CognUserName3,FinishDate3,FinishDate2,FinishDate4",true);
	doTemp.setHTMLStyle("FinishDate2,FinishDate3,FinishDate4","style={width:80px");
	//style={color:#848284;width:70px}
	doTemp.setEditStyle("CognReason2,CognReason3,CognReason4,Remark","3");
	doTemp.setHTMLStyle("CognReason2,CognReason3,CognReason4,Remark"," style={width:200px;height:70px} ");
	doTemp.setLimit("CognReason2,CognReason3,CognReason4,Remark",200);
	doTemp.setRequired("R.Remark",true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//��������¼�
	if(CurUser.hasRole("442"))	sSourceValue = "CognResult4";
	if(CurUser.hasRole("242"))	sSourceValue = "CognResult2";
	if(CurUser.hasRole("042"))	sSourceValue = "CognResult3";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord('updateENTINFO()')",sResourcesPath},
			{"true","","Button","�ύ","�ύ���õȼ��϶�","Finished()",sResourcesPath},
			{"false","","Button","�϶�","�϶��ύ�����õȼ�","Finished()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	if(sIsReadOnly.equals("Y")){
        sButtons[0][0]="false";
        sButtons[1][0]="false";
    }else if(sButtonFlags.equals("Y")){
		sButtons[1][0]="false";
        sButtons[2][0]="true";
    }
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	function saveRecord(sPostEvents){
		beforeUpdate();
		CheckEvaluate();
		as_save("myiframe0",sPostEvents);		
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function updateENTINFO(){
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        sLineID = RunMethod("���õȼ�����","���¿ͻ����µȼ����","<%=sSerialNo%>,<%=sObjectNo%>,<%=sSourceValue%>,"+sAccountMonth);		
	}
	
	/*~[Describe=�����������;InputParam=��;OutPutParam=��;]~*/
	function CheckEvaluate(){
        var sCognResult = getItemValue(0,getRow(),"<%=sResult%>");
        var sCognLevel = "<%=sRole%>";
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        PopPageAjax("/Common/Evaluate/CheckEvaluateActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&CognLevel="+sCognLevel+"&CognResult="+sCognResult+"&AccountMonth="+sAccountMonth,"","resizable=yes;dialogWidth=21;dialogHeight=19;center:yes;status:no;statusbar:no");        
	}
	
	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function Finished(sPostEvents){
		if(confirm("��ȷ��Ҫ�ύ�϶���")){
    	   setItemValue(0,0,"<%=sDate%>","<%=StringFunction.getToday()%>");
    	   //as_save("myiframe0",sPostEvents); 
    		saveRecord(sPostEvents);
        }
	}

	function goBack(){
		OpenPage("/Common/Evaluate/EvaluateCognList.jsp","_self","");
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"<%=sUserID%>","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"<%=sUserName%>","<%=CurUser.getUserName()%>");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%@ include file="/IncludeEnd.jsp"%>