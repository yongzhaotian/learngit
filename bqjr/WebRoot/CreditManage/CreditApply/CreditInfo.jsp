<%@page import="com.amarsoft.app.lending.bizlets.CheckCreditCycle"%>
<%@page import="com.amarsoft.proj.action.P2PCreditCommon"%>
<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
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
		             xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
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
	// Ȩ�޿�����ʾ��ť ReadOnly All
	String sRigthType = CurComp.getAttribute("RightType");
	CurComp.setAttribute("RightType", "All");
	
	String productIdTemp = "";
	//�����������������������Ӧ����������SQL��䡢��Ʒ���͡��ͻ����롢��ʾ���ԡ���Ʒ�汾
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="",sSalesexecutive="",sSalesexecutiveName="";
	//�����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//�������������ҵ����֡�����ҵ�����ա�������ˮ�š���ݺ�
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSno="",sSname="",ssSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCreditId="",sCreditPerson="",sCity="",sAttr2="",sCarfactory="";
	// ��������� �ŵ꾭�����о���
	String sSalesManager = "", sCityManager = "", sSalesManagerName = "", sCityManagerName = "";
	//������� ��CCS-681��ͬ�������ŵ���� add by jiangyuanlin 20150513
    String sStoreCityCode = "";
  	//���Ѵ���ĿCCS-1113 ��ͬ����������Ϣ daihuafeng
	String sStoreCountyCode = "";
    //CCS-681��ͬ�������ŵ���� end
    
    
    
	//�������������ҵ�������ҵ�����ʡ�����ҵ�����
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//���������չ�ڴ��������»��ɴ��������ɽ��´�����ծ���������
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0;
	//�����������Ʒ������
	String sSubProductType = "";
	//¼��ʱ��
	String sInputDate = "";
	//�����������ѯ�����
	ASResultSet rs = null;
	String subProductTypename ="";//������
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

    //�����ŵ�
    //add by xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
	String sNo = "";
	// ���ݺ�ͬ��ȥ���ŵ���Ϣ
	String sql = "SELECT BC.STORES FROM BUSINESS_CONTRACT BC WHERE BC.SERIALNO = :SERIALNO";
	sNo = Sqlca.getString(new SqlObject(sql).setParameter("SERIALNO", sObjectNo));
	if (sNo == null || "".equals(sNo)) {
		sNo = CurUser.getAttribute8();
	}
  	// end by xswang 2015/06/01
  	
   //�ͻ�����    add by ybpan at 20150409 CCS-588  ϵͳ����������ALDIģʽ�Ŀͻ�����
     String sCustomerHolder= Sqlca.getString(new SqlObject("select SalesManNO  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     String sCustomerHolderName= Sqlca.getString(new SqlObject("select getUserName(SalesManNO)  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     
     if(sNo == null) sNo = "";
     if(sCustomerHolder == null) sCustomerHolder = "";
     if(sCustomerHolderName == null) sCustomerHolderName = "";
     
     
     //�޸ĳ��о�������۾�����ϼ�ȡ�á� edit by Dahl 2015-03-17    CCS-681��ͬ�������ŵ����  edit by jiangyuanlin 20150515

     sSql="select si.city as city,getitemname('AreaCode',si.city) as cityName,si.country,si.sno,si.sname, si.SALESMANAGER, getusername(si.SALESMANAGER) as  SALESMANAGERNAME, ui.superId as CITYMANAGER, getusername(ui.superId) as CITYMANAGERNAME from store_info si ,user_info ui where si.salesmanager=ui.userid and sno = :sno and  identtype = '01'";
     
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 sSno = DataConvert.toString(rs.getString("sno"));//�ŵ�
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 sSalesManager = DataConvert.toString(rs.getString("SALESMANAGER"));		// ���۾���
    	 sCityManager = DataConvert.toString(rs.getString("CITYMANAGER")); 	// ���о���
    	 sSalesManagerName = DataConvert.toString(rs.getString("SALESMANAGERNAME"));		// ���۾���
    	 sCityManagerName = DataConvert.toString(rs.getString("CITYMANAGERNAME")); 	// ���о���
    	 sStoreCityCode = DataConvert.toString(rs.getString("city"));//�ŵ����ڳ���  CCS-681��ͬ�������ŵ����

    
       	 sStoreCountyCode = DataConvert.toString(rs.getString("country"));//���Ѵ���ĿCCS-1113 ��ͬ����������Ϣ daihuafeng
    	 //��ӡlog���Ա��Ժ��ͬ�����۾���Ϊ��ʱ���������ݡ� add by Dahl 2015-03-17
    	 ARE.getLog().info("\n"+sObjectNo+"-------�����ŵ�-------"+sNo+"\n-------���۾���-------"+sSalesManager+"\n-------���о���-------"+sCityManager);
    	 
 		//����ֵת���ɿ��ַ���
 		if(sSno == null) sSno = "";
 		if(sSname == null) sSname = "";
 		if (sSalesManager == null) sSalesManager = "";
 		if (sCityManager == null) sCityManager = "";
 		if (sSalesManagerName == null) sSalesManagerName = "";
 		if (sCityManagerName == null) sCityManagerName = "";
 		if (sStoreCityCode == null) sStoreCityCode = "";  //CCS-681��ͬ�������ŵ����


 		if (sStoreCountyCode == null) sStoreCountyCode = "";  //���Ѵ���ĿCCS-1113 ��ͬ����������Ϣ
     }
     rs.getStatement().close();
     System.out.println("sStoreCountyCode=============================="+sStoreCountyCode);
     //���۴�����ϵ��ʽ
     String sSalesexecutivePhone =Sqlca.getString("select MobileTel from user_info where UserID = '"+CurUser.getUserID()+"'");
     if(null == sSalesexecutivePhone) sSalesexecutivePhone = "";
     
     String sCityName = "" ;//����������
     
	  String sCreditAttribute = "";//0002����/0001����/0003������/0004С��ҵ����
     
     //��ѯ���۴���
     sSql="select Salesexecutive,getusername(Salesexecutive) as SalesexecutiveName,ProductID,CreditAttribute,SubProductType,InputDate from business_contract where serialno=:serialno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
     if(rs.next()){
    	 sSalesexecutive = DataConvert.toString(rs.getString("Salesexecutive"));//���۴���ID
    	 sSalesexecutiveName = DataConvert.toString(rs.getString("SalesexecutiveName"));//���۴���Name
    	 
    	 sProductid = DataConvert.toString(rs.getString("ProductID"));//��Ʒ����
    	 productIdTemp = sProductid;
    	 sCreditAttribute =  DataConvert.toString(rs.getString("CreditAttribute"));//��Ʒ����
    	 
    	 sSubProductType = DataConvert.toString(rs.getString("SubProductType"));//��Ʒ������
    	 sInputDate = DataConvert.toString(rs.getString("InputDate"));
 		//����ֵת���ɿ��ַ���
 		if(sSalesexecutive == null) sSalesexecutive = "";
 		if(sSalesexecutiveName == null) sSalesexecutiveName = "";
     }
     rs.getStatement().close();
     
     String ssCity = Sqlca.getString(new SqlObject("select city from store_info si where si.sno=:sno").setParameter("sno", sNo));
   	//��ȡ��������Ϣ(�������������ѽ���ȡֵ�߼�һ��)
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
	String sFlag = "true";
	String productobjectno = sBusinessType+"-V1.0";
	Double CredFeeRate = 0.0;
	Double CredFeeRateAll = 0.0;
	String CredTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(CredTermID==null) CredTermID = "";
	if("".equals(CredTermID)){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
		sFlag = "false";
	}else{
		CredFeeRate = DataConvert.toDouble(Sqlca.getString(new SqlObject("select defaultvalue from product_term_para where paraid='FeeRate' and termid = '"+CredTermID+"' and objectno='"+productobjectno+"' ")));
		CredFeeRateAll = CredFeeRate*iPeriods;
	}
	
	/** add CCS-996��ϵͳ���ݲ�Ʒ���ͺͳ���ƥ�䱣�չ�˾ tangyb 20150928 start */
	String sInsuranceNo = Sqlca.getString(new SqlObject("select InsuranceNo from Business_Contract where serialno = '"+sObjectNo+"' "));
	if(sInsuranceNo==null) sInsuranceNo = "";
	//����Ƿ����Ͷ��
	CheckCreditCycle check = new CheckCreditCycle();
	check.setBusinessType(sBusinessType);
	check.setInsuranceNo(sInsuranceNo);
	String sReturn = check.CreditCycle(Sqlca);
	if(!"true".equals(sReturn)){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
		sFlag = "false";
	}
	/** add CCS-996��ϵͳ���ݲ�Ʒ���ͺͳ���ƥ�䱣�չ�˾ tangyb 20150928 end */
	
	String tTermTemp="",tTerm = "",tLoanFixedRate = "",tHighestFixedRate = "",tShouFuRatio = "",tRateFloat = "", tSectionRatio = "",tDealcomminssion = "",tSalesComminssion="",tDisCountFixedRate="",tSectionFixedRate="";
	
	double cCreditRate = 0.0d;//��������
	//���д����������޸�
	//String cRateValue = Sqlca.getString(new SqlObject("select rateValue from rate_info where ratetype = '010' and rateunit='02' and termunit='020' and status='1' and term='"+tTerm+"' "));
	
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
		//CCS-797 add by clhuang 2015/05/12 ���ۺ�ͬ�б�����Ĵ���ʡ��Ϊ��
		if("0".equals(sSubProductType)){
			String sRepaymentWay = Sqlca.getString(new SqlObject("select RepaymentWay from Business_Contract where serialno='"+sObjectNo+"'"));
			if(sRepaymentWay==null) sRepaymentWay = "";
			if(sRepaymentWay.equals("1")){
				doTemp.setRequired("ReplaceAccount", true);
				doTemp.setRequired("OpenBank",true);
				doTemp.setRequired("OpenBankName",true);
				doTemp.setRequired("ReplaceName",true);
				doTemp.setRequired("CityName",true);//����ʡ��
			}else{
				doTemp.setRequired("ReplaceAccount", false);
				doTemp.setRequired("OpenBank",false);
				doTemp.setRequired("OpenBankName",false);
				doTemp.setRequired("ReplaceName",false);
				doTemp.setRequired("CityName",false);//����ʡ��  
			}
		} 
	  //end by  clhuang
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
	
	String sIsP2p = Sqlca.getString("select isP2p from Business_Contract where SerialNo = '"+sObjectNo+"'");

	//��ȡ�����˵������Ϣ
	String RepaymentNo = "";//�����˺�
	String RepaymentBank = "";//�����˺ſ�����
	String RepaymentName = "";//�����˺Ż���
	String RepaymentBankName = "";
	
	// modified by huangshuo, ��ӻ�ȡԭ�ظ����ֶ�
	// String sCreditid = Sqlca.getString("select CreditID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	String sCreditid = "";
	String isReconsider = "";
	String contractStatus = "";
	sSql = "select CreditID, IsReconsider, ContractStatus from Business_Contract where SerialNo = :SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
	if (rs.next()) {
		sCreditid = rs.getString("CreditID");
		isReconsider = rs.getString("IsReconsider");
		contractStatus = rs.getString("ContractStatus");
	}
	
	boolean checkLog = true;//�Ƿ���Ҫ��ѯ��ʷ��¼��
	sSql = "select pc.backAccountPrefix,pc.turnAccountName,pc.turnAccountBlank,getItemName('LoanSubBank', pc.subBankName) as RepaymentBankName "+
	   "from Service_Providers sp,ProvidersCity pc where sp.SerialNo = :SerialNo "+
	   "and pc.serialno = sp.serialno and pc.areacode = '"+ssCity+"' and pc.ProductType = '"+sSubProductType+"'";
	SqlObject soSer = new SqlObject(sSql).setParameter("SerialNo", sCreditid);
	rs = Sqlca.getASResultSet(soSer);
	if(rs.next()){
		checkLog = false;
		RepaymentNo = rs.getString("backAccountPrefix");
		RepaymentBank = rs.getString("turnAccountBlank");
		RepaymentName = rs.getString("turnAccountName");
		RepaymentBankName = rs.getString("RepaymentBankName");
	}
	rs.getStatement().close();
	//��Ҫ��ѯ��ʷ��¼��
	if(checkLog){
		sSql = "select pc.backAccountPrefix,pc.turnAccountName,pc.turnAccountBlank,getItemName('LoanSubBank', pc.subBankName) as RepaymentBankName "+
				   "from Service_Providers sp,ProvidersCity_Log pc where sp.SerialNo = :SerialNo "+
				   "and pc.serialno = sp.serialno and pc.areacode = '"+ssCity+"' and pc.ProductType = '"+sSubProductType+"' "+
				   "and :InputDate between pc.beginTime and pc.endTime";
		SqlObject soSerLog = new SqlObject(sSql).setParameter("SerialNo", sCreditid).setParameter("InputDate", sInputDate);
		rs = Sqlca.getASResultSet(soSerLog);
		if(rs.next()){
			RepaymentNo = rs.getString("backAccountPrefix");
			RepaymentBank = rs.getString("turnAccountBlank");
			RepaymentName = rs.getString("turnAccountName");
			RepaymentBankName = rs.getString("RepaymentBankName");
		}
		rs.getStatement().close();
	}
	//update CCS-399(���Ѵ�Ĭ����ʾΪ���ĺ�֧�С����ֽ��Ĭ����ʾΪ������֧��  ��;)�� add CCS-1000���Ѵ��е�ѧ������������˽�����ҲĬ����ʾΪ������֧��  �� by huanghui 
	if(RepaymentNo == null || RepaymentNo == "") 
	{
		if("020".equals(sProductid) || "4".equals(sSubProductType) || "5".equals(sSubProductType))//�ֽ�������Ѵ��е�ѧ��������˽�����
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
		if("020".equals(sProductid) || "1".equals(sIsP2p) || "4".equals(sSubProductType) || "5".equals(sSubProductType) )//�ֽ����p2p��  add CCS-1000���Ѵ��е�ѧ������������˽�����ҲĬ����ʾΪ������֧��  �� by huanghui 
		{
			RepaymentBankName = "�������йɷ����޹�˾���ڰ���֧��";
		}else
		{
			RepaymentBankName = "�������������ĺ�֧��";
		}
	}
	if(RepaymentName == null || RepaymentName == "") RepaymentName = "�����а�Ǫ���ڷ������޹�˾";
	//end
	
	RepaymentNo = RepaymentNo+Sqlca.getString("select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	
	//update CCS-399(���Ѵ�Ĭ����ʾΪ���ĺ�֧�С����ֽ��Ĭ����ʾΪ������֧��  ��;)
	/*if("020".equals(sProductid) || "1".equals(sIsP2p) )//�ֽ����p2p
	{
		RepaymentBankName = "�������йɷ����޹�˾���ڰ���֧��";
	}else
	{
		RepaymentBankName = "�������������ĺ�֧��";
	}*/
	//end
		
	
	//��ȡ�ͻ�����״̬
	String sCTempSaveFlag = Sqlca.getString(new SqlObject("select Tempsaveflag from Ind_Info where CustomerID =:CustomerID").setParameter("CustomerID", sCustomerID));
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
		{"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath},
		{"false","All","Button","��ӡ�����","��ӡ�����","creatApplyTable()",sResourcesPath},
		{"false","All","Button","��ӡ���Ӻ�ͬ","��ӡ���Ӻ�ͬ","creatContract()",sResourcesPath},
		{"true","All","Button","�ϴ���Ƭ","�ϴ���Ƭ","imageManage()",sResourcesPath},
		{"false","All","Button","��ӡ����Э��","��ӡ����Э��","creatThirdTable()",sResourcesPath},
		{"true","All","Button","���ɻ�����Ϣ","���ɻ�����Ϣ","generatePaymentInfo()",sResourcesPath}	// Ҫ��Ȩ�޿���
	};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	if ("ReadOnly".equals(sRigthType))  {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		
		if ("060".equals(contractStatus) && !"1".equals(isReconsider)) {
			sButtons[6][0] = "true";
		} else {
			sButtons[6][0] = "false";
		}
		
	}
	
	if("0001".equals(sCreditAttribute)){
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	var loadAmount = "0.00"; 
	var isInsure = "";
/*~[Describe=��ӡ�����;InputParam=��;OutPutParam=��;]~*/
function creatApplyTable(){

		var sObjectNo = "<%=sObjectNo%>";
		sObjectType = "ApplySettle";
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				//���ɳ���֪ͨ��	
				PopPage("/FormatDoc/Report17/03.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	 
}

	/*~[Describe=��ӡ���Ӻ�ͬ;InputParam=��;OutPutParam=��;]~*/
	function creatContract(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = RunMethod("���÷���", "GetColValue", "Business_Contract,ProductId,SerialNo='"+sObjectNo+"'");//getItemValue(0,getRow(),"ProductID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			var sManageUserID = "<%=CurUser.getUserID()%>";
			sParaString = "ManageUserID," +sManageUserID;
			sEDocNo = PopPage("/Common/EDOC/EDocNo.jsp?ObjectType="+sObjectType,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
			sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			
			if(sReturn == "nodef")
			{
				alert("û�ж�Ӧ��ģ�壬���Ӻ�ͬ����ʧ�ܣ�");
				return;
			}
			if(sReturn == "nodoc")
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=150;dialogHeight=100;center:no;status:no;statusbar:no");
			}
			sSerialNo = sReturn;
			OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
			
			reloadSelf();
		}
		
	}

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord() {	
		// ȥ��������ֶκ�����ʾ add by tbzeng 2014/05/03  
		var sTemp = _user_validator[0].rules.BUSINESSSUM.expressions;
		for (var x in sTemp) {
			sTemp[x] = "";
		} 
		// hope fixme carefully

		// add by tbzeng 2014/09/23 
		var regManuExpr = /^[1-9]\d{1,}[e|E][1-9]\d{1,}/i;
		var sManufacturer1 = getItemValue(0, 0, "Manufacturer1");
		var sManufacturer2 = getItemValue(0, 0, "Manufacturer2");
		var sManufacturer3 = getItemValue(0, 0, "Manufacturer3");

		if (regManuExpr.test(sManufacturer1)) {
			alert("�ͺ�1���������ѧ������������ǰ�����������!");
			return;
		}
		if (regManuExpr.test(sManufacturer2)) {
			alert("�ͺ�2���������ѧ������������ǰ�����������!");
			return;
		}
		if (regManuExpr.test(sManufacturer3)) {
			alert("�ͺ�3���������ѧ������������ǰ�����������!");
			return;
		}
	
		//¼��������Ч�Լ��
		if (!ValidityCheck()) {
	  		return;
	  	}
		
		//-- add by CCS-1255 tangyb 20160220 start --//
		//��ֹ�۱������δ��ȡ���ٴμ���
		if(!getSellPrice()){
			return;
		}
		
		//�۱���������֤
		if(!validateBbd()){
			return;
		}
		//-- end --//
		
		// ���ʽѡ����ۣ������ѡ���Ƿ������÷�Χ�� add by tbzeng 2014/09/02
		var sPaymentWay = getItemValue(0, 0, "RepaymentWay");
		if (sPaymentWay == "1") {
			var sOpenBank = RunMethod("���÷���", "GetColValue", "Code_Library,itemno,CodeNo='BankCode' and ISINUSE='1' and itemno='"+getItemValue(0, 0, "OpenBank")+"'");
			if (sOpenBank == "Null") {
				alert("��������ϵͳ�趨������������ѡ����ۿ����У�");
				return;
			}
		}

         //��ͬ���水ť�����ݴ棩�ٴν��д�������£��ĸ��ֶο����п������˺ŵ�У�� ccs708 add by xiaoyp
		 selectWay();

		//��ѡ��ְҵ�������������졢��֤��������ѡ������ʱ���������ӱ�עquliangmao
		var course_Education_training1=getItemValue(0,getRow(),"course_Education_training1");
		if(course_Education_training1=="����"){
			var course_Remarks1=getItemValue(0,getRow(),"course_Remarks1");
			if(!course_Remarks1){
				alert("��������д��ע1");
				return ;
			}
		}
		// end 2014/09/02
		
		var sReturnReplaceAccount = checkReplaceAccount();
		if(sReturnReplaceAccount=="error"){
			return;
		}
		if ("020" == "<%=sProductid%>") {
			ChangePurposeRemark();//������;��ѡ������������ע����
		}
		
		if(vI_all("myiframe0")) {
			var returncheck = CheckSum();// У�������
			if(!returncheck){
				return;
			}
			
			if("01"=='<%=CurUser.getIsCar()%>' &&!CarValidityCheck()){	//�����������У��
				return;			
			}
			
			if (!saveSubItem()) return;// �������У��
			
			//-- add by tangyb CCS-1255 20160220 start ����۱�����Ϣ --//
			if(!saveBbdInfo()) return; 
			//-- end --//
			
			// ���㴦��ʼ��������
			var SerialNo = getItemValue(0, getRow(), "SerialNo");// ��ͬ��ˮ��
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); // �Ƿ�Ͷ��
			var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");// �ۿ��˺�
			var ReplaceName = getItemValue(0,0,"ReplaceName");// �ۿ��˺���
			var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");// ����
			var businessType = getItemValue(0,getRow(),"BusinessType");// ��Ʒ����
			var buyPayPkgind = getItemValue(0,getRow(),"BugPayPkgind");// ���Ļ������
			var openBranch = getItemValue(0,getRow(),"OpenBranch");// ������֧��--CCS-1247 add by zty
			var openBank = getItemValue(0,getRow(),"OpenBank");// ������--CCS-1247 add by zty
			var city = getItemValue(0,getRow(),"City");// ������--CCS-1247 add by zty
			var type = "";
		    if (sCreditCycle != "1") {		// ûѡ��Ͷ����ʱ�򣬲��ж�Ͷ�����Ƿ����ѡ��
		    	var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckCreditCycle", "checkNecessity", "businessType=" + businessType);
		    	if (res == "1") {
		    		alert("�ò�Ʒ����ѡ��Ͷ����");
		    		return;
		    	}
		    } 
			
			if (sBusinessSum != loadAmount || sCreditCycle != isInsure) {
				type = "1";	
				loadAmount = sBusinessSum;
				isInsure = sCreditCycle;
			} else {
				type = "";
			}
			var sParms = "objectNo=" + SerialNo + ",userID=<%=CurUser.getUserID()%>," 
						+ "businessType=<%=sBusinessType%>,creditCycle=" + sCreditCycle 
						+ ",replaceAccount=" + ReplaceAccount + ",replaceName=" + ReplaceName 
						+ ",businessSum=" + sBusinessSum + ",type=" + type + ",org=<%=CurUser.getOrgID() %>"
						+ ",businessType=" + businessType + ",buyPayPkgind=" + buyPayPkgind
						//CCS-1247 add by zty 
						+ ",productId=<%=productIdTemp%>,repaymentWay=" +  sPaymentWay + ",openBranch="+openBranch + ",openBank="+openBank + ",city="+city;
			
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", "initContractLoanInfo", sParms);
			if(sReturn == null || sReturn.length == 0 || sReturn == "Error"){
				alert("��ͬ����ʧ�ܣ�");
				return;
			}
			// setItemValue(0, 0, "MonthRepayment",fix(parseFloat(sReturn)));
			// ���㴦�����
			setItemValue(0,getRow(),"TempSaveFlag","2"); //�ݴ��־��1���ǣ�2����
			beforeUpdate();
			as_save("myiframe0",afterSaveEvent());//���������ִ�еĴ���
			
			//-- add CCS-1255���۱������� tangyb 20160218 start --//
			var subProductType = "<%=sSubProductType%>";
			
			// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
			if("0" == subProductType || "7" == subProductType) {
				var businesstype2 = getItemValue(0, 0, "BusinessType2"); //��Ʒ����2
				
				if(businesstype2 == "2015061500000017") { //�۱�����ӿ���
					operateMobileSerialNumber("1");
				} else {
					setItemReadOnly(0, 0, "TotalSum2", false); //�Ը����2  ��ֻ��
					
					setItemRequired(0, 0, "Price2", false); //�۸�2 ����
					setItemReadOnly(0, 0, "Price2", false); //�۸�2 ��ֻ��
					
					setItemRequired(0, 0, "mobileSerialNumber", false); // �ֻ����� �Ǳ���
					setItemRequired(0, 0, "MODELNO", false); // �۱������� �Ǳ���
					setItemRequired(0, 0, "SERVEYEAR", false); // �ӱ����� �Ǳ���
					
					setItemDisabled(0, 0, "MODELNO", true); // �۱������� ֻ��
					setItemDisabled(0, 0, "SERVEYEAR", true); // �ӱ����� ֻ��
					setItemReadOnly(0, 0, "mobileSerialNumber", true); // �ֻ����� ֻ��
				}
				
				var businessrangename3 = getItemValue(0, 0, "BusinessRangeName3"); //��Ʒ����3
				if(businessrangename3 == null || businessrangename3 == ""){
					setItemRequired(0, 0, "Price3", false); // �ֻ����� �Ǳ���
				}
			}
			//-- end --//
		}
	}
	
	/*~[Describe=���������ִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function afterSaveEvent(){
		if("020" == "<%=sProductid%>"){
			ChangePurposeRemark();
		}
		var iseducation="<%=subProductTypename%>";
		if(iseducation && (iseducation=="5" || iseducation=="4")){
			save_business_education_info();// ���������Ϣ
		}
	}
	 //edit by awang 20150215 CCS-447
	
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
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp() {
		
		var sCreditCycle = getItemValue(0, 0, "CreditCycle"); // �Ƿ�Ͷ��
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");// ����
		
		//-- add by CCS-1255 �۱��� tangyb 20160220 start --//
		//��ֹ�۱������δ��ȡ���ٴμ���
		if(!getSellPrice()){
			return;
		}
		
		// ����۱�����Ϣ
		if(!saveBbdInfo()){
			return; 
		}
		//-- end --//
		
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�2����
		if(!saveSubItem()) return;//�������У��
		as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");   //���ݴ�
		// ����BUSINESS_CREDIT.STATUS type = 0 -- �ݴ�
		var sParms = "objectNo=" + getItemValue(0, 0, "SerialNo") + ",type=0" 
					+ ",userID=<%=CurUser.getUserID() %>,org=<%=CurUser.getOrgID() %>"
					+ ",businessType=<%=sBusinessType%>,creditCycle=" + sCreditCycle
					+ ",businessSum=" + sBusinessSum;	
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
					"updateBusinessCredit", sParms);
		if (sReturn != "SUCCESS") {
			alert("�ݴ�ʧ�ܣ�");
			return;
		}
		var iseducation="<%=subProductTypename%>";
		if(iseducation && (iseducation=="5" || iseducation=="4")){
			save_business_education_info();// ���������Ϣ
		}
		setNeedCheckRequired(0);//����ٽ����������û���
		selectWay();//CCS-797 add by clhuang 2015/05/12 ���ۺ�ͬ�б�����Ĵ���ʡ��Ϊ��
		
		//-- add CCS-1255���۱������� tangyb 20160218 start --//
		var subProductType = "<%=sSubProductType%>";
		
		// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0, 0, "BusinessType2"); //��Ʒ����2
			if(businesstype2 == "2015061500000017") { //�۱�����ӿ���
				operateMobileSerialNumber("1");
			} else {
				setItemReadOnly(0, 0, "TotalSum2", false); //�Ը����2  ��ֻ��
				
				setItemRequired(0, 0, "Price2", false); //�۸�2 ����
				setItemReadOnly(0, 0, "Price2", false); //�۸�2 ��ֻ��
				
				setItemRequired(0, 0, "mobileSerialNumber", false); // �ֻ����� �Ǳ���
				setItemRequired(0, 0, "MODELNO", false); // �۱������� �Ǳ���
				setItemRequired(0, 0, "SERVEYEAR", false); // �ӱ����� �Ǳ���
				
				setItemDisabled(0, 0, "MODELNO", true); // �۱������� ֻ��
				setItemDisabled(0, 0, "SERVEYEAR", true); // �ӱ����� ֻ��
				setItemReadOnly(0, 0, "mobileSerialNumber", true); // �ֻ����� ֻ��
			}

			var businessrangename3 = getItemValue(0, 0, "BusinessRangeName3"); //��Ʒ����3
			if(businessrangename3 == null || businessrangename3 == ""){
				setItemRequired(0, 0, "Price3", false); // �ֻ����� �Ǳ���
			}
		}
		//-- end --//
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

<script type="text/javascript">


/****************************business_education_info**********quliangmao******************/

function save_business_education_info(){
	var putoutno 				= "<%=sObjectNo%>";//��ͬ��
	var course_start_time1 	= getItemValue(0,getRow(),"course_Start_time1");//��ѧʱ��
	var course_consultant_name1 = getItemValue(0,getRow(),"course_consultant_name1");//��������
	var course_consultant_phone1 			= getItemValue(0,getRow(),"course_consultant_phone1");//������ϵ��ʽ
	var is_probation1 					= getItemValue(0,getRow(),"is_probation1");//�Ƿ��Զ�
	var probation_time1 			= getItemValue(0,getRow(),"probation_time1");//�Զ�ʱ�䳤
	var course_education_training1 = getItemValue(0,getRow(),"course_Education_training1");//��ѵĿ��
	var course_remarks1 = getItemValue(0,getRow(),"course_Remarks1");//��ע
	var course_start_time2 = getItemValue(0,getRow(),"course_start_time2");//��ѧʱ��
	var course_consultant_name2 = getItemValue(0,getRow(),"course_consultant_name2");//��������
	var course_consultant_phone2 = getItemValue(0,getRow(),"course_consultant_phone2");//������ϵ��ʽ
	var is_probation2 = getItemValue(0,getRow(),"is_probation2");//�Ƿ��Զ�
	var probation_time2 = getItemValue(0,getRow(),"probation_time2");//�Զ�ʱ�䳤
	var course_education_training2 = getItemValue(0,getRow(),"course_education_training2");//��ѵĿ��
	var course_remarks2 = getItemValue(0,getRow(),"course_Remarks2");//��ע
	var educationPutoutno=RunMethod("���÷���", "GetColValue", "business_education_info,putoutno,putoutno='"+putoutno+"'");
	var 	updateOrinsert="updateEducationInfoByServerNo";//���±�
	if( null== educationPutoutno || ""==educationPutoutno|| "Null"==educationPutoutno){//�ж��Ƿ��Ѿ�����
	updateOrinsert ="InserOrupdateEducationInfoByServerNo";//�����
	}
	var baseRate = RunJavaMethodSqlca("com.amarsoft.app.billions.InserOrupdateEducationInfo", updateOrinsert,
			"putoutno="+putoutno+",course_start_time1="+course_start_time1+",course_consultant_name1="+course_consultant_name1+
			",course_consultant_phone1="+course_consultant_phone1+",is_probation1="+is_probation1+",probation_time1="+probation_time1+
			",course_education_training1="+course_education_training1+",course_remarks1="+course_remarks1+
			",course_start_time2="+course_start_time2+",course_consultant_name2="+course_consultant_name2+
			",course_consultant_phone2="+course_consultant_phone2+",is_probation2="+is_probation2+",probation_time2="+probation_time2+
			",course_education_training2="+course_education_training2+",course_remarks2="+course_remarks2+",updateby="+"<%=CurUser.getUserID()%>"+",createby="+"<%=CurUser.getUserID()%>");
}
/****************************business_education_info****************************/

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function CheckSum()
	{	
		var temBusinessSum = getItemValue(0, getRow(), "BusinessSum");
		var LowPrinciPalMin = "<%=LowPrinciPalMin%>";
		var TallPrinciPalMax = "<%=TallPrinciPalMax%>";
		var ShoufuRatio = "<%=ShoufuRatio%>";//��Ʒ�׸�����
		
		//-- add by tangyb CCS-1255�Ƚϴ�����߶�ȣ�������ȥ�۱�������� 20160220 start --//
		var subProductType = "<%=sSubProductType%>";
		// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0, 0,"BusinessType2");
			if("2015061500000017" == businesstype2){ //2015061500000017[�۱���]
				var businessSum2 = getItemValue(0, 0, "BusinessSum2"); //�����2
				temBusinessSum = parseFloat(temBusinessSum) - parseFloat(businessSum2);
			}
		}
		//-- end --//
		
		if(parseFloat(temBusinessSum) > parseFloat(TallPrinciPalMax) || parseFloat(temBusinessSum) < parseFloat(LowPrinciPalMin)){
			alert("�������ڲ�Ʒ�ĵ���ͺ���߷�Χ�ڣ���ȷ�ϣ�");
			return false;
		}
		
		var ShoufuRatioType = "<%=ShoufuRatioType%>";//1:�̶�����2:��ͱ���3:�̶����
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//����
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//�Ը����
		
		var sPaymentRate = getItemValue(0,getRow(),"PaymentRate");//��ͬ�׸�����
		if(ShoufuRatioType=="1"){
			if(parseFloat(sPaymentRate) == parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("�׸�����������ڲ�Ʒ�׸�������"+ShoufuRatio+"%");
				return false;
			}
		}else if(ShoufuRatioType=="2"){
			if(parseFloat(sPaymentRate) >= parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("�׸�����������ڵ��ڲ�Ʒ�׸�������"+ShoufuRatio+"%");
				return false;
			}
		} else if (ShoufuRatioType=="3") {
			if(parseFloat(sTotalSum) == parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("�׸���������ڲ�Ʒ�׸���"+ShoufuRatio+"Ԫ");
				return false;
			}
		} else if (ShoufuRatioType=="4") {
			if(parseFloat(sTotalSum) >= parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("�׸���������ڵ��ڲ�Ʒ�׸���"+ShoufuRatio+"Ԫ");
				return false;
			}
		}
		
		return true;
	}

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
		//
		sReplaceName = getItemValue(0,getRow(),"ReplaceName");//����/�ſ��˺Ż���
		sRepaymentWay = getItemValue(0,getRow(),"RepaymentWay");//���ʽ
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//�ͻ�����
		//alert(sReplaceName+"---"+sCustomerName+"----"+sRepaymentWay);
		
		if(sRepaymentWay == "1" && sReplaceName != sCustomerName){
			alert("�ǿͻ����˵����п����ܰ������д���ҵ��!");
			return false;
		}
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//����
		if(parseFloat(sBusinessSum) < 0.0){
			alert("�������С����!");
			return false;
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
	/* function selectCategoryID()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange1@0@BusinessRangeName@1",0,0,"");
	} */
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
		/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCategoryID()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		//sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
//		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange1@0@BusinessRangeName@1",0,0,"");
		
		sCompID = "CreditCategoryList";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessType="+sBusinessType,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessRangeName","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinessRange1",""); //�����Ʒ����1����
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinessRange1",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName",sReturn[1]);
	}
	
	//-- add CCS-1255���۱������� tangyb 20160218 start --//
	/**
	 * add by tangyb CCS-1255 20160220 
	 * ��ȡ�۱����ۼ�
	 */
	function getSellPrice() {
		var subProductType = "<%=sSubProductType%>";
		// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
		if("0" == subProductType || "7" == subProductType) {
			var modelno = getItemValue(0, 0, "MODELNO"); //�۱�������
			var serveyear = getItemValue(0,0,"SERVEYEAR");//�ӱ�����
			
			modelno = modelnoCheck(modelno); //add �ֻ������ظ���� PRM-837 tangyb 20160418
			
			if((modelno != null && modelno != "" && modelno != "undefined")
					&& (serveyear != null && serveyear != "" && serveyear != "undefined")){
				var modelInfo = RunMethod("���÷���", "GetColValue", "bbd_model_cost_config,price ||','||deduct,modelno = '"+modelno+"' AND serveyear = '"+serveyear+"'");
				if(modelInfo != null && modelInfo != "" && modelInfo != "Null"){
					var modelInfos = modelInfo.split(",");
					
					var price = modelInfos[0]; // �۱����ۼ�
					var deduct = modelInfos[1]; // �������
					
					setItemValue(0,0,"Price2", price);//�۸�2
					setItemValue(0,0,"BusinessSum2", price);//�����2
					setItemValue(0,0,"DEDUCT", deduct);//�������
					
					//����ÿ�»����,�Ը���������ܼ۸�����
					getMonthPayment();
				} else {
					setItemValue(0, 0, "SERVEYEAR", "");//�ӱ�����
					alert("��ѡ����͵��ӱ����޷���δ����");
					return false;
				}
			}
		}
		return true;
	}
	
	/**
	 * add by tangyb CCS-1255 20160220 
	 * ��Ʒ���Ͱ۱�������
	 * flag[0:�ǰ۱���,1:�۱���]
	 */
	function operateMobileSerialNumber(flag){
		var subProductType = "<%=sSubProductType%>";
		// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
		if("0" == subProductType || "7" == subProductType) {
			if("1" == flag){ // �۱���
				setItemValue(0, 0, "TotalSum2", "0"); //�Ը����2  
				setItemReadOnly(0, 0, "TotalSum2", true); //�Ը����2  ֻ��
				
				setItemRequired(0, 0, "Price2", true); //�۸�2 ����
				setItemReadOnly(0, 0, "Price2", true); //�۸�2 ֻ��
				
				setItemRequired(0, 0, "MODELNO", true); // �۱������� ����
				setItemRequired(0, 0, "SERVEYEAR", true); // �ӱ����� ����
				setItemRequired(0, 0, "mobileSerialNumber", true); // �ֻ����� ����
				
				setItemDisabled(0, 0, "MODELNO", false); // �۱������� ��ֻ��
				setItemDisabled(0, 0, "SERVEYEAR", false); // �ӱ����� ��ֻ��
				
				setItemReadOnly(0, 0, "mobileSerialNumber", false); // �ֻ����� ��ֻ��
			}else{
				setItemValue(0, 0, "TotalSum2", ""); //�Ը����2 
				setItemReadOnly(0, 0, "TotalSum2", false); //�Ը����2  ��ֻ��
				
				setItemRequired(0, 0, "Price2", false); //�۸�2 �Ǳ���
				setItemReadOnly(0, 0, "Price2", false); //�۸�2 ��ֻ��
				
				setItemRequired(0, 0, "mobileSerialNumber", false); // �ֻ����� �Ǳ���
				setItemRequired(0, 0, "MODELNO", false); // �۱������� �Ǳ���
				setItemRequired(0, 0, "SERVEYEAR", false); // �ӱ����� �Ǳ���
				
				setItemDisabled(0, 0, "MODELNO", true); // �۱������� ֻ��
				setItemDisabled(0, 0, "SERVEYEAR", true); // �ӱ����� ֻ��
				setItemReadOnly(0, 0, "mobileSerialNumber", true); // �ֻ����� ֻ��
				
				setItemValue(0, 0, "MODELNO", ""); //�۱������� 
				setItemValue(0, 0, "SERVEYEAR", ""); //�ӱ����� 
				setItemValue(0, 0, "Price2", ""); //�۸�2 
				setItemValue(0, 0, "BusinessSum2", "0"); //�����2
				setItemValue(0, 0, "mobileSerialNumber", ""); //�ֻ�����
				
				//����ÿ�»����,�Ը���������ܼ۸�����
				getMonthPayment();
			}
		}
	}
	
	/**
	 * add by tangyb CCS-1255 20160220 
	 * �۱���������֤
	 */
	function validateBbd(){
		var subProductType = "<%=sSubProductType%>"; //�Ӳ�Ʒ���ʹ���
		
		// ��ͨ���Ѵ���ѧ�����Ѵ�
		if(subProductType == "0" || subProductType == "7") {
			var storeCityCode = "<%=sStoreCityCode%>"; //�ŵ����ڵĳ���
			var businesstype1 = getItemValue(0, 0, "BusinessType1"); //��Ʒ����1
			var businesstype2 = getItemValue(0, 0, "BusinessType2"); //��Ʒ����2
			var businesstype3 = getItemValue(0, 0, "BusinessType3"); //��Ʒ����3
			
			//��Ʒ����1����Ʒ����3ѡ��۱���2015061500000017[�۱���]
			if(businesstype1 == "2015061500000017" || businesstype3 == "2015061500000017"){
				alert("�۱��������������Ʒ��Ϣ2��ѡ��");
				return false;
			}
			
			//��Ʒ����2ѡ��۱���2015061500000017[�۱���]
			if(businesstype2 == "2015061500000017") { 
				var serveyear = getItemValue(0, 0, "SERVEYEAR"); //�ӱ�����
				var modelno = getItemValue(0, 0, "MODELNO"); //�ٱ�������
				var price2 = getItemValue(0, 0, "Price2"); //�۸�2
				var mobileserialnumber = getItemValue(0, 0, "mobileSerialNumber"); //�ֻ�����
				var businessRangeName1 = getItemValue(0, 0, "BusinessRangeName"); //��Ʒ����1
				
				var businessrange1 = getItemValue(0, 0, "BusinessRange1"); //��Ʒ����1
				var businessRangeName3 = getItemValue(0, 0, "BusinessRangeName3"); //��Ʒ����3
				
				if(serveyear == null || serveyear == "" || serveyear == "undefined"){
					alert("�ӱ����޲���Ϊ��");
					return false;
				}
				
				if(modelno == null || modelno == "" || modelno == "undefined"){
					alert("�ٱ������Ͳ���Ϊ��");
					return false;
				}
				
				if(price2 == null || price2 == "" || price2 == "undefined"){
					alert("�۸�2����Ϊ��");
					return false;
				}
				
				if(mobileserialnumber == null || mobileserialnumber == "" || mobileserialnumber == "undefined"){
					alert("�ֻ����Ų���Ϊ��");
					return false;
				} else {
					if(mobileserialnumber.length != 15 && mobileserialnumber.length != 17){
						alert("�ֻ����ų��ȱ���Ϊ15λ��17λ ");
						return false;
					}
					
					//--add �ֻ������ظ���� PRM-837 tangyb 20160418 start--//
					var serialno = getItemValue(0,0,"SerialNo"); //��Լ���
					var checkParams = "mobnumber="+mobileserialnumber+",serialno="+serialno;
					var msginfo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BaibaobagManageInfo", "mobnumberCheck", checkParams);
					if(msginfo != ""){
						alert(msginfo);
						return false;
					}
					//-- end --//
				}
				
				if(businessRangeName1 == null || businessRangeName1 == "" || businessRangeName1 == "undefined"){
					alert("��Ʒ����1����Ϊ��");
					return false;
				}
				
				// ��֤��Ʒ�����Ƿ�����ѡ��۱�������
				var params = "businessrange1="+businessrange1;
				var msgInfo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BaibaobagManageInfo", "bbdBusinessCheck", params);
				if(msgInfo != "" && msgInfo != null){
					alert(msgInfo);
					return false;
				}
				
				if((businessRangeName3 != null && businessRangeName3 != "")
						|| (businesstype3 != null && businesstype3 != "")){
					alert("ѡ��۱���������Ʒ��Ϣ3����������д��Ϣ");
					return false;
				}
				
				// ��ȡ���ŵ����ڳ��ж�Ӧ�İ۱�����Ӧ��
				var providerId = RunMethod("���÷���", "GetColValue", "bbd_provider_relative_city,provider_id,status='1' and city_id='"+storeCityCode+"'");
				if(providerId == null || providerId == "" || providerId == "Null"){
					alert("���ŵ����ڵĳ��л�δ�ṩ�۱�������");
					return false;
				}
				
				setItemValue(0, 0, "PROVIDER_ID", providerId);  //��Ӧ��ID
			}
		} 
		return true;
	}
	
	/**
	 * add by tangyb CCS-1255 20160220 
	 * �۱�����Ϣ����
	 */
	function saveBbdInfo(){
		var subProductType = "<%=sSubProductType%>";
		
		// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
		if("0" == subProductType || "7" == subProductType) {
			var userid = "<%=CurUser.getUserID()%>"; //�����û�
			var serialno = getItemValue(0, getRow(), "SerialNo");// ��ͬ��ˮ��
			var typename2 =  getItemValue(0, 0,"BusinessType2"); //��Ʒ����2
			var mobnumber =  getItemValue(0, 0,"mobileSerialNumber"); //�ֻ�����
			var providerid =  getItemValue(0, 0,"PROVIDER_ID"); //��Ӧ��ID
			var serveyear =  getItemValue(0, 0,"SERVEYEAR"); //�ӱ�����
			var modelno =  getItemValue(0, 0,"MODELNO"); //�ٱ������ͱ���
			var price =  getItemValue(0, 0,"Price2"); //�۸�2(�ٱ����ۼ�)
			var deduct =  getItemValue(0, 0,"DEDUCT"); //�������
			
			// �۱�����Ϣ�������
			var parms = "serialno="+serialno+",userid="+userid+",typename2="+typename2+",mobnumber="+mobnumber
					+",providerid="+providerid+",serveyear="+serveyear+",modelno="+modelno+",price="+price+",deduct="+deduct;
			
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BaibaobagManageInfo", "saveBbdInfo", parms);
			if(sReturn == "Error"){
				alert("�۱�����Ϣ����ʧ�ܣ�");
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * add PRM-837���ֻ������ظ���� tangyb 20160418 
	 * ��֤�ֻ��۸���۱��������Ƿ�ƥ��
	 */
	function modelnoCheck(modelno){
		var price =  getItemValue(0, 0,"Price1"); //�۸�1(�ֻ��۸�)
		
		//�ֻ��۸�Ϊ��
		if(price != null && typeof(price) != "undefined" && sReturn != ""){
			
			//��ƻ������(����)
			if(modelno == "2001" || modelno == "2002"){
				if(parseFloat(price) > 2500){
					modelno = "2001"; //2001:�������ֻ���Ʒ�۸�2500Ԫ����
				} else {
					modelno = "2002"; //2002:�������ֻ���Ʒ�۸�2500Ԫ������
				}
				
				setItemValue(0, 0, "MODELNO", modelno); //��ֵ�۱�������
			}
		}
		
		return modelno;
	}
	//-- add ccs-1255 tangyb 20160220 end --//
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectTypeID()
	{
		sBusinessRange1 = getItemValue(0,0,"BusinessRange1");
		
		if(typeof(sBusinessRange1) == "undefined" || sBusinessRange1 == "")
		{
			alert("����ѡ�񷶳�1����!");
			return;
		}
		sCompID = "CreditCategoryList1";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList1.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessRange1="+sBusinessRange1,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessTypeName","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinessType1",""); //�������1����
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType1",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName",sReturn[1]);
	    
	  //���ǰ�����Ʒ���������룬��۸�Ϊ��ѡ��
	    var sBusinessTypeName=getItemValue(0,getRow(),"BusinessTypeName");
	    
	    if(typeof(sBusinessTypeName) == "undefined" || sBusinessTypeName.length==0){
			return false;
		}else{
			setItemRequired(0, 0, "Price1", true);
		}
//		sParaString = "ProductcategoryID"+","+sBusinessRange1;
		//���÷��ز��� 
//		setObjectValue("SelectMoldType",sParaString,"@BusinessType1@0@BusinessTypeName@1",0,0,"");
	}
	
	
	function selectCategoryID2()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");
		
		sCompID = "CreditCategoryList";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessType="+sBusinessType,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessRangeName2","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinessRange2",""); //�����Ʒ����2����
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinessRange2",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName2",sReturn[1]);

