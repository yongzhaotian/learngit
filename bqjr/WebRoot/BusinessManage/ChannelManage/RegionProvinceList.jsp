<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 
 	// ��ȡ�������
 	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
 	String sAreaUserId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaUserId"));
 	
 	if (sAreaNo == null) sAreaNo = "";
 	if (sAreaUserId == null) sAreaUserId = "";
 	String sTypeCode = "ProvinceCode";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ProvinceCodeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause += " and AttrStr1='"+sAreaNo+"'";

	//doTemp.setColumnAttribute("ExampleName","IsFilter","1");
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
		};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function mySelectRow(){
		var sProvinceNo = getItemValue(0,getRow(),"Attr1");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sProvinceManager = getItemValue(0, getRow(), "Attr3");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityList.jsp","ProvinceNo="+sProvinceNo+"&AreaNo=<%=sAreaNo%>"+"&ProvinceManager="+sProvinceManager,"rightdown","");
		}
	}
	
	function newRecord(){
		var sArea = "<%=sAreaNo %>";
		if (typeof(sArea)=='undefined' || sArea.length==0) {
			alert("��ѡ���������");
			return;
		}
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionProvinceInfo.jsp","TypeCode=<%=sTypeCode %>&AreaNo=<%=sAreaNo %>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionProvinceList.jsp&AreaUserId=<%=sAreaUserId%>","_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionProvinceInfo.jsp","AreaNo=<%=sAreaNo %>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionProvinceList.jsp&SerialNo="+sSerialNo+"&ProvinceNo="+getItemValue(0, getRow(), "Attr1")+"&AreaUserId=<%=sAreaUserId%>","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var sProvinceSerialNo = RunMethod("���÷���", "GetColValue", "Basedataset_Info,SerialNo,TypeCode='CityCode' and AttrStr1='"+getItemValue(0, getRow(), "Attr1")+"' and AttrStr2='"+getItemValue(0, getRow(), "AttrStr1")+"'");
		if (sProvinceSerialNo != "Null") {
			alert("����ɾ����ʡ���¹������У���ɾ����ʡ�ݣ�");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			// ����ʡ��������Ա�ϼ���ԭ���������Ա�ϼ�
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateProvinceSuperDel","provinceUserId="+getItemValue(0, getRow(), "Attr3")+",rawUserId=,provinceNo="+getItemValue(0, getRow(), "Attr1"));
			
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}
	
	function init_row() {
		
		var sProvinceNo = getItemValue(0,getRow(),"Attr1");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityList.jsp","ProvinceNo="+sProvinceNo,"rightdown","");
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		init_row();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>