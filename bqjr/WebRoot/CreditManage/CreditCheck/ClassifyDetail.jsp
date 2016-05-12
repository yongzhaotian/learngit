<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.classify.*"%>
<%
	//定义变量：计数器
	int i = 0,iCount = 0;
	//定义变量：查询结果集
	ASResultSet rs = null ;
	//定义变量：封装sql语句防止sql注入
	SqlObject so = null;
	//定义变量：风险分类类
	Classify classify = null;
	//定义变量：Sql语句、返回信息、客户名称、产品名称
	String sSQLText = "",sMessage = "",sCustomerName = "",sBusinessName = "";
	//定义变量：客户代码、对象类型、对象编号、流水号
	String sObjectType = "",sObjectNo = "",sSerialNo = "";
	//定义变量：会计月份、模型号、异常提示、分类类型
	String sAccountMonth = "",sModelNo = "",sException = "",sClassifyType = "";
	//定义变量：动作、项目名称、项目值、代码
	String sAction = "",sItemName = "",sItemValue = "",sValueCode ="";
	//定义变量：值方法、值类型、Sql语句
	String sValueMethod = "",sValueType = "",sSql = "";
	//定义打开方式
	String sOpenType = "";
	//定义变量：余额
	double dBalance = 0.0;
	//定义五级分类借据或合同 add by cbsu 2009-10-12
	String sResultType = "";
	
	//获取页面参数：动作、分类类型、对象类型、借据或合同编号、五级分类申请流水号、会计月份、模型号、合同或者借据分类
	sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	sClassifyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassifyType"));
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	sResultType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ResultType"));
	sOpenType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OpenType"));
	
	//将空值转化为空字符串
	if(sAction == null) sAction = "";
	if(sClassifyType == null) sClassifyType = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sResultType == null) sResultType ="";
	if(sOpenType == null) sOpenType ="";
	
	//jschen@20100412 通过sOpenType 进行sObjectNo的转换
	if("Tab".equalsIgnoreCase(sOpenType)){
		//如果是Tab方式展现，sObjectNo实际是CLASSIFY_RECORD的SerialNo,sSerialNo是借据/合同号，所以需要交换值
		String sTempNo = sObjectNo;
		sObjectNo = sSerialNo;
		sSerialNo = sTempNo;
	}
	
	//查询按合同进行风险分类的业务品种、客户名称和余额
	if(sResultType.equals("BusinessContract")){
		sSQLText = 	" select CustomerName,getBusinessName(BusinessType) as BusinessTypeName,Balance "+
					" from BUSINESS_CONTRACT "+
					" where SerialNo =:SerialNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSQLText).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			sBusinessName = rs.getString("BusinessTypeName");
			dBalance = rs.getDouble("Balance");
			
			//将空值转化为空字符串
			if(sCustomerName == null) sCustomerName = "";
			if(sBusinessName == null) sBusinessName = "";
		}
		rs.getStatement().close();
	}
	
	//查询按借据进行风险分类的业务品种、客户名称和余额
	if(sResultType.equals("BusinessDueBill")){
		sSQLText = 	" select CustomerName,getBusinessName(BusinessType) as BusinessTypeName,Balance "+
					" from BUSINESS_DUEBILL "+
					" where SerialNo =:SerialNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSQLText).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			sBusinessName = rs.getString("BusinessTypeName");
			dBalance = rs.getDouble("Balance");
			
			//将空值转化为空字符串
			if(sCustomerName == null) sCustomerName = "";
			if(sBusinessName == null) sBusinessName = "";
		}
		rs.getStatement().close();
	}
	//新建一个classify
	if(sAction.equals("_NEW_")){
		sSql = 	" select count(SerialNo) from CLASSIFY_RECORD "+
				" where ObjectType =:ObjectType "+
				" and ObjectNo =:ObjectNo "+
				" and AccountMonth =:AccountMonth ";
		so = new SqlObject(sSql).setParameter("ObjectType",sResultType)
		.setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth);
		rs = Sqlca.getASResultSet(so);
		if (rs.next())
			iCount = rs.getInt(1);
		//关闭结果集
		rs.getStatement().close(); 
		
		if(iCount > 0){
%>
			<script type="text/javascript"> 
				alert(getBusinessMessage("665"));//该期资产风险分类已经存在！
				self.close();
			</script> 
<%
		}else{
			//获取资产风险分类日期
			String sClassifyDate = StringFunction.getToday();
			//获取当前机构代码
			String sOrgID = CurOrg.getOrgID();
			//获取当前用户代码
			String sUserID = CurUser.getUserID();
			//在风险分类记录表中新增一条分类记录
			sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,sClassifyDate,sOrgID,sUserID,Sqlca); 
			
			sSql = 	" update CLASSIFY_RECORD set BusinessBalance =:BusinessBalance, "+
					" InputDate =:InputDate, "+
					" UpdateDate =:UpdateDate "+
					" where SerialNo =:SerialNo ";
			so = new SqlObject(sSql);
			so.setParameter("BusinessBalance",dBalance).setParameter("InputDate",StringFunction.getToday())
			.setParameter("UpdateDate",StringFunction.getToday()).setParameter("SerialNo",sSerialNo);
			Sqlca.executeSQL(so);

			session.setAttribute("AccountMonth",sAccountMonth);
			session.setAttribute("ModelNo",sModelNo);
		}
	}
	
	classify = new Classify(sResultType,sObjectNo,sSerialNo,Sqlca);
	//保存,计算时也进行保存
	if(sAction.equals("_UPDATE_") || sAction.equals("_CLASSIFY_")){
		if (classify.ClassifyData.first()){
			do {
	    		i++;
	     		sItemName  = "R" + String.valueOf(i);
	     		sItemValue = request.getParameter(sItemName);
			
	     		if (sItemValue!=null && sItemValue.trim().length()!=0){
	     			Sqlca.executeSQL(" update CLASSIFY_DATA set ItemValue = '"+sItemValue+"' where ObjectType = '"+sResultType+"' and ObjectNo = '"+sObjectNo+"' and SerialNo = '"+sSerialNo+"' and ItemNo = '"+classify.ClassifyData.getString("ItemNo")+"' ");
	     		}
			}while(classify.ClassifyData.next());
		 }
			 
		 classify.getRecord();	
		 classify.getData(); 
		 sMessage =  "FinishSave";  //该期资产风险分类数据保存完成！
	}

	//开始计算
	if(sAction.equals("_CLASSIFY_")){
		//取值
		classify.getValue();
		try{   //计算
			classify.classify();
			sMessage = "FinishCalculate";//该期资产风险分类测算完成！
		}catch(Exception e){
			classify.FirstResult = "";
			classify.SecondResult = "";
			classify.updateRecord();
			sMessage = "UnfinishCalculate";//该期资产风险分类测算没有正常完成！
			sException = e.toString();
		}
		//重新取数据
		classify.getRecord();
		classify.getData();  
	}

	//删除数据
	if(sAction.equals("_DELETE_")){
		Classify.deleteClassify(classify.ObjectType,classify.ObjectNo,classify.SerialNo,Sqlca);
%>
		<script type="text/javascript"> 
			alert(getBusinessMessage("666"));//该期资产风险分类信息删除完成！
			self.close();
		</script> 
<%		
	}
