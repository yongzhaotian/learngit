<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    
		Tester:	
		Content: �ͻ��б�
		Input Param:
              ObjectType:  ��������
              ObjectNo  :  ������
              ModelType :  ����ģ������ 010--���õȼ�����   030--���ն�����  080--�����޶� 018--���ô�������  ������'EvaluateModelType'����˵��
              CustomerID��  �ͻ�����        ��        
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005.7.22 fbkang    ҳ������
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sContext = "";//���ݲ���
	String sSql = "";//--���sql���
	String sObjectType = "";//--��������
	String sObjectNo = "";//--������
	String sModelType = "";//--ģ������
	String sFag = "";//--��־
	String sCustomerType = "";//--�ͻ�����
	String sModelTypeAttributes="";//--ģ����������
	String sCustomerID = "";//--�ͻ�����
    String sDisplayFinalResult="";//--��ʾ���
    String sSMEStatus="";
    //�������������������͡������š�ģ�����͡��ͻ�����
	sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sModelType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if (sModelType==null) 
		sModelType = "010"; //ȱʡģ������Ϊ"���õȼ�����"
	ASResultSet rs = null;
%>	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	sSql = "select * from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:sModelType ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sModelType",sModelType));
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}else{
		throw new Exception("ģ������ ["+sModelType+"] û�ж��塣��鿴CODE_LIBRARY:EvaluateModelType");
	}
	rs.getStatement().close();
	
	sDisplayFinalResult = StringFunction.getProfileString(sModelTypeAttributes,"DisplayFinalResult");
	
	//��ȡ��С��ҵ�ͻ��϶����
	sSql = "select * from CUSTOMER_INFO where CustomerID=:sCustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID",sCustomerID));
	if(rs.next()){
		sSMEStatus = rs.getString("Status");
		sCustomerType=rs.getString("CustomerType");
	}
	rs.getStatement().close();
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "EvaluateList";//ģ�ͱ��
	       
	if (sModelType.equals("030"))//  �����ҵ����������������б����
	{		
		String sModelTypeName="���ն�������";
		//���ն�����ֻ���������������ǰ����Ϊ��ͬ��֪ͨ�飬��ʾ����������ķ��ն�����
		if(sObjectType.equals("CreditApply"))
		{	
			sTempletNo = "CreditApplyEvaluateList";
			sContext += sObjectType +","+sObjectNo;
		 }
	}else//�����׶ε�����
	{
		sContext += sObjectType +","+sObjectNo+","+sModelType;
	}

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if (sModelType.equals("080"))
	{
		//���ò��ɼ���
		doTemp.setVisible("EvaluateResult,CognScore,CognResult,CognOrgName,CognUserName,CognDate",false);
		doTemp.setHTMLStyle("EvaluateScore,CognScore","style={width:160px} ");	
	}else if(sModelType.equals("070")){//���������ʽ�������ģ�Ͳ���ModelType='070';
		//���ò��ɼ���
		doTemp.setVisible("EvaluateResult,CognScore,CognResult,CognOrgName,CognUserName,CognDate",false);
		doTemp.setHTMLStyle("EvaluateScore,CognScore","style={width:160px} ");	
	}
	
	//���Ϊ���˿ͻ������ر���ھ��ֶε���ʾ
	if (sModelType.equals("015") || sModelType.equals("017")) //modify by cbsu 2009-10-20 sModelType=17��ʾ���徭Ӫ��
	{
		doTemp.setVisible("ReportScope,ReportScopeName",false);			  
	}
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID,FinishDate",false);
	if(sDisplayFinalResult==null || !sDisplayFinalResult.equalsIgnoreCase("Y"))
	{
		doTemp.setVisible("EvaluateScore,EvaluateResult,CognScore,CognResult",false);
	}

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow(sContext);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));		
	
%> 

