<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2005.01.26
		Tester:
		Content: �����ʲ����鷽�����ٲ�ѯ
		Input Param:
			   ItemID������״̬     
		Output param:				 
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ����鷽�����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql="";	

	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
					
	//����Sql���ɴ������
	String sTempletNo="RMNPAReformQueryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	
	doTemp.generateFilters(Sqlca);
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ


	//����HTMLDataWindow
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
	
		//���Ϊ�����鲻���ʲ������б���ʾ���°�ť
		
		String sButtons[][] = {
					{"true","","Button","������ԭ����","�鿴�����鲻���ʲ�","viewAndEdit()",sResourcesPath},
					{"true","","Button","���鷽������","�鿴���鷽������","viewReform()",sResourcesPath},
					{"true","","Button","������´���","�鿴���������Ϣ","ReformCredit()",sResourcesPath}
				};		
%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
		
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//������ˮ��		
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");  
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=�����鲻���ʲ������б�&ComponentType=MainWindow&SerialNo="+sSerialNo+"&ItemID=060&QueryFlag=Query","_blank",OpenStyle);

	}
	
	//���鷽��������Ϣ
	function viewReform()
	{
		//���������ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
		}
		else
		{
			sObjectType = "NPAReformApply";
			sObjectNo = sSerialNo;
			sViewID = "002";
			openObject(sObjectType,sObjectNo,sViewID);
			
		}
		
		
	}
	
	//���������Ϣ
	function ReformCredit()
	{
		//������鷽����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
			
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=�ʲ������б�?&ComponentType=MainWindow&SerialNo="+sSerialNo+"&Flag=ReformCredit&ItemID=060&QueryFlag=Query","_blank",OpenStyle);

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
