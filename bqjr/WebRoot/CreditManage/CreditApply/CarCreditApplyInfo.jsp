<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: �������Ŷ������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 �����Ŷ������ҳ�浥������
					 jgao1 2009/10/21 ���Ӽ������Ŷ�ȣ��Լ�ѡ��ͻ����ͱ仯ʱ���Data����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
    //�����ŵ�
    String sSNo = CurARC.getAttribute(request.getSession().getId()+"city");
	if(sSNo == null) sSNo = "";
    System.out.println("-------չ��-------"+sSNo);
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CarCreditApplyInfo";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ñ��䱳��ɫ
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
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
			{"true","","Button","ȷ��","ȷ���������Ŷ������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		
		initSerialNo();//��ͬ��ˮ��
		checkType();//
		InsertCustomer();//
		as_save("myiframe0",sPostEvents);
	}
	
	function InsertCustomer(){
		//�жϵ�ǰ�ͻ��Ƿ����
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sCertID = getItemValue(0,0,"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sCustomerID = getItemValue(0,0,"CustomerID");
		
		//alert("�ͻ�ID��"+sCustomerID+"�ͻ����ͣ�"+sCustomerType+"�ͻ����ƣ�"+sCustomerName+"֤�����룺"+sCertID);
		
		var sStatus = "01";
		var sCustomerOrgType = sCustomerType;
		var sHaveCustomerType = sCustomerType;
		//��ȡ�ͻ�ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sCertID);
		//alert("����ֵ00000��"+sReturn);
		
		if(sReturn == "Null"){
			var sParam = "";
            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;

			sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
        }
	}
		   
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		if(isCardNo()== false){
			return;
		}else{
			saveRecord("doReturn()");
		}
	}
	
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}

	
	/*~[Describe=�����������ڲ�Ʒѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectProductID()
	{
		sProductID = getItemValue(0,0,"ProductID");
		if(typeof(sProductID) == "undefined" || sProductID == "")
		{
			alert("����ѡ���Ʒ����!");
			return;
		}
		//alert("----------"+sProductID);
		sParaString = "ProductType"+","+sProductID;
		//���÷��ز��� 
		setObjectValue("SelectCarBusinessInfo",sParaString,"@BusinessType@0@ProductName@1",0,0,"");
	}
	
	//���ݿͻ����ͣ���д֤����Ϣ
	function selectCustomerType(){
		sCustomerType = getItemValue(0,0,"CustomerType");
		
		if(sCustomerType=="03"){//���˿ͻ�
			//����֤������Ϊ���֤
			setItemValue(0,0,"CertType","Ind01");
		}else if(sCustomerType=="04"){//�Թ͡���˾�ͻ�
			setItemValue(0,0,"CertType","Ent02");
		}else if(sCustomerType=="05"){
			setItemValue(0,0,"CertType","Ent02");
		}else{
			setItemValue(0,0,"CertType","");
		}
	}
	


	//ѡ���Ʒ����ʱ����ʾ��Ӧ���ı���
	function checkType(){
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId = getItemValue(0,0,"CertID");
        //alert("---1111---"+sCustomerName+"--2222----"+sIdentityId);

		//��ȡ�ͻ�ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
		//alert("����ֵ��"+sReturn);
			
	    //���ÿͻ�ID
	    if(sReturn == "Null"){
	    	//��ȡ�ͻ���
			var sSerialNo = getSerialNo("Customer_Info","CustomerID","");
			setItemValue(0,getRow(),"CustomerID",sSerialNo);
	    }else{
	    	//�ѿͻ��ţ����֤������ֻ��
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//�Ѳ�ѯ�Ŀͻ�ID���õ�CustomerID��
	        setItemValue(0,0,"CustomerID",sReturn);
	    }
	}
	
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼
			
			//������ͬ��ʶ
			setItemValue(0,0,"CreditAttribute","0001");
			//��ͬ״̬
			setItemValue(0,0,"ContractStatus","060");
			//��ʼ���汾
			setItemValue(0,0,"ProductVersion","V1.0");
			//��������
			setItemValue(0,0,"ApplyDate","<%=StringFunction.getToday()%>");
			//չ��
            setItemValue(0,0,"Stores","<%=sSNo%>");

			//�������
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			//������
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			//��������
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//�Ǽǻ���
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			//�Ǽ���
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			//�Ǽ�����			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
		setItemValue(0, 0, "ApplySerialNo", sSerialNo);
	}
	
	</script>
	
<script type="text/javascript">
//���֤������У��
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"CertID");
	var sCertType = getItemValue(0,getRow(),"CertType");

	if(sCertType=="Ind01"){//���֤�����������֤����У��
	   checkIdcard(card);
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
			setItemValue(0,0,"CertID","");
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
				setItemValue(0,0,"CertID","");
				return Errors[0]; 
		        
			}else{ 
				alert(Errors[2]); 
				setItemValue(0,0,"CertID","");
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
					setItemValue(0,0,"CertID","");
					return  Errors[3]; 
		        }
			}else{
				alert(Errors[2]);
				setItemValue(0,0,"CertID","");
				return Errors[2]; 
		    }
			break;
		default:
		    alert(Errors[1]);
		    setItemValue(0,0,"CertID","");
			return  Errors[1]; 

			break;
		} 
			 
}

</script>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>