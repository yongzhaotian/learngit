<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.setPageSize(1);
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
	function validFilter(){
		

		alert(getFilterAreaOption(0,"serialno"));
		alert(getFilterAreaOption(0,"ISINUSE"));
		alert(getFilterAreaOption(0,"ADDRESS"));
				
		alert(getFilterAreaValue(0,"serialno",1));
		alert(getFilterAreaValue(0,"ISINUSE"));
		alert(getFilterAreaValue(0,"ADDRESS"));

		getFilterAreaInput(0,"serialno").focus();
		alert('ģ�����');
		return false;
	}
	function initFilter(){
		setFilterAreaValue(0,"serialno","2011030405");
		setFilterAreaValue(0,"ISINUSE","2");
		setFilterAreaValue(0,"ADDRESS","2011/11/08");

		setFilterAreaOption(0,"serialno","Area");
		setFilterAreaOption(0,"ISINUSE","In");
		setFilterAreaOption(0,"ADDRESS","BigThan");

		//��ʾ�߼���ѯ��
		showFilterArea();
		//�ύ��ѯ
		submitFilterArea();
	}
	window.onload= initFilter;
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
