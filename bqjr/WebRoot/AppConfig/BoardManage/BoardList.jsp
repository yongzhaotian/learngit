<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �����б�
	 */
	String PG_TITLE = "�����б�";
	
//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BoardList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
	//dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(BOARD_LIST,BoardNo='#BoardNo')");
	dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo')");
	dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","All","Button","��������","��������","my_add()",sResourcesPath},
		{"true","All","Button","ɾ������","ɾ������","my_del()",sResourcesPath},
		{"true","","Button","��������","�鿴��������","my_detail()",sResourcesPath},
		{"true","","Button","���渽��","�鿴���渽��","DocDetail()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){
		 	as_add("myiframe0");
		}
	}
	
	function my_add(){
		AsControl.OpenView("/AppConfig/BoardManage/BoardInfo.jsp","","rightdown","");
	}
	
	function my_detail(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");			
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		AsControl.OpenView("/AppConfig/BoardManage/BoardInfo.jsp","BoardNo="+sBoardNo,"rightdown","");
	}
	
	<%/*[Describe=�鿴���渽��;]*/%>
	function DocDetail(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//AsControl.OpenView("/AppConfig/Document/AttachmentList.jsp","DocNo="+sDocNo,"rightdown","");
		AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	function my_del(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");	
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
		parent.reloadSelf();
	}

	<%/*~[Describe=�����¼�;]~*/%>
	function mySelectRow(){
		var sBoardNo = getItemValue(0,getRow(),"BoardNo");
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0){
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/AppConfig/BoardManage/BoardInfo.jsp","BoardNo="+sBoardNo,"rightdown","");
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>