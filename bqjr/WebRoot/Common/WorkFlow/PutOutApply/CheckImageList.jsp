<%@ page contentType="text/html; charset=GBK"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
    <%
    /*
		Author:  yongxu 2015/05/28
		Tester:
		Content: �������ϼ��
		Input Param:
		Output param:
		History Log: 
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

	String sButtonSet = "";

	
	//����������:��������,�׶�����
	String sApplyType = "CreditLineApply";
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFinishFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"));
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	//����ֵת���ɿ��ַ���
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFinishFlag == null) sFinishFlag = "";

	//��ú�ͬȡ��ʱ����ʾ����,��ͬȡ��ʱ����"ȡ��ԭ��"��"ȡ������"����ʾ

	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//�����������ΪClassifyApply(�弶��������)�����PARA_CONFIGURE���ж�ȡ�弶����Ķ������ͣ�ȷ�����ǽ�ݻ��Ǻ�ͬ
    String sResultType = CurConfig.getConfigure("ClassifyObjectType");
    
    //�����ŵ�
    String sSNo = CurUser.getAttribute8();
    if(sSNo == null) sSNo = "";
    
	//�����������(��������)�Ӵ����CODE_LIBRARY�л��ApplyMain����ͼ�Լ�������Ľ׶�,���̶�������,ApplyListʹ���ĸ�ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApproveType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
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
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sPhaseTypeSet).setParameter("ItemNo",sFinishFlag));
	if(rs.next()){
		sButton = rs.getString("ItemDescribe");
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));		
		sTempletNo = rs.getString("Attribute4");
		
		//��sTempNo��@���зָ� 
		if ("Classify".equals(sObjectType)) {
			String[] sTempletNos = sTempletNo.split("@");
			//�����弶��������ǽ�ݻ��Ǻ�ͬ��ʹ�ò�ͬ��ģ��
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
	

	


	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	//������ʾģ���ź���ʾģ�������������DataObject����
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//�Ƕ������,���س��ڽ���ֶ�,����BusinessSum��������Ϊ������

	
	if(sFinishFlag.equals("N")) 
		sButton = "getTask,checkImage,doSubmit";
	System.out.println(sButton);
	if(sFinishFlag.equals("Y")  && CurUser.hasRole("2040")) 
		sButton = "updateDocOpinion,doSubmit";
	
	if(sButton == null) sButton = "";
	
	if(sFinishFlag.equals("Y") && CurUser.hasRole("2040")){
		
	}else {
		sWhereClause1 += " and (Check_Contract.checkImageUserID='#UserID' or Check_Contract.checkImageUserID2='#UserID') ";
		sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	}
	//���ø��±���������

	doTemp.setKey("ObjectType,ObjectNo",true);	 //Ϊ�����ɾ��
	//��where����1��where����2�еı�����ʵ�ʵ�ֵ�滻��������Ч��SQL���

	
	//�����弶��������ʱ��SQL������ƴ�� 
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
	
	//0:��ͨPOS��,4:���˽�����,5:ѧ��������,7:ѧ�����Ѵ�
//	doTemp.WhereClause += "  and  (subproducttype = '0' or subproducttype = '4' or subproducttype = '5' or subproducttype = '7')  ";
	
	//���ô������ϼ��״̬��
//	doTemp.setDDDWSql("checkstatus", " select itemname,itemname from code_library where codeno='checkstatus' and IsInUse = '1' ");
//	doTemp.setDDDWSql("uploadFlag", " select itemname,itemname from code_library where codeno='uploadFlag' and IsInUse = '1' ");
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	//���ô��������ϴ�״̬��ѯ����
//	doTemp.setFilter(Sqlca, "024", "uploadFlag", "Operators=EqualsString;");
	//���ô������ϼ��״̬��ѯ����
//	doTemp.setFilter(Sqlca, "026", "checkstatus", "Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//��ѯ������������ʾģ�������ã�
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20); 

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sApplyType+"','"+sPhaseType+"','"+CurUser.getUserID()+"'");
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
		
		

		
	}
	rs.getStatement().close();
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>