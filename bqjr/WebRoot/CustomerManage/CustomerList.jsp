<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   --cchang  2004.12.2
               
        Tester: 
        Content: �ͻ���Ϣ�б�
        Input Param:
            CustomerType���ͻ�����
                01����˾�ͻ���
                0110��������ҵ�ͻ���
                0120����С����ҵ�ͻ���
                02�����ſͻ���
                0210��ʵ�弯�ſͻ���
                0220�����⼯�ſͻ���
                03�����˿ͻ�
                0310�����˿ͻ���
                0320�����徭Ӫ����
            CustomerListTemplet���ͻ��б�ģ�����          
        ���ϲ���ͳһ�ɴ����:--MainMenu���˵��õ�����
        Output param:
           CustomerID���ͻ����
           CustomerType���ͻ�����                                        
           CustomerName���ͻ�����
           CertType���ͻ�֤������                                      
           CertID���ͻ�֤������
        History Log: 
            DATE    CHANGER     CONTENT
            2005-07-20  fbkang  ҳ������
            2005/09/10 zywei �ؼ����
            2009/08/13 djia ����AmarOTI --> queryCusomerInfo()
            2009/10/12 pwang �޸ı�ҳ����漰�ͻ������жϵ����ݡ�
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "�ͻ���Ϣ�б�"   ; // ��������ڱ��� <title> PG_TITLE </title>  
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sSql = "";//��� sql��� 
    String sUserID = CurUser.getUserID(); //�û�ID
    String sOrgID = CurOrg.getOrgID(); //����ID
    
    //����������    ���ͻ����͡��ͻ���ʾģ���
    String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
    String sTempletNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
    String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID")); //�û��������ͼ��ID���ڼ��ſͻ�����ʱ���ɴ���ȷ����ҳ������ʾ�İ�ť  add by cbsu 2009-10-21
    //����ֵת��Ϊ���ַ���
    if(sCustomerType == null) sCustomerType = "";
    if(sTempletNo == null) sTempletNo = "";
    if(sCurItemID == null) sCurItemID = ""; // add by cbsu 2009-10-21
    //���ҳ�����
    
    //add by syang 2009/11/06 �Ƿ����ű�׼���ſͻ���ѯ�����ſͻ���ѯΪ���ſͻ�����ڣ����Բ鿴����Ͻ�ڵļ��ſͻ���Ϣ��
    boolean bGroupAdmin = false;
    
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
    //ͨ����ʾģ�����ASDataObject����doTemp
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
    doTemp.setKeyFilter("CB.CustomerID");

    //���ӹ����� 
    
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //����datawindows
    ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
    //������datawindows����ʾ������
    dwTemp.setPageSize(20); //add by hxd in 2005/02/20 for �ӿ��ٶ�
    //����DW��� 1:Grid 2:Freeform
    dwTemp.Style="1";      
    //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.ReadOnly = "1";
        
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sCustomerType+","+sOrgID+","+CurOrg.getSortNo());
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    //out.println(doTemp.SourceSql); //����datawindow��Sql���÷���
    
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
    <%
    String sbCustomerType = sCustomerType.substring(0,2);
    
    //����Ϊ��
        //0.�Ƿ���ʾ
        //1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
        //2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
        //3.��ť����
        //4.˵������
        //5.�¼� 
        //6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
    String sButtons[][] = {
            //�ڼ��ſͻ�����ʱ�����û����"���ſͻ���ѯ"����ʾ"����"��ť add by cbsu 2009-10-21
            {(sCurItemID.equals("02")?"false":"true"),"","Button","����","����һ����¼","newRecord()",sResourcesPath}, 
            {"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
            //�ڼ��ſͻ�����ʱ�����û����"���ſͻ���ѯ"����ʾ"ɾ��"��ť add by cbsu 2009-10-21
            {(sCurItemID.equals("02")?"false":"true"),"","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}, 
            {(sbCustomerType.equals("01")?"true":"false"),"","Button","�ͻ���ϢԤ��","�ͻ���ϢԤ��","alarmCustInfo()",sResourcesPath},
            {(sbCustomerType.equals("02")?"false":"true"),"","Button","�����ص�ͻ�����","�����ص�ͻ�����","addUserDefine()",sResourcesPath},
            {(sbCustomerType.equals("02") || sCustomerType.equals("0320")?"false":"true"),"","Button","Ȩ������","Ȩ������","ApplyRole()",sResourcesPath},
            {(sbCustomerType.equals("02") && !sCurItemID.equals("02")?"true":"false"),"","Button","ת�ƹܻ�Ȩ","���ſͻ��ƽ�","transCust()",sResourcesPath},
            {(sbCustomerType.equals("01")?"true":"false"),"","Button","�ͻ���ģת��","�ı�ͻ���ҵ��ģ","changeCustomerType()",sResourcesPath},
            {(sbCustomerType.equals("03")?"true":"false"),"","Button","�ͻ�����ת��","�ı�ͻ�����","changeCustomerType()",sResourcesPath},
            {(sbCustomerType.equals("01")?"true":"false"),"","Button","���ſͻ���������","���ſͻ���������","searchCustRela()",sResourcesPath},
            {(sbCustomerType.equals("01")?"false":"false"),"","Button","�϶��ͻ���ģ","�϶��ͻ���ģ","confirmScale()",sResourcesPath},
            {"false","","Button","�ͻ�����","�鿴�ͻ�������Ϣ������ҵ����Ϣ","viewCustomerInfo()",sResourcesPath},
            {(sbCustomerType.equals("02")?"false":"true"),"","Button","�ͻ�������ѯ","��ѯ�ͻ�������Ϣ","queryCusomerInfo()",sResourcesPath}
        };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
    <script type="text/javascript">

    //---------------------���尴ť�¼�------------------------------------
    /*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
    function newRecord(){
        var sCustomerType='<%=sCustomerType%>'; //--�ͻ�����
        var sCustomerID ='';                                        //--�ͻ�����
        var sReturn ='';                                                //--����ֵ���ͻ���¼����Ϣ�Ƿ�ɹ�
        var sReturnStatus = '';                                 //--��ſͻ���Ϣ�����
        var sStatus = '';                                               //--��ſͻ���Ϣ���״̬      
        var sReturnValue = '';                                  //--��ſͻ�������Ϣ
        var sCustomerOrgType ='';                               //--�ͻ���������
        var sHaveCustomerType = "";
        var sHaveCustomerTypeName = "";
        var sHaveStatus = "";

        //���ſͻ�ѡ���ʵ�� ����  ��  ���⼯�š������ڲ����ּ��ſͻ������ͣ���˽��˶δ���ע�͵�
        //if(sCustomerType == "02"){
        //    sCustomerType = selectCode("CustomerType","���ſͻ�����","0220","02.+");
        //    if(typeof(sCustomerType) == "undefined" || sCustomerType.length == 0 || sCustomerType == '_CANCEL_'){
        //        return;
        //    }
        // }
      
        //�ͻ���Ϣ¼��ģ̬�����   
        //�������ֿͻ����ͣ���Ϊ���ƶԻ����չʾ��С
        if(sCustomerType.substring(0,2) == "01"||sCustomerType.substring(0,2) == "03")
            sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=350px;dialogHeight=200px;center:yes;status:no;statusbar:no");
        else
        	sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=350px;dialogHeight=150px;center:yes;status:no;statusbar:no");                
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
                }else{
                    alert("�ͻ��ţ�"+sCustomerID+"����"+sHaveCustomerTypeName+"�ͻ�����ҳ�汻�Լ����������ȷ�ϣ�");
                }
                return;
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
                    if(sStatus == "05")
                    {
                        if(confirm("�ͻ��ţ�"+sCustomerID+"�ѳɹ����룬Ҫ��������ÿͻ���Ȩ����")) //�ͻ��ѳɹ����룬Ҫ��������ÿͻ��Ĺܻ�Ȩ��
                            popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurOrg.getOrgID()%>","");
                    }else if(sStatus == "04"){
                        alert("�ͻ��ţ�"+sCustomerID+"�ѳɹ�����!");
                    }else if(sStatus == "01"){
                        alert("�ͻ��ţ�"+sCustomerID+"�����ɹ�!"); //�����ͻ��ɹ�
                    }                                   
                //���ÿͻ�û�����κ��û�������Ч��������ǰ�û�����ÿͻ�������Ч�������ÿͻ��������û�������Ч���������˿ͻ�/���幤�̻�/ũ��/����С�飩�Ѿ�����ͻ�
                }else if(sReturn == "2"){
                    alert("����ͻ��ţ�"+sCustomerID+"�Ŀͻ�����Ϊ"+sHaveCustomerTypeName+"�������ڱ�ҳ�����룡");
                //�Ѿ������ͻ�
                }else{
                    alert("�����ͻ�ʧ�ܣ�"); //�����ͻ��ɹ�
                    return;
                }
            }           
            if(sStatus == "01" || sStatus == "04"){
                //�������С��ҵ��Ҫ�������϶�״̬Ϊδ�϶�.
                if(sCustomerType == "0120")
                    RunMethod("CustomerManage","UpdateCustomerStatus",sCustomerID+","+"0");             
            }
            openObject("Customer",sCustomerID,"001");
            reloadSelf();
        }
    }
    
    /*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord(){
    	var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
            return;
        }
        
        if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
            sReturn = PopPageAjax("/CustomerManage/DelCustomerBelongActionAjax.jsp?CustomerID="+sCustomerID+"","","");
            if(sReturn == "ExistApply"){
                alert(getBusinessMessage('113'));//�ÿͻ���������ҵ��δ�սᣬ����ɾ����
                return;
            }
            if(sReturn == "ExistApprove"){
                alert(getBusinessMessage('112'));//�ÿͻ����������������ҵ��δ�սᣬ����ɾ����
                return;
            }
            if(sReturn == "ExistContract"){
                alert(getBusinessMessage('111'));//�ÿͻ�������ͬҵ��δ�սᣬ����ɾ����
                return;
            }
            if(sReturn == "DelSuccess"){
                alert(getBusinessMessage('110'));//�ÿͻ�������Ϣ��ɾ����
                reloadSelf();
            }
        }
    }
    
    //�ͻ���ϢԤ��
    function alarmCustInfo(){
    	var sCustomerID = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
        }else {
            sReturn = autoRiskScan("005","ObjectType=Customer&ObjectNo="+sCustomerID);      
        }       
    }

    /*~[Describe=���ſͻ��ƽ�;InputParam=��;OutPutParam=��;]~*/
    function transCust(){
    	var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
    	var sManUserID   = getItemValue(0,getRow(),"UserID");
	    if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
	        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return;
	    }
	    if (typeof(sManUserID)=="undefined" || sManUserID.length==0){
	        alert("�����쳣����ǰ�ͻ�δ�ҵ���ܻ��ͻ�������");
	        return;
	    }
	
	    var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
	    if(typeof(sReturn) == "undefined" || sReturn.length == 0){
	        return;
	    }
	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];    //�ͻ�����Ȩ
	    sReturnValue2 = sReturnValue[1];    //��Ϣ�鿴Ȩ
	    sReturnValue3 = sReturnValue[2];    //��Ϣά��Ȩ
      	if(sReturnValue1 != "Y"){
            alert("��û�иÿͻ�����Ȩ");
            return;
       	}
			//��鼯�ſͻ�δ���������ҵ��
			//����ֵ��
   	 		//* 0 δ�����ҵ�����Ϊ0(ͨ��)<br/>
 			//* 1 ����;�������<br/>
 			//* 2 ��δ����ͨ���������������<br/>
 			//* 3 ��δ�Ǽ���ɵĺ�ͬ<br/>  
     	sReturn = RunMethod("BusinessManage","GroupCustBizCheck",sCustomerID);
     	if(sReturn == "1"){
				alert("����;������룬����ת��");
				return ;
     	}else if(sReturn == "2"){
				alert("��δ����ͨ���������������������ת��");
				return ;
     	}else if(sReturn == "3"){
				alert("��δ�Ǽ���ɵĺ�ͬ������ת��");
				return ;
     	}
     	
     	 //���ſͻ�����ڵĽ�ɫΪ���У�027�����У�227��֧�У�427��������ͨ��27��ɫ
       sParaString = "OrgID,<%=CurOrg.getSortNo()%>,RoleID,27";
       sReturn = selectObjectValue("UserInRoleAndOrg",sParaString);
       //����û��ر��˴˴��ڻ���ʲôҲûѡ��ʱ���ʹ���ֹ
       if(typeof(sReturn) == 'undefined' 
           || sReturn == '_CANCEL_'
           || sReturn == '_NONE_'
           || sReturn == '_CLEAR_'
           || sReturn.length == 0
           ){
            return;
       }
       stdUID=sReturn.split("@")[0];           //ѡ����û�ID
       stdOrgID = sReturn.split("@")[1];
       if(stdUID == "<%=CurUser.getUserID()%>"){
           alert("�ƽ�Ŀ���û�Ϊ��ǰ�û����ˣ��ƽ�������");
           return;
       }
       if(stdOrgID == null || stdOrgID.length == 0){
				alert("��ǰѡ����û������쳣���޻�����");
				return;
       }
       sReturn = RunMethod("CustomerManage","TransGroupCustMana",sCustomerID+","+stdUID);
       if(parseInt(sReturn) == 1){
           alert("�ͻ��ţ�"+sCustomerID+"���ܻ�Ȩת�Ƴɹ���");
           reloadSelf();
       }
    }
    /*~[Describe=�ı�ͻ�����;InputParam=��;OutPutParam=��;]~*/
    function changeCustomerType(){
    	var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        var sType="<%=sCustomerType%>".substring(0,2);
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }

        var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
    	if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        	return;
   		}
    	var sReturnValue = sReturn.split("@");
    	sReturnValue1 = sReturnValue[0];    //�ͻ�����Ȩ
    	sReturnValue2 = sReturnValue[1];    //��Ϣ�鿴Ȩ
    	sReturnValue3 = sReturnValue[2];    //��Ϣά��Ȩ
                        
        if(sReturnValue1 == "Y"){
			//��;ҵ����
			sCount = RunMethod("BusinessManage","CustomerUnFinishedBiz",sCustomerID);
			if(sCount != "0"){
				alert("����ʧ�ܣ��ÿͻ�����;���룬����ת����");
				return;
			}
            
            sCustomerType = PopPage("/CustomerManage/ChangeCustomerTypeDialog.jsp?CustomerID="+sCustomerID+"&Type="+sType,"","dialogWidth=20;dialogHeight=8;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
            if(sCustomerType == "" || sCustomerType == "_CANCEL_" || typeof(sCustomerType) == "undefined") return;
            //����˵����CustomerID,CustomerType,UserID,OrgID
            sReturn = RunMethod("CustomerManage","ChangeCustomerType",sCustomerID+","+sCustomerType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
            if(sReturn == "1"){
                alert(getBusinessMessage('106'));//�ı�ͻ����ͳɹ���"
                reloadSelf();
                return;
            }else{
                alert(getBusinessMessage('107'));//�ı�ͻ�����ʧ�ܣ������²�����
                return;
            }
        }else{
            alert(getBusinessMessage('249'));//����Ȩ���ĸÿͻ���Ȩ�ޣ�
        }
    }
    
    /*~[Describe=���ſͻ���������;InputParam=��;OutPutParam=��;]~*/
    function searchCustRela(){
        var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }

        var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
	    if (typeof(sReturn) == "undefined" || sReturn.length == 0){
	            return;
	    }
	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];    //�ͻ�����Ȩ
	    sReturnValue2 = sReturnValue[1];    //��Ϣ�鿴Ȩ
	    sReturnValue3 = sReturnValue[2];    //��Ϣά��Ȩ
                        
        if(sReturnValue1 == "Y"){
            popComp("RelationSearchList","/CustomerManage/GroupManage/RelationSearchList.jsp","CustomerID="+sCustomerID,"","");
        }else{
			alert("��û�иÿͻ�����Ȩ�����ܽ�������");
         	return;
        }
    }
    /*~[Describe=�϶��ͻ���ģ;InputParam=��;OutPutParam=��;]~*/
    function confirmScale(){
        var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        alert("�����!");
    }

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
    function viewAndEdit(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sCustomerType = "<%=sCustomerType%>";
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}

     	sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
    	if (typeof(sReturn) == "undefined" || sReturn.length == 0){
        return;
    	}

	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];
	    sReturnValue2 = sReturnValue[1];
	    sReturnValue3 = sReturnValue[2];
                        
		if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2"){    
			openObject("Customer",sCustomerID,"001");
			reloadSelf();
		}else{
			//���Ϊ���ſͻ�����ڣ�������ֻ����ʽ�鿴
			<%if(bGroupAdmin){%>
				openObject("Customer",sCustomerID,"003");
			<%}else{%>
				alert(getBusinessMessage('115'));//�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ�
			<%}%>
		}
    }
    
    /*~[Describe=�����ص���Ϣ����;InputParam=CustomerID,ObjectType=Customer;OutPutParam=��;]~*/
    function addUserDefine(){
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        if(confirm(getBusinessMessage('114'))){ //������ͻ���Ϣ�����ص�ͻ���������?
            var sRvalue= PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=Customer&ObjectNo="+sCustomerID,"","");
            alert(getBusinessMessage(sRvalue));
        }
    }
        
    /*~[Describe=Ȩ������;InputParam=CustomerID,ObjectType=Customer;OutPutParam=��;]~*/          
    function ApplyRole(){
        //��ÿͻ����
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));
            return;
        }
        //�������״̬
        sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");           
        if(sApplyStatus == "1"){
            alert(getBusinessMessage('116'));//���ύ����,�����ٴ��ύ��
            return;
        }
        //��ÿͻ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
        var sBelongAttribute = getItemValue(0,getRow(),"BelongAttribute");        
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");        
        if(sBelongAttribute == "��" && sBelongAttribute1 == "��" && sBelongAttribute2 == "��" && sBelongAttribute3 == "��"){
            alert(getBusinessMessage('117'));//���Ѿ�ӵ�иÿͻ�������Ȩ�ޣ�
            return;
        }
        
        popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurOrg.getOrgID()%>","");
        reloadSelf();
    }
    
    function viewCustomerInfo(){
        //��ÿͻ����
        var sCustomerID = getItemValue(0,getRow(),"CustomerID");        
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));
            return;
        }
        popComp("EntInfo","/CustomerManage/EntManage/EntInfo.jsp","CustomerID="+sCustomerID,"");
    }
    
    /*~[Describe=��ѯ�ͻ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
    function queryCusomerInfo(){
    	var sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	var sCertID = getItemValue(0,getRow(),"CertID");
    	var sCertTypeName = getItemValue(0,getRow(),"CertTypeName");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        
        var sReturn = PopPageAjax("/CustomerManage/QueryCustomerAjax.jsp?CertID="+sCertID,"","");
        if(typeof(sReturn) != "undefined"){
            sReturn=getSplitArray(sReturn);
            sStatus=sReturn[0];
            sMessage=sReturn[1];
            if(sStatus == "0"){
                sReturn = "�����ɹ������״��룺" + "Q001" + "���Ŀͻ���Ϊ��"+ sMessage + "�������ݿ�ɹ���";
            }else{
                sReturn = "������ʾ��"+"Q002"+" ����ʧ�ܣ�ʧ����Ϣ��" + sMessage;
            }
            alert(sReturn);
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
    /**
     * 
     * ����ѡ��򣬴���һ�������ţ�ѡ����Ӧ����
     * ��������ط�ʹ�õ�ѡ�����Ƚ�Ƶ����������ɿ��ǽ��˺�������common.js
     * @author syang 2009/10/14
     * @param codeNo ������
     * @param Caption �����Ի�������
     * @param defaultValue ѡ���Ĭ��ֵ
     * @param filterExpr ��ItemNo����������ʽ����ƥ��
     * @return ѡ���ItemNo
     */
    function selectCode(codeNo,Caption,defaultValue,filterExpr){
        if(typeof(filterExpr) == "undefined"){
            filterExpr = "";
        }
        var codePage = "/CustomerManage/SelectCode.jsp";
        var sPara = "CodeNo="+codeNo
                        +"&Caption="+Caption
                        +"&DefaultValue="+defaultValue
                        +"&ItemNoExpr="+encodeURIComponent(filterExpr)  //������Ҫ������ת������������&,%,+�����ַ������������
                        ;
        style = "resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no";
        sReturnValue = PopPage(codePage+"?"+sPara,"",style);
        return sReturnValue;
    }
    </script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
    AsOne.AsInit();
    init(); 
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
    my_load(2,0,'myiframe0');
</script>   
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>