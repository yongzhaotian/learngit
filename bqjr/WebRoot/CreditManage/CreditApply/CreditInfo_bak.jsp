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

	//�����������������������Ӧ����������SQL��䡢��Ʒ���͡��ͻ����롢��ʾ���ԡ���Ʒ�汾
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="",sSalesexecutive="",sSalesexecutiveName="";
	//�����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//�������������ҵ����֡�����ҵ�����ա�������ˮ�š���ݺ�
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSno="",sSname="",ssSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCreditId="",sCreditPerson="",sCity="",sAttr2="",sCarfactory="";
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
     //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
     String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));

     if(sNo == null) sNo = "";
     System.out.println("-------�����ŵ�-------"+sNo);
     
     sSql="select sno,sname from store_info where sno = :sno and  identtype = '01'";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 sSno = DataConvert.toString(rs.getString("sno"));//�ŵ�
    	 sSname = DataConvert.toString(rs.getString("sname"));
 		//����ֵת���ɿ��ַ���
 		if(sSno == null) sSno = "";
 		if(sSname == null) sSname = "";
 		
     }
     rs.getStatement().close();
     
     
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
     
  	
  	String ssCity = Sqlca.getString(new SqlObject("select city from store_info si where si.sno=:sno").setParameter("sno", sNo));
  	//��ȡ��������Ϣ(�������������ѽ���ȡֵ�߼�һֱ)
    sSql="select sp.serialno as SerialNo,sp.serviceprovidersname as ServiceProvidersName "+
  				" from Service_Providers sp where sp.customertype1='06' and sp.city like '%"+ssCity+"%' ";
      rs=Sqlca.getASResultSet(sSql);
      if(rs.next()){
     	 sCreditId = DataConvert.toString(rs.getString("SerialNo"));//�����˱��
     	 sCreditPerson = DataConvert.toString(rs.getString("ServiceProvidersName"));//����������
     	
  		//����ֵת���ɿ��ַ���
  		if(sCreditId == null) sCreditId = "";
  		if(sCreditPerson == null) sCreditPerson = "";
      }
      rs.getStatement().close();
     
     //��ѯ����
//      sSql="select attr2 from BaseDataSet_Info WHERE TypeCode='AreaCodeCar' and attr1 in (select attrstr2 from BaseDataSet_Info WHERE TypeCode='CityCodeCar' and Attr1=:city)";
//      rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("city",sCity));
//      if(rs.next()){
//     	 sAttr2 = DataConvert.toString(rs.getString("attr2"));//��������
//      }
//      rs.getStatement().close();
//      ARE.getLog().debug("����"+sAttr2);
      
	

	  String sCreditAttribute = "";//0002����/0001����/0003������
     
     //��ѯ���۴���
     sSql="select Salesexecutive,getusername(Salesexecutive) as SalesexecutiveName,ProductID,CreditAttribute from business_contract where serialno=:serialno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
     if(rs.next()){
    	 sSalesexecutive = DataConvert.toString(rs.getString("Salesexecutive"));//���۴���ID
    	 sSalesexecutiveName = DataConvert.toString(rs.getString("SalesexecutiveName"));//���۴���Name
    	 
    	 sProductid = DataConvert.toString(rs.getString("ProductID"));//��Ʒ����
    	 sCreditAttribute =  DataConvert.toString(rs.getString("CreditAttribute"));//��Ʒ����
    	 
 		//����ֵת���ɿ��ַ���
 		if(sSalesexecutive == null) sSalesexecutive = "";
 		if(sSalesexecutiveName == null) sSalesexecutiveName = "";
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
	
	//�Ƿ��б��շ�
	String productobjectno = sBusinessType+"-V1.0";
	String scount = Sqlca.getString(new SqlObject("select count(*) from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(Integer.valueOf(scount)==0){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
	}
	
	//��ȡ������Ʒ�Ĳ���
	String LowPrinciPalMin = "",TallPrinciPalMax = "",ShoufuRatio = "",ShoufuRatioType = "",sRateType = "",monthcalculationMethod = "",sRateFloatType="",cProductType="";
	String highestLoansProportion = "",whetherDiscount = "";
		String sSqlBT = " select LOWPRINCIPAL,TALLPRINCIPAL,SHOUFURATIO,SHOUFURATIOTYPE,ratetype,monthcalculationMethod,floatingManner,highestLoansProportion,whetherDiscount,producttype from business_type where typeno='"+sBusinessType+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSqlBT));
		while(rs.next()){
			LowPrinciPalMin = rs.getString("LOWPRINCIPAL");
			TallPrinciPalMax = rs.getString("TALLPRINCIPAL");
			ShoufuRatio = rs.getString("SHOUFURATIO");
			ShoufuRatioType = rs.getString("SHOUFURATIOTYPE");
			sRateType = DataConvert.toString(rs.getString("rateType"));//��������  modify by jli5 ����null
			monthcalculationMethod = rs.getString("monthcalculationMethod");//�¹����㷽ʽ
			sRateFloatType = rs.getString("floatingManner");//���ʸ�����ʽ
			
			highestLoansProportion = rs.getString("highestLoansProportion");//��ߴ������
			whetherDiscount = rs.getString("whetherDiscount");//�Ƿ���Ϣ
			cProductType = rs.getString("producttype");//������������/�������� 01��������02������
			
		}
		rs.getStatement().close();
	
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
	String cRateValue = Sqlca.getString(new SqlObject("select yearsinterestrate from Interest_Rate where interestratetype='01' and isinuse='1' "+ 
	        " and to_date(to_char(sysdate, 'yyyy/MM/dd'), 'yyyy/mm/dd')>=to_date(effectivedate, 'yyyy/MM/dd') and term='"+tTermTemp+"' and rownum='1' "));
	if(cRateValue==null) cRateValue="0";

	//��������  ���ݲ�Ʒ����   ��ʾģ����� add by jli5 
	if("0001".equals(sCreditAttribute)){
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
	}
	
	//����Ʒ��������ǰ���������� ����׶�ɾ���˷��ã�����ǰ��������ʱ�ٲ������ü�¼
	String tqhksxfTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A9' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(tqhksxfTermID == null) tqhksxfTermID = "";
	
