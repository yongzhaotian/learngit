<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 
 	// �������
 	String sTypeCode = "AreaCodeCar";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AreaCodeList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
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
		var sAreaNo = getItemValue(0,getRow(),"Attr1");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/DistributorInfo/RegionProvinceList1.jsp","AreaNo="+sAreaNo,"rightmiddle","");
		}
	}
	
	function newRecord(){
		
		AsControl.OpenView("/DistributorInfo/RegionAreaInfo1.jsp","TypeCode=<%=sTypeCode %>","_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/DistributorInfo/RegionAreaInfo1.jsp","SerialNo="+sSerialNo+"&PrevUrl=/DistributorInfo/RegionProvinceList1.jsp","_self","");
		
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			var sAreaNo = getItemValue(0, getRow(), "Attr1");
			RunMethod("���÷���", "DelByWhereClause", "Basedataset_Info,(TypeCode='CityCodeCar' and AttrStr2='"+sAreaNo+"') or (TypeCode='ProvinceCodeCar' and AttrStr1='"+sAreaNo+"')");
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			parent.reloadSelf();
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>