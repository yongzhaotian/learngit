<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: yxzhang 2010/03/22
		Tester:
		Describe: ��Ϣ����ʵʱ��ѯ�б�
		Input Param:
	
		Output Param:
			
			
		HistoryLog:	sxjiang 2010/07/19  Line77  �رս����
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ϣ����ʵʱ��ѯ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
							{"ManageOrgID","��������"},
							{"ManageOrgName","��������"},
							{"Reinforce1","�貹���Ŵ�ҵ��"},
							{"Reinforce2","��������Ŵ�ҵ��"},
							{"FinishedRatio","������ɰٷֱ�"},
							{"TotalBC","����"}
						  }; 
	String sSql=" select ManageOrgID,getOrgName(BC.ManageOrgID) as ManageOrgName,"+
				" sum(case when ReinforceFlag='010' then 1 else 0 end) as Reinforce1,"+
				" sum(case when ReinforceFlag='020' then 1 else 0 end) as Reinforce2,0 as FinishedRatio,"+
				" count(ReinforceFlag) as TotalBC"+
				" from BUSINESS_CONTRACT BC"+
				" where ReinforceFlag in('010','020')"+
				" and BC.ManageOrgID like '"+CurOrg.getOrgID()+"%'"+
				" group by BC.ManageOrgID";

	//����DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    //���ø��µ����ݿ����
	doTemp.UpdateTable = "BUSINESS_CONTRACT"; 
    //���ùؼ��ֶ�	
	doTemp.setKey("ManageOrgID",true);
	doTemp.setAlign("ManageOrgID,ManageOrgName","2");
	doTemp.setAlign("Reinforce1,Reinforce2,TotalBC,FinishedRatio","3");
	//����HTML�ĸ�ʽ
	doTemp.setHTMLStyle("ManageOrgID"," style={width:200px} ");
	doTemp.setVisible("ManageOrgID",false);
	
	ASResultSet rs = null;
	double dReinForce2 =0;
	double dTotalBC = 0;
	double dFinishedRatio = 0;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		dReinForce2 = rs.getDouble("ReinForce2");
		dTotalBC = rs.getDouble("TotalBC");
	}
	rs.getStatement().close();
	dFinishedRatio = dReinForce2/dTotalBC;
	
	//���ɲ�ѯ��
	//doTemp.setColumnAttribute("ManageOrgID","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//����datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
			{"true","","Button","ҵ�񲹵��������չʾ","ҵ�񲹵��������չʾ","GraphShowCount()",sResourcesPath},	
			{"true","","Button","ҵ�񲹵ǰٷֱ�չʾ","ҵ�񲹵ǰٷֱ�չʾ","GraphShowPercent()",sResourcesPath}	
		  };
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=�Զ��庯��;]~*/%>

<script>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����ͼ��;InputParam=��;OutPutParam=��;]~*/
	function GraphShowCount()
	{  
		var dTotalBC = <%=dTotalBC%>;
		if(dTotalBC == 0){
			alert("�û���û�в���ҵ��");
			return;
		}
		OrgID = <%=CurOrg.getOrgID()%>;
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-40;
		
		sReturn=RunMethod("��Ϣ����","ReinforceStatisticNow",OrgID+",Counts");
	    sReturns = sReturn.split(",");
	    OrgNames = sReturns[0];
	    FinishCounts = sReturns[1];
	    ItemName = sReturns[2];
	    
	    PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishCounts+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}

	/*~[Describe=����ͼ��;InputParam=��;OutPutParam=��;]~*/
	function GraphShowPercent()
	{  
		var dTotalBC = <%=dTotalBC%>;
		if(dTotalBC == 0){
			alert("�û���û�в���ҵ��");
			return;
		}
		OrgID = <%=CurOrg.getOrgID()%>;
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-40;

		sReturn=RunMethod("��Ϣ����","ReinforceStatisticNow",OrgID+",Percents");
	    sReturns = sReturn.split(",");
	    OrgNames = sReturns[0];
	    FinishPercents = sReturns[1];
	    ItemName = sReturns[2];
		
		PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishPercents+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}

</script>
<%/*~END~*/%>	




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	var dFinishedRatio = <%=dFinishedRatio%>;
	dFinishedRatio = roundOff(dFinishedRatio*100,2);
	setItemValue(0,0,"FinishedRatio",dFinishedRatio);
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
