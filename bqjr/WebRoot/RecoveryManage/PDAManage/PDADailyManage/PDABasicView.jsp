<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: ��ծ�ʲ���������PDABasicView.jsp
		Input Param:
				ObjectNo����ծ�ʲ���ˮ��				
		Output param:
		            
		History Log: 
		              
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ծ�ʲ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
		//�������
		String  sSerialNo = "";//�ʲ���ˮ��		
		String  sObjectType = "AssetInfo";
		String  sAssetType = "10";//����
		String  sFlag = "010";//����.
		String  sAssetStatus = "02";//01/02:δ�������;03/04:�ѵ���/���������.�����ܹ���������̨��.

		//����������
		sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		if (sSerialNo == null)  sSerialNo = "";
		
		String sSql = "";
		ASResultSet rsTemp = null;
		//���ݵ�ծ�ʲ���ˮ�Ż�ȡ�ʲ�����AssetType/AssetStatus/sFlag
		sSql = " select AssetType,AssetStatus,Flag from ASSET_INFO where SerialNo = :SerialNo ";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
		if (rsTemp.next()){
			sAssetType  = DataConvert.toString(rsTemp.getString("AssetType"));
			if (sAssetType == null) sAssetType = "10"; 
			sAssetStatus  = DataConvert.toString(rsTemp.getString("AssetStatus"));
			if (sAssetStatus == null) sAssetStatus = "02"; //������
			sFlag  = DataConvert.toString(rsTemp.getString("Flag"));
			if (sFlag == null) sFlag = "010"; 
		}
		rsTemp.getStatement().close();		
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ծ�ʲ����������б�","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent = true; //�Ƿ��Զ�����ѡ���¼�


	//������ͼ�ṹ:����sEnterPath�Ĳ�ͬ,�����Ƿ���ʾ����̨��.
	String sSqlTreeView  = "";
	if((sAssetStatus.equals("02")) || (sAssetStatus.equals("01")))  //δ����/����׼�����,����ʾ����̨��,������Ҳһ��.
	{
		sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList'  and ItemNo in ('01','02','03','06','08','19')";
	}else  //"03/04":��ʾ������Ŀ,���Ǳ䶯����б�������ʾ���ƵĲ�ͬ.
	{	//���ѵ����ʲ���,���ݵ������/����Ĳ�ͬ,���䶯̨�ʵ���ʾ����Ҳ��ͬ,���ǵ���ͬһ��ҳ��		
		if (sFlag.equals("010"))  //�������
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'18' ";
		}else  //�������
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'16' ";
		}
	}

	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	function OpenChildComp(sCompID,sURL,sParameterString)
	{
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}	

	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //����������ֶ�����@�ָ��ĵ�1����
		sCurItemDescribe2=sCurItemDescribe[1]; //����������ֶ�����@�ָ��ĵ�2����
		sCurItemDescribe3=sCurItemDescribe[2]; //����������ֶ�����@�ָ��ĵ�3��������������������Ժܶࡣ
		//����
		if (sCurItemDescribe2=="goBack") 
		{
			self.close();
		}else if (sCurItemDescribe2=="PDABasicInfo") //������Ϣ
		{
			var sSerialNo="<%=sSerialNo%>";
			var sAssetType="<%=sAssetType%>";			
			var sObjectType="<%=sObjectType%>";
			var sAssetStatus="<%=sAssetStatus%>";
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetType="+sAssetType+"&ObjectType="+sObjectType+"&AssetStatus="+sAssetStatus);		
			setTitle(sCurItemName);
		}else if (sCurItemDescribe2=="PDARelativeContractList") //��غ�ͬ��Ϣ
		{
			var sSerialNo="<%=sSerialNo%>";
			var sAssetStatus="<%=sAssetStatus%>";
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetStatus="+sAssetStatus);
			setTitle(sCurItemName);
		}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			var sSerialNo="<%=sSerialNo%>"; //�ʲ����
			var sObjectType="<%=sObjectType%>";//AssetInfo	
			var sAssetStatus="<%=sAssetStatus%>";
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&AssetStatus="+sAssetStatus);
			if (sCurItemDescribe2=="PDABalanceChangeList")
				setTitle(sCurItemName+"(***�����ݴӻ��ϵͳ��ȡ***)")
			else
				setTitle(sCurItemName);
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
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
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>