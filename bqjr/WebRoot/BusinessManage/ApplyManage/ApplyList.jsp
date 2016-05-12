<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:FWang 2005.5.13
 * Tester:
 *
 * Content: ��ҳ��������ʾҵ�������¼
 * Input Param:
 * Output param:
 *
 * History Log: zpsong 2005.6.1 
 *              fwang  2005.6.24 �޸ĺ�ͬ�ջز��� 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
    //��ȡ��ѯ���ͺͲ�ѯ����	
	String sCondition = DataConvert.toRealString(iPostChange,(String)request.getParameter("Condition"));
	String sCondition2 = sCondition;
	//����ѯ�����е������ַ�����ת��
	if(sCondition==null||sCondition.equals(""))
	{
	 	sCondition = " 1^2";	 	
	}
	else
	{
		sCondition = " 1^1 and "+sCondition;
	}
	sCondition2 = StringFunction.replace(sCondition,"^","=");
	sCondition2 = StringFunction.replace(sCondition2,"*","%");

%>
<html>
<head>
<!--��������-->
<title>�����б�</title> 
</head>
<%
	//�б��ͷ
	String sHeaders[][] = { 
							  {"CustomerID","�ͻ�����"},
							  {"CustomerName","�ͻ�����"},
							  {"ApplyStatusName","����״̬"},
							  {"SerialNo","������ˮ��"},
							  {"OccurTypeName","��������"},
							  {"BusinessTypeName","ҵ��Ʒ��"},		
							  {"BusinessSum","���"},
							  {"BusinessCurrencyName","����"},
							  {"TermMonth","������"},
							  {"TermDay","������"},
							  {"ApplyDate","��������"},
							  {"OrgName","�������"},
							  {"UserName","������"},
							  {"ContractStatus","��Ӧ��ͬ״̬"},
							  {"ApplyStatus","����״̬"},
							  {"BusinessType","ҵ��Ʒ��"},
							  {"FinishOrg","��������"},
							  {"ApplyType","���뷽ʽ"},
							  {"OccurType","��������"}
							};   				   		
	
	//����SQL���
	String sSql = "select CustomerID,CustomerName, ContractStatus," +
	       "ApplyStatus,getItemName('ApplyStatus',ApplyStatus) as ApplyStatusName, " +
		   "SerialNo, "+
		   "BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
		   "BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName,"+
		   "getItemName('OccurType',OccurType) as OccurTypeName,TermMonth,TermDay,ApplyDate,FinishOrg,ApplyType,OccurType,"+
	       "getOrgName(OperateOrg) as OrgName, "+
	       "getUserName(OperateUser) as UserName "+
	       "from BUSINESS_APPLY " +
	       "where "+sCondition2;	
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);	    
	//�Ա���и��¡����롢ɾ������ʱ��Ҫ������������   
	doTemp.UpdateTable = "BUSINESS_APPLY";                                
	doTemp.setKey("SerialNo",true);
    doTemp.setVisible("ContractStatus,ApplyStatus,BusinessType,FinishOrg,ApplyType,OccurType",false);
    //������������
    doTemp.setType("BusinessSum","Number");
    //���ö����ʽ
    doTemp.setAlign("BusinessCurrencyName","2");
    //��html��ʽ
    doTemp.setHTMLStyle("CustomerID,SerialNo"," style={width:120px} ondblclick=\"javascript:parent.my_DBLClick()\"");
	doTemp.setHTMLStyle("CustomerName"," style={width:160px} ondblclick=\"javascript:parent.my_DBLClick()\"");
	doTemp.setHTMLStyle("ApplyDate,OccurTypeName,UserName,InputTime,ConsultClassifyName"," style={width:80px} ondblclick=\"javascript:parent.my_DBLClick()\""); 
	doTemp.setHTMLStyle("BusinessSum,ApplyStatusName,BusinessTypeName,OrgName"," style={width:100px}  ondblclick=\"javascript:parent.my_DBLClick()\"");
	doTemp.setHTMLStyle("BusinessCurrencyName,TermMonth,TermMDay,UserName"," style={width:80px}  ondblclick=\"javascript:parent.my_DBLClick()\"");
   
	//����ASDataWindow���󣬲���һ���ڱ�ҳ��������������ASDataWindow����������ASDataObject����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
					

%> 
<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top bgcolor='#DCDCDC'>
    <td>
    	<table>
	    	<tr>
			<!--�������������顢ɾ��˳�����а�ť-->
	 		    <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ѯ","ѡ���ѯ����","javascript:my_query()",sResourcesPath)%>
	    		</td>
                <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","��������","javascript:my_add()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�鿴/�޸�","�鿴���޸�����","javascript:my_info()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ɾ��","ɾ������","javascript:my_del()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�ύ","�ύ����","javascript:my_submit()",sResourcesPath)%>
	    		</td>
	            <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�ջ�","�ջ�����","javascript:my_callback()",sResourcesPath)%>
	    		</td>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡҵ�������","��ӡҵ�������","javascript:my_print()",sResourcesPath)%>
	    		</td>
				<td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�鿴��������","�鿴��������","javascript:my_HQ()",sResourcesPath)%>
	    		</td>
                <td>
                    <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�鿴��������","�鿴��������","javascript:my_BR()",sResourcesPath)%>
	    		</td>
                <td>
	                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ͬ�Ǽ�","��ͬ�Ǽ�","javascript:my_addContract()",sResourcesPath)%>
	    		</td>
			</tr>
		</table>
    </td>
