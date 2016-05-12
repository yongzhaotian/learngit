<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  ccxie 2010/03/17
		Tester:
		Describe: ���̼���б�
		Input Param:
			FlowStatus��01�ڰ�ҵ�� 02���ҵ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���̼���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����	
	//����������	
  	String sFlowStatus =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowStatus"));  
	if(sFlowStatus == null) sFlowStatus = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletNo = "FlowControlList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	if(sFlowStatus.equals("01"))
		doTemp.WhereClause = doTemp.WhereClause + " and PhaseNo not in ('1000','8000') " ;
	else
		doTemp.WhereClause = doTemp.WhereClause + " and PhaseNo in ('1000','8000') " ;
	doTemp.WhereClause = doTemp.WhereClause+" and OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";
	//����Filter		
	doTemp.setFilter(Sqlca,"1","FlowName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"2","PhaseName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"3","ObjectNo","Operators=EqualsString,Contains,BeginsWith,EndWith;");
	doTemp.setFilter(Sqlca,"4","UserName","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","OrgName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"6","InputDate","HtmlTemplate=Date;Operators=BeginsWith,EndWith,BetweenString;");

	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2 ";
	
	String sApproveNeed = "";
	sApproveNeed = CurConfig.getConfigure("ApproveNeed");//��ȡҵ���Ƿ�Ҫ������������������̵ı�־
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��   
	String sButtons[][] = {
			
		{"true","","Button","����","����","ViewDetail()",sResourcesPath},
		{"true","","Button","�鿴���","�鿴���","ViewOpinion()",sResourcesPath},
		{"true","","Button","��ת��¼","��ת��¼","ChangeFlow()",sResourcesPath},
		{"false","","Button","ҵ���ƽ�","ҵ���ƽ�","BizTransfer()",sResourcesPath}
		};
	
		if(sFlowStatus.equals("01")){
			sButtons[3][0] = "true";
		}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function ViewDetail(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowDetailPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}

	/*~[Describe=�鿴���;InputParam=��;OutPutParam=��;]~*/
	function ViewOpinion(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowOpinionPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}
	
	/*~[Describe=��ת��¼;InputParam=��;OutPutParam=��;]~*/
	function ChangeFlow(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			popComp("FlowChangeList","/SystemManage/GeneralSetup/FlowChangeList.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FlowStatus="+"<%=sFlowStatus%>","");
			reloadSelf();
		}
	}

	/*~[Describe=ҵ���ƽ�;InputParam=��;OutPutParam=��;]~*/
	function BizTransfer(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			sParaStr = "SortNo,"+"<%=CurOrg.getSortNo()%>";
			sReturn= setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
			if(typeof(sReturn) != "undefined" && sReturn.length != 0 ){
				sReturn = sReturn.split('@');
				sUserID = sReturn[0];
				RunMethod("WorkFlowEngine","ChangeFlowOperator",sObjectNo+","+sObjectType+","+sUserID);
				alert("��ǰҵ�����ƽ����û� "+sUserID);
				reloadSelf();
			}
		}  
	}


	/*~[Describe=��ѯ���������Ի���;InputParam=��;OutPutParam=��;]~*/
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.getElementById(sObjectID);
		oMyObj2 = document.getElementById(sObjectID2);
		if(sFilterID=="1"){
			var sApproveNeed = "<%=sApproveNeed%>";
			if("true" == sApproveNeed){//�жϸñ�ҵ���Ƿ�Ҫ�������������������
				sParaString = "CodeNo"+","+"FlowObject";
				sReturn =setObjectValue("SelectCode",sParaString,"",0,0,"");
			}else{
				sParaString = "CodeNo"+","+"FlowObject"+","+"Attribute1"+","+"SWITapprove";
				sReturn =setObjectValue("SelectCodeFlowObject",sParaString,"",0,0,"");
			}
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				//oMyObj2.value=sReturns[0];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="2"){		
			obj = document.getElementById("1_1_INPUT");
			if(obj.value == ""){
				alert('����ѡ���������ƣ�');
				return;
			}
			sParaString = "FlowName"+","+obj.value;
			sReturn =setObjectValue("SelectPhaseByFlowName",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				//oMyObj2.value=sReturns[0];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="5"){		
			sParaString = "OrgID,<%=CurOrg.getOrgID()%>";
			sReturn =setObjectValue("SelectBelongOrg",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				//oMyObj2.value=sReturns[0];
				oMyObj.value=sReturns[1];
			}
		}	
	}
	
	</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>