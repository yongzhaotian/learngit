<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   jli5
        Tester:
        Content: ������������̨
        Input Param:
            ApproveType����������
                ��CarApprove    ������������
               
        Output param: 
              
     */
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;δ����ģ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
    String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
    String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
    <%
    //�����������ѯ�����
    ASResultSet rs = null;
    //���������SQL��䡢��ǰ����������ɹ���
    String sSql = "",sFolderUnfinished = "",sFolderfinished = "";
    //����������׶α�š��׶����ơ�����������������ʾ��ǩ���ļ��б��
    String sPhaseNo = "",sPhaseName = "",sWorkCount = "",sPageShow = "",sFolderSign= "" ;
    //������������̱�š��׶����͡������š��������
    String sFlowNo = "",sPhaseType = "",sCompID = "",sCompName = "";
    //��������������������ơ����̶�������
    String sItemName = "",sObjectType = "";
    //������������Ͳ˵�ҳ��
    int iLeaf = 1,i = 0;
    
    //��������������������
    String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));

    //����ֵת���ɿ��ַ���
    if(sObjectType == null) sObjectType = "";
    %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
    <%  
        
    //�����������ʹӴ����CODE_LIBRARY�л�������������ơ�����ģ�ͱ�š����̶������͡������š��������
    sSql =  " select ItemName,Attribute2,ItemAttribute,Attribute7,Attribute8 from CODE_LIBRARY where "+
            " CodeNo = 'ApproveType' and ItemNo = :ItemNo ";
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
    if(rs.next())
    {
        sItemName = rs.getString("ItemName");
        sFlowNo = rs.getString("Attribute2");
        sObjectType = rs.getString("ItemAttribute");
        sCompID = rs.getString("Attribute7");
        sCompName = rs.getString("Attribute8");
        
        //����ֵת���ɿ��ַ���
        if(sItemName == null) sItemName = "";
        if(sFlowNo == null) sFlowNo = "";
        if(sObjectType == null) sObjectType = "";
        if(sCompID == null) sCompID = "";
        if(sCompName == null) sCompName = "";
        
        //���ô��ڱ���
        PG_TITLE = sItemName;
        PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
    }else
    {
        throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
    }   
    rs.getStatement().close();

    //��FlowNo�𿪣�Ϊ�˼��ϵ�����
    String sTempFlowNo = "(";
    StringTokenizer st = new StringTokenizer(sFlowNo,",");
    while(st.hasMoreTokens())
    {
        sTempFlowNo += "'"+ st.nextToken()+"',";
    }

    if(!sTempFlowNo.equals(""))
    {
        sTempFlowNo = sTempFlowNo.substring(0,sTempFlowNo.length()-1)+")";
    }
    
    //out.println(sTempFlowNo);
    HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,PG_TITLE,"right");
    tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��

    //���õ�ǰ�û����ڸ������ĵ�ǰ�����˵���
    sFolderUnfinished = tviTemp.insertFolder("root","������","",i++);
    //�����������FLOW_TASK�в�ѯ����ǰ�û��Ĵ��������������Ϣ
    sSql =  " select FlowNo,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
            " from FLOW_TASK "+
            " where ObjectType = '"+sObjectType+"' ";
    /* if(!sObjectType.equalsIgnoreCase("CreditApply"))
        sSql += " and FlowNo in "+sTempFlowNo+" "; */
    sSql += " and FlowNo in "+sTempFlowNo+" ";
    
    sSql += " and UserID ='"+CurUser.getUserID()+"' "+
            " and (EndTime is  null or EndTime =' ' or EndTime ='') and PhaseNo <> '0010'"+
            " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
            " Order by FlowNo,PhaseNo ";
    //out.println(sSql);
    rs = Sqlca.getASResultSet(sSql);
    int t=0;//������������ж��Ƿ��ǵ�һ������
    String sDisplay="";//���ڴ��sPageShow�õ��ĵ�һ�����ݣ�����ͬ�׶δ���������������ʱ��
    sPageShow  = "��ǰ��������"; 
    while (rs.next())
    {   
        sFlowNo  =   DataConvert.toString(rs.getString("FlowNo"));           
        sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
        sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  
        sPhaseName = DataConvert.toString(rs.getString("PhaseName")); 
        sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
         
        //����ֵת���ɿ��ַ���        
        if(sPhaseType == null) sPhaseType = ""; 
        if(sPhaseNo == null) sPhaseNo = "";         
        if(sPhaseName == null) sPhaseName = ""; 
        if(sWorkCount == null) sWorkCount = "";
        
        if(sWorkCount.equals(""))
            sPageShow  = sPhaseName+"("+sFlowNo+")  0 ��"; 
        else
            sPageShow  = sPhaseName+"("+sFlowNo+")  "+sWorkCount+" ��"; 
        
        //���sPageShow��һ������
		if(t==0){
			sDisplay = sPageShow;
			t++;
		}
		tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
    }
    //tviTemp.insertPage("root",sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",1);
    
    rs.getStatement().close();

    //4�����õ�ǰ�û����ڸ�����������ɹ����˵���
    sFolderfinished = tviTemp.insertFolder("root","�Ѵ���","",i++);
    sSql =  " select FlowNo,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
            " from FLOW_TASK "+
            " where ObjectType = '"+sObjectType+"' ";
    /* if(!sObjectType.equalsIgnoreCase("CreditApply"))
        sSql += " and FlowNo in "+sTempFlowNo+" "; */
    sSql += " and FlowNo in "+sTempFlowNo+" ";
    sSql += " and UserID = '"+CurUser.getUserID()+"' "+
            " and EndTime is not null "+    
            " and (EndTime <> ' ' or EndTime <> '') and PhaseNo <> '0010'"+   
            " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
            " Order by FlowNo,PhaseNo ";
    
    rs = Sqlca.getASResultSet(sSql);
    while (rs.next())
    {        
        sFlowNo  =   DataConvert.toString(rs.getString("FlowNo"));
        sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
        sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));         
        sPhaseName = DataConvert.toString(rs.getString("PhaseName"));  
        sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
         
        //����ֵת���ɿ��ַ���        
        if(sPhaseType == null) sPhaseType = ""; 
        if(sPhaseNo == null) sPhaseNo = "";         
        if(sPhaseName == null) sPhaseName = ""; 
        if(sWorkCount == null) sWorkCount = "";
        
        if(sWorkCount.equals(""))
            sPageShow  = sPhaseName+"("+sFlowNo+")"+" 0 ��"; 
        else
            sPageShow  = sPhaseName+"("+sFlowNo+") "+sWorkCount+" ��"; 
        
        tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
   }
    
    //sPageShow  = "����ɵ�����"; 
    //tviTemp.insertPage("root",sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);

    rs.getStatement().close();

    %>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
    <script type="text/javascript"> 
    
    /*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
    function openPhase(sApproveType,sPhaseType,sFlowNo,sPhaseNo,sFinishFlag)
    {
        //�򿪶�Ӧ����������
        AsControl.OpenComp("<%=sCompName%>","ApproveType="+sApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&FinishFlag="+sFinishFlag,"right","");
        //setTitle(getCurTVItem().name);
    }
        
    /*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
    function startMenu() 
    {
        <%=tviTemp.generateHTMLTreeView()%>;
    }
    
    </script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
    <script type="text/javascript">
    try{
	    startMenu();
	    expandNode('root');
	    expandNode('<%=sFolderUnfinished%>');
	    selectItemByName('<%=sDisplay%>');
    }catch(e){}
    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
