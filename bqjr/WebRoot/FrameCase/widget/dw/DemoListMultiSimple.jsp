<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    //���ղ��������ݲ���ȷ����ҳ�������
    String sLayout = DataConvert.toString(request.getParameter("Layout"));

	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.setPageSize(30);//���õ�ҳ��ʾ�ļ�¼����
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","","btn_icon_add",""},
		{"false","","Button","����","����","edit()","","","","btn_icon_detail",""},
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
	}
	function mySelectRow(){

		var layout = "<%=sLayout%>";
		sSerialNo=getItemValue(0,getRow(),"SerialNo");

		if(layout == "east"){
			//��Ϊ������������򿪼�¼��������Ϣ
			var sUrl = "/FrameCase/widget/dw/DemoInfoMultiSimple.jsp";
			OpenPage(sUrl+'?SerialNo=' + sSerialNo+"&Layout=east",parent.Layout.getRegionName('east'),"");
		}
        if(layout == "south"){
        	//��Ϊ������������򿪼�¼�Ĺ����б���Ϣ
        	var sUrl = "/FrameCase/widget/dw/DemoInfoMultiSimple.jsp";
			OpenPage(sUrl+'?SerialNo=' + sSerialNo+"&Layout=south",parent.Layout.getRegionName('south'),"");
        }
	}

	//����ҳ���Ĭ��ѡ���һ��
	//mySelectRow(0);
	
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
