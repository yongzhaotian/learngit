<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//add by ybpan at 20150210
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "����ǹؼ������б�";
	//���ҳ�����
	String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	if(sInputUser==null) sInputUser="";

	String sCurUser = CurUser.getUserID();
	ARE.getLog().debug("========��ǰ�û���"+sCurUser);
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "IsPrimaryErrorList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�÷�������ǰʱ��
	String curDateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");

	doTemp.WhereClause = " WHERE (qg.QUALITYGRADE = '1' or (qg.QUALITYGRADE = '2' AND ceil((to_date('"+curDateTime+"','yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) < 4)) AND ceil((to_date('"+curDateTime+"','yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) > 1 AND bc.SERIALNO=qg.ARTIFICIALNO AND bc.salesmanager='"+sCurUser+"' ";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

	
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCurUser);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			/* {"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()","","","","",""}, */
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
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
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
