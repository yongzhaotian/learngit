<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 
 	// ��ȡ�������
 	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
 	String sProvinceNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceNo"));
 	String sProvinceManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceManager"));
 	
 	if (sAreaNo == null) sAreaNo = "";
 	if (sProvinceNo == null) sProvinceNo = "";
 	if (sProvinceManager == null) sProvinceManager = "";
 	String sTypeCode = "CityCode";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CityCodeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause += " and AttrStr1='" + sProvinceNo + "' and AttrStr2='"+sAreaNo+"' and Attr1='"+sProvinceManager+"'";

	/* doTemp.setColumnAttribute("ExampleName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange); */
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
		/* var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if(typeof(sExampleId)=="undefined" || sExampleId.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"rightdown","");
		} */
	}
	
	function newRecord(){
		var sProvince = "<%=sProvinceNo %>";
		if (typeof(sProvince)=='undefined' || sProvince=='undefined' || sProvince.length==0) {
			alert("��ѡ�����ʡ�ݣ�");
			return;
		}
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityInfo.jsp","TypeCode=<%=sTypeCode %>&AreaNo=<%=sAreaNo%>&ProvinceNo=<%=sProvinceNo %>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionCityList.jsp"+"&ProvinceManager=<%=sProvinceManager%>&CityNo="+getItemValue(0, getRow(), "Attr2"),"_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sParam = "SerialNo="+sSerialNo+"&ProvinceManager=<%=sProvinceManager%>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionAreaList.jsp&ProvinceNo=<%=sProvinceNo %>&AreaNo=<%=sAreaNo %>&CityNo="+getItemValue(0, getRow(), "Attr2");
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityInfo.jsp", sParam,"_self","");
		
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			
			// ���³��й�����Ա�ϼ���ԭ���������Ա�ϼ�
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateCitySuperDel","cityUserId="+getItemValue(0, getRow(), "Attr3")+",rawUserId=,cityNo="+getItemValue(0, getRow(), "Attr2"));

			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>