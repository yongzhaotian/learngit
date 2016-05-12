<%@page import="com.amarsoft.xquery.*"%>
<%@page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 对查询条件进行处理，生成Sql
		Input Param:
		     type:查询类型
                GroupList;;Other;	:分组列表
 				SummaryList;;Other;	:汇总列表
 				OrderList;;Other;	:排序列表
 				DisplayList;;Other;	:显示列表
	 */
%>
<script>
        //显示的控制
	    var aw = screen.availWidth;
    	var ah = screen.availHeight;
    	window.moveTo(0, 0);
    	window.resizeTo(aw, ah);
</script>
<%
	String baseSql= "",querySql= "",baseString0="",baseString1="",groupByString="";
	String column[];
	int columnLength;
	String header[][]= new String[2][2];

	//获得组件参数，查询的路径和查询类型
	XQuery query = new XQuery((String)session.getAttribute("xmlPath"),(String)session.getAttribute("queryType"));

	String groupString    =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupList;;Other;"));
	String summaryString  =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SummaryList;;Other;"));
	String orderString    =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrderList;;Other;"));
	String displayString  =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DisplayList;;Other;"));
	String sStatResult   = DataConvert.toRealString(iPostChange,CurPage.getParameter("StatResult;;Other;"));
	if(groupString==null) groupString="";
	if(summaryString==null) summaryString="";
	if(orderString==null) orderString="";
	if(displayString==null) displayString="";
	if(sStatResult==null) sStatResult="";
	
	//设置基本Sql
	ASQuery queryGen = new ASQuery(request);

	queryGen.BaseSelectFirst = false;	
	//汇总查询
	if (sStatResult.equals("1")){
		//将summaryString转化为数组
		column=StringFunction.toStringArray(summaryString,"|");
		if(summaryString.trim().length()!=0){
			columnLength = column.length;
		}else{
			columnLength = 0;
		}
		
		//建立合计项的数组 0,header 1,value 2,?
		String totalSum[][]=new String[columnLength+1][3];

		//将groupString转为用于select显示的字符串
		Vector codeRelatedColumns = query.getCodeRelatedColumns(groupString,"0");
		Vector allCol= query.getAllColumnsList();
		for(int jj=0;jj<allCol.size();jj++){
			String[] sTemp=(String[])allCol.get(jj);
			if(sTemp[4].length()> 0){
				groupString=groupString.replaceAll(" as "+sTemp[4]," ");
			}
		}

		String groupColumnAddToSelectString = query.convertVectorToString(codeRelatedColumns,0);
		
		header= new String[codeRelatedColumns.size()+(columnLength+1)*2][2];
		for(int i=0; i<codeRelatedColumns.size();i++){
			String temp[] = (String[])codeRelatedColumns.get(i);
			header[i][0] = temp[1];
			header[i][1] = temp[2];
		}
		
		//生成groupByString
		if(groupString.trim().length()!=0){
			groupByString = " group by " + StringFunction.replace(groupString,"|",",");;
		}
		//取得基本的sqlString
		baseString0 = "select Count(*) as TotalSum0";
		for(int i=0; i<columnLength; i++){
			String id = (new Integer(i+1)).toString();
			baseString0 = baseString0 + ", sum("+column[i]+") as TotalSum"+id+"";
		}
		
		if(groupColumnAddToSelectString.trim().length()!=0){
			baseString1 = "select "+groupColumnAddToSelectString+", Count(*) as Sum0, Count(*)*100/#TotalSum0 as SumProp0";
		}else{
			baseString1 = "select Count(*) as Sum0, Count(*)/#TotalSum0 as SumProp0";
		}
		
		for(int i=0; i<columnLength; i++){
			String id = (new Integer(i+1)).toString();
			baseString1 = baseString1 + ", sum("+column[i]+") as Sum"+id+", sum("+column[i]+")*100/#TotalSum"+id+" as SumProp"+id;
		}	
		baseSql = baseString1 + " " + query.getFromString()+ " " + query.getWhereString()+ " " + groupByString; 	
		baseSql = StringFunction.replace(baseSql,"#ManageOrgID","(select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')");
		baseSql = StringFunction.replace(baseSql,"#OperateOrgID","(select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')");
		baseSql = StringFunction.replace(baseSql,"^","'");

		queryGen.BaseSelectFirst = false;
		queryGen.setBaseSql(baseSql);

		//取得合计项的值
		String totalSql= baseString0 + " " + query.getFromString()+ " " + queryGen.genWhere();
		totalSql = queryGen.pretreatSql(totalSql);

		ASResultSet rs = Sqlca.getASResultSet(totalSql);
		rs.next();
		for(int i=0; i<totalSum.length; i++){
			totalSum[i][1] = DataConvert.toString(rs.getString(i+1));
			if (totalSum[i][1].equals("0")||totalSum[i][1].equals("")||totalSum[i][1]==null){
				totalSum[i][1]="1";
			}
		}
		rs.getStatement().close();

		String argumentString="";
		String argumentValue="";
		String sumString1="";
		String sumString2="";
		for(int i=0; i<totalSum.length; i++){
			String id = (new Integer(i)).toString();
			if(i==0){
				argumentString="Number TotalSum"+id;
				argumentValue=totalSum[i][1];
				sumString1 = "Sum"+id;
				sumString2 = "SumProp"+id;
				header[codeRelatedColumns.size()+i*2][0]="Sum"+id;
				header[codeRelatedColumns.size()+i*2][1]="笔数";
				header[codeRelatedColumns.size()+i*2+1][0]="SumProp"+id;
				header[codeRelatedColumns.size()+i*2+1][1]="占比%";
			}else{
				argumentString=argumentString+", Number TotalSum"+id;
				argumentValue=argumentValue+","+totalSum[i][1];
				sumString1 = sumString1+",Sum"+id;
				sumString2 = sumString2+",Sum"+id+",SumProp"+id;
				header[codeRelatedColumns.size()+i*2][0]="Sum"+id;
				String colDef[]= query.getColumnDefinition(column[i-1]);
				header[codeRelatedColumns.size()+i*2][1]=colDef[5];
				header[codeRelatedColumns.size()+i*2+1][0]="SumProp"+id;
				header[codeRelatedColumns.size()+i*2+1][1]="占比%";
			}
		}
		querySql = queryGen.genQuerySql();
		session.setAttribute("Arguments",argumentString); 
		session.setAttribute("sumString2",sumString2);
		session.setAttribute("sumString1",sumString1);
		session.setAttribute("argumentValue",argumentValue);
	}else{//明细查询
		Vector codeRelatedColumns;
		String temp[];
		
		if(displayString.trim().length()==0){
			displayString = "*";
		}else{
			codeRelatedColumns = query.getCodeRelatedColumns(displayString,"1");
			displayString = query.convertVectorToString(codeRelatedColumns,0);
			header = new String[codeRelatedColumns.size()][2];
			for(int i=0; i<codeRelatedColumns.size();i++){
				temp = (String[])codeRelatedColumns.get(i);
				header[i][0] = temp[1];
				header[i][1] = temp[2];
			}
		}
		String sqlString = "select " + displayString+" "+ query.getFromString()+ " " + query.getWhereString();	
		queryGen.setBaseSql(sqlString);
		querySql = queryGen.genQuerySql();
		//排序字段的替换，把“|”替换为“,”
		if(orderString.length()!=0){
			//int index = orderString.indexOf(" ",1);
			//orderString = StringFunction.replace(orderString,"substr(EI.IndustryType,1,1) as IndustryTypeLevel1","substr(EI.IndustryType,1,1)");
			//orderString = orderString.substring(0,index);
			querySql = querySql + " order by " + StringFunction.replace(orderString,"|",",");
		}
		querySql = StringFunction.replace(querySql,"#ManageOrgID","(select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')");
		querySql = StringFunction.replace(querySql,"#OperateOrgID","(select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')");
	}
	session.setAttribute("querySql",querySql); 
	session.setAttribute("header",header);
	session.setAttribute("XQuery",query); 
 %>
<script>
	OpenComp("XQueryResult","/InfoManage/QueryManage/XShow.jsp","StatResult=<%=sStatResult%>","_blank",OpenStyle);
</script><%@ include file="/IncludeEnd.jsp"%>