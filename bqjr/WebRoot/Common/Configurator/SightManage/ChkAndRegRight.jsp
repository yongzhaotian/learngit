<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zxu 2005-03-11
		Tester:
		Content: 检查合法性并注册权限点
		Input Param:
                  
		Output param:
		                
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	SqlObject so = null;
	String sNewSql = "";
	
	//获得组件参数	
	String sSightSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SightSetID"));
	String sSightID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SightID"));
	String sOper = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Oper"));
	if(sSightSetID==null) sSightSetID="";
	if(sSightID==null) sSightID="";
	if(sOper==null) sOper="Y";
%>
<%/*~END~*/%>

<%
	if( sOper.equals("N") ) {
		if( sSightSetID.length() != 0 && sSightID.length() != 0 )
			sNewSql = "update DS_Sight set EffStatus = '0' where SightSetId = :SightSetID and SightId = :SightID ";
			so = new SqlObject(sNewSql).setParameter("SightSetID",sSightSetID).setParameter("SightID",sSightID);
			Sqlca.executeSQL(so);

		%>
		<script type="text/javascript">
		self.returnValue="succeeded";
		self.close();
		</script>
		<%
	}else{
%>
<html>
<head>
<title>检查视野条件并注册权限点</title> 
<script type="text/javascript">
function doReturn(){
	self.close();
}
</script>
</head>
<body class="InfoPage" leftmargin="0" topmargin="0" >
<table border="0" width="60%" height="20%" cellspacing="0" cellpadding="0">
	<tr height=1 >
	    <td id="InfoTitle" class="InfoTitle">
	    </td>
	</tr>
	<tr>
		<td>
		<!--消息提示区-->
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=检查合法性及注册权限;]~*/%>
<%	
	boolean flag = true;
	String sSightWhereClause = null;
        try{
		int i = 0;
		sNewSql = "select SightWhereClause from DS_SIGHT where SightSetId = :SightSetID and SightId = :SightID ";
		so = new SqlObject(sNewSql).setParameter("SightSetID",sSightSetID).setParameter("SightID",sSightID);
		sSightWhereClause = Sqlca.getString(so);
		if(sSightWhereClause==null) sSightWhereClause="";
	        //从视野定义表中取权限信息
	        sNewSql = "select MacroParams from DS_SIGHT_SET where SightSetId = :SightSetID";
			so = new SqlObject(sNewSql).setParameter("SightSetID",sSightSetID);
	        String sMacroParams = Sqlca.getString(so);
	        if( sMacroParams == null ){
	            out.println("该视野组["+sSightSetID+"]用户还未定义，请定义先！");
	        }
	        sMacroParams = sMacroParams.trim();
		sSightWhereClause = sSightWhereClause.trim();
	
	        //设置宏替换所用的Attribute
	        int iAttrSize = StringFunction.getSeparateSum(sMacroParams,",");
	        String[][] ssAttribute = new String[iAttrSize][2];
	        for( i = 0; i < iAttrSize; i++ ){
	            ssAttribute[i][0] = "#{"+StringFunction.getSeparate(sMacroParams,",",i+1)+"}";
		    ssAttribute[i][1] = "0";
	        }
	        int iPosBegin=0,iPosEnd=0;
	        String sAttributeID="";
		String sAttrValue=null;
		String sReTemp = sSightWhereClause;
        
	        while((iPosBegin=sReTemp.indexOf("#{",iPosBegin))>=0){
	            iPosEnd = sReTemp.indexOf("}",iPosBegin);
	            sAttributeID = sReTemp.substring(iPosBegin,iPosEnd+"}".length());
		    sAttrValue = StringFunction.getAttribute(ssAttribute,sAttributeID,0,1);
	            sReTemp = sReTemp.substring(0,iPosBegin) + sAttrValue + sReTemp.substring(iPosEnd+"}".length());
		    if( sAttrValue == null )
		    {
			out.println("缺少宏定义变量：" + sAttributeID );
			flag = false;
			%>
			<script type="text/javascript">
			self.returnValue="failed";
			</script>
			<%
	            }
		}
        }catch(Exception ex){
		out.println("条件子句语法有误:"+sSightWhereClause + ",信息："+SpecialTools.amarsoft2Real(ex.getMessage()));
		flag = false;
		%>
		<script type="text/javascript">
		self.returnValue="failed";
		</script>
		<%
        }
	if( flag ) {
		//检查通过，注册权限点，并更改视野表中的权限字段
		String sRightId = "视野-" + sSightSetID + "-" + sSightID;
	
		try{
			int rowCount=0;
			String sTmpRightID = Sqlca.getString(new SqlObject("select RightId from Right_Info where RightID = :RightId").setParameter("RightId",sRightId));
			if( sTmpRightID == null ) {
				sNewSql = "insert into Right_Info (RightID,RightName,RightStatus,InputTime,InputUser,InputOrg) values(:RightID,:RightName,:RightStatus,:InputTime,:InputUser,:InputOrg)";
				so = new SqlObject(sNewSql);
				so.setParameter("RightID",sRightId);
				so.setParameter("RightName",sRightId);
				so.setParameter("RightStatus","1");
				so.setParameter("InputTime",StringFunction.getToday());
				so.setParameter("InputUser",CurUser.getUserID());
				so.setParameter("InputOrg",CurOrg.getOrgID());
				rowCount = Sqlca.executeSQL(so);
			}
			sNewSql = "update DS_Sight set RightId = :RightId, EffStatus = :EffStatus where SightSetId = :SightSetId and SightId = :SightId ";
			so = new SqlObject(sNewSql);
			so.setParameter("RightId",sRightId);
			so.setParameter("EffStatus","1");
			so.setParameter("SightSetId",sSightSetID);
			so.setParameter("SightId",sSightID);
			rowCount += Sqlca.executeSQL(so);

			out.println("语法检查通过并注册权限成功！");
			%>
			<script type="text/javascript">
			self.returnValue="succeeded";
			</script>
			<%
	        }catch(Exception exx){
			out.println("注册权限点:"+sRightId + "时数据库操作错误：" + SpecialTools.amarsoft2Real(exx.getMessage()));
			%>
			<script type="text/javascript">
			self.returnValue="failed";
			</script>
			<%
	        }
	}
	
%>

		</td>
		<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","返回","返回","javascript:doReturn()",sResourcesPath)%></td>
	</tr>
</table>
</body>
</html>
<%
	} // END for if( sOper.equals("N") )
%>

<%/*~END~*/%>
		
<%@ include file="/IncludeEnd.jsp"%>
