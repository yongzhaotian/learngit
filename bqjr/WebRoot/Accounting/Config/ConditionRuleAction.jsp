<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String type = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));//操作类型update ,getCode
	String serialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(serialNo==null)serialNo = "";
	String compareType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CompareType"));
	if(compareType==null)compareType = "";
	String colID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColID"));
	if(colID==null)colID = "";
	String colName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColName"));
	if(colName==null)colName = "";
	String colType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColType"));
	if(colType==null)colType = "";
	String colSource =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColSource"));
	if(colSource==null)colSource = "";
	String valueList =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ValueList"));
	if(valueList==null)valueList = "";
	String valusListName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ValueListName"));
	if(valusListName==null)valusListName = "";

	if("update".equalsIgnoreCase(type))
	{
		String sql="update CONDITION_RULE set CompareType=:CompareType,ColID=:ColID,ColName=:ColName,ColType=:ColType,ColSource=:ColSource,ValueList=:ValueList,ValueListName=:ValueListName where SerialNo=:SerialNo ";
		Sqlca.executeSQL(new SqlObject(sql).setParameter("CompareType",compareType)
			.setParameter("ColID",colID)
			.setParameter("ColName",colName)
			.setParameter("ColType",colType)
			.setParameter("SerialNo",serialNo)
			.setParameter("ColSource",colSource)
			.setParameter("ValueList",valueList)
			.setParameter("ValueListName",valusListName));
		%>
		<script language=javascript>
			self.returnValue = "保存成功！";   
		    self.close();    
		</script>
		<%
	}
	else if("getCode".equals(type))
	{
		StringBuffer sb = new StringBuffer();
		if(colSource == null || "".equals(colSource))
			sb.append("");
		else if(colSource.toUpperCase().startsWith("CODE:"))
		{
			com.amarsoft.dict.als.object.Item[] items  = com.amarsoft.dict.als.cache.CodeCache.getItems(colSource.substring(5));
			for(com.amarsoft.dict.als.object.Item item:items)
			{
				sb.append(item.getItemNo()+","+item.getItemName()+"@");
			}
			sb.delete(sb.length()-1,sb.length());
		}
		else
		{
			 ASResultSet rsTemp = Sqlca.getASResultSet(colSource.substring(4));
			 while(rsTemp.next())
			 {
				 sb.append(rsTemp.getString(1)+","+rsTemp.getString(2)+"@");
			 }
			 rsTemp.getStatement().close();
			 sb.delete(sb.length()-1,sb.length());
		}
			
		%>
		<script language=javascript>
			self.returnValue = "<%=sb.toString()%>";   
		    self.close();    
		</script>
		<%
	}
	else
		throw new Exception("不支持的操纵类型！");
%>
	
<%@ include file="/IncludeEnd.jsp"%>
