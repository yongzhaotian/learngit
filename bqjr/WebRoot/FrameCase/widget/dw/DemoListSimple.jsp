<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_simplelist.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(20);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","","btn_icon_add",""},
		{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
		{"true","","Button","�����˵��༭","�����˵��༭","editd()","","","","btn_icon_detail",""},
		{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
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
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}function editd(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoDMenu.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
