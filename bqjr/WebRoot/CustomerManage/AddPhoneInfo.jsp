
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 
		Input Param:
			
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�绰������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sTempletNo = "AddPhoneInfo";
	//�������������ͻ�����
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
	System.out.println("--------aaaaa-----------"+sSerialNo);
	System.out.println("--------bbbbb-----------"+sCustomerID);
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//�����������ѯ�����
	ASResultSet rs = null;
	String sSql = "",sCustomerName="";
	
    sSql=" select customername from ind_info where customerid=:CustomerID ";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
    if(rs.next()){
   	   sCustomerName = DataConvert.toString(rs.getString("customername"));//�ͻ�����
   	 
		//����ֵת���ɿ��ַ���
		if(sCustomerName == null) sCustomerName = "";
    }
    rs.getStatement().close();
	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly="0";

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
			{"false","","Button","ȷ��","ȷ��","doCreation()",sResourcesPath},

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
	function saveRecord()
	{
		if(!ValidityCheck()) return;
		doCreation();//ȷ��
		as_save("myiframe0");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		 //����
		sZipCode = getItemValue(0,getRow(),"ZipCode");
		//�绰����
		sPhoneCode = getItemValue(0,getRow(),"PhoneCode");
		//�ֻ���
		sExtensionNo = getItemValue(0,getRow(),"ExtensionNo");
		
		if(sPhoneType=="02"||sPhoneType=="05"||sPhoneType=="06"){
			var reg1=/^\d{11}$/;
			var sSub1=sPhoneCode.substring(0,1);//��ȡ�ֻ��ŵĵ�һ���ַ�
			if(isNaN(sPhoneCode)==true){
				alert("�ֻ��������������!");
				return false;
			}
			if(sPhoneCode!=""&&(sSub1!='1'||reg1.test(sPhoneCode)==false)){
				alert("�ֻ������ʽ��д����!");
				return false;
			}
			
		}else if(sPhoneType=="01"||sPhoneType=="03"){
			//�̶��绰���ŵ�У��
			var sSub=sZipCode.substring(0,1);//��ȡ���ŵĵ�һ���ַ�
			
			var reg=/^\d{3,4}$/;
			if(isNaN(sZipCode)==true){//����
				alert("���ű���������!");
				return false;
			}
			if(sZipCode!=""&&(sSub!='0'||reg.test(sZipCode)==false)){
				alert("������д����!");
				return false;
			}
			//�̶��绰�����У��
			reg=/^\d{7,8}$/;
			if(isNaN(sPhoneCode)==true){
				alert("�绰�������������!");
				return false;
			}
			if((sPhoneCode!="")&&reg.test(sPhoneCode)==false){
				alert("�̶��绰������д����!");
				return false;
			}
			//�ֻ��ŵ�У��
			reg=/^\d{1,8}$/;
			if(isNaN(sExtensionNo)==true){
				alert("�ֻ��ű���������!");
				return false;
			}
			if((sExtensionNo!="")&&reg.test(sExtensionNo)==false){
				alert("�ֻ�������д����!");
				return false;
			}
			
		}else{
			return true;
		}
		return true;
	} 
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/AddPhoneList.jsp","_self","");
	}
	
	function doCreation()
	{
      doReturn();
	}
	
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sZipCode     = getItemValue(0,getRow(),"ZipCode");//����
		sPhoneCode   = getItemValue(0,getRow(),"PhoneCode");//�绰����
		sExtensionNo    = getItemValue(0,getRow(),"ExtensionNo");//�ֻ�����
		sPhoneType    = getItemValue(0,getRow(),"PhoneType");//�绰����

		//alert("-----"+sZipCode+"--------"+sPhoneCode+"-----"+sExtensionNo);
		top.returnValue = sZipCode+"@"+sPhoneCode+"@"+sExtensionNo+"@"+sPhoneType;
		//top.close();
	}
	
	/*~[Describe=�绰����;InputParam=��;OutPutParam=��;]~*/
	function selectPhone(){
		sPhoneType = getItemValue(0,getRow(),"PhoneType");
		
		if(sPhoneType=="01"){//�̶��绰
			setItemValue(0,0,"ZipCode","");
			showItem(0, 0, "ZipCode");//��ʾ
			showItem(0, 0, "PhoneCode");//��ʾ
			showItem(0, 0, "ExtensionNo");//��ʾ
			showItem(0, 0, "Owner");//��ʾ
			setItemRequired(0,0,"ZipCode",true);
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"PhoneCode",true);
			setItemDisabled(0,0, "ZipCode",false);
		}
		if(sPhoneType=="02"){//�ƶ��绰
			setItemValue(0,0,"ZipCode","+86");
			showItem(0, 0, "ZipCode");//��ʾ
			showItem(0, 0, "PhoneCode");//��ʾ
			hideItem(0, 0, "ExtensionNo");//����
			showItem(0, 0, "Owner");//��ʾ
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"PhoneCode",true);
			setItemRequired(0,0,"Annotation",false);
			//setItemReadOnly(0,0,"ZipCode",true);//�һ�����
			setItemDisabled(0,0, "ZipCode",true);
		}
		if(sPhoneType=="03"){//�����绰
			setItemValue(0,0,"ZipCode","");
			showItem(0, 0, "ZipCode");//��ʾ
			showItem(0, 0, "PhoneCode");//��ʾ
			showItem(0, 0, "ExtensionNo");//��ʾ
			showItem(0, 0, "Owner");//��ʾ
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"ZipCode",true);
			setItemRequired(0,0,"PhoneCode",true);
			setItemDisabled(0,0, "ZipCode",false);
		}
		if(sPhoneType=="04"){//������Ϣ
			hideItem(0, 0, "ZipCode");//����
			hideItem(0, 0, "PhoneCode");//����
			hideItem(0, 0, "ExtensionNo");//����
			hideItem(0, 0, "Owner");//����
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"Annotation",true);
			setItemDisabled(0,0, "ZipCode",false);
		}
		if(sPhoneType=="05"){//��λ�ƶ��绰
			setItemValue(0,0,"ZipCode","+86");
			showItem(0, 0, "ZipCode");//��ʾ
			showItem(0, 0, "PhoneCode");//��ʾ
			hideItem(0, 0, "ExtensionNo");//����
			showItem(0, 0, "Owner");//��ʾ
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"PhoneCode",true);
			//setItemReadOnly(0,0,"ZipCode",true);
			setItemDisabled(0,0, "ZipCode",true);
		}
		if(sPhoneType=="06"){//��ͥ�ƶ��绰
			setItemValue(0,0,"ZipCode","+86");
			showItem(0, 0, "ZipCode");//��ʾ
			showItem(0, 0, "PhoneCode");//��ʾ
			hideItem(0, 0, "ExtensionNo");//����
			showItem(0, 0, "Owner");//��ʾ
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"Annotation",false);
			setItemRequired(0,0,"PhoneCode",true);
			//setItemReadOnly(0,0,"ZipCode",true);
			setItemDisabled(0,0, "ZipCode",true);
		}
		if(sPhoneType==""){
			showItem(0, 0, "ZipCode");//��ʾ
			showItem(0, 0, "PhoneCode");//��ʾ
			showItem(0, 0, "ExtensionNo");//��ʾ
			showItem(0, 0, "Owner");//��ʾ
			
			setItemRequired(0,0,"ZipCode",false);
			setItemRequired(0,0,"PhoneCode",false);
			setItemRequired(0,0,"ExtensionNo",false);
			setItemRequired(0,0,"Owner",false);
			
			setItemValue(0,0,"ZipCode","");
		}
	}
	
	/*~[Describe=�ͻ���ϵ;InputParam=��;OutPutParam=��;]~*/
	function selectRelative(){
		sRelation = getItemValue(0,getRow(),"Relation");
		
		if(sRelation=="010"){//����
			setItemValue(0,0,"Owner","<%=sCustomerName%>");
		}else{
			setItemValue(0,0,"Owner","");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			initSerialNo();
			//���ÿͻ�ID��
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		var sTableName = "Phone_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);*/
		var sSerialNo = '<%=DBKeyUtils.getSerialNo("PI")%>';
		/** --end --*/
		
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"SerialNo",sSerialNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	//bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>