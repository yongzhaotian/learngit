<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: hxli 2005-8-2
				
*	Tester:
*	Describe: �����ʲ���Ϣ�����б�;
*		  �Ӻ�ͬ��BUSINESS_CONTRACT �л�ȡ���ݣ����У���ȫ�����ˣ�CurUser and �峥����FinishDateΪ�� and ҵ��Ʒ��BusinessType Like ���Ŵ����Ʒ���е����ݡ�
*		  ҵ��Ʒ��ҵ��Ʒ��BusinessType ��80��Ϊ�����಻���ʲ�������Ϊ�Ŵ��಻���ʲ�
*	Input Param:
*		ItemMenuNo :�˵����
*		      01010��δ�峥���Ŵ��಻���ʲ�		      
*		      01030���Ѻ������Ŵ��಻���ʲ�
*		      01040�����峥���Ŵ��಻���ʲ�		    
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���Ϣ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSerialNo = "" ; //��ͬ���
	String sWhereCondition = "";
	String sUserID = CurUser.getUserID();
	String sTempletNo = "";
		
	//����������
	String sItemMenuNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo")); //CodeLibrary �ж���describe���
%>                    
<%/*~END~*/%>         

                      
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	
	if(sItemMenuNo.equals("01010")){ //δ�ս���Ŵ��಻���ʲ�
		sTempletNo = "NPAInformationList01";	
	}else if(sItemMenuNo.equals("01040")){ //���ս���Ŵ��಻���ʲ�
		sTempletNo = "NPAInformationList02";	
	}else if(sItemMenuNo.equals("01030")){ //�Ѻ������Ŵ��಻���ʲ�
		sTempletNo = "NPAInformationList03";
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
	 Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);//������ʾģ�����
	 for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
				{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
				{"true","","Button","�ճ�����","�ճ�������Ϣ","my_ManageView()",sResourcesPath},
				{"true","","Button","�ս�","��ͬ�鵵�ս����","my_FinishPigeonhole()",sResourcesPath},
				{"true","","Button","תδ�ս�","��ͬתδ�ս����","my_ExitPigeonhole()",sResourcesPath},
				{"true","","Button","���ʽ����","���ʽ����","my_ReturnWay()",sResourcesPath},
		};

	if (sItemMenuNo.equals("01010")) {
		sButtons[3][0] = "false";
	}
	if (sItemMenuNo.equals("01030")) {
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
	}
	if (sItemMenuNo.equals("01040")) {
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=��̨ͬ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_ManageView(){ 
		//��ͬ��ˮ�š���ͬ��š��ͻ�����,����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sItemMenuNo = "<%=sItemMenuNo%>";
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}else{
			sObjectType = "NPABook";
			sObjectNo = sSerialNo;
			if(sItemMenuNo == "01030" || sItemMenuNo == "01040" ) 
				sViewID = "002";
			else
				sViewID = "001";
			
			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
    /*~[Describe=�峥�鵵;InputParam=��;OutPutParam=��;]~*/
	function my_FinishPigeonhole(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			//��ȡ��ͬ������ǷϢ������ǷϢ
			var sBalance = getItemValue(0,getRow(),"Balance");
			var sInterestBalance1 = getItemValue(0,getRow(),"InterestBalance1");
			var sInterestBalance2 = getItemValue(0,getRow(),"InterestBalance2");
			if((parseFloat(sBalance)+parseFloat(sInterestBalance1)+parseFloat(sInterestBalance2)) > 0){
				alert(getBusinessMessage('649'));//�ú�ͬ��������ǷϢ������ǷϢ���>0�����ܽ����ս������
				return;
			}else{
				//�����Ի�ѡ���
				sReturn = PopPage("/RecoveryManage/NPAManage/NPADailyManage/NPAFinishedTypeDialog.jsp","","dialogWidth:22;dialogHeight:10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
				if(typeof(sReturn) != "undefined" && sReturn.length != 0){
					ss = sReturn.split('@');
					sFinishedType = ss[0];
					sFinishedDate = ss[1];
					//�ս����
					sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@"+sFinishedType+"@String@FinishDate@"+sFinishedDate+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
					if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
						alert(getHtmlMessage('62'));//�ս�ʧ�ܣ�
						return;			
					}else{
						reloadSelf();	
						alert(getHtmlMessage('43'));//�ս�ɹ���
					}
				}
			}
		}
	}
	
    /*~[Describe=ת��δ�峥;InputParam=��;OutPutParam=��;]~*/
	function my_ExitPigeonhole(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			if(confirm(getHtmlMessage('63'))){ //������뽫����Ϣ�ս�ȡ����
				//ȡ���鵵����
				sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@None@String@FinishDate@None,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
					alert(getHtmlMessage('65'));//ȡ���ս�ʧ�ܣ�
					return;
				}else{
					reloadSelf();
					alert(getHtmlMessage('64'));//ȡ���ս�ɹ���
				}				
		   	}
		}
	}
	
	/*~[Describe=�����ʲ����ʽ����;InputParam=��;OutPutParam=��;]~*/
	function my_ReturnWay(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			OpenComp("NPAReturnWayMain","/RecoveryManage/NPAManage/NPADailyManage/NPAReturnWayView.jsp","ComponentName=�����ʲ����ʽ&ComponentType=MainWindow&DefaultTVItemName=�����ǹ���&SerialNo="+sSerialNo,"_blank",OpenStyle)
		}
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@include file="/IncludeEnd.jsp"%>
