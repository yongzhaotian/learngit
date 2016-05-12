<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
    Author:  cbsu 2009-10-13
    Tester:
    Content: 五级分类认定签署意见
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "五级分类认定签署意见";
    %>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sSql="";
    ASResultSet rs=null;
    String sObjectNo="",sBusinessType="",sBusinessCurrency="";
    String sAccountMonth="",sModeClassifyResult="",sCustomerName="",sCustomerID=""; 
    double dBalance = 0.0;
    //BC表或者BD表
    String sTableName = "";
    //"借据流水号"或者"合同流水号"
    String sHeadType = "";
    //"借据余额"或者"合同余额"
    String sBalanceType="";
    
    //获取组件参数
    //FLOW_TASK表记录流水号
    String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
    //五级分类申请流水号
    String sClassifyRecordNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    //五级分类类型:Classify
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    //五级分类是借据或合同
    String sResultType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ResultType"));

    //将空值转化为空字符串
    if(sSerialNo == null) sSerialNo = "";
    if(sClassifyRecordNo == null) sClassifyRecordNo = "";
    if(sObjectType == null) sObjectType = "";
    if(sResultType == null) sResultType = "";
    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
    <%
 
    //根据sResultType来确定是对BUSINESS_DUEBILL(借据)或BUSINESS_CONTRACT(合同)表进行操作    
   if ("BusinessDueBill".equals(sResultType)) {
        sTableName = "BUSINESS_DUEBILL";
        sHeadType = "借据流水号";
        sBalanceType = "借据余额";
    }
    if ("BusinessContract".equals(sResultType)) {
        sTableName = "BUSINESS_CONTRACT";
        sHeadType = "合同流水号";
        sBalanceType = "合同余额";
    } 
    

    //取得页面需要展现的数据信息:借据/合同流水号，业务品种，币种，余额，会计月份，模型评估结果
    sSql = " select CR.ObjectNo,BT.BusinessType,BT.BusinessCurrency," +
           " BT.Balance,CR.AccountMonth,CR.SecondResult," +
           " BT.CustomerID,BT.CustomerName" + 
           " from CLASSIFY_RECORD CR," + sTableName + " BT" + 
           " where CR.ObjectType =:ObjectType" +
           " and CR.SerialNo =:SerialNo and CR.ObjectNo=BT.SerialNo";
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sResultType).setParameter("SerialNo",sClassifyRecordNo));
    if(rs.next()){
        sObjectNo = rs.getString("ObjectNo");
        sBusinessType = rs.getString("BusinessType");
        sBusinessCurrency = rs.getString("BusinessCurrency");
        //五级分类模型评估结果代码
        sModeClassifyResult = rs.getString("SecondResult");
        dBalance = rs.getDouble("Balance");
        sAccountMonth = rs.getString("AccountMonth");
        sCustomerName = rs.getString("CustomerName");
        sCustomerID = rs.getString("CustomerID");
         
         if (sObjectNo==null)sObjectNo="";
         if (sBusinessType==null)sBusinessType="";
         if (sBusinessCurrency==null)sBusinessCurrency="";
         if (sModeClassifyResult==null)sModeClassifyResult="";
         if (sAccountMonth==null)sAccountMonth="";
         if (sCustomerName==null)sCustomerName="";
         if (sCustomerID==null)sCustomerID="";
    }
    rs.getStatement().close();
  
               
    ASDataObject doTemp = null;
    if ("BusinessDueBill".equals(sResultType)) {
    	 String sTempletNo = "SignClassifyOpinionInfo1";
    	 doTemp = new ASDataObject(sTempletNo,Sqlca);
          }
     //模型编号：2013-5-9新增
     
     
   
 	//生成ASDataWindow对象 
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    //freeform形式
    dwTemp.Style="2";
    Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//新增参数：2013-5-9
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
    <%
    //依次为：
        //0.是否显示
        //1.注册目标组件号(为空则自动取当前组件)
        //2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
        //3.按钮文字
        //4.说明文字
        //5.事件
        //6.资源图片路径
    String sButtons[][] = {
            {"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
            {"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
        };
    %> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">

    /*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
    function saveRecord()
    {
        sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
        if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
        {
            initOpinionNo();
        }
      	//不允许签署的意见为空白字符
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion2"))){
			alert("请签署认定理由！");
			setItemValue(0,0,"PhaseOpinion2","");
			return;
		}
        as_save("myiframe0"); 
    }
    
    /*~[Describe=删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
        sSerialNo=getItemValue(0,getRow(),"SerialNo");
        sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
        if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
         {
               alert("您还没有签署意见，不能做删除意见操作！");
         }
         else if(confirm("你确实要删除意见吗？"))
         {
               sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
               if (sReturn==1)
               {
                alert("意见删除成功!");
              }
               else
               {
                alert("意见删除失败！");
               }
        }
        reloadSelf();
    } 
    
    /*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
    function initOpinionNo() 
    {
    	/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var sTableName = "FLOW_OPINION";//表名
        var sColumnName = "OpinionNo";//字段名
        var sPrefix = "";//无前缀

        //获取流水号
        var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);*/
		var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		
        //将流水号置入对应字段
        setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		/** --end --*/
        
    }
    
    /*~[Describe=插入一条新记录;InputParam=无;OutPutParam=无;]~*/
    function initRow()
    {
        //如果没有找到对应记录，则新增一条，并可以设置字段默认值
        if (getRowCount(0)==0) 
        {
            //新增记录
            as_add("myiframe0");
            setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
            setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
            setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
            setItemValue(0,getRow(),"ObjectNo","<%=sClassifyRecordNo%>");
            setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
            setItemValue(0,getRow(),"BusinessCurrency","<%=sBusinessCurrency%>");
            setItemValue(0,getRow(),"SecondResult","<%=sModeClassifyResult%>");
            setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
            setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
            setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
            setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
            setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
        }
        setItemValue(0,getRow(),"PhaseChoice","<%=sObjectNo%>");
        setItemValue(0,getRow(),"BusinessTypeName","<%=sBusinessType%>");
        setItemValue(0,getRow(),"Balance","<%=DataConvert.toMoney(dBalance)%>");
        setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
        setItemValue(0,getRow(),"SecondResult","<%=sModeClassifyResult%>");
    }
    </script>
<%/*~END~*/%>


<script type="text/javascript">
    AsOne.AsInit();
    init();
    my_load(2,0,'myiframe0');
    initRow(); //页面装载时，对DW当前记录进行初始化
</script>    
<%@ include file="/IncludeEnd.jsp"%>