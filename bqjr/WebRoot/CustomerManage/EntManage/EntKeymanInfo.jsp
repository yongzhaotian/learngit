<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --�ؼ�����Ϣ;
		Input Param:
			CustomerID: --��ǰ�ͻ����
			RelativeID: --�����ͻ����
			Relationship: --������ϵ
			EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output Param:
			
		HistoryLog:
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         �°汾�ĸ�д		
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ؼ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sTempletNo = "EntKeymanInfo";//ģ���

	//�������������ͻ����롢�����ͻ����롢������ϵ���༭Ȩ��
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���ҳ�����
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	//����ֵת��Ϊ���ַ���
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
/* 	if(!(sRelativeID == null || sRelativeID.equals("")))
	{
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	} */

	//����������
	//doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo like '01%' and length(ItemNo)>2 order by SortNo ");
	//doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo not like 'Ent%' order by SortNo ");
    	
	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=\"...\" onclick=parent.selectCustomer()><font color=red>(�����ѡ)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//���ò���͸����¼������������͸���
    dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,,#InputUserId,#CustomerType)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");
  	
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRelativeID+","+sRelationShip);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ:
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"false","","Button","����","�����߹���Ϣ","newRecord()",sResourcesPath},
		{(sEditRight.equals("02")?"true":"false"),"All","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","�߹���Ϣ����","�鿴�߹���Ϣ����","viewKeymanInfo()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var flag = false;//�жϸ߹���Ϣ���������û�����(false)���Ǵ�ϵͳ��ѡ��(true)

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	//add by wlu 2009-02-19
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntKeymanInfo.jsp?EditRight=02","_self","");
	}	

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
		if(bIsInsert)
		{
			var relationship  = getItemValue(0,getRow(),"RelationShip");
			
			if(relationship == "0100"){
				var sPara = "CustomerID=" + "<%=sCustomerID%>";
				var hasKeyMan =  RunJavaMethodSqlca("com.amarsoft.app.als.customer.common.action.GetKeyMan","hasKeyMan",sPara);
				if (hasKeyMan == "true"){
					alert("�Ѿ����ڷ��˴���(�߹�)");
					return;
				}
			}
			
			//����ǰ���й�����ϵ���
			if (!RelativeCheck()) return;
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			var ct = getItemValue(0,getRow(),"CustomerType");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=���ظ߹���Ϣ����ҳ��;InputParam=��;OutPutParam=��;]~*/
	//add by wlu 2009-02-19
	function viewKeymanInfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		if(typeof(sRelativeID) == "undefined" || sRelativeID == "")
		{
			alert("���ȱ��棡");
			return;
		}
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		sReturn = RunMethod("CustomerManage","CheckRolesAction",sRelativeID+",<%=CurUser.getUserID()%>");
    if (typeof(sReturn) == "undefined" || sReturn.length == 0){
    	return;
    }

    var sReturnValue = sReturn.split("@");
    sReturnValue1 = sReturnValue[0];
    sReturnValue2 = sReturnValue[1];
    sReturnValue3 = sReturnValue[2];
                        
    if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2"){    		
			openObject("Customer",sRelativeID+"&<%=sCustomerScale%>","001");
   		//reloadSelf();
		}else
		{
		    alert(getBusinessMessage('115'));//�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ�
		}
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntKeymanList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--������ϵ
		OpenPage("/CustomerManage/EntManage/EntKeymanInfo.jsp?RelationShip="+sRelationShip+"&RelativeID="+sRelativeID+"&EditRight=<%=sEditRight%>", "_self","");
	}
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID = getItemValue(0,getRow(),"CertID");//--֤������
        
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //��ÿͻ�����
	        var sColName = "CustomerID@CustomerName";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//���ÿͻ����
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");							
			} 
			
			//�����֤�ĳ��������Զ��������������ֶ�
			if (!GetBirthday()) return;  
		}     
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������
		sParaString = "OrgID"+","+"<%=CurUser.getOrgID()%>";		
		//sReturn = setObjectValue("SelectManager",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		
		//ʵ����չ���:�����û��Լ��������Ϣʱ,ֻ��ո߹�����,���Ǵ�ϵͳ�������ѯ����,����� ֤�����͡�֤������͸߹������ֶ�;ʵ���ֶι�����ʾ���ܡ�add by zhuang 2010-03-30
		sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		sObjectNoString = selectObjectValue("SelectManager",sParaString,sStyle);
		sValueString = "@RelativeID@0@CustomerName@1@CertType@2@CertID@3";
		sValues = sValueString.split("@");

		var i=sValues.length;
	    i=i-1;
	    if (i%2!=0){
	    	alert("setObjectValue()���ز����趨����!\r\n��ʽΪ:@ID����@ID�ڷ��ش��е�λ��...");
	        return;
	    }else{   
	        var j=i/2,m,sColumn,iID;    
	        if(typeof(sObjectNoString)=="undefined"){
	            
	            return; 
	        }else if(String(sObjectNoString)==String("_CANCEL_") ){
	            return;
	        }else if(String(sObjectNoString)==String("_CLEAR_")){
	        	 setItemDisabled(0,0,"CertType",false);
                 setItemDisabled(0,0,"CertID",false);
                 setItemDisabled(0,0,"CustomerName",false);
                 setItemValue(0,getRow(),"CustomerName","");
                 if(flag){
                	 setItemValue(0,getRow(),"CertType","");
                	 setItemValue(0,getRow(),"CertID","");
                 }
                 flag = false;
	        }else if(String(sObjectNoString)!=String("_NONE_") && String(sObjectNoString)!=String("undefined")){
	            sObjectNos = sObjectNoString.split("@");
	            for(m=1;m<=j;m++){
	                sColumn = sValues[2*m-1];
	                iID = parseInt(sValues[2*m],10);
	                if(sColumn!="")
	                    setItemValue(0,0,sColumn,sObjectNos[iID]);
	            }  
	            flag = true;
	        }
	        sCustomerName = getItemValue(0,0,"CustomerName");
	        if( String(sObjectNoString)!=String("_CLEAR_") && typeof(sCustomerName) != "undefined" && sCustomerName != "" ){
				setItemDisabled(0,0,"CertType",true);
				setItemDisabled(0,0,"CertID",true);
				setItemDisabled(0,0,"CustomerName",true);
				setItemDisabled(0,0,"CustomerType",true);  //added by yzheng
		    }else{
				setItemDisabled(0,0,"CertType",false);
				setItemDisabled(0,0,"CertID",false);
				setItemDisabled(0,0,"CustomerName",false);
				setItemFocus(0,0,"CustomerName");
			}
	    }
		//�����֤�ĳ��������Զ��������������ֶ�,xing
		if (!GetBirthday()) return;
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;

			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
		else{
			setItemReadOnly(0,0,"RelationShip",true);  //�������ʱ����
		}
	}
	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RelativeCheck()
	{
		sCustomerID   = getItemValue(0,0,"CustomerID");//--�ͻ�����		
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������			
		sRelationship = getItemValue(0,0,"RelationShip");//--������ϵ
		if (typeof(sRelationship) != "undefined" && sRelationship != "")
		{
			var sMessage = PopPageAjax("/CustomerManage/EntManage/RelativeCheckActionAjax.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationship+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			var messageArray = sMessage.split("@");
			var isRelationExist = messageArray[0];
			var info = messageArray[1];
			if (typeof(sMessage)=="undefined" || sMessage.length==0) 
			{
				return false;
			}
			else if(isRelationExist == "false"){
				alert(info);
				return false;
			}
			else if(isRelationExist == "true"){
				setItemValue(0,0,"RelativeID",info);
			}
		}
		
		return true;
	}
	
	/*~[Describe=�������֤�Ż�ȡ��������;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function GetBirthday()
	{		
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
	
			
		//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
		if(sCertType =='Ind01' || sCertType =='Ind08')
		{
			if (!CheckLicense(sCertID))
			{
			//	alert(getBusinessMessage('156'));//�������֤��������				
			//	return false;
			}
			
			//�����֤�е������Զ�������������,���Ա�����(add by fhuang 06.11.28)
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
		return true;			
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


<%@	include file="/IncludeEnd.jsp"%>