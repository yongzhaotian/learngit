<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_sublist.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.forceSerialJBO = true;
	dwTemp.setPageSize(5);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly ="0";
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","ȫ������","ȫ������","saveAll()","","","","btn_icon_save",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function saveAll(){
		as_saveAll();
	}
	//��ʾ�ӱ����¼�
	function displaySubTable(rowIndex,frameId){
		//alert("frameId=" + frameId);
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
