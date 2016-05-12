<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
    <%
    /*
        Author:   CYHui  2003.8.18
        Tester:
        Content: 审查审批工作台_Main
        Input Param:
            ApproveType：审批类型
                —ApproveCreditApply/授信业务审查审批
                —ApproveApprovalApply/最终审批意见复核  
                —ApprovePutOutApply/出帐申请复核
        Output param: 
              
        History Log: 2005.08.03 jbye    重新修改流程审查相关信息
                     2005.08.05 zywei   重检页面
                   //CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
     */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;未命名模块&nbsp;&nbsp;"; //默认的内容区标题
    String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
    String PG_LEFT_WIDTH = "200";//默认的treeview宽度
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
    <%
    //定义变量：查询结果集
    ASResultSet rs = null;
    //定义变量：SQL语句、当前工作、已完成工作
    String sSql = "",sFolderUnfinished = "",sFolderfinished = "";
    
    
    /*********新增公告栏 ADD CCS-224 20150513 huzp ***********************/
    String sNotice ="",updateNotice="",updateNotice2="",sCompName2 = "",sCompName3 = "",sItemName2 = "",sItemName3 = "";
    /**************end***********************************************/
    /*********根据登录人员获得对应的角色权限 ADD CCS-225 20150515 huzp ***********************/
    String org= CurUser.getOrgID();
    String flag="";//1:标识为审核管理员。2：标识为审核专员。3：非审核部人员
    if(org.equals("11")){//若是审核部人员则进行下一步判断是否为管理员权限
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
    
    
    
    //定义变量：阶段编号、阶段名称、工作数、工作数显示标签、文件夹标记
    String sPhaseNo = "",sPhaseName = "",sWorkCount = "",sPageShow = "",sFolderSign= "" ;
    //定义变量：流程编号、阶段类型、组件编号、组件名称
    String sFlowNo = "",sPhaseType = "",sCompID = "",sCompName = "";
    //定义变量：审批类型名称、流程对象类型
    String sItemName = "",sObjectType = "";
    //定义变量：树型菜单页数
    int iLeaf = 1,i = 0;
    
    //获得组件参数：审批类型
    String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));

    //将空值转换成空字符串
    if(sObjectType == null) sObjectType = "";
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
    <%  
        
    //根据申请类型从代码表CODE_LIBRARY中获得审批类型名称、审批模型编号、流程对象类型、组件编号、组件名称
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
        
        //将空值转换成空字符串
        if(sItemName == null) sItemName = "";
        if(sFlowNo == null) sFlowNo = "";
        if(sObjectType == null) sObjectType = "";
        if(sCompID == null) sCompID = "";
        if(sCompName == null) sCompName = "";
        
        //设置窗口标题
        PG_TITLE = sItemName;
        PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
    }else
    {
        throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
    }   
    rs.getStatement().close();

    //把FlowNo拆开，为了加上单引号
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
    tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）

    //设置当前用户对于该类对象的当前工作菜单项
    sFolderUnfinished = tviTemp.insertFolder("root","当前工作","",i++);
    //从流程任务表FLOW_TASK中查询出当前用户的待审查审批工作信息
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
    int t=0;//定义变量用于判断是否是第一条数据 */
    String sDisplay="";//用于存放sPageShow拿到的第一条数据（当相同阶段存在两个或多个流程时）
    sPageShow  = "当前待办任务"; 
    /* while (rs.next())
    {   
        sFlowNo  =   DataConvert.toString(rs.getString("FlowNo"));           
        sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
        sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  
        sPhaseName = DataConvert.toString(rs.getString("PhaseName")); 
        sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
         
        //将空值转换成空字符串        
        if(sPhaseType == null) sPhaseType = ""; 
        if(sPhaseNo == null) sPhaseNo = "";         
        if(sPhaseName == null) sPhaseName = ""; 
        if(sWorkCount == null) sWorkCount = "";
        
        if(sWorkCount.equals(""))
            sPageShow  = sPhaseName+"("+sFlowNo+")  0 件"; 
        else
            sPageShow  = sPhaseName+"("+sFlowNo+")  "+sWorkCount+" 件"; 
        
        //获得sPageShow第一条数据
		if(t==0){
			sDisplay = sPageShow;
			t++;
		}
		tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
    } */
    //待处理任务
    String sFlowCount = "0";
    
    /*   原来的SQL
   	sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
    						" and FT.Objectno = BC.Serialno"+
   							" and FT.FlowNo in "+sTempFlowNo+" "+
    						" and (FT.UserID ='"+CurUser.getUserID()+"' or (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null)) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and FT.PhaseNo <> '0010'");
   	*/
   	
   	
    //除去自身或者任务后的条件查询  update huzp 20150611
   	if(CurUser.getOrgID().equals("10")){//风控部登录后执行只查询出CE专家审核的单量
   		sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
   				" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
   					" and FT.FlowNo in "+sTempFlowNo+" "+
   				" and (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020' and ft.phasename =  'CE专家审核'");
   	   	
   	}else if(CurUser.getOrgID().equals("11")){//审核部登录后执行只查询出审核专员的单量
   		sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
   				" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
   		        " and (ft.taskstate <>'2' or ft.taskstate is null  or ft.taskstate=' ' or ft.taskstate='')  "+
   					" and FT.FlowNo in "+sTempFlowNo+" "+
   				" and (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020' and ft.phasename <>  'CE专家审核'");
   	   	
   	}else{//否则避免权限配错造成页面报错。查询出所有的单量
   		sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
   				" and FT.Objectno = BC.Serialno and (BC.cancelstatus <> '1' or BC.cancelstatus is null or BC.cancelstatus=' ' or BC.cancelstatus='')"+
   					" and FT.FlowNo in "+sTempFlowNo+" "+
   				" and (FT.GroupInfo like '%"+CurUser.getUserID()+"%' and FT.UserID is null) and (FT.EndTime is  null or FT.EndTime =' ' or FT.EndTime ='') and ft.phasetype ='1020' ");
   	}
   	
   	
   	sPageShow  = "当前待办任务"+sFlowCount+"件"; 
   	sDisplay = sPageShow;
   	tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
    //tviTemp.insertPage("root",sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",1);
    
    rs.getStatement().close();

    //4、设置当前用户对于该类对象的已完成工作菜单项
    sFolderfinished = tviTemp.insertFolder("root","已完成工作","",i++);
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
         
        //将空值转换成空字符串        
        if(sPhaseType == null) sPhaseType = ""; 
        if(sPhaseNo == null) sPhaseNo = "";         
        if(sPhaseName == null) sPhaseName = ""; 
        if(sWorkCount == null) sWorkCount = "";
        
        if(sWorkCount.equals(""))
            sPageShow  = sPhaseName+"("+sFlowNo+")"+" 0 件"; 
        else
            sPageShow  = sPhaseName+"("+sFlowNo+") "+sWorkCount+" 件"; 
        
        tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
   } */
    
    sFlowCount = "0";
   	sFlowCount = Sqlca.getString("select count(1) as sCount from FLOW_TASK FT,BUSINESS_CONTRACT BC where FT.ObjectType = '"+sObjectType+"' "+
    						" and FT.ObjectNo = BC.SerialNo"+
    						" and FT.FlowNo in "+sTempFlowNo+" "+
    						" and FT.UserID ='"+CurUser.getUserID()+"' and FT.EndTime is not null and (FT.EndTime <> ' ' or FT.EndTime <> '') and FT.PhaseNo <> '0010'");
    sPageShow  = "已完成的任务"+sFlowCount+"件"; 
   	tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);

    rs.getStatement().close();
    /*********新增公告栏 ADD CCS-224 20150513 huzp ***********************/
    
    if(flag=="1"){//flag=1则为管理员身份，显示公告发布，已阅菜单，弹出信息栏
        //根据申请类型从代码表CODE_LIBRARY中获得审批类型名称、审批模型编号、流程对象类型、组件编号、组件名称
        sSql =  " select ItemName,Attribute8 from CODE_LIBRARY where "+
                " CodeNo = 'Notice' and ItemNo = :ItemNo ";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
        if(rs.next())
        {
             sItemName2 = rs.getString("ItemName");
             sCompName2 = rs.getString("Attribute8");
            
            //将空值转换成空字符串
            if(sItemName2 == null) sItemName2 = "";
            if(sCompName2 == null) sCompName2 = "";
            
            //设置窗口标题
            PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
        }else
        {
            throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
        }   
        
        
        //设置当前用户公告栏菜单项
        sNotice = tviTemp.insertFolder("root","公告栏","",i++);
        updateNotice="更新公告栏";
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
            
            //将空值转换成空字符串
            if(sItemName3 == null) sItemName3 = "";
            if(sCompName3 == null) sCompName3 = "";
            
            //设置窗口标题
            PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
        }else
        {
            throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
        }   
        
        
        //设置当前用户公告栏菜单项
        updateNotice2="已阅公告";
        sPageShow=updateNotice2;
        tviTemp.insertPage(sNotice,updateNotice2,"javascript:parent.openReadNotice(\""+ sApproveType +"\")",iLeaf++);
        rs.getStatement().close();
        /**************end***********************************************/
    }else if(flag=="2"){//审核部非管理员，显示已阅菜单，弹出公告界面
    	 sSql =  " select ItemName,Attribute8 from CODE_LIBRARY where "+
                 " CodeNo = 'ReadNotice' and ItemNo = :ItemNo ";
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
         if(rs.next())
         {
              sItemName2 = rs.getString("ItemName");
              sCompName2 = rs.getString("Attribute8");
             
             //将空值转换成空字符串
             if(sItemName2 == null) sItemName2 = "";
             if(sCompName2 == null) sCompName2 = "";
             
             //设置窗口标题
             PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
         }else
         {
             throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
         }   
         
         
         //设置当前用户公告栏菜单项
         sNotice = tviTemp.insertFolder("root","公告栏","",i++);
         updateNotice="已阅公告";
         sPageShow=updateNotice;
         tviTemp.insertPage(sNotice,updateNotice,"javascript:parent.openNotice(\""+ sApproveType +"\")",iLeaf++);
         rs.getStatement().close();
         /**************end***********************************************/
         
    }
   