//		sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
//		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange2@0@BusinessRangeName2@1",0,0,"");
	}
	
	function selectTypeID2()
	{
		sBusinessRange2 = getItemValue(0,0,"BusinessRange2");
		
		if(typeof(sBusinessRange2) == "undefined" || sBusinessRange2 == "")
		{
			alert("����ѡ�񷶳�2����!");
			return;
		}

		sCompID = "CreditCategoryList1";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList1.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessRange1="+sBusinessRange2,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	setItemValue(0,0,"BusinessTypeName2","");
	    	 
			//-- add by tangyb ccs-1255 start --//
			setItemValue(0,0,"BusinessType2",""); //�������2����
			operateMobileSerialNumber("0");
			//-- end --//
	    	return;
	    }
	    setItemValue(0,0,"BusinessType2",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName2",sReturn[1]);
	  //���ǰ�����Ʒ���������룬��۸�Ϊ��ѡ��
	    var sBusinessTypeName2=getItemValue(0,getRow(),"BusinessTypeName2");
	    
	    if(typeof(sBusinessTypeName2) == "undefined" || sBusinessTypeName2.length==0){
			return false;
		}else{
			//-- add by tangyb ccs-1255 20160220 start --//
			var businesstype2=getItemValue(0,getRow(),"BusinessType2"); // ��Ʒ����
			if("2015061500000017" == businesstype2){ //2015061500000017[�۱���]
				operateMobileSerialNumber("1");
			}else{
				operateMobileSerialNumber("0");
			}
			//-- end --//
		}
//	    sParaString = "ProductcategoryID"+","+sBusinessRange2;
		//���÷��ز��� 
//		setObjectValue("SelectMoldType",sParaString,"@BusinessType2@0@BusinessTypeName2@1",0,0,"");
	}
	
	
	function selectCategoryID3()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");
		
		sCompID = "CreditCategoryList";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessType="+sBusinessType,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessRangeName3","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinesSrange3",""); //�����Ʒ����3����
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinesSrange3",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName3",sReturn[1]);

