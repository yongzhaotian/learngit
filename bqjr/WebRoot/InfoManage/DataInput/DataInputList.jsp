<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bliu 2004-12-22
		Tester:
		Describe: Ͷ�ʣ���ҵծȨͶ��;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			
		HistoryLog:slliua 2005-01-15
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ҵ�񲹵��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sClauseWhere="";
	 String sSql="";
	
	//���ҳ�����
	
	//����������
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sFlag==null) sFlag="";
	
	//����������(8010��ҵͶ�ʡ�8020��ȨͶ�ʡ�8030���)
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	if(sBusinessType==null) sBusinessType="";
	
	//����������(010������ҵ��020�������ҵ��)
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";
	
	
	//�����ͷ
	//��ҵծȨͶ��
	String sHeaders1[][] = {	
				{"OldlcNo","Ͷ�ʶ�����"},
				{"CustomerName","Ͷ�ʶ�������"},
				{"BusinessSubTypeName","Ͷ�ʶ������õȼ�"},
				{"CargoInfo","ծȯ����"},
				{"UserName","�Ǽ���"},
				{"OrgName","�Ǽǻ���"},
				{"InputDate","�Ǽ�����"} 
			 };
	
	//��ȨͶ��
	String sHeaders2[][] = {	
					{"OldlcNo","Ͷ�ʶ�����"},
					{"CustomerName","Ͷ�ʶ�������"},
					{"BusinessSubTypeName","Ͷ�ʶ������õȼ�"},
					{"ArtificialNo","��ͬ���"},
					{"UserName","�Ǽ���"},
					{"OrgName","�Ǽǻ���"},
					{"InputDate","�Ǽ�����"}                                                                                                                                       			
				  };
	
	//���
	String sHeaders3[][] = {	
					{"SerialNo","��ˮ��"},
					{"OldlcNo","�����ֱ��"},
					{"CustomerName","����������"},
					{"ArtificialNo","����ͬ��"},
					{"BusinessSum","����ͬ���(Ԫ)"},
					{"BeginDate","�����Ϣ��"},
					{"EndDate","��赽����"},					
					{"UserName","�Ǽ���"},
					{"OrgName","�Ǽǻ���"},
					{"InputDate","�Ǽ�����"} 
			  };
	
	
	if(sReinforceFlag.equals("110"))  //�����ǵ�ҵ��
	{
		sClauseWhere = " and ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')"; //������Ͻ�� Modi by wuxiong 20050709 
	}
	if(sReinforceFlag.equals("120"))  //������ɵ�ҵ��
	{
		sClauseWhere = " and ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')"; //������Ͻ�� Modi by wuxiong 20050709 
	}
	
	//��ҵծȨͶ��
	if(sBusinessType.equals("8010"))
	{
		
          	sSql = " select SerialNo,CustomerID,OldlcNo,CustomerName,getItemName('CreditGrade',BusinessSubType) as BusinessSubTypeName,CargoInfo," +
				   " InputOrgID,InputUserID,getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName ,InputDate"+
				   " from BUSINESS_CONTRACT " +
				   " where BusinessType='8010' "+
				   " and ReinforceFlag = '"+sReinforceFlag+"' "
				   +sClauseWhere;
	}
	
	//��ȨͶ��
	if(sBusinessType.equals("8020"))
	{
		
          	sSql = " select SerialNo,CustomerID,CustomerName,getItemName('CreditGrade',BusinessSubType) as BusinessSubTypeName,CargoInfo," +
				   " InputOrgID,InputUserID,getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName ,InputDate"+
				   " from BUSINESS_CONTRACT " +
				   " where BusinessType='8020' "+
				   " and ReinforceFlag = '"+sReinforceFlag+"' "
				   +sClauseWhere;
	}
	//���
	if(sBusinessType.equals("8030"))
	{
		
        	sSql = " select SerialNo,CustomerID,CustomerName,ArtificialNo,BusinessSum,BeginDate,EndDate," +
				   " InputOrgID,InputUserID,getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName,InputDate "+
				   " from BUSINESS_CONTRACT " +
				   " where BusinessType='8030' "+
				   " and ReinforceFlag = '"+sReinforceFlag+"' "
				   +sClauseWhere;
				 
	}

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//��ҵծȨͶ��
	if(sBusinessType.equals("8010"))
	{
		doTemp.setHeader(sHeaders1);
	}
	
	//��ȨͶ��
	if(sBusinessType.equals("8020"))
	{
		doTemp.setHeader(sHeaders2);
	}
	
	//���
	if(sBusinessType.equals("8030"))
	{
		doTemp.setHeader(sHeaders3);
	}
	
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
   	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CustomerID,CargoInfo,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	//����ѡ��˫�����п�
	doTemp.setHTMLStyle("CustomerID,ArtificialNo,BusinessSubTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("CargoInfo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("UserName,BeginDate,EndDate,InputDate"," style={width:80px} ");
	
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","����","����","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			{"true","","Button","�������","�������","Finished()",sResourcesPath},
			{"true","","Button","�ٴβ���","�ٴβ���","secondFinished()",sResourcesPath}

		};
	
	
	if(sReinforceFlag.equals("120"))  //������ɵ�ҵ��
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
	
	if(sReinforceFlag.equals("110"))  //������ҵ��
	{
		sButtons[4][0] = "false";
	}
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		var sCurItemDescribe3 = "<%=sBusinessType%>";
		OpenPage("/InfoManage/DataInput/DataInputInfo.jsp?Flag=<%=sFlag%>&CurItemDescribe3="+sCurItemDescribe3,"_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sReinforceFlag = "<%=sReinforceFlag%>";
		var sCurItemDescribe3 = "<%=sBusinessType%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(sReinforceFlag=="110") //�����ǵĿ����޸�
			{
				OpenPage("/InfoManage/DataInput/DataInputInfo.jsp?SerialNo="+sSerialNo+"&Flag=<%=sFlag%>&CurItemDescribe3=<%=sBusinessType%>", "_self","");

			}else
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=�б�&ComponentType=MainWindow&SerialNo="+sSerialNo+"&Flag=Y&CurItemDescribe3="+sCurItemDescribe3+"","_blank",OpenStyle);
			}
		}
	}
	
	/*~[Describe=����ɲ��Ǳ�־;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("���Ҫ���������")) 
		{
			
			var sFlag="<%=sFlag%>";
			
			if(sFlag=="Y")   //�����ʲ��������
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag,"","");
			}else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo,"","");
			}
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=�ٴβ���;InputParam=��;OutPutParam=��;]~*/
	function secondFinished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("���Ҫ�ٴβ�����")) 
		{
			
			var sFlag="<%=sFlag%>";
			
			var sFlag1 = "SecondFlag";
			
			if(sFlag=="Y")   //�����ʲ��������
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&Flag1="+sFlag1,"","");
			}
			else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&Flag1=SecondFlag","","");
			}
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				alert("�ٴβ��ǣ���ѡ���ݽ��ص��貹��ҵ���б�!");
			}
			
			if(sReturn == "false")
			{
				alert("��ѡ�ʲ��Ѿ��ַ�,�����ٴβ���!");
			}
			reloadSelf();
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�ƽ���ȫ����;InputParam=��;OutPutParam=��;]~*/
	function ShiftRMDepart()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
		
			var sTrace= PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sTrace)!="undefined" && sTrace.length!=0)
			{
				
				var sTrace=sTrace.split("@");
				
				//����ƽ����͡���ȫ����
				var sShiftType = sTrace[0];
				var sTraceOrgID = sTrace[1];
				var sTraceOrgName = sTrace[2];
				
				if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
				{
					var sReturn = PopPageAjax("/RecoveryManage/Public/NPAShiftActionAjax.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"","","");
					if(sReturn == "true") //ˢ��ҳ��
					{
						alert("�ò����ʲ��ɹ��ƽ�����"+sTraceOrgName+"��"); 
						self.location.reload();
					}else
					{
						alert("�ò����ʲ��Ѿ��ƽ��������ٴ��ƽ���"); 
						self.location.reload();
					}
				}
			}
	
		}
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