//用@替换字符串中的逗号
    String TempFlowNoString = sTempFlowNo.replace(",", "@");

    %>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
    <script type="text/javascript"> 
    
    /*********新增公告栏 ADD CCS-224 20150513 huzp ***********************/
    function openNotice(sApproveType)
    {
        //打开对应的公告界面
        AsControl.OpenComp("<%=sCompName2%>","ApproveType="+sApproveType,"right","");
    }
    //CCS-913 权限的修改。审核部管理员既能发公告又能弹屏幕，还能已阅公告
    function openReadNotice(sApproveType)
    {
        //打开对应的公告界面
        AsControl.OpenComp("<%=sCompName3%>","ApproveType="+sApproveType,"right","");
    }
    /**************end***********************************************/
    
    /******************add CSS-225审核员身份进入弹出公告栏页面   20150515 huzp***/
	//进入此页面,权限为审核员时弹出公告栏
	function UpNotice(){//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		AsControl.PopView("/Common/WorkFlow/UpNoticeList.jsp", "identtype=01", "dialogWidth=850px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*********************end***************************************/
	
    function openPhase(sApproveType,sPhaseType,sFlowNo,sPhaseNo,sFinishFlag)
    {
        //打开对应的审批界面
        AsControl.OpenComp("<%=sCompName%>","ApproveType="+sApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&FinishFlag="+sFinishFlag,"right","");
        //setTitle(getCurTVItem().name);
    }
        
    /*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
    function startMenu() 
    {
        <%=tviTemp.generateHTMLTreeView()%>;
    }
	//获取待处理树图的节点ID
	var id=getNodeIDByName('<%=sDisplay%>');
	//找到节点，在节点上2秒设置一个显示的名字
    function ReloadSelf(){
    	var ObjectType = "<%=sObjectType%>";
		var TempFlowNo = "<%=TempFlowNoString%>";
		var UserId = "<%=CurUser.getUserID()%>";
		var orgId="<%=CurUser.getOrgID()%>";
    	var name = RunJavaMethodSqlca("com.amarsoft.app.als.flow.cfg.web.selectNewContract" ,"selectNewContractString" ,"ObjectType="+ObjectType+",TempFlowNo="+TempFlowNo+",UserId="+UserId+",orgId="+orgId);//获取当前任务件数
    	setItemName(id, name);//通过节点ID设置当前页面的显示名称
   			 		
    }
    function ReloadNotice(){
    	<%/*~begin判断登录身份flag为2则是管理员只显示菜单不弹界面反之只弹界面不显示菜单add CSS-225审核员身份进入弹出公告栏页面   20150519 huzp~~已在下面的jira中撤了flag=2的判断*/%>
 	    <%/*~begin判断登录身份org为11则是审核部都弹屏 add CSS-913审核员身份进入弹出公告栏页面   20150701 huzp~*/%>
 	    if(<%=org%>=='11'){
 	    	var UserId = "<%=CurUser.getUserID()%>";
 	    	//若有新公告则弹出界面，否则不弹出界面
 	    	//add by byang CCS-1252	控制查看已阅公告栏为本部门的发出的公告
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


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
    <script type="text/javascript">
    try{
    	var sFlowCount = "<%=sFlowCount%>";
	    startMenu();
	    expandNode('root');
	    selectItem('<%=sPageShow%>');
	    expandNode('<%=sFolderUnfinished%>');
	    selectItemByName('<%=sDisplay%>');
	    ReloadNotice();
	    //规定的时间间隔内调用某个JS方法(此方法对数据库效率影响太大，所以不上生产,如后期需求可以解开注释)
		   /*  setInterval(function () {
		    	ReloadSelf();
	        }, 60000); */
	        
	    //规定的时间间隔内调用某个JS方法(调用此方法是完成实时公告监控功能CCS-225，CCS-913)
	    // 此方法取消定时检测，改为登录时弹出一次，之后点击“获取任务”才会弹出。  CCS-1197（审核人员点击“获取任务”按钮弹出审核部公告）
	    //setInterval(function () {
	    //	ReloadNotice();
        //}, 60000);
	        
	        
    }catch(e){}
    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
