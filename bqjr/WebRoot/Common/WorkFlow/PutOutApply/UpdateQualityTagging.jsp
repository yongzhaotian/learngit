<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Author:   rqiao  20150413
		Content:CCS-483 PRM-177 销售代表增加查询合同功能
		Input Param:
	 */
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 		//业务流水号
	String sQualityGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("QualityGrade")); 	//质量等级
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sQualityGrade == null) sQualityGrade = "";
	
	ASResultSet rs = null;
	String sQualityTagging = "";//质量标注
	String sQualityTaggingList = "";//质量标注统计
	//根据质量等级统计查询质量标注信息
	String sSql = "select QualityTagging from record_Data where artificialno = '"+sSerialNo+"' and QualityGrade = '"+sQualityGrade+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sQualityTagging = rs.getString("QualityTagging");
		if(null == sQualityTagging) sQualityTagging = "";
		if(!"".equals(sQualityTagging))//累计质量标注信息
		{
			sQualityTaggingList += sQualityTagging +",";
		}
	}
	rs.getStatement().close();
	
	//将质量标注更新到合同表中
	String sSql_Update = "Update Business_Contract set QualityTagging = '"+sQualityTaggingList+"' where SerialNo = '"+sSerialNo+"'";
	Sqlca.executeSQL(sSql_Update);
	
	
	
%><%@ include file="/IncludeEndAJAX.jsp"%>