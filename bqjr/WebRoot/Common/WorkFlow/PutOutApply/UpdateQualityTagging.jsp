<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Author:   rqiao  20150413
		Content:CCS-483 PRM-177 ���۴������Ӳ�ѯ��ͬ����
		Input Param:
	 */
	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 		//ҵ����ˮ��
	String sQualityGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("QualityGrade")); 	//�����ȼ�
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sQualityGrade == null) sQualityGrade = "";
	
	ASResultSet rs = null;
	String sQualityTagging = "";//������ע
	String sQualityTaggingList = "";//������עͳ��
	//���������ȼ�ͳ�Ʋ�ѯ������ע��Ϣ
	String sSql = "select QualityTagging from record_Data where artificialno = '"+sSerialNo+"' and QualityGrade = '"+sQualityGrade+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sQualityTagging = rs.getString("QualityTagging");
		if(null == sQualityTagging) sQualityTagging = "";
		if(!"".equals(sQualityTagging))//�ۼ�������ע��Ϣ
		{
			sQualityTaggingList += sQualityTagging +",";
		}
	}
	rs.getStatement().close();
	
	//��������ע���µ���ͬ����
	String sSql_Update = "Update Business_Contract set QualityTagging = '"+sQualityTaggingList+"' where SerialNo = '"+sSerialNo+"'";
	Sqlca.executeSQL(sSql_Update);
	
	
	
%><%@ include file="/IncludeEndAJAX.jsp"%>