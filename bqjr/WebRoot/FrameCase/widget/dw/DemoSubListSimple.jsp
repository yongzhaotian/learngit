<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_sublist.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(5);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","","btn_icon_add",""},
		{"true","","Button","����","����","reloadSelf()","","","","btn_icon_detail",""},
		{"true","","Button","�����˵��༭","�����˵��༭","editd()","","","","btn_icon_detail",""},
		{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
		 PopPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_blank','');
	}function editd(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoDMenu.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
	//��ʾ�ӱ����¼�
	function displaySubTable(rowIndex,frameId){
		var sUrl = "/FrameCase/widget/dw/DemoInfoDMenu.jsp";
		sUrl = sUrl+'?SerialNo=' + getItemValue(0,rowIndex,'SerialNo');
		OpenPage(sUrl,frameId,'');
	}
	//�ӱ������¼�
	function reloadFrame(frameId){
		//�����ӱ��߶�
		setFrameHeight(frameId,"auto");
	}
	
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
