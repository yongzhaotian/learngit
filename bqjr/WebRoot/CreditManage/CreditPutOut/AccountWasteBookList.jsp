<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��ˮ̨���б�";
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//AccountType 01 ���� 02 ����
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AccountType"));
	
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountType == null) sAccountType = "";
	
	String sTempletNo="";
	if(sAccountType.equals("ALL")){
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	sTempletNo = "ALL_AccountWasteBookList";//ģ�ͱ��
	}else if(sAccountType.equals("01")){
	sTempletNo = "01_AccountWasteBookList";	
	}else if(sAccountType.equals("02")){
	sTempletNo = "02_AccountWasteBookList";	
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sAccountType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","������ˮ","������ˮ","newRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴����","viewAndEdit()",sResourcesPath},
			{"false","","Button","ɾ����ˮ","ɾ����ˮ","deleteRecord()",sResourcesPath}
			};
		%>
	<%/*~END~*/%>


	<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
		<%@include file="/Resources/CodeParts/List05.jsp"%>
	<%/*~END~*/%>


	<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
		<script type="text/javascript">

		//---------------------���尴ť�¼�------------------------------------
		/*~[Describe=������ˮ��Ϣ;InputParam=��;OutPutParam=��;]~*/
		function newRecord(){
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp?AccountType=<%=sAccountType%>", "_self","");
		}
		
		/*~[Describe=ɾ����ˮ��Ϣ;InputParam=��;OutPutParam=��;]~*/
		function deleteRecord(){
			var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}
			else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
			{
				as_del('myiframe0');
				as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			}		
		}

		/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
		function viewAndEdit(){
			var sSerialNo = getItemValue(0,getRow(),"SerialNo");
			var sOccurDirection = getItemValue(0,getRow(),"OccurDirection");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}else{
				OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp?SerialNo="+sSerialNo, "_self","");
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