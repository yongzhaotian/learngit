<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";
	/***��CCS-960�Դ�ҳ������˷��¸���Ϊ�˼����ı��༭������ҳ���ѱ�EditorNoticeInfo.jsp���� ***/

	// ���ҳ�����
	String sNoticeId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NoticeId"));
	if(sNoticeId==null) sNoticeId="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "NoticeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sNoticeId);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveAndGoBack()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		//��ù��������ж�������󲻳���2000����
		var	NoticeContent = getItemValue(0,0,"NoticeContent");
		if(NoticeContent.length<=2000){
			saveRecord("goBack()");
		}else{
			alert("������������ѳ���2000�֣�����˾�����ٱ��棡");
		}
	}
	
	function goBack(){
		AsControl.OpenView("/Common/WorkFlow/NoticeList.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var NoticeId = getSerialNo("Notice_INFO","NoticeId","");
		setItemValue(0,0,"NoticeId",NoticeId);
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTORG","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		setItemValue(0,0,"NoticeDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		setItemValue(0,0,"NoticePeople","<%=CurUser.getUserID()%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORG","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			
			setItemValue(0,0,"NoticeDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			setItemValue(0,0,"NoticePeople","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"NoticePeopleName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
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
