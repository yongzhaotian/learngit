<%@ page contentType="text/html; charset=GBK"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Content: ��ҳ����Ҫ����ҵ��������ص������������������������ˡ��Ŵ����븴��
		Input Param:
			ApproveType:��������			
			PhaseType���׶�����
			FlowNo������ģ�ͱ��
			PhaseNo���׶α��
			FinishFlag����ɱ�־��Y������ɣ�N��δ��ɣ�
		Output param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//���������SQL��䡢ģ��ItemNo���׶������顢�����Ӧ�׶Ρ��׶�����ǿ��where�Ӿ�1���׶�����ǿ��where�Ӿ�2
	String sSql = "",sTempletNo = "",sPhaseTypeSet = "",sViewID = "",sWhereClause1 = "",sWhereClause2 = "";     
	//�����������ť������ť���������̶���
	String sButtonSet = "",sButton = "",sObjectType = "";
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//����������:���̶������͡��������͡����̱�š��׶α�š��׶����͡���ɱ�־
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo")); 
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")); 
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType")); 
	String sFinishFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"));
		
	//����ֵת���ɿ��ַ���
	if(sApproveType == null) sApproveType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";	
	if(sPhaseType == null) sPhaseType = "";
	if(sFinishFlag == null) sFinishFlag = "";
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//�Ӵ����CODE_LIBRARY�л��ApproveMain����ͼ�Լ�������Ľ׶�,���̶�������,TaskListʹ���ĸ�ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApproveType' and ItemNo = :ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		sButtonSet = rs.getString("Attribute5");
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
		if(sButtonSet == null) sButtonSet = "";
	}else{
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
	}
	rs.getStatement().close();
	
	//�Ӵ����CODE_LIBRARY�в�ѯ����ʲô��ͼ�鿴��������,where����1,where����2,ApplyList���ݶ���ID		
	sSql = 	" select ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo = :CodeNo and ItemNo = :ItemNo ";	
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sPhaseTypeSet).setParameter("ItemNo",sFinishFlag));
	if(rs.next()){				
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));		
		sTempletNo = rs.getString("Attribute4");
		
		//����ֵת���ɿ��ַ���		
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{		
		throw new Exception("û���ҵ���Ӧ�������׶ζ��壨CODE_LIBRARY,"+sSql+","+sFinishFlag+"����");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("û�ж��������б����ݶ���CODE_LIBRARY.ApproveType:"+sApproveType+"����");
	if(sViewID.equals("")) throw new Exception("û�ж��������׶���ͼ��CODE_LIBRARY,"+sPhaseTypeSet+","+sFinishFlag+"����");
		
	//add by zywei 2006/02/21 ������ɱ�־����ȡ��Ӧ���̱�š���Ӧ�׶α��Ӧ��ʾ�Ĺ��ܰ�ť
	if(sFinishFlag.equals("N")) //��ǰ����
		sButton = Sqlca.getString("select Attribute1 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	if(sFinishFlag.equals("Y")) //����ɹ���
		sButton = Sqlca.getString("select Attribute2 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	//����ֵת���ɿ��ַ���
	if(sButton == null) sButton = "";
			
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	//������ʾģ���ź���ʾģ�������������DataObject����
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//���ø��±���������
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	 //Ϊ�����ɾ��
	//��where����1��where����2�еı�����ʵ�ʵ�ֵ�滻��������Ч��SQL���
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseNo",sPhaseNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#FlowNo",sFlowNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.getUserID());
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseNo",sPhaseNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#FlowNo",sFlowNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	
	//���ӿո��ֹsql���ƴ�ӳ���
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//����ASDataObject�е���������
	doTemp.OrderClause = " order by FLOW_TASK.SerialNo desc ";
	
	doTemp.setAlign("CurrencyName,OccurTypeName","2");
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'','"+sPhaseType+"','"+CurUser.getUserID()+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //������仰����datawindowװ�����ݵ�SQL���
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	sSql = " select * from CODE_LIBRARY where CodeNo = :CodeNo and IsInUse = '1' Order by SortNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sButtonSet));
	while(rs.next()){	
		iCountRecord++;
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		} 
		sButtons[iCountRecord][6] = sResourcesPath;
		if(sApproveType.equals("ApproveCreditApply")){
			if("viewFlowGraph".equals(rs.getString("ItemNo"))){	//ƥ�䰴ť
					if("Demonstration".equals(sCurRunMode)){			//ֻ������ʾģʽ�²���ʾ�鿴����ͼ��ť
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
	}
	rs.getStatement().close();
	 
	%> 
<%/*~END~*/%>
