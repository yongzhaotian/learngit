<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   	��ҵ� 2005-08-18
		Tester:
		Content:  	���պ��б�
		Input Param:												
				ObjectType	��������
				ObjectNo	������        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���պ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%		
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));	
	String sDunCurrency    =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Currency"));
	String flag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));

	//sxjiang 2010/08/05 �˴���ȡ���������Comp��Page
	if(flag == null) flag = "";
	if(sObjectType==null) {
		sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
		if(sObjectType == null) sObjectType = "";
	}
	if(sObjectNo==null) {
		sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
		if(sObjectNo == null) sObjectNo = "";
	}
	if(sDunCurrency==null) {
		sDunCurrency = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Currency"));
		if(sDunCurrency == null) sDunCurrency = "";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	String sTempletNo="DunList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);//20��һ��ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);//������ʾģ�����
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
			{"true","","Button","����","�������պ�","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ǰ���պ�","deleteRecord()",sResourcesPath},
			{"true","","Button","��ӡ���պ�","��ӡ���պ�","PrintDunLetter()",sResourcesPath},
			{(flag.equals("page")?"true":"false"),"","Button","����","���ص�����̨��","goBack()",sResourcesPath}
	};	
	%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			//url = "/RecoveryManage/DunManage/DunInfo.jsp?ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&SerialNo="+sSerialNo+"&Currency="+"<%=sDunCurrency%>";
			//OpenPage(url,"_self","");
			popComp("DunInfo","/RecoveryManage/DunManage/DunInfo.jsp","ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&SerialNo="+sSerialNo+"&Currency="+"<%=sDunCurrency%>"+"&flag=comp","dialogwidth:640px;dialogheight:480;");
			reloadSelf();
		}
	}


	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/	
	function newRecord()
	{
		popComp("DunInfo","/RecoveryManage/DunManage/DunInfo.jsp","ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&Currency="+"<%=sDunCurrency%>"+"&flag=comp","dialogwidth:640px;dialogheight:480;");
		reloadSelf();
	}

	/*~[Describe=��ӡ���պ�;InputParam=��;OutPutParam=��;]~*/
	function PrintDunLetter()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sDunObjectType = getItemValue(0,getRow(),"DunObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(sDunObjectType == "01")//���ն���Ϊ�����
			{
                //modified by djia 2010/08/03
				//������ô�ҳ����ϲ㴰����һ��ģ̬���ڣ���ҳ�治����OpenPage����ʽ�򿪣�ֻ����PopPage����ʽ�򿪣���������session��ʧ����
				OpenPage("/RecoveryManage/DunManage/Println1.jsp?SerialNo="+sSerialNo,"",OpenStyle);
				//popComp("Println1","/RecoveryManage/DunManage/Println1.jsp","SerialNo="+sSerialNo,OpenStyle);
			}
			else if(sDunObjectType == "02")//���ն���Ϊ��֤��
			{
				OpenPage("/RecoveryManage/DunManage/Println2.jsp?SerialNo="+sSerialNo,"",OpenStyle);
				//popComp("Println2","/RecoveryManage/DunManage/Println2.jsp","SerialNo="+sSerialNo,OpenStyle);
			}
			else{
				alert("ϵͳ�в�֧�ִ��ն���Ϊ���������͡��Ĵ��պ���ӡ��");
				return;
			}	
		}
	}	

	/*~[Describe=ҳ�淵��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditPutOut/ContractList.jsp","_self");
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

<%@ include file="/IncludeEnd.jsp"%>