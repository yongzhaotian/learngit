<%@page import="com.amarsoft.are.jbo.ql.Function"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.edoc.EDocument"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   fmwu  2008/01/02
		Tester: 
  		Content: 生成电子合同 
  		Input Param:
  			ObjectNo:文档编号	
  		Output param:
  		History Log:
			
	*/
	%>
<%/*~END~*/%>

<%!
String getFullPath(String sDocNo, String sFileName, String sFileSavePath, ServletContext sc) {
	java.io.File dFile = null;
	String sBasePath = sFileSavePath;
	if (!sFileSavePath.equals("")) {
		try {
			dFile = new java.io.File(sBasePath);
			if (!dFile.exists()) {
				dFile.mkdirs();
				System.out.println("！！保存附件文件路径[" + sFileSavePath + "]创建成功！！");
			}
		} catch (Exception e) {
			sBasePath = sc.getRealPath("/WEB-INF/Upload");
			System.out.println("！！保存附件文件路径[" + sFileSavePath + "]无法创建,文件保存在缺省目录[" + sBasePath + "]！");
		}
	} else {
		sBasePath = sc.getRealPath("/WEB-INF/Upload");
		System.out.println("！！保存附件文件路径没有定义,文件保存在缺省目录[" + sBasePath + "]！");
	}

	String sFullPath = sBasePath + getMidPath(sDocNo);
	try {
		dFile = new java.io.File(sFullPath);
		if (!dFile.exists()) {
			dFile.mkdirs();
		}
	} catch (Exception e) {   
		System.out.println("！！保存附件文件完整路径[" + sFullPath + "]无法创建！");
	}

	String sFullName = sBasePath + getFilePath(sDocNo, sFileName);
	return sFullName;
}

//根据相关参数得到中间部分的路径
String getMidPath(String sDocNo) {
	return "/EDOC/"+sDocNo.substring(0,6);
}

//根据相关参数得到完整文件名
String getFilePath(String sDocNo, String sShortFileName) {
	String sFileName;
	sFileName = getMidPath(sDocNo);
	sFileName = sFileName + "/" + sDocNo + "_" + sShortFileName;
	return sFileName;
}
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
<%
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
		String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
		String sEDocNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocNo"));
		if (sEDocNo == null || "".equals(sEDocNo)) {
			String sTypeNo = Sqlca.getString("Select BusinessType from BUSINESS_CONTRACT where SerialNo='"+sObjectNo+"'");
			sEDocNo = Sqlca.getString("select Attribute25 from business_type where TypeNo='"+sTypeNo+"'");
		}
		
		//得到模板文件路径
		String sFileName = Sqlca.getString("select FileNameFmt from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
		String sFullPathFmt = Sqlca.getString("select FullPathFmt from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
		String sFullPathDef = Sqlca.getString("select FullPathDef from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");

		//如果不存在记录，则新增记录
		String sSerialNo = Sqlca.getString("SELECT SerialNo FROM EDOC_PRINT where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' and EDocNo='"+sEDocNo+"'");
		if (sSerialNo == null) {
			sSerialNo = DBKeyHelp.getSerialNo("EDOC_PRINT","SerialNo",Sqlca);
			Sqlca.executeSQL("insert into EDOC_PRINT(SerialNo,ObjectNo,ObjectType,EDocNo) values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sEDocNo+"')");
		}
   		java.util.Date dateNow = new java.util.Date();
   		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
   		String sUpdateTime=sdfTemp.format(dateNow);

   		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		String sFullPathOut = getFullPath(sSerialNo, sFileName, sFileSavePath, application);

		EDocument edoc = new EDocument(sFullPathFmt,sFullPathDef);
   		HashMap map = new HashMap();
		map.put("SerialNo", sObjectNo);
		System.out.println("===================="+sFullPathOut);
		edoc.saveDoc(sFullPathOut,map,Sqlca);
		long lFileLen = new java.io.File(sFullPathOut).length();
		System.out.println("--------------------"+lFileLen);
		String sSql = "Update EDOC_PRINT set FullPath='"+sFullPathOut+"',ContentType='application/msword',ContentLength='"+lFileLen+"',InputTime='"+sUpdateTime+"',InputOrg='"+CurUser.getOrgID()+"',InputUser='"+CurUser.getUserID()+"' where SerialNo='"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
%>		
<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
    alert("生成电子合同成功！");
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
