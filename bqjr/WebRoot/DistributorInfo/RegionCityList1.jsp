<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 
 	// ��ȡ�������
 	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
 	String sProvinceNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceNo"));
 	if (sAreaNo == null) sAreaNo = "";
 	if (sProvinceNo == null) sProvinceNo = "";
 	String sTypeCode = "CityCodeCar";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CityCodeList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause += " and AttrStr1='" + sProvinceNo + "' and AttrStr2='"+sAreaNo+"'";

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
		AsControl.OpenView("/DistributorInfo/RegionCityInfo1.jsp","TypeCode=<%=sTypeCode %>&AreaNo=<%=sAreaNo%>&ProvinceNo=<%=sProvinceNo %>"+"&PrevUrl=/DistributorInfo/RegionCityList1.jsp","_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/DistributorInfo/RegionCityInfo1.jsp","SerialNo="+sSerialNo+"&PrevUrl=/DistributorInfo/RegionAreaList1.jsp&ProvinceNo=<%=sProvinceNo %>&AreaNo=<%=sAreaNo %>&CityNo="+getItemValue(0, getRow(), "Attr1"),"_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
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