<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "���۱����Ϣ";
	//�������
	String sSql="",sCustomerName="",sCertID="",sMobileTelephone="",sReplaceName="",sReplaceAccount="",sOpenBank="",sArtificialNo="";
	String sOldCityName="",sOldCity="";
	String sProductID="";  //add by yzhang9 CCS-444  ��ƷID �����ж��Ƿ����ֽ��  
	//�����������ѯ�����
	ASResultSet rs = null;
	//���ҳ�������
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	// add by yzhang9 CCS-444
	String sContractSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo")); // ��ͬ��� 
	rs = Sqlca.getASResultSet(new SqlObject("select ProductID from business_contract where SerialNo='"+sContractSerialNo+"'"));
	if(rs.next()){
		sProductID = DataConvert.toString(rs.getString("ProductID"));
	}
	rs.getStatement().close();
	if(sContractSerialNo==null)  sContractSerialNo="";
	// end  by yzhang9 CCS-444
	if(sSerialNo==null)  sSerialNo="";
	%>
	<%/*~END~*/%>
	
	<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ChargeApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setLimit("NewAccount",30); //�޶����ŵ�¼�볤��
	doTemp.setReadOnly("NewAccountName", true);
	
	if("020".equals(sProductID)){ // add by yzhang9 CCS-444   ������ֽ��  ����ʾ '�´����˺ſ�����֧��' �� 'ԭ�����˺ſ�����֧��'
		doTemp.setVisible("NEWBANKBRANCHNAME", true);
		doTemp.setVisible("OLDBANKBRANCHNAME", true);
		doTemp.setReadOnly("OLDBANKBRANCHNAME", true);//ֻ�� 
		doTemp.setReadOnly("NEWBANKBRANCHNAME", true);//ֻ�� 
	}
	
	
	// �ı���۷�ʽ 
	doTemp.setHTMLStyle("NEWREPAYMENTWAY"," onchange=\"javascript:parent.changeRepaymentWay()\" ");
	//add CCS-537 ��ͬ¼�������������˺ŵ���¼�����֣���������Ϊ32λ
	doTemp.setHTMLStyle("NewAccount","style={width:150px}  onkeyup=\"parent.formatNoFomat(this)\" onkeydown=\"parent.formatNoFomat(this)\" onfocus=\"parent.formatNoFomat(this)\" onchange=\"javascript:parent.CheckReplaceAccount();parent.accountChange()\" ");
	//doTemp.setHTMLStyle("NewAccount"," onchange=\"javascript:parent.CheckReplaceAccount()\" ");
	doTemp.setHTMLStyle("RESULTINFO","style={width:150px}");
	doTemp.setHTMLStyle("NewBankName"," onchange=\"javascript:parent.bankNameChange()\" ");
	
	//end
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ�ϱ��","ȷ�ϱ��","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	function bankNameChange(){
		onInfoChange();
	}
	
	function accountChange(){
		onInfoChange();
	}
	
	function onInfoChange(){
		setItemValue(0,0,"REQSTATUS","");
		setItemValue(0,0,"RESULTINFO","");
		setItemValue(0,0,"RESULTCODE","");
		setItemValue(0,0,"SUCCESS","");
	}

	function saveRecord()
	{
		//trimBlank();
		//add CCS-537 ��ͬ¼�������������˺ŵ���¼�����֣���������Ϊ32λ
		var sRepayMentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");
		//if("1" == sRepayMentWay)//���ʽΪ���ۣ�У������ʺŸ�ʽ
		//{
			//var sReturnReplaceAccount=CheckReplaceAccount();
			//if(sReturnReplaceAccount=="error"){
				//return;
			//}
			
		//}
		//end
		if(!vI_all("myiframe0")) return;
		if("1" == sRepayMentWay){
			//���´��۲�ѯ���ص���Ϣ add by zty 201251210
			var saveFlag = getSaveFlag();
			//alert(saveFlag);
			if(saveFlag != "1"){
				var resultinfo = getItemValue(0,getRow(),"RESULTINFO");
				var resultcode = getItemValue(0,getRow(),"RESULTCODE");
				if("S037_02_1000" == resultcode || "S030_00_0003" == resultcode){
					alert("������ȷ�ϱ������ͻ�������֤��");
				}else{
					alert("������ȷ�ϱ����"+resultinfo);
				}
				return;
			}
			
			updateBankCardCheckInfo();
		}
		
		//return;
		
		//��ȡ�����Ŀ����������ۿ��˻��š�������
		ContractSerialno = getItemValue(0,getRow(),"ContractSerialNo");
		NewAccountName = getItemValue(0,getRow(),"NewAccountName");
		CustomerID = getItemValue(0,getRow(),"CustomerID");
		NewBankName = getItemValue(0,getRow(),"NewBankName");
		AccountIndicator = "01";//�ۿ�
		NewAccount = getItemValue(0,getRow(),"NewAccount");
		NewAccount = NewAccount.replace(/\s/ig,'');
		NewCity = getItemValue(0,getRow(),"NewCity");		
		NewRePaymentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");//�µĻ��ʽ1������ 2���Ǵ���
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		NewBankBranch=getItemValue(0,getRow(),"NEWBANKBRANCH"); //add by yzhang9 CCS-444   �������˺�֧�д��� ���µ���ͬ�� 
		//����ͻ���Ϣ������ͻ������к�ͬ�� ���ʽ(����/�Ǵ���);  
		sReturnValue = RunMethod("CustomerManage","UpdateReplaceAccount", AccountIndicator+","+ContractSerialno+","+CustomerID+","+NewAccountName+","+NewBankName+","+NewAccount+","+NewCity+","+NewRePaymentWay+","+NewBankBranch);
	 	 if(sReturnValue=="Success") {
			alert("��������˻���Ϣ�ɹ�!");
		}else{
			alert("��������˻���Ϣʧ��!");
			return;
		}
		as_save("myiframe0","top.close()");
	}
	
	//  add by yzhang9 CCS-444 
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"NewBankName");  //�´����˺ſ����� ȡԭ���������б� 
		var sCity     = getItemValue(0,0,"NewCity");//�´����˺ſ�����ʡ�� 
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
		sBankNo=sReturn[0];// �´����˺ſ�����֧�д��� 
		sBranch=sReturn[1];// �´����˺ſ�����֧������  
		setItemValue(0,0,"NEWBANKBRANCH",sBankNo);
		setItemValue(0,0,"NEWBANKBRANCHNAME",sBranch);
	}
	
	
	function changeRepaymentWay() {
		var srpWay = getItemValue(0, 0, "NEWREPAYMENTWAY");
		var customerName = getItemValue(0, 0, "CustomerName");
		
		if ("1" == srpWay) {
			setItemRequired(0, 0, "NewAccountName", true);
			setItemRequired(0, 0, "NewAccount", true);
			setItemRequired(0, 0, "NewBankName", true);
			setItemRequired(0, 0, "NewCity", true);
			setItemRequired(0, 0, "NewCityName", true);
			setItemValue(0,0,"NewAccountName",customerName);
			//add by zty 20151209
			setItemRequired(0, 0, "REQSTATUS", true);
			setItemRequired(0, 0, "RESULTINFO", true);
			showItem(0, 0, "REQSTATUS", "block");
			showItem(0, 0, "RESULTINFO", "block");
			//�����´����˻��������´����˻��ʺš��´����˻������С��´����˻�ʡ�пɼ�
			showItem(0, 0, "NewAccountName", "block");
			showItem(0, 0, "NewAccount", "block");
			showItem(0, 0, "NewBankName", "block");
			//showItem(0, 0, "NewCity", "block");
			showItem(0, 0, "NewCityName", "block");
			showItem(0,0,"NEWBANKBRANCHNAME", "block");//add by yzhang9 CCS-444 �´����˺ſ�����֧������ 
		} else if ("2" == srpWay) {
			setItemRequired(0, 0, "NewAccountName", false);
			setItemRequired(0, 0, "NewAccount", false);
			setItemRequired(0, 0, "NewBankName", false);
			setItemRequired(0, 0, "NewCity", false);
			setItemRequired(0, 0, "NewCityName", false);
			setItemValue(0,0,"NewAccountName","");
			//add by zty 20151209
			setItemRequired(0, 0, "REQSTATUS", false);
			setItemRequired(0, 0, "RESULTINFO", false);
			hideItem(0,0,"REQSTATUS");
			hideItem(0,0,"RESULTINFO");
			//�����´����˻��������´����˻��ʺš��´����˻������С��´����˻�ʡ�в��ɼ� 
			hideItem(0,0,"NewAccountName");
			hideItem(0,0,"NewAccount");
			hideItem(0,0,"NewBankName");
			//hideItem(0,0,"NewCity");
			hideItem(0,0,"NewCityName");
			hideItem(0,0,"NEWBANKBRANCHNAME");//add by yzhang9 CCS-444  �´����˺ſ�����֧������ 
			
			//jQuery('#REQSTATUS').hide();
			//jQuery('#RESULTINFO').hide();
		}
	}
	
	/*~[Describe=����ʡ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCityName()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NewCity","");
			setItemValue(0,getRow(),"NewCityName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"NewCity",sAreaCodeValue);
					setItemValue(0,getRow(),"NewCityName",sAreaCodeName);			
			}
		}
	}
	
	
	function initRow()
	{	
		var sOpenBank=RunMethod("���÷���","GetColValue","code_library,itemName,itemNo='<%=sOpenBank%>'");
		var sSerialNo =  getItemValue(0,getRow(),"ContractSerialNo");
		var sOldBankBranchNo = RunMethod("���÷���","GetColValue","business_contract,OpenBranch,SerialNo='"+sSerialNo+"'");
		var sOldBankBranchName = RunMethod("���÷���","GetColValue","bankput_info,bankname,bankno='"+sOldBankBranchNo+"'");
		if(sOldBankBranchName == "Null"){sOldBankBranchName = "";}
		setItemValue(0,0,"OLDBANKBRANCHNAME",sOldBankBranchName);//add by yzhang9 CCS-444  ��ʼ�� ԭ�����˺ſ�����֧�� 
		
		if(sOpenBank=="Null") {sOpenBank="";}
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
            //�Ǽ�����Ϣ
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
	    	setItemValue(0,0,"UpdateOrgID","<%=CurUser.getOrgID()%>");
	    	setItemValue(0,0,"UpdateOrgName","<%=CurUser.getOrgName()%>");
	    	setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
	    	setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
	    	setItemValue(0,0,"UpdateDate","<%=StringFunction.getTodayNow()%>");
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "WITHHOLD_CHARGE_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	//add CCS-537 ��ͬ¼�������������˺ŵ���¼�����֣���������Ϊ32λ
	/*
	JIRA������
	���ڡ������˺ű����������ҳ��������֤��  
	1. �����˺ű��������֣�
	2. �����˺ų�����16-19λ֮�䣡
	3. �����˺Ų�����4��5��ͷ��
	*/
	function CheckReplaceAccount(){
		var sReplaceAccount =getItemValue(0,getRow(),"NewAccount");
		sReplaceAccount=sReplaceAccount+"";
		sReplaceAccount=sReplaceAccount.replace(/\s/ig,'');
		//alert(sReplaceAccount);
		
			//var tst = /^\d+$/;
			//if(!tst.test(sReplaceAccount)){
				//alert("�����˺ű��������֣�");
				//return "error";
			//}
			//add by pli 2015/04/09 CCS-609 ��˶ϵͳ֧�ִ����������ӡ����������С�
			//������ѡ�񡱹��������йɷ����޹�˾��Ϊ�ͻ������п������к󣬶Դ����˻��˺ſ������ж����������ж�:��д���˺�Ϊ��625952����ͷ���ҿ���Ϊ16λ
			var sOpenBank = getItemValue(0,getRow(),"NewBankName");//�������д���
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
			//if(typeof(sReplaceAccount) != "undefined" || sReplaceAccount.length != 0){
				//var sFirstStr=sReplaceAccount.substring(0,1);
			//update CCS-578  ������д���/�ſ��˺ſ���������4��ͷ�����п����� by rqiao 20150316
			/*if(sFirstStr=="4"||sFirstStr=="5"){
				alert("�����˺Ų�����4��5��ͷ��");
				return "error";
			}*/
			//if(sFirstStr=="5"){
				//alert("�����˺Ų�����5��ͷ��");
				//return "error";
			//}
			//end
			//}
	}
	//142����������  402ũ�������硢304�������С�310�Ϻ��ֶ���չ���С�789�������С�806����ũ����ҵ���С�794��ݸ���С�790�������С�316�������С�791�Ϻ����С�306�㷢����
	function noSuportBankDeal(serialno,bankcode){
			//���ݿ����û�м�¼ �Ȳ���һ��
		RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","insertCardvalidateInfo","serialno="+serialno);
			
		setItemValue(0,0,"SUCCESS","1111");
		setItemValue(0,0,"RESULTCODE","U000_01_4005");
		setItemValue(0,0,"RESULTINFO","�ݲ�֧�ִ�������֤");
		setItemValue(0,0,"REQSTATUS","�ݲ�֧����֤");
		setItemValue(0,0,"OUID","");
		setItemValue(0,0,"APPLYTIME","");
		
	}
	
	//var flag = false;
	//add by zty 20151202 ���п�У��
	function checkBankCard(obj){
		obj.disabled = true; 
		var serialno = getItemValue(0,getRow(),"ContractSerialNo");//��ͬ��
		var realname = getItemValue(0,getRow(),"NewAccountName");//��ʵ����
		var certno = getItemValue(0,getRow(),"CertID");//���֤��
		var bankcardtype = "DEBIT_CARD";//���п����� ��ǿ�
		var bankcode = getItemValue(0,getRow(),"NewBankName");//���б���
		//alert("bankcode=="+bankcode);
		var servicetype = "INSTALLMENT";//��������
		var bankcardno = getItemValue(0,getRow(),"NewAccount");//���п���
		bankcardno = bankcardno.replace(/\s/ig,'');
		var mobileno = getItemValue(0,getRow(),"TelPhone");//�ֻ�����
		var infotype = "1";//������Դ p2p
		var customerid = getItemValue(0,getRow(),"CustomerID");//�ͻ�ID
		var newCity = getItemValue(0,getRow(),"NewCity");	
		//����֤ǰУ���Ƿ��Ǵ��� �Լ����п��ź������Ƿ�Ϊ��
		var sRepayMentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");
		if("1" != sRepayMentWay){
			alert("�»��ʽ�Ǵ��ۣ��������п���֤��");
			obj.disabled = false; 
			return;
		}else{
			if("" == bankcode){
				alert("��ѡ���´����˻�������");
				obj.disabled = false; 
				return;
			}
			if("" == bankcardno){
				alert("�������´����˻��˺�");
				obj.disabled = false; 
				return;
			}
		}
		if("142" == bankcode){
			var sReturnReplaceAccount=CheckReplaceAccount();
			if(sReturnReplaceAccount=="error"){
				obj.disabled = false; 
				return;
			}else{
				noSuportBankDeal(serialno,bankcode);
				obj.disabled = false; 
				return;
			}
		}
		//���ݿ����û�м�¼ �Ȳ���һ��
	   if("402" == bankcode || "304" == bankcode || "310" == bankcode || "789" == bankcode || "806" == bankcode || 
				"794" == bankcode || "790" == bankcode || "316" == bankcode || "791" == bankcode){
		   noSuportBankDeal(serialno,bankcode);
		   obj.disabled = false; 
		   return;
	   }
		//��ѯ����ƽ̨��Ӧ�����б���
		var dkbankcode = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getBankCodeDK","xfbankcode="+bankcode);//�������б���  
		//alert("dkbankcode=="+dkbankcode);
		//У�鿨BIN
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","checkCardBin","xfbankcode="+bankcode+",bankcardno="+bankcardno);
		if("0" == sReturn){
			alert("����������п��Ż򿪻��д�������������ύ��");
			obj.disabled = false; 
			return false;
		}
		if("2" == sReturn){
			bankcardtype = "CREDIT_CARD"; //���ǿ�
		}
		//if("2" == sReturn){
			//alert("���ÿ���֧�ִ���");
			//obj.disabled = false; 
			//return false;
		//}
		
		//���ݿ����û�м�¼ �Ȳ���һ��
		if("306" == bankcode){
			 noSuportBankDeal(serialno,bankcode);
			 obj.disabled = false; 
			 return;
		 }
		
		//У����ô���
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getCheckTimes","serialno="+serialno);
		//alert("���ô���"+sReturn);
		if(parseInt(sReturn) >= 3){
			alert("�ú�ͬ������޸Ĵ����Ѿ�����3�Σ����������޸ģ�");
			obj.disabled = false; 
			return false;
		}
		//У����ǰ�Ƿ��ѵ��ù�
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","isHadChecked","serialno="+serialno+",realname="+realname+",certno="+certno+",xfbankcode="+bankcode+",bankcardno="+bankcardno);
		if("fail" == sReturn){
			//alert("�ú�ͬ��ǰû��У���");
		}else{
			var strs = sReturn.split("@");
			var resultcode = strs[0];
			var resultinfo = strs[1];
			var success = strs[2];
			var reqstatus = strs[3];
			var ouid = strs[4];
			var applytime = strs[5];
			setItemValue(0,0,"SUCCESS",success);
			setItemValue(0,0,"RESULTCODE",resultcode);
			setItemValue(0,0,"RESULTINFO",resultinfo);
			setItemValue(0,0,"REQSTATUS",getStatusZh(reqstatus));
			setItemValue(0,0,"OUID",ouid);
			setItemValue(0,0,"APPLYTIME",applytime);
			
			//var saveFlag = getSaveFlag();
			//if("0" != saveFlag){
				 obj.disabled = false;
			 //}
			
			return false;
		}
		
		//���ô���ƽ̨У�����п�
		$.ajax({
			type:"post",
			url: sWebRootPath+"/servlet/idCheck",
			data: {"serialno":serialno,"realname":realname,"certno":certno,"bankcardtype":bankcardtype,"dkbankcode":dkbankcode,"xfbankcode":bankcode,"servicetype":"INSTALLMENT","bankcardno":bankcardno,"mobileno":mobileno,"infotype":"1","customerid":customerid},
			timeout: 40000,
			async: true,
			dataType:"json",
			success: function(data){
			     var resultcode = data.resultcode;
				 var resultinfo = data.info;
				 var result = data.result;
				 var reqstatus = data.reqstatus;
				 var ouid = data.ouid;
				 var applytime = data.applytime;
				 setItemValue(0,0,"SUCCESS",result);
				 setItemValue(0,0,"RESULTCODE",resultcode);
				 setItemValue(0,0,"RESULTINFO",resultinfo);
				 setItemValue(0,0,"REQSTATUS",getStatusZh(reqstatus));
				 setItemValue(0,0,"OUID",ouid);
				 setItemValue(0,0,"APPLYTIME",applytime);
				 
				 //var saveFlag = getSaveFlag();
				 //if("0" != saveFlag){
					 obj.disabled = false;
				 //}
			},
			error:function(data){
				var resultcode = data.resultcode;
				var resultinfo = data.info;
				var result = data.result;
				var reqstatus = data.reqstatus;
				var ouid = data.ouid;
				var applytime = data.applytime;
				setItemValue(0,0,"SUCCESS",result);
				setItemValue(0,0,"RESULTCODE",resultcode);
				setItemValue(0,0,"RESULTINFO",resultinfo);
				setItemValue(0,0,"REQSTATUS",getStatusZh(reqstatus));
				setItemValue(0,0,"OUID",ouid);
				setItemValue(0,0,"APPLYTIME",applytime);
				
				obj.disabled = false;
			}

		})
		
		
		return "0";
		
	}
	//����״̬[01����֤�ɹ���02����֤ʧ�ܣ�03���޷��ؽ����04��δ����ƽ̨��05��δ��������]
	function getStatusEn(statusZh){
		if("��֤�ɹ�" == statusZh){
			return "01";
		}
		if("��֤ʧ��" == statusZh){
			return "02";
		}
		if("�޷��ؽ��" == statusZh){
			return "03";
		}
		if("δ����ƽ̨" == statusZh){
			return "04";
		}
		if("δ��������" == statusZh){
			return "05";
		}
		if("�ݲ�֧����֤" == statusZh){
			return "06";
		}
	}
	function getStatusZh(statusEn){
		if("01" == statusEn){
			return "��֤�ɹ�";
		}
		if("02" == statusEn){
			return "��֤ʧ��";
		}
		if("03" == statusEn){
			return "�޷��ؽ��";
		}
		if("04" == statusEn){
			return "δ����ƽ̨";
		}
		if("05" == statusEn){
			return "δ��������";
		}
		if("06" == statusEn){
			return "�ݲ�֧����֤";
		}
	}
	
	function updateBankCardCheckInfo(){
		var serialno = getItemValue(0,getRow(),"ContractSerialNo");//��ͬ��
		var customerid = getItemValue(0,getRow(),"CustomerID");//�ͻ�ID
		var realname = getItemValue(0,getRow(),"NewAccountName");//��ʵ����
		var certno = getItemValue(0,getRow(),"CertID");//���֤��
		var bankcardtype = "DEBIT_CARD";//���п����� ��ǿ�
		var servicetype = "INSTALLMENT";//��������
		var bankcardno = getItemValue(0,getRow(),"NewAccount");//���п���
		bankcardno = bankcardno.replace(/\s/ig,'');
		var mobileno = getItemValue(0,getRow(),"TelPhone");//�ֻ�����
		var bankcode = getItemValue(0,getRow(),"NewBankName");//���б���
		if("142" == bankcode){
			bankcardtype = "CREDIT_CARD";
		}else if("402" == bankcode || "304" == bankcode || "310" == bankcode || "789" == bankcode || "806" == bankcode || 
				"794" == bankcode || "790" == bankcode || "316" == bankcode || "791" == bankcode){
			
		}else{
			//У�鿨BIN
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","checkCardBin","xfbankcode="+bankcode+",bankcardno="+bankcardno);
			if("0" == sReturn){
				alert("��bin������,��������������п��Ż����������Ƿ���ȷ");
				return false;
			}
			if("2" == sReturn){
				bankcardtype = "CREDIT_CARD"; //���ǿ�
			}
		}
		
		
		var dkbankcode = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getBankCodeDK","xfbankcode="+bankcode);//�������б���  
		
		var success = getItemValue(0,getRow(),"SUCCESS");
		var resultinfo = getItemValue(0,getRow(),"RESULTINFO");
		var resultcode = getItemValue(0,getRow(),"RESULTCODE");
		var reqstatus = getItemValue(0,getRow(),"REQSTATUS");
		var ouid = getItemValue(0,getRow(),"OUID");
		var applytime = getItemValue(0,getRow(),"APPLYTIME");
		
		RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","operateCardQueryInfo","serialno="+serialno+",customerid="+customerid+",realname="+realname+",certno="+certno+",bankcardtype="+bankcardtype+",servicetype="+servicetype+",bankcardno="+bankcardno+",mobileno="+mobileno+",xfbankcode="+bankcode+",dkbankcode="+dkbankcode+",success="+success+",resultinfo="+resultinfo+",resultcode="+resultcode+",reqstatus="+getStatusEn(reqstatus)+",ouid="+ouid+",applytime="+applytime);
	}
	
	/**
	 * ���п��Ÿ�ʽ��
	 onkeyup=\"parent.formatNoFomat(this)\" onkeydown=\"parent.formatNoFomat(this)\" onfocus=\"parent.formatNoFomat(this)\"
	 
	 **/
	function formatNoFomat(BankNo){
    	if (BankNo.value == "") return;
		var account = new String (BankNo.value);
		account = account.substring(0,23); /*�ʺŵ�����, �����ո����� */
		if (account.match (".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}") == null){
			/* ���ո�ʽ */
			if (account.match (".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}|" + ".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}|" +
			".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}|" + ".[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{7}") == null){
				var accountNumeric = accountChar = "", i;
				for (i=0;i<account.length;i++){
					accountChar = account.substr (i,1);
					if (!isNaN (accountChar) && (accountChar != " ")) accountNumeric = accountNumeric + accountChar;
				}
				account = "";
				for (i=0;i<accountNumeric.length;i++){    /* �ɽ����¿ո��Ϊ-,Ч��Ҳ���� */
					if (i == 4) account = account + " "; /* �ʺŵ���λ����ӿո� */
					if (i == 8) account = account + " "; /* �ʺŵڰ�λ����ӿո� */
					if (i == 12) account = account + " ";/* �ʺŵ�ʮ��λ������ӿո� */
					if (i == 16) account = account + " ";/* �ʺŵ�ʮ��λ������ӿո� */
					account = account + accountNumeric.substr (i,1)
				}
			}
		} else {
			account = " " + account.substring (1,5) + " " + account.substring (6,10) + " " + account.substring (14,18) + "-" + account.substring(18,25);
		}
		if (account != BankNo.value) BankNo.value = account;
	}
	
	//ȥ���ո��ύ
	function trimBlank(){
		var account=getItemValue(0,getRow(),"NewAccount");//���п���
		account=account.replace(/\s/ig,'');
		setItemValue(0,0,"NewAccount",account);
	}
	//��ȡ������
	function getSaveFlag(){
		var resultcode = getItemValue(0,getRow(),"RESULTCODE");
		var returnStr = RunJavaMethodSqlca("com.amarsoft.app.check.BankCardCheck","getSaveFlag","resultcode="+resultcode);
		return returnStr;
	}
	
	//end
	
	</script>

<script language=javascript>	
	AsOne.AsInit();
	//showFilterArea();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
