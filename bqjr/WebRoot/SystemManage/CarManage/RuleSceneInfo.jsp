<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSceneId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SceneId"));
	if(sSceneId==null) sSceneId="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RuleSceneInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sSceneId!=""){
	    doTemp.setReadOnly("SCENEID", true);
	}
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSceneId);//�������,���ŷָ�
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
	//����������Ϣʱ����鳡������Ƿ��ظ�
	function CheckScene()
	{
		var s_SCENEID = getItemValue(0,getRow(),"SCENEID");
		var s_Count = RunMethod("���÷���", "GetColValue", "RULESCENE_INFO,Count(1),SCENEID='"+s_SCENEID+"'");
		if(s_Count>0)
		{
			alert("�ó�������Ѵ��ڣ������ظ����");
			return false;
		}
	}
	function saveRecord(sPostEvents){
		if(bIsInsert){
			var Check_01 = CheckScene();
			if(false == Check_01) return;
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/CarManage/RuleSceneList.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"RULETYPE","RuleFlow");
			bIsInsert = true;
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
