<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: ��Ȼ�����Ϣҳ��
		Input Param:
		Output param:
		History Log: 
			zywei 2007/10/11 ���οͻ�ѡ����
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		
	//������ʾ����				
	String[][] sHeaders = {											
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"BusinessSum","��Ƚ��"},
					{"BusinessCurrency","����"},					
					{"BeginDate","��Ч��"},
					{"PutOutDate","��ʼ��"},
					{"Maturity","������"},			
					{"LimitationTerm","���ʹ���������"},				
					{"UseTerm","�������ҵ����ٵ�������"},				
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputDate","�Ǽ�����"},
					{"UpdateDate","��������"}															
				};
	String sSql = 	" select SerialNo,CustomerID,CustomerName, "+
					" BusinessSum,BusinessCurrency,BeginDate,PutOutDate,Maturity,LimitationTerm, "+
					" UseTerm,GetOrgName(InputOrgID) as InputOrgName,InputOrgID, "+
					" InputUserID,GetUserName(InputUserID) as InputUserName,InputDate,UpdateDate,OperateUserID,OperateOrgID "+
					" from BUSINESS_CONTRACT "+
					" Where SerialNo = '"+sSerialNo+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("BusinessCurrency","Currency");
	
	//���ò��ɼ�����
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,OperateUserID,OperateOrgID",false);
	//����ֻ������
	doTemp.setReadOnly("CustomerID,CustomerName,InputUserName,InputOrgName,InputDate,UpdateDate",true);
	//���ñ�����
	doTemp.setRequired("BusinessSum,BusinessCurrency,BeginDate,PutOutDate,Maturity",true);
	//���ò��ɸ�������
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//���ø�ʽ
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setCheckFormat("BeginDate,PutOutDate,Maturity,LimitationTerm,UseTerm","3");	
	doTemp.setHTMLStyle("InputUserName,InputDate,UpdateDate"," style={width:80px;} ");
	
	//���ö�Ƚ�Ԫ����Χ
	doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ƚ�Ԫ��������ڵ���0��\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
	dwTemp.setEvent("AfterUpdate","!BusinessManage.AddCLContractInfo(#SerialNo,#BusinessSum,#BusinessCurrency,#BeginDate,#PutOutDate,#Maturity,#LimitationTerm,#UseTerm,#InputUserID)");
		
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}	
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		sParaString = "CertType, ";
		setObjectValue("SelectOwner",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		//������Ч�ա���ʼ�պ͵�����֮���ҵ���߼���ϵ
		sBeginDate = getItemValue(0,getRow(),"PutOutDate");//��ʼ��			
		sEndDate = getItemValue(0,getRow(),"Maturity");//������	
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����
		if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
		{			
			if(typeof(sEndDate)!="undefined" && sEndDate.length > 0)
			{
				if(sEndDate <= sBeginDate)
				{		    
					alert(getBusinessMessage('172'));//�����ձ���������ʼ�գ�
					return false;		    
				}
				
				if (typeof(sLineEffDate)!="undefined" && sLineEffDate.length > 0)
				{
					if(sEndDate <= sLineEffDate)
					{		    
						alert(getBusinessMessage('411'));//�����ձ���������Ч�գ�
						return false;		    
					}
				}
			}	
		}
						
		return true;
	}

	/*~[Describe=�����������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function setCLType()
	{			
		setObjectValue("SelectCLType","","@CLTypeID@0@CLTypeName@1",0,0,"");		
	}
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
