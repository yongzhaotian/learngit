<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �û���Ϣ����
	 */
	String PG_TITLE = "�û���Ϣ����";
	
	//���ҳ�����	
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	if(sUserID==null) sUserID="";
	//��ȡ�齨����
	String sIsCar = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isCar"));
	if(sIsCar == null) sIsCar = "";
	
	double dCnt = 0.0;
	if (!"".equals(sUserID)) {
		dCnt = Sqlca.getDouble("select count(1) from user_role where roleid='1006' and userid='"+sUserID+"'");
	}
	
// 	ARE.getLog().debug("�Ƿ񳵴��û�����isCar="+sIsCar);
	
	//���ó�ʼ����welcome!bqjr
	String sInitPwd = "welcome!bqjr88";
	String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", sInitPwd);
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "UserInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	/* if (dCnt > 0.0) {
		doTemp.setRequired("CertID", true);
	} else {
		doTemp.setRequired("CertID", false);
	} */
	
//	doTemp.appendHTMLStyle("UserID"," onkeyup=\"value=value.replace(/[^0-z]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;)\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{((CurUser.hasRole("1000") || CurUser.hasRole("3000"))?"true":"false"),"","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"false","","Button","����","���ص��б����","doReturn('Y')",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurUserID=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false;
    
    /* ѡ���û��ϼ� */
    function selectSuperUser() {
    	var BelongOrg = getItemValue(0, 0, "BelongOrg"); //��������
    	if(BelongOrg == null || BelongOrg == "" || typeof(BelongOrg)=="undefined"){
    		alert("����ѡ����������");
    		return;
    	}
    	
    	var retVal  = setObjectValue("SelectSalesmanSingle", "BelongOrg,"+BelongOrg, "", 0, 0, "");
    	if (typeof retVal=="undefined" || retVal=="_CLEAR_") {
    		return;
    	}
    	setItemValue(0, 0, "SuperId", retVal.split("@")[0]);
    	setItemValue(0, 0, "Attribute8", retVal.split("@")[1]);
    }
	
    /*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
    function getRegionCode() {
    	
    	var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
    	if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
    		return;
    	}
    	
    	setItemValue(0, 0, "City", retVal.split("@")[0]);
    	setItemValue(0, 0, "CityName", retVal.split("@")[1]);
    }
    
    function getJobTitle() {
    	
    	var retVal = setObjectValue("SelectJobTitle","","",0,0,"");
    	setItemValue(0, 0, "JOB_TITLE", retVal.split("@")[0]);
    	
    	// ��ȡְλ����
    	var jobTitleName = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction", "getJobTitleName", "itemNO=" + retVal.split("@")[0]);
    	setItemValue(0, 0, "JOB_TITLE_NAME", jobTitleName);
    }
    
	function saveRecord(){
		if(bIsInsert && checkPrimaryKey("USER_INFO","UserID")){
			alert("�ñ���Ѵ��ڣ��������룡");
			return;
		}
		
		if (!isCardNo()) return;
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		as_save("myiframe0","");
		// ��������ŵ꣬�����ŵ��е���Ϣ
		RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "updateSaleManagerLinkInfo", "userId=<%=sUserID%>");
		//�رմ���
		//alert(checkRequired());
		if(!checkRequired()){
			return;
		}else{
			//alert(1);
		window.close();
		}
		
	}
	function checkRequired(){
		sUserID=getItemValue(0,getRow(),"UserID");
		sLoginID=getItemValue(0,getRow(),"LoginID");
		sUserName=getItemValue(0,getRow(),"UserName");
		sUserType=getItemValue(0,getRow(),"UserType");
		sBelongOrg=getItemValue(0,getRow(),"BelongOrg");
		sStatus=getItemValue(0,getRow(),"Status");
		sCityName=getItemValue(0,getRow(),"CityName");
		sCompany = getItemValue(0,getRow(),"Company");
		 if((typeof(sUserID) == "undefined" || sUserID.length==0)||(typeof(sLoginID) == "undefined" || sLoginID.length==0)
			||	(typeof(sUserName) == "undefined" || sUserName.length==0) ||(typeof(sUserType) == "undefined" || sUserType.length==0)
			||(typeof(sBelongOrg) == "undefined" || sBelongOrg.length==0)||(typeof(sStatus) == "undefined" || sStatus.length==0)
			||(typeof(sCityName) == "undefined" || sCityName.length==0 )||(typeof(sCompany)=="undefined" ||sCompany.length==0)
		 ){
			 return false;
		 }
		 return true;
	}

    function doReturn(sIsRefresh){
        OpenPage("/AppConfig/OrgUserManage/UserList.jsp","_self","");
	}

    <%/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;]~*/%>
	function selectOrg(){
		sParaString = "OrgID,"+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
		
		//�����ı�����ϼ�������ѡ��
		setItemValue(0, 0, "SuperId", "");
    	setItemValue(0, 0, "Attribute8", "");
	}
	
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
            setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
            setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
            setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"Password","<%=sPassword%>"); //����������û������ó�ʼ����
            setItemValue(0,0,"IsCar","<%=sIsCar%>"); //�Ƿ񳵴��û�
            setItemValue(0,0,"CertType","Ind01"); //֤�����ͱ��������֤
            
            bIsInsert = true;
		}
	}
	//���֤������У��
	function isCardNo()  
	{
		var card = getItemValue(0,getRow(),"CertID");
		//var flag=true;
		//alert("==================="+card);
		if(card!=""||card.length!=0){
		if(!checkIdcard(card)){
			return false;
			//flag=false;
		}
		return true;
		}else{
			alert("���֤����Ϊ�գ�");
			return false;
		}
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
				//setItemValue(0,0,"CertID","");
				//return Errors[4];
				return false;
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
					//setItemValue(0,0,"CertID","");
					//return Errors[0]; 
					return true;
			        
				}else{ 
					alert(Errors[2]);
					//setItemValue(0,0,"CertID","");
					//return Errors[2];  
					return false;
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
						//setItemValue(0,0,"CertID","");
						//return  Errors[3]; 
						return false;
			        }
				}else{
					alert(Errors[2]);
					//setItemValue(0,0,"CertID","");
					//return Errors[2]; 
					return false;
			    }
				break;
			default:
			    alert(Errors[1]);
			    //setItemValue(0,0,"CertID","");
				//return  Errors[1]; 
				return false;

				break;
			}	 

	}
	
	<%/*~[Describe=��Ч�Լ��;ͨ��true,����false;]~*/%>
	function ValidityCheck(){
		//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
		sCertType = getItemValue(0,getRow(),"CertType");//֤������
		sCertID = getItemValue(0,getRow(),"CertID");//֤�����
		sBirthday = getItemValue(0,getRow(),"Birthday");//��������
		if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
			if(sCertType == 'Ind01' || sCertType == 'Ind08'){
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
		
		}
	
		return true;	
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>