<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content:��ȷ�����������
		Input Param:
			LineID����ȷ�����
		Output param:
			
		History Log: 
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ����������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ŷ����������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sSubLineID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubLineID"));
	if(sSubLineID == null) sSubLineID = "";
	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���Ŷ��������������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	int iOrder = 1;	
	String sFolder = tviTemp.insertFolder("root","��������","",iOrder++);	
	String sSql = " select CLS.LimitationSetID,CLS.LimitationType,CLT.TypeName,CLS.ObjectType "+
				  " from CL_LIMITATION_SET CLS,CL_LIMITATION_TYPE CLT "+
				  " where CLS.LimitationType = CLT.TypeID "+
				  " and CLS.LineID =:CLS.LineID ";
	String[][] sLimitationSets = Sqlca.getStringMatrix(new SqlObject(sSql).setParameter("CLS.LineID",sSubLineID));
	for(int i=0;i<sLimitationSets.length;i++){
		tviTemp.insertPage(sFolder,sLimitationSets[i][2],sLimitationSets[i][0],"javascript:parent.openLimitationSet('"+sLimitationSets[i][0]+"')",iOrder++);
	}

	tviTemp.insertPage(sFolder," [���һ����������]","javascript:parent.addLimitationSet()",iOrder++);
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	
	//treeview����ѡ���¼�	
	function TreeViewOnClick()
	{		
		setTitle(getCurTVItem().name);
	}
	
	function addLimitationSet()
	{
		//��ȡ��������
		sReturn = setObjectValue("SelectLimitationType","","",0,0,"");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sLimitationType = sReturn[0];
		
		//�����ݿ�������һ��������
		var sLimitationSetID = getSerialNo("CL_LIMITATION_SET","LimitationSetID","");
		var sReturn = RunMethod("CreditLine","NewLimitaionSet","<%=sSubLineID%>,"+sLimitationSetID+","+sLimitationType);
		reloadSelf();
	}
	
	function openLimitationSet(sLimitationSetID){
		
		OpenPage("/CreditManage/CreditLine/LimitationSetInfo.jsp?SubLineID=<%=sSubLineID%>&LimitationSetID="+sLimitationSetID,"right","");
	}
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	expandNode('<%=sFolder%>');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
