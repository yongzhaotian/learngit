<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����ҵ����ص������б������Ŷ�������б��������ҵ�������б�
			 ��������ҵ�������б�������������Ǽ��б����������б�
	Input Param:
		ApplyType����������
			��CreditLineApply/���Ŷ������
			��DependentApply/�����������	
			��IndependentApply/��������ҵ������	
			��ApproveApply/���ύ���������������
			��PutOutApply/���ύ��˳���
			--ProductLineApply ��Ʒ����
		PhaseType���׶�����
			��1010/���ύ�׶Σ���ʼ�׶Σ�
	Output param:
	History Log: zywei 2005/07/27 �ؼ�ҳ��
	*/
	%>
<%/*~END~*/%>


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
	String userType="";
	String switch_status ="";//����ʽ�ᵥ���ϵͳ���� huzp
	//����������:��������,�׶�����
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String transactionFilter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransactionFilter",10));
	String stuApplyType= DataConvert.toRealString(iPostChange,(CurComp.getParameter("subApplyType")));
	//����ֵת���ɿ��ַ���
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(transactionFilter == null) transactionFilter = "";
	//��ú�ͬȡ��ʱ����ʾ����,��ͬȡ��ʱ����"ȡ��ԭ��"��"ȡ������"����ʾ
	String sMonitorId=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	if(sMonitorId==null) sMonitorId="";
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
	//ȡ��ҳ������������ʾ�ֶΣ���ȡ�����͡�����ȡ��ԭ��
	if("Cancel".equals(sMonitorId)){
		doTemp.setVisible("CancelReason",true);
		doTemp.setVisible("CancelType",true);
	}
	//add  �ڡ� �Ѿܾ���ͬ��������ʾ  �ܷ�ԭ�ظ����ֶ� by hhuang 20150630
	if("1050".equals(sPhaseType)){
		doTemp.setVisible("AllowReconsider",true);
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
	
	//�����弶��������ʱ��SQL������ƴ��  add by cbsu 2009-10-29
    if ("Classify".equals(sObjectType)) {
        String sTableSerialNo = "";
        if ("BusinessDueBill".equals(sResultType)) {
        	sTableSerialNo = "BUSINESS_DUEBILL.SerialNo";
        }
        if ("BusinessContract".equals(sResultType)) {
        	sTableSerialNo = "BUSINESS_CONTRACT.SerialNo";
        }
        sWhereClause1 = StringFunction.replace(sWhereClause1,"#TableSerialNo",sTableSerialNo);
        sWhereClause2 = StringFunction.replace(sWhereClause2,"#TableSerialNo",sTableSerialNo);
    }
	
	//���ӿո��ֹsql���ƴ�ӳ���
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//����ASDataObject�е���������
	//doTemp.OrderClause = " order by FLOW_OBJECT.ObjectNo desc ";
	//add ��ͬע�ᡢ��ͬ��ӡ���治���ֲ�Ʒ���������в�Ʒ���ܲ�ѯ by huanghui 20150826
	if((stuApplyType != null && (!"1150".equals(sPhaseType) && (!"1160".equals(sPhaseType)))) || ("CreditLineApply".equals(sApplyType) && (!"1150".equals(sPhaseType) && (!"1160".equals(sPhaseType))))){
		if("StuEducation".equals(stuApplyType)){//quliangmao   ��Ʒ������ �����û������URL �ж�������������
			doTemp.WhereClause += "  and  subproducttype = '5'  ";
		} else if("AdultEducation".equals(stuApplyType)){
			doTemp.WhereClause += "  and  subproducttype = '4'  ";
		} else if ("StuPos".equals(stuApplyType)){	// ѧ�����Ѵ�  add by dahl
			doTemp.WhereClause += "  and  subproducttype = '7'  ";
		}else{ //��ͨ���Ѵ� edit by dahl
			/*
			doTemp.WhereClause += "  and  nvl(subproducttype,'3') <> '4'  ";
			doTemp.WhereClause += "  and  nvl(subproducttype,'3') <> '5'  ";
			doTemp.WhereClause += "  and  nvl(subproducttype,'3') <> '7'  ";
			*/
			doTemp.WhereClause += "  and  subproducttype = '0'  ";
			
		}
	}
	
	//��������ʱ��Ϊ�����ؼ�
	doTemp.setCheckFormat("inputdate", "3");
	//���ɲ�ѯ��
	//add ��ͬ��ӡ����ͬע�������Ĳ�ѯ by huanghui 20150826
	if("1150".equals(sPhaseType) ){
		doTemp.setFilter(Sqlca, "002", "SerialNo", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "020", "CustomerName", "Operators=EqualsString,BeginsWith;");
		doTemp.setDDDWSql("contractStatus1", "select itemno,itemname from code_library where codeno='ContractStatus' and itemno in ('020','050','080') and IsInUse = '1' ");
		doTemp.setFilter(Sqlca, "036", "contractStatus1", "Operators=EqualsString;");
		doTemp.setFilter(Sqlca, "027", "inputdate", "Operators=EqualsString,BeginsWith;");
		//doTemp.generateFilters(Sqlca);
	}else if(("1160".equals(sPhaseType))){
		//����ע��ʱ��
		doTemp.setVisible("timerange,registrationdate", false);
		doTemp.setFilter(Sqlca, "002", "SerialNo", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "020", "CustomerName", "Operators=EqualsString,BeginsWith;");
		doTemp.setDDDWSql("contractStatus1", "select itemno,itemname from code_library where codeno='ContractStatus' and itemno ='080' and IsInUse = '1' ");
		doTemp.setFilter(Sqlca, "036", "contractStatus1", "Operators=EqualsString;");
		doTemp.setFilter(Sqlca, "027", "inputdate", "Operators=EqualsString,BeginsWith;");
		//doTemp.generateFilters(Sqlca);
	}else{
		doTemp.generateFilters(Sqlca);
	}	
	//��Ӵ��������ϴ�״̬��ѯ����
	if("CreditLineApply".equals(sApplyType) && "1080".equals(sPhaseType)){
		doTemp.setDDDWSql("uploadFlag", " select itemname,itemname from code_library where codeno='uploadFlag' and IsInUse = '1' ");
		doTemp.setDDDWSql("checkstatus", " select itemname,itemname from code_library where codeno='checkstatus' and IsInUse = '1' ");
		doTemp.setFilter(Sqlca, "024", "uploadFlag", "Operators=EqualsString;");
		doTemp.setFilter(Sqlca, "026", "checkstatus", "Operators=EqualsString;");
	}else if("CreditLineApply".equals(sApplyType) && "1050".equals(sPhaseType) && CurUser.hasRole("1005")){
		doTemp.WhereClause += " "+" and (isbaimingdan <> '1' or isbaimingdan is null)  ";
	}
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//jgao 2009-10-09�޸ģ���ѯ������������ʾģ�������ã�
	//doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//if(!sApplyType.equals("CreditCogApply")){ //���õȼ���������ʱ��չʾ
		//doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//}	
	
	//add ��ͬע�ᡢ��ͬ��ӡ��������Ĭ�ϲ���ѯ������ by huanghui 20150826
	if("1150".equals(sPhaseType) || ("1160".equals(sPhaseType))){
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20); 
	//ɾ����ǰ��ҵ����Ϣ 
	if(sObjectType.equals("CreditApply")|| sObjectType.equals("ProductApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	}else if(sObjectType.equals("Reserve")){
		//���Ӽ�ֵ׼��ɾ���Ĳ����߼���add by syang 2009-10-10
		dwTemp.setEvent("AfterDelete","!ReserveManage.ReserveCancelApply(#ObjectNo)+!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteReserve)");
	}else if(sObjectType.equals("Classify")){
		//����ɾ���弶����ɾ���Ĳ����߼���add by cbsu 2009-10-12
        dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteClassify)");
	}else if(sObjectType.equals("TransformApply")){
        //����ɾ��������ͬ����Ĳ����߼�
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteGuarantyTransform)");
	}else{
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sApplyType+"','"+sPhaseType+"','"+CurUser.getUserID()+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	if(sApplyType.equals("PutOutApply")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeletePutoutTask)");
	}
	
	//add by qfang 2011-6-8 ȡ��֧������
	if(sApplyType.equals("PaymentApply")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeletePaymentApply)");
	}
	//add end
	
	//out.println("-------sql"+doTemp.SourceSql); //������仰����datawindowװ�����ݵ�SQL���
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
	String sSql11="select userType from user_info where userID=:userID and isCar='02'";
	ASResultSet rs11=Sqlca.getASResultSet(new SqlObject(sSql11).setParameter("userID",CurUser.getUserID()));
	if(rs11.next()){
		userType=rs11.getString("userType");
	}
	rs11.getStatement().close();
	
	//��ȡ�����ŵ�����ģʽ    add by phe
    String operatemode="";
    String sSql2="select operatemode from store_info where sno=:sNo";
	 rs11=Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("sNo",sSNo));
	if(rs11.next()){
		operatemode=rs11.getString("operatemode");
	}
	rs11.getStatement().close();
	
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//���ڿ��Ƶ��а�ť��ʾ��������
	String iButtonsLineMax = "8";
	//add ����Ȩ�޵����۴���������������۴�������ʱ������ʾԭ�ظ���İ�ť�������ڴ������ڣ���Ҫ��ʾԭ�ظ���İ�ť�� by hhuang 20150630
	String Serialno = "";
	sSql11="select * from Reconsider_Quota_Record r where r.saleid=:userID ";
	rs11=Sqlca.getASResultSet(new SqlObject(sSql11).setParameter("userID",CurUser.getUserID()));
	if(rs11.next()){
		Serialno = rs11.getString(1);
	}
	rs11.getStatement().close();
	/********����ʽ�ᵥ����***************************/
	sSql = 	" select t.switch_status from SYSTEM_SWITCH t where t.switch_type ='PRETRIAL_ENABLE'";
	rs = Sqlca.getASResultSet(new SqlObject(sSql));
    if(rs.next()){
    	switch_status = rs.getString("switch_status");
    }else{
        throw new Exception("Ԥ�������쳣������ϵ����Ա��");
    }
    rs.getStatement().close();
    /**************************end**************/
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
		if(!userType.equals("01") && "doRegistration".equals(rs.getString("ItemNo"))){
			sButtons[iCountRecord][0] = "false";
		}
		if("doSign".equals(rs.getString("ItemNo"))){
			sButtons[iCountRecord][0] = "false";
		}
		if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("03")){
			sButtons[iCountRecord][0] = "true";
		}else if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("02")){
			sButtons[iCountRecord][0] = "false";
		}else if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("01")){
			sButtons[iCountRecord][0] = "false";
			sButtons[iCountRecord-1][0] = "true";			
		}else if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("04")){//add by phe 20150318 CCS-543
			sButtons[iCountRecord][0] = "true";
		}
		//add ����Ȩ�޵����۴���������������۴�������ʱ���費��ʾԭ�ظ���İ�ť���Ѳ�Ʒ������Ϊ4��5�������ܾ��б��ԭ�ظ��ť�������أ������۴��������Ϳ��� by hhuang 20150708
		if(Serialno==null || "".equals(Serialno) || "StuEducation".equals(stuApplyType) || "AdultEducation".equals(stuApplyType)){
			if("ReconsiderSubmit".equals(rs.getString("ItemNo"))){
				sButtons[iCountRecord][0] = "false";
			}
		}		
		//add CCS-1256 �۱�����ӡ��ͬ���� ���������ء���ӡ�۱�����ͬ����ť by fangxq 20160229
		if("StuEducation".equals(stuApplyType) || "AdultEducation".equals(stuApplyType)){
			if("printBaiBaoDai".equals(rs.getString("ItemNo"))){
				sButtons[iCountRecord][0] = "false";
			}
		}
		//end 
		/********����ʽ�ᵥ����***************************/
		if("1".equals(switch_status) && "��������".equals(sButtons[iCountRecord][3])){
			if(("CarCashLoanApply".equals(sApplyType)||"CashLoanApply".equals(sApplyType))){
				if("1010".equals(sPhaseType) ){
					sButtons[iCountRecord][0]="true"; 
				}else{
					sButtons[iCountRecord][0]="false"; 
				}
			}else{
				sButtons[iCountRecord][0]="false"; 
			}
		}
		/**************************end**************/
	}
	rs.getStatement().close();
	
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>