<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:ʾ��ģ����ҳ��
	 */
	String PG_TITLE = "�ͷ���Ϣ��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ͷ���Ϣ��ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";	//"200";//Ĭ�ϵ�treeview��� modified by tbzeng 2014/07/30

	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ʾ��ģ����ҳ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	//String sFolder1=tviTemp.insertFolder("root","ʾ����Ϣ","",1);
	//tviTemp.insertPage(sFolder1,"���е�ʾ����Ϣ","",1);
	//tviTemp.insertPage(sFolder1,"�ҵ�ʾ����Ϣ","",2);
	//tviTemp.insertPage(sFolder1,"����ʾ����Ϣ","",3);
	tviTemp.insertPage("root","������ѯ","",1);
	tviTemp.insertPage("root","�ŵ���ѯ","",2);
	
	tviTemp.insertPage("root","�˻�����","",3);
	tviTemp.insertPage("root","����ȡ������","",4);
	tviTemp.insertPage("root","���ս�����","",5);
	tviTemp.insertPage("root","��ǰ��������","",6);
	tviTemp.insertPage("root","�˿�����","",7);
	tviTemp.insertPage("root","�����˺ű������","",8);
	tviTemp.insertPage("root","�����ļ���ѯ","",9);
	tviTemp.insertPage("root","�������֤������","",10);
	tviTemp.insertPage("root","�̻���ѯ","",11);
	tviTemp.insertPage("root","������ѯ","",12);
	
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	var defExpandId = '������ѯ';
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='������ѯ'){
			AsControl.OpenView("/CustomService/BusinessConsult/LoanConsultList.jsp","","right");
		}else if(sCurItemname=='�ŵ���ѯ'){
			AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp","","right");
		}else if(sCurItemname=='�˻�����'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y001","right");
		}else if(sCurItemname=='����ȡ������'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y002","right");
		}else if(sCurItemname=='���ս�����'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y003","right");
		}else if(sCurItemname=='��ǰ��������'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y004","right");
		}else if(sCurItemname=='�˿�����'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y005","right");
		}else if(sCurItemname=='�����˺ű������'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y006","right");
		}else if (sCurItemname=='�����ļ���ѯ') {
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp", "ApplyType="+"Y007", "right");
		}else if (sCurItemname=='�������֤������') {
			AsControl.OpenView("/CustomService/BusinessConsult/CreditSettleApproveList.jsp", "", "right");
		}else if (sCurItemname=='�̻���ѯ') {
			AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp", "temp=001", "right");
		}else if (sCurItemname=='������ѯ') {
			AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp", "temp=002", "right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		selectItemByName("������ѯ");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
