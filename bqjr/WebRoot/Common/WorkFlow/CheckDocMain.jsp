<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
    <%
    /*
		Author:  xswang 2015/05/25
		Tester:
		Content: �ļ�������鵱ǰ��������/���������
		Input Param:
		Output param:
		History Log: 
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
    sFolderUnfinished = tviTemp.insertFolder("root","��ǰ����","",i++);
    //�����������FLOW_TASK�в�ѯ����ǰ�û��Ĵ��������������Ϣ
    sSql =  " select FlowNo,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
            " from FLOW_TASK "+
            " where ObjectType = '"+sObjectType+"' ";
    sSql += " and FlowNo in "+sTempFlowNo+" ";
    
    sSql += " and UserID ='"+CurUser.getUserID()+"' "+
            " and (EndTime is  null or EndTime =' ' or EndTime ='') and PhaseNo <> '0010'"+
            " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
            " Order by FlowNo,PhaseNo ";
    rs = Sqlca.getASResultSet(sSql);
    int t=0;//������������ж��Ƿ��ǵ�һ������ */
    String sDisplay="";//���ڴ��sPageShow�õ��ĵ�һ�����ݣ�����ͬ�׶δ���������������ʱ��
    sPageShow  = "��ǰ��������"; 
    //����������
    String sFlowCount = "0";
   	/* sFlowCount =Sqlca.getString(" select count(1) from business_contract bc "+
   			  			" where 1=1 and fo.objectno = bc.serialno and bc.suretype = 'APP' and (bc.contractstatus='080' or bc.contractstatus='020' or bc.contractstatus='050') "+
   			  			" and bc.subproducttype ='0' "+
   			  			" and (bc.CheckDocStatus ='1' or bc.CheckDocStatus ='6' "+
   			  			" ) "); */
	sFlowCount =Sqlca.getString(" select count(1) from business_contract bc,check_contract cc "+
	  			" where bc.serialno=cc.contractserialno and (bc.contractstatus='160' or bc.contractstatus='050') "+
	  			" and (cc.CheckDocStatus ='1' or cc.CheckDocStatus ='6' "+
	  			" ) ");
   	sPageShow  = "��ǰ��������"+sFlowCount+"��"; 
   	sDisplay = sPageShow;
   	tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
    
    rs.getStatement().close();

    //4�����õ�ǰ�û����ڸ�����������ɹ����˵���
    sFolderfinished = tviTemp.insertFolder("root","����ɹ���","",i++);
    sSql =  " select FlowNo,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
            " from FLOW_TASK "+
            " where ObjectType = '"+sObjectType+"' ";
    sSql += " and FlowNo in "+sTempFlowNo+" ";
    sSql += " and UserID = '"+CurUser.getUserID()+"' "+
            " and EndTime is not null "+    
            " and (EndTime <> ' ' or EndTime <> '') and PhaseNo <> '0010'"+   
            " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
            " Order by FlowNo,PhaseNo ";
    
    rs = Sqlca.getASResultSet(sSql);
    sFlowCount = "0";
   	/* sFlowCount = Sqlca.getString(" select count(1) from business_contract bc, flow_object fo "+
    		   			  			" where 1=1 and fo.objectno = bc.serialno and bc.suretype = 'APP' "+
    		   			  			" and (bc.CheckDocStatus ='3' or bc.CheckDocStatus ='5')"+
    		   			  			" and (bc.contractstatus='080' or bc.contractstatus='020' or bc.contractstatus='050') "+
    		   			  			" and (fo.gettaskuserid1 ='"+CurUser.getUserID()+"' or fo.gettaskuserid2 ='"+CurUser.getUserID()+"') "); */
   	String sFinishSql = " select count(1) from business_contract bc,check_contract cc "+
	  			" where bc.serialno=cc.contractserialno "+
	  			" and (cc.CheckDocStatus in ('3','4','5'))"+
				" and (bc.contractstatus='160' or bc.contractstatus='050') ";
  	//����ԱȨ�޿�����ʾ�����û�����ɵļ�¼
	if(!CurUser.hasRole("2040")){
		sFinishSql += " and (cc.gettaskuserid1 ='"+CurUser.getUserID()+"' or cc.gettaskuserid2 ='"+CurUser.getUserID()+"') ";	   			  				
   	}
   	sFlowCount = Sqlca.getString(sFinishSql);
    sPageShow  = "����ɵ�����"+sFlowCount+"��"; 
   	tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
    rs.getStatement().close();
//��@�滻�ַ����еĶ���
    String TempFlowNoString = sTempFlowNo.replace(",", "@");

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
        AsControl.OpenComp("<%=sCompName%>","ApproveType="+sApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&FinishFlag="+sFinishFlag,"right","");
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
    	var sFlowCount = "<%=sFlowCount%>";
	    startMenu();
	    expandNode('root');
	    selectItem('<%=sPageShow%>');
	    expandNode('<%=sFolderUnfinished%>');
	    selectItemByName('<%=sDisplay%>');
	    //�涨��ʱ�����ڵ���ĳ��JS����
	    setInterval(function () {
	    	reloadSelf();
        }, 300000);
    }catch(e){}
    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
