<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<div style="padding:1% 0.5%;border:0px solid #F00;position:absolute; height:100%;width: 100%;over-flow:hidden" id="ControlCenter">
</div>
<%@ include file="/IncludeEnd.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var tabCompent = new TabStrip("T001","����̨","tab","#ControlCenter");
	tabCompent.setSelectedItem("0010");			//Ĭ��ѡ����ı��
	//tabCompent.setIsCache(true);	 			//�Ƿ񻺴�,�������Ϊfalse������ӵ�Ԫ�ؼ�ʹ�����˻���Ҳ������Ч
	tabCompent.setCanClose(false);			//�Ƿ��йرհ�ť,�������Ϊfalse������ӵ�Ԫ�ؼ�ʹ�����˹رհ�ťҲ������ʾ
	//���һ�����˵����ID(����Ψһ)�����ƣ��ⷢ�ű����Ƿ񻺴棬�Ƿ��пɹر�
	tabCompent.addDataItem('0010',"���в���","AsControl.OpenView('/AppConfig/ControlCenter/RunConfig.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0020',"�������̨","AsControl.OpenView('/AppConfig/ControlCenter/CacheConsole.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0030',"ϵͳ����","AsControl.OpenView('/AppConfig/ControlCenter/SystemEnv.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0040',"ϵͳ����","AsControl.OpenView('/AppConfig/ControlCenter/SystemProperties.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0050',"��־����","AsControl.OpenView('/AppConfig/ControlCenter/LogManage/GeneralFileManage.jsp','','TabContentFrame')",true,true);
	
	//���ʹ��addDataItem,��������init()����
	tabCompent.initTab(); 
});
</script>