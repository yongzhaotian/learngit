<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: �������������������ҳ��-- */
	String PG_TITLE = "�������������������ҳ��";

	// ���ҳ�����
	String sColSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColectionSerialNo"));//����������
	String sBcSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo"));//��ͬ��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//�����Ǽǽ�����
	//out.println("sColSerialNo:"+sColSerialNo+"sBcSerialNo:"+sBcSerialNo);
	if(sColSerialNo==null)sColSerialNo="";
	if(sBcSerialNo==null)sBcSerialNo="";
	if(sSerialNo==null)sSerialNo="";
	
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CARCOLLECTIONREGISTINFO";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.setVisible("SERIALNO,PHASETYPE1,PHASETYPE2", false);//�Ƿ�ɼ�
	doTemp.setReadOnly("SERIALNO,INPUTUSERID,INPUTUSERNAME,INPUTORGID,INPUTORGNAME,INPUTDATE,UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", true);//�Ƿ�ֻ��
	if(sSerialNo.equals("")){
		doTemp.setVisible("SERIALNO,PHASETYPE1,PHASETYPE2,UPDATEUSERNAME,UPDATEUSERID,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", false);//�Ƿ�ɼ�
	}else{
		doTemp.setReadOnly("REGISTTYPE,REMARK,SERIALNO,INPUTUSERID,INPUTUSERNAME,INPUTORGID,INPUTORGNAME,INPUTDATE,UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE", true);//�Ƿ�ֻ��
	}
		
	doTemp.setRequired("REGISTTYPE", true);
	
	doTemp.setDDDWSql("PHASETYPE1", "select itemno,itemname from code_library where codeno='PhaseType1'");
	doTemp.setDDDWSql("PHASETYPE2", "select itemno,itemname from code_library where codeno='PhaseType2'");
	doTemp.setDDDWSql("REGISTTYPE", "select itemno,itemname from code_library where codeno='RegistType'");

	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}else{
			beforeUpdate();
		}
		as_save("myiframe0",sPostEvents);
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		//alert("����:ContractSerialNo=<%=sBcSerialNo%>&ColectionSerialNo=<%=sColSerialNo%>");
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","updateCarColectionRegist","RegistSerialNo="+sSerialNo);
		if(sReturn != "Success"){
			alert("���ո����Ǽǽ��״̬����ʧ��!");
			return;
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenPage("/BusinessManage/CollectionManage/ColectionRegistList.jsp","ContractSerialNo=<%=sBcSerialNo%>&ColectionSerialNo=<%=sColSerialNo%>","_self","");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var sSerialNo = getSerialNo("CAR_COLLECTIONREGIST_INFO","SerialNo","");// ��ȡ��ˮ��
		setItemValue(0,0,"SERIALNO",sSerialNo);
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UPDATEORGNAME","<%=CurUser.getOrgName()%>");
		setItemValue(0,0,"UPDATEORGID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
			if(bIsInsert){
				var sSerialNo = getSerialNo("CAR_COLLECTIONREGIST_INFO","SerialNo","");// ��ȡ��ˮ��
				setItemValue(0,0,"SERIALNO",sSerialNo);
				setItemValue(0,0,"CONTRACTSERIALNO","<%=sBcSerialNo%>");
				setItemValue(0,0,"COLECTIONSERIALNO","<%=sColSerialNo%>");
				setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
				setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
				setItemValue(0,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");
				setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			}
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