%>
<%
   doTemp.setReadOnly("CustomerType", true);//add by jli5 �ͻ��������Ͳ����޸�
  
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
	
	//��ȡ�����˵������Ϣ
	String RepaymentNo = "";//�����˺�
	String RepaymentBank = "";//�����˺ſ�����
	String RepaymentName = "";//�����˺Ż���
	String RepaymentBankName = "";
	String sCreditid = Sqlca.getString("select CreditID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	sSql = "select backAccountPrefix,turnAccountName,turnAccountBlank,getItemName('BankCode',turnAccountBlank) as RepaymentBankName from Service_Providers where SerialNo =:SerialNo";
	SqlObject soSer = new SqlObject(sSql).setParameter("SerialNo", sCreditid);
	rs = Sqlca.getASResultSet(soSer);
	if(rs.next()){
		RepaymentNo = rs.getString("backAccountPrefix");
		RepaymentBank = rs.getString("turnAccountBlank");
		RepaymentName = rs.getString("turnAccountName");
		RepaymentBankName = rs.getString("RepaymentBankName");
	}
	if(RepaymentNo == null || RepaymentNo == "") RepaymentNo = "755920947910920";
	if(RepaymentBank == null || RepaymentBank == "") RepaymentBank = "308";
	if(RepaymentBankName == null || RepaymentBankName == "") RepaymentBankName = "�������������ĺ�֧��";
	if(RepaymentName == null || RepaymentName == "") RepaymentName = "�����а�Ǫ���ڷ������޹�˾";
	rs.getStatement().close();
	
	RepaymentNo = RepaymentNo+Sqlca.getString("select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	
	RepaymentBankName = "�������������ĺ�֧��";
	//��ȡ�ͻ�����״̬
	String sCTempSaveFlag = Sqlca.getString(new SqlObject("select Tempsaveflag from Ind_Info where CustomerID =:CustomerID").setParameter("CustomerID", sCustomerID));
	
	//�״λ�����
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String temDay = "";
	String businessDate = SystemConfig.getBusinessDate();	
	
	temDay = businessDate.substring(8, 10);
	if(temDay.equals("29")){
		temDay = "02";
		sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
	}else if(temDay.equals("30")){
		temDay = "03";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
	}else if(temDay.equals("31")){
		temDay = "04";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
	}else{
		sFirstDueDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1);
	}

	//һ���ͻ������ͬ��������ж��״λ����գ�ȡ�ͻ�֮ǰ����ĺ�ͬ
	String sFirstNextDueDate = "";
	int sDays=0;
	String minSerialNo = Sqlca.getString(new SqlObject("SELECT min(serialno) FROM business_contract where finishdate is null and CONTRACTSTATUS not in ('090','200','140','130','160','040','120','210','010','150','110','030') and customerid = :CustomerID and serialno != :serialno ").setParameter("CustomerID", sCustomerID).setParameter("serialno", sObjectNo));
	if(minSerialNo == null) minSerialNo = "";
	if(!minSerialNo.equals("")){
		sFirstNextDueDate = Sqlca.getString(new SqlObject("SELECT NEXTDUEDATE FROM acct_loan where putoutno in (SELECT min(serialno) FROM business_contract where CONTRACTSTATUS not in ('090','200','140','130','160','040','120','210','010','150','110','030') and customerid = :CustomerID and serialno != :serialno) ").setParameter("CustomerID", sCustomerID).setParameter("serialno", sObjectNo));	
		if(sFirstNextDueDate == null) sFirstNextDueDate = "";
		if(!sFirstNextDueDate.equals("")){
			sDays = DateFunctions.getDays(businessDate, sFirstNextDueDate);
			if(sDays >= 14){
				sFirstDueDate = sFirstNextDueDate;
			}else{
				sFirstDueDate = DateFunctions.getRelativeDate(sFirstNextDueDate, DateFunctions.TERM_UNIT_MONTH, 1);
			}
		}		
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
		{"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath},
		{"false","All","Button","��ӡ�����","��ӡ�����","creatApplyTable()",sResourcesPath},
		{"false","All","Button","��ӡ���Ӻ�ͬ","��ӡ���Ӻ�ͬ","creatContract()",sResourcesPath},
		{"true","All","Button","�ϴ���Ƭ","�ϴ���Ƭ","imageManage()",sResourcesPath},
		{"false","All","Button","��ӡ����Э��","��ӡ����Э��","creatThirdTable()",sResourcesPath},
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
	function saveRecord()
	{	
		// ȥ��������ֶκ�����ʾ add by tbzeng 2014/05/03  
		var sTemp = _user_validator[0].rules.BUSINESSSUM.expressions;
		for (var x in sTemp) {
			sTemp[x] = "";
		} 
		// hope fixme carefully
		
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
	
		if(vI_all("myiframe0"))
		{
			var returncheck = CheckSum();
			if(!returncheck){
				return;
			}
			
			if("01"=='<%=CurUser.getIsCar()%>' &&!CarValidityCheck()){	//�����������У��
				return;			
			}
			
			beforeUpdate();
			if(!saveSubItem()) return;
			setItemValue(0,getRow(),"TempSaveFlag","2"); //�ݴ��־��1���ǣ�2����
			
			var returnvalue = inserTermPara();//�������ʣ����ʽ
			if(!returnvalue){
				alert("�������ü�¼����,���������±��棡");
				return;
			}
			
			SetBusinessMaturity();//��ͬ����Ϊ��ͬ��Ч
			as_save("myiframe0");
		}
	}
	
	
	/*~[Describe=�����������У��;InputParam=��;OutPutParam=��;]~*/
	function CarValidityCheck(){
		
		
		return true;
	}
	
	
	/*~[Describe=���㵽����;InputParam=��;OutPutParam=��;]~*/
	function SetBusinessMaturity(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//��ͬ��ˮ��
		var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
		var sFirstDueDate = "<%=sFirstDueDate%>";
		//�����״λ�����
		RunMethod("PublicMethod","UpdateColValue","String@FIRSTDUEDATE@"+sFirstDueDate+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//�״λ�����	
		
		var sDay = sPutOutDate.substring(8,10); 
		var deDaultDueDay = "<%=temDay%>";
		
		RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//��ͬĬ�ϻ�����	
		var sTermMonth_ = RunMethod("GetElement","GetElementValue","Periods,business_contract,SerialNo='"+SerialNo+"'");//����
		var sTermMonth = parseInt(sTermMonth_,10);
		var sMaturity = "";
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 ) {
			alert("��ͬδ¼������ڴΣ�");
			return ;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";//���޵�λ(��)
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate);
		}
		RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ��Ч��
		RunMethod("PublicMethod","UpdateColValue","String@contractEffectiveDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ��Ч��
		RunMethod("PublicMethod","UpdateColValue","String@Maturity@"+sMaturity+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ������
	}
	
	//�����������
	function inserTermPara(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo="<%=sObjectNo%>";
		var sApplyType="<%=sApplyType%>";
		var sBusinessType = "<%=sBusinessType%>";
		var CreditAttribute = "<%=sCreditAttribute%>";
		var RepaymentWay = getItemValue(0,0,"RepaymentWay");//��������
		if(CreditAttribute == "0002"){//���Ѵ�
			var sTermID = "RPT17";//�ȶϢ
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=sObjectType%>,<%=sObjectNo%>");
			//�̶�����
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RAT002,<%=sObjectType%>,<%=sObjectNo%>");
			//��������
			var sReturnFeeBool = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
						
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); //�Ƿ�Ͷ�� 
			if(sCreditCycle=="2"){//��Ͷ��  
				//ɾ������ı��շ� ������Ϣ
				RunMethod("PublicMethod","DeleteFee","A12,<%=sObjectNo%>");
			}
			
			//�ۿ��˻���Ϣ
			if(RepaymentWay=="1"){//����
				var accountIndicator="01";//�ۿ�
				//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//�ۿ��˺�
				var ReplaceName = getItemValue(0,0,"ReplaceName");//�ۿ��˺���
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}else if(RepaymentWay=="2"){//�Ǵ���
				var accountIndicator="01";//�ۿ�
				//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				var ReplaceAccount = getItemValue(0,0,"RepaymentNo");//߀���˺�
				var ReplaceName = getItemValue(0,0,"RepaymentName");//�ۿ��˺���
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
			}
			//�ſ��˻�
			var accountIndicator="00";//�ſ�
			//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
			sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
			var ReplaceAccount = "XFD"+"<%=sObjectNo%>";//�ۿ��˺�
			var ReplaceName = "���Ѵ��ͻ�";//�ſ��˺���
			if(sReturn>0){
				RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+ReplaceAccount+"@String@accountno@"+ReplaceName);
			}else{
				var AccountSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
				RunMethod("LoanAccount","CreateDepositAccount",AccountSerialNo+","+"<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT"+","+ReplaceAccount+","+accountIndicator+","+ReplaceName);
			}
			
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
		}else if(CreditAttribute == "0001"){//��������
			var sRateType = "<%=sRateType%>";
			var Issue = getItemValue(0, 0, "Issue");//�����ڴ�
		
			var finrate = "FIN003";//������Ϣ
			var IntereStrate = getItemValue(0, 0, "IntereStrate");//��������
			var CreditRate = getItemValue(0, 0, "CreditRate");//������������
			
			var RATTerm = "";
			if(IntereStrate=="0"){//�̶�����
				 RATTerm = "RAT002";
			}else if(IntereStrate=="1"){//��������
				 RATTerm = "RAT001";
			}else if(IntereStrate=="2"){//�̶����
				 RATTerm = "RAT004";
			}
			
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+RATTerm+",<%=sObjectType%>,<%=sObjectNo%>");//����
			if(RATTerm == "RAT004"){//�̶��������
				RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+CreditRate+",acct_rate_segment,String@ratetermid@RAT004@String@OBJECTNO@"+sObjectNo);
			}
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+finrate+",<%=sObjectType%>,<%=sObjectNo%>");//��Ϣ
<%-- 			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//����
 --%>		
 			
 			var SEGRPTAmount = getItemValue(0, 0, "FinalPaymentSum");//β����
 			if(!(typeof(shoufuRatio)=="undefined" || shoufuRatio=="shoufuRatio" || shoufuRatio.length==0)){
 				RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+CreditRate+",acct_rate_segment,String@ratetermid@RAT004@String@OBJECTNO@"+sObjectNo);
 				/* RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+SEGRPTAmount+",PRODUCT_TERM_PARA,String@paraid@SEGRPTAmount@String@termid@"+monthcalculationMethod+"@String@ObjectNo@"+sObjectNo);//β���� */
 			}
 			
 			//���ʽ
 			var monthcalculationMethod = "<%=monthcalculationMethod%>";
 			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//�¹����㷽ʽ
			
			<%-- 
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
			 --%>
			var sReturnFeeBool = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
			
			/* if(s!="true"){
				alert("��Ʒ�������!");
				return "false";
			} */
			
			//�ۿ��˺�
			var RepaymentWay = getItemValue(0,0,"RepaymentWay");//���ʽReplaceAccount
			
			if(RepaymentWay=="1"){//����
				var accountIndicator="01";//����
				var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//�ۿ��˺�
				var ReplaceName = getItemValue(0,0,"ReplaceName");//�ۿ��˺���
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+ReplaceName+"@String@accountno@"+ReplaceAccount);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}
			
			if(sReturnFeeBool == "ture"){
				return true;
			}else{
				return false;
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
	function CheckSum()
	{	
		var temBusinessSum = getItemValue(0, getRow(), "BusinessSum");
		var LowPrinciPalMin = "<%=LowPrinciPalMin%>";
		var TallPrinciPalMax = "<%=TallPrinciPalMax%>";
		var ShoufuRatio = "<%=ShoufuRatio%>";//��Ʒ�׸�����
		if(parseFloat(temBusinessSum) > parseFloat(TallPrinciPalMax) || parseFloat(temBusinessSum) < parseFloat(LowPrinciPalMin)){
			alert("�������ڲ�Ʒ�ĵ���ͺ���߷�Χ�ڣ���ȷ�ϣ�");
			return false;
		}
		
		var ShoufuRatioType = "<%=ShoufuRatioType%>";//1:�̶�2:���
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
	    	 return;
	    }
	    setItemValue(0,0,"BusinessRange1",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName",sReturn[1]);
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
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType1",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName",sReturn[1]);
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
	    	 setItemValue(0,0,"BusinessRangeName","");
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
	    	 setItemValue(0,0,"BusinessTypeName","");
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType2",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName2",sReturn[1]);
	
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
	    	 setItemValue(0,0,"BusinessRangeName","");
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
	    	 setItemValue(0,0,"BusinessTypeName","");
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType3",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName3",sReturn[1]);
	    
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
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"OpenBranch",sBankNo);
		setItemValue(0,0,"OpenBranchName",sBranch);
	}
	
	
	/*--------------��������ҳ����������--------------begin-----------------modify by jli5-----------------*/
	//���Ƴ����ۼ۲��ø��ڳ�����
	function selectVPrice(obj){
		var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//�����ۼ�
		var sCarPrice =getItemValue(0,0,"CarPrice");//������
		
		if(parseFloat(sVehiclePrice) > parseFloat(sCarPrice)){
			alert("�����ۼ۲��ø��ڳ�����");
			obj.focus();
		}
		//���㳵���ܼ�
		selectOtherCost();
		
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
			    selectPaymentRateW();
			    selectPaymentSumW();//β���������
				selectPaymentSum();//�׸����������
				selectPaymentRate();
				
				selectBusinessSum();//���������
	        }else{
	        	setItemValue(0,0,"CarTotal","");//�����ܼ�
	        }
		}
	}
	
	//�׸������(��������):(�׸�����/�����ܼ�)*100%
	function selectPaymentRate(){
		selectBusinessSum();//���������
		var sProductID =getItemValue(0,0,"ProductID");//��Ʒ����
		if(sProductID=="01"){
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//�׸�����
			var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
		
			if(!isNaN(sPaymentSum) && !isNaN(sCarTotal)){
				var sPaymentRate=roundOff((parseFloat(sPaymentSum)/parseFloat(sCarTotal))*100,2);
	
				if(!isNaN(sPaymentRate)){
				    setItemValue(0,0,"PaymentRate",sPaymentRate);//�׸������
				}else{
					  setItemValue(0,0,"PaymentRate","");
				}
			}
		}
	}
	//���ݱ��ʼ�����
	function selectPaymentSum(){
		var sProductID =getItemValue(0,0,"ProductID");//��Ʒ����
		if(sProductID=="01"){
			var sPaymentRate =getItemValue(0,0,"PaymentRate");//�׸������
			var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
			if(!isNaN(sPaymentRate) && !isNaN(sCarTotal)){
				var sPaymentSum=roundOff((parseFloat(sPaymentRate)*parseFloat(sCarTotal))*0.01,2);
				if(!isNaN(sPaymentSum)){
				    setItemValue(0,0,"PaymentSum",sPaymentSum);//�׸�����
				    selectBusinessSum();//���������
				}else{
					 setItemValue(0,0,"PaymentSum","");//�׸�����
				}
			}
		}
	}
	
	
	//β�����:��β����/ �����ܼۣ�*100%
	function selectPaymentRateW(){
		var sFinalPaymentSum =getItemValue(0,0,"FinalPaymentSum");//β����
		var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
		if(!isNaN(sFinalPaymentSum) && !isNaN(sCarTotal)){
			var sFinalPayment=roundOff((parseFloat(sFinalPaymentSum)/parseFloat(sCarTotal))*100,2);
			if(!isNaN(sFinalPayment)){
			    setItemValue(0,0,"FinalPayment",sFinalPayment);//β�����
			}else{
				setItemValue(0,0,"FinalPayment","");//β�����
			}
		}
	}
	//���ݱ��ʼ�����
	function selectPaymentSumW(){
		var sFinalPayment =getItemValue(0,0,"FinalPayment");//β����
		var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
		
		if(!isNaN(sFinalPayment) && !isNaN(sCarTotal)){
			var sFinalPaymentSum=roundOff((parseFloat(sFinalPayment)*parseFloat(sCarTotal))*0.01,2);
			if(!isNaN(sFinalPaymentSum)){
			    setItemValue(0,0,"FinalPaymentSum",sFinalPaymentSum);//β�����
			}else{
				setItemValue(0,0,"FinalPaymentSum","");
			}
		}
	}
	
	
	//��ֵ����(��������):����ֵ���/ ���������ۣ�*100%
	function selectSalvageRatio(){
		selectBusinessSum();//���������
		var sProductID =getItemValue(0,0,"ProductID");//��Ʒ����
 		if(sProductID=="02"){
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//��ֵ���
			var sCarPrice   =getItemValue(0,0,"CarPrice");//�����ܼ�
			if(!isNaN(sSalvageSum) && !isNaN(sCarPrice)){
				var sSalvageRatio=roundOff((parseFloat(sSalvageSum)/parseFloat(sCarPrice))*100,2);
				if(!isNaN(sSalvageRatio)){
				    setItemValue(0,0,"SalvageRatio",sSalvageRatio);//��ֵ����
				}else{
					setItemValue(0,0,"SalvageRatio","")
				}
			}
		}
	}
	//���ݱ��ʼ�����
	function selectSalvageSum(){
		var sProductID =getItemValue(0,0,"ProductID");//��Ʒ����
		if(sProductID=="02"){
			var sSalvageRatio =getItemValue(0,0,"SalvageRatio");//��ֵ����
			var sCarPrice   =getItemValue(0,0,"CarPrice");//�����ܼ�
			alert(sSalvageRatio+","+sCarPrice);
			if(!isNaN(sSalvageRatio) && !isNaN(sCarPrice)){
				var sSalvageSum=roundOff((parseFloat(sSalvageRatio)*parseFloat(sCarPrice))*0.01,2);
				if(!isNaN(sSalvageSum)){
				    setItemValue(0,0,"SalvageSum",sSalvageSum);//��ֵ���
				    selectBusinessSum();//���������
				}else{
					setItemValue(0,0,"SalvageSum","");
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
				var 	sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sPaymentSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//������
				}else{
					setItemValue(0,0,"BusinessSum","");
				}
			}
			//���ƴ�����/�����ܼ۲��ø��ڲ�Ʒ�����е���ߴ������
			var sBusinessType =  getItemValue(0,0,"BusinessType");//��Ʒ����
			var sBusinessSum =  getItemValue(0,0,"BusinessSum");//������
			var sCarTotal =  getItemValue(0,0,"CarTotal");//�����ܼ�
			RunJavaMethodSqlca("","","");
		 }
		
		//�������ޣ������ܼ�-��ֵ���
		if(sProductID=="02"){
			var sCarTotal   =getItemValue(0,0,"CarTotal");//�����ܼ�
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//��ֵ���
			
			if(!isNaN(sCarTotal) && !isNaN(sSalvageSum)){
				sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sSalvageSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//������
				}else{
					 setItemValue(0,0,"BusinessSum","");//������
				}
			}
		}
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
		
	//��������
	/* ��������ѡ��̶����������Ҫ���۾����ֹ�����������ʣ������ƴ������ʲ���С�ڲ�Ʒ������ز������ñ��еĹ̶�����ֵ��ͬʱ���ø�����߹̶����ʡ�
		����������Ϊ�̶����ʣ���ʾ��Ʒ������ز������ñ��еĹ̶�����ֵ��
		����������Ϊ��������ʱ�����������ҵ���Ӧ�Ļ�׼���ʣ����ո������ͣ���Ϊ���������������������=��׼����*��1+�������ȣ�����Ϊ�������㣬���������=��׼����+�������� */
	function	selectCreditRate(){
		var sIntereStrate =  getItemValue(0,0,"IntereStrate");//��������
		var sProductID =  getItemValue(0,0,"ProductID");//��Ʒ
		var sPeriods =  getItemValue(0,0,"Periods");//��������
		
		//
		var sCreditRate = RunJavaMethodSqlca("","","");
		if(!isNaN(sCreditRate) ){
			setItemValue(0,0,"CreditRates",sCreditRate);
		}else{
			setItemValue(0,0,"CreditRates","");
		}
	}
	
	
	//������/���ֳ������ۣ����ֳ�ʱ��ʾ
	function selectCreditRates(){
		var sCarStatus = getItemValue(0,0,"CarStatus");//����
		if("02"!=sCarStatus){//�ɳ�
			setItemValue(0,0,"CreditRates","");//���������۵Ĵ������
			return;
		}
		var sBusinessSum   = getItemValue(0,0,"BusinessSum");//������
		var sAssessPrice   = getItemValue(0,0,"AssessPrice");//���ֳ������۸�
		if(!isNaN(sBusinessSum) && !isNaN(sAssessPrice)){
			var sCreditRates=roundOff(parseFloat(sBusinessSum)/parseFloat(sAssessPrice)*100,2);
			if(!isNaN(sCreditRates)){
			    setItemValue(0,0,"CreditRates",sCreditRates);//���������۵Ĵ������
			}
		}
	}
	/*--------------��������ҳ����������--------------end-----------------modify by jli5-----------------*/
		
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
			setItemRequired(0,0,"CityName",true);//����ʡ��
			
			//���غ���ʾ�ֶ�
			//hideItem(0, 0, "ReplaceAccount");
			//showItem(0, 0, "RepaymentWay");
		}else{
			setItemRequired(0,0,"ReplaceAccount",false);
			setItemRequired(0,0,"OpenBank",false);
			setItemRequired(0,0,"ReplaceName",false);
			setItemRequired(0,0,"CityName",false);//����ʡ��
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
		setItemValue(0,getRow(),"PaymentRate","<%=tShouFuRatio%>");//�׸�����
		
		
	}
	
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		
		if(<%=sCreditAttribute%>=="0001"){
			carInitRow();
		}
		
		// fixme xx
		//DZ[iDW][1][iCol][0]
		//var iColNum = getColIndex(0, "BusinessSum");
		//alert(iColNum);
		//DZ[0][1][iColNum][0] = "";
		
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
		setItemValue(0,getRow(),"Stores","<%=sSno%>");
		setItemValue(0,getRow(),"StoresName","<%=sSname%>");
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

		
		//չ��
		setItemValue(0,getRow(),"ExhibitionHall","<%=ssSno%>");
		setItemValue(0,getRow(),"ExhibitionHallName","<%=ssSname%>");
		//����������
		setItemValue(0,getRow(),"DealerName","<%=sServiceprovidersname%>");
		//��������������
		setItemValue(0,getRow(),"DealerGroup","<%=sGenusgroup%>");
		//��������
		setItemValue(0,getRow(),"Depot","<%=sCarfactory%>");
		
		//������
		setItemValue(0,getRow(),"CreditPerson","<%=sCreditPerson%>");
		setItemValue(0,getRow(),"CreditId","<%=sCreditId%>");
		//����
		setItemValue(0,getRow(),"Area","<%=sCity%>");
		setItemValue(0,getRow(),"AreaName","<%=sCityName%>");
		
		
		//���ھ�������
		setItemValue(0,getRow(),"ManagerName","<%=CurUser.getUserID()%>");
		
		// �����ʺţ�������ʼ��
		var sRepayAccountNo = RunMethod("���÷���", "GetColValue", "Business_Contract,755920947910910||CustomerId, SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");
		//alert(sRepayAccountNo);
		setItemValue(0, 0, "RepaymentNo", "<%=RepaymentNo%>");
		setItemValue(0, 0, "RepaymentBank", "<%=RepaymentBank%>");
		setItemValue(0, 0, "RepaymentBankName", "<%=RepaymentBankName%>");
		setItemValue(0, 0, "RepaymentName", "<%=RepaymentName%>");
		
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
	
	/*~[Describe=�����׸����;InputParam=��;OutPutParam=��;]~*/
	function inputPaymentRate(){
		var sCarTotal_ = '0'+getItemValue(0,getRow(),"CarTotal");//�����ܼ�
		var nLoanTerm = getItemValue(0,getRow(),"Periods");//��������
		var sPaymentRate_ = '0'+getItemValue(0,getRow(),"PaymentRate");//�׸�����
		var nMonthRate = ''+getItemValue(0,getRow(),"IntereStrate");//������
		var sBusinessSum_ = ''+getItemValue(0,getRow(),"BusinessSum");//������
		var nMonthPay = 0.0;
		
		var sCarTotal=parseFloat(sCarTotal_);
		var sPaymentRate=parseFloat(sPaymentRate_);
		var sBusinessSum=parseFloat(sBusinessSum_);
		
		if(sCarTotal<0.0){
			alert("�����ܼ۴������飡");
			return;
		}
		
		if(parseFloat(sPaymentRate)<0.0) {
			alert("��������ڵ���0���׸�������");
			setItemValue(0,0,"PaymentRate","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}else if(parseFloat(sPaymentRate)>100.0){
			alert("�׸��������ܴ���100��");
			setItemValue(0,0,"PaymentRate","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}
		
		setItemValue(0, 0, "PaymentSum", (sCarTotal*parseFloat(sPaymentRate)*0.01).toFixed(2));//�׸����
		sBusinessSum =  sCarTotal-(sCarTotal*parseFloat(sPaymentRate)*0.01).toFixed(2);
		setItemValue(0, 0, "BusinessSum", sBusinessSum.toFixed(2));//�����
		
		setItemValue(0,0,"MonthRepayment","");
	}
	
	/*~[Describe=��������ÿ�»����,����𣬳����ܼ۸�����;InputParam=��;OutPutParam=��;]~*/
	function carGetMonthPayment(){
		var sCarPrice = '0'+getItemValue(0,getRow(),"CarPrice");//����������
		var sVehiclePrice = '0'+getItemValue(0,getRow(),"VehiclePrice");//�����ۼ�
		var sInsuranceSum = '0'+getItemValue(0,getRow(),"InsuranceSum");//���ս��
		var sRevenueTax = '0'+getItemValue(0,getRow(),"RevenueTax");//����˰
		var sAllocationSum = '0'+getItemValue(0,getRow(),"AllocationSum");//�������ý��
		//var sCarTotal = '0'+getItemValue(0,getRow(),"CarTotal");//�����ܼ�
		
		if(parseFloat(sVehiclePrice)>parseFloat(sCarPrice)){
			alert("�����ۼ۲��ø��ڳ����ۣ�");
			return;
		}
		if(parseFloat(sInsuranceSum)>parseFloat(sVehiclePrice)*0.01*7){
			alert("���ս���ø��ڳ����ۼ۵�7%��");
			return;
		}
		if(parseFloat(sAllocationSum)>parseFloat(sVehiclePrice)*0.01*8){
			alert("�������ý��ø��ڳ����ۼ۵�8%��");
			return;
		}
		if(parseFloat(sRevenueTax)>parseFloat(sVehiclePrice)*0.01*10){
			alert("����˰���ø��ڳ����ۼ۵�8%��");
			return;
		}
		//�����/�����ܼ�
		var sValue1 = parseFloat(sRevenueTax)+parseFloat(sAllocationSum)+parseFloat(sInsuranceSum)+parseFloat(sVehiclePrice);//�����ܼ�
		setItemValue(0,getRow(),"CarTotal",sValue1+"");
		var sCarTotal = getItemValue(0,getRow(),"CarTotal");//�����ܼ�
		
		var sPaymentRate = '0'+getItemValue(0,getRow(),"PaymentRate");//�׸�����
		var sPaymentSum = '0'+getItemValue(0,getRow(),"PaymentSum");//�׸����
		if(parseFloat(sCarTotal)>0.0&&parseFloat(sPaymentRate)>0.0){
			inputPaymentRate();
		}
		
		var sBusinessSum = '0'+getItemValue(0,getRow(),"BusinessSum");//�����
		if(parseFloat(parseInt(sBusinessSum,10))<parseFloat(sBusinessSum)){
			alert("��������Ϊ����������");
			return;
		}
		
		var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo);
		var MonthPaymentBefore = parseFloat(sMonthPayment).toFixed(2);
		var MonthPaymentAfter = fix(MonthPaymentBefore);
		setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
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
				//setItemValue(0,getRow(),"TotalSum2","ת��ǰ��"+parseFloat(sMonthPayment).toFixed(2)+"");
				var MonthPaymentBefore = parseFloat(sMonthPayment).toFixed(2);
				var MonthPaymentAfter = fix(MonthPaymentBefore);
				//setItemValue(0,getRow(),"BrandType2","ת����"+MonthPaymentAfter+"");
				setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
			
			}
		}
	}
	
	/*~[Describe=С����λ;InputParam=��;OutPutParam=��;]~*/
	function fix(d) {
		var temp = d * 10;
		var value1 = Math.ceil(parseFloat(temp).toFixed(2));//��λȡ��
		var finalyvalue = parseFloat(value1)/10;
		return finalyvalue;
	}  
	
	/*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
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
