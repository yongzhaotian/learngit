<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<div>
<input id="add01" value="�����Tab(������)" type="button"/>
<input id="add02" value="�����Tab(����)"  type="button"/>
<input id="add03" value="�����Tab(���ɹر�)"  type="button"/>
<input id="add04" value="�����Tab(�ɹر�)"  type="button"/>
<input id="add05" value="�����Tab(��Ӻ�������)"  type="button"/>
</div>
<div style="padding:1% 0.5%;border:0px solid #F00;position:absolute; height:100%;width: 100%;over-flow:hidden" id="ExamplePlant">
</div>
<%@ include file="/IncludeEnd.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	
	var tabCompent = new TabStrip("T001","����̨","tab","#ExamplePlant");
	tabCompent.setSelectedItem("0010");			//Ĭ��ѡ����ı��
	tabCompent.setIsAddButton(true);				//�Ƿ����½���ť
	tabCompent.setAddCallback("addNewTabListen(this)");		//�½���ť��������
	tabCompent.setCloseCallback("deleteTabListen(this)");	//ִ��ɾ�����������
	//tabCompent.setIsCache(true);	 			//�Ƿ񻺴�,�������Ϊfalse������ӵ�Ԫ�ؼ�ʹ�����˻���Ҳ������Ч
	//tabCompent.setCanClose(false);			//�Ƿ��йرհ�ť,�������Ϊfalse������ӵ�Ԫ�ؼ�ʹ�����˹رհ�ťҲ������ʾ
	//���һ�����˵����ID(����Ψһ)�����ƣ��ⷢ�ű����Ƿ񻺴棬�Ƿ��пɹر�
	tabCompent.addDataItem('0010',"ʾ��01","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0020',"ʾ��02","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0030',"ʾ��03","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",true,true);
	//���ʹ��addDataItem,��������init()����
	tabCompent.initTab(); 

	var number = 4;
	var script = "AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')";
	//����󶨰�ť�¼�
	//1.�����Tab(������)
	$("#add01").click(function(){
		tabCompent.addItem('0X'+number,"���"+number,script,false,true,false);
		number++;
	});
	$("#add02").click(function(){
		tabCompent.addItem('0X'+number,"���"+number,script,true,true,false);
		number++;
	});
	$("#add03").click(function(){
		tabCompent.addItem('0X'+number,"���"+number,script,true,false,false);
		number++;
	});
	$("#add04").click(function(){
		tabCompent.addItem('0X'+number,"���"+number,script,true,true,false);
		number++;
	});
	$("#add05").click(function(){
		tabCompent.addItem('0X'+number,"���"+number,script,true,true,true);
		number++;
	});
});

function addNewTabListen(obj){
	id = $(obj).attr("id").replace(/^handle_/,"");
	alert("�½���ť�������!ID="+id);
}
function deleteTabListen(obj){
	id = $(obj).attr("id").replace(/^handle_/,"");
	alert("ѡ���ɾ��!ID="+id);
}
</script>