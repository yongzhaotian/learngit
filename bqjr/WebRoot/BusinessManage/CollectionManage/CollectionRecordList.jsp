<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CollectionList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","��ͬ�鿴","�鿴��ͬ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����¼��","����¼��","newRecord()",sResourcesPath},
		{"true","","Button","�鿴��ʷ","�鿴��ʷ","newRecord()",sResourcesPath},
		//{"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		//{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
		//{"true","","Button","����¼��","¼�������ʷ","newRecord()",sResourcesPath},
		//{"true","","Button","�鿴��ʷ","�鿴������ʷ","viewAndEdit()",sResourcesPath},
		//{"true","","Button","���ں�ͬ�б�","���ں�ͬ�б�","viewOverdueContract()",sResourcesPath},
		//{"false","","Button","������ʷ��ѯ","������ʷ��ѯ","newRecord()",sResourcesPath},
		//{"false","","Button","�������","�������","viewAndEdit()",sResourcesPath},
		//{"false","","Button","���ü���","���ü���","deleteRecord()",sResourcesPath},
		//{"true","","Button","����ת��","����ת��","",sResourcesPath},
		//{"true","","Button","���ڼ�¼ͳ�Ʋ�ѯ","���ڼ�¼ͳ�Ʋ�ѯ","",sResourcesPath},
		//{"true","","Button","���ŷ���","���ŷ���","",sResourcesPath},
		//{"true","","Button","���ʷ���","���ʷ���","",sResourcesPath},
		//{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/CollectionRecodeInfo.jsp","","_self","");
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
		}
	}
	
	/*~[Describe=���ڿͻ���ͬ��ѯ;InputParam=��;OutPutParam=��;]~*/
	function viewOverdueContract(){
		OpenPage("/BusinessManage/CollectionManage/OverdueContractList.jsp","_self","");
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		//alert("======"+sSerialNo);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/CollectionRecodeInfo.jsp","SerialNo="+sSerialNo+"&flag=Y","_self","");
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>