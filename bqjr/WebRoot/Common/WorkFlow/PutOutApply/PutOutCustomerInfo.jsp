<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		Tester:
		Content: --�ͻ��ſ�
		Input Param:
			  CustomerID:--�ͻ���
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         �°汾�ĸ�д
		   2005.9.10 zywei         �ؼ���� 
		   2005.12.15 jbai
		   2006.10.16 fhuang       �ؼ����
		   2009.10.12 pwang        �� �ı�ҳ����漰�ͻ������жϵ����ݡ�
		   2009.10.27 sjchuan	        ҳ����Ĭ����ʾ��ҵ��ģ
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ſ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sCustomerInfoTemplet = "";//--ģ������
    String sSql = "";//--���sql���
    String sCustomerType = "";//--��ſͻ�����   
    String sCustomerOrgType = "";//--��Ż�������
    String sScope = "";//add by sjchuan 2009-10-27 �����ҵ��ģ
    String sItemAttribute = "" ;
    String sTempSaveFlag = "" ;//�ݴ��־
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- ��Ž����
	
	//����������,�ͻ�����
    String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    String sTypes =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Types"));//����Ŵ�ҵ�񲹵�ʱ�Ŀͻ������types
    
	if(sCustomerID == null) sCustomerID = "";
	if(sTypes == null) sTypes = "";
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�ÿͻ�����
	sSql = "select CustomerType,CertType,CertID from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		sCertType = rs.getString("CertType");
		sCertID = rs.getString("CertID");
	}
	rs.getStatement().close();
	if(sCustomerType == null) sCustomerType = ""; 
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";
	
	//ȡ�ÿͻ�����
	sSql = "select OrgNature,Scope from ENT_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerOrgType = rs.getString("OrgNature");
		sScope = rs.getString("Scope");	//add sjchuan 2009-10-27 ȡ����ҵ��ģ
	}
	rs.getStatement().close();
	
	//ȡ����ͼģ������
	if(sCustomerType.equals("03")){ //�������ڿͻ���Ϣģ��
		//sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerOrgType' and ItemNo = :ItemNo ";
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if(sCustomerType.equals("04")){//�Թ�
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if (sCustomerType.equals("05")){//��˾
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
    if (sCustomerType.equals("0310")){ //���ѽ��ڿͻ���Ϣģ��
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	
	if(rs.next()){ 
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//������ҵ�ͻ�������ͼ����		
	    sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		        //��С��ҵ�ͻ�������ͼ����
	}
	rs.getStatement().close(); 
	
	if(sItemAttribute == null) sItemAttribute = "";	
	if(sAttribute3 == null) sAttribute3 = "";	
	if(sCustomerType.equals("0120")){
		if(sTypes.equals("Reinforce")){ //��Ϊ���ǿͻ�ʱ����С��˾�ͻ���������ʾģ��EnterpriseInfoInput11
			sCustomerInfoTemplet="EnterpriseInfoInput11";
		}else{
			sCustomerInfoTemplet = sAttribute3;	
		}
	}else
		sCustomerInfoTemplet = sItemAttribute;	//�����ͻ�������ʾģ��
		
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("�ͻ���Ϣ�����ڻ�ͻ�����δ���ã�"); 
	
	if(sCustomerType.substring(0,2).equals("03")){ //���˿ͻ�
		sSql = "select TempSaveFlag from IND_INFO where CustomerID = :CustomerID ";
	}else{ //��˾�ͻ����ſͻ�
		sSql = "select TempSaveFlag from ENT_INFO where CustomerID = :CustomerID ";
	}
	sTempSaveFlag = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(sTempSaveFlag == null) sTempSaveFlag = "";	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sCertType.equals("Ind01") || sCertType.equals("Ind08")){
		//doTemp.setReadOnly("Sex,Birthday",true);
	}	
	//add by jgao1 ���֤��������Ӫҵִ�գ�������֤�������ֶ� 2009-11-2
	if(sCertType.equals("Ent02")){
		doTemp.setVisible("CorpID",false);
		doTemp.setReadOnly("LicenseNo",true);
	}
	
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ò���͸����¼������������͸���(���¿ͻ��Ĵ�����) 
	if(sCustomerType.substring(0,2).equals("01")){ //��˾�ͻ�
    	if(sCertType.equals("Ent01")){
    		dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.getUserID()+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.getUserID()+")");
  		}else{
  			dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+SpecialTools.real2Amarsoft(sCertID)+",#LoanCardNo,"+CurUser.getUserID()+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+SpecialTools.real2Amarsoft(sCertID)+",#LoanCardNo,"+CurUser.getUserID()+")");
  		}
  	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(dwTemp.Name);
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
		{"false","All","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{sTempSaveFlag.equals("2")?"false":"false","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath}
	};
	//ֻҪ�ͻ�����û������Ȩ,�Ͳ����޸ı�ҳ�档
	String sRight = Sqlca.getString(new SqlObject(" select BelongAttribute2 from CUSTOMER_BELONG where CustomerID = :CustomerID and UserID = :UserID ").setParameter("CustomerID",sCustomerID).setParameter("UserID",CurUser.getUserID()));
	if(sRight != null && !sRight.equals("1")){
	 	sButtons[0][0] = "false";
	 	sButtons[1][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		//¼��������Ч�Լ��
		//if (!ValidityCheck()) return;
		beforeUpdate();
		setItemValue(0,0,"TempSaveFlag","2");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0",sPostEvents);
		
	}
		
	function saveRecordTemp(){
		var sCustomerType = "<%=sCustomerType%>";
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,0,"TempSaveFlag","1");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0");   //���ݴ�
		setNeedCheckRequired(0);//����ٽ����������û���	
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(sCustomerType == '01'){ //��˾�ͻ�
			
			//8��У�������
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//������	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				//���������Ψһ��
				sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") {
					alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					return false;
				}					
			}
			
			//9:У�鵱�Ƿ����ű�׼���ſͻ�Ϊ��ʱ�����������ϼ���˾���ơ��ϼ���˾��֯����������ϼ���˾������
			sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//�ϼ���˾��֯��������
	    	sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//�Ƿ����ű�׼���ſͻ�
	    	
			if(sECGroupFlag == '1'){ //�Ƿ����ű�׼���ſͻ���1���ǣ�2����
				
				//���¼�����ϼ���˾��֯�������룬����ҪУ���ϼ���˾��֯��������ĺϷ��ԣ�ͬʱ���ϼ���˾֤����������Ϊ��֯��������֤
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" ){
					setItemValue(0,getRow(),'SuperCertType',"Ent01");
				}	
			}			
		}
		
		if(sCustomerType == '03'){ //���˿ͻ�
			//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
			sCertType = getItemValue(0,getRow(),"CertType");//֤������
			sCertID = getItemValue(0,getRow(),"CertID");//֤�����
			sBirthday = getItemValue(0,getRow(),"Birthday");//��������
			if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
				if(sCertType == 'Ind01' || sCertType == 'Ind08'){
					//У���֤����ʱ���֤�ĳ���
					if(sCertID.length != 15 && sCertID.length !=18){
						alert(getBusinessMessage('250')); //֤�����볤������							
						return false;
					}
					//�����֤�е������Զ�������������,�����֤�е��Ա𸳸��Ա�
					if(sCertID.length == 15){
						sSex = sCertID.substring(14);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,12);
						sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sCertID.length == 18){
						sSex = sCertID.substring(16,17);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,14);
						sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sBirthday != sCertID){
						alert(getBusinessMessage('200'));//�������ں����֤�еĳ������ڲ�һ�£�	
						return false;
					}
				}
				
				if(sBirthday < '1900/01/01'){
					alert(getBusinessMessage('201'));//�������ڱ�������1900/01/01��	
					return false;
				}
			}
				
			//4��У���ֻ�����
			sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");//�ֻ�����
			if(typeof(sMobileTelephone) == "undefined" || sMobileTelephone == "" ){
				
				setItemValue(0,0,"MobileTelephone","00000000000");//���ֻ�����Ϊ��ʱ��������棬ϵͳ�Զ�������"00000000000"
			}
		}
		return true;		
	}

    /*~[Describe=������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/   
    function selectOrgType(){
        sParaString = "CodeNo"+",OrgType";      
        //'0110'������ҵ�ͻ��������С����徭Ӫ��ѡ��     Add by zhuang 2010-03-17
        var sCustomerType = "<%=sCustomerType%>";
        if(sCustomerType =='0110'){
            setObjectValue("SelectBigOrgType",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }else{
            setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }
    }
	
	/*~[Describe=��������/����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_")
		{
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			sCountryCodeValue = sCountryCodeInfo[0];//-- ���ڹ���(����)����
			if(sCountryCodeValue != 'CHN') //�����ڹ���(����)��Ϊ�л����񹲺͹�ʱ�������ʡ�ݡ�ֱϽ�С�������������
			{
				setItemValue(0,getRow(),"RegionCode","");
				setItemValue(0,getRow(),"RegionCodeName","");
			}
		}
	}
	
	/*~[Describe=�������õȼ�����ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditTempletType()
	{		
		sParaString = "CodeNo"+",CreditTempletType";			
		setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	
	/*~[Describe=������Ӧ���ֿ�ģ��ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAnalyseType(sModelType)
	{		
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=����ʡ�ݡ�ֱϽ�С�������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode(flag)
	{		
		if (flag != "ent") { //������ҵ�ͻ�����������͸��˵ļ���
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}

	/*~[Describe=������ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"NativePlace",sAddress);//��ַID
		setItemValue(0,0,"NativePlaceName",sAddressName);//��ַNAME
		setItemValue(0,0,"Villagetown",sTownShip);//��/��
		setItemValue(0,0,"Street",sStreet);//�ֵ�/��
		setItemValue(0,0,"Community",sCell);//С��/¥��
		setItemValue(0,0,"CellNo",sRoom);//��/��Ԫ/�����
		
	}
	
	/*~[Describe=�־ӵ�ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getAddCode(){
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"FamilyAdd",sAddress);//�־�ס��ַ
		setItemValue(0,0,"FamilyAddName",sAddressName);
		setItemValue(0,0,"Countryside",sTownShip);//��/��(�־�)
		setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
		setItemValue(0,0,"Plot",sCell);//С��/¥�̣��־ӣ�
		setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
		
	}
	
	/*~[Describe=��λ��ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getCellRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"WorkAdd",sAddress);//��ַID
		setItemValue(0,0,"WorkAddName",sAddressName);//��ַNAME
		setItemValue(0,0,"UnitCountryside",sTownShip);//��/��
		setItemValue(0,0,"UnitStreet",sStreet);//�ֵ�/��
		setItemValue(0,0,"UnitRoom",sCell);//С��/¥��
		setItemValue(0,0,"UnitNo",sRoom);//��/��Ԫ/�����
	}	
	
	/*~[Describe=�ʼĵ�ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getEmailRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"CommAdd",sAddress);//��ַID
		setItemValue(0,0,"CommAddName",sAddressName);//��ַNAME
		setItemValue(0,0,"EmailCountryside",sTownShip);//��/��
		setItemValue(0,0,"EmailStreet",sStreet);//�ֵ�/��
		setItemValue(0,0,"EmailPlot",sCell);//С��/¥��
		setItemValue(0,0,"EmailRoom",sRoom);//��/��Ԫ/�����
	}
	
	/*~[Describe=סլ�绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		sFamilyTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FamilyTel",sFamilyTel);//סլ�绰
		
	}
	
	/*~[Describe=�ֻ�����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getTelPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		setItemValue(0,0,"MobileTelephone",sPhoneCode);//�ֻ�����
		
	}
	
	/*~[Describe=�����绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getWorkPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"WorkTel",sWorkTel);//�����绰

	}
	
	/*~[Describe=��ż�绰����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getSpouseTel()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		//sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"SpouseTel",sPhoneCode);//��ż�绰
		
	}
	
	
	/*~[Describe=��ϵ�˵绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getLinkManCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		//sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"ContactTel",sPhoneCode);//��ϵ�˵绰
		
	}
	
	
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//������չ��ܵ��ж�
		if(sIndustryTypeInfo == "NO" ||sIndustryTypeInfo == '_CLEAR_' )
		{	
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}
	
	//�־�ס��ַ�Ƿ�ͬ������ַ
	function selectYesNo(){
		var sFlag2 = getItemValue(0,getRow(),"Flag2");
		
		//��ȡ������ַ
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sRoom = getItemValue(0,0,"CellNo");
		//alert("----------------------"+sRoom);
		//alert("----------------------"+sFlag2);
		
		
		if(sFlag2=="1"){//�����
			setItemValue(0,0,"FamilyAdd",sNativePlace);//�־�ס��ַ
			setItemValue(0,0,"FamilyAddName",sNativePlaceName);
			setItemValue(0,0,"Countryside",sVillagetown);//��/��(�־�)
			setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
			setItemValue(0,0,"Plot",sCommunity);//С��/¥�̣��־ӣ�
			setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
		}else{
			setItemValue(0,0,"FamilyAdd","");//�־�ס��ַ
			setItemValue(0,0,"FamilyAddName","");
			setItemValue(0,0,"Countryside","");//��/��(�־�)
			setItemValue(0,0,"Villagecenter","");//�ֵ�/�壨�־ӣ�
			setItemValue(0,0,"Plot","");//С��/¥�̣��־ӣ�
			setItemValue(0,0,"Room","");//��/��Ԫ/����ţ��־ӣ�
		}

	}
	
	function selectYesNo2(){
		var sFlag8 = getItemValue(0,getRow(),"Flag8");
		
		//alert("--------------"+sFlag8)
		
		//��ȡ������ַ
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sCellNo = getItemValue(0,0,"CellNo");
		//��ȡ��λ��ַ
		var sWorkAdd = getItemValue(0,0,"WorkAdd");
		var sWorkAddName = getItemValue(0,0,"WorkAddName");
		var sUnitCountryside = getItemValue(0,0,"UnitCountryside");
		var sUnitStreet = getItemValue(0,0,"UnitStreet");
		var sUnitRoom = getItemValue(0,0,"UnitRoom");
		var sUnitNo = getItemValue(0,0,"UnitNo");

		//��ȡ�־�ס��ַ
        var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
        var sFamilyAddName = getItemValue(0,0,"FamilyAddName");
        var sCountryside = getItemValue(0,0,"Countryside");
        var sVillagecenter = getItemValue(0,0,"Villagecenter");
        var sPlot = getItemValue(0,0,"Plot");
        var sRoom = getItemValue(0,0,"Room");
        
		if(sFlag8=="010"){//ͬ�־�ס��ַ

			setItemValue(0,0,"CommAdd",sFamilyAdd);
			setItemValue(0,0,"CommAddName",sFamilyAddName);
			setItemValue(0,0,"EmailCountryside",sCountryside);
			setItemValue(0,0,"EmailStreet",sVillagecenter);
			setItemValue(0,0,"EmailPlot",sPlot);
			setItemValue(0,0,"EmailRoom",sRoom);
		}else if(sFlag8=="020"){//ͬ��λ/ѧУ��ַ

			setItemValue(0,0,"CommAdd",sWorkAdd);
			setItemValue(0,0,"CommAddName",sWorkAddName);
			setItemValue(0,0,"EmailCountryside",sUnitCountryside);
			setItemValue(0,0,"EmailStreet",sUnitStreet);
			setItemValue(0,0,"EmailPlot",sUnitRoom);
			setItemValue(0,0,"EmailRoom",sUnitNo);
		}else if(sFlag8=="030"){//ͬ������ַ

			setItemValue(0,0,"CommAdd",sNativePlace);
			setItemValue(0,0,"CommAddName",sNativePlaceName);
			setItemValue(0,0,"EmailCountryside",sVillagetown);
			setItemValue(0,0,"EmailStreet",sStreet);
			setItemValue(0,0,"EmailPlot",sCommunity);
			setItemValue(0,0,"EmailRoom",sCellNo);
		}else{//
			setItemValue(0,0,"CommAdd","");
			setItemValue(0,0,"CommAddName","");
			setItemValue(0,0,"EmailCountryside","");
			setItemValue(0,0,"EmailStreet","");
			setItemValue(0,0,"EmailPlot","");
			setItemValue(0,0,"EmailRoom","");
		}

	}
	
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrg()
	{		
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getUser()
	{		
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 )
		{		
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else
		{
			alert(getBusinessMessage('132'));//����ѡ��ܻ�������
		}
	}
	

						
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
	  if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;

		setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
		
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");  
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		var sHasIERight = getItemValue(0,getRow(),"HasIERight");
		var SECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");
		var sLoanFlag = getItemValue(0,getRow(),"LoanFlag");
		var sListingCorpType = getItemValue(0,getRow(),"ListingCorpOrNot");// add by zhuang 2010-03-17
		
        //�������й�˾����Ĭ��ֵΪ�������С�  add by zhuang 2010-03-17        
        if(sListingCorpType=="")
        {   
            //"2"���ֶ�"ListingCorpOrNot"��ģ���ж�Ӧ���ô���ListingCorpType��ItemNoֵ����ʾ������
            setItemValue(0,getRow(),"ListingCorpOrNot","2");
        }
		//�����ֶ�Ĭ��ֵ
		if (sCountryCode=="")
		{
			setItemValue(0,getRow(),"CountryCode","CHN");
			setItemValue(0,getRow(),"CountryCodeName","�л����񹲺͹�");
		}

		//���ô�����ҵ����ҵ��ģĬ��ֵ add by cbsu 2009-11-02
        if("<%=sCustomerType%>" == '0110')
        {
            setItemValue(0,getRow(),"Scope","2");
        }
        
		if (sInputUserID=="") 
		{
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == "")
		{
		    setItemValue(0,getRow(),"CreditBelong","010");			
			setItemValue(0,getRow(),"CreditBelongName","��ҵ���������ҵ��λ���õȼ�������");
		}
		if("<%=sCustomerInfoTemplet%>" == "IndEntInfo")
		{
		    setItemValue(0,getRow(),"FinanceBelong","050");			
		}
		
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
		ssCustomerType = "<%=sCustomerOrgType%>";
		sScope = "<%=sScope%>";	
		if(ssCustomerType == '0101' || ssCustomerType == '0102' || ssCustomerType == '0107')
		{
			sRCCurrency = getItemValue(0,0,"RCCurrency");
			sPCCurrency = getItemValue(0,0,"PCCurrency");
			if(sRCCurrency == '')
				setItemValue(0,getRow(),"RCCurrency","01");		
			if(sPCCurrency == '')
				setItemValue(0,getRow(),"PCCurrency","01");
		}
		if(sCustomerType == '01')//��˾�ͻ�
		{
			if(sLoanFlag == "")
			setItemValue(0,getRow(),"LoanFlag","1");
			if(sHasIERight == "")
			setItemValue(0,getRow(),"HasIERight","2");
			if(SECGroupFlag == "")
			setItemValue(0,getRow(),"ECGroupFlag","2");
		}
		if(sCustomerType == '03') //���˿ͻ�
		{	
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				//�����֤�е������Զ�������������
				if(sCertID.length == 15)
				{
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18)
				{
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
		}
	  }
    }
	
	/*~[Describe=��ʼ���ͻ����ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initCustomerID(){
		var sTableName = "IND_INFO";//����
		var sColumnName = "CustomerID";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
    function Trim (sTmp)
    {
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//���� ��ҵ���͡�Ա�����������۶�ʲ��ܶ�ȷ����С��ҵ��ģ
	function EntScope() {
		/*
		����˵����
		�μ��ĵ���ͳ���ϴ���С����ҵ���ְ취�����У�������ͳ�ƾ����˾
		����������ָ���������ҵ���͡�Ա�����������۶�ʲ��ܶ�
		*/
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");//��С��ҵ��ҵ
		var sLastYearSale = getItemValue(0,getRow(),"SellSum");//�����۶�
		var sCapitalAmount = getItemValue(0,getRow(),"TOTALASSETS");//�ʲ��ܶ�
		var sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");//Ա������
		if(typeof(sIndustryType)=="undefined" || sIndustryType.length==0)
			return;
		if(typeof(sLastYearSale)=="undefined" || sLastYearSale.length==0)
			return;
		if(typeof(sCapitalAmount)=="undefined" || sCapitalAmount.length==0)
			return;
		if(typeof(sEmployeeNumber)=="undefined" || sEmployeeNumber.length==0)
			return;
		if(sIndustryType.substring(0,1)=="B" || sIndustryType.substring(0,1)=="C"||sIndustryType.substring(0,1)=="D"){ //��ҵ����ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<300||sLastYearSale<3000||sCapitalAmount<4000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="E"){ //����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<3000||sCapitalAmount<4000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H63"){ //����ҵ��ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H65"){ //����ҵ��ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="F" && sIndustryType.substring(0,3)!="F59"&& sIndustryType.substring(0,3)!="F58"){ //��ͨ����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F59"){ //����ҵ��ҵ
			if(sEmployeeNumber>=1000&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="I"){ //ס�޺Ͳ���ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="A"){ //ũ��������ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F58"){ //�ִ���ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="K"){ //���ز���ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="J"){ //������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=50000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<5000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="M78" ||sIndustryType.substring(0,1)=="N"){ //���ʿ����ˮ������������ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=20000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<2000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="R"){ //���塢������ҵ
			if(sEmployeeNumber>=600&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="M"&&sIndustryType.substring(0,3)!="M78"){ //��Ϣ������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="G"){ //��������������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L73"){ //������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L74"){ //���񼰿Ƽ�������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="O"){ //���������ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000) { //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else{ //������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
