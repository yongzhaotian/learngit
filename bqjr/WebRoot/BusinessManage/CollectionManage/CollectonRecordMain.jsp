<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�绰������ҳ��
	 */
	String PG_TITLE = "�绰����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���չ���&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//��õ�½�˵Ľ�ɫ
	String roleID="";
	//M1��M2��M3��������Ƚ�ɫ�Ĳ˵���ʾ
	boolean roleM1=false;
	boolean roleM2=false;
	boolean roleM3=false;
	boolean roleMM=false;
	//M1,M2,M3��ť��ʾ 
	String buttonM1="false";
	String buttonM2="false";
	String buttonM3="false";
	
	String userID=CurUser.getUserID();
    String sSql="select roleid from User_Role where userid=:userid order by roleid";
    String sSql1="select roleid from User_Role where userid=:userid order by roleid desc";
	ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("userid", userID));
	while(rs.next()){
		roleID=rs.getString("roleid");
		//���ո߼�������߸߼�����
		if("1110".equals(roleID) || "1210".equals(roleID)){
			roleM1=true;
			roleM2=true;
			roleM3=true;
			roleMM=true;
			break;
		}
		
		//���M1���ܡ����M1�鳤�����M1רԱ
		if("1310".equals(roleID) || "1410".equals(roleID) || "1510".equals(roleID)){
			roleM1=true;
		}
		//���M2���ܡ����M2�鳤�����M2רԱ
		if("1311".equals(roleID) || "1411".equals(roleID) || "1511".equals(roleID)){
			roleM2=true;
		}
		//���M3���ܡ����M3�鳤�����M3רԱ
		if("1312".equals(roleID) || "1412".equals(roleID) || "1512".equals(roleID)){
			roleM3=true;
		}
		//���������ܡ���߲������鳤��������רԱ
		if("1313".equals(roleID) || "1413".equals(roleID) || "1513".equals(roleID)){
			roleMM=true;
		}
	}
	rs.getStatement().close();
	
	//��ť��ʾ
	ASResultSet rs1=Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("userid", userID));
	while(rs1.next()){
		roleID=rs1.getString("roleid");
		if("1510".equals(roleID)){
			buttonM1="true";
		}
		if("1511".equals(roleID)){
			buttonM2="true";
		}
		if("1512".equals(roleID)){
			buttonM3="true";
		}
		if("1110".equals(roleID) || "1210".equals(roleID) || "1310".equals(roleID) || "1410".equals(roleID)){
			buttonM1="false";
		}
		if("1110".equals(roleID) || "1210".equals(roleID) || "1311".equals(roleID) || "1411".equals(roleID)){
			buttonM2="false";
		}
		if("1110".equals(roleID) || "1210".equals(roleID) || "1312".equals(roleID) || "1412".equals(roleID)){
			buttonM3="false";
		}
	}
	rs1.getStatement().close();
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�绰����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sFolder1=tviTemp.insertFolder("root","�绰������Ϣ","",1);
	if(roleM1){
		tviTemp.insertPage("root","M1����¼��","",1);
	}
	if(roleM2){
		tviTemp.insertPage("root","M2����¼��","",2);
	}
	if(roleM3){
		tviTemp.insertPage("root","M3����¼��","",3);
	}
	if(roleMM){
		tviTemp.insertPage("root","������","",4);
	}
	

	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if(sCurItemname=='M1����¼��'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1=0011&&buttonM1=<%=buttonM1%>&&buttonM2=<%=buttonM2%>&&buttonM3=<%=buttonM3%>","right");
		}else if(sCurItemname=='M2����¼��'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1=0012&&buttonM1=<%=buttonM1%>&&buttonM2=<%=buttonM2%>&&buttonM3=<%=buttonM3%>","right");
		}else if(sCurItemname=='M3����¼��'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1=0013&&buttonM1=<%=buttonM1%>&&buttonM2=<%=buttonM2%>&&buttonM3=<%=buttonM3%>","right");
		}else if(sCurItemname=='������'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionGroupList.jsp","PhaseType1=0060","right");
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
		selectItemByName("M1����¼��");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
