<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*,com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   jytian  2004/12/12
		Tester:
		Content: ҵ�������Ϣ
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		Output param:
		History Log: zywei 2005/08/03 �ؼ�ҳ��
		             pwang 2009/08/13 �޸�ҳ����ʾ����Ĭ�ϱ�����ʾ
		             djia  2009/10/21 ���ӻ�ȡչ�ڽ�ݵĽ�ݺ���Ϣ����Business_Apply�����ݺ���Ϣ
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "ҵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�����������������������Ӧ����������SQL��䡢��Ʒ���͡��ͻ����롢��ʾ���ԡ���Ʒ�汾
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="";
	//�����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//�������������ҵ����֡�����ҵ�����ա�������ˮ�š���ݺ�
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="";
	//�������������ҵ�������ҵ�����ʡ�����ҵ�����
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//���������չ�ڴ��������»��ɴ��������ɽ��´�����ծ���������
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0;
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
  /*  sSql = "select ProductID from business_contract where serialno =:ObjectNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
	if(rs.next()){
		sProductid = DataConvert.toString(rs.getString("ProductID"));
	
		//����ֵת���ɿ��ַ���
		if(sProductid == null) sProductid = "";
	
	}
	rs.getStatement().close(); 

    //������Ʒ�������Ʒ����
    sSql = "select ProductcategoryId,ProductcategoryName from product_category where productcategoryid in (select productcategory from business_type where typeno =:ProductID) ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ProductID",sProductid));
	if(rs.next()){
		sProductcategoryId = DataConvert.toString(rs.getString("ProductcategoryId"));
		sProductcategoryname = DataConvert.toString(rs.getString("ProductcategoryName"));
		
		//����ֵת���ɿ��ַ���
		if(sProductcategoryname == null) sProductcategoryname = "";
		if(sProductcategoryId == null) sProductcategoryId = "";
	}
	rs.getStatement().close();
*/
    
     //�����ŵ�
     String sSNo = CurARC.getAttribute(request.getSession().getId()+"city");
     System.out.println("-------�����ŵ�-------"+sSNo);
     
     sSql="select sno,sname from store_info where sno = :sno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sSNo));
     if(rs.next()){
    	 ssSno = DataConvert.toString(rs.getString("sno"));
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 
 		//����ֵת���ɿ��ַ���
 		if(ssSno == null) ssSno = "";
 		if(sSname == null) sSname = "";
     }
     rs.getStatement().close();
     
     //���������
     sSql="select si.sno as sno,si.sname as sname,sp.serviceprovidersname as serviceprovidersname,sp.genusgroup as genusgroup,sp.carfactoryid as carfactoryid from store_info si,service_providers sp where si.rserialno=sp.serialno and si.identtype='02' and sp.customertype1='07' and si.sno=:sno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sSNo));
     if(rs.next()){
    	 ssSno = DataConvert.toString(rs.getString("sno"));
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 sServiceprovidersname = DataConvert.toString(rs.getString("serviceprovidersname"));
    	 sGenusgroup = DataConvert.toString(rs.getString("genusgroup"));
    	 sCarfactoryid = DataConvert.toString(rs.getString("carfactoryid"));
    	 
 		//����ֵת���ɿ��ַ���
 		if(ssSno == null) ssSno = "";
 		if(sSname == null) sSname = "";
 		if(sServiceprovidersname == null) sServiceprovidersname = "";
 		if(sGenusgroup == null) sGenusgroup = "";
 		if(sCarfactoryid == null) sCarfactoryid = "";
     }
     rs.getStatement().close();
     
     

	//���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
	sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){
		sMainTable = DataConvert.toString(rs.getString("ObjectTable"));
		sRelativeTable = DataConvert.toString(rs.getString("RelativeTable"));
				
		//����ֵת���ɿ��ַ���
		if(sMainTable == null) sMainTable = "";
		if(sRelativeTable == null) sRelativeTable = "";		
	}
	rs.getStatement().close(); 
	
	//��ҵ����л��ҵ��Ʒ��
	sSql = "select ApplyType,RelativeSerialNo,CustomerID,BusinessType,OccurType,TempSaveFlag,ProductVersion from "+sMainTable+" where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sApplyType = DataConvert.toString(rs.getString("ApplyType"));
		sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sOccurType = DataConvert.toString(rs.getString("OccurType"));
		sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag"));
		sProductVersion = DataConvert.toString(rs.getString("ProductVersion"));
		
		//����ֵת���ɿ��ַ���
		if(sApplyType == null) sApplyType = "";
		if(sRelativeSerialNo == null) sRelativeSerialNo = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sTempSaveFlag == null) sTempSaveFlag = "";
	}
	rs.getStatement().close(); 
	
	//�ӱ�BUSINESS_APPLY��ȡISLIQUIDITY��ISFIXED��ֵ
	BizSort bizSort = new BizSort(Sqlca,sObjectType,sObjectNo,sApproveNeed,sBusinessType);
	boolean isLiquidity = bizSort.isLiquidity();
	boolean isFixed = bizSort.isFixed();
		
	//���ҵ��Ʒ��Ϊ��,����ʾ���������ʽ����
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//��ҵ�����Ϊ����ʱ��ִ������ҵ���߼�
	if(sObjectType.equals("CreditApply")){
		//���ݷ������ͣ�ϵͳ�ݴ���չ�ڡ����»��ɡ����ɽ��¡�ծ�������������ͣ���ȡ��Ӧ�Ĺ���ҵ����Ϣ
		if(sOccurType.equals("015") || sOccurType.equals("060")){ //չ�ڡ����»��ɡ����ɽ���
			//��ȡչ�ں�ͬ��/��ݣ��Ľ�ݺš��������ʡ����֡������ա�չ�ڴ��������»��ɴ��������ɽ��´�����ծ�������������Ϣ
			sSql = 	" select SerialNo,BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,RenewTimes as LNGOTimes,GOLNTimes,ReorgTimes as DRTimes "+ //���ս��
					//" from BUSINESS_CONTRACT "+ //���պ�ͬ
					" from BUSINESS_DUEBILL "+ //���ս��
					" where SerialNo = (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //���պ�ͬ
					" where ObjectType = 'BusinessDueBill' "+ //���ս��
					" and SerialNo =:SerialNo) ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
			if(rs.next()){
				dOldSerialNo = DataConvert.toString(rs.getString("SerialNo"));
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("BusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//����ֵת���ɿ��ַ���					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 		
		}else if(sOccurType.equals("030")){ //ծ������
			//��ȡ�ʲ����鷽�����
			sSql = 	" select ObjectNo from "+sRelativeTable+" "+
					" where ObjectType = 'CapitalReform' "+
					" and SerialNo =:SerialNo ";
			String sCapitalReformNo = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
			
			//��ȡ�����ͬ�Ľ�ծ�������ͬ�����ʡ����֡������ա�չ�ڴ��������»��ɴ��������ɽ��´�����ծ�������������Ϣ
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //���պ�ͬ
					" from BUSINESS_CONTRACT "+ //���պ�ͬ
					" where SerialNo = (select max(ObjectNo) "+
					" from APPLY_RELATIVE "+
					" where ObjectType = 'BusinessContract' "+ 				
					" and SerialNo =:SerialNo) ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sCapitalReformNo));
			if(rs.next()){
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("BusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//����ֵת���ɿ��ַ���					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 		
		}
		//��Щ����ҵ����Ҫ�ٽ��й���һ�Σ�չ��/���»���/���ɽ���/ծ�����飩�������Ҫ��ԭ���Ĵ���������һ��
		iExtendTimes = iExtendTimes + 1;
		iLNGOTimes = iLNGOTimes + 1;
		iGOLNTimes = iExtendTimes + 1;
		iDRTimes = iDRTimes + 1;
	}
	
	//���ݲ�Ʒ���ʹӲ�Ʒ��Ϣ��BUSINESS_TYPE�л����ʾģ������
	//��������Ϊչ�ڣ���Ҫ����չ����Ϣģ��
	if(sOccurType.equals("015")){
		if(sObjectType.equals("CreditApply")) //�������
			sDisplayTemplet = "ApplyInfo0000";
		if(sObjectType.equals("ApproveApply")) //���������������
			sDisplayTemplet = "ApproveInfo0000";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
			sDisplayTemplet = "ContractInfo0000";					
	}else{
		if(sObjectType.equals("CreditApply")) //�������
			sFieldName = "ApplyDetailNo";
		if(sObjectType.equals("ApproveApply")) //���������������
			sFieldName = "ApproveDetailNo";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
			sFieldName = "ContractDetailNo";

		sSql = " select "+sFieldName+" as DisplayTemplet from BUSINESS_TYPE where TypeNo =:TypeNo ";
		sDisplayTemplet = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	
		//����ͬһģ���ڲ�ͬ�׶���ʾ��ͬ������	
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
			sColAttribute = " ColAttribute like '%"+sObjectType+"%' ";
		//����/����ó������ҵ��,��ͬ�׶���ʱ��ʹ��ColAttribute����
		if(sBusinessType!=null && (sBusinessType.startsWith("1080") || sBusinessType.startsWith("1090") || "1030025".equals(sBusinessType))){
			sColAttribute="";
		}
	}

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,sColAttribute,Sqlca);
	
	//���ø��±���������
	doTemp.UpdateTable = sMainTable;

    //����ҵ������BusinessType����ʾ��Ӧ�������б�ѡ�� (��Business_Type���У�"2030"-�����Ա�����"2040"-�������Ա�����
    //��ģ��AssureType�У�"01010"-�����Ա���,"01020"-�������Ա���)    Add by zhuang 2010-03-17
    if(sBusinessType.equals("2030")){
        doTemp.setDDDWSql("SafeGuardType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AssureType' and ItemNo like '01010%' and ItemNo not in ('01010')" );
    }else if(sBusinessType.equals("2040")){
        doTemp.setDDDWSql("SafeGuardType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AssureType' and ItemNo like '01020%' and ItemNo not in ('01020')" );
    }

	//�����ֶεĿɼ�����	
	if(sOccurType.equals("020")) //���»���ʱ��ʾ���»��ɴ����ֶ�
		doTemp.setVisible("LNGOTimes",false);
	if(sOccurType.equals("060")) //���ɽ�����ʾ���ɽ��´����ֶ�
		doTemp.setVisible("GOLNTimes",true);
	if(sOccurType.equals("030")) //ծ��������ʾծ����������ֶ�
		doTemp.setVisible("DRTimes",true);	
	if(sOccurType.equals("015"))
		doTemp.setCheckFormat("TotalSum,BusinessSum","2"); 
	doTemp.setVisible("REQUITALACCOUNT",isLiquidity);//�����ʽ����ʱ��ʾ�ʽ�����˻��ֶ� 
	doTemp.setRequired("REQUITALACCOUNT",isLiquidity);//�����ʽ����ʱ�ʽ�����˻��ֶ�Ϊ����
	doTemp.setVisible("FUNDBACKACCOUNT",isFixed);//�̶��ʲ�����ʱ��ʾ����׼�����˻��ֶ�
	doTemp.setRequired("FUNDBACKACCOUNT",isFixed);//�̶��ʲ�����ʱ����׼�����˻��ֶ�Ϊ����
	//jschen@20100408 �Բ��ǵķǶ��ҵ�񣬺�ͬ�����ڽ��ֻ��
	if(sObjectType.equals("ReinforceContract") && !sBusinessType.startsWith("30")){
		doTemp.setReadOnly("BusinessSum",true);
	}

%>
<%
	//����DataWindow����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0"; 
	
	/*--------------------------���º��㹦�����Ӵ���-----------------*/
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", sBusinessType);
	valuePool.setAttribute("ProductVersion", sProductVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	/*--------------------------���Ϻ��㹦�����Ӵ���-----------------*/
	
	//���ñ���ʱ�������̶����Ķ���
	//ֻ��ҵ��Ʒ���Ƕ��ʱ��Ҫ����CL_Info
	if(sBusinessType.startsWith("3"))
	{
		//modify by hwang,���Ӷ�Rotative�ֶθ��²���
		dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo("+sObjectType+",#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#CreditCycle)");
	}			
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡУ��������Ϣ
	double dCheckBusinessSum = 0.0,dCheckBaseRate = 0.0,dCheckRateFloat = 0.0,dCheckBusinessRate = 0.0;
	double dCheckPdgRatio = 0.0,dCheckPdgSum = 0.0,dCheckBailSum = 0.0,dCheckBailRatio = 0.0;
	String sCheckRateFloatType = "";
	int iCheckTermYear = 0,iCheckTermMonth = 0,iCheckTermDay = 0;
	SqlObject so1 = null;
	//����������Ϊ�����������ʱ����ȡ���������������Ӧ��������Ϣ
	if(sObjectType.equals("ApproveApply")){
		//��ȡ��������������ˮ��
		sSql = 	" select max(SerialNo) "+
				" from FLOW_OPINION "+
				" where ObjectType = 'CreditApply' "+
				" and ObjectNo =:ObjectNo ";
		String sTaskSerialNo = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo",sRelativeSerialNo));

		//������������������ˮ�źͶ����Ż�ȡ��Ӧ��ҵ����Ϣ
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.BailSum,BA.BailRatio,BA.PdgRatio,BA.PdgSum, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay "+
				" from FLOW_OPINION BA "+
				" where BA.SerialNo =:SerialNo";
		so1 = new SqlObject(sSql).setParameter("SerialNo",sTaskSerialNo);
	}
	
	//����������Ϊ��ͬʱ����ȡ��ͬ����Ӧ��У����Ϣ
	if(sObjectType.equals("BusinessContract")){
		//jschen@20100401 �������Ҫ��������������������FLOW_OPINION����ȡУ��ֵ
		if(!"true".equalsIgnoreCase(sApproveNeed)){
			//��ȡ��ͬ��Ӧ������ˮ��
			String sApplySerialNo = Sqlca.getString(new SqlObject("select RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo",sObjectNo));
			String sTaskSerialNo = Sqlca.getString(new SqlObject("select max(SerialNo) from FLOW_OPINION where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo ").setParameter("ObjectNo",sApplySerialNo));
			
			//������������������ˮ�źͶ����Ż�ȡ��Ӧ��ҵ����Ϣ
			sSql = 	" select BusinessSum,BaseRate, "+
					" RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
					" BailSum,BailRatio,PdgRatio,PdgSum,TermYear, "+
					" TermMonth,TermDay "+
					" from FLOW_OPINION "+
					" where SerialNo =:SerialNo "+
					" and ObjectNo =:ObjectNo ";
			so1 = new SqlObject(sSql);
			so1.setParameter("SerialNo",sTaskSerialNo).setParameter("ObjectNo",sApplySerialNo);
		//�����BUSINESS_APPROVE����ȡУ��ֵ
		}else{
			sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
					" BA.BusinessRate,BA.PdgRatio,BA.PdgSum,BA.BailSum,BA.BailRatio, "+
					" BA.TermYear,BA.TermMonth,BA.TermDay "+
					" from BUSINESS_APPROVE BA"+
					" where exists (select BC.RelativeSerialNo from BUSINESS_CONTRACT BC "+
					" where BC.SerialNo =:SerialNo "+
					" and BC.RelativeSerialNo = BA.SerialNo) ";	
			so1 = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);
		}
	}
	
	if(sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract")){
		rs = Sqlca.getASResultSet(so1);
		if(rs.next()){ 
			dCheckBusinessSum = rs.getDouble("BusinessSum");
			dCheckBaseRate = rs.getDouble("BaseRate");
			dCheckRateFloat = rs.getDouble("RateFloat");
			dCheckBusinessRate = rs.getDouble("BusinessRate");
			dCheckPdgRatio = rs.getDouble("PdgRatio");
			dCheckPdgSum = rs.getDouble("PdgSum");
			dCheckBailSum = rs.getDouble("BailSum");
			dCheckBailRatio = rs.getDouble("BailRatio");
			sCheckRateFloatType = rs.getString("RateFloatType");
			iCheckTermYear = rs.getInt("TermYear");
			iCheckTermMonth = rs.getInt("TermMonth");
			iCheckTermDay = rs.getInt("TermDay");
		}
		rs.getStatement().close(); 
		if(sCheckRateFloatType == null) sCheckRateFloatType = "";
	}
	
	String sRateType = "";
	String monthcalculationMethod = "";
	String CreditAttribute = Sqlca.getString(new SqlObject("SELECT CreditAttribute FROM  business_type bt where bt.typeno='"+sBusinessType+"' "));
	if(CreditAttribute=="0001"){//���� */
		sSql = 	"SELECT bt.rateType,bt.monthcalculationMethod FROM  business_type bt where bt.typeno=:sbusinesstype";	
		so1 = new SqlObject(sSql).setParameter("sbusinesstype",sBusinessType);
		rs = Sqlca.getASResultSet(so1);
		if(rs.next()){ 
			sRateType = rs.getString("rateType");
			monthcalculationMethod = rs.getString("monthcalculationMethod");
		}
		rs.getStatement().close(); 
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{"true","All","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath}
	};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{	
		//setNoCheckRequired(0);
		//¼��������Ч�Լ��
		if ( !ValidityCheck() )
			return;									
		//�ı���ͬ����ظ��Լ��
		//alert(checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo@CustomerID") );
		//alert(checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo"));
		if(!checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo@CustomerID") && checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo")){
			alert("���ı���ͬ����Ѿ����ڣ��������룡");
			return;
		}
		inserTermPara();//�������ʣ����ʽ
		if(vI_all("myiframe0"))
		{
			beforeUpdate();
			if(!saveSubItem()) return;
			setItemValue(0,getRow(),"TempSaveFlag","2"); //�ݴ��־��1���ǣ�2����			
			as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");
		}
	}
	
	//�����������
	function inserTermPara(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo="<%=sObjectNo%>";
		var sApplyType="<%=sApplyType%>";
		var sBusinessType = "<%=sBusinessType%>";
		var CreditAttribute = "<%=CreditAttribute%>";
		var RepaymentWay = getItemValue(0,0,"RepaymentWay");//��������
		if(CreditAttribute == "0002"){//���Ѵ�
			var sTermID = "RPT17";//�ȶϢ
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=sObjectType%>,<%=sObjectNo%>");
			//�̶�����
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RAT002,<%=sObjectType%>,<%=sObjectNo%>");
			//��������
			var sReturn = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
			//�ſ��˻���Ϣ
			
			//�ۿ��˻���Ϣ
			if(RepaymentWay=="1"){//����
				var accountIndicator="01";//�ۿ�
				alert(sObjectType);
				//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				alert(sReturn);return;
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//�ۿ��˺�
					var ReplaceName = getItemValue(0,0,"ReplaceName");//�ۿ��˺���
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}
			
		
		}else if(CreditAttribute == "0001"){//��������
			var sRateType = "<%=sRateType%>";
			var Issue = getItemValue(0, 0, "Issue");//�����ڴ�
			var monthcalculationMethod = "<%=monthcalculationMethod%>";
			var finrate = "FIN003";//������Ϣ
			var IntereStrate = getItemValue(0, 0, "IntereStrate");//��������
			var CreditRate = getItemValue(0, 0, "CreditRate");//������������
			
			if(IntereStrate == "RAT004"){//�̶��������
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+CreditRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@"+IntereStrate+"@String@ObjectNo@"+sObjectNo);//����
			}
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+Issue+",PRODUCT_TERM_PARA,String@paraid@SEGStages@String@termid@"+monthcalculationMethod+"@String@ObjectNo@"+sObjectNo);//�����ڴ�
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+IntereStrate+",<%=sObjectType%>,<%=sObjectNo%>");//����
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+finrate+",<%=sObjectType%>,<%=sObjectNo%>");//��Ϣ
<%-- 			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//����
 --%>		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//�¹����㷽ʽ
 			
			//��������String FeeTermID,String ObjectType,String ObjectNo,String UserID FeeAmount
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sBusinessType%>,V1.0,YB100");//�ӱ���
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sBusinessType%>,V1.0,QT100");//������
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sBusinessType%>,V1.0,CD100");//���ս�
			var Premiums = getItemValue(0, 0, "Premiums");//�ӱ���
			var OtherCost = getItemValue(0, 0, "OtherCost");//������
			var InsuranceSum = getItemValue(0, 0, "InsuranceSum");//���ս�
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+Premiums+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@YB100@String@ObjectNo@"+sObjectNo);//�ӱ���
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+OtherCost+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@QT100@String@ObjectNo@"+sObjectNo);//������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+InsuranceSum+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@CD100@String@ObjectNo@"+sObjectNo);//���ս�
			
			RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
			//�ۿ��˺�
			var RepaymentWay = getItemValue(0,0,"RepaymentWay");//���ʽ
			if(RepaymentWay=="1"){//����
				var accountIndicator="01";//����
				sReturn = RunMethod("PublicMethod","DistinctAccount","<%=sObjectNo%>,<%=sObjectType%>,"+accountIndicator+","+serialNo);
				if(sReturn>=1){
					RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					var ReplaceName = getItemValue(0,0,"ReplaceName");//�˻�����������
					var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//�ۿ��˺� 
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}
			
		}
		
	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp()
	{
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�2����
		if(!saveSubItem()) return;
		as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");   //���ݴ�
		setNeedCheckRequired(0);//����ٽ����������û���		
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

<script type="text/javascript">

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");					
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//��������
		sOccurType = "<%=sOccurType%>";
		//���
		dOldBalance = "<%=dOldBalance%>";
		//��������
		sObjectType = "<%=sObjectType%>";
		//������
		sObjectNo = "<%=sObjectNo%>";
		//ҵ��Ʒ��
		sBusinessType = "<%=sBusinessType%>";
		
		//add by ttshao 2013/1/7
		//���ڽ��Ӧ���ܴ���������
		//������
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//���ڽ��
		dExposureSum = getItemValue(0,getRow(),"ExposureSum");
		
		if(sObjectType == "CreditApply") //�������
		{
			if(sOccurType == "015") //չ��ҵ��
			{
				dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
				if(dBusinessSum != dOldBalance)
				{
					//jqcao�� ���Ӽ��㣬�޷�������ģ����
					alert(getBusinessMessage('511'));//չ�ڽ��������չ��ǰ��ҵ����
					return false;
				}
			}
			
			 //������
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//��֤����
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//�����ѽ��
			dPdgSum = getItemValue(0,getRow(),"PdgSum"); 
		}
		<%-- 
		if(sObjectType == "ApproveApply")//���������������
		{
			//������
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
			//��׼���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			sBusinessType = "<%=sBusinessType%>";

		    //jqcao������һ�δ��룬��ΪУ����Ƹ������ݿ��ѯ����ʱ�޷�������ģ����
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0){
				if(dBusinessSum > dCheckBusinessSum){
					if(sOccurType == "015"){ //չ��ҵ��					
						alert(getBusinessMessage('512'));//��׼չ�ڽ��(Ԫ)������������е�չ�ڽ��(Ԫ)��
						return false;
					}else{					
						if(sBusinessType == '1020030') {//Э�鸶ϢƱ������
							alert(getBusinessMessage('513'));//��׼Ʊ���ܽ��(Ԫ)����С�ڻ���������е�Ʊ���ܽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '1080005' || sBusinessType == '1090010' || sBusinessType == '1080007'){//��������֤����������֤����������֤
							alert(getBusinessMessage('514'));//��׼����֤���(Ԫ)����С�ڻ���������е�����֤���(Ԫ)��
							return false;
						}else if(sBusinessType == '1080410') {//�������
							alert(getBusinessMessage('515'));//��׼���ݽ��(Ԫ)����С�ڻ���������еĵ��ݽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020'){ //���˷��ݴ��������Ŀ���������������̡��������Ѵ������������
							alert(getBusinessMessage('517'));//��׼�����ܶ��(Ԫ)����С�ڻ���������е����볨���ܶ��(Ԫ)��
							return false;
						}else{
							alert(getBusinessMessage('518'));//��׼���(Ԫ)����С�ڻ���������еĽ��(Ԫ)��
							return false;
						}						
					}
				}
			}
			
		    //jqcao������һ�δ��룬��ΪУ����Ƹ������ݿ��ѯ����ʱ�޷�������ģ����
			//У�����ޣ�ͳһ�������������������������*30�������죨ϵͳ��û��ʹ�������꣩��
			//�����������			
			dCheckTermMonth = "<%=iCheckTermMonth%>";
			//�����������
			dCheckTermDay = "<%=iCheckTermDay%>";
			//�����������
			dCheckTotalDay = parseInt(dCheckTermMonth)*30 + parseInt(dCheckTermDay);
			//��׼��������
			dTermMonth = getItemValue(0,getRow(),"TermMonth");
			//��׼��������
			dTermDay = getItemValue(0,getRow(),"TermDay");
			//��׼��������
			dTotalDay = parseInt(dTermMonth)*30 + parseInt(dTermDay);
			if(parseFloat(dCheckTotalDay) >= 0 && parseFloat(dTotalDay) >= 0)
			{
				if(dTotalDay > dCheckTotalDay)
				{
					alert(getBusinessMessage('550'));//��׼�����ޱ���С�ڻ������������ޣ�
					return false;
				}
			}
			
			//��׼���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//��֤����
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//�����ѽ��
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
		}
	
		
		//jqcao��ע��
		if(sObjectType == "CreditApply" || sObjectType == 'ApproveApply')
		{
			//�����ʽ�����˵���Ĺ�ϵ
			sDrawingType = getItemValue(0,getRow(),"DrawingType");//��ʽ��01��һ����02���ִ���
			sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			
			//��黹�ʽ�ͻ���˵���Ĺ�ϵ
			sCorpusPayMethod = getItemValue(0,getRow(),"CorpusPayMethod");//���ʽ��1��һ�λ��2���ִλ��
			sPaySource = getItemValue(0,getRow(),"PaySource");
		}
		
		if(sObjectType == "BusinessContract")//��ͬ����
		{			
			//��׼���
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
			//��ͬ���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//jqcao���öδ���ʹ���˸������ݿ��ѯ���޷�����ʾģ��������
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0)
			{
				if(dBusinessSum > dCheckBusinessSum)
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('552'));//չ�ڽ��(Ԫ)�������������������е���׼չ�ڽ��(Ԫ)��
						return false;
					}else
					{
						if(sBusinessType == '1020030') //Э�鸶ϢƱ������
						{
							alert(getBusinessMessage('553'));//Ʊ���ܽ��(Ԫ)����С�ڻ����������������е���׼Ʊ���ܽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '1080005' || sBusinessType == '1090010' || sBusinessType == '1080007') //��������֤����������֤����������֤
						{
							alert(getBusinessMessage('554'));//����֤���(Ԫ)����С�ڻ����������������е���׼����֤���(Ԫ)��
							return false;
						}else if(sBusinessType == '1080410') //�������
						{
							alert(getBusinessMessage('555'));//���ݽ��(Ԫ)����С�ڻ����������������е���׼���ݽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020') //���˷��ݴ��������Ŀ���������������̡��������Ѵ������������
						{
							alert(getBusinessMessage('557'));//�����ܶ��(Ԫ)����С�ڻ����������������е���׼�����ܶ��(Ԫ)��
							return false;
						}else
						{
							alert(getBusinessMessage('558'));//��ͬ���(Ԫ)����С�ڻ����������������е���׼���(Ԫ)��
							return false;
						}	
					}
				}
			}
			
			//��ͬ��ʼ��
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			//��ͬ������
			sMaturity = getItemValue(0,getRow(),"Maturity");			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sMaturity) != "undefined" && sMaturity != ""){
				if(sMaturity <= sPutOutDate){
				//��������Э��Ķ����Ч�ա����ʹ��������ڡ��������ҵ����ٵ�����������ʼ�ա������յ��߼���ϵ
				sBeginDate = getItemValue(0,getRow(),"BeginDate");
				sLimitationTerm = getItemValue(0,getRow(),"LimitationTerm");
				sUseTerm = getItemValue(0,getRow(),"UseTerm");
				
				//jqcao�����´���ʹ�������ݿ��ѯ���޷����õ�ģ����
				//У���ͬ���������ͬ��ʼ��֮��������Ƿ񳬹�����׼������
				iCheckTermYear = "<%=iCheckTermYear%>";
				iCheckTermMonth = "<%=iCheckTermMonth%>";
				//jschen@20100413 ���ֵΪ0���򲻼��顣�����������ҵ�����������������Ϊ����ʱû��������
				if(typeof(iCheckTermYear) != "undefined" && iCheckTermYear != ""
					&& typeof(iCheckTermMonth) != "undefined" && iCheckTermMonth != ""
					&& iCheckTermYear != 0 && iCheckTermMonth != 0)	
					{						
						a = new Date(sPutOutDate);
						b = new Date(sMaturity);			
						if(parseInt((b-a)/1000/24/60/60/30) > (parseInt(iCheckTermMonth)+parseInt(iCheckTermYear)*12))
						{
							alert(getBusinessMessage('591'));//��ͬ���ޱ���С�ڻ����������������е����ޣ����������£���
							return;
						}
					}	
				}
			}
			
			//��ͬ���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//��֤����
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//�����ѽ��
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			//��׼�Ļ�׼����
			sCheckBaseRate = "<%=dCheckBaseRate%>";
			//��׼�����ʸ�����ʽ
			sCheckRateFloatType = "<%=sCheckRateFloatType%>";
			//��׼�����ʸ���ֵ
			sCheckRateFloat = "<%=dCheckRateFloat%>";
			//��׼����
			sBaseRate = getItemValue(0,getRow(),"BaseRate");
			//���ʸ�����ʽ
			sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
			//���ʸ���ֵ
			sRateFloat = getItemValue(0,getRow(),"RateFloat");
			//jqcao�����´���ʹ�����ݿ��ѯ���޷���ģ��������
			if(parseFloat(sBaseRate) >= 0 && parseFloat(sCheckBaseRate) >= 0)
			{
				if(parseFloat(sBaseRate) < parseFloat(sCheckBaseRate))
				{
					alert(getBusinessMessage('559'));//��׼���ʱ�����ڻ����������������еĻ�׼���ʣ�
					return false;
				}
			}
			if(typeof(sRateFloatType) != "undefined" && sRateFloatType != ""
			&& typeof(sCheckRateFloatType) != "undefined" && sCheckRateFloatType != "")
			{
				if(sRateFloatType == sCheckRateFloatType)
				{
					if(parseFloat(sRateFloat) >= 0 && parseFloat(sCheckRateFloat) >= 0)
					{
						if(parseFloat(sRateFloat) < parseFloat(sCheckRateFloat))
						{
							alert(getBusinessMessage('560'));//���ʸ���ֵ������ڻ����������������е����ʸ���ֵ��
							return false;
						}
					}
				}
			}
			
			//jqcao�����´���ʹ���˸��ӷ������޷���ģ��������
			//�жϻ���׼�����˻������ʽ�����˻����˻������Ƿ��Ѿ��Ǽ�
			sFundbackAccount = getItemValue(0,getRow(),"FundbackAccount");
			sRequitalAccount = getItemValue(0,getRow(),"RequitalAccount");
			sCustomerID = getItemValue(0,getRow(),"CustomerID");
			sReturn = RunMethod("BusinessManage","CheckRegister",sFundbackAccount+","+sRequitalAccount+","+sCustomerID);
			if (sReturn == "true")
			{
				alert("���˺��Ѿ��Ǽǣ��Ƿ����ʹ�ã�");
			}else if(sReturn == "own")
			{
				alert("���˺��ѱ������û�ռ��");
				return false;
			}
		}
		 --%>
		//������������������֤
		
		sProductID = getItemValue(0,getRow(),"ProductID");//��Ʒ����
		//alert("---------------"+sProductID);
		if(sProductID=="01"){
			//�����ۼ���֤
			var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//�����ۼ�
			var sCarPrice =getItemValue(0,0,"CarPrice");//������
			
			if(parseFloat(sVehiclePrice) > parseFloat(sCarPrice)){
				alert("�����ۼ۲��ø��ڳ�����!");
				return false;
			}
			
			//�׸��������֤
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//�׸�����
			var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
			
			
		}
		
		
		
		
		
		return true;
	}
	
	/*~[Describe=�������Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditLine()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sTableName = "CUSTOMER_INFO" ;
		var sColName = "CustomerType";
		var sWhereClause = "CustomerID="+"'"+sCustomerID+"'";		
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//��ÿͻ�����
		sCustomerType = RunMethod("���÷���","GetColValue",sTableName + "," + sColName + "," + sWhereClause); 
		//���Ҹÿͻ�����Ч����Э��
		if(sCustomerType.substring(0,2) == "01")
		{
			sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
					setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0",0,0,"");
		}
		if(sCustomerType.substring(0,2) == "03")
		{
			sParaString = "PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract1",sParaString,"@CreditAggreement@0",0,0,"");
		}
	}

	/*~[Describe=��������/����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCountryCode(ID,Name){
		sParaString = "CodeNo"+",CountryCode";
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@"+ID+"@0@"+Name+"@1",0,0,"");
	}
			
	/*~[Describe=ѡ����Ҫ������ʽ;InputParam=��;OutPutParam=��;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}

	//ѡ������ҵ�񵣱���ʽ
	function selectVouchType3(){
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@Describe1@0@DescribeName@1",0,0,"");
	}
	
	//��Ѻ����Ѻ����
	function selectVouchType1() {
		ssBusinessType = "<%=sBusinessType%>";
		sParaString = "CodeNo"+","+"VouchType";
		if(ssBusinessType == "1110090" || ssBusinessType == "1110050")
		setObjectValue("SelectImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");
		else 
		setObjectValue("SelectPawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");	
			
	}
	//��֤����
	function selectVouchType2() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectAssureCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=����������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sType)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		if(sType == "OperateUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
		if(sType == "ManageUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@ManageUserID@0@ManageUserName@1@ManageOrgID@2@ManageOrgName@3",0,0,"");	
		if(sType == "RecoveryUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@RecoveryUserID@0@RecoveryUserName@1@RecoveryOrgID@2@RecoveryOrgName@3",0,0,"");			
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg(sType)
	{		
		if(sType == "StatOrg")
			setObjectValue("SelectAllOrg","","@StatOrgID@0@StatOrgName@1",0,0,"");		
	}
	
	/*~[Describe=������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAssureType()
	{		
		sParaString = "CodeNo"+","+"AssureType";
		setObjectValue("SelectCode",sParaString,"@SafeGuardType@0@SafeGuardTypeName@1",0,0,"");		
	}

	/*~[Describe=ѡ����ҵͶ�򣨹�����ҵ���ͣ�;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"Direction");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
			setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
		}
	}
	
	//add by ttshao 2013/1/5
	/*~[Describe=ѡ��ж������ơ�֤������;InputParam=��;OutPutParam=��;]~*/
	function selectAcceptanceCustomer()
	{
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";
		setObjectValue("SelectGuarantor",sParaString,"@ThirdPartyID1@0@THIRDPARTY1@1",0,0,"");		
	}
	 
	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
    	
	}
	
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{
		//��׼����
		var dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		var sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		var dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 && parseFloat(dRateFloat) >= 0)
		{			
			var dYearRate="";
			var dMonthRate="";
			if(sRateFloatType=="0"){	//�����ٷֱ�
				//ִ��������
				dYearRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
			 	//ִ��������
				dMonthRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else{	//1:��������
				//ִ��������
				dYearRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				//ִ��������
				dMonthRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
					//dBusinessRate = parseFloat(dBaseRate)/1.2 + parseFloat(dRateFloat); // �޸�ִ�������ʵļ��㹫ʽ add by cbsu 2009-10-22
			}
			dMonthRate = roundOff(dMonthRate,6);
			dYearRate = roundOff(dYearRate,6);
			setItemValue(0,getRow(),"BusinessRate",dMonthRate);
			setItemValue(0,getRow(),"ExecuteYearRate",dYearRate);
		}else{
			setItemValue(0,getRow(),"BusinessRate","");
			setItemValue(0,getRow(),"ExecuteYearRate","");
		}
	}
	
	/*~[Describe=����������Ϣ��ʵ�����ֽ��;InputParam=��;OutPutParam=��;]~*/
	function getDiscountInterest()
	{
		//������
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//Ʊ���ܽ��
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//��ȡ������Ϣ
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBusinessRate) >= 0)
		{
			//������Ϣ��Ʊ���ܽ���������
			dDiscountInterst = roundOff(parseFloat(dBusinessSum) * parseFloat(dBusinessRate)/1000,2);
			//����ʵ����Ʊ���ܽ�������Ϣ
			dDiscountSum = parseFloat(dBusinessSum) - parseFloat(dDiscountInterst);
			setItemValue(0,getRow(),"DiscountInterest",dDiscountInterst);
			setItemValue(0,getRow(),"DiscountSum",dDiscountSum);
		}
	}
	
	/*~[Describe=��������Ӧ��������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function getBargainorInterest()
	{
		//������Ϣ
		dDiscountInterest = getItemValue(0,getRow(),"DiscountInterest");
		//��Ӧ��������Ϣ
		dPurchaserInterest = getItemValue(0,getRow(),"PurchaserInterest");
		//��ȡ����Ӧ��������Ϣ
		if(parseFloat(dDiscountInterest) >= 0 && parseFloat(dPurchaserInterest) >= 0)
		{
			//����Ӧ��������Ϣ��������Ϣ����Ӧ��������Ϣ
			dBargainorInterest = parseFloat(dDiscountInterest) - parseFloat(dPurchaserInterest);
			setItemValue(0,getRow(),"BargainorInterest",dBargainorInterest);
		}
	}
	
	/*~[Describe=���Ŵ����С����д���ݶ�ռ�ȡ�����;InputParam=��;OutPutParam=��;]~*/	
	function setBusinessProp()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    dTradeSum = getItemValue(0,getRow(),"TradeSum");
        dBusinessProp = roundOff(parseFloat(dBusinessSum)/parseFloat(dTradeSum)*100,2);
		if(dBusinessProp>100)
		{
			setItemValue(0,getRow(),"BusinessProp",0);
		}
		else
		{
			 setItemValue(0,getRow(),"BusinessProp",dBusinessProp);
		}
    }
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(dPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCategoryID()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange1@0@BusinessRangeName@1",0,0,"");
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectTypeID()
	{
		sBusinessRange1 = getItemValue(0,0,"BusinessRange1");
		
		if(typeof(sBusinessRange1) == "undefined" || sBusinessRange1 == "")
		{
			alert("����ѡ�񷶳�1����!");
			return;
		}

		sParaString = "ProductcategoryID"+","+sBusinessRange1;
		//���÷��ز��� 
		setObjectValue("SelectMoldType",sParaString,"@BusinessType1@0@BusinessTypeName@1",0,0,"");
	}
	
	
	function selectCategoryID2()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange2@0@BusinessRangeName2@1",0,0,"");
	}
	
	function selectTypeID2()
	{
		sBusinessRange2 = getItemValue(0,0,"BusinessRange2");
		
		if(typeof(sBusinessRange2) == "undefined" || sBusinessRange2 == "")
		{
			alert("����ѡ�񷶳�2����!");
			return;
		}

		sParaString = "ProductcategoryID"+","+sBusinessRange2;
		//���÷��ز��� 
		setObjectValue("SelectMoldType",sParaString,"@BusinessType2@0@BusinessTypeName2@1",0,0,"");
	}
	
	
	function selectCategoryID3()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange3@0@BusinessRangeName3@1",0,0,"");
	}
	
	function selectTypeID3()
	{
		sBusinessRange3 = getItemValue(0,0,"BusinessRange3");
		
		if(typeof(sBusinessRange3) == "undefined" || sBusinessRange3 == "")
		{
			alert("����ѡ�񷶳�3����!");
			return;
		}

		sParaString = "ProductcategoryID"+","+sBusinessRange3;
		//���÷��ز��� 
		setObjectValue("SelectMoldType",sParaString,"@BusinessType3@0@BusinessTypeName3@1",0,0,"");
	}
	
	
	/*~[Describe=����ʡ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCityName()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"City","");
			setItemValue(0,getRow(),"CityName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"City",sAreaCodeValue);
					setItemValue(0,getRow(),"CityName",sAreaCodeName);			
			}
		}
	}
	
	//�����˺ſ�����ѡ��
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"OpenBank");
		var sCity     = getItemValue(0,0,"City");
		
		if(sCity=="" ||sOpenBank==""){
			alert("��ѡ�񿪻����л�ʡ�У�");
			return;
		}
		
		sCompID = "SelectWithholdList";
		sCompURL = "/CreditManage/CreditApply/SelectWithholdList.jsp";
		sParaString="OpenBank="+sOpenBank+"&City="+sCity;
		
		sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"OpenBranch",sBankNo);
		setItemValue(0,0,"OpenBranchName",sBranch);
	}
	
	//���Ƴ����ۼ۲��ø��ڳ�����
	function selectVPrice(obj){
		var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//�����ۼ�
		var sCarPrice =getItemValue(0,0,"CarPrice");//������
		
		if(parseFloat(sVehiclePrice) > parseFloat(sCarPrice)){
			alert("�����ۼ۲��ø��ڳ�����");
			obj.focus();
		}
	}
	
	//���㳵���ܼ�
	function selectOtherCost(){
		var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//�����ۼ�
		var sInsuranceSum =getItemValue(0,0,"InsuranceSum");//���ս��
		var sRevenueTax =getItemValue(0,0,"RevenueTax");//����˰
		var sOtherCost =getItemValue(0,0,"OtherCost");//��������
		var sAllocationSum =getItemValue(0,0,"AllocationSum");//�������ý��
		var sPremiums =getItemValue(0,0,"Premiums");//�ӱ���
		
		if(!isNaN(sVehiclePrice) && !isNaN(sInsuranceSum) && !isNaN(sRevenueTax) && !isNaN(sOtherCost) && !isNaN(sAllocationSum) && !isNaN(sPremiums)){
			var stotal=parseFloat(sVehiclePrice)+parseFloat(sInsuranceSum)+parseFloat(sRevenueTax)+parseFloat(sOtherCost)+parseFloat(sAllocationSum)+parseFloat(sPremiums);
			//alert("--------------"+stotal);
	        dTotal = roundOff(stotal,2);//�������뱣��2λС��

	        if(!isNaN(dTotal)){
			    setItemValue(0,0,"CarTotal",dTotal);//�����ܼ�
	        }
		}
	}
	
	//�׸������(��������):(�׸�����/�����ܼ�)*100%
	function selectPaymentRate(){
		var sProductID =getItemValue(0,0,"ProductID");//��Ʒ����
		if(sProductID=="01"){
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//�׸�����
			var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
			
			if(!isNaN(sPaymentSum) && !isNaN(sCarTotal)){
				var sPaymentRate=roundOff((parseFloat(sPaymentSum)/parseFloat(sCarTotal))*0.1,2);
	
				if(!isNaN(sPaymentRate)){
				    setItemValue(0,0,"PaymentRate",sPaymentRate);//�׸������
				}
			}
		}
	}
	
	//β�����:��β����/ �����ܼۣ�*100%
	function selectPaymentRate(){
		var sFinalPaymentSum =getItemValue(0,0,"FinalPaymentSum");//β����
		var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
		
		if(!isNaN(sFinalPaymentSum) && !isNaN(sCarTotal)){
			var sFinalPayment=roundOff((parseFloat(sFinalPaymentSum)/parseFloat(sCarTotal))*0.1,2);

			if(!isNaN(sFinalPayment)){
			    setItemValue(0,0,"FinalPayment",sFinalPayment);//β�����
			}
		}
	}
	
	//��ֵ����(��������):����ֵ���/ ���������ۣ�*100%
	function selectSalvageRatio(){
		var sProductID =getItemValue(0,0,"ProductID");//��Ʒ����
		if(sProductID=="02"){
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//��ֵ���
			var sCarPrice   =getItemValue(0,0,"CarPrice");//�����ܼ�
			
			if(!isNaN(sSalvageSum) && !isNaN(sCarPrice)){
				var sSalvageRatio=roundOff((parseFloat(sSalvageSum)/parseFloat(sCarPrice))*0.1,2);
	
				if(!isNaN(sSalvageRatio)){
				    setItemValue(0,0,"SalvageRatio",sSalvageRatio);//��ֵ����
				}
			}
		}
	}
	
	//������
	function selectBusinessSum(){
		var sProductID =getItemValue(0,0,"ProductID");//��Ʒ����
		//�������ڣ������ܼ�-�׸�����
		if(sProductID=="01"){
			var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//�׸�����
			
			if(!isNaN(sCarTotal) && !isNaN(sPaymentSum)){
				sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sPaymentSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//������
				}
			}
		 }
		
		//�������ޣ������ܼ�-��ֵ���
		if(sProductID=="02"){
			var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//��ֵ���
			
			if(!isNaN(sCarTotal) && !isNaN(sSalvageSum)){
				sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sSalvageSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//������
				}
			}
		}

		//���ƴ�����/�����ܼ۲��ø��ڲ�Ʒ�����е���ߴ������
		
	}
	
	//��֤����:����ָ����*��֤�����
	function selectBailSum(){
		var sCarguiDeprice   =getItemValue(0,0,"CarguiDeprice");//����ָ����
		var sDeposit   =getItemValue(0,0,"Deposit");//��֤�����
		
		if(!isNaN(sCarguiDeprice) && !isNaN(sDeposit)){
			sBailSum=roundOff(parseFloat(sCarguiDeprice)*parseFloat(sDeposit),2);
			if(!isNaN(sBailSum)){
			    setItemValue(0,0,"BailSum",sBailSum);//��֤����
			}
		}
		
	}
	
	//ѡ�񻹿ʽ
	function selectRepay(){
		var sRepaymentWay   =getItemValue(0,0,"RepaymentWay");//���ʽ
		if(sRepaymentWay=="1"){//����
			setItemRequired(0,0,"ReplaceName",true);//�˻�����������
			setItemRequired(0,0,"ReplaceAccount",true);//�˺�
			setItemRequired(0,0,"OpenBankName",true);//������������
			setItemRequired(0,0,"OpenBranchName",true);//����֧������
		}else{
			setItemRequired(0,0,"ReplaceName",false);//�˻�����������
			setItemRequired(0,0,"ReplaceAccount",false);//�˺�
			setItemRequired(0,0,"OpenBankName",false);//������������
			setItemRequired(0,0,"OpenBranchName",false);//����֧������
		}
	}
	
	//���ۿ�����������(����)
	function selectBankNo()
	{
		//sParaString = "ProductcategoryID"+","+sBusinessRange3;
		//���÷��ز��� 
		setObjectValue("SelectOpenBank","","@OpenBank@0@OpenBankName@1",0,0,"");
	}
	
	//���ۿ���֧������
	function selectBranchNo(){
		sOpenBank = getItemValue(0,0,"OpenBank");
		
		if(typeof(sOpenBank) == "undefined" || sOpenBank == "")
		{
			alert("��ѡ����ۿ������У�");
			return;
		}
		
		sParaString = "SerialNo"+","+sOpenBank;
		//���÷��ز��� 
		setObjectValue("SelectBranchName",sParaString,"@OpenBranch@0@OpenBranchName@1",0,0,"");
	}
	
	
	//������
	function countMoney(){
		var sPrice1 =parseFloat(getItemValue(0,0,"Price1"));
		var sTotalSum1 =parseFloat(getItemValue(0,0,"TotalSum1"));
		
		if(!isNaN(sPrice1) && !isNaN(sTotalSum1)){
			var sTotal=sPrice1-sTotalSum1;
			dTotal = roundOff(sTotal,2);
			
			if(!isNaN(dTotal)){
			   setItemValue(0,0,"BusinessSum1",dTotal);
			}
		}	
	}
	
	
	function countMoney2(){
		var sPrice2 =parseFloat(getItemValue(0,0,"Price2"));
		var sTotalSum2 =parseFloat(getItemValue(0,0,"TotalSum2"));
		
		if(!isNaN(sPrice2) && !isNaN(sTotalSum2)){
			var sTotal=sPrice2-sTotalSum2;
			dTotal = roundOff(sTotal,2);
			
			if(!isNaN(dTotal)){
			   setItemValue(0,0,"BusinessSum2",dTotal);
			}
		}	
	}
	
	function countMoney3(){
		var sPrice3 =parseFloat(getItemValue(0,0,"Price3"));
		var sTotalSum3 =parseFloat(getItemValue(0,0,"TotalSum3"));
		
		if(!isNaN(sPrice3) && !isNaN(sTotalSum3)){
			var sTotal=sPrice3-sTotalSum3;
			dTotal = roundOff(sTotal,2);
			
			if(!isNaN(dTotal)){
			  setItemValue(0,0,"BusinessSum3",dTotal);
			}
		}	
	}
	
	//���ʽ����
	function selectWay(){
		sRepaymentWay = getItemValue(0,0,"RepaymentWay");
		if(sRepaymentWay=="1"){
			//���ñ�ѡ����ѡ����ۣ���ʾ�������˺š������������С����������˻�����Ϊ����
			setItemRequired(0,0,"ReplaceAccount",true);
			setItemRequired(0,0,"OpenBank",true);
			setItemRequired(0,0,"ReplaceName",true);
			
			//���غ���ʾ�ֶ�
			//hideItem(0, 0, "ReplaceAccount");
			//showItem(0, 0, "RepaymentWay");
		}else{
			setItemRequired(0,0,"ReplaceAccount",false);
			setItemRequired(0,0,"OpenBank",false);
			setItemRequired(0,0,"ReplaceName",false);
		}
	}
	
	//��������
	function selectCarStatus(){
		sCarStatus = getItemValue(0,0,"CarStatus");
		//alert("---------------------"+sCarStatus);
		if(sCarStatus=="02"){
			//���ñ�ѡ�
			setItemRequired(0,0,"CarFrame",true);
			setItemRequired(0,0,"ProductDate",true);
			setItemRequired(0,0,"AssessPrice",true);
			setItemRequired(0,0,"CarYear",true);
			setItemRequired(0,0,"Journey",true);
		}else{
			setItemRequired(0,0,"CarFrame",false);
			setItemRequired(0,0,"ProductDate",false);
			setItemRequired(0,0,"AssessPrice",false);
			setItemRequired(0,0,"CarYear",false);
			setItemRequired(0,0,"Journey",false);
		}
	}
	
	//�����ͺŴ���
	function selectCarCode(){
		sCarCode = getItemValue(0,0,"CarCode");
		//alert("---------------------"+sCarCode);
		if(sCarCode !=""){
			sReturn = RunMethod("BusinessManage","GetCarInfo",sCarCode);
			//alert("------------"+sReturn);
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			
			//��ȡ����ֵ
			sReturn = sReturn.split("@");
			sModelsBrand=sReturn[0];//����Ʒ��
			sCarDescription=sReturn[1];//��������
			sModelsSeries=sReturn[2];//ϵ��
			sPrice=sReturn[3];//����������
			sBodyType=sReturn[4];//��������
			sEngineSize=sReturn[5];//����������
			sSalesstartTime=sReturn[6];//�³��������
			sColor=sReturn[7];//��ɫ
	
			setItemValue(0,0,"CarBrand",sModelsBrand);
			setItemValue(0,0,"CartypeDescribe",sCarDescription);
			setItemValue(0,0,"CarSeries",sModelsSeries);
			setItemValue(0,0,"CarPrice",sPrice);
			setItemValue(0,0,"CarBody",sBodyType);
			setItemValue(0,0,"Enginecapacity",sEngineSize);
			setItemValue(0,0,"ProductionYear",sSalesstartTime);
			setItemValue(0,0,"CarColour",sColor);
		}
	}
	

	/*~[Describe=���"��"�����Ƿ�Ϸ�;InputParam=��;OutPutParam=��;]~*/
 	function getTermDay()
	{
	    /* var dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay)>30){
	    	if(!(sBusinessType=="1080005") && !(sBusinessType=="1090010"))
	        alert("��(��)����С�ڵ���30!");
	    } */
	} 
	
	/*~[Describe=�����׸��������׸�����;InputParam=��;OutPutParam=��;]~*/
	function getThirdPartyRatio()
	{
	    //dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType = "<%=sBusinessType%>";
	    //ȡ�����ܼ�@jlwu
	    if(sBusinessType =="1110180" )
	    {
	    	sThirdPartyID2 = getItemValue(0,getRow(),"ThirdParty2");
	    }else
	    { 
	    	sThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2");
	    }
	    dThirdPartyID2 = parseFloat(sThirdPartyID2);
	    
	    //ȡ�׸����@jlwu
	    if(sBusinessType =="1110180" )
	    {
	    	sThirdParty = getItemValue(0,getRow(),"ThirdPartyID2");
	    }else
	    { 
	    	sThirdParty = getItemValue(0,getRow(),"ThirdPartyAdd1");
	    }	  
	    dThirdParty = parseFloat(sThirdParty);
	   
	    //�䵽У�������@qzhang1
	    /* if(dThirdPartyID2 < dThirdParty)
	    {
		    alert('�׸����ӦС�ڵ��ڷ����ܼۣ�');
			setItemValue(0,getRow(),"ThirdPartyAdd1","");
		    return;
	    } */
	    if(parseFloat(sThirdPartyID2) >= 0)
	    {
	        dThirdParty = roundOff(dThirdParty,2);
	        
	        if(parseFloat(dThirdParty) >= 0)
	        {	     
	            dThirdPartyRatio = parseFloat(dThirdParty)/parseFloat(dThirdPartyID2)*100;
	            dThirdPartyRatio = roundOff(dThirdPartyRatio,2);
	            dThirdPartyRatio+="";
	             if(sBusinessType =="1110180" )
	             {
	             	setItemValue(0,getRow(),"ThirdParty3",dThirdPartyRatio);
	             }else //if(sBusinessType=="1110010" || sBusinessType=="1110020" || sBusinessType=="1110030" || sBusinessType=="1110040" )
				 {
	            	setItemValue(0,getRow(),"ThirdPartyZIP1",dThirdPartyRatio);
	             }
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
		/*Ĭ���뵱ǰ����һ��
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio()
	{
	    /*Ĭ���뵱ǰ����һ��
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	        
				dBailSum = roundOff(dBailSum,2);
	            dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
	            dBailRatio = roundOff(dBailRatio,2);
	            setItemValue(0,getRow(),"BailRatio",dBailRatio);
				if (dBailRatio=="100") {
					setItemValue(0,getRow(),"VouchType",'005');
					setItemValue(0,getRow(),"VouchTypeName",'����');
				}
	        }
	    }
	}

	/*~[Describe=���û�׼������;InputParam=��;OutPutParam=��;]~*/
	function setBaseRate()
	{
		var currency = getItemValue(0,getRow(),"BusinessCurrency");
		var termMonth = getItemValue(0,getRow(),"TermMonth");
		var termDay = getItemValue(0,getRow(),"TermDay");
		if(isNull(currency) || isNull(termMonth)){
			return;
		}
		if(isNull(termDay)) termDay = 0;
		
		termDay = parseInt(termMonth)*30+parseInt(termDay);
		
		var baseRateType = getItemValue(0,getRow(),"BaseRateType");
		if(isNull(baseRateType)){
			setItemValue(0,getRow(),"BaseRate","");
			setItemValue(0,getRow(),"BusinessRate","");
			setItemValue(0,getRow(),"BusinessRate","");
			return;
		}
		var baseRate = RunJavaMethod("com.amarsoft.app.util.CalcBaseRate", "getBaseRate", "RateType="+baseRateType+",TermDay="+termDay+",Currency="+currency);
		if(baseRate=="-9999"){
			alert("δ���ҵ���Ӧ�Ļ�׼���ʣ��������޺ͱ���!");
			return;
		}
		setItemValue(0,getRow(),"BaseRate",baseRate);
		//����ִ������
		getBusinessRate(); 
	}
	
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		sOccurType = "<%=sOccurType%>";
		if(sOccurType == null || sOccurType==""){
			setItemValue(0,getRow(),"OccurType","010");
	    }		
		sObjectType = "<%=sObjectType%>";
		sBusinessType = "<%=sBusinessType%>";
		sManageUserID = getItemValue(0,getRow(),"ManageUserID");
		sPutOutOrgID = getItemValue(0,getRow(),"PutOutOrgID");
		sInputUserID = getItemValue(0,getRow(),"InputUserID");
		sOperateUserID = getItemValue(0,getRow(),"OperateUserID");
		//add by ttshao 2013/1/4
		var sOperateType=getItemValue(0,getRow(),"OPERATETYPE");
		if(isNull(sOperateType)){
			//����֤���½��ڴ�����������½��ڴ�����������Ŀ����������½��ڴ�������������֤�����򷽴���ҵ�����Ӵ��������ʽĬ��
			if(sBusinessType == "1080015" || sBusinessType == "1080110" || sBusinessType == "1030025" || sBusinessType == "1080090" || sBusinessType == "1090030"){
				setItemValue(0,getRow(),"OPERATETYPE","01");
		    }
		}
			
		//���ڲ��ǽ����ĺ�ͬ��û�йܻ�����Ϣ��Ŵ�����ֵΪ�գ��Զ�����Ϊ��ǰ�û���ǰ����
		if(sObjectType=="ReinforceContract"&&(typeof(sManageUserID)=="undefined"||sManageUserID=="")){
			setItemValue(0,getRow(),"ManageUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"ManageUserName","<%=CurUser.getUserName()%>");
		}
		if(sObjectType=="ReinforceContract"&&(typeof(sPutOutOrgID)=="undefined"||sPutOutOrgID=="")){
			setItemValue(0,getRow(),"PutOutOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"PutOutOrgName","<%=CurOrg.getOrgName()%>");
		}
		if(sObjectType=="ReinforceContract"&&(typeof(sInputUserID)=="undefined"||sInputUserID=="")){
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		}
		if(sObjectType=="ReinforceContract"&&(typeof(sOperateUserID)=="undefined"||sOperateUserID=="")){
			setItemValue(0,getRow(),"OperateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"OperateUserName","<%=CurUser.getUserName()%>");
		}
		var sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//"<%=sOldBusinessCurrency%>";
		if(isNull(sBusinessCurrency)){
			setItemValue(0,getRow(),"BusinessCurrency","01");
			sBusinessCurrency="01";
		}	
		var sBaseRateType = getItemValue(0,getRow(),"BaseRateType");//"<%=sOldBusinessCurrency%>";
		if(isNull(sBaseRateType)){
			//����Ϊ�����,��׼������������Ϊ���л�׼����,�ų�����ҵ�񡢳���˾ί�д����typeno��2��ͷ��ҵ�񡢸��˹���������������֤��������������֤����������ͥ�������������������֤��������������֤�����򷽴���
			if(sBusinessCurrency=="01" && !(!isNull(sBusinessType) && (sBusinessType.indexOf("1020")==0 || sBusinessType.indexOf("3")==0 || (sBusinessType.indexOf("2")==0 && sBusinessType!="2070")) || ",1110180,1080005,1080007,1080060,1080410,1090010,1090030".indexOf(sBusinessType)>0)){
				setItemValue(0,getRow(),"BaseRateType","010");
			}
		}	

        //����"��ͥ��"ҵ��ʱ�����"Ʊ�ݱ���"ֵΪ�գ�������Ϊ������
        if (sBusinessType == "1080060") {
            var sTradeCurrency = getItemValue(0,getRow(),"TradeCurrency");
            if (sTradeCurrency == "") {
                setItemValue(0,getRow(),"TradeCurrency","01");
           }
        }
				
		if(sBusinessType == "1100010" && sObjectType == "CreditApply" )
		{
			setItemValue(0,getRow(),"BusinessSum",0);
		}
		if(sOccurType == "015" && sObjectType == "CreditApply") //չ��ҵ��
		{
			setItemValue(0,getRow(),"Relativeagreement","<%=dOldSerialNo%>");
			setItemValue(0,getRow(),"TotalSum","<%=dOldBusinessSum%>");
			setItemValue(0,getRow(),"BusinessSum","<%=dOldBalance%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"BaseRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
		//setItemValue(0,getRow(),"BusinessCurrency","01");
		if(sOccurType == "020") //���»���
		{
			//setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060") //���ɽ���
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030" && sObjectType == "CreditApply") //ծ������
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		
		//�����ŵ�
		setItemValue(0,getRow(),"Stores","<%=ssSno%>");
		setItemValue(0,getRow(),"StoresName","<%=sSname%>");
		//���۴���
		setItemValue(0,getRow(),"Salesexecutive","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"SalesexecutiveName","<%=CurUser.getUserName()%>");
		
		//չ��
		setItemValue(0,getRow(),"ExhibitionHall","<%=ssSno%>");
		setItemValue(0,getRow(),"ExhibitionHallName","<%=sSname%>");
		//����������
		setItemValue(0,getRow(),"DealerName","<%=sServiceprovidersname%>");
		//��������������
		setItemValue(0,getRow(),"DealerGroup","<%=sGenusgroup%>");
		//��������
		setItemValue(0,getRow(),"Depot","<%=sCarfactoryid%>");
	}
	//�����������
	function CreditColumnCheck(sColumnName,sCheckType)
	{
		sCheckWord = getItemValue(0,getRow(),sColumnName);
		
		if(typeof(sCheckWord) != "undefined" && sCheckWord != "")	
		{
			if(!CheckTypeScript(sCheckWord,sCheckType))	
			{
				alert("�������Ͳ���ȷ�����������룡");
				setItemValue(0,getRow(),sColumnName,"");
				return false;
			}
			return true;
		}
	}
	//����Ƿ��Ǹ�����
	function isDigit(s)
	{
		var patrn=/^(-?\d+)(\.\d+)?$/;
		if (s!="" && !patrn.exec(s)) 
		{
			alert(s+"���ݸ�ʽ����");
			return false;
		}
		return true;
	}

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	//add by ttshao 2012/1/4
	/*~[Describe=���ݱ�����������Ѻ�����(%),������;InputParam=��;OutPutParam=��;]~*/
	function getBusinessSum(){
		var sOverDraftCurrent = getItemValue(0,getRow(),"RATIO");
		var sMFeeSum = getItemValue(0,getRow(),"MFeeSum");
		if(typeof(sOverDraftCurrent) == "undefined" || sOverDraftCurrent.length == 0
		|| typeof(sMFeeSum) == "undefined" || sMFeeSum.length == 0)
			return;
		
		var sValue = parseFloat(sOverDraftCurrent)*parseFloat(sMFeeSum)/parseFloat(100);
		setItemValue(0,getRow(),"BusinessSum",sValue+"");
	}
	
	/*~[Describe=����ÿ�»����,�Ը���������ܼ۸�����;InputParam=��;OutPutParam=��;]~*/
	function getMonthPayment(){
		var sPrice1 = '0'+getItemValue(0,getRow(),"Price1");//�۸�1
		var sTotalSum1 = '0'+getItemValue(0,getRow(),"TotalSum1");//�Ը����1
		var sPrice2 = '0'+getItemValue(0,getRow(),"Price2");//�۸�2
		var sTotalSum2 = '0'+getItemValue(0,getRow(),"TotalSum2");//�Ը����2
		var sPrice3 = '0'+getItemValue(0,getRow(),"Price3");//�۸�3
		var sTotalSum3 = '0'+getItemValue(0,getRow(),"TotalSum3");//�Ը����3
		
		var sValue1 = parseFloat(sPrice1)-parseFloat(sTotalSum1);//����1
		setItemValue(0,getRow(),"BusinessSum1",sValue1+"");
		var sValue2 = parseFloat(sPrice2)-parseFloat(sTotalSum2);//����2
		setItemValue(0,getRow(),"BusinessSum2",sValue2+"");
		var sValue3 = parseFloat(sPrice3)-parseFloat(sTotalSum3);//����3
		setItemValue(0,getRow(),"BusinessSum3",sValue3+"");
		var sValue4 = parseFloat(sPrice1)+parseFloat(sPrice2)+parseFloat(sPrice3);//�ܼ۸�
		setItemValue(0,getRow(),"TotalPrice",sValue4+"");
		var sValue5 = parseFloat(sTotalSum1)+parseFloat(sTotalSum2)+parseFloat(sTotalSum3);//�Ը����
		setItemValue(0,getRow(),"TotalSum",sValue5+"");
		var sValue6 = parseFloat(sValue1)+parseFloat(sValue2)+parseFloat(sValue3);//����
		setItemValue(0,getRow(),"BusinessSum",sValue6+"");
		
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//����
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//�Ը����
		var sPeriods = getItemValue(0,getRow(),"Periods");//��������
		var sBusinessType="<%=sBusinessType%>";
		if(parseFloat(sBusinessSum) > 0 && parseFloat(sPeriods) > 0){
			 if(parseFloat(sTotalSum)-parseFloat(sBusinessSum)>0){
				alert("�Ը��ܽ��ܴ��ڴ����ܱ���!");
				return;
			}else{
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods);
				setItemValue(0,getRow(),"MonthRepayment",parseFloat(sMonthPayment).toFixed(2)+"");
			}
		}
	}
</script>

<script type="text/javascript">
//���֤������У��
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"IdentityID");
	//alert("==================="+card);
	
   // ���֤����Ϊ15λ����18λ��15λʱȫΪ���֣�18λǰ17λΪ���֣����һλ��У��λ������Ϊ���ֻ��ַ�X   
   var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
   if(reg.test(card) === false)  
   {  
      alert("���֤���벻�Ϸ�");  
       return  false;  
   }  
}


function getFoucs(){
	alert("���ɿ��");
}
</script>



<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();	
	/*------------------�������JS����---------------*/
	afterLoad("<%=sObjectType%>","<%=sObjectNo%>"); 
	/*------------------�������JS����---------------*/
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
