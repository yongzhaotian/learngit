<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ���������б�
		Input Param:
			   ItemID������״̬     
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql="";
	String sSortNo; //������
	String sItemID; //����״̬
	String sWhereClause=""; //Where����
	String sViewID=null; //�鿴��ʽ
	
	//����������	
	sSortNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SortNo"));
	if(sSortNo==null) sSortNo="";
	
	sItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sItemID==null) sItemID="";
	
	//�����ͷ�ļ�
	String sHeaders[][] = {
				{"SerialNo","���鷽�����"},
				{"ApplyTypeName","��������"},
				{"OperateTypeName","������ʽ"},
				{"Flag1","�Ƿ��״�����"},
				{"OccurDate","�״�����ʱ��"},
				{"OperateUserName","������"},
				{"OperateOrgName","�������"}				
				}; 

 	if(sItemID.equals("010")){	//δ��׼���鷽��:�����Σ���Ȼ���κ�ʱ�򶼿��Էſ�������ô��
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and (FO.PhaseNo <> '1000' and FO.PhaseNo <> '8000')"+
				" and BA.PigeonholeDate is null "+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;
	}
 	
	if(sItemID.equals("020")){	//����׼δִ�е����鷽��
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and FO.PhaseNo = '1000' "+
				" and BA.PigeonholeDate is null "+
				" and BA.SerialNo not in (select ObjectNo from CONTRACT_RELATIVE where ObjectType='NPAReformApply') "+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;	
	}
	if(sItemID.equals("030")){	//�ѷ�������鷽��
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and FO.PhaseNo = '8000' "+
				" and BA.PigeonholeDate is null "+
				" and BA.BusinessType = '6010' "+
				" order by SerialNo desc " ;
	}
	
	if(sItemID.equals("060")){	//��ִ�е����鷽��
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" and FO.PhaseNo = '1000' "+
				" and BA.PigeonholeDate is null "+
				" and BA.SerialNo in (select ObjectNo from CONTRACT_RELATIVE "+
				" where ObjectType='NPAReformApply') "+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;
	}
	
	if(sItemID.equals("080")){	//�ѹ鵵�����鷽��
		sSql = 	" select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType,getItemName('ReformType',BA.ApplyType) as ApplyTypeName," + 	
				" getItemName('YesOrNo',BA.Flag1) as Flag1," + 
				" getItemName('ReformShape',BA.OperateType) as OperateTypeName," + 
				" BA.OccurDate as OccurDate," + 
				" getUserName(BA.OperateUserID) as OperateUserName, " + 
				" getOrgName(BA.OperateOrgID) as OperateOrgName " + 			 
				" from BUSINESS_APPLY BA,Flow_Object FO " +		
				" where  BA.OperateUserID = '"+CurUser.getUserID()+"' " +
				" and  BA.OperateOrgID = '"+CurOrg.getOrgID()+"' " +
				" and BA.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType = 'NPAReformApply' "+
				" And (BA.Pigeonholedate is not null and BA.Pigeonholedate<>' ')"+
				" and BA.BusinessType = '6010' order by SerialNo desc " ;
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//����Sql���ɴ������
	//out.println(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("ApplyType,SerialNo",false);	
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setCheckFormat("Balance","2");
	
	//���ö��뷽ʽ	
	doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("Balance","3");	
	
	//����ѡ��˫�����п�
	doTemp.setHTMLStyle("ArtificialNo"," style={width:100px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResult"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("ArtificialNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ


	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
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
	
		//���Ϊ�����鲻���ʲ������б���ʾ���°�ť
		
		String sButtons[][] = {
					{"false","","Button","�������鷽��","�������鷽��","NewRecord()",sResourcesPath},
					{"false","","Button","ɾ�����鷽��","ɾ������׼δִ�е����鷽��","DeleteRecord()",sResourcesPath},
					{"false","","Button","������ԭ����","�鿴������ԭ����","viewAndEdit()",sResourcesPath},
					{"false","","Button","����ǰԭ����","�鿴������ԭ����","viewAndEdit()",sResourcesPath},
					{"false","","Button","���鷽������","�鿴���鷽������","viewReform()",sResourcesPath},
					{"false","","Button","������´���","�鿴���������Ϣ","ReformCredit()",sResourcesPath},
					{"false","","Button","���鷽��ִ��̨��","���鷽��ִ��̨��","ReformBook()",sResourcesPath},
					{"false","","Button","�鵵","�鵵","archive()",sResourcesPath},
					{"false","","Button","ȡ���鵵","ȡ���鵵","cancelarch()",sResourcesPath}
				};
				
		if(sItemID.equals("010")){
			sButtons[4][0]="true";
			sButtons[6][0]="true";
			sButtons[7][0]="true";
		}
		
		if(sItemID.equals("020")){
			sButtons[0][0]="true";
			sButtons[1][0]="true";
			sButtons[2][0]="true";
			sButtons[4][0]="true";
			sButtons[7][0]="true";
		}

		if(sItemID.equals("030")){
			sButtons[0][0]="true";
			sButtons[2][0]="true";
			sButtons[4][0]="true";
			sButtons[7][0]="true";
		}

		if(sItemID.equals("060")){
			sButtons[3][0]="true";
			sButtons[4][0]="true";
			sButtons[5][0]="true";
			sButtons[6][0]="true";
			sButtons[7][0]="true";
		}

		if(sItemID.equals("080")){
			sButtons[3][0]="true";
			sButtons[4][0]="true";
			sButtons[5][0]="true";
			sButtons[8][0]="true";
		}
%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	function NewRecord(){
		var sItemID="<%=sItemID%>";
		if (sItemID=="020"){
			sReturn = createObject("NPAReformApply","ApplyType=NPAReformApply~FlowNo=NPAReformFlow~PhaseNo=1000");//�Ѿ���׼δִ�С�
		}

		if (sItemID=="030"){
			sReturn = createObject("NPAReformApply","ApplyType=NPAReformApply~FlowNo=NPAReformFlow~PhaseNo=8000");//����ķ�����
		}
		
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		var sObjectNo = sReturn;  //������
		openObject("NPAReformApply",sObjectNo,"001");
		reloadSelf();
	}

	function DeleteRecord(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		}else if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
			sSerialNo=getItemValue(0,getRow(),"SerialNo");
			//ɾ��business_apply֮�󣬱�����������ı���ɾ��������¼(Υ��������Լ���������޷�ɾ����)			
			var sReturn=PopPageAjax("/RecoveryManage/NPAManage/NPAReform/NPAReformDeleteAjax.jsp?SerialNo="+sSerialNo+	"&ObjectType=NPAReformApply&FlowNo=NPAReformFlow","","resizable=yes;dialogWidth=16;dialogHeight=10;center:yes;status:no;statusbar:no");
			if(typeof(sReturn) != "undefined" && sReturn == "true"){
				alert("ɾ�����ݳɹ�!");
				self.close();
			}else{
				alert("ɾ������ʧ��!");
			}
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
		
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit(){
		//������ˮ��		
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");  
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=�����鲻���ʲ������б�?&ComponentType=MainWindow&SerialNo="+sSerialNo+"&ItemID=<%=sItemID%>","right",OpenStyle);
	}
	
	/*~[Describe=�鵵;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		var sObjectType ="NPAReformApply";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			if(confirm("���Ҫ�鵵��")){
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
				if(typeof(sReturn)!="undefined" && sReturn!="failed") 
				alert("�鵵�ɹ���");
				self.location.reload();
			}
		}
	}
	
	/*~[Describe=ȡ���鵵;InputParam=��;OutPutParam=��;]~*/
	function cancelarch(){
		var sObjectType ="NPAReformApply";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			if(confirm("���Ҫȡ���鵵��")){
				sReturn = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&Pigeonholed=Y","","");
				if(typeof(sReturn)!="undefined" && sReturn!="failed") 
				alert("ȡ���鵵�ɹ���");
				self.location.reload();
			}
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//���鷽��������Ϣ
	function viewReform(){
		//���������ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sItemID = "<%=sItemID%>"; 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
		}else{
			sObjectType = "NPAReformApply";
			sObjectNo = sSerialNo;
			
			if(sItemID=="060" || sItemID=="080"){
				sViewID = "002";
			}else
				if (sItemID=="020"){
					sViewID="001";
				}else{	//����ı�־λ�����������Ƿ���ʾ����̨�ʣ�����060��080֮�⣬������ʾ����̨�ʡ�
					sViewID = "003";  
				}

			if ((sItemID=="020")||(sItemID=="030") ){  //�����ѷ���ķ����޸ģ�Ȩ��֮�ƣ��պ����֮��
				//����openObject������ΪȨ���޷����ơ�
				//������ViewIDʧȥ���ã������ڶ��������а�rightofapply��Ϊrightofviewid.
				//���������޸ľͻ�Ӱ�쵽���벿�ֵ�����ҳ���Ȩ�ޡ�
				//��ҳ���ԭ���߾�Ȼ��ϵͳԤ����Ȩ�ޱ�־��Ϊ˽�б���֮�ã���ά�������˼�����Ѷȡ���Ҫ���Ӵ��������
					OpenComp("NPAReformApplyView","/RecoveryManage/RMApply/NPAReformApplyView.jsp",
						"ObjectNo="+sObjectNo+"&ViewID="+sViewID,"_blank",OpenStyle);
					self.location.reload();
			}else
				openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
	//���������Ϣ
	function ReformCredit(){
		//������鷽����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=�ʲ������б�?&ComponentType=MainWindow&SerialNo="+sSerialNo+"&Flag=ReformCredit&ItemID=<%=sItemID%>","right",OpenStyle);
	}
	
	//���鷽��ִ��̨��
	function ReformBook(){
		//������鷽����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		OpenComp("NPAReformInfo","/RecoveryManage/NPAManage/NPAReform/NPAReformInfo.jsp","ComponentName=���鷽��ִ��̨��&ComponentType=MainWindow&ObjectNo="+sSerialNo,"_blank",OpenStyle);
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