<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jschen  2010.03.17
		Tester:
		Describe: �Ŵ�ҵ�񲹵��б�;
		Input Param:
			ReinforceFlag��110 �貹���Ŵ�ҵ��
			               120 �Ѳ����Ŵ�ҵ��
		Output Param:
			
		HistoryLog:
			    
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ŵ�ҵ�񲹵��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql="";
	String sClauseWhere="";
	//���ҳ�����
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";


%>
<%/*~END~*/%>
	
	
	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//��SQL������ɴ������
	String sTempletNo="InputBusinessList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sReinforceFlag.equals("010")){  //�貹���Ŵ�ҵ��
		doTemp.WhereClause += " and ManageOrgID ='"+CurOrg.getOrgID()+"'";
	}
	if(sReinforceFlag.equals("020")){  //��������Ŵ�ҵ��
		doTemp.WhereClause += " and ManageUserID ='"+CurUser.getUserID()+"'";
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sReinforceFlag);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
				{"true","","Button","����","����һ���Ŵ�ҵ��Ϳͻ�������Ϣ","InputInfo()",sResourcesPath},
				{"true","","Button","�������пͻ�","�������пͻ�","ChangeCustomer()",sResourcesPath},
				{"false","","Button","����","�򿪺�ͬ����ҳ��,���Թ���һ�ʶ��","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","�ϲ���ͬ","���к�ͬ�ϲ�����","UnitContract()",sResourcesPath},
				{"true","","Button","�޸�ҵ��Ʒ��","�޸���ѡ�е��Ŵ�ҵ���ҵ��Ʒ��","ChangeBizType()",sResourcesPath},
				{"true","","Button","�������","����ѡ�е��Ŵ�ҵ����Ϊ���״̬","FinishCreditBusiness()",sResourcesPath},
				{"true","","Button","���²���","����ѡ�е��Ŵ�ҵ����Ϊ�貹��״̬","secondFinishCreditBusiness()",sResourcesPath},
			};
	
	//�貹���Ŵ�ҵ��
	if(sReinforceFlag.equals("010")){
		sButtons[6][0] = "false";
	}
	//��������Ŵ�ҵ��
	if(sReinforceFlag.equals("020")){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[2][0] = "true";
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���ǿͻ���ҵ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputInfo(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");	
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		var sCustomerName = getItemValue(0,getRow(),"CustomerName");
		var sCustomer = "";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			//ҵ��δ�����ͻ�
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
				/*----------------------------------�����ͻ�begin----------------------------*/
				//ѡ��ͻ�����
				var sReturnValue = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","_self","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
				if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0 || sReturnValue == '_CANCEL_'){
					return;
				}
				var sCustomerType = sReturnValue;
				
			    //�ͻ���Ϣ¼��ģ̬�����   
			    //�������ֿͻ����ͣ���Ϊ���ƶԻ����չʾ��С
			    if(sCustomerType.substring(0,2) == "01"||sCustomerType.substring(0,2) == "03") 
			        sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=14;center:yes;status:no;statusbar:no");
			    else
			        sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
			    //�ж��Ƿ񷵻���Ч��Ϣ
			    if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_'){
			        sReturnValue = sReturnValue.split("@");
			        //�õ��ͻ�������Ϣ
			        sCustomerOrgType = sReturnValue[0];
			        sCustomerName = sReturnValue[1];
			        sCertType = sReturnValue[2];
			        sCertID = sReturnValue[3];
			    
			        //���ͻ���Ϣ����״̬
			        sReturnStatus = RunMethod("CustomerManage","CheckCustomerAction",sCustomerType+","+sCustomerName+","+sCertType+","+sCertID+",<%=CurUser.getUserID()%>");
			        //�õ��ͻ���Ϣ������Ϳͻ���
			        sReturnStatus = sReturnStatus.split("@");
			        sStatus = sReturnStatus[0];
			        sCustomerID = sReturnStatus[1];
			        sHaveCustomerType = sReturnStatus[2];
			        sHaveCustomerTypeName = sReturnStatus[3];
			        sHaveStatus = sReturnStatus[4];
					//�����ǹ���ҳ�棬��鵱ǰ����Ŀͻ��ͻ������Ƿ��뵱ǰҳ������Ŀͻ�����һ��
					if(sStatus != "01"){
						if(sCustomerType != sHaveCustomerType){
							alert("�ͻ��ţ�"+sCustomerID+"�����ڣ�"+sHaveCustomerTypeName+"�������ڴ�����");
							return;
						}
					}
			        
			        //02Ϊ��ǰ�û�����ÿͻ�������Ч����
			        if(sStatus == "02"){
			            if(sHaveCustomerType == sCustomerType){
			                alert(getBusinessMessage('105')); //�ÿͻ��ѱ��Լ����������ȷ�ϣ�
			                sCustomer = sCustomerID+"@"+sCustomerName+"@";
			            }else{
			                alert("�ͻ��ţ�"+sCustomerID+"����"+sHaveCustomerTypeName+"�ͻ�����ҳ�汻�Լ����������ȷ�ϣ�");
			            }
			            //return;
			        }

			        //01Ϊ�ÿͻ������ڱ�ϵͳ��
			        if(sStatus == "01"){                
			            //ȡ�ÿͻ����
			            sCustomerID = getNewCustomerID();
			        }
			        //01 �������Ϊ�޸ÿͻ�
			        //04 û�к��κοͻ���������Ȩ
			        //05 �������ͻ���������Ȩʱ���ж����ݿ����
			        if(sStatus == "01" || sStatus == "04" || sStatus == "05"){
			            //����˵��CustomerID,CustomerName,CustomerType,CertType,CertID,Status,CustomerOrgType,UserID,OrgID
			            var sParam = "";
			            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
			                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;
			            sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
			            //���ÿͻ��������û�������Ч������Ϊ��ҵ�ͻ��͹������� ,��Ҫ��ϵͳ����Ա����Ȩ��
			            if(sReturn == "1"){
			                if(sStatus == "05"){
			                    if(confirm("�ͻ��ţ�"+sCustomerID+"�ѳɹ����룬Ҫ��������ÿͻ���Ȩ����")) //�ͻ��ѳɹ����룬Ҫ��������ÿͻ��Ĺܻ�Ȩ��
			                        popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurOrg.getOrgID()%>","");
			                }else if(sStatus == "04"){
			                    alert("�ͻ��ţ�"+sCustomerID+"�ѳɹ�����!");
			                }else if(sStatus == "01"){
			                    alert("�ͻ��ţ�"+sCustomerID+"�����ɹ�!"); //�����ͻ��ɹ�
			                }  
			                sCustomer = sCustomerID+"@"+sCustomerName+"@";                                 
			            //���ÿͻ�û�����κ��û�������Ч��������ǰ�û�����ÿͻ�������Ч�������ÿͻ��������û�������Ч���������˿ͻ�/���幤�̻�/ũ��/����С�飩�Ѿ�����ͻ�
			            }else if(sReturn == "2"){
			                //alert("����ͻ��ţ�"+sCustomerID+"�Ŀͻ�����Ϊ"+sHaveCustomerTypeName+"�������ڱ�ҳ�����룡");
			                alert("����ͻ��ţ�"+sCustomerID+"�Ŀͻ�����Ϊ"+sHaveCustomerTypeName+"�������ڱ�ҳ�����룡\r\n�ÿͻ�ֻ����Ϊ"+sHaveCustomerTypeName+"���룬�������Խ��пͻ���ģת��");
			            //�Ѿ������ͻ�
			            }else{
			                alert("�����ͻ�ʧ�ܣ�"); //�����ͻ�ʧ��
			                return;
			            }
			        } 
			        if(sStatus == "01" || sStatus == "04"){
			            //��ͻ����������ͻ���Ϣ���ܲ�ͬ���������С��ҵ��Ҫ�������϶�״̬Ϊ���϶�.
			            if(sCustomerType == "0120")
			                RunMethod("CustomerManage","UpdateCustomerStatus",sCustomerID+","+"1");  
			        }
		    	}
			    /*----------------------------------�����ͻ�end----------------------------*/				
			    
				if (typeof(sCustomer)=="undefined" || sCustomer.length==0) {
					alert("Ҫ���ǵĿͻ���Ϣ������,����ѡ��ͻ���");	
					return;
				}else{
					sCustomer = sCustomer.split("@");
					sCustomerID = sCustomer[0];
					sCustomerName = sCustomer[1];
					//���ͻ���Ϣ���µ�BUSINESS_CONTRACT
					RunMethod("��Ϣ����","UpdateBCCustomer",sSerialNo+","+sCustomerID+","+sCustomerName+","+"<%=StringFunction.getToday()%>");  
				}
			}

			//ѡ��ҵ��Ʒ��
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
				//ѡ��ҵ��Ʒ��
				var sReturn = selectBusinessType(sCustomerID,sSerialNo);
				//δѡ��ҵ��Ʒ��ʱֱ�ӷ���
				if(sReturn == "false"){
					return;
				}
			}
			
		    //���ݺ�ͬ��ˮ�ţ����������
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			//����δ���֮ǰ���鵵����ǿ����Ϊ��
			sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?Pigeonholed=Y&ObjectType=ReinforceContract&ObjectNo="+sSerialNo,"","");
			reloadSelf();	
		}
	}

	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=�ͻ���sCustomerID����ͬ��ˮ��sSerialNo;OutPutParam=��;]~*/
	function selectBusinessType(sCustomerID,sSerialNo){
		var sBusinessType = "";
		sReturn = RunMethod("PublicMethod","GetColValue","CustomerType,CUSTOMER_INFO,String@CustomerID@"+sCustomerID);
		sReturn = sReturn.split("@");
		//���Ϊ���˿ͻ�
		if(sReturn[1].substr(0,2) == "03"){
			if(sReturn[1] == "0310"){
				sBusinessType = setObjectValue("SelectIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else if(sReturn[1] == "0320"){
				sBusinessType = setObjectValue("SelectIndEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else{
				alert("��ѡ����˿ͻ����߸��徭Ӫ����");
				return "false";
			}
		}	
		//���Ϊ��˾�ͻ�		
		else if(sReturn[1].substr(0,2) == "01"){
			if(sReturn[1] == "0110"){ 
				sBusinessType = setObjectValue("SelectInputEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else if(sReturn[1] == "0120"){
				sBusinessType = setObjectValue("SelectInputSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			}else{
				alert("��ѡ�������ҵ�ͻ�������С��ҵ�ͻ���");
				return "false";
			}
		}

		if (!(sBusinessType=='_CANCEL_' || typeof(sBusinessType)=="undefined" || sBusinessType.length==0 || sBusinessType=='_CLEAR_' || sBusinessType=='_NONE_'))
		{
			sBusinessType = sBusinessType.split("@");
			RunMethod("��Ϣ����","UpdateBusinessType",sSerialNo+","+sBusinessType[0]+","+"<%=StringFunction.getToday()%>");
		}else{
				return "false";
		}
	}

	/*~[Describe=�������пͻ�;InputParam=��;OutPutParam=��;]~*/
	function ChangeCustomer(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sCustomerName   = getItemValue(0,getRow(),"CustomerName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			if(typeof(sCustomerID) != "")
				if(!confirm("��ҵ���ѹ����ͻ�"+sCustomerName+"���Ƿ����¹���?"))return;
			sParaString = "OrgID,"+"<%=CurUser.getOrgID()%>";
			sCustomer = setObjectValue("SelectAllCustomer",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
			if(sCustomer == "_CLEAR_"){
				alert("��ղ�����Ч��");
				return;
			}
			if (typeof(sCustomer)=="undefined" || sCustomer.length==0 || sCustomer == "_CANCEL_" || sCustomer == "_NONE_"){
				return;
			}else{
				sCustomer = sCustomer.split("@");
				sCustomerID = sCustomer[0];
				sCustomerName = sCustomer[1];
				//���ͻ���Ϣ���µ�BUSINESS_CONTRACT
				RunMethod("��Ϣ����","UpdateBCCustomer",sSerialNo+","+sCustomerID+","+sCustomerName+","+"<%=StringFunction.getToday()%>");  
			}
		}
		reloadSelf();
	}

	/*~[Describe=�ϲ���ͬ;InputParam=��;OutPutParam=��;]~*/
	function UnitContract(){
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			var sReturn = popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType,"dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			if(sReturn=="true"){
				reloadSelf();
			}
		}
	}
	
	/*~[Describe=�޸�ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function ChangeBizType(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("Ҫ���ǵĿͻ���Ϣ������,����ѡ��ͻ���");
			return;	
		}
		//ѡ��ҵ��Ʒ��
		var sReturn = selectBusinessType(sCustomerID,sSerialNo);
		if(sReturn == "false")
			return ;
		reloadSelf();
	}

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function CreditBusinessInfo(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			if(sReinforceFlag=="010"){
				sParamString = "ViewID=001&ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				reloadSelf();
			}else{
				sParamString = "ViewID=002&ObjectType=ReinforceContract&ObjectNo="+sSerialNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				reloadSelf();
			}
		}
	}
	
	/*~[Describe=���Ŵ���ɲ��Ǳ�־;InputParam=��;OutPutParam=��;]~*/
	function FinishCreditBusiness(){
		//��ͬ��ˮ�š��ͻ���š�ҵ��Ʒ��
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		//��ʾ���ǽ����б�
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else {	
			if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
				alert("�ͻ����Ϊ�գ����Ȳ��ǿͻ���");
				return;
			}else{
				if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
					alert("ҵ��Ʒ��Ϊ�գ����Ȳ���ҵ��Ʒ�֣�");
					return;
				}else{
					sReturn = autoRiskScan("012","ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID,10);	
					if(sReturn != true){
						return;
					}	
					RunMethod("��Ϣ����","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag+","+sBusinessType);
					sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&ObjectNo="+sSerialNo,"","");
					if(sReturn == "true"){
						alert("������ɣ���ҵ����ת�������������ҵ���б�!");
					}
				}
				reloadSelf();	
			}
		}
	}

	/*~[Describe=���²���;InputParam=��;OutPutParam=��;]~*/
	function secondFinishCreditBusiness(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		} else {
			RunMethod("��Ϣ����","UpdateReinforceFlag",sSerialNo+","+sReinforceFlag+"");
			sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType=ReinforceContract&Pigeonholed=Y&ObjectNo="+sSerialNo,"","");
			if(sReturn == "true"){
				alert("�ñ��Ŵ�ҵ���ѷ����貹�������Ŵ��б������²���!");
			}			
			reloadSelf();
		}
	}

    /*~[Describe=�����¿ͻ�ID;InputParam=��;OutPutParam=��;]~*/
    function getNewCustomerID(){
    	var sTableName = "CUSTOMER_INFO";//����
		var sColumnName = "CustomerID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
        return sSerialNo;
    }
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
