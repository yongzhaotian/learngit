<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
    <%
    /*
		Author:  yongxu 2015/05/28
		Tester:
		Content: 贷后资料检查当前待办任务/已完成任务
		Input Param:
		Output param:
		History Log: 
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
    sSql += " and FlowNo in "+sTempFlowNo+" ";
    
    sSql += " and UserID ='"+CurUser.getUserID()+"' "+
            " and (EndTime is  null or EndTime =' ' or EndTime ='') and PhaseNo <> '0010'"+
            " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
            " Order by FlowNo,PhaseNo ";
    rs = Sqlca.getASResultSet(sSql);
    int t=0;//定义变量用于判断是否是第一条数据 */
    String sDisplay="";//用于存放sPageShow拿到的第一条数据（当相同阶段存在两个或多个流程时）
    sPageShow  = "当前待办任务"; 
    //待处理任务
    String sFlowCount = "0";
  	//add by xswang 20150806 --CRA-329 获取文件质量检查和贷后资料比较慢
   	sFlowCount =Sqlca.getString(" select count(1) from business_contract bc, check_contract cc "+
   			  			" where bc.serialno = cc.ContractSerialNo and (bc.suretype = 'APP' or bc.suretype = 'FC') and (cc.checkstatus = '2' or cc.checkstatus = '6') "+
   			  			" and bc.contractstatus='050' and cc.uploadflag = '1' ");
   	// end
   	sPageShow  = "当前待办任务"+sFlowCount+"件"; 
   	sDisplay = sPageShow;
   	tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
    
    rs.getStatement().close();

    //4、设置当前用户对于该类对象的已完成工作菜单项
    sFolderfinished = tviTemp.insertFolder("root","已完成工作","",i++);
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
  	//add by xswang 20150806 --CRA-329 获取文件质量检查和贷后资料比较慢
  	String sFinishSql = " select count(1) from business_contract bc, check_contract cc "+
	  			" where 1=1 and cc.ContractSerialNo = bc.serialno "+
	  			" and (cc.checkstatus in ('1','5'))"+
	  			" and bc.contractstatus='050' and (bc.suretype = 'APP' or bc.suretype = 'FC') ";
  	//管理员权限可以显示所有用户已完成的记录
	if(!CurUser.hasRole("2040")){
		sFinishSql += " and (cc.checkImageUserID ='"+CurUser.getUserID()+"' or cc.checkImageUserID2 ='"+CurUser.getUserID()+"')  ";	   			  				
   	}
   	sFlowCount = Sqlca.getString(sFinishSql);
    // end
  	sPageShow  = "已完成的任务"+sFlowCount+"件"; 
   	tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:parent.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sTempFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
    rs.getStatement().close();
//用@替换字符串中的逗号
    String TempFlowNoString = sTempFlowNo.replace(",", "@");

    %>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
    <script type="text/javascript"> 
    
    /*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
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
	    //规定的时间间隔内调用某个JS方法
 	    setInterval(function () {
	    	reloadSelf();
        }, 300000);
    }catch(e){}
    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