//		sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
//		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange3@0@BusinessRangeName3@1",0,0,"");
	}
	
	function selectTypeID3()
	{
		sBusinessRange3 = getItemValue(0,0,"BusinesSrange3");
		if(typeof(sBusinessRange3) == "undefined" || sBusinessRange3 == "")
		{
			alert("����ѡ�񷶳�3����!");
			return;
		}

		sCompID = "CreditCategoryList1";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList1.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessRange1="+sBusinessRange3,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	setItemValue(0,0,"BusinessTypeName3","");
	    	 
	    	//-- add by tangyb ccs-1255 20160220 start --//
	    	setItemValue(0,0,"BusinessType3",""); //�������3����
	    	setItemRequired(0, 0, "Price3", false); //�۸�3 �Ǳ���
	    	//-- end --//
	    	 
	    	return;
	    }
	    setItemValue(0,0,"BusinessType3",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName3",sReturn[1]);
	    
	  //���ǰ�����Ʒ���������룬��۸�Ϊ��ѡ��
	    var sBusinessTypeName3=getItemValue(0,getRow(),"BusinessTypeName3");
	    
	    if(typeof(sBusinessTypeName3) == "undefined" || sBusinessTypeName3.length==0){
			return false;
		}else{
			setItemRequired(0, 0, "Price3", true);
		}
//		sParaString = "ProductcategoryID"+","+sBusinessRange3;
		//���÷��ز��� 
//		setObjectValue("SelectMoldType",sParaString,"@BusinessType3@0@BusinessTypeName3@1",0,0,"");
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
	
	// ѡ�������
	function getBankCodeName() {
		
		var sPayWay = getItemValue(0, 0, "RepaymentWay");
		var sCompID = "SelectWithholdBankCodeList";
		var sCompURL = "/CreditManage/CreditApply/SelectWithholdBankCodeList.jsp";
		var sParaString="PayWay=" + sPayWay;
		
		var sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		if (sReturn) {
			var sReturn = sReturn.split("@");
			var sOpenBank = sReturn[0];		//
			var sOpenBankName = sReturn[1];		//
			setItemValue(0,0,"OpenBank",sOpenBank);
			setItemValue(0,0,"OpenBankName",sOpenBankName);	
		} else {
			setItemValue(0,0,"OpenBank","");
			setItemValue(0,0,"OpenBankName","");			
		}
		//add CCS-368 �ֽ���ſ���Ҫ�ṩ֧�д�����Ϣ���ܷſϵͳ�����ӷſ��֧����Ϣ
		if("020" == "<%=sProductid%>")
		{
			setItemValue(0,0,"OpenBranch","");
			setItemValue(0,0,"OpenBranchName","");
		}
		//end
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
		
		sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sReturn=="undefined@undefined"){
			sReturn="@";
		}
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"OpenBranch",sBankNo);
		setItemValue(0,0,"OpenBranchName",sBranch);
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
			setItemRequired(0,0,"OpenBankName",true);
			setItemRequired(0,0,"ReplaceName",true);
			setItemRequired(0,0,"CityName",true);//����ʡ��
		}else{
			setItemRequired(0,0,"ReplaceAccount",false);
			setItemRequired(0,0,"OpenBank",false);
			setItemRequired(0,0,"OpenBankName",false);
			setItemRequired(0,0,"ReplaceName",false);
			setItemRequired(0,0,"CityName",false);//����ʡ��
		}
	}
	
	//add  wlq   У��ſ��˺ų��� 20140814  
	function checkReplaceAccount(){
		var sReplaceAccount =getItemValue(0,getRow(),"ReplaceAccount");
		sRepaymentWay = getItemValue(0,0,"RepaymentWay");
		sReplaceAccount=sReplaceAccount+"";
		
		if(sRepaymentWay=="1"){
			var tst = /^\d+$/;
			if(!tst.test(sReplaceAccount)){
				alert("����/�ſ��˺ű��������֣�");
				return "error";
			}
			//add by pli 2015/04/09 CCS-609 ��˶ϵͳ֧�ִ����������ӡ����������С�
			//������ѡ�񡱹��������йɷ����޹�˾��Ϊ�ͻ������п������к󣬶Դ����˻��˺ſ������ж����������ж�:��д���˺�Ϊ��625952����ͷ���ҿ���Ϊ16λ
			//update by huanghui 2015/12/01 PRM-668���д��ۿ�У������  ����ǰ12λ������625952100000�����ֿ�ͷ��
			var sOpenBank = getItemValue(0,getRow(),"OpenBank");//�������д���
			if((typeof(sOpenBank) != "undefined" || sOpenBank.length != 0)&&sOpenBank=="142"){//ѡ���˹�����������Ϊ��������
				if(typeof(sReplaceAccount) == "undefined" || sReplaceAccount.length == 0||sReplaceAccount.substring(0,12)!="625952100000"){
					alert("����/�ſ��˺ű����ԡ�625952100000����ͷ��");
					return "error";
				}else if(sReplaceAccount.length!=16){
					alert("����/�ſ��˺ų��ȱ���Ϊ16λ��");
					return "error";
				}
			}else if(sReplaceAccount.length<16||sReplaceAccount.length>19){
				alert("����/�ſ��˺ų�����16-19λ֮�䣡");
				return "error";
			}
			//end by pli
			if(typeof(sReplaceAccount) != "undefined" || sReplaceAccount.length != 0){
				var sFirstStr=sReplaceAccount.substring(0,1);
			if(sFirstStr=="5"){
				alert("����/�ſ��˺Ų�����5��ͷ��");
				return "error";
			}
			//end
			}
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
		selectCreditRates();
	}
	
	//�����ͺŴ���
	function selectCarCode(){
		//���÷��ز��� 
		setObjectValue("SelectCarCode","","@CarCode@0@CarBrand@1@CartypeDescribe@2@CarSeries@3@CarPrice@4@CarBody@5@Enginecapacity@6@ProductionYear@7@CarColour@8",0,0,"");
		selectSalvageSum();//���������ֵ��������
		selectSalvageRatio();
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
	
	/*~[Describe=������ʼ������;InputParam=��;OutPutParam=��;]~*/
	function carInitRow()
	{
		setItemValue(0,getRow(),"IntereStrate","<%=sRateType%>");//��������
		setItemValue(0,getRow(),"Periods","<%=tTerm%>");//��������
		setItemValue(0,getRow(),"CreditRate","<%=cCreditRate%>");//��������
		//setItemValue(0,getRow(),"PaymentRate","<%=tShouFuRatio%>");//�׸�����
		setItemValue(0,getRow(),"FinalPayment","<%=tSectionRatio%>");//β�����
		
	}
	
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow() {
		//-- add by tangyb CCS-1255 ��ʼ���۱�����Ϣ 20160220 start --//
		var subProductType = "<%=sSubProductType%>";
		
		// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0,getRow(),"BusinessType2"); //��Ʒ����2
			
			if("2015061500000017" == businesstype2){ //�۱���[2015061500000017]
				operateMobileSerialNumber("1");
			} else {
				setItemReadOnly(0, 0, "TotalSum2", false); //�Ը����2  ��ֻ��
				
				setItemRequired(0, 0, "Price2", false); //�۸�2 ����
				setItemReadOnly(0, 0, "Price2", false); //�۸�2 ��ֻ��
				
				setItemRequired(0, 0, "mobileSerialNumber", false); // �ֻ����� �Ǳ���
				setItemRequired(0, 0, "MODELNO", false); // �۱������� �Ǳ���
				setItemRequired(0, 0, "SERVEYEAR", false); // �ӱ����� �Ǳ���
				
				setItemDisabled(0, 0, "MODELNO", true); // �۱������� ֻ��
				setItemDisabled(0, 0, "SERVEYEAR", true); // �ӱ����� ֻ��
				setItemReadOnly(0, 0, "mobileSerialNumber", true); // �ֻ����� ֻ��
			}
			
			var bbdinfo = RunMethod("���÷���", "GetColValue", "bbd_treasurebag_info,mobile_serial_number||'@'||provider_id||'@'||modelno||'@'||deduct||'@'||serveyear,SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");
			if(null != bbdinfo && "" != bbdinfo && "Null" != bbdinfo){
				var bbdinfos = bbdinfo.split("@");
				setItemValue(0, getRow(), "mobileSerialNumber", bbdinfos[0]); // �ֻ�����
				setItemValue(0, getRow(), "PROVIDER_ID", bbdinfos[1]); // ��Ӧ��ID
				setItemValue(0, getRow(), "MODELNO", bbdinfos[2]); // �ٱ������ͱ���
				setItemValue(0, getRow(), "DEDUCT", bbdinfos[3]); // �������
				setItemValue(0, getRow(), "SERVEYEAR", bbdinfos[4]); // �ӱ�����
			}
		}
		//-- add by tangyb CCS-1255 ��ʼ���۱�����Ϣ 20160220 end --//
		
		//�ͻ�����  add  by ybpan  CCS-588  ϵͳ����������ALDIģʽ�Ŀͻ�����
	   setItemValue(0,getRow(),"CustomerHolder","<%=sCustomerHolder%>");
	   setItemValue(0,getRow(),"CustomerHolderName","<%=sCustomerHolderName%>");
		//end
	//������;��ѡ������������ע���ݱ���
	   if("020" == "<%=sProductid%>"){
			ChangePurposeRemark();
			}
		var sMonthRepayment=getItemValue(0,0,"MonthRepayment");
		if(<%=sCreditAttribute%>=="0001"){
			carInitRow();
		}
		//add �ֽ��
		if("020" == "<%=sProductid%>"&&(sMonthRepayment==null 
							|| "" == sMonthRepayment)) {//update ����sMonthRepaymentΪ�յ���� 20150515
			CashLoanGetMonthPayment();
		} 
		//end
		if ("020" != "<%=sProductid%>" && (sMonthRepayment == null || "" == sMonthRepayment)) {
			getMonthPayment();
		}
		
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
		if(sObjectType == "ReinforceContract" && (typeof(sManageUserID) == "undefined"
				|| sManageUserID == "")) {
			setItemValue(0, getRow(), "ManageUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0, getRow(), "ManageUserName", "<%=CurUser.getUserName()%>");
		}
		if(sObjectType == "ReinforceContract" && (typeof(sPutOutOrgID) == "undefined"
				|| sPutOutOrgID == "")){
			setItemValue(0, getRow(), "PutOutOrgID", "<%=CurOrg.getOrgID()%>");
			setItemValue(0, getRow(), "PutOutOrgName", "<%=CurOrg.getOrgName()%>");
		}
		if(sObjectType == "ReinforceContract" && (typeof(sInputUserID) == "undefined"
				|| sInputUserID == "")){
			setItemValue(0, getRow(), "InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0, getRow(), "InputUserName", "<%=CurUser.getUserName()%>");
		}
		if(sObjectType == "ReinforceContract" && (typeof(sOperateUserID) == "undefined"
				|| sOperateUserID == "")){
			setItemValue(0, getRow(), "OperateUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0, getRow(), "OperateUserName", "<%=CurUser.getUserName()%>");
		}
		var sBusinessCurrency = getItemValue(0, getRow(), "BusinessCurrency");
		if(isNull(sBusinessCurrency)){
			setItemValue(0,getRow(),"BusinessCurrency","01");
			sBusinessCurrency="01";
		}	
		var sBaseRateType = getItemValue(0,getRow(),"BaseRateType");
		if(isNull(sBaseRateType)){
			//����Ϊ�����,��׼������������Ϊ���л�׼����,�ų�����ҵ�񡢳���˾ί�д����typeno��2��ͷ��ҵ�񡢸��˹���������������֤��������������֤����������ͥ�������������������֤��������������֤�����򷽴���
			if (sBusinessCurrency == "01" && !(!isNull(sBusinessType) 
					&& (sBusinessType.indexOf("1020") == 0 || sBusinessType.indexOf("3") == 0 
					|| (sBusinessType.indexOf("2") == 0 && sBusinessType != "2070")) 
					|| ",1110180,1080005,1080007,1080060,1080410,1090010,1090030".indexOf(sBusinessType) > 0)) {
				setItemValue(0, getRow(), "BaseRateType", "010");
			}
		}	

        //����"��ͥ��"ҵ��ʱ�����"Ʊ�ݱ���"ֵΪ�գ�������Ϊ������
        if (sBusinessType == "1080060") {
            var sTradeCurrency = getItemValue(0,getRow(),"TradeCurrency");
            if (sTradeCurrency == "") {
                setItemValue(0,getRow(),"TradeCurrency","01");
           }
        }
				
		if(sBusinessType == "1100010" && sObjectType == "CreditApply") {
			setItemValue(0,getRow(),"BusinessSum",0);
		}
		
		if(sOccurType == "015" && sObjectType == "CreditApply") { //չ��ҵ��
		
			setItemValue(0,getRow(),"Relativeagreement","<%=dOldSerialNo%>");
			setItemValue(0,getRow(),"TotalSum","<%=dOldBusinessSum%>");
			setItemValue(0,getRow(),"BusinessSum","<%=dOldBalance%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"BaseRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
		
		if(sOccurType == "020") { //���»���
			//setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060") { //���ɽ���
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030" && sObjectType == "CreditApply") { //ծ������
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
		//CCS-681 ��ͬ�������ŵ���� �����Ӻ�ͬʱ����  jiangyuanlin20150515 ����
	    setItemValue(0,getRow(),"StoreCityCode","<%=sStoreCityCode%>");
	    //CCS-681 ��ͬ�������ŵ����  end
	    //���Ѵ���ĿCCS-1113 ��ͬ����������Ϣ daihuafeng begin
	    setItemValue(0,getRow(),"StoreCountyCode","<%=sStoreCountyCode%>");
	  	//���Ѵ���ĿCCS-1113 ��ͬ����������Ϣ daihuafeng end 
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

		//modify by jli5 Ĭ��ֵչʾ�߼�����
		//չ��
		var ExhibitionHall = getItemValue(0,getRow(),"ExhibitionHall");
		if(typeof(ExhibitionHall) !="undefind" && ExhibitionHall==""){
			setItemValue(0,getRow(),"ExhibitionHall","<%=ssSno%>");
			setItemValue(0,getRow(),"ExhibitionHallName","<%=ssSname%>");
		}
		//����������
		var DealerName = getItemValue(0,getRow(),"DealerName");
		if(typeof(DealerName) !="undefind" && DealerName==""){
			setItemValue(0,getRow(),"DealerName","<%=sServiceprovidersname%>");
		}
				
		//��������������
		var DealerGroup = getItemValue(0,getRow(),"DealerGroup");
		if(typeof(DealerGroup) !="undefind" && DealerGroup==""){
			setItemValue(0,getRow(),"DealerGroup","<%=sGenusgroup%>");
		}
		
		//��������
		var Depot = getItemValue(0,getRow(),"Depot");
		if(typeof(Depot) !="undefind" && Depot==""){
			setItemValue(0,getRow(),"Depot","<%=sCarfactory%>");
		}
		//����
		var Area = getItemValue(0,getRow(),"Area");
		if(typeof(Area) !="undefind" && Area==""){
			setItemValue(0,getRow(),"Area","<%=sCity%>");
			setItemValue(0,getRow(),"AreaName","<%=sCityName%>");		
		}
		//end by jli5 Ĭ��ֵչʾ�߼�����
		//���շ���
		setItemValue(0,getRow(),"CreditFeeRate","<%=CredFeeRate%>");
		
		//������
		setItemValue(0,getRow(),"CreditPerson","<%=sCreditPerson%>");
		setItemValue(0,getRow(),"CreditId","<%=sCreditId%>");
				
		// �����ʺţ�������ʼ��
		var sRepayAccountNo = RunMethod("���÷���", "GetColValue", "Business_Contract,755920947910910||CustomerId, SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");
		//var sInsuranceNo = RunMethod("���÷���", "GetColValue", "Business_Contract,InsuranceNo, SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");//���չ�˾
		var sCreditCycleFlag = "<%=sFlag %>";//�Ƿ����Ͷ���ı�־
		var subProductTypename ="<%=subProductTypename%>";
		if( "4"== subProductTypename || "5"==subProductTypename ){//���Ѵ��е�ѧ��������˽�����
			setItemValue(0, 0, "RepaymentWay", "1");// ���ʽ ��ʼ��Ϊ����
			setItemValue(0, 0, "CreditCycle", "2");// �Ƿ�Ͷ�� ��Ĭ��Ϊ��
			setItemValue(0, 0, "RepaymentNo", "<%=RepaymentNo%>");
			setItemValue(0, 0, "RepaymentBank", "<%=RepaymentBank%>");
			setItemValue(0, 0, "RepaymentBankName", "<%=RepaymentBankName%>");
			setItemValue(0, 0, "RepaymentName", "<%=RepaymentName%>");
		}else if("090" != "<%=sProductid%>"){
			//CCS-1239 ��ͬҳ�����Ѿ�Ͷ���ĺ�ͬ��ɾ����ֵ����ѣ�ҳ��״̬Ϊ����δͶ������
			var CreditCycleValue = getItemValue(0, 0, "CreditCycle");
			if(sCreditCycleFlag=="false" && (CreditCycleValue=="" || CreditCycleValue =="undefind")){
				setItemValue(0, 0, "CreditCycle", "2");
			}
			setItemValue(0, 0, "RepaymentNo", "<%=RepaymentNo%>");
			setItemValue(0, 0, "RepaymentBank", "<%=RepaymentBank%>");
			setItemValue(0, 0, "RepaymentBankName", "<%=RepaymentBankName%>");
			setItemValue(0, 0, "RepaymentName", "<%=RepaymentName%>");
		}else{  //add С��ҵ������
			setItemValue(0,getRow(),"SalesManager","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"MobileTel","<%=sSalesexecutivePhone%>");
		}
		
		loadAmount = getItemValue(0, 0, "BusinessSum"); 
		isInsure = getItemValue(0, 0, "CreditCycle");
		
		// �����ύ״̬�ֶ�
		var operatedStatus = getItemValue(0, 0, "OPERATEDSTATUS");
		if (operatedStatus == null || operatedStatus == "" || operatedStatus == "undefind") {
			setItemValue(0, 0, "OPERATEDSTATUS", "0");// �ύ״̬
		}
	}
	//�����������
	/* function CreditColumnCheck(sColumnName,sCheckType)
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
	} */
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
	
	/*~[Describe=�����׸�����;InputParam=��;OutPutParam=��;]~*/
	function inputPaymentSum(){
		var sCarTotal_ = '0'+getItemValue(0,getRow(),"CarTotal");//�����ܼ�
		var sPaymentSum_ = getItemValue(0,getRow(),"PaymentSum");//�׸����
		
		var nMonthRate = ''+getItemValue(0,getRow(),"CreditRate");//����
		var nLoanTerm = getItemValue(0,getRow(),"Periods");//��������
		var sBusinessSum_ = getItemValue(0,getRow(),"BusinessSum");//�����
		var nMonthPay = 0.0;
		
		var sCarTotal=parseFloat(sCarTotal_);
		var sPaymentSum=parseFloat(sPaymentSum_);
		var sBusinessSum=parseFloat(sBusinessSum_);
		
		if(sCarTotal<0.0){
			alert("�����ܼ۴������飡");
			return;
		}

		if(sPaymentSum<0.0) {
			alert("��������ڵ���0���׸���");
			setItemValue(0,0,"PaymentSum","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}else if(sPaymentSum==0.0){
			setItemValue(0,0,"PaymentSum","");
			setItemValue(0,0,"BusinessSum","");
		}else if(sPaymentSum>sCarTotal){
			alert("�׸���ܴ��ڳ����ܼۣ�");
			setItemValue(0,0,"PaymentSum","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}
		setItemValue(0, 0, "PaymentRate", (sPaymentSum/sCarTotal*100).toFixed(2));//�׸�����
		sBusinessSum = sCarTotal-parseFloat(sPaymentSum);
		setItemValue(0, 0, "BusinessSum", sBusinessSum.toFixed(2));//�����
	}
	
	// quliangmao    ��֤�ֻ�����
	function checkMobile1(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("�ֻ����벻�ܿ�");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("�ֻ�����������������������"); 
	        //obj.focus();
		    //setItemValue(0,0,"MobileTelephone","");
	        return false; 
	    } 
	}
	
/*********************��֤�ֻ�����**************************************************/
	
	function isCheckMobilePhone(obj){
		var sSchCouTel=obj.value;
		//�ո��Զ�����
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){    //���ֻ���
						alert("�ֻ������ʽ��д����"); 
						obj.focus();
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("�̶��绰��ʽ��д����"); 
						obj.focus();
				        return false; 
					}else{
						alert("�����ʽ��д���Ϸ�");
						obj.focus();
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("�ֻ�������д����");
							 obj.focus();
							 return false;
						 }
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
			}
	}		
	
	//add �ֽ������
	//��ʼ��ÿ�»����
	function CashLoanGetMonthPayment()
	{
		var sBusinessSum = '0'+getItemValue(0,getRow(),"BusinessSum");//�����
		var sBusinessType="<%=sBusinessType%>";//��Ʒ���
		var sPeriods = getItemValue(0,getRow(),"Periods");//��������
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//�Ƿ������Ļ������
		//�����˻�����ѡ�������ʷ� ���շ�
		var YesNo = getItemValue(0, getRow(), "CreditCycle");//�Ƿ�Ͷ��1:�� 2����		
		if(typeof(YesNo) == "undefined" || YesNo.length == 0){
			YesNo = "2";
		}
		//�жϸò�Ʒ�Ƿ��������Ļ����������
		if(sBugPayPkgind=="1"){
			var sRe = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckBugPayPkgind", "checkSuiXinHuan", "businessType="+sBusinessType);
			if(sRe == 0){
				alert("�ò�Ʒδ������ȡ���Ļ���������ã�");
				setItemValue(0,0,"BugPayPkgind","0");
			}
		}
		
		var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo+","+sBugPayPkgind);
		var MonthPaymentBefore = parseFloat(sMonthPayment).toFixed(2);
		var MonthPaymentAfter = fix(MonthPaymentBefore);
		setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
		setItemValue(0,getRow(),"RepaymentWay","1");//�ֽ�����ͻ����ʽ��Ĭ�Ͽͻ�ѡ����ۣ��Ҳ����޸ġ�
    }
    //�ſ��˺Ÿ�ʽ���
    function CheckPutOutAccount()
    {
    	var sflag2 =getItemValue(0,getRow(),"RepaymentNo");
    	
		sflag2=sflag2+"";
		var checkaccount = /^\d+$/;
		if(!checkaccount.test(sflag2)){
			alert("�ſ�/�����˺ű��������֣�");
			setItemValue(0,getRow(),"RepaymentNo","");
			return;
		}
		if(sflag2.length<10){
			alert("�ſ�/�����˺ų��Ȳ�С��10λ����");
			setItemValue(0,getRow(),"RepaymentNo","");
			return;
		}
    }
	//��÷ſ��ʺſ����б��/�ſ��˻�����������/�����˺ſ����б��/�����˺ſ���������
	function getOpenBankCodeName(Flag)
	{
		var ReturnSelInfo = "";
		if("Repayment" == Flag)
		{
			ReturnSelInfo = "@flag3@0@flag3Name@1@RepaymentBank@0@RepaymentBankName@1";
		}else if("OpenBank" == Flag)
		{
			ReturnSelInfo = "@OpenBank@0@OpenBankName@1";
		}
		setObjectValue("getOpenBankCodeName","",ReturnSelInfo,0,0,""); 
	}
	//������;��ѡ������������ע����
	function ChangePurposeRemark()
	{
		var sPurpose = getItemValue(0,getRow(),"purpose");
		if("05" == sPurpose)
		{
			setItemRequired(0,getRow(),"purposeRemark",true);
		}else
		{
			setItemRequired(0,getRow(),"purposeRemark",false);
		}
	}

	//�ſ��˺���Ϣ �뻹���˺���Ϣһ��
	function UpdateRepaymentInfo()
	{
		var sRepaymentName = getItemValue(0,getRow(),"RepaymentName");//�����˻���
		var sRepaymentNo = getItemValue(0,getRow(),"RepaymentNo");//�����˺�
		if(null != sRepaymentName && "" != sRepaymentName && "undefined" != sRepaymentName) setItemValue(0,0,"flag1",sRepaymentName);//�ſ��˻���
		if(null != sRepaymentNo && "" != sRepaymentNo && "undefined" != sRepaymentNo) setItemValue(0,0,"flag2",sRepaymentNo);//�ſ��˺�
	}
    //end
    
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
		
		//-- add by tangyb CCS-1255 �����׸�������ʱ���ܼ۸���Ҫ��ȥ�۱����ļ۸� 20160220 start --//
		var subProductType = "<%=sSubProductType%>";
		// �Ƿ�����ͨ���ѻ�ѧ�����Ѵ�
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0,getRow(),"BusinessType2"); // ��Ʒ����2
			if("2015061500000017" == businesstype2){ //2015061500000017[�۱���]
				sValue4 = sValue4 - parseFloat(sPrice2);
			}
		}
		//-- end --//
		
		var sValue7=sValue5/sValue4; //�׸�����
		setItemValue(0,getRow(),"PaymentRate",sValue7.toFixed(2)*100+"");
		
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//����
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//�Ը����
		var sPeriods = getItemValue(0,getRow(),"Periods");//��������
		var sBusinessType="<%=sBusinessType%>";
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//�Ƿ������Ļ������
		
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
		

		//�жϸò�Ʒ�Ƿ��������Ļ����������
		if(sBugPayPkgind=="1"){
			var sRe = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckBugPayPkgind", "checkSuiXinHuan", "businessType="+BusinessType);
			if(sRe == 0){
				alert("�ò�Ʒδ������ȡ���Ļ���������ã�");
				setItemValue(0,0,"BugPayPkgind","0");
			}
		}
		
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
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo+","+sBugPayPkgind);
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
	
	/*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        //��֤��ͬ��Ʒ�Ƿ��Ѿ���Ӱ������������
		var sBusinessType = RunMethod("���÷���", "GetColValue", "Business_Contract,BusinessType,SerialNo='"+sObjectNo+"'");
     	var sAmount = RunMethod("���÷���","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
     	if(sAmount == 0){
			alert("��������ƷӰ�����������øò�Ʒ��Ӧ��Ӱ���ļ���");
			return false;
		}
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
    }
	
	// ���ɻ�����Ϣ
	function generatePaymentInfo() {
		
		// 1. ���ж��Ƿ���Ҫ��������
		var params = "objectNo=<%=sObjectNo %>";
		var isReconsider = "<%=isReconsider %>";
		var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
									"gainIsGenSchedule", params);
		if ((res == null || res == "" || res == "0") && (isReconsider != "1")) {
			alert("���ȱ����ͬ��Ϣ��");
			return;
		} else if (res == "2") {
			alert("�����������㻹����Ϣ��");
			return;
		} else {
			// 2. �����ɻ�����Ϣ
			var SerialNo = getItemValue(0,getRow(),"SerialNo");//��ͬ��ˮ��
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); //�Ƿ�Ͷ��
			var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//�ۿ��˺�
			var ReplaceName = getItemValue(0,0,"ReplaceName");//�ۿ��˺���
			var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//����
			
			params = "objectNo=" + SerialNo + ",userID=<%=CurUser.getUserID()%>," 
					+ "businessType=<%=sBusinessType%>,creditCycle=" + sCreditCycle 
					+ ",replaceAccount=" + ReplaceAccount + ",replaceName=" 
					+ ReplaceName + ",businessSum="+sBusinessSum + ",org=<%=CurUser.getOrgID()%>";
			
			res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
									"firstMonthPayTry", params);
			if(res == null || res.length == 0 || res == "Error") {
				alert("���ɻ�����Ϣʧ�ܣ�");
				return;
			} else {
				setItemValue(0, 0, "MonthRepayment", fix(parseFloat(res)));
				alert("���ɻ�����Ϣ�ɹ���");
				return;
			} 
		}
	}
</script>

<script type="text/javascript">
//���֤������У��
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"Idcard");
	//alert("==================="+card);
	checkIdcard(card);
}

//���֤
function checkIdcard(idcard){
		var Errors=new Array( 
							"��֤ͨ��!", 
							"���֤����λ������!", 
							"���֤����������ڳ�����Χ���зǷ��ַ�!", 
							"���֤����У�����!", 
							"���֤�����Ƿ�!" 
							); 
		var area={11:"����",12:"���",13:"�ӱ�",14:"ɽ��",15:"���ɹ�",21:"����",22:"����",23:"������",31:"�Ϻ�",32:"����",33:"�㽭",34:"����",35:"����",36:"����",37:"ɽ��",41:"����",42:"����",43:"����",44:"�㶫",45:"����",46:"����",50:"����",51:"�Ĵ�",52:"����",53:"����",54:"����",61:"����",62:"����",63:"�ຣ",64:"����",65:"�½�",71:"̨��",81:"���",82:"����",91:"����"} 
							 
		var idcard,Y,JYM; 
		var S,M; 
		var idcard_array = new Array(); 
		idcard_array     = idcard.split(""); 
		//alert(area[parseInt(idcard.substr(0,2))]);
		
		//�������� 
		if(area[parseInt(idcard.substr(0,2))]==null){
			alert(Errors[4]);
			setItemValue(0,0,"Idcard","");
			return Errors[4];
		}
		 
		//��ݺ���λ������ʽ���� 
		
		switch(idcard.length){
		case 15: 
			if((parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
			}else{ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
			} 
		 
			if(ereg.test(idcard)){
				alert(Errors[0]);
				setItemValue(0,0,"Idcard","");
				return Errors[0]; 
		        
			}else{ 
				alert(Errors[2]);
				setItemValue(0,0,"Idcard","");
				return Errors[2];  
			}
			break; 
		case 18: 
			//18λ��ݺ����� 
			//�������ڵĺϷ��Լ��  
			//��������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
			//ƽ������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
			if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//����������ڵĺϷ���������ʽ 
			}else{
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//ƽ��������ڵĺϷ���������ʽ 
			} 
			if(ereg.test(idcard)){//���Գ������ڵĺϷ��� 
				//����У��λ 
				S  =  (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 
					+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 
					+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 
					+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 
					+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 
					+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 
					+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 
					+  parseInt(idcard_array[7]) * 1  
					+  parseInt(idcard_array[8]) * 6 
					+  parseInt(idcard_array[9]) * 3 ; 
				Y    = S % 11; 
				M    = "F"; 
				JYM  = "10X98765432"; 
				M    = JYM.substr(Y,1);//�ж�У��λ 
				if(M == idcard_array[17]){
					return  Errors[0];		//���ID��У��λ 
				}else{
					alert(Errors[3]);
					setItemValue(0,0,"Idcard","");
					return  Errors[3]; 
		        }
			}else{
				alert(Errors[2]);
				setItemValue(0,0,"Idcard","");
				return Errors[2]; 
		    }
			break;
		default:
		    alert(Errors[1]);
		    setItemValue(0,0,"Idcard","");
			return  Errors[1]; 

			break;
		} 
			 
}
	/*~ ѡ��ѡ���½�û�������չ���µ���Ч�Ľ��ھ���~*/
	function selectManage(){
		var sParaString ="sNo,"+"<%=sNo%>";
		setObjectValue("SelectManage",sParaString,"@ManageUserID@0@ManagerName@1",0,0,"");
	}

	/*~ ��д�Ƽ�����Ϣ ~*/
	function judgeName() {
		
		var username = getItemValue(0, 0, "REFERER");
		if (username == null || username == "") {
			return;
		}
		
    	var res = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction", 
    			"judgeName", "username=" + username);
    	if (res == "ERROR" || res == "0") {
    		if (!window.confirm("�޷��ҵ����Ƽ���, �Ƿ����������Ƽ�����Ϣ��")) {
    			setItemValue(0, 0, "REFERER", "");
    		}
    	}
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
