<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-2
		Tester:   
		Content: �����ʲ����ʽ�����б�
		Input Param:
			 ItemMenuNo���˵���ţ�00510�����ǡ�00520�������	�� 
			 SerialNo����ͬ��ˮ��     
		Output param:
				 
		History Log: zywei 2005/09/03 �ؼ����
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ����ʽ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sWhereClause = ""; //Where����
	
	//���ҳ�����

	//����������
	String sItemMenuNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")); 
	if(sItemMenuNo == null) sItemMenuNo = "";
	if(sSerialNo == null) sSerialNo = "";
	String sTempletNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	
	if(sItemMenuNo.equals("00510")){
		sTempletNo = "NPAReturnWayList01";
	}else if(sItemMenuNo.equals("00520")){
		sTempletNo = "NPAReturnWayList02";
	}

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
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//������ʾģ�����
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
		{"true","","Button","��ͬ����","�鿴�����ʲ�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�鿴����","�鿴������ˮ����","my_Detail()",sResourcesPath},
		{"true","","Button","���ǻ��ʽ","���ǻ��ʽ","my_register()",sResourcesPath},
		{"true","","Button","�޸Ļ��ʽ","�޸Ļ��ʽ","my_register()",sResourcesPath}
		
		};
	if(sItemMenuNo.equals("00510")){
		sButtons[3][0] = "false";
	}	
	if(sItemMenuNo.equals("00520")){
		sButtons[2][0] = "false";
	}

%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ContractInfo;Describe=�鿴��ͬ����;]~*/%>
	<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
		
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴������ˮ����;InputParam=��;OutPutParam=��;]~*/
	function my_Detail(){ 
		//������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"BWSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPABadDebtWasteBookInfo.jsp?SerialNo="+sSerialNo+"&Flag=Y", "_self","");
		}
	}

	/*~[Describe=���ǻ��ʽ;InputParam=��;OutPutParam=��;]~*/
	function my_register(){
		//��¼��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"BWSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			sParaString = "CodeNo"+",ReclaimType";
			sReturn = selectObjectValue("SelectCode",sParaString,"@BackType@0",0,0,"");
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_NONE_" && sReturn != "_CLEAR_" && sReturn != "_CANCEL_"){
				sReturn = sReturn.split('@');
				sBackType = sReturn[0];
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@BackType@"+sBackType+",BUSINESS_WASTEBOOK,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE"){
					alert(getBusinessMessage('676')); //���ʽ���ǳɹ���
					reloadSelf();
				}else{
					alert(getBusinessMessage('677')); //���ʽ����ʧ�ܣ�
					return;
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

<%@include file="/IncludeEnd.jsp"%>
