<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
    <%
    /*
        Author:   CYHui  2003.8.18
        Tester:
        Content: �����������̨_Main
        Input Param:
            ApproveType����������
                ��ApproveCreditApply/����ҵ���������
                ��ApproveApprovalApply/���������������  
                ��ApprovePutOutApply/�������븴��
        Output param: 
              
        History Log: 2005.08.03 jbye    �����޸�������������Ϣ
                     2005.08.05 zywei   �ؼ�ҳ��
                   //CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
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
    
    
    /*********���������� ADD CCS-224 20150513 huzp ***********************/
    String sNotice ="",updateNotice="",updateNotice2="",sCompName2 = "",sCompName3 = "",sItemName2 = "",sItemName3 = "";
    /**************end***********************************************/
    /*********���ݵ�¼��Ա��ö�Ӧ�Ľ�ɫȨ�� ADD CCS-225 20150515 huzp ***********************/
    String org= CurUser.getOrgID();
    String flag="";//1:��ʶΪ��˹���Ա��2����ʶΪ���רԱ��3������˲���Ա
    if(org.equals("11")){//������˲���Ա�������һ���ж��Ƿ�Ϊ����ԱȨ��
    	if(CurUser.hasRole("1038")){
    		flag="1";
    	}else{
    		flag="2";
    	}
    }else{
    	flag="3";
    }
    System.out.println("flag=========================="+flag);
    
    /************************************end*************************************/
    
    
    
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
    /* if(!sObjectType.equalsIgnoreCase("CreditApply"))
        sSql += " and FlowNo in "+sTempFlowNo+" "; */
    sSql += " and FlowNo in "+sTempFlowNo+" ";
    
    sSql += " and UserID ='"+CurUser.getUserID()+"' "+
            " and (EndTime is  null or EndTime =' ' or EndTime ='') and PhaseNo <> '0010'"+
            " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
            " Order by FlowNo,PhaseNo ";
    //out.println(sSql);
    rs = Sqlca.getASResultSet(sSql);
    int t=0;//������������ж��Ƿ��ǵ�һ������ */
    String sDisplay="";//���ڴ��sPageShow�õ��ĵ�һ�����ݣ�����ͬ�׶δ���������������ʱ��
    sPageShow  = "��ǰ��������"; 
    /* while (rs.next())
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
    } */
    //����������
    String sFlowCount = "0";
    
    /*   ԭ����SQL
   	sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
    						" and FT.Objectno = BC.Serialno"+
   							" and FT.FlowNo in "+sTempFlowNo+" "+
    						" and (FT.UserID ='"+CurUser.getUserID()+"' or (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null)) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and FT.PhaseNo <> '0010'");
   	*/
   	
   	
    //��ȥ�������������������ѯ  update huzp 20150611
   	if(CurUser.getOrgID().equals("10")){//��ز���¼��ִ��ֻ��ѯ��CEר����˵ĵ���
   		sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
   				" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
   					" and FT.FlowNo in "+sTempFlowNo+" "+
   				" and (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020' and ft.phasename =  'CEר�����'");
   	   	
   	}else if(CurUser.getOrgID().equals("11")){//��˲���¼��ִ��ֻ��ѯ�����רԱ�ĵ���
   		sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
   				" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
   		        " and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='')  "+
   					" and FT.FlowNo in "+sTempFlowNo+" "+
   				" and (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020' and ft.phasename <>  'CEר�����'");
   	   	
   	}else{//�������Ȩ��������ҳ�汨����ѯ�����еĵ���
   		sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
   				" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
   					" and FT.FlowNo in "+sTempFlowNo+" "+
   				" and (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020' ");
   	}
   	
   	
   	sPageShow  = "��ǰ��������"+sFlowCount+"��"; 
   	sDisplay = sPageShow;
   	tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
    //tviTemp.insertPage("root",sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",1);
    
    rs.getStatement().close();

    //4�����õ�ǰ�û����ڸ�����������ɹ����˵���
    sFolderfinished = tviTemp.insertFolder("root","����ɹ���","",i++);
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
    /* while (rs.next())
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
   } */
    
    sFlowCount = "0";
   	sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
    						" and FT.ObjectNo = BC.SerialNo"+
    						" and FT.FlowNo in "+sTempFlowNo+" "+
    						" and FT.UserID ='"+CurUser.getUserID()+"' and FT.EndTime is not null and (FT.EndTime <> ' ' or FT.EndTime <> '') and FT.PhaseNo <> '0010'");
    sPageShow  = "����ɵ�����"+sFlowCount+"��"; 
   	tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);

    rs.getStatement().close();
    /*********���������� ADD CCS-224 20150513 huzp ***********************/
    
    if(flag=="1"){//flag=1��Ϊ����Ա��ݣ���ʾ���淢�������Ĳ˵���������Ϣ��
        //�����������ʹӴ����CODE_LIBRARY�л�������������ơ�����ģ�ͱ�š����̶������͡������š��������
        sSql =  " select ItemName,Attribute8 from CODE_LIBRARY where "+
                " CodeNo = 'Notice' and ItemNo = :ItemNo ";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
        if(rs.next())
        {
             sItemName2 = rs.getString("ItemName");
             sCompName2 = rs.getString("Attribute8");
            
            //����ֵת���ɿ��ַ���
            if(sItemName2 == null) sItemName2 = "";
            if(sCompName2 == null) sCompName2 = "";
            
            //���ô��ڱ���
            PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
        }else
        {
            throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
        }   
        
        
        //���õ�ǰ�û��������˵���
        sNotice = tviTemp.insertFolder("root","������","",i++);
        updateNotice="���¹�����";
        sPageShow=updateNotice;
        tviTemp.insertPage(sNotice,updateNotice,"javascript:parent.openNotice(\""+ sApproveType +"\")",iLeaf++);
        rs.getStatement().close();
        /**************end***********************************************/
        
        sSql =  " select ItemName,Attribute8 from CODE_LIBRARY where "+
                " CodeNo = 'ReadNotice' and ItemNo = :ItemNo ";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
        if(rs.next())
        {
             sItemName3 = rs.getString("ItemName");
             sCompName3 = rs.getString("Attribute8");
            
            //����ֵת���ɿ��ַ���
            if(sItemName3 == null) sItemName3 = "";
            if(sCompName3 == null) sCompName3 = "";
            
            //���ô��ڱ���
            PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
        }else
        {
            throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
        }   
        
        
        //���õ�ǰ�û��������˵���
        updateNotice2="���Ĺ���";
        sPageShow=updateNotice2;
        tviTemp.insertPage(sNotice,updateNotice2,"javascript:parent.openReadNotice(\""+ sApproveType +"\")",iLeaf++);
        rs.getStatement().close();
        /**************end***********************************************/
    }else if(flag=="2"){//��˲��ǹ���Ա����ʾ���Ĳ˵��������������
    	 sSql =  " select ItemName,Attribute8 from CODE_LIBRARY where "+
                 " CodeNo = 'ReadNotice' and ItemNo = :ItemNo ";
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
         if(rs.next())
         {
              sItemName2 = rs.getString("ItemName");
              sCompName2 = rs.getString("Attribute8");
             
             //����ֵת���ɿ��ַ���
             if(sItemName2 == null) sItemName2 = "";
             if(sCompName2 == null) sCompName2 = "";
             
             //���ô��ڱ���
             PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
         }else
         {
             throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
         }   
         
         
         //���õ�ǰ�û��������˵���
         sNotice = tviTemp.insertFolder("root","������","",i++);
         updateNotice="���Ĺ���";
         sPageShow=updateNotice;
         tviTemp.insertPage(sNotice,updateNotice,"javascript:parent.openNotice(\""+ sApproveType +"\")",iLeaf++);
         rs.getStatement().close();
         /**************end***********************************************/
         
    }
   
