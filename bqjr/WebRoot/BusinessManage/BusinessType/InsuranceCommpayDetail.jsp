<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "���չ�˾��Ʒ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���չ�˾��Ʒ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����,��Ʒ���
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���չ�˾��Ʒ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root", "������Ϣ", "", 1);
	tviTemp.insertPage("root", "������Ʒ", "", 2);
	tviTemp.insertPage("root", "��������", "", 3);
	//tviTemp.insertPage("root", "��������", "", 4); midify by 20151019 guoqiang.liu

	
	%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sSerialNo="<%=sSerialNo%>";
		var sCurItemID = getCurTVItem().id;
		var sFlag = "Detail";
		if(sCurItemID=="1"){	
			AsControl.OpenView("/BusinessManage/BusinessType/InsuranceCommpayInfo.jsp","SerialNo="+sSerialNo+"&sFlag="+sFlag,"right");
		}else if(sCurItemID=="2"){
			AsControl.OpenView("/BusinessManage/BusinessType/InsuranceProductList.jsp","SerialNo="+sSerialNo,"right");
		}else if(sCurItemID=="3"){
			AsControl.OpenView("/BusinessManage/BusinessType/InsuranceCityList.jsp","SerialNo="+sSerialNo,"right");			
		}else if(sCurItemID=="4"){
			AsControl.OpenView("/BusinessManage/BusinessType/InsuranceFeeTypeList.jsp","SerialNo="+sSerialNo,"right");			
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem("1");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
