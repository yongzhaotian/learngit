<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID==null) sCustomerID="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PretrialInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveAndGoBack()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		//����У��绰�����Ƿ��ظ�
		if(checkTelPhone() == false) return;

		var sCertID = getItemValue(0,0,"CertID");//���֤��
		var sCustomerName = getItemValue(0,0,"CustomerName");//�ͻ�����
		var sReturn = RunMethod("BusinessManage","IsReplaseState",sCertID.trim()+","+sCustomerName.trim());
		var sReturnTwo= RunMethod("BusinessManage","GetPretrialInfoByDay",sCertID.trim()+","+sCustomerName.trim());//����Ԥ����������
		if(parseFloat(sReturn)==0){
			if(parseFloat(sReturnTwo) <5){ 
				saveRecord("saveAfter()");
			}else{
				alert("�ÿͻ�����Ƶ�����룬���ȴ����������!");
			}
		}else{
			alert("�ÿͻ���Ԥ��ͨ������Ϣδ�������ȴ����������!");
		}
	}
	
	function goBack(){
		AsControl.OpenView("/Common/WorkFlow/PretrialInfoList.jsp","","_self");
	}
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function saveAfter(){
		RunMethod("BusinessManage","AddPretrialTaskInfo",getItemValue(0,0,"SERIALNO"));
		goBack();
	}
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var sCustomerName = getItemValue(0,0,"CustomerName");//�ͻ�����
		var sCertID = getItemValue(0,0,"CertID");//���֤��
		var sCustomerID = RunMethod("BusinessManage","CustomerID",sCustomerName.trim()+","+sCertID.trim());
		//�жϵ�ǰ�ͻ��Ƿ��ǰ�����
		var sReturnBmd = RunMethod("BusinessManage","IsBaimingdan",sCustomerName.trim()+","+sCertID.trim());
		if(parseInt(sReturnBmd) > 0){
			sCustomerID = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId",null)
		}else{
			if(sCustomerID == null || sCustomerID == "Null" ||sCustomerID == ""){
				var sReturn = RunMethod("BusinessManage","IsReplaseCustomerid",sCertID.trim()+","+sCustomerName.trim());
				if(sReturn == null || sReturn=="Null"||sReturn == ""){
					sCustomerID = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId",null)
				}else{
					sCustomerID = sReturn ;
				}
			}
		}
		
		var SERIALNO = "<%=DBKeyUtils.getSerialNo()%>";
		
		setItemValue(0,0,"SERIALNO",SERIALNO);
		
		setItemValue(0,0,"CustomerID",sCustomerID);
		setItemValue(0,0,"STATE","001");//001:��ɨ��״̬��002��Ԥ��ͨ��.003:���״̬.004:�����״̬.005:��ȡ��״̬
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
	}
	
	function checkTelPhone(){
		//�ж������ֻ����벻���ظ�
		
		//�ֻ�����
		var sMobileTelephone = getItemValue(0,0,"MobileTelephone");
		//������ϵ����
		var sKinshipTel = getItemValue(0,0,"KinshipTel");
		//������ϵ�˺���
		var sContactTel = getItemValue(0,0,"ContactTel");
		
		var myArray =new Array(); 
		//�ѵ绰����Ϊ�յ�ȥ��
		var k=0;
		if(typeof(sMobileTelephone) != "undefined" && sMobileTelephone.length>0){
			myArray[k++] = sMobileTelephone; 
		}
		if(typeof(sKinshipTel) != "undefined" && sKinshipTel.length>0){
			myArray[k++] = sKinshipTel;
		}
		if(typeof(sContactTel) != "undefined" && sContactTel.length>0){
			myArray[k++] = sContactTel;
		}
				
		var flag = "1";
		for(var i=0;i<myArray.length;i++){
			for(var j=i+1;j<myArray.length;j++){
				if(myArray[i] == myArray[j]){
					flag="0";
					break;
				}
			}
		}
		if(flag == "1"){
			return true;
		}else{
			alert("���й�ϵ�ĵ绰�����ظ�����,�����ظ����벢�޸�!");
			return false;
		}
	}
	
	//��������У��
	function checkKinshipName(obj){
		var sName=getItemValue(0,getRow(),"KinshipName");
		if(typeof(sName) == "undefined" || sName.length==0 ){
			//alert("��������������Ϊ��!");
			return false;
		}else{
		if(/\s+/.test(sName)){
			alert("�����������пո�����������");
			setItemFocus(0, 0, "KinshipName");
			return false;
		}
		//�������������Ļ�����ĸ
		if(!(/^[\u4e00-\u9fa5]+|[a-zA-Z]+$/.test(sName))){
			    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)��([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("������������Ƿ�");
				setItemFocus(0, 0, "KinshipName");
				return false;
			    }
			    
			}
		 }
		return true;
	}
	//����������У��
	function checkOtherContactName(){
		var sName=getItemValue(0,getRow(),"OtherContact");
		if(typeof(sName) == "undefined" || sName.length==0 ){
			//alert("������ϵ������������Ϊ��!");
			return false;
		}else{
		if(/\s+/.test(sName)){
			alert("������ϵ���������пո�����������");
			setItemFocus(0, 0, "OtherContact");
			return false;
		}
		//�������������Ļ�����ĸ
		if(!(/^[\u4e00-\u9fa5]+|[a-zA-Z]+$/.test(sName))){
			    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)��([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("������ϵ����������Ƿ�");
				setItemFocus(0, 0, "OtherContact");
				return false;
			    }
			    
			}
		 }
		return true;
	}
	//��λ����У��
	function checkWorkCorpName(){
		var sWorkCorp=getItemValue(0, getRow(), "WorkCorp");
		if(typeof(sWorkCorp) == "undefined" || sWorkCorp.length==0){
			return false;
		}
		if(/\s+/.test(sWorkCorp)){
			alert("��λ���ƺ��пո�����������");
			setItemFocus(0, 0, "WorkCorp");
			return false;
		}
		if(!(/^[a-zA-Z0-9\u4e00-\u9fa5]+$/.test(sWorkCorp))){
			alert("��λ��������Ƿ�");
			setItemFocus(0, 0, "WorkCorp");
			return false;
		}
		return true;
	}
	
	//���֤У��
	function checkType(){
		if(!isCardNo()){
			return;
		}
		var sIdentityId   = getItemValue(0,0,"CertID");
		if(sIdentityId ==""){
		   alert("����д���֤�ţ�");  	
		}
		//�ж��Ƿ����18�꣬С��55��
		if(typeof(sIdentityId)=="undefined" || sIdentityId.length==0 ){
		}else{
		var myDate=new Date(); 
		   var thisYear = myDate.getFullYear(); 
		   var thisMonth = myDate.getMonth()+1; 
		   var thisDay = myDate.getDate(); 
		   var age = myDate.getFullYear() - sIdentityId.substring(6, 10) - 1;
		   if (sIdentityId.substring(10, 12) < thisMonth || sIdentityId.substring(10, 12) == thisMonth && sIdentityId.substring(12, 14) <= thisDay) { 
			   age++; 
			 }
	        if((age>55)||(age<18)){
	        	alert("�ͻ����������18��55֮��");
				setItemFocus(0, 0, "CertID");
	        	return;
	        }
		}
	}
	//���֤������У��
	function isCardNo()  
	{
		var card = getItemValue(0,getRow(),"CertID");
		if(card!=""||card.length!=0){
		if(!checkIdcard(card)){
			return false;
		}
		return true;
		}else{
			//alert("���֤����Ϊ�գ�");
			return false;
		}
	}

	//У�����֤�Ϸ���
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
			
			//�������� 
			if(area[parseInt(idcard.substr(0,2))]==null){
				alert(Errors[4]); 
				setItemFocus(0, 0, "CertID");
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
					setItemFocus(0, 0, "CertID");
					return true;
			        
				}else{ 
					alert(Errors[2]);
					setItemFocus(0, 0, "CertID");
					return false;
				}
				break; 
			case 18: 
				//18λ��ݺ����� 
				//�������ڵĺϷ��Լ��  
				//��������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
				//ƽ������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
				if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
					ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//����������ڵĺϷ���������ʽ 
				}else{
					ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//ƽ��������ڵĺϷ���������ʽ 
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
						setItemFocus(0, 0, "CertID");
						return false;
			        }
				}else{
					alert(Errors[2]);
					setItemFocus(0, 0, "CertID");
					return false;
			    }
				break;
			default:
			    alert(Errors[1]);
				setItemFocus(0, 0, "CertID");
				return false;
				break;
			}	 
	}
	
	//��֤�ֻ�����ȷ��
	function checkMobile(obj){
	    var sMobile = getItemValue(0,getRow(),"MobileTelephone");
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	//alert("�ֻ����벻�ܿ�");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("�ֻ�����������������������"); 
			setItemFocus(0, 0, "MobileTelephone");
	        return false; 
	    } 
	}
	
	//������ϵ�绰��֤�ֻ��Ż�����������ȷ��
	function isCheckMobilePhone(obj){
		var sSchCouTel=getItemValue(0,getRow(),"KinshipTel");
		//�ո��Զ�����
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
		     //alert("������ϵ�˵绰���ܿ�");
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){//���ֻ���
						alert("�ֻ������ʽ��д����"); 
						setItemFocus(0, 0, "KinshipTel");
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("�̶��绰��ʽ��д����"); 
						setItemFocus(0, 0, "KinshipTel");
				        return false; 
					}else{
						alert("�����ʽ��д���Ϸ�");
						setItemFocus(0, 0, "KinshipTel");
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("�̶��绰��ʽ��д����");
						setItemFocus(0, 0, "KinshipTel");
						return false;
					}
				}else{
					alert("������д����");
					setItemFocus(0, 0, "KinshipTel");
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				setItemFocus(0, 0, "KinshipTel");
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("�ֻ�������д����");
								setItemFocus(0, 0, "KinshipTel");
							 return false;
						 }
					}else{
						alert("�̶��绰��ʽ��д����");
						setItemFocus(0, 0, "KinshipTel");
						return false;
					}
				}else{
					alert("������д����");
					setItemFocus(0, 0, "KinshipTel");
					return false;
				}
			}
	}	
	
	//������ϵ�˵绰��֤�ֻ��Ż�����������ȷ��
	function isCheckOtherMobilePhone(obj){
		var sSchCouTel=getItemValue(0,getRow(),"ContactTel");
		//�ո��Զ�����
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
		     //alert("������ϵ�˵绰���ܿ�");
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){//���ֻ���
						alert("�ֻ������ʽ��д����"); 
						setItemFocus(0, 0, "ContactTel");
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("�̶��绰��ʽ��д����"); 
						setItemFocus(0, 0, "ContactTel");
				        return false; 
					}else{
						alert("�����ʽ��д���Ϸ�");
						setItemFocus(0, 0, "ContactTel");
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("�̶��绰��ʽ��д����");
						setItemFocus(0, 0, "ContactTel");
						return false;
					}
				}else{
					alert("������д����");
					setItemFocus(0, 0, "ContactTel");
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				setItemFocus(0, 0, "ContactTel");
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("�ֻ�������д����");
							 setItemFocus(0, 0, "ContactTel");
							 return false;
						 }
					}else{
						alert("�̶��绰��ʽ��д����");
						setItemFocus(0, 0, "ContactTel");
						return false;
					}
				}else{
					alert("������д����");
					setItemFocus(0, 0, "ContactTel");
					return false;
				}
			}
	}	
	
	//У����������벻��С�ڵ���0
	function checkSelfMonthIncome(obj){
		var sSelfMonthIncome=getItemValue(0,getRow(),"SelfMonthIncome");
		if(typeof(sSelfMonthIncome) == "undefined" || sSelfMonthIncome.length==0){
		    //alert("���������벻�ܿ�");
			return false;
		}
		if(parseFloat(sSelfMonthIncome)<=0){
			alert("����������������0��");
			setItemFocus(0, 0, "SelfMonthIncome");
			return false;
		}
	}
	
	//�����ʼ������
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName() %>");
			setItemValue(0,0,"OrgName","<%=CurUser.getOrgName() %>");
			
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
