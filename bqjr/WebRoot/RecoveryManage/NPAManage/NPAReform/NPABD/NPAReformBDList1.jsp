<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*   
		Author:   hxli 2005.8.11
		Tester:
		Content: ���鷽���б�
		Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ������е����鷽���б�			          
		Output param:
				SerialNo   : �����������к�
				
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���鷽���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���鷽���б�&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	String sUserID = CurUser.getUserID();
	String sOrgID = CurOrg.getOrgID();
	
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	
	String sTempletNo="NPAReformBDList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);//16��һ��ҳ
	
	//ɾ�����鷽��������Ϣ
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(NPAReformApply,#SerialNo,DeleteBusiness)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sOrgID);//������ʾģ�����
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord(){
		var sCompID = "NPAReformApply";
		var sCompURL = "/RecoveryManage/RMApply/NPAReformCreationInfo.jsp";			
		var sReturn = PopComp(sCompID,sCompURL,"","dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn) == "undefined" || sReturn == null || sReturn == "null" || sReturn == "" || sReturn == "_CANCEL_") return;
		var sObjectNo = sReturn;  //������
		openObject("NPAReformApply",sObjectNo,"001");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,APPLY_RELATIVE,String@ObjectType@NPAReformApply@String@ObjectNo@"+sSerialNo);
			if (typeof(sReturn) != "undefined" && sReturn.length != 0){
				alert("�����鷽���Ѿ�������ҵ�����˹�����ϵ������ɾ����");  
				return;
			}else{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit(){
		//������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		openObject("NPAReformApply",sSerialNo,"001");
		reloadSelf();
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