//��@�滻�ַ����еĶ���
    String TempFlowNoString = sTempFlowNo.replace(",", "@");

    %>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
    <script type="text/javascript"> 
    
    /*********���������� ADD CCS-224 20150513 huzp ***********************/
    function openNotice(sApproveType)
    {
        //�򿪶�Ӧ�Ĺ������
        AsControl.OpenComp("<%=sCompName2%>","ApproveType="+sApproveType,"right","");
    }
    //CCS-913 Ȩ�޵��޸ġ���˲�����Ա���ܷ��������ܵ���Ļ���������Ĺ���
    function openReadNotice(sApproveType)
    {
        //�򿪶�Ӧ�Ĺ������
        AsControl.OpenComp("<%=sCompName3%>","ApproveType="+sApproveType,"right","");
    }
    /**************end***********************************************/
    
    /******************add CSS-225���Ա��ݽ��뵯��������ҳ��   20150515 huzp***/
	//�����ҳ��,Ȩ��Ϊ���Աʱ����������
	function UpNotice(){//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		AsControl.PopView("/Common/WorkFlow/UpNoticeList.jsp", "identtype=01", "dialogWidth=850px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*********************end***************************************/
	
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
	//��ȡ��������ͼ�Ľڵ�ID
	var id=getNodeIDByName('<%=sDisplay%>');
	//�ҵ��ڵ㣬�ڽڵ���2������һ����ʾ������
    function ReloadSelf(){
    	var ObjectType = "<%=sObjectType%>";
		var TempFlowNo = "<%=TempFlowNoString%>";
		var UserId = "<%=CurUser.getUserID()%>";
		var orgId="<%=CurUser.getOrgID()%>";
    	var name = RunJavaMethodSqlca("com.amarsoft.app.als.flow.cfg.web.selectNewContract" ,"selectNewContractString" ,"ObjectType="+ObjectType+",TempFlowNo="+TempFlowNo+",UserId="+UserId+",orgId="+orgId);//��ȡ��ǰ�������
    	setItemName(id, name);//ͨ���ڵ�ID���õ�ǰҳ�����ʾ����
   			 		
    }
    function ReloadNotice(){
    	<%/*~begin�жϵ�¼���flagΪ2���ǹ���Աֻ��ʾ�˵��������淴ֻ֮�����治��ʾ�˵�add CSS-225���Ա��ݽ��뵯��������ҳ��   20150519 huzp~~���������jira�г���flag=2���ж�*/%>
 	    <%/*~begin�жϵ�¼���orgΪ11������˲������� add CSS-913���Ա��ݽ��뵯��������ҳ��   20150701 huzp~*/%>
 	    if(<%=org%>=='11'){
 	    	var UserId = "<%=CurUser.getUserID()%>";
 	    	//�����¹����򵯳����棬���򲻵�������
 	    	//add by byang CCS-1252	���Ʋ鿴���Ĺ�����Ϊ�����ŵķ����Ĺ���
 	    	var userOrg = "<%=CurUser.getOrgID()%>";
 	    	var count= RunMethod("Unique","uniques","notice_info,count(1),noticeid not in (select t.noticeid  from USER_NOTICE t  where t.isflag = '1' and t.UserID = '"+UserId+"') and InputOrg='"+userOrg+"'");
 	    	if(count>0){
 	    		UpNotice();
 	    	}
 	    }
 	    <%/*~end~*/%>
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
	    ReloadNotice();
	    //�涨��ʱ�����ڵ���ĳ��JS����(�˷��������ݿ�Ч��Ӱ��̫�����Բ�������,�����������Խ⿪ע��)
		   /*  setInterval(function () {
		    	ReloadSelf();
	        }, 60000); */
	        
	    //�涨��ʱ�����ڵ���ĳ��JS����(���ô˷��������ʵʱ�����ع���CCS-225��CCS-913)
	    // �˷���ȡ����ʱ��⣬��Ϊ��¼ʱ����һ�Σ�֮��������ȡ���񡱲Żᵯ����  CCS-1197�������Ա�������ȡ���񡱰�ť������˲����棩
	    //setInterval(function () {
	    //	ReloadNotice();
        //}, 60000);
	        
	        
    }catch(e){}
    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
