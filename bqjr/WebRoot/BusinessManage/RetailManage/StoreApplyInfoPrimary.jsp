<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	ARE.getLog().info("sSerialNo============================================"+sSerialNo);
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreApplyInfoPrimary";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("PrimaryApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�ύ","�ύ�����޸�","saveRecord()","","","","btn_icon_save",""},
			{"true","","Button","����","�����б�ҳ��","goBack()","","","","",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function selectStatus(){
		var sPrimaryApproveStatus = getItemValue(0,getRow(),"PrimaryApproveStatus");
		if(sPrimaryApproveStatus=="1"){
			hideItem(0, 0, "PrimaryRefuseReason");//����
			setItemValue(0, 0, "PrimaryRefuseReason", "");
			setItemRequired(0,0, "PrimaryRefuseReason", false);
			}else if (sPrimaryApproveStatus=="2"){
				showItem(0, 0, "PrimaryRefuseReason");//��ʾ
		        setItemRequired(0,0, "PrimaryRefuseReason", true);
			}
	}
	
	function saveRecord(sPostEvents){
		var sssSerialNo="<%=sSerialNo%>";
		var sPrimaryApproveStatus=getItemValue(0,0,"PrimaryApproveStatus");
		var sRemark=getItemValue(0,0,"REMARK");
		var sPrimaryRefuseReason=getItemValue(0,0,"PrimaryRefuseReason");
		var sPrimaryApproveTime=getItemValue(0,0,"PRIMARYAPPROVETIME");
		var sPrimaryApprovePerson=getItemValue(0,0,"PRIMARYAPPROVEPERSON");
		if(sPrimaryApproveStatus=="4"){
			alert("��ѡ�����״̬��");
			return;
		}

		//�ύ
		var AllSerialNo = sssSerialNo.replace(/,/g,"|");//�滻������,
		var para = "AllSerialNo="+AllSerialNo+",PrimaryApproveStatus="+sPrimaryApproveStatus
			+",Remark="+sRemark+",PrimaryRefuseReason="+sPrimaryRefuseReason
			+",PrimaryApproveTime="+sPrimaryApproveTime+",PrimaryApprovePerson="+sPrimaryApprovePerson;
		RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno","PrimaryApproveStore", para);
		
		as_save("myiframe0",sPostEvents);
		selectStatus();
	}
	
	// ���ؽ����б�
	function goBack()
	{
		//AsControl.OpenView("/BusinessManage/ChannelManage/RetailStoreApplyList.jsp","","_self");
		self.close();
	}
	
	function initRow(){
		setItemValue(0,0,"PRIMARYAPPROVETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		setItemValue(0,0,"PRIMARYAPPROVEPERSON","<%=CurUser.getUserID()%>");
		selectStatus();
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SERIALNO","<%=sSerialNo%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
