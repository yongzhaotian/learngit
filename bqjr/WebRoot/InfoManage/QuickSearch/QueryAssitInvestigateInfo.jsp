<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = " Э����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
     //�������
      String sSql = "";//--���sql���
      String sTempSaveFlag="";//�ݴ��־
      ASResultSet rs = null;//-- ��Ž����
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sRightType==null) sRightType="";
	
	//ȡ���ݴ��־
		sSql = "select TempSaveFlag from AssistInvestigate where ObjectNo=:ObjectNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
		if(rs.next()){
			sTempSaveFlag = rs.getString("TempSaveFlag");
		}
//		rs.getStatement().close();
		if(sTempSaveFlag == null) sTempSaveFlag = ""; 
		
		
		rs.getStatement().close(); 
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		 				
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AssistInvestigateInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	
	//���õ���ͬ��Ϊ0�ǷǱ�����
	String sCompanyWith="";
	String sCheckPartner="";
	sSql = "select companyWith,checkPartner from AssistInvestigate where ObjectNo=:ObjectNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
	if(rs.next()){
		sCompanyWith = rs.getString("companyWith");
		sCheckPartner = rs.getString("checkPartner");
	}
	
	if(sCompanyWith == null) sCompanyWith = ""; 
	if(sCheckPartner == null) sCheckPartner = ""; 
	
	if(sCheckPartner.equals("2")){
		doTemp.setRequired("PartnerName",false);
		doTemp.setRequired("PartnerPhone",false);
	}

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪGrid���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
		{"false","All","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath}
	};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
		if(sTempSaveFlag.equals("2"))
			sButtons[1][0] = "false";
		if ("ReadOnly".equals(sRightType))  {
			sButtons[0][0] = "false";
			sButtons[1][0] = "false";
		}

	//ֻҪ�ͻ�����û������Ȩ,�Ͳ����޸ı�ҳ�档
	/* String sRight = Sqlca.getString(new SqlObject(" select BelongAttribute2 from CUSTOMER_BELONG where CustomerID = :CustomerID and UserID = :UserID ").setParameter("CustomerID",sCustomerID).setParameter("UserID",CurUser.getUserID()));
	if(sRight != null && !sRight.equals("1")){
	 	sButtons[0][0] = "false";
	 	sButtons[1][0] = "false";
	} */
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
	function saveRecord(sPostEvents){
		setItemValue(0,0,"TempSaveFlag","2");
		as_save("myiframe0",sPostEvents);
		setRequired();
	}
	function setRequired(){
		var sCompanyWith=getItemValue(0,0,"companyWith");
		var sCheckPartner=getItemValue(0,0,"checkPartner");
		if(sCheckPartner=="2"){
			setItemRequired(0,0,"PartnerName",false);
			setItemRequired(0,0,"PartnerPhone",false);
		}else{
			setItemRequired(0,0,"PartnerName",true);
			setItemRequired(0,0,"PartnerPhone",true);
		}
	}
		
	function saveRecordTemp(){
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,0,"TempSaveFlag","1");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0");   //���ݴ�
		setNeedCheckRequired(0);//����ٽ����������û���	
	}
    
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow()
	{
		 var sRightType="ReadOnly";
		 if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			 //ֻҪ����ֻ�����Ϳ���������¼
			// if(sRightType!="ReadOnly"){
			   as_add("myiframe0");//������¼
			 //}
			beforeInsert();
			
		} 
		setItemValue(0,0,"Objectno","<%=sObjectNo%>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getTodayNow()%>");
    } 
	 function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
	} 
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sSerialNo = getSerialNo("AssistInvestigate","serialNo");
		setItemValue(0,0,"Serialno",sSerialNo);
	} 
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������ͬ��Ա;InputParam=��;OutPutParam=��;]~*/
	function checkPartnerNo(obj){
		var sCompanyWith=getItemValue(0,0,"companyWith");
		//�����ͬ��ԱΪ��
		if(sCompanyWith=="0"){
			setItemValue(0,0,"checkPartner","2");
			setItemRequired(0,0,"PartnerName",false);
			setItemRequired(0,0,"PartnerPhone",false);
			return;
		}
		setItemValue(0,0,"checkPartner","1");
		setItemRequired(0,0,"PartnerName",true);
		setItemRequired(0,0,"PartnerPhone",true);
	}
	/*~[Describe=��ͬ��Ա�Ƿ�������;InputParam=��;OutPutParam=��;]~*/
	function checkPartner(obj){
		var sCompanyWith=getItemValue(0,0,"companyWith");
		if(sCompanyWith=="0"){
			setItemValue(0,0,"checkPartner","2");
		}
		var sCheckPartner=getItemValue(0,0,"checkPartner");
		if(sCheckPartner=="1"){
			setItemRequired(0,0,"PartnerName",true);
			setItemRequired(0,0,"PartnerPhone",true);
		}
		if(sCheckPartner=="2"){
			setItemRequired(0,0,"PartnerName",false);
			setItemRequired(0,0,"PartnerPhone",false);
		}
	}
	/*~[Describe=��ͬ��Ա�ֻ��ŵ�У��;InputParam=��;OutPutParam=��;]~*/
	function checkPartnerPhone(obj){
		var sPartnerPhone=getItemValue(0,0,"PartnerPhone");
		if(typeof(sPartnerPhone) == "undefined" || sPartnerPhone.length==0){     
	    	return false;
	    }
		if(!(/^\d+$/.test(sPartnerPhone))){
			alert("�ֻ���ֻ��������");
			obj.focus();
			return false;
		}
	}
	
	/*~[Describe=����������֤;InputParam=��;OutPutParam=��;]~*/
	function checkName(obj){
		var sName=obj.value;
		if(typeof(sName) == "undefined" || sName.length==0 ){
			return false;
		}else{
			
		if(/\s+/.test(sName)){
			alert("�������пո�����������");
			obj.focus();
			return false;
		}
		//�������������Ļ�����ĸ
		if(!(/^[\u4e00-\u9fa5]{2,7}$|^[a-zA-Z]{1,30}$/.test(sName))){
			   // if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)��([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("��������Ƿ�");
				obj.focus();
				return false;
			    //}
			}
		 }
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
	<script type="text/javascript">	
		AsOne.AsInit();
		init();
		bFreeFormMultiCol=true;
		my_load(2,0,'myiframe0');
		initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	</script>	
	<%/*~END~*/%>
<%@	include file="/IncludeEnd.jsp"%>