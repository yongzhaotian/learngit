<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����ҵ����ص������б������Ŷ�������б��������ҵ�������б�
			 ��������ҵ�������б�
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 �ؼ�ҳ�� 
		zywei 2007/10/10 �޸�ȡ���������ʾ��
		zywei 2007/10/10 �������鱨��ʱ�����ͷ���ҵ����������ҵ����Ʊ����ҵ���ۺ�����ҵ�񡢸��˿ͻ���
						 ��С��ҵ֮���ҵ��Ž��е��鱨���ʽ���������ж�
		zywei 2007/10/10 ����û��򿪶����������ظ������������Ĵ���
		qfang 2011/06/13 �����жϣ����Ϊ"�����¹����ò�Ʒ"���򵯳�ҳ�棬��ʾҵ��Ʒ�ַ����������־λ�ֶ�
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "���ŷ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = ""; //���SQL���
	ASResultSet rs = null; //��Ų�ѯ�����
	String sTempletNo = ""; //��ʾģ��ItemNo
	String sPhaseTypeSet = ""; //��Ž׶�������
	String sButton = ""; 
	String sObjectType = ""; //��Ŷ�������
	String sViewID = ""; //��Ų鿴��ʽ
	String sWhereClause1 = ""; //��Ž׶�����ǿ��where�Ӿ�1
	String sWhereClause2 = ""; //��Ž׶�����ǿ��where�Ӿ�2
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	String sButtonSet = "";
	
	//����������:��������,�׶�����
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String transactionFilter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransactionFilter",10));
	String sPhaseNo=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	System.out.println("sPhaseNo:"+sPhaseNo);
	//����ֵת���ɿ��ַ���
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(transactionFilter == null) transactionFilter = "";
	if(sPhaseNo==null)sPhaseNo="";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//�����������ΪClassifyApply(�弶��������)�����PARA_CONFIGURE���ж�ȡ�弶����Ķ������ͣ�ȷ�����ǽ�ݻ��Ǻ�ͬ add by cbsu 2009-10-28
    String sResultType = CurConfig.getConfigure("ClassifyObjectType");
    /*if("ClassifyApply".equals(sApplyType)) {
        sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'";    
        sResultType = Sqlca.getString(sSql); 
        //���PARA_CONFIGURE����û�������弶�������ݣ���ֱ��ʹ��"BusinessDueBill"
        if(!sResultType.equals("BusinessDueBill") && !sResultType.equals("BusinessContract"))
        {
            sResultType = "BusinessDueBill";
        }
    }*/
    
    //�����ŵ�
    String sSNo = CurUser.getAttribute8();
    if(sSNo == null) sSNo = "";
    System.out.println("-------�����ŵ�-------"+sSNo);
    
    
	//�����������(��������)�Ӵ����CODE_LIBRARY�л��ApplyMain����ͼ�Լ�������Ľ׶�,���̶�������,ApplyListʹ���ĸ�ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		sButtonSet = rs.getString("Attribute5");
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
		if(sButtonSet == null) sButtonSet = "";
	}else{
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApplyType:"+sApplyType+"����");
	}
	rs.getStatement().close();
	//�������ID���������(�׶�����)�Ӵ����CODE_LIBRARY�в�ѯ����ʾ�İ�ť,��ʲô��ͼ�鿴��������,where����1,where����2,ApplyList���ݶ���ID
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo =:CodeNo and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sPhaseTypeSet).setParameter("ItemNo",sPhaseType));
	if(rs.next()){
		sButton = rs.getString("ItemDescribe");
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));		
		sTempletNo = rs.getString("Attribute4");
		
		//��sTempNo��@���зָ� add by cbsu 2009-10-12
		if ("Classify".equals(sObjectType)) {
			String[] sTempletNos = sTempletNo.split("@");
			//�����弶��������ǽ�ݻ��Ǻ�ͬ��ʹ�ò�ͬ��ģ�� add by cbsu 2009-10-12
			if (sTempletNos.length > 1) {
				if ("BusinessDueBill".equals(sResultType)) {
					sTempletNo = sTempletNos[0];
					}
				if ("BusinessContract".equals(sResultType)) {
					sTempletNo = sTempletNos[1];
				}
			}
		}
		
		if(sButton == null) sButton = "";
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{
		throw new Exception("û���ҵ���Ӧ������׶ζ��壨CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"����");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("û�ж���sTempletNo, ���CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	if(sViewID.equals("")) throw new Exception("û�ж���ViewID ���CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	
	//�����������(��������)�Ӵ����CODE_LIBRARY�л��Ĭ������ID
	sSql = " select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	while(rs.next()){
		sInitFlowNo = rs.getString("Attribute2");
		if(sInitFlowNo == null) sInitFlowNo = "";
	}
	rs.getStatement().close();
	
	//����Ĭ������ID�����̱�FLOW_CATALOG�л�ó�ʼ�׶�
	sSql = " select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo",sInitFlowNo));
	while(rs.next()){
		sInitPhaseNo = rs.getString("InitPhase");
		if(sInitPhaseNo == null) sInitPhaseNo = "";
	}
	rs.getStatement().close();


	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	//������ʾģ���ź���ʾģ�������������DataObject����
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//�Ƕ������,���س��ڽ���ֶ�,����BusinessSum��������Ϊ������
	if(!"CreditLineApply".equals(sApplyType)){
		doTemp.setVisible("ExposureSum",false);
		doTemp.setHeader("BusinessSum","������");
	}
	//���ø��±���������
	doTemp.UpdateTable = "FLOW_OBJECT";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //Ϊ�����ɾ��
	//��where����1��where����2�еı�����ʵ�ʵ�ֵ�滻��������Ч��SQL���
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ApplyType",sApplyType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseType",sPhaseType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.getUserID());
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ApplyType",sApplyType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseType",sPhaseType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#Stores",sSNo);//����ŵ����
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	
	
    
	
	//���ӿո��ֹsql���ƴ�ӳ���
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//����ASDataObject�е���������
	//doTemp.OrderClause = " order by FLOW_OBJECT.ObjectNo desc ";

	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//jgao 2009-10-09�޸ģ���ѯ������������ʾģ�������ã�
	//doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//if(!sApplyType.equals("CreditCogApply")){ //���õȼ���������ʱ��չʾ
		//doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//}	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20); 

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseNo);
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
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//���ڿ��Ƶ��а�ť��ʾ��������
	String iButtonsLineMax = "8";
	//���ݰ�ť���Ӵ����CODE_LIBRARY�в�ѯ����ťӢ�����ƣ�����1������2��Button������ť�������ơ���ť������������ť����javascript��������
	sSql = 	" select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode "+
			" from CODE_LIBRARY where CodeNo =:CodeNo and IsInUse = '1' Order by SortNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sButtonSet)); 
	while(rs.next()){
		iCountRecord++;
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		//sButtons[iCountRecord][0] = "true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sApplyType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		}
		sButtons[iCountRecord][6] = sResourcesPath;
		//add sy syang 2009/10/22 �Ŵ�����ͨ�������룬����ʾģʽ�£���ת����󡱰�ť�ɼ�
		if(sApplyType.equals("PutOutApply")){
			if("transToAfterLoan".equals(rs.getString("ItemNo"))){	//ƥ�䰴ť
				if(sButton.indexOf(rs.getString("ItemNo"))>=0){ //�Ƿ�������ʾ
					if("Demonstration".equals(sCurRunMode)||"Development".equals(sCurRunMode)){			//������ʾ���ж��Ƿ�Ϊ��ʾģʽ
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
		}
		if(sApplyType.equals("IndependentApply") || sApplyType.equals("CreditLineApply") || sApplyType.equals("DependentApply")){
			if("greenWay".equals(rs.getString("ItemNo"))||"viewFlowGraph".equals(rs.getString("ItemNo"))){	//ƥ�䰴ť
				if(sButton.indexOf(rs.getString("ItemNo"))>=0){ //�Ƿ�������ʾ
					if("Demonstration".equals(sCurRunMode)){			//ֻ������ʾģʽ�²���ʾ��ɫͨ���Ͳ鿴����ͼ��ť
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
		}

	}
	rs.getStatement().close();
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
function newApply(){
	//��jsp�еı���ֵת����js�еı���ֵ
	var sObjectType = "<%=sObjectType%>";	
	var sApplyType = "<%=sApplyType%>";	
	var sPhaseType = "<%=sPhaseType%>";
	var sInitFlowNo = "<%=sInitFlowNo%>";
	var sInitPhaseNo = "<%=sInitPhaseNo%>";
	
	//����������������Ի���
		sCompID = "ForceBalanceApplyInfo";
		sCompURL = "/Common/WorkFlow/ForceBalanceApplyInfo.jsp";		
	    sReturn=PopComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo,"dialogWidth=750px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;"); 
	    reloadSelf();
    }
/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
function signOpinion(){
	//����������͡�������ˮ�š����̱�š��׶α��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	//��ȡ������ˮ��
	var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
	if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
		alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
		return;
	}
	var sCompID = "SignTaskOpinionInfo";
	var sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
	popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
}
/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
function doSubmit(){
    //����������͡�������ˮ�š����̱�š��׶α�š��������͡���ͬ��
    var sObjectType = getItemValue(0,getRow(),"ObjectType");
    var sFlowNo = getItemValue(0,getRow(),"FlowNo");
    var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    var sApplyType1 = "<%=sApplyType%>";      
    var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    var sApplyType = "<%=sApplyType%>";
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
    }

    //����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
    var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
    if(sNewPhaseNo != sPhaseNo) {
        alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
        reloadSelf();
        return;
    }

    //��ȡ������ˮ��
    var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
    if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
        alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
        return;
    }
    
    //���������ύѡ�񴰿�     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28
	var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
		alert(getHtmlMessage('18'));//�ύ�ɹ���
		reloadSelf();
	}else if (sPhaseInfo == "Failure"){
		alert(getHtmlMessage('9'));//�ύʧ�ܣ�
		return;
	}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
		alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
		reloadSelf();
		return;
	}else{
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//����ύ�ɹ�����ˢ��ҳ��
		if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}
	}
}
function viewTab(){
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
    }
    sObjectType = "BusinessContract";
    sCompID = "CreditTab";
	sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
  	reloadSelf();
}
function viewOpinions(){
	//����������͡�������ˮ�š����̱�š��׶α��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
    }
    
  	//����Ƿ�ǩ�����
    var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    var sObjectType = getItemValue(0,getRow(),"ObjectType");
    var sSerialNo = RunMethod("���÷���", "GetColValue", "Billions_Opinion,SerialNo,ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'")
	sReturn = RunMethod("���÷���", "GetCountByWhereClause", "Flow_Opinion,OpinionNo,ObjectNo='"+sObjectNo+"'");
	if(sReturn<=0) {
		//alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
		alert("�ñ����뻹δǩ�������");
		return;
	}
	
	popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
}

</script>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">		
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