<%/*END*/%>


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
			  {"true","All","Button","����","����������Ϣ","my_add()",sResourcesPath},
			  {"true","","Button","����","�鿴��������","my_detail()",sResourcesPath},
			  {"true","All","Button","ɾ��","ɾ����ѡ�е���Ϣ","my_del()",sResourcesPath},
			  {"false","","Button","��ӡ","��ӡ��������","my_print()",sResourcesPath},
			  {"false","","Button","�˹��϶�","�����϶�ԭ��˵��","Reason()",sResourcesPath}
		     };
	if (sModelType.equals("030") || sModelType.equals("018") || sModelType.equals("080"))
	{
	    sButtons[3][0] = "false";
	}
	//sModelTypeΪ012ʱΪ��С��ҵ���õȼ����� add by cbsu 2009-11-03
	if (sModelType.equals("010") ||sModelType.equals("018") || sModelType.equals("012")) {
		sButtons[4][0] = "false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
	//---------------------���尴ť�¼�---------------------//
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function my_add()
	{
		var CustomerType="<%=sCustomerType%>";
		var SMEStatus="<%=sSMEStatus%>";
		var stmp = CheckRole();
		if("true"==stmp)
		{    	
			if(CustomerType=="0120" && SMEStatus!="1"){
				alert(getBusinessMessage('960'))
			}
			else{
				sReturn = PopPage("/Common/Evaluate/AddEvaluateMessage.jsp?Action=display&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ModelType=<%=sModelType%>&EditRight=100","","dialogWidth:350px;dialogHeight:350px;resizable:yes;scrollbars:no");
	    		if(sReturn==null || sReturn=="" || sReturn=="undefined") return;
	    		sReturns = sReturn.split("@");
	    		sObjectType = sReturns[0];
	    		sObjectNo = sReturns[1];
	    		sModelType = sReturns[2];
	    		sModelNo = sReturns[3];
	    		sAccountMonth = sReturns[4];
	    		sReportScope = sReturns[5]; 
	    		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=add&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelType="+sModelType+"&ModelNo="+sModelNo+"&AccountMonth="+sAccountMonth+"&ReportScope="+sReportScope,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
	    		if (typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn == "EXIST")
	    		{
	    			alert(getBusinessMessage('189'));//�������õȼ�������¼�Ѵ��ڣ���ѡ�������·ݣ�
	    			return;
	    		}
	    		
	    		if(typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn != "failed")
	    		{
	    			var sEditable="true";
					OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sReturn+"&Editable="+sEditable,"_blank",OpenStyle);
	    		}
	    	    reloadSelf();
			}    		
	    }else
	    {
	        alert(getBusinessMessage('190'));//�Բ�����û�����õȼ�������Ȩ�ޣ�
	    }
	}
	
	/*~[Describe=�鿴��ϸ;InputParam=��;OutPutParam=��;]~*/
	function my_detail()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		var sOrgID        = getItemValue(0,getRow(),"OrgID");
		var sModelType = "<%=sModelType%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sEditable="true";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			//���Ϊ�������õȼ�������򿪲���ģ�͵ı༭Ȩ�ޣ���������ֻ�ܲ鿴�����ܲ��㡣
			//sModelType=015��ʾ�������õȼ�������sModelType=017��ʾ���徭Ӫ�����õȼ�������sModelType=030��ʾ���ն����� 
			//sModelType=019��ʾũ�����õȼ�������sModelType=070��ʾ�����ʽ�����������
			//��������������EvaluateModelType�����á�modify by cbsu 2009-11-19
			if(sModelType == "015" || sModelType == "017" || sModelType == "019" || sModelType == "030" || sModelType == "070")
				sEditable="true";
			else
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}		
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function my_del()
	{
		var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID       = getItemValue(0,getRow(),"UserID");
    		var sOrgID        = getItemValue(0,getRow(),"OrgID");
    		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    		var sObjectType = getItemValue(0,getRow(),"ObjectType");
    		var sAccountMonth        = getItemValue(0,getRow(),"AccountMonth");
    		var sReportScope        = getItemValue(0,getRow(),"ReportScope");
    		//sModelTypeΪϵͳ����ģ�͵�ItemNoֵ����������������EvaluateModelType�����á�
    		var sModelType = "<%=sModelType%>";
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{
    			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		}else if(sUserID=='<%=CurUser.getUserID()%>')
    		{
	          	if(confirm(getHtmlMessage('2')))
	          	{
		          	if(sModelType == "030" || sModelType == "070")
		          		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=delete&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
			        else
		    			sReturn = RunMethod("WorkFlowEngine","DeleteCreditCognTask",sObjectType+","+sSerialNo+",DeleteTask");
		        	//���ɾ���ͻ����õȼ����������¼,Ҫ������״̬��Ϊ��ɡ�
		        	//sModelType��ֵ 010:��ҵ���õȼ�����  012:��С��ҵ���õȼ����� 017:���徭Ӫ�����õȼ�����
		          	if(sModelType == "010" || sModelType == "012" ||  sModelType == "017")
	          			RunMethod("CustomerManage","UpdateFSStatus",sObjectNo+","+'02'+","+sAccountMonth+","+sReportScope);
		    		if(typeof(sReturn) != "undefined" && sReturn.length>=0)
		    		{
		    			alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
		    			reloadSelf();
		    		}else
		    		{
		    			alert(getHtmlMessage('8'));//�Բ���ɾ����Ϣʧ�ܣ�
		    		}		    	           
    		    } 
    		}else alert(getHtmlMessage('3'));
		}else
	    {
	       alert(getBusinessMessage('190'));//�Բ�����û�����õȼ�������Ȩ�ޣ�
	    }
	}
	
	/*~[Describe=�˹��϶�;InputParam=��;OutPutParam=��;]~*/
	function Reason()
	{
	    var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID = getItemValue(0,getRow(),"UserID");
    		var sOrgID = getItemValue(0,getRow(),"OrgID");
    		var sModelNo = getItemValue(0,getRow(),"ModelNo");
    		var sFinishDate	= getItemValue(0,getRow(),"FinishDate");
    		
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{    		
    			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��  			
    		}else
    		{
    			OpenComp("EvaluateReason","/Common/Evaluate/Reason.jsp","FinishDate="+sFinishDate+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&ModelNo="+sModelNo,"_blank","height=600, width=800, left=0,top=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
    		    reloadSelf();
    		}
    	}
	    else
	    {
	        alert(getBusinessMessage('190'));//�Բ�����û�����õȼ�������Ȩ�ޣ�
	    }
	}
	/*~[Describe=��ӡ;InputParam=��;OutPutParam=��;]~*/
	function my_print()
	{

		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sModelNo      = getItemValue(0,getRow(),"ModelNo");
		sSerialNo     = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��  	
		}else
		{
			PopPage("/Common/Evaluate/EvaluatePrint.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&rand="+randomNumber(),"_blank","");
 		}
	}
	/*~[Describe=����У��;InputParam=��;OutPutParam=��;]~*/
	function CheckRole()
	{
	    var sCustomerID="<%=sCustomerID%>";
		var sReturn = RunMethod("CustomerManage","CheckRolesAction",sCustomerID+",<%=CurUser.getUserID()%>");
  
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //�ͻ�����Ȩ
        sReturnValue2 = sReturnValue[1];        //��Ϣ�鿴Ȩ
        sReturnValue3 = sReturnValue[2];        //��Ϣά��Ȩ
        sReturnValue4 = sReturnValue[3];        //ҵ�����Ȩ

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