</tr>
<tr>
    <td colpsan=3>
		<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
</table>
</body>
</html>
<script type="text/javascript">
    
    //����һ������
	function my_add()
	{	
		sApplyInfo = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ApplyManage/createApplyPreMessage.jsp?rand="+randomNumber(),"NewApply","dialogWidth=20;dialogHeight=17;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");
		if(typeof(sApplyInfo) != "undefined" && sApplyInfo.length != 0)
		{			
			//��ȡ�������͡��������͡������˴��롢���������ƺͿͻ�����
			sApplyInfo    = sApplyInfo.split("@");
			sOccurType    = sApplyInfo[0];
			sApplyType    = sApplyInfo[1];
			sCustomerID   = sApplyInfo[2];
			sCustomerName = sApplyInfo[3];	
			sCustomerType = sApplyInfo[4];	
			sBusinessType = sApplyInfo[5];
			if(typeof(sOccurType) != "undefined" && sOccurType.length != 0&&typeof(sApplyType) != "undefined" && sApplyType.length != 0)
			{
				var sTableName = "BUSINESS_APPLY";//����
				var sColumnName = "SerialNo";//�ֶ���
				var sPrefix = "";//ǰ׺
		
				//��ȡ��ˮ��
				var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
                //alert(sSerialNo);
                if(typeof(sSerialNo) != "undefined" && sSerialNo.length != 0)
                {							
                    //��ҵ��������Ϣ��(BUSINESS_APPLY)������һ����¼
                    self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ApplyManage/createApplyAction.jsp?SerialNo="+sSerialNo+"&OccurType="+sOccurType+"&ApplyType="+sApplyType+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&BusinessType="+sBusinessType+"&CustomerType="+sCustomerType+"&rand="+randomNumber(),"","dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
                    //������������ˮ�ź�ҵ��Ʒ������ҵ����Ϣ����ҳ��	
                   OpenWindow("/BusinessManage/ApplyManage/ApplyDetail.jsp?ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType+"&ApplyType="+sApplyType+"&OccurType="+sOccurType+"&Condition=<%=sCondition%>","_top");
                }
			}
		}
	}

    //��ѯ
    function my_query()
    {
        sReturnValue = self.showModalDialog("ApplyChoice.jsp?rand="+randomNumber(),"","dialogWidth=32;dialogHeight=32;center:yes;status:no;statusbar:no");
		if(sReturnValue != "doCancel" && typeof(sReturnValue) != "undefined")
		{	
            sReturnValue=sReturnValue.split("@");
	        sCondition=sReturnValue[0];
	        sType=sReturnValue[1];
            window.open("ApplyList.jsp?Condition="+sCondition+"&rand="+randomNumber(),"_self","");
        }   
    }

    //�鿴/�޸�����
    function my_info()
	{
		//ҵ����ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		//ҵ��Ʒ��
		sBusinessType=getItemValue(0,getRow(),"BusinessType");
		//���뷽ʽ
        sApplyType=getItemValue(0,getRow(),"ApplyType");
		//��������
		sOccurType=getItemValue(0,getRow(),"OccurType");

		sCustomerID = getItemValue(0,getRow(),"CustomerID"); 
        if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert("��ѡ��һ�����룡");
			return;
		}	
	
		popComp("ApplyDetail","/BusinessManage/ApplyManage/ApplyDetail.jsp","ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType+"&ApplyType="+sApplyType+"&OccurType="+sOccurType+"&Condition=<%=sCondition%>","","");
		
		//OpenWindow("/BusinessManage/ApplyManage/ApplyDetail.jsp?ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&BusinessType="+sBusinessType+"&ApplyType="+sApplyType+"&OccurType="+sOccurType+"&Condition=<%=sCondition%>","_top");
	}
	
    //ɾ������,ֻ������״̬Ϊδ�ύ��11�����������ɾ��
	function my_del()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined"||sSerialNo.length==0)
		{
		   alert("��ѡ��һ�����룡");
		   return;
		}
	    //�������״̬
		sApplyStatus=getItemValue(0,getRow(),"ApplyStatus");
		if(sApplyStatus!="11")
		{
		alert("���������ύ,����ɾ����");
		return;
		}
		if(confirm("��ȷ��ɾ�������룿"))
		{
		var sReturnValue=self.showModalDialog("delApplyAction.jsp?SerialNo="+sSerialNo+"&rand="+randomNumber(),"","dialogWidth=32;dialogHeight=32;center:yes;status:no;statusbar:no");
		if(sReturnValue=="Success")
			{
			   alert("ɾ���ɹ���")
			   self.location.reload();
			}
		 else
			{
			   alert("ɾ��ʧ�ܣ�������ɾ��һ�Σ�");
			   return;
			} 
		}
	}
	
    //�ύ
    function my_submit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		sStatus = getItemValue(0,getRow(),"ApplyStatus"); 
		sUpdateTable = "BUSINESS_APPLY";
		sColumns="ApplyStatus";
		sColumnsValue=21;
	    if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert("��ѡ��һ�����룡");
			return;
		}else if(sStatus != "11" )
		{
			alert("����״̬Ϊδ�ύ����������ύ��");
		}else
		{
		    //�ύǰԤ��
            var sReturn3;
            sReturn3 = popComp("ScenarioAlarm.jsp","/PublicInfo/ScenarioAlarm.jsp","OneStepRun=yes&ScenarioNo=001&ObjectType=ApplySerialNo&ObjectNo="+sSerialNo,"dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
            if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
            {
                alert("�����Ǹ���ֵĴ���");
                return;
            }else if (sReturn3 >= 0) //�ɹ� 
            {
                alert("�ɹ�������ףһ�£�"+sReturn3);    
                if( sReturn3 <= 50 )
                	return;
            }else  //ʧ��
            {
                alert("���أ���ʧ���� :..( ");
                return;
            }
            

            //�ύ�������´η������ڡ��Լ�����������Ϣ
			sReturn = self.showModalDialog("<%=sWebRootPath%>/PublicInfo/updateTable.jsp?TableName="+sUpdateTable+"&Key=SerialNo&KeyValue="+sSerialNo+"&Column="+sColumns+"&ColumnValue="+sColumnsValue+"&rand="+randomNumber(),"","dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if (typeof(sReturn)=="undefined" || sReturn != 'Y') 
			{
				alert("�ύʧ�ܣ������²���");
				return 0;
			}else
			{
				alert("�ύ�ɹ�!");
				self.location.reload();
			}
		}
	}

    //�ջ�
	function my_callback()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		//��������״̬Ϊ"���ύ����δ�Ǽ�"21�������Ӧ�ĺ�ͬ״̬Ϊ"δǩ��ͬ"10�����������ջ�
		sApplyStatus=getItemValue(0,getRow(),"ApplyStatus");
		sContractStatus=getItemValue(0,getRow(),"ContractStatus");
        if(sApplyStatus=="21"&&sContractStatus=="10")
		{
			sUpdateTable = "BUSINESS_APPLY";
			sColumns="ApplyStatus";
			sColumnsValue=11;
			
			//�ջ�
			sReturn = self.showModalDialog("<%=sWebRootPath%>/PublicInfo/updateTable.jsp?TableName="+sUpdateTable+"&Key=SerialNo&KeyValue="+sSerialNo+"&Column="+sColumns+"&ColumnValue="+sColumnsValue+"&rand="+randomNumber(),"","dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if (typeof(sReturn)=="undefined" || sReturn != 'Y') 
				{
					alert("�ύʧ�ܣ������²���");
					return 0;
				}else
				{
					alert("�ջسɹ�!");
					self.location.reload();
				}
		}
		//��������Ѿ��Ǽ����������ʾ"�������ѱ����еǼǣ���Ҫ����ɾ���Ǽ���Ϣ������ջ�"����������Ѿ��Ǽ��˺�ͬ������ʾ"�������Ѿ��ǼǺ�ͬ��Ϣ����Ҫ��ɾ����ͬ������ջ�"
		else if(sApplyStatus!="21"&&sApplyStatus!="11")//�ѵǼǷ��������
		{
		  alert("�������ѱ����еǼǣ���Ҫ����ɾ���Ǽ���Ϣ������ջ�!");
		  return;
		}
		else if(sContractStatus!="10")//�ѵǼǺ�ͬ
		{
		  alert("�������Ѿ��ǼǺ�ͬ��Ϣ����Ҫ��ɾ����ͬ������ջ�!");
		  return;
		}
	}
	
    //��ӡ
	function my_print()
	{
		
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
	
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert("��ѡ��һ��ҵ��");
			return;
		}else if ( sApplyStatus=='11')
		{
			alert("�ñ�ҵ����δ�ύ�����ܴ�ӡ��");
			return;
		}else
		{
		 self.open("<%=sWebRootPath%>/BusinessManage/ApplyManage/BusinessApplySheet.jsp?ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&rand=" + randomNumber(),"",OpenStyle);
		}

	}
    
    //�ǼǺ�ͬ
	function my_addContract()
	{
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ��ҵ��");
			return;
		}else if ( sApplyStatus=='11')
		{
			alert("�ñ�ҵ����δ�ύ�����ܵǼǺ�ͬ��");
			return;
		}
		else
		{
			sReturnValue = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/BusinessInfo/AddContractAction.jsp?ObjectNo="+ sSerialNo +"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=20;center:no;status:no;statusbar:no");
            if (sReturnValue != "false" && typeof(sReturnValue) != "undefined")
                window_open("<%=sWebRootPath%>/BusinessManage/BusinessInfo/BusinessDetail.jsp?ObjectType=BusinessContract&ObjectNo="+ sReturnValue +"&BackPage=ContractMain&rand="+randomNumber(),"_top","");
        } 
	}
    
    //˫���鿴����
    function my_DBLClick()
    {
        my_info();
    }

</script>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>