%>
<html>
<head>
<title>资产风险分类 - 数据详情表</title>
	<style>
	 input {border-style:none;border-width:thin;border-color:#e9e9e9}
	 .number {text-align:right;}
	</style>

<script type="text/javascript"> 

	/*~[Describe=测算;InputParam=无;OutPutParam=SerialNo;]~*/
   	function classify(){
        var sParameter = "1=1"+  //jschen@20100423 整理代码
            "&OpenType= "+
	        "&Action=_CLASSIFY_"+
	        //"&ClassifyType="+sClassifyType+
	        "&ObjectType="+"<%=sObjectType%>"+
	        "&ObjectNo="+"<%=sObjectNo%>"+
	        "&SerialNo="+"<%=sSerialNo%>"+
	        "&AccountMonth="+"<%=sAccountMonth%>"+
	        "&ModelNo="+"<%=sModelNo%>"+
	        "&ResultType="+"<%=sResultType%>"+
	        "&Rand="+randomNumber();
		document.report.action="<%=sWebRootPath%>/CreditManage/CreditCheck/ClassifyDetail.jsp?"+sParameter;
		document.report.submit(); 
   	} 
  	
  	/*~[Describe=保存;InputParam=无;OutPutParam=SerialNo;]~*/
   	function updateData(){
        var sParameter = "1=1"+
	        "&OpenType= "+
	        "&Action=_UPDATE_"+
	        //"&ClassifyType="+sClassifyType+
	        "&ObjectType="+"<%=sObjectType%>"+
	        "&ObjectNo="+"<%=sObjectNo%>"+
	        "&SerialNo="+"<%=sSerialNo%>"+
	        "&AccountMonth="+"<%=sAccountMonth%>"+
	        "&ModelNo="+"<%=sModelNo%>"+
	        "&ResultType="+"<%=sResultType%>"+
	        "&Rand="+randomNumber();
		document.report.action="<%=sWebRootPath%>/CreditManage/CreditCheck/ClassifyDetail.jsp?"+sParameter;
		document.report.submit(); 
   	}
   	
   	/*~[Describe=删除记录;InputParam=无;OutPutParam=SerialNo;]~*/
   	function deleteData(){
		if (confirm(getBusinessMessage("667"))){ //将要删除该该期资产风险分类信息，继续吗？
	        var sParameter = "1=1"+
		        "&OpenType= "+
		        "&Action=_DELETE_"+
		        //"&ClassifyType="+sClassifyType+
		        "&ObjectType="+"<%=sObjectType%>"+
		        "&ObjectNo="+"<%=sObjectNo%>"+
		        "&SerialNo="+"<%=sSerialNo%>"+
		        "&AccountMonth="+"<%=sAccountMonth%>"+
		        "&ModelNo="+"<%=sModelNo%>"+
		        "&ResultType="+"<%=sResultType%>"+
		        "&Rand="+randomNumber();
			document.report.action="<%=sWebRootPath%>/CreditManage/CreditCheck/ClassifyDetail.jsp?"+sParameter;
			document.report.submit(); 
		}
   	}  
   	
   	/*~[Describe=返回;InputParam=无;OutPutParam=SerialNo;]~*/
   	function goback(){
		self.close();
   	}  
   	
   	/*~[Describe=初始化页面;InputParam=无;OutPutParam=SerialNo;]~*/
   	function initPage(){
		//借款人财务状况自动获取
		document.report.R10.disabled=true;
		//担保状况中的担保方式自动获取
		document.report.R13.disabled=true;	
		//保证人财务状况自动获取	
		document.report.R15.disabled=true;
		//是否直接认定为损失类为否
		if(document.report.R2.value=="0")
			document.report.R2.value="2";
		//是否直接认定为可疑类为否
		if(document.report.R5.value=="0")
			document.report.R5.value="2";
		ClassifyChange();
   	}
   	
   	/*~[Describe=损失控制;InputParam=无;OutPutParam=SerialNo;]~*/
	function ClassifyChange(){
		//如果直接认定为损失类，则只需选择具体原因，其他项不需再进行选择
		if(document.report.R2.value == "1"){
			document.report.R3.disabled=false;
			document.report.R4.disabled=false;				
			document.report.R5.disabled=true;
			document.report.R6.disabled=true;
			document.report.R7.disabled=true;			
			document.report.R9.disabled=true;			
			document.report.R11.disabled=true;					
			document.report.R16.disabled=true;
			document.report.R19.disabled=true;									
			document.report.R20.disabled=true;
			document.report.R21.disabled=true;
			document.report.R22.disabled=true;			
			if((document.report.R3.value=="0")&&(document.report.R4.value==""))
				alert(getBusinessMessage("663"));//请选择直接认定为损失类的具体原因或输入其他原因！
		}else{
			document.report.R3.disabled=true;	
			document.report.R4.disabled=true;
			document.report.R5.disabled=false;
			document.report.R6.disabled=false;
			document.report.R7.disabled=false;			
			document.report.R9.disabled=false;			
			document.report.R11.disabled=false;							
			document.report.R16.disabled=false;	
			document.report.R19.disabled=false;							
			document.report.R20.disabled=false;
			document.report.R21.disabled=false;
			document.report.R22.disabled=false;			
			//如果直接认定为可疑类，则只需选择具体原因，其他项不需再进行选择
			if(document.report.R5.value == "1"){
				document.report.R3.disabled=true;	
				document.report.R4.disabled=true;
				document.report.R5.disabled=false;
				document.report.R6.disabled=false;
				document.report.R7.disabled=false;			
				document.report.R9.disabled=true;				
				document.report.R11.disabled=true;												
				document.report.R16.disabled=true;
				document.report.R19.disabled=true;										
				document.report.R20.disabled=true;
				document.report.R21.disabled=true;
				document.report.R22.disabled=true;
				if((document.report.R6.value=="0")&&(document.report.R7.value==""))
					alert(getBusinessMessage("664"));//请选择直接认定为可疑类的具体原因或输入其他原因！
			}else{
				document.report.R3.disabled=true;	
				document.report.R4.disabled=true;
				document.report.R5.disabled=false;
				document.report.R6.disabled=true;
				document.report.R7.disabled=true;			
				document.report.R9.disabled=false;				
				document.report.R11.disabled=false;								
				document.report.R16.disabled=false;	
				document.report.R19.disabled=false;								
				document.report.R20.disabled=false;
				document.report.R21.disabled=false;
				document.report.R22.disabled=false;				
			}
		}
	}
		
</script>
  
<link rel="stylesheet" href="style.css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0">
<p>
<table width="100%" border="0" align="center" height="100%" cellspacing="0" cellpadding="0">
  <tr >
    <td height="1"></td>
  </tr>
  <tr > 
    <td height="1"> 
      <table width="80%" border="0" cellspace="0" cellpad="2" align="center">
        <tr> 
        <%
        	if(sClassifyType.equals("010")){
        %>
          <!-- <td ><a href="javascript:updateData()">保存</a></td>
          <td ><a href="javascript:classify()" >测算</a></td> -->
          <td align="center">
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","保存","保存","javascript:updateData()",sResourcesPath)%>
    	  </td>
    	  <td align="left">
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","测算","测算","javascript:classify()",sResourcesPath)%>
    	  </td>
          <!-- <td ><a href="javascript:deleteData()">删除</a></td>-->
         <%
         	}
         %>
          <!-- <td ><a href="javascript:goback()">返回</a></td> -->
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="1" > 
      <hr size="1" noshade color="orange">
    </td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="100%"> 
      <div id="Layer1" style="position:absolute; width:100%; height:100%; z-index:1; overflow: auto"> 
       <form name="report" method="post"> <center><b><%=sCustomerName +" "+ sBusinessName +" "+  classify.AccountMonth %>风险分类表<br>
		<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
		<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
		  </b> 模型分类结果:
		  <b>
		  <%		  	
			String s_tmp=DataConvert.toString(classify.SecondResult);
		  %>
		  <%=CodeManager.getItemName("ClassifyResult",s_tmp)%>
		  </b> 
        </center>
        
          <table cellspacing=1 cellpadding=1 align="center">
            <tr bgcolor="#CCCCCC"> 
              <td nowrap width="50"><font color="#000099">编号</font></td>
              <td nowrap width="180"><font color="#000099">项目名称</font></td>
              <td nowrap width="450"><font color="#000099">项目值</font></td>
            </tr>
            <%
				i = 0;
				if(classify.ClassifyData.first()){
					do {
				    	i ++;
				     	sItemName = "R" + String.valueOf(i);				     	
			%> 
            <tr bgcolor="#e9e9e9"> 
              <td nowrap width="50"><%=DataConvert.toString(classify.ClassifyData.getString("ItemNo"))%></td>
              <td nowrap width="180" ><input style="background-color:#e9e9e9" type=text readonly size='28' value='<%=DataConvert.toString(classify.ClassifyData.getString("ItemName"))%>'></td>
             <%
					 	sValueCode   = classify.ClassifyData.getString("ValueCode"); 
					 	sValueMethod = classify.ClassifyData.getString("ValueMethod"); 
					 	sValueType   = classify.ClassifyData.getString("ValueType"); 
					 	sItemValue   = classify.ClassifyData.getString("ItemValue"); 					 
					 	if (sValueCode != null && sValueCode.trim().length() > 0){ //如果有代码则显示代码列表
	 						//如果在模型展现项目的下拉列表内容配置的是代码，请使用如下的语句
	 						//sSql = " select ItemNo,ItemDescribe,ItemName from CODE_LIBRARY where CodeNo = '" + sValueCode + "' order by SortNo ";
	 						//如果在模型展现项目的下拉列表内容配置的是SQL，请使用如下的语句
	 						sSql = sValueCode;
	 		%> 
              <td width="450" class="right" > 
                <select name=<%=sItemName%> class="right" onchange="ClassifyChange();">
                  <option value='0'> </option>
                  <%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,3,DataConvert.toString(sItemValue))%> 
                </select>
              </td>
            <%
					 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType==null || sValueType.trim().length() == 0) //如果有取值方法则不能进行修改
					 	{
	 		%> 
	 		<% 
	 						if(DataConvert.toString(classify.ClassifyData.getString("ItemValue")).length()>0){
	 		%>
              	<td nowrap height='22' width="450" class="right" name=<%=sItemName%>> <%=DataConvert.toMoney(classify.ClassifyData.getString("ItemValue"))%></td>
            <%
             				}else{
            %>
              	<td nowrap height='22' width="450" class="right" name=<%=sItemName%>> <%=DataConvert.toString(classify.ClassifyData.getString("ItemValue"))%></td>
            <%
             				}
					 	}else{ //否则可以进行修改
			%> 
              <td nowrap width="450" class="right" > 
                <input class="right" size=100 type=text name=<%=sItemName%> value='<%=DataConvert.toString(classify.ClassifyData.getString("ItemValue"))%>'>
              </td>
            <%
	 					}	
	 		%>
	      </tr>
            <%	
					}while(classify.ClassifyData.next());
				}	
			%> 
          </table>
        </form>
      </div>
    </td>
  </tr>
</table>

<%
	if(!sAction.equals("_NEW_") && !sAction.equals("_DISPLAY_"))
	{
%>
		<script type="text/javascript">
			sMessage = "<%=sMessage%>"
			if(sMessage == "FinishSave")
				alert(getBusinessMessage("668"));//该期资产风险分类数据保存完成！
			if(sMessage == "FinishCalculate")
				alert(getBusinessMessage("669"));//该期资产风险分类测算完成！
			if(sMessage == "UnfinishCalculate"){
				alert(getBusinessMessage("670"));//该期资产风险分类测算没有正常完成！
				alert("<%=sException%>");
			}
		</script>
<%	 
	}
	classify.close();
	classify = null;
%>
</body>
</html>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
try{
	initPage();}catch(e){}
</script>
<%/*~END~*/%>
<%@include file="/IncludeEnd.jsp"%>
