<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: ��ʾ�ͻ���صĲ��񱨱�
		Input Param:
			CustomerID�� ��ǰ�ͻ����
		Output Param:
			CustomerID�� ��ǰ�ͻ����
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	ҳ�����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ����񱨱���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sCustomerID = "";//--�ͻ�����
     String sSql = "";//--���sql���
	//���ҳ�����

	//�������������ͻ�����
	sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CustomerFSList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);

	//ɾ����ز��񱨱���Ϣ
	dwTemp.setEvent("AfterDelete","!BusinessManage.InitFinanceReport(CustomerFS,#CustomerID,#ReportDate,#ReportScope,#RecordNo,,,Delete,,)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
		{"true","All","Button","��������","�����ͻ�һ�ڲ��񱨱�","AddNewFS()",sResourcesPath},
		{"false","All","Button","����˵��","�޸Ŀͻ�һ�ڲ��񱨱������Ϣ","FSDescribe()",sResourcesPath},
		{"true","","Button","��������","�鿴���ڱ������ϸ��Ϣ","FSDetail()",sResourcesPath},
		{"true","All","Button","�޸ı�������","�޸ı�������","ModifyReportDate()",sResourcesPath},
		{"true","All","Button","ɾ������","ɾ�����ڲ��񱨱�","DeleteFS()",sResourcesPath},
		{"true","All","Button","���","���ñ���Ϊ���״̬","FinishFS()",sResourcesPath},//���ñ�־λ�����Ʊ���Ȩ�ޣ�������ɰ�ť��ʵ�ֲ��񱨱�������״̬ת��Ϊ���״̬��
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var ObjectType = "CustomerFS";
	//����һ�ڲ��񱨱�
	function AddNewFS()
	{
		var stmp = CheckRole();
		if("true" == stmp)
		{
    		//�жϸÿͻ���Ϣ�в��񱨱�������Ƿ�ѡ��
    		sModelClass = PopPageAjax("/CustomerManage/EntManage/FindFSTypeAjax.jsp?CustomerID=<%=sCustomerID%>&rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
    		if(sModelClass == "false")
    		{
    			alert(getBusinessMessage('162'));//�ͻ��ſ���Ϣ���벻��������������ͻ��ſ���Ϣ��
    		}else
    		{
    			//�� /CustomerManage/EntManage/AddFSPre.jsp ҳ�������������
    			sReturn = PopComp("CustomerFS","/CustomerManage/EntManage/AddFSPre.jsp","CustomerID=<%=sCustomerID%>&ModelClass="+sModelClass,"dialogWidth=40;dialogHeight=50;resizable:yes;scrollbars:no;");
    			if(sReturn=="ok")
    			{
    				reloadSelf();	
    			}
    		}
		}else
	    {
	        alert(getHtmlMessage('16'));//�Բ�����û����Ϣά����Ȩ�ޣ�
	        return;
	    }
	}
	
	//�޸ı��������Ϣ
	function FSDescribe()
	{
	    var stmp = CheckRole();
	    var srole = "";
		if("true" == stmp)
		    srole="has";
		else
		    srole="no";
		var sEditable="true";
		sUserID = getItemValue(0,getRow(),"UserID");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			if(FSLockStatus())
				sEditable="false";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			OpenComp("FinanceStatementInfo","/CustomerManage/EntManage/FinanceStatementInfo.jsp","Role="+srole+"&RecordNo="+sRecordNo+"&Editable="+sEditable,"_self",OpenStyle);
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
	}
	
	//������ϸ��Ϣ
	function FSDetail()
	{
	    var stmp = CheckRole();
	    var srole = "";
		if("true" == stmp)
		{
		    srole="has";
		}
		else
		{
		    srole="no";
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sUserID = getItemValue(0,getRow(),"UserID");

		if (typeof(sCustomerID) != "undefined" && sCustomerID != "" )
		{
			var sEditable="true";
			if(FSLockStatus())
				sEditable="false";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			OpenComp("FinanceReportTab","/Common/FinanceReport/FinanceReportTab.jsp","Role="+srole+"&RecordNo="+sRecordNo+"&ObjectType="+ObjectType+"&CustomerID="+sCustomerID+"&ReportDate="+sReportDate+"&ReportScope="+sReportScope+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
	}
	
	//�޸ı�������
	function ModifyReportDate()
	{
		var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//�Բ�����û����Ϣά����Ȩ�ޣ�
		    return;
		}
		if(FSLockStatus()){
			alert("���ڲ��񱨱��������������޸�!");
			return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		if(typeof(sReportDate)!="undefined"&& sReportDate != "" )
		{
			//ȡ�ö�Ӧ�ı����·�
			sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
			if(typeof(sReturnMonth) != "undefined" && sReturnMonth != "")
			{
				sToday = "<%=StringFunction.getToday()%>";//��ǰ����
				sToday = sToday.substring(0,7);//��ǰ���ڵ�����
				if(sReturnMonth >= sToday)
				{		    
					alert(getBusinessMessage('163'));//�����ֹ���ڱ������ڵ�ǰ���ڣ�
					return;		    
				}
				
				if(confirm("��ȷ��Ҫ�� "+sReportDate+"���񱨱� ����Ϊ"+sReturnMonth+"��"))
				{
					//�����Ҫ���Խ��б���ǰ��Ȩ���ж�
					sPassRight = PopPageAjax("/CustomerManage/EntManage/FinanceCanPassAjax.jsp?ReportDate="+sReturnMonth+"&ReportScope="+sReportScope,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
					if(sPassRight == "pass")
					{
						//������صĲ��񱨱�
						sReturn = RunMethod("BusinessManage","InitFinanceReport","CustomerFS,<%=sCustomerID%>,"+sReportDate+","+sReportScope+","+sRecordNo+","+""+","+sReturnMonth+",ModifyReportDate,<%=CurOrg.getOrgID()%>,<%=CurUser.getUserID()%>");
						if(sReturn == "ok")
						{
							alert("���ڲ��񱨱��Ѿ�����Ϊ"+sReturnMonth);	
							reloadSelf();	
						}
					}else
					{
						alert(sReturnMonth +" �Ĳ��񱨱��Ѵ��ڣ�");
					}
				}
			}
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
	}
	
	//ɾ��һ�ڲ��񱨱�
	function DeleteFS() 
	{
	    var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//�Բ�����û����Ϣά����Ȩ�ޣ�
		    return;
		}
		if(FSLockStatus()){
			alert("���ڲ��񱨱�������������ɾ��!");//��������״̬�ı�������ɾ����
			return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sUserID = getItemValue(0,getRow(),"UserID");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		if (typeof(sReportDate) != "undefined" && sReportDate != "" )
		{
			if(sUserID=='<%=CurUser.getUserID()%>')
			{
    			if(confirm(getHtmlMessage('2')))
    		    {			
	    			as_del('myiframe0');
	      			as_save('myiframe0');  //�������ɾ������Ҫ���ô����			
	      			reloadSelf();	  //added by yzheng 2013-06-17
    			}
			}else alert(getHtmlMessage('3'));
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}	
	}

	//���ò����Ĳ��񱨱�Ϊ���״̬
	function FinishFS()
	{
		var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//�Բ�����û����Ϣά����Ȩ�ޣ�
		    return;
		}
		if(FSLockStatus()){
			alert("���ڲ��񱨱��������������޸�!");
			return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		if (typeof(sReportDate) != "undefined" && sReportDate != "" )
		{
			sReportStatus = '02';//01��ʾ����״̬��02��ʾ���״̬��03��ʾ����״̬
			sReturn = RunMethod("CustomerManage","UpdateFSStatus","<%=sCustomerID%>,"+sReportStatus+","+sReportDate+","+sReportScope);
			if(sReturn == "SUCCESS")
			{
				alert("���񱨱�����Ϊ���״̬��");	
			}else{
				alert("����ʧ�ܣ�");	
			}
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		reloadSelf();
	}
	
	//�ж�ʱ������Ϣά��Ȩ��
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
	
	//�����񱨱��Ƿ����������õȼ�����
	/*����״̬��־λ�󣬱���������Ч��
		function CheckFSinEvaluateRecord(){
			sCustomerID = getItemValue(0,getRow(),"CustomerID");
			sReportDate = getItemValue(0,getRow(),"ReportDate");
			sReturn=RunMethod("CustomerManage","CheckFSinEvaluateRecord",sCustomerID+","+sReportDate);
			if(sReturn>0)return true;
			return false;
			
		}
	*/
	
	//�����񱨱��Ƿ�Ϊ����״̬���磺��ѯ���Ϊ03������״̬������true�����򷵻�false
	//�˷�������ȫ�������CheckFSinEvaluateRecord��������Ϊ���д���03״̬�ı������������õȼ������ˡ�
	function FSLockStatus()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sReturn=RunMethod("CustomerManage","CheckFSStatus",sCustomerID+","+sReportDate+","+sReportScope);
		return sReturn == '03';
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

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