<%@page import="com.amarsoft.proj.action.P2PCreditCommon"%>
<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*,com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   rqiao 20150413
		Tester:
		Content: CCS-574 PRM-256 ԭ�ظ���ƻ���˶ϵͳ����
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		Output param:
		History Log: xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "���±���ҵ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�����������������������Ӧ����������SQL��䡢��Ʒ���͡��ͻ����롢��ʾ���ԡ���Ʒ�汾
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="",sSalesexecutive="",sSalesexecutiveName="";
	//�����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//�������������ҵ����֡�����ҵ�����ա�������ˮ�š���ݺ�
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSno="",sSname="",ssSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCreditId="",sCreditPerson="",sCity="",sAttr2="",sCarfactory="";
	// ��������� �ŵ꾭�����о���
	String sSalesManager = "", sCityManager = "", sSalesManagerName = "", sCityManagerName = "";
	//�������������ҵ�������ҵ�����ʡ�����ҵ�����
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//���������չ�ڴ��������»��ɴ��������ɽ��´�����ծ���������
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0;
	//�����������Ʒ������
	String sSubProductType = "";
	//�����������ѯ�����
	ASResultSet rs = null;
	String subProductTypename ="";//������
	//���ҳ�����	
	String sObjectType = DataConvert.toString((String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toString((String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
    
     //�����ŵ�
     //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
	//add by xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
     //String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
     String sNo = CurUser.getAttribute8();
 	// end by xswang 2015/06/01
 	
   //�ͻ�����    add by ybpan at 20150409 CCS-588  ϵͳ����������ALDIģʽ�Ŀͻ�����
     String sCustomerHolder= Sqlca.getString(new SqlObject("select SalesManNO  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     String sCustomerHolderName= Sqlca.getString(new SqlObject("select getUserName(SalesManNO)  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     
     if(sNo == null) sNo = "";
     if(sCustomerHolder == null) sCustomerHolder = "";
     if(sCustomerHolderName == null) sCustomerHolderName = "";
     
     
     //"select sno,sname, SALESMANAGER, getusername(SALESMANAGER) as  SALESMANAGERNAME, CITYMANAGER, getusername(CITYMANAGER) as CITYMANAGERNAME  from store_info where sno = :sno and  identtype = '01'";
     //�޸ĳ��о�������۾�����ϼ�ȡ�á� edit by Dahl 2015-03-17
     sSql="select si.sno,si.sname, si.SALESMANAGER, getusername(si.SALESMANAGER) as  SALESMANAGERNAME, ui.superId as CITYMANAGER, getusername(ui.superId) as CITYMANAGERNAME from store_info si ,user_info ui where si.salesmanager=ui.userid and sno = :sno and  identtype = '01'";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 sSno = DataConvert.toString(rs.getString("sno"));//�ŵ�
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 sSalesManager = DataConvert.toString(rs.getString("SALESMANAGER"));		// ���۾���
    	 sCityManager = DataConvert.toString(rs.getString("CITYMANAGER")); 	// ���о���
    	 sSalesManagerName = DataConvert.toString(rs.getString("SALESMANAGERNAME"));		// ���۾���
    	 sCityManagerName = DataConvert.toString(rs.getString("CITYMANAGERNAME")); 	// ���о���
    	 //��ӡlog���Ա��Ժ��ͬ�����۾���Ϊ��ʱ���������ݡ� add by Dahl 2015-03-17
    	 ARE.getLog().info("\n"+sObjectNo+"-------�����ŵ�-------"+sNo+"\n-------���۾���-------"+sSalesManager+"\n-------���о���-------"+sCityManager);
    	 
 		//����ֵת���ɿ��ַ���
 		if(sSno == null) sSno = "";
 		if(sSname == null) sSname = "";
 		if (sSalesManager == null) sSalesManager = "";
 		if (sCityManager == null) sCityManager = "";
 		if (sSalesManagerName == null) sSalesManagerName = "";
 		if (sCityManagerName == null) sCityManagerName = "";
     }
     rs.getStatement().close();
     
     //���۴�����ϵ��ʽ
     String sSalesexecutivePhone =Sqlca.getString("select MobileTel from user_info where UserID = '"+CurUser.getUserID()+"'");
     if(null == sSalesexecutivePhone) sSalesexecutivePhone = "";
     
     String sCityName = "" ;//����������
     //���������
     sSql="select si.city as city,getitemname('AreaCode',si.city) as cityName,si.sno as sno,si.sname as sname,sp.serviceprovidersname as serviceprovidersname,sp.genusgroup as genusgroup,sp.carfactoryid as carfactoryid,sp.carfactory as carfactory from store_info si,service_providers sp where si.rserialno=sp.serialno and si.identtype='02' and sp.customertype1='07' and si.sno=:sno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 ssSno = DataConvert.toString(rs.getString("sno"));//չ�����
    	 ssSname = DataConvert.toString(rs.getString("sname"));//չ������
    	 sServiceprovidersname = DataConvert.toString(rs.getString("serviceprovidersname"));//����������
    	 sGenusgroup = DataConvert.toString(rs.getString("genusgroup"));//��������
    	 sCarfactoryid = DataConvert.toString(rs.getString("carfactoryid"));//��������ID
    	 sCarfactory = DataConvert.toString(rs.getString("carfactory"));//������������
    	 sCity = DataConvert.toString(rs.getString("city"));//����
    	 sCityName = DataConvert.toString(rs.getString("cityName"));//����
     }
     rs.getStatement().close();
     
     ARE.getLog().debug("======"+sCity+","+ssSno+","+ssSname+","+sServiceprovidersname+","+sGenusgroup+","+sCarfactoryid+","+sCarfactory);
     
	

	  String sCreditAttribute = "";//0002����/0001����/0003������/0004С��ҵ����
     
     //��ѯ���۴���
     sSql="select Salesexecutive,getusername(Salesexecutive) as SalesexecutiveName,ProductID,CreditAttribute,SubProductType from business_contract where serialno=:serialno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
     if(rs.next()){
    	 sSalesexecutive = DataConvert.toString(rs.getString("Salesexecutive"));//���۴���ID
    	 sSalesexecutiveName = DataConvert.toString(rs.getString("SalesexecutiveName"));//���۴���Name
    	 
    	 sProductid = DataConvert.toString(rs.getString("ProductID"));//��Ʒ����
    	 sCreditAttribute =  DataConvert.toString(rs.getString("CreditAttribute"));//��Ʒ����
    	 
    	 sSubProductType = DataConvert.toString(rs.getString("SubProductType"));//��Ʒ������
    	 
 		//����ֵת���ɿ��ַ���
 		if(sSalesexecutive == null) sSalesexecutive = "";
 		if(sSalesexecutiveName == null) sSalesexecutiveName = "";
     }
     rs.getStatement().close();
     
     String ssCity = Sqlca.getString(new SqlObject("select city from store_info si where si.sno=:sno").setParameter("sno", sNo));
   	//��ȡ��������Ϣ(�������������ѽ���ȡֵ�߼�һֱ)
       sSql="select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName "+
    	         "from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '"+sSubProductType+"' "+
    		     "and pc.serialno=sp.serialno and sp.loaner = '010' and pc.areacode='"+ssCity+"'";
 	   rs=Sqlca.getASResultSet(sSql);
       if(rs.next()){
      	 sCreditId = DataConvert.toString(rs.getString("SerialNo"));//�����˱��
      	 sCreditPerson = DataConvert.toString(rs.getString("ServiceProvidersName"));//����������
      	
   		//����ֵת���ɿ��ַ���
   		if(sCreditId == null) sCreditId = "";
   		if(sCreditPerson == null) sCreditPerson = "";
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
		
		// fixme δ�жϸ����������͸ı����Ӧ��ģ���
		if (sDisplayTemplet == null) sDisplayTemplet = "ContractInfo1210";
		
		String	SubProductTypesSql = 	" select SubProductType from BUSINESS_CONTRACT where  SerialNo =:SerialNo ";
		 subProductTypename = Sqlca.getString(new SqlObject(SubProductTypesSql).setParameter("SerialNo",sObjectNo));
		if ("5".equals(subProductTypename)){//ѧ���� quliangmao
				sDisplayTemplet = "School001";
			}else if ("4".equals(subProductTypename)){//���˴�
				sDisplayTemplet = "School002";
			}
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
	
	//��ȡ������Ʒ�Ĳ���
	String LowPrinciPalMin = "",TallPrinciPalMax = "",ShoufuRatio = "",ShoufuRatioType = "",sRateType = "",monthcalculationMethod = "",sRateFloatType="",cProductType="";
	String highestLoansProportion = "",whetherDiscount = "" ,dMonthlyInterstRate="";
	int iPeriods = 0;
		String sSqlBT = " select term,MONTHLYINTERESTRATE,LOWPRINCIPAL,TALLPRINCIPAL,SHOUFURATIO,SHOUFURATIOTYPE,ratetype,monthcalculationMethod,floatingManner,highestLoansProportion,whetherDiscount,producttype from business_type where typeno='"+sBusinessType+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSqlBT));
		while(rs.next()){
			iPeriods = rs.getInt("term");
			LowPrinciPalMin = rs.getString("LOWPRINCIPAL");
			TallPrinciPalMax = rs.getString("TALLPRINCIPAL");
			ShoufuRatio = rs.getString("SHOUFURATIO");
			ShoufuRatioType = rs.getString("SHOUFURATIOTYPE");
			sRateType = DataConvert.toString(rs.getString("rateType"));//��������  modify by jli5 ����null
			monthcalculationMethod = rs.getString("monthcalculationMethod");//�¹����㷽ʽ
			sRateFloatType = rs.getString("floatingManner");//���ʸ�����ʽ
			dMonthlyInterstRate = rs.getString("MONTHLYINTERESTRATE");//��Ʒ������
			
			highestLoansProportion = rs.getString("highestLoansProportion");//��ߴ������
			whetherDiscount = rs.getString("whetherDiscount");//�Ƿ���Ϣ
			cProductType = rs.getString("producttype");//������������/�������� 01��������02������
			
		}
		rs.getStatement().close();
		
	//�Ƿ��б��շ�
	String productobjectno = sBusinessType+"-V1.0";
	Double CredFeeRate = 0.0;
	Double CredFeeRateAll = 0.0;
	String CredTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(CredTermID==null) CredTermID = "";
	if("".equals(CredTermID)){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
	}else{
		CredFeeRate = DataConvert.toDouble(Sqlca.getString(new SqlObject("select defaultvalue from product_term_para where paraid='FeeRate' and termid = '"+CredTermID+"' and objectno='"+productobjectno+"' ")));
		CredFeeRateAll = CredFeeRate*iPeriods;
	}
	
	ARE.getLog().debug("======CredFeeRateAll======"+CredFeeRateAll);
	
	String tTermTemp="",tTerm = "",tLoanFixedRate = "",tHighestFixedRate = "",tShouFuRatio = "",tRateFloat = "", tSectionRatio = "",tDealcomminssion = "",tSalesComminssion="",tDisCountFixedRate="",tSectionFixedRate="";
	if("0001".equals(sCreditAttribute)){//�������޲���
		sSql = 	"SELECT term,loanfixedrate,highestfixedrate,shoufuratio,floatingrate,sectionratio,dealercommissionrate,salescommission,discountfixedrate,sectionfixedrate FROM term where typeno=:sBusinessType and status='1' ";	
		rs = Sqlca.getASResultSet( new SqlObject(sSql).setParameter("sBusinessType",sBusinessType));
		if(rs.next()){
			tTerm = rs.getString("term");//����
			tLoanFixedRate = rs.getString("loanfixedrate");//����̶�����
			tHighestFixedRate = rs.getString("highestfixedrate");//��߹̶�����
			tShouFuRatio = rs.getString("shoufuratio");//�׸�����
			tRateFloat = rs.getString("floatingrate");//��������
			tSectionRatio = rs.getString("sectionratio");//β�����
			tDealcomminssion = rs.getString("dealercommissionrate");
			tSalesComminssion = rs.getString("salescommission");
			tDisCountFixedRate	 = rs.getString("discountfixedrate");//��Ϣ�ͻ��̶�����
			tSectionFixedRate = rs.getString("sectionfixedrate");//β��̶�����
		}
		rs.getStatement().close();
		
		//add by jli5 ����null���� 
		if(tTerm==null) tTerm="0";
		if(tLoanFixedRate==null) tLoanFixedRate="0";
		if(tHighestFixedRate==null) tHighestFixedRate="0";
		if(tShouFuRatio==null) tShouFuRatio="0";
		if(tRateFloat==null) tRateFloat="0";
		if(tSectionRatio==null) tSectionRatio="0";
		if(tDealcomminssion==null) tDealcomminssion="0";
		if(tSalesComminssion==null) tSalesComminssion="0";
		if(tDisCountFixedRate==null) tDisCountFixedRate="0";
		if(tSectionFixedRate==null) tSectionFixedRate="0";
		
		if("02".equals(monthcalculationMethod)||"04".equals(monthcalculationMethod)){//β���Ϣ
			tSectionFixedRate = "0.0";
		}
		//end 
		if(Integer.parseInt(tTerm)<=6){
			tTermTemp = "0"; 
		}else if(Integer.parseInt(tTerm)>6&&Integer.parseInt(tTerm)<=12){
			tTermTemp = "1"; 
		}else if(Integer.parseInt(tTerm)>12&&Integer.parseInt(tTerm)<=36){
			tTermTemp = "2"; 
		}else if(Integer.parseInt(tTerm)>36&&Integer.parseInt(tTerm)<=60){
			tTermTemp = "3"; 
		}
	}
	double cCreditRate = 0.0d;//��������
	//���д����������޸�
	//String cRateValue = Sqlca.getString(new SqlObject("select rateValue from rate_info where ratetype = '010' and rateunit='02' and termunit='020' and status='1' and term='"+tTerm+"' "));
	//��������  ���ݲ�Ʒ����   ��ʾģ����� add by jli5 
	if("0001".equals(sCreditAttribute)){
		String cRateValue = Sqlca.getString(new SqlObject("select yearsinterestrate from Interest_Rate where interestratetype='01' and isinuse='1' "+ 
		        " and to_date(to_char(sysdate, 'yyyy/MM/dd'), 'yyyy/mm/dd')>=to_date(effectivedate, 'yyyy/MM/dd') and term='"+tTermTemp+"' and rownum='1' "));
		if(cRateValue==null) cRateValue="0";
		if("01".equals(monthcalculationMethod)){
			doTemp.setVisible("FinalPayment,FinalPaymentSum", false);
		}
		if(cProductType.equals("02")){
			
		}
		System.out.println("�������ͣ�"+sRateType+"���ޣ�"+tTerm+"���л�׼���ʣ�"+cRateValue+"�������ȣ�"+tRateFloat+"�������ʣ�"+(Float.parseFloat(cRateValue)*(1+Float.parseFloat(tRateFloat)*0.01)));
		if(sRateType.equals("RAT004")){//�̶��������
			doTemp.setReadOnly("CreditRate", false);
			doTemp.setRequired("CreditRate", true);
			cCreditRate = Double.parseDouble(tLoanFixedRate);
		}else if(sRateType.equals("RAT001")){//��������
			if(sRateFloatType.equals("0")){//��������
				cCreditRate = (Double.parseDouble(cRateValue)+(Double.parseDouble(cRateValue)*Double.parseDouble(tRateFloat)*0.01));
			}else if(sRateFloatType.equals("1")){//��������
				cCreditRate = (Double.parseDouble(cRateValue)+Double.parseDouble(tRateFloat));
			}
		}else{
			cCreditRate = Double.parseDouble(tLoanFixedRate);
		}
		doTemp.setDefaultValue("PaymentRate", tShouFuRatio);
		
		//���ھ�������
		doTemp.setReadOnly("ManagerName,DealerGroup,Depot,CustomerName,ProductName,CreditPerson", true);
		doTemp.setUnit("ManagerName", "<input type=\"button\" value=\"...\" class=\"inputdate\" onclick=\"parent.selectManage()\">");
		doTemp.setVisible("ManageUserID", false);
		doTemp.setUpdateable("ManagerName,ManageUserID", true);
		
	}
	
	//����Ʒ��������ǰ���������� ����׶�ɾ���˷��ã�����ǰ��������ʱ�ٲ������ü�¼
	String tqhksxfTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A9' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(tqhksxfTermID == null) tqhksxfTermID = "";
	
	//edit by phe 20150305 CCS-470
	 String sOperatorMode =  Sqlca.getString(new SqlObject("select OperatorMode from Business_Contract where  serialno='"+sObjectNo+"' "));
	 if(sOperatorMode==null) sOperatorMode = "";
	  if(sOperatorMode.equals("01")){
		
		doTemp.setRequired("PromotersName",true);
		doTemp.setRequired("Idcard",true);
		doTemp.setRequired("Phone",true);
		
	}   
%>
<%
   doTemp.setReadOnly("CustomerType", true);//add by jli5 �ͻ��������Ͳ����޸�
   
	// �ŵ���ʾ add by tbzeng 2014/09/17
   if ("0002".equals(sCreditAttribute)) {
   	doTemp.setVisible("Stores,StoresName", true);
   	doTemp.setReadOnly("Stores,StoresName", true);
   	doTemp.setHeader("Stores", "�ŵ���");
   }
   // end --------------
   
   //������ԤԼ�ֽ������ͬ����ҳ��չʾ���Ƽ��ˡ���Ϣ
     if (!"2".equals(sSubProductType)) {
   	doTemp.setVisible("Recommender", false);
   }
   //end
    doTemp.setVisible("",false);
	//����DataWindow����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
	
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
	
	/* //�״λ�����
	dwTemp.setEvent("AfterUpdate","!LoanAccount.PutOutLoanTry("+sObjectNo+")"); */
	
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
	
/*
	//�ж��Ƿ�Ϊp2p��ͬ�� add by Dahl 2015-3-31
	P2PCreditCommon p2p = new P2PCreditCommon(sObjectNo, Sqlca);
	boolean isP2p = p2p.isUseP2P();
	ARE.getLog().debug("P2P�жϽ���,��ͬ"+sObjectNo+"�Ƿ�ΪP2P��ͬ"+isP2p+"������ʱ��Ϊ��"+StringFunction.getNow());
	//end by Dahl 2015-3-31 	
*/
	String sIsP2p = Sqlca.getString("select isP2p from Business_Contract where SerialNo = '"+sObjectNo+"'");

	//��ȡ�����˵������Ϣ
	String RepaymentNo = "";//�����˺�
	String RepaymentBank = "";//�����˺ſ�����
	String RepaymentName = "";//�����˺Ż���
	String RepaymentBankName = "";
	String sCreditid = Sqlca.getString("select CreditID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	sSql = "select pc.backAccountPrefix,pc.turnAccountName,pc.turnAccountBlank,getItemName('BankCode', pc.turnAccountBlank) as RepaymentBankName "+
	       "from Service_Providers sp,ProvidersCity pc where sp.SerialNo = :SerialNo "+
	       "and pc.serialno = sp.serialno and pc.areacode = '"+ssCity+"' and pc.ProductType = '"+sSubProductType+"'";
	SqlObject soSer = new SqlObject(sSql).setParameter("SerialNo", sCreditid);
	rs = Sqlca.getASResultSet(soSer);
	if(rs.next()){
		RepaymentNo = rs.getString("backAccountPrefix");
		RepaymentBank = rs.getString("turnAccountBlank");
		RepaymentName = rs.getString("turnAccountName");
		RepaymentBankName = rs.getString("RepaymentBankName");
	}
	//update CCS-399(���Ѵ�Ĭ����ʾΪ���ĺ�֧�С����ֽ��Ĭ����ʾΪ������֧��  ��;)
	if(RepaymentNo == null || RepaymentNo == "") 
	{
		if("020".equals(sProductid))//�ֽ��
		{
			RepaymentNo = "755920947910303";
		}else if("1".equals(sIsP2p))	//p2p
		{
			RepaymentNo = "755920947910212";
		}else
		{
			RepaymentNo = "755920947910920";
			  
		}
	}
	if(RepaymentBank == null || RepaymentBank == "") RepaymentBank = "308";
	if(RepaymentBankName == null || RepaymentBankName == "") 
	{
		if("020".equals(sProductid) || "1".equals(sIsP2p) )//�ֽ����p2p
		{
			RepaymentBankName = "�������йɷ����޹�˾���ڰ���֧��";
		}else
		{
			RepaymentBankName = "�������������ĺ�֧��";
		}
	}
	if(RepaymentName == null || RepaymentName == "") RepaymentName = "�����а�Ǫ���ڷ������޹�˾";
	//end
	rs.getStatement().close();
	
	RepaymentNo = RepaymentNo+Sqlca.getString("select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	
	//update CCS-399(���Ѵ�Ĭ����ʾΪ���ĺ�֧�С����ֽ��Ĭ����ʾΪ������֧��  ��;)
	if("020".equals(sProductid) || "1".equals(sIsP2p) )//�ֽ����p2p
	{
		RepaymentBankName = "�������йɷ����޹�˾���ڰ���֧��";
	}else
	{
		RepaymentBankName = "�������������ĺ�֧��";
	}
	//end
		
	
	//��ȡ�ͻ�����״̬
	String sCTempSaveFlag = Sqlca.getString(new SqlObject("select Tempsaveflag from Ind_Info where CustomerID =:CustomerID").setParameter("CustomerID", sCustomerID));
	
	//�״λ�����
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String temDay = "";
	String sSpecialDay = "";//�Ƿ����ⷢ����
	int iDaytemp =0;
	String businessDate = SystemConfig.getBusinessDate();
	
	temDay = businessDate.substring(8, 10);
	if(temDay.equals("29")){
		temDay = "02";
		sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
		sSpecialDay = "1";
	}else if(temDay.equals("30")){
		temDay = "03";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
		sSpecialDay = "1";
	}else if(temDay.equals("31")){
		temDay = "04";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
		sSpecialDay = "1";
	}else{
		sFirstDueDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1);
	}
	iDaytemp = DateFunctions.getDays(DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1), sFirstDueDate);
	
	//һ���ͻ������ͬ��������ж��״λ����գ�ȡ�ͻ�֮ǰ����ĺ�ͬ
	String sFirstNextDueDate = "";
	int sDays=0;
	String minSerialNo = Sqlca.getString(new SqlObject("SELECT min(serialno) FROM business_contract where finishdate is null and CONTRACTSTATUS = '050' and customerid = :CustomerID and serialno <> :serialno ").setParameter("CustomerID", sCustomerID).setParameter("serialno", sObjectNo));
	if(minSerialNo == null) minSerialNo = "";
	if(!minSerialNo.equals("")){
		sFirstNextDueDate = Sqlca.getString(new SqlObject("SELECT NEXTDUEDATE FROM acct_loan where loanstatus in ('0','1') and putoutno = :minSerialNo ").setParameter("minSerialNo", minSerialNo));	
		if(sFirstNextDueDate == null) sFirstNextDueDate = "";
		if(sFirstNextDueDate.compareTo(businessDate)<=0) sFirstNextDueDate = sFirstDueDate;
		if(!sFirstNextDueDate.equals("")){
			sDays = DateFunctions.getDays(businessDate, sFirstNextDueDate);
			if(sDays >= 14){
				sFirstDueDate = sFirstNextDueDate;
			}else{
				sFirstDueDate = DateFunctions.getRelativeDate(sFirstNextDueDate, DateFunctions.TERM_UNIT_MONTH, 1);
			}
			temDay = sFirstDueDate.substring(8, 10);
		}		
	}
	
	//String sMaturity = DateFunctions.getRelativeDate(sFirstDueDate, DateFunctions.TERM_UNIT_MONTH, iPeriods-1);
	String sMaturity = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, iPeriods);
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
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{	
		ShowMessage("ϵͳ�����ύ����ȴ�...",true,true);
			beforeUpdate();
			if(!saveSubItem()) return;
			setItemValue(0,getRow(),"TempSaveFlag","2"); //�ݴ��־��1���ǣ�2����
			var returnvalue = inserTermPara();//�������ʣ����ʽ
			/* if(!returnvalue){
				alert("�������ü�¼����,���������±��棡");
				return;
			} */
			var xxx = SetBusinessMaturity();//��ͬ����Ϊ��ͬ��Ч
			if(!xxx) {
				setItemValue(0,getRow(),"TempSaveFlag","1"); //�ݴ��־��1���ǣ�2����
			}
			//��ʱ����д �ſ�����ʧ�ܺ�ͬ��������Ϊ�ݴ�
			if(!firstMonthPayTry()){
				setItemValue(0,getRow(),"TempSaveFlag","1"); //�ݴ��־(1���ǣ�2����)
			}
			as_save("myiframe0",UpdatePromoters());
	}
	
	
	//edit by phe 20150305 CCS-470
	/*~[Describe=������������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function UpdatePromoters(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//��ͬ��ˮ��
		var sPromotersName=getItemValue(0,getRow(),"PromotersName");
		var sIdcard=getItemValue(0,getRow(),"Idcard");
		var sPhone=getItemValue(0,getRow(),"Phone");
		var sStores=getItemValue(0,getRow(),"Stores");
		var sRSerialno=RunMethod("BusinessManage", "selectRSerialno", sStores);
		
		var count=RunMethod("BusinessManage", "selectPromoterCount", SerialNo);
		if(count=="0.0"){
			<%-- <%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,<%=StringFunction.getToday()%> --%>
			RunMethod("BusinessManage", "InsertPromoterInfo", SerialNo+",,"+sPromotersName+","+sPhone+","+sIdcard+","+sStores+","+sRSerialno+","+'<%=CurUser.getOrgID()%>'+","+'<%=CurUser.getUserID()%>'+","+'<%=StringFunction.getToday()%>');
		}else{
			RunMethod("BusinessManage", "UpdatePromoterInfo", ","+sPromotersName+","+sPhone+","+sIdcard+","+sStores+","+sRSerialno+","+'<%=CurUser.getOrgID()%>'+","+'<%=CurUser.getUserID()%>'+","+'<%=StringFunction.getToday()%>'+","+SerialNo);

		}
		
	}
	
	
	/*~[Describe=���㵽����;InputParam=��;OutPutParam=��;]~*/
	function SetBusinessMaturity(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//��ͬ��ˮ��
		var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
		var sFirstDueDate = "<%=sFirstDueDate%>";
		//�����״λ�����
		RunMethod("PublicMethod","UpdateColValue","String@FIRSTDUEDATE@"+sFirstDueDate+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//�״λ�����	
		RunMethod("PublicMethod","UpdateColValue","String@ORIGINALPUTOUTDATE@"+sFirstDueDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//�״λ�����
		
		var sDay = sPutOutDate.substring(8,10); 
		var deDaultDueDay = "<%=temDay%>";
		
		RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//��ͬĬ�ϻ�����	
		var sTermMonth_ = RunMethod("GetElement","GetElementValue","Periods,business_contract,SerialNo='"+SerialNo+"'");//����
		var sTermMonth = parseInt(sTermMonth_,10);
		var sMaturity = "";
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 ) {
			alert("��ͬδ¼������ڴΣ�");
			return false;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";//���޵�λ(��)
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate);
		}
		
		sMaturity = "<%=sMaturity%>";
		if(sMaturity==""||sMaturity==null){
			alert("������Ϊ�գ������¼�飡");
			return false;
		}
		RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ��Ч��
		RunMethod("PublicMethod","UpdateColValue","String@contractEffectiveDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ��Ч��
		RunMethod("PublicMethod","UpdateColValue","String@Maturity@"+sMaturity+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ������
		
		/* //�״λ�����
		firstMonthPayTry(); */
		
		//return firstMonthPayTry();
		return true;
	}
	
	//�״λ������������
	function firstMonthPayTry(){
		//���ڻ������
		var dMonthlyInterstRate = "<%=dMonthlyInterstRate%>";//��Ʒ������
		var dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//�����
		var dMonthRepayment = getItemValue(0,getRow(),"MonthRepayment");
		var iDaytemp="<%=iDaytemp%>";
		
		//�������ӷſ����� ��ʱ����  ���޸�
		var sSpecialDay = "<%=sSpecialDay%>";
		var sContractSerialNo = "<%=sObjectNo%>";
		//if("1"==sSpecialDay){
			//��������
			var paymentValue = RunMethod("LoanAccount","PutOutLoanTry", sContractSerialNo);
			if(paymentValue==""||paymentValue==null||typeof(paymentValue)=="undefined"||paymentValue.length==0) return false;
			 
			var paymentValue1 = paymentValue.split("@")[0];//��һ��Ӧ���ܽ��
			var paymentValue2 = paymentValue.split("@")[1];//�ڶ���Ӧ���ܽ��
			var paymentValueEnd = paymentValue.split("@")[2];//���һ��Ӧ���ܽ��
			var totalPaylAmt1 = paymentValue.split("@")[3];//��һ��Ӧ����Ϣ
			var totalPaylAmt2 = paymentValue.split("@")[4];//�ڶ���Ӧ����Ϣ
			if(parseFloat(paymentValueEnd)>parseFloat(paymentValue2)) paymentValueMonth = paymentValueEnd;
			else paymentValueMonth = paymentValue2;
			try{
				setItemValue(0,getRow(),"FIRSTDRAWINGDATE",fix(parseFloat(paymentValue1)));//����
				setItemValue(0,getRow(),"MonthRepayment",fix(parseFloat(paymentValueMonth)));//ÿ��
			}catch(e){
				return false;
			}
		//}
		
		//��¼��û���� ����ʱ������һ��
		var MonthRepayment = getItemValue(0,getRow(),"MonthRepayment");
		var Firstpayment = getItemValue(0,getRow(),"FIRSTDRAWINGDATE");//���ڻ����
		try{
			if(Firstpayment == "NaN" || typeof(MonthRepayment)=="undefind" || MonthRepayment.length==0 || isNaN(MonthRepayment) || parseFloat(MonthRepayment)<=0.0 || typeof(Firstpayment)=="undefind" || Firstpayment.length==0 || isNaN(Firstpayment) || parseFloat(Firstpayment)<=0.0){
				getMonthPayment();
				return false;
			}
			var MonthRepaymentend = getItemValue(0,getRow(),"MonthRepayment");
			var Firstpaymentend = getItemValue(0,getRow(),"FIRSTDRAWINGDATE");//���ڻ����
			if(Firstpayment == "NaN" || typeof(MonthRepaymentend)=="undefind" || MonthRepaymentend.length==0 || isNaN(MonthRepayment) || parseFloat(MonthRepaymentend)<=0.0 || typeof(Firstpaymentend)=="undefind" || Firstpaymentend.length==0 || isNaN(Firstpaymentend) || parseFloat(Firstpaymentend)<=0.0){
				return false;
			}
		}catch(e){
			alert("����ϵ����Ա�������ݻ���,��������");
			return false;
		}
		
		return true;
	}
	
	//�����������
	function inserTermPara(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo="<%=sObjectNo%>";
		var sApplyType="<%=sApplyType%>";
		var sBusinessType = "<%=sBusinessType%>";
		var CreditAttribute = "<%=sCreditAttribute%>";
		var RepaymentWay = getItemValue(0,0,"RepaymentWay");//��������
		//if(CreditAttribute == "0002"){//���Ѵ�
			var sTermID = "RPT17";//�ȶϢ
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=sObjectType%>,<%=sObjectNo%>");
			//�̶�����
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RAT002,<%=sObjectType%>,<%=sObjectNo%>");
			//��������
			var sReturnFeeBool = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
						
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); //�Ƿ�Ͷ�� 
			if(sCreditCycle!="1"){//��Ͷ��  
				//ɾ������ı��շ� ������Ϣ
				RunMethod("PublicMethod","DeleteFee","A12,<%=sObjectNo%>");
			}else{
				RunMethod("PublicMethod","UpdateColValue","String@FeeRate@<%=CredFeeRateAll%>,ACCT_FEE,String@FeeType@A12@String@ObjectNo@<%=sObjectNo%>");//���շ�
			}
			
			//�˻���Ϣ
			accountDeposit(RepaymentWay,"2");
			
			//������Ʒ����ķ��ü�����Ϣδ������
			var sReturn = RunMethod("LoanAccount","InsertFeeWaive",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>");
			//���ɷſ���
			var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
			RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@<%=sObjectNo%>");//��ͬ��Ч��
			
			if(sReturnFeeBool == "ture"){
				return true;
			}else{
				return false;
			}
		//}
		
	}
	function accountDeposit(RepaymentWay,isCar){
		var sObjectNo="<%=sObjectNo%>";
		//�ۿ��˻���Ϣ
		if(RepaymentWay=="1"){//����
			var accountIndicator1="01";//�ۿ�
			//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
			var sReturn1 = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator1);
			var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//�ۿ��˺�
			var ReplaceName = getItemValue(0,0,"ReplaceName");//�ۿ��˺���
			
			if(sReturn1>0.0){
				RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
			}else{
				var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
				RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
			}
			
		}else {//�Ǵ���
			var accountIndicator2="01";//�ۿ�
			//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
			var sReturn2 = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator2);
			var ReplaceAccount = getItemValue(0,0,"RepaymentNo");//߀���˺�
			var ReplaceName = getItemValue(0,0,"RepaymentName");//�ۿ��˺���
			if (typeof(ReplaceName) == "undefined" || ReplaceName.length == 0 || typeof(ReplaceAccount) == "undefined" || ReplaceAccount.length == 0){
				if(isCar=="1"){
					ReplaceName = "��������";//�ſ��˺���
					ReplaceAccount = "CAR"+"<%=sObjectNo%>";//�ۿ��˺�
				}else{
					ReplaceName = "���Ѵ��ͻ�";//�ſ��˺���
					ReplaceAccount = "XFD"+"<%=sObjectNo%>";//�ۿ��˺�
				}
			}
			if(sReturn2>0.0){
				RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
			}else{
				var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
				RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
			}
		}
		//�ſ��˻�
		var accountIndicator="00";//�ſ�
		//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
		var sReturn3 = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
		var ReplaceAccount = "";
		var ReplaceName = "";
		if(isCar=="1"){
			ReplaceName = "��������";//�ſ��˺���
			ReplaceAccount = "CAR"+"<%=sObjectNo%>";//�ۿ��˺�
		}else{
			ReplaceName = "���Ѵ��ͻ�";//�ſ��˺���
			ReplaceAccount = "XFD"+"<%=sObjectNo%>";//�ۿ��˺�
		}
		if(sReturn3>0){
			RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+ReplaceAccount+"@String@accountno@"+ReplaceName);
		}else{
			var AccountSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
			RunMethod("LoanAccount","CreateDepositAccount",AccountSerialNo+","+"<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT"+","+ReplaceAccount+","+accountIndicator+","+ReplaceName);
		}
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
	
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//�ͻ�����  add  by ybpan  CCS-588  ϵͳ����������ALDIģʽ�Ŀͻ�����
	   setItemValue(0,getRow(),"CustomerHolder","<%=sCustomerHolder%>");
	   setItemValue(0,getRow(),"CustomerHolderName","<%=sCustomerHolderName%>");
		//end
		
		var sMonthRepayment=getItemValue(0,0,"MonthRepayment");
		
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
		if(sOccurType == "060") //���ɽ���
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030" && sObjectType == "CreditApply") //ծ������
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		
		//�����ŵ�
		var sTempFlag = getItemValue(0, 0, "TempSaveFlag");
		var vSSNo = "<%=sSno%>";
		if (sTempFlag == "1" && vSSNo!= "") {
			setItemValue(0,getRow(),"Stores","<%=sSno%>");
			setItemValue(0,getRow(),"StoresName","<%=sSname%>");
			setItemValue(0, getRow(), "SalesManager", "<%=sSalesManager%>");
			setItemValue(0, getRow(), "SalesManagerName", "<%=sSalesManagerName%>");
			setItemValue(0, getRow(), "CityManager", "<%=sCityManager%>");
			setItemValue(0, getRow(), "CityManagerName", "<%=sCityManagerName%>");
			//add �ֽ������
			if("020" == "<%=sProductid%>")
			{
				setItemValue(0,getRow(),"SalesexecutivePhone","<%=sSalesexecutivePhone%>");
			}
			//end
		}
		//���۴���
		var sSalesexecutive="<%=sSalesexecutive%>";
		var sSalesexecutiveName="<%=sSalesexecutiveName%>";

		if(sSalesexecutive == null || sSalesexecutive==""){
			setItemValue(0,getRow(),"Salesexecutive","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"SalesexecutiveName","<%=CurUser.getUserName()%>");
		}else{
			setItemValue(0,getRow(),"Salesexecutive",sSalesexecutive);
			setItemValue(0,getRow(),"SalesexecutiveName",sSalesexecutiveName);
		}

		//���շ���
		setItemValue(0,getRow(),"CreditFeeRate","<%=CredFeeRate%>");
		
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
		var sValue7=sValue5/sValue4; //�׸�����
		setItemValue(0,getRow(),"PaymentRate",sValue7.toFixed(2)*100+"");
		
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//����
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//�Ը����
		var sPeriods = getItemValue(0,getRow(),"Periods");//��������
		var sBusinessType="<%=sBusinessType%>";
		
	    //����������ɿ�ʼ
		
		var commission = getItemValue(0,getRow(),"commission");//���������
		var minload = getItemValue(0,getRow(),"minload");//��ʹ���
		var maxload = getItemValue(0,getRow(),"maxload");//������
		var payment_num = getItemValue(0,getRow(),"payment_num");//��������
		var BusinessType =  getItemValue(0,getRow(),"BusinessType");//��Ʒ���
		if(parseInt(minload) <= parseInt(sBusinessSum) && parseInt(maxload) >= parseInt(sBusinessSum) ){
			if(sPeriods == payment_num){
				var bounes = parseInt(sBusinessSum) * commission;
				setItemValue(0,getRow(),"bonus",bounes);
			}
			//������Щ��Ʒ���ǹ̶����
			var arr = new Array();
			arr[0] = "CDN013";
			arr[1] = "CDN014";
			arr[2] = "CDN015";
			arr[3] = "CDN016";
			arr[4] = "CDN017";
			arr[5] = "CJD013";
			arr[6] = "CJD014";
			arr[7] = "CJD015";
			arr[8] = "CJD016";
			arr[9] = "CJD017";
			arr[10] = "JDN003";
			for(var i=0;i<arr.length; i++){
				if(BusinessType == arr[i]){
					setItemValue(0,getRow(),"bonus",commission);
					break;
				}
			}
		}else{
			setItemValue(0,getRow(),"bonus","");
		}
		//����������ɽ���
		
		if(parseFloat(parseInt(sValue6,10))<parseFloat(sValue6)){
			alert("��������Ϊ����������");
			return;
		}
		
		
		//�����˻�����ѡ�������ʷ� ���շ�
		var YesNo = getItemValue(0, getRow(), "CreditCycle");//�Ƿ�Ͷ��1:�� 2����		
		if(typeof(YesNo) == "undefined" || YesNo.length == 0){
			YesNo = "2";
		}
		
		if(parseFloat(sBusinessSum) < 0.0){
			alert("�Ը��ܽ��ܴ�����Ʒ�ܼ۸�,����!");
			return;
		}
		
		if(parseFloat(sBusinessSum) > 0 && parseFloat(sPeriods) > 0){
			 if(parseFloat(sTotalSum)-parseFloat(sValue4)>0){
				alert("�Ը��ܽ��ܴ��ڴ����ܼ۸�!");
				return;
			}else{
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo);
				//setItemValue(0,getRow(),"MonthRepayment",parseFloat(sMonthPayment).toFixed(0)+"");
				//setItemValue(0,getRow(),"TotalSum2","ת��ǰ��"+parseFloat(sMonthPayment)+"");
				var MonthPaymentBefore = parseFloat(sMonthPayment);
				var MonthPaymentAfter = fix(MonthPaymentBefore);
				//setItemValue(0,getRow(),"BrandType2","ת����"+MonthPaymentAfter+"");
				//update CCS-376 ����������ͬ����-ÿ�»�����ʾ-���治��(�Ļ���������ÿ�»�����)
				//������������ÿ�»�����
				setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
				//end
			}
		}
		//���ñ�����ɽ��
		if(YesNo =='1'){
			setItemValue(0,getRow(),"insur_bonus","15.00");
		}else if(YesNo =='2'){
			setItemValue(0,getRow(),"insur_bonus","");
		}
	}
	
	/*~[Describe=С����λ;InputParam=��;OutPutParam=��;]~*/
	function fix(d) {
		var temp = d * 10;
		var value1 = Math.ceil(parseFloat(temp));//��λȡ��
		var finalyvalue = parseFloat(value1)/10;
		if(d==parseInt(d,10)){
			finalyvalue = d;
		}
		return finalyvalue;
	}
	
	
</script>

<script type="text/javascript">

</script>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
ShowMessage("ϵͳ�����ύ����ȴ�...",true,true);
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	initRow();	
	/*------------------�������JS����---------------*/
	afterLoad("<%=sObjectType%>","<%=sObjectNo%>"); 
	/*------------------�������JS����---------------*/
	saveRecord();
	self.returnValue = "Success";
	self.close();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>