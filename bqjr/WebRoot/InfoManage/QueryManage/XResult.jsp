<%@page import="com.amarsoft.xquery.*"%>
<%@page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �Բ�ѯ�������д�������Sql
		Input Param:
		     type:��ѯ����
                GroupList;;Other;	:�����б�
 				SummaryList;;Other;	:�����б�
 				OrderList;;Other;	:�����б�
 				DisplayList;;Other;	:��ʾ�б�
	 */
%>
<script>
        //��ʾ�Ŀ���
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

	//��������������ѯ��·���Ͳ�ѯ����
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
	
	//���û���Sql
	ASQuery queryGen = new ASQuery(request);

	queryGen.BaseSelectFirst = false;	
	//���ܲ�ѯ
	if (sStatResult.equals("1")){
		//��summaryStringת��Ϊ����
		column=StringFunction.toStringArray(summaryString,"|");
		if(summaryString.trim().length()!=0){
			columnLength = column.length;
		}else{
			columnLength = 0;
		}
		
		//�����ϼ�������� 0,header 1,value 2,?
		String totalSum[][]=new String[columnLength+1][3];

		//��groupStringתΪ����select��ʾ���ַ���
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
		
		//����groupByString
		if(groupString.trim().length()!=0){
			groupByString = " group by " + StringFunction.replace(groupString,"|",",");;
		}
		//ȡ�û�����sqlString
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

		//ȡ�úϼ����ֵ
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
				header[codeRelatedColumns.size()+i*2][1]="����";
				header[codeRelatedColumns.size()+i*2+1][0]="SumProp"+id;
				header[codeRelatedColumns.size()+i*2+1][1]="ռ��%";
			}else{
				argumentString=argumentString+", Number TotalSum"+id;
				argumentValue=argumentValue+","+totalSum[i][1];
				sumString1 = sumString1+",Sum"+id;
				sumString2 = sumString2+",Sum"+id+",SumProp"+id;
				header[codeRelatedColumns.size()+i*2][0]="Sum"+id;
				String colDef[]= query.getColumnDefinition(column[i-1]);
				header[codeRelatedColumns.size()+i*2][1]=colDef[5];
				header[codeRelatedColumns.size()+i*2+1][0]="SumProp"+id;
				header[codeRelatedColumns.size()+i*2+1][1]="ռ��%";
			}
		}
		querySql = queryGen.genQuerySql();
		session.setAttribute("Arguments",argumentString); 
		session.setAttribute("sumString2",sumString2);
		session.setAttribute("sumString1",sumString1);
		session.setAttribute("argumentValue",argumentValue);
	}else{//��ϸ��ѯ
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
		//�����ֶε��滻���ѡ�|���滻Ϊ��,��
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