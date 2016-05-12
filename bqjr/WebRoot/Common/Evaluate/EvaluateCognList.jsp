<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ���õȼ��϶��б�;
		Input Param:
			EvaluateType��	01   ���϶�����
							02   ���϶�����
	 */
	String PG_TITLE = "���õȼ��϶��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������	
	String sSql = "";//--���sql���
	String sBtns = "";//--�����ʾ��Ϣ	
	String sOrgLevel = CurOrg.getOrgLevel();//��������0�����У�3�����У�6��֧�У�9�����㣩
	
	//��������������������
	String sEvaluateType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EvaluateType"));

	String sHeaders[][] =  {	{"CustomerName","�ͻ�����"},
							{"AccountMonth","����·�"},
							{"ModelName","����ģ��"},
							{"EvaluateScore","ϵͳ�����÷�"},
							{"EvaluateResult","ϵͳ�������"},						
							{"CognScore","�˹��϶��÷�"},
							{"CognResult","�˹��϶����"},
							{"CognResult4","֧���϶����"},
							{"CognResult2","�����϶����"},
							{"CognResult3","�����϶����"},
							{"OrgName","������λ"},
							{"UserName","�����ͻ�����"},
							{"CognOrgName","�����϶���λ"},
							{"CognUserName","�����϶���"}
						};    				   		
	
	sSql = " select R.ObjectNo as ObjectNo,R.SerialNo as SerialNo,CI.CustomerID as CustomerID,CI.CustomerName as CustomerName,"+
		   " R.AccountMonth as AccountMonth,C.ModelName as ModelName,R.EvaluateScore as EvaluateScore,"+
		   " R.EvaluateResult as EvaluateResult,R.CognDate as CognDate,R.ModelNo as ModelNo,R.FinishDate2,R.FinishDate3,"+
           " CognScore,CognResult,CognResult4,CognResult2,CognResult3,getOrgName(R.OrgID) as OrgName,R.OrgID as OrgID,getUserName(R.UserID) as UserName,R.UserID as UserID,"+
           " getOrgName(R.CognOrgID) as CognOrgName,"+
           " getUserName(R.CognUserID) as CognUserName "+
           " from EVALUATE_RECORD R,EVALUATE_CATALOG C,CUSTOMER_INFO CI" + 
           " where R.ModelNo = C.ModelNo "+
           " and R.ObjectType = 'Customer' "+
           " and R.ObjectNo = CI.Customerid"+
           " and exists (select OI.OrgId from ORG_INFO OI where OI.OrgId = R.OrgID "+
           " and OI.SortNo like '"+CurOrg.getSortNo()+"%')";

	if(sEvaluateType.equals("01")){ //���϶����õȼ�
		if(sOrgLevel.equals("0")){ //���з��շ����϶�
			sSql += " and (R.FinishDate3 = ' ' or R.FinishDate3 is null) and R.FinishDate2 <> ' ' and R.FinishDate2 is not null";
		}
		if(sOrgLevel.equals("3")){ //���з��շ����϶�
			sSql += " and (R.FinishDate2 = ' ' or R.FinishDate2 is null) and R.FinishDate4 <> ' ' and R.FinishDate4 is not null";
		}
		if(sOrgLevel.equals("6")){ //֧�з��շ����϶�
			sSql += " and (R.FinishDate4 = ' ' or R.FinishDate4 is null) ";
		}
	}else if(sEvaluateType.equals("02")){ //���϶����õȼ�
		if(sOrgLevel.equals("0")){ //���з��շ����϶�
			sSql += " and R.FinishDate3 <> ' ' and R.FinishDate3 is not null and CognUserID3='"+CurUser.getUserID()+"'";
		}
		if(sOrgLevel.equals("3")){ //���з��շ����϶�
			sSql += " and R.FinishDate2 <> ' ' and R.FinishDate2 is not null and CognUserID2='"+CurUser.getUserID()+"'";
		}
		if(sOrgLevel.equals("6")){ //֧�з��շ����϶�
			sSql += " and R.FinishDate4 <> ' ' and R.FinishDate4 is not null and CognUserID4='"+CurUser.getUserID()+"'";
		}		
	}
	
	sSql += " and (R.FinishDate <> ' ' and R.FinishDate is not null) order by CustomerName DESC";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//�費�ɼ�
	doTemp.setVisible("SerialNo,ObjectNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID,CustomerID,FinishDate2,FinishDate3",false);
	//Ϊ��ɾ��
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID",false);
	doTemp.setVisible("CognDate,CognOrgName,CognUserName",false);
	doTemp.setAlign("ModelName,EvaluateResult,CognResult,CognResult4,CognResult2,CognResult3","2");
	//���ÿ��
	doTemp.setHTMLStyle("ModelName","style={width:150px} ");
	doTemp.setHTMLStyle("AccountMonth,CognDate,EvaluateScore,EvaluateResult,UserName,CognScore,CognResult,CognResult2,CognResult3,CognResult4","  style={width:80px}  ");
	//����EvaluateScore�ļ���ʽ(1 String 2 Number 3 Date(yyyy/mm/dd) 4 DateTime(yyyy/mm/dd hh:mm:ss))
	doTemp.setCheckFormat("BusinessSum,EvaluateScore,CognScore","2");
	//����EvaluateScore���ֶ�����("String","Number")
	doTemp.setType("EvaluateScore,CognScore","Number");

	doTemp.setColumnAttribute("CustomerName,UserName,OrgName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	if(sEvaluateType.equals("01")){
		sBtns = "�ȼ��϶�,�ͻ�����,��������";
	}else if(sEvaluateType.equals("02")){
		sBtns = "�϶�����,�ͻ�����,��������";
	}

	String sButtons[][] = {
		{(sBtns.indexOf("ֱ���϶�")>=0?"true":"false"),"","Button","ֱ���϶�","ֱ���϶�","newRecord()",sResourcesPath},
		{(sBtns.indexOf("�϶�����")>=0?"true":"false"),"","Button","�϶�����","�϶�����","viewAndEdit()",sResourcesPath},
		{(sBtns.indexOf("�ȼ��϶�")>=0?"true":"false"),"","Button","�ȼ��϶�","�ȼ��϶�","viewAndEdit()",sResourcesPath},
		{(sBtns.indexOf("��������")>=0?"true":"false"),"","Button","��������","�鿴��������","my_detail()",sResourcesPath},
		{(sBtns.indexOf("�ͻ�����")>=0?"true":"false"),"","Button","�ͻ�����","�ͻ�����","CustomerviewAndEdit()",sResourcesPath},		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{  
		    if("<%=sEvaluateType%>"=="01"){
			    OpenPage("/Common/Evaluate/EvaluateCognInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo, "_self","");
		    }else{
		       OpenPage("/Common/Evaluate/EvaluateCognInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&IsReadOnly=Y", "_self",""); 
		    }        
		}
	}
   	/*~[Describe=�鿴���޸Ŀͻ�����;InputParam=��;OutPutParam=��;]~*/
	function CustomerviewAndEdit(){
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		openObject("Customer",sCustomerID,"001");
	}

    function my_detail(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			var sEditable="true";
			if(sUserID!="<%=CurUser.getUserID()%>")
				sEditable="false";
			if("<%=sEvaluateType%>"=="02")
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&ObjectType=Customer&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		}
		reloadSelf();
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%@	include file="/IncludeEnd.jsp"%>