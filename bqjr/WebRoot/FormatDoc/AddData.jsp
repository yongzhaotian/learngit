<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: 插入数据到FORMATDOC_DATA
		Input Param:
			DocID:    formatdoc_catalog中的文档类别（调查报告，贷后检查报告，...)
			ObjectNo：业务流水号
	 */
	%>
<%/*~END~*/%>

<%!
	//获得机构所在的分行
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString(" select OrgLevel from ORG_INFO where OrgID = '"+sOrgID+"' "));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString(" select RelativeOrgID from ORG_INFO where OrgID = '"+sOrgID+"' ");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString(" select OrgLevel from ORG_INFO where OrgID = '"+sOrgID+"' "));
		}
		return sOrgID;
	}
%>

<% 	
	//获得组件参数	
	String sDocID    = CurPage.getParameter("DocID");    		//调查报告文档类别
	String sObjectNo = CurPage.getParameter("ObjectNo"); 		//业务流水号
	String sObjectType = CurPage.getParameter("ObjectType"); 	//对象类型
	String sOrgID = getBranchOrgID(CurOrg.getOrgID(),Sqlca);
	//定义变量	
	String sGoToUrl = "";  //用于存放转向的文件路径

	//数组化保证方式参数、履约保险保证参数、保函保证参数、保证金保证参数、抵押物参数、质物参数
	String[] sWarrantor=null,sWarrantorName=null,sWarrantor1=null,sWarrantorName1=null,sWarrantor2=null,sWarrantorName2=null,sWarrantor3=null,sWarrantorName3=null;
	String[] sDiYa=null,sDiYaName=null,sZhiYa=null,sZhiYaName=null,sPutout=null,sPutoutName=null,sPutoutNo=null;
	int iWarrantor=0,iWarrantor1=0,iWarrantor2=0,iWarrantor3=0,iDiYa=0,iZhiYa=0,iPutout=0;
	
	String sSql = "";
	ASResultSet rsData = null;

	//取得该笔申请的客户代码
	String sCustomerID = "",sCustomerName = "",sObjectNo1 = "";;
	if(sDocID.equals("11")){
		sSql = " select ObjectNo from FLOW_TASK where SerialNo = '"+sObjectNo+"'";
		rsData = Sqlca.getResultSet(sSql);
		if(rsData.next()) sObjectNo1 = rsData.getString(1);
		rsData.getStatement().close();
		sSql = " select CustomerID,CustomerName from BUSINESS_APPLY where SerialNo = '"+sObjectNo1+"'";
	}else{
		sSql = " select CustomerID,CustomerName from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
		sObjectNo1 = sObjectNo;
	}
	rsData = Sqlca.getResultSet(sSql);
	if(rsData.next()){
		sCustomerID = rsData.getString(1);
		sCustomerName = rsData.getString(2);
	}
	rsData.getStatement().close();
	
	String sTemp = "";
	StringTokenizer st = null;
	int i =0;
	
	//保证方式
	sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT " +
			" where SerialNo in (select ObjectNo  from APPLY_RELATIVE "+
			" where ObjectType = 'GuarantyContract' and SerialNo = '"+sObjectNo1+"') "+
			" and GuarantyType = '010010' ";
	rsData = Sqlca.getResultSet(sSql);
	sTemp = "";
	String sGuarantorID = "";
	String sGuarantorName = "";
	while(rsData.next()){
		sGuarantorID = DataConvert.toString(rsData.getString(1));
		if(sGuarantorID == null || sGuarantorID.length() == 0) sGuarantorID = "X";
		
		sGuarantorName = DataConvert.toString(rsData.getString(2));
		sTemp += sGuarantorID+"@";  
		sTemp += sGuarantorName+"@";  
	}
	rsData.getStatement().close();	

	st = new StringTokenizer(sTemp,"@");
	iWarrantor = st.countTokens()/2;
	sWarrantor = new String[iWarrantor];
	sWarrantorName = new String[iWarrantor];	
	i = 0;
	while(st.hasMoreTokens()){
		sWarrantor[i] = st.nextToken();
		sWarrantorName[i] = st.nextToken();
		i++;
	}	
		
	//履约保险保证方式
	sSql = 	" select SerialNo,GuarantorName from GUARANTY_CONTRACT " +
			" where SerialNo in (select objectno  from APPLY_RELATIVE "+
			" where ObjectType = 'GuarantyContract' and SerialNo = '"+sObjectNo1+"') "+
			" and GuarantyType = '010020' ";
	rsData = Sqlca.getResultSet(sSql);
	sTemp = "";
	while(rsData.next()){
		sTemp += DataConvert.toString(rsData.getString(1))+"@";  
		sTemp += DataConvert.toString(rsData.getString(2))+"@";  
	}
	rsData.getStatement().close();		

	st = new StringTokenizer(sTemp,"@");
	iWarrantor1 = st.countTokens()/2;
	sWarrantor1 = new String[iWarrantor1];
	sWarrantorName1 = new String[iWarrantor1];	
	i = 0;
	while(st.hasMoreTokens()){
		sWarrantor1[i] = st.nextToken();
		sWarrantorName1[i] = st.nextToken();
		i++;
	}	

	//保函保证方式
	sSql = 	" select SerialNo,GuarantorName from GUARANTY_CONTRACT " +
			" where SerialNo in (select objectno  from APPLY_RELATIVE "+
			" where ObjectType = 'GuarantyContract' and SerialNo = '"+sObjectNo1+"') "+
			" and GuarantyType = '010030' ";
	rsData = Sqlca.getResultSet(sSql);
	sTemp = "";
	while(rsData.next()){
		sTemp += DataConvert.toString(rsData.getString(1))+"@";  
		sTemp += DataConvert.toString(rsData.getString(2))+"@";  
	}
	rsData.getStatement().close();		

	st = new StringTokenizer(sTemp,"@");
	iWarrantor2 = st.countTokens()/2;
	sWarrantor2 = new String[iWarrantor2];
	sWarrantorName2 = new String[iWarrantor2];	
	i = 0;
	while(st.hasMoreTokens()){
		sWarrantor2[i] = st.nextToken();
		sWarrantorName2[i] = st.nextToken();
		i++;
	}
		
	//add by fhuang 增加保证金保证方式
	sSql = 	" select SerialNo,GuarantorName from GUARANTY_CONTRACT " +
			" where SerialNo in (select objectno  from APPLY_RELATIVE "+
			" where ObjectType = 'GuarantyContract' and SerialNo = '"+sObjectNo1+"') "+
			" and GuarantyType = '010040' ";
	rsData = Sqlca.getResultSet(sSql);
	sTemp = "";
	while(rsData.next()){
		sTemp += DataConvert.toString(rsData.getString(1))+"@";  
		sTemp += DataConvert.toString(rsData.getString(2))+"@";  
	}
	rsData.getStatement().close();		

	st = new StringTokenizer(sTemp,"@");
	iWarrantor3 = st.countTokens()/2;
	sWarrantor3 = new String[iWarrantor3];
	sWarrantorName3 = new String[iWarrantor3];	
	i = 0;
	while(st.hasMoreTokens()){
		sWarrantor3[i] = st.nextToken();
		sWarrantorName3[i] = st.nextToken();
		i++;
	}
		
	//抵押物
	sSql = 	" select GuarantyID,getItemName('GuarantyList',GuarantyType) from GUARANTY_INFO where GuarantyID in ( " +
			" select GuarantyID from GUARANTY_RELATIVE where ObjectType = 'CreditApply' "+
			" and ObjectNo = '"+sObjectNo1+"' ) " +
			" and GuarantyType like '010%' ";
	rsData = Sqlca.getResultSet(sSql);
	sTemp = "";
	while(rsData.next()){
		sTemp += DataConvert.toString(rsData.getString(1))+"@";  
		sTemp += DataConvert.toString(rsData.getString(2))+"@";  
	}
	rsData.getStatement().close();		

	st = new StringTokenizer(sTemp,"@");
	iDiYa = st.countTokens()/2;
	sDiYa = new String[iDiYa];
	sDiYaName = new String[iDiYa];	
	i = 0;
	while(st.hasMoreTokens()){
		sDiYa[i] = st.nextToken();
		sDiYaName[i] = st.nextToken();
		i++;
	}	

	//质物
	sSql = 	" select GuarantyID,getItemName('GuarantyList',GuarantyType) from GUARANTY_INFO where GuarantyID in ( " +
			" select GuarantyID from GUARANTY_RELATIVE where ObjectType = 'CreditApply' "+
			" and ObjectNo = '"+sObjectNo1+"' ) " +
			" and GuarantyType like '020%' ";
	rsData = Sqlca.getResultSet(sSql);
	sTemp = "";
	while(rsData.next()){
		sTemp += DataConvert.toString(rsData.getString(1))+"@";  
		sTemp += DataConvert.toString(rsData.getString(2))+"@";  
	}
	rsData.getStatement().close();		

	st = new StringTokenizer(sTemp,"@");
	iZhiYa = st.countTokens()/2;
	sZhiYa = new String[iZhiYa];
	sZhiYaName = new String[iZhiYa];	
	i = 0;
	while(st.hasMoreTokens()){
		sZhiYa[i] = st.nextToken();
		sZhiYaName[i] = st.nextToken();
		i++;
	}
	
	//判断是否是初次生成授信调查报告，如果是，则在FORMATDOC_DATA表中插入空记录，如果不是，则不做插入操作
	int iCount = 0;
	ASResultSet rs = Sqlca.getResultSet(" select count(*) from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"'  ");
	if(rs.next())
		iCount = rs.getInt(1);
	rs.getStatement().close();	
	String sSerialNo = "";
	if(iCount==0){ //首次生成授信调查报告
		//公司客户首笔（单笔单批）授信业务调查报告,非首笔业务（单笔单批）,综合授信额度,综合授信额度项下业务,个人调查报告		
		if(sDocID.equals("01") || sDocID.equals("02") || sDocID.equals("03") || sDocID.equals("04") || sDocID.equals("05") || sDocID.equals("06") || sDocID.equals("11") || sDocID.equals("08") || sDocID.equals("09"))
		{
			String sInsertSql = "";
			sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
			//先插入一般信息：circleattr='0' or circleattr is null
			sInsertSql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,TreeNo,DocID,DirID,DirName,GuarantyNo,ContentLength,"+
						 " OrgID,UserID,InputDate,UpdateDate) "+
						 " select '"+sSerialNo+"' || FD.DirID,'"+sObjectNo+"','"+sObjectType+"',FD.DirID,FD.DocID,FD.DirID,FD.DirName,'"+sCustomerID+"',0,"+
						 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' "+
						 " from FORMATDOC_DEF FD where FD.DocID = '"+sDocID+"' and (FD.CircleAttr = '0' or FD.CircleAttr is null) ";
			Sqlca.executeSQL(sInsertSql);	

			//判断是否有相关担保信息：circleattr='1'
			if(iWarrantor>0 ||iWarrantor1>0||iWarrantor2>0||iWarrantor3>0|| iDiYa>0 || iZhiYa>0){
				sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
				sInsertSql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,TreeNo,DocID,DirID,DirName,GuarantyNo,ContentLength,"+
							 " OrgID,UserID,InputDate,UpdateDate) "+
							 " select '"+sSerialNo+"' || FD.DirID,'"+sObjectNo+"','"+sObjectType+"',FD.DirID,FD.DocID,FD.DirID,FD.DirName,'"+sCustomerID+"',0,"+
							 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' "+
							 " from FORMATDOC_DEF FD where FD.DocID = '"+sDocID+"' and FD.CircleAttr = '1' ";
				Sqlca.executeSQL(sInsertSql);				
			}
			
			java.text.DecimalFormat myFormatter = new java.text.DecimalFormat("00000000000000000000");
			
			//再插入保证人信息：circleattr='11'
			if(iWarrantor>0){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				
				//获得第一个DirID,(以后多个保证人用DirID+1来格式化)。
				sSql =	" select DocID,DirID,DirName "+
						" from FORMATDOC_DEF " +
						" where DocID = '"+sDocID+"' "+
						" and CircleAttr = '11' "+
						" order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				iFirstDir = 0;
				while(rsData.next()){
					sDocID = rsData.getString(1);
					if(iFirstDir==0) sFirstDirID = rsData.getString(2);
					
					//对每一个保证人执行插入操作
					for(i=0;i<iWarrantor;i++){
						if(iFirstDir==0) 
							sDirName = rsData.getString(3)+"-"+sWarrantorName[i];
						else			 
							sDirName = rsData.getString(3);

						sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
						sDirID = rsData.getString(2);
						sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
						
						sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
						sInsertSql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
									 " OrgID,UserID,InputDate,UpdateDate) "+
									 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sWarrantor[i]+"',0,"+
									 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
						Sqlca.executeSQL(sInsertSql);				
					}
					
					iFirstDir++;
				}
				rsData.getStatement().close();										
			}	
			
			//再插入履约保险保证信息：circleattr='111'
			if(iWarrantor1>0){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				
				//获得第一个DirID,(以后多个保证人用DirID+1来格式化)。
				sSql = " select DocID,DirID,DirName "+
					   " from FORMATDOC_DEF " +
					   " where DocID = '"+sDocID+"' "+
					   " and CircleAttr = '111' "+
					   " order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				iFirstDir = 0;
				while(rsData.next()){
					sDocID = rsData.getString(1);
					if(iFirstDir==0) sFirstDirID = rsData.getString(2);
					
					//对每一个保证人执行插入操作
					for(i=0;i<iWarrantor1;i++){
						if(iFirstDir==0) 
							sDirName = rsData.getString(3)+"-"+sWarrantorName1[i];
						else
							sDirName = rsData.getString(3);

						sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
						sDirID = rsData.getString(2);
						sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
						
						sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
						sInsertSql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
									 " OrgID,UserID,InputDate,UpdateDate) "+
									 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sWarrantor1[i]+"',0,"+
									 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
						Sqlca.executeSQL(sInsertSql);				
					}
					
					iFirstDir++;
				}
				rsData.getStatement().close();										
			}	
			
			//再插入保函保证信息：circleattr='1111'
			if(iWarrantor2>0){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				
				//获得第一个DirID,(以后多个保证人用DirID+1来格式化)。
				sSql = " select DocID,DirID,DirName "+
					   " from FORMATDOC_DEF " +
					   " where DocID = '"+sDocID+"' "+
					   " and CircleAttr = '1111' "+
					   " order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				iFirstDir = 0;
				while(rsData.next()){
					sDocID = rsData.getString(1);
					if(iFirstDir==0) sFirstDirID = rsData.getString(2);
					//对每一个保证人执行插入操作
					for(i=0;i<iWarrantor2;i++){
						if(iFirstDir==0) 
							sDirName = rsData.getString(3)+"-"+sWarrantorName2[i];
						else			 
							sDirName = rsData.getString(3);

						sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
						sDirID = rsData.getString(2);
						sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
						
						sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
						sInsertSql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
									 " OrgID,UserID,InputDate,UpdateDate) "+
									 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sWarrantor2[i]+"',0,"+
									 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
						Sqlca.executeSQL(sInsertSql);				
					}
					
					iFirstDir++;
				}
				rsData.getStatement().close();										
			}
			
			//再插入保证金保证信息：circleattr='111111'
			if(iWarrantor3>0){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				
				//获得第一个DirID,(以后多个保证人用DirID+1来格式化)。
				sSql = " select DocID,DirID,DirName "+
					   " from FORMATDOC_DEF " +
					   " where DocID = '"+sDocID+"' "+
					   " and CircleAttr = '11111' "+
					   " order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				iFirstDir = 0;
				while(rsData.next()){
					sDocID = rsData.getString(1);
					if(iFirstDir==0) sFirstDirID = rsData.getString(2);
					
					//对每一个保证人执行插入操作
					for(i=0;i<iWarrantor3;i++){
						if(iFirstDir==0) 
							sDirName = rsData.getString(3)+"-"+sWarrantorName3[i];
						else			 
							sDirName = rsData.getString(3);

						sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
						sDirID = rsData.getString(2);
						sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
						
						sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
						sInsertSql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
									 " OrgID,UserID,InputDate,UpdateDate) "+
									 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sWarrantor3[i]+"',0,"+
									 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
						Sqlca.executeSQL(sInsertSql);				
					}
					
					iFirstDir++;
				}
				rsData.getStatement().close();										
			}
			
			//再插入抵押信息：circleattr='12' 
			if(iDiYa>0){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				
				//获得第一个DirID,(以后多个diya用DirID+1来格式化)。
				sSql = " select DocID,DirID,DirName "+
					   " from FORMATDOC_DEF " +
					   " where DocID = '"+sDocID+"' "+
					   " and CircleAttr = '12' "+
					   " order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				iFirstDir = 0;
				while(rsData.next()){
					sDocID = rsData.getString(1);
					if(iFirstDir==0) sFirstDirID = rsData.getString(2);
					
					//对每一个抵押执行插入操作
					for(i=0;i<iDiYa;i++){
						if(iFirstDir==0) 
							sDirName = rsData.getString(3)+"-"+sDiYaName[i];
						else			 
							sDirName = rsData.getString(3);

						sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
						sDirID = rsData.getString(2);
						sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
						
						sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
						sInsertSql = "insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
									 " OrgID,UserID,InputDate,UpdateDate) "+
									 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sDiYa[i]+"',0,"+
									 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
						Sqlca.executeSQL(sInsertSql);				
					}
					
					iFirstDir++;
				}
				rsData.getStatement().close();										
			}	
		
			//再插入质押信息：circleattr='13'
			if(iZhiYa>0){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				
				//获得第一个DirID,(以后多个zhiya用DirID+1来格式化)。
				sSql = " select DocID,DirID,DirName "+
					   " from FORMATDOC_DEF " +
					   " where DocID = '"+sDocID+"' "+
					   " and CircleAttr = '13' "+
					   " order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				iFirstDir = 0;
				while(rsData.next()){
					sDocID = rsData.getString(1);
					if(iFirstDir==0) sFirstDirID = rsData.getString(2);
					
					//对每一个ZhiYa执行插入操作
					for(i=0;i<iZhiYa;i++){
						if(iFirstDir==0) 
							sDirName = rsData.getString(3)+"-"+sZhiYaName[i];
						else			 
							sDirName = rsData.getString(3);

						sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
						sDirID = rsData.getString(2);
						sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
						
						sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
						sInsertSql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
									 " OrgID,UserID,InputDate,UpdateDate) "+
									 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sZhiYa[i]+"',0,"+
									 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
						Sqlca.executeSQL(sInsertSql);				
					}
					
					iFirstDir++;
				}
				rsData.getStatement().close();										
			}
		} //end if(sDocID.equals("01") || sDocID.equals("02") sDocID.equals("03") sDocID.equals("04") sDocID.equals("05") sDocID.equals("06") sDocID.equals("11"))
		
		
	}else{ //end if(iCount==0)
		String sDeletesql = "";
		String sInsertsql = "";
		String sSql1="";
		String sDirid="";

		//查询是否有相关担保信息：circleattr='1'
		sSql1="select Dirid from FORMATDOC_DATA where DocID= '"+sDocID+"' and ObjectNo='"+sObjectNo+"'"+
				" and Dirid=(select Dirid from FORMATDOC_DEF where DocID= '"+sDocID+"' and circleattr='1')";
				sDirid=Sqlca.getString(sSql1);
		if(sDirid==null)sDirid="";
		if(sDirid.equals("")){
			//插入是否有相关担保信息
			if(iWarrantor>0 ||iWarrantor1>0||iWarrantor2>0||iWarrantor3>0|| iDiYa>0 || iZhiYa>0){
				sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
				sInsertsql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,TreeNo,DocID,DirID,DirName,GuarantyNo,ContentLength,"+
						" OrgID,UserID,InputDate,UpdateDate) "+
						" select '"+sSerialNo+"' || FD.DirID,'"+sObjectNo+"','"+sObjectType+"',FD.DirID,FD.DocID,FD.DirID,FD.DirName,'"+sCustomerID+"',0,"+
						" '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' "+
						" from FORMATDOC_DEF FD where FD.DocID = '"+sDocID+"' and FD.CircleAttr = '1' ";
				Sqlca.executeSQL(sInsertsql);				
			}
		}

		java.text.DecimalFormat myFormatter = new java.text.DecimalFormat("00000000000000000000");
		//保证方式
		
		sSql = " select distinct(GuarantyNo) from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and DirID = '0601' ";
		String[] sGuarantyNo = null;
		rsData = Sqlca.getResultSet(sSql);
		sTemp = "";
		while(rsData.next()){
			sTemp += rsData.getString(1)+",";
		}
		rsData.getStatement().close();
		
		sGuarantyNo = sTemp.split(",");
		int j = 0;
		//如果有删除担保，则需要删除FORMAT_DATA中与之对应的数据
		for(i=0;i<sGuarantyNo.length;i++){
			for(j=0;j<iWarrantor;j++){
				if(sGuarantyNo[i].equals(sWarrantor[j])) break;
			}
			
			if(j == iWarrantor){
				sDeletesql = " delete from FORMATDOC_DATA where GuarantyNo = '"+sGuarantyNo[i]+"' ";
				Sqlca.executeSQL(sDeletesql);
			}
		}
		
		//添加
		for(i=0;i<iWarrantor;i++){
			for(j=0;j<sGuarantyNo.length;j++){
				if(sWarrantor[i].equals(sGuarantyNo[j])) break;
			}
			
			if(j == sGuarantyNo.length){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				sSql = " select Treeno from FORMATDOC_DATA where objectno = '"+sObjectNo+"' and (TreeNo like '060_' or TreeNo like '061_') order by TreeNo desc ";
				rsData = Sqlca.getResultSet(sSql);
				if(rsData.next()) sTemp = rsData.getString(1);
				if(sTemp == null || sTemp.length()==0) sTemp = "0600";
				rsData.getStatement().close();
				//int index = Integer.valueOf(sTemp.substring(3,4)).intValue()+1;
				//if(index<10)
				//	sTemp = sTemp.substring(0,3)+index;
				//else
				//	sTemp = sTemp.substring(0,2)+index;
				int index = Integer.valueOf(sTemp.substring(2,4)).intValue()+1;
				if(index<100){
					if(index < 10){
						sTemp = sTemp.substring(0,2)+"0"+index;
					}else{
						sTemp = sTemp.substring(0,2)+index;
					}
				}
					
				//获得第一个DirID,(以后多个保证人用DirID+1来格式化)。
				sSql = " select DocID,DirID,DirName from FORMATDOC_DEF " +
					   " where DocID = '"+sDocID+"' and CircleAttr='11' order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				while(rsData.next()){
					sDocID = rsData.getString(1);
					sFirstDirID = rsData.getString(2);
					
					//对保证人执行插入操作
					if(iFirstDir==0){ 
						sDirName = rsData.getString(3)+"-"+sWarrantorName[i];
						sFirstDirID = sTemp;
					}else{
						sDirName = rsData.getString(3);
						sFirstDirID = sTemp+sFirstDirID.substring(4,sFirstDirID.length());
					}

					sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+0).substring(20-sFirstDirID.length());
					sDirID = rsData.getString(2);
					sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
					
					sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
					System.out.println(sWarrantor[i]+"~~~~~~~~~~~~~~~~~");
					sInsertsql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
								 " OrgID,UserID,InputDate,UpdateDate) "+
								 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sWarrantor[i]+"',0,"+
								 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
					Sqlca.executeSQL(sInsertsql);				
					
					iFirstDir++;
				}
				rsData.getStatement().close();	
			}
		}
		
		sDeletesql = " delete from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '062%'";
		Sqlca.executeSQL(sDeletesql);
		sDeletesql = " delete from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '064%'";
		Sqlca.executeSQL(sDeletesql);
		
		//再插入履约保险保证信息：circleattr='111'
		if(iWarrantor1>0){
			String sFirstDirID = "";
			String sReplaceNo = "";
			String sDirID = "";
			String sDirName = "";
			String sNo = "";
			int iFirstDir = 0;
			
			//获得第一个DirID,(以后多个保证人用DirID+1来格式化)。
			sSql = " select DocID,DirID,DirName "+
				   " from FORMATDOC_DEF " +
				   " where DocID = '"+sDocID+"' "+
				   " and CircleAttr = '111' "+
				   " order by DirID ";
			rsData = Sqlca.getResultSet(sSql);				
			iFirstDir = 0;
			while(rsData.next()){
				sDocID = rsData.getString(1);
				if(iFirstDir==0) sFirstDirID = rsData.getString(2);
				
				//对每一个保证人执行插入操作
				for(i=0;i<iWarrantor1;i++){
					if(iFirstDir==0) 
						sDirName = rsData.getString(3)+"-"+sWarrantorName1[i];
					else			 
						sDirName = rsData.getString(3);

					sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
					sDirID = rsData.getString(2);
					sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
					
					sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
					sInsertsql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
								 " OrgID,UserID,InputDate,UpdateDate) "+
								 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sWarrantor1[i]+"',0,"+
								 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
					Sqlca.executeSQL(sInsertsql);				
				}
				
				iFirstDir++;
			}
			rsData.getStatement().close();										
		}	
		
		//再插入保函保证信息：circleattr='1111'
		if(iWarrantor2>0){
			String sFirstDirID = "";
			String sReplaceNo = "";
			String sDirID = "";
			String sDirName = "";
			String sNo = "";
			int iFirstDir = 0;
			
			//获得第一个DirID,(以后多个保证人用DirID+1来格式化)。
			sSql = " select DocID,DirID,DirName "+
				   " from FORMATDOC_DEF " +
				   " where DocID = '"+sDocID+"' "+
				   " and CircleAttr = '1111' "+
				   " order by DirID ";
			rsData = Sqlca.getResultSet(sSql);				
			iFirstDir = 0;
			while(rsData.next()){
				sDocID = rsData.getString(1);
				if(iFirstDir==0) sFirstDirID = rsData.getString(2);
				
				//对每一个保证人执行插入操作
				for(i=0;i<iWarrantor2;i++){
					if(iFirstDir==0) 
						sDirName = rsData.getString(3)+"-"+sWarrantorName2[i];
					else			 
						sDirName = rsData.getString(3);

					sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+i).substring(20-sFirstDirID.length());
					sDirID = rsData.getString(2);
					sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
					
					sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
					sInsertsql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
								 " OrgID,UserID,InputDate,UpdateDate) "+
								 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sWarrantor2[i]+"',0,"+
								 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
					Sqlca.executeSQL(sInsertsql);				
				}
				
				iFirstDir++;
			}
			rsData.getStatement().close();										
		}
		
		
		//插入抵押信息: circleattr='12' 
		sSql = " select distinct(GuarantyNo) from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and DirID = '0660' ";
		String[] sGuarantyNo1 = null;
		rsData = Sqlca.getResultSet(sSql);
		sTemp = "";
		while(rsData.next()){
			sTemp += rsData.getString(1)+",";
		}
		rsData.getStatement().close();
		
		sGuarantyNo1 = sTemp.split(",");
		j = 0;
		//删除
		for(i=0;i<sGuarantyNo1.length;i++){
			for(j=0;j<iDiYa;j++){
				if(sGuarantyNo1[i].equals(sDiYa[j])) break;
			}
			
			if(j == iDiYa){
				sDeletesql = " delete from FORMATDOC_DATA where GuarantyNo = '"+sGuarantyNo1[i]+"' ";
				Sqlca.executeSQL(sDeletesql);
			}
		}
		
		//添加
		for(i=0;i<iDiYa;i++){
			for(j=0;j<sGuarantyNo1.length;j++){
				if(sDiYa[i].equals(sGuarantyNo1[j])) break;
			}
			
			if(j == sGuarantyNo1.length){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				sSql = " select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and (TreeNo like '066_' or TreeNo like '067_') order by TreeNo desc ";
				rsData = Sqlca.getResultSet(sSql);
				if(rsData.next()) sTemp = rsData.getString(1);
				if(sTemp == null || sTemp.length()==0) sTemp = "0660";
				rsData.getStatement().close();
				//int index = Integer.valueOf(sTemp.substring(3,4)).intValue()+1;
				//if(index<10)
				//	sTemp = sTemp.substring(0,3)+index;
				//else
				//	sTemp = sTemp.substring(0,2)+index;
				int index = Integer.valueOf(sTemp.substring(2,4)).intValue()+1;
				if(index<100)
					sTemp = sTemp.substring(0,2)+index;
				//获得第一个DirID
				sSql = " select DocID,DirID,DirName from FORMATDOC_DEF " +
					   " where DocID = '"+sDocID+"' and CircleAttr = '12' order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				if(rsData.next()){
					sDocID = rsData.getString(1);
					sFirstDirID = rsData.getString(2);
					
					//对保证人执行插入操作
					if(iFirstDir==0){
						sDirName = rsData.getString(3)+"-"+sDiYaName[i];
						sFirstDirID = sTemp;
					}

					sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+0).substring(20-sFirstDirID.length());
					sDirID = rsData.getString(2);
					sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());	
					
					sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
					sInsertsql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
								 " OrgID,UserID,InputDate,UpdateDate) "+
								 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sDiYa[i]+"',0,"+
								 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
					Sqlca.executeSQL(sInsertsql);				
				}
				rsData.getStatement().close();	
			}
		}
		
		
		//质押信息: circleattr='13' 
		sSql = " select distinct(GuarantyNo) from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and DirID = '0680' ";
		String[] sGuarantyNo2 = null;
		rsData = Sqlca.getResultSet(sSql);
		sTemp = "";
		while(rsData.next()){
			sTemp += rsData.getString(1)+",";
		}
		rsData.getStatement().close();
		
		sGuarantyNo2 = sTemp.split(",");
		j = 0;
		//删除
		for(i=0;i<sGuarantyNo2.length;i++){
			for(j=0;j<iZhiYa;j++){
				if(sGuarantyNo2[i].equals(sZhiYa[j])) break;
			}
			
			if(j == iZhiYa){
				sDeletesql = " delete from FORMATDOC_DATA where GuarantyNo = '"+sGuarantyNo2[i]+"' ";
				Sqlca.executeSQL(sDeletesql);
			}
		}
		
		//添加
		for(i=0;i<iZhiYa;i++){
			for(j=0;j<sGuarantyNo2.length;j++){
				if(sZhiYa[i].equals(sGuarantyNo2[j])) break;
			}
			
			if(j == sGuarantyNo2.length){
				String sFirstDirID = "";
				String sReplaceNo = "";
				String sDirID = "";
				String sDirName = "";
				String sNo = "";
				int iFirstDir = 0;
				sSql = " select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and (TreeNo like '068_' or TreeNo like '069_') order by TreeNo desc";
				rsData = Sqlca.getResultSet(sSql);
				if(rsData.next()) sTemp = rsData.getString(1);
				if(sTemp == null || sTemp.length()==0) sTemp = "0680";
				rsData.getStatement().close();
				//int index = Integer.valueOf(sTemp.substring(3,4)).intValue()+1;
				//if(index<10)
				//	sTemp = sTemp.substring(0,3)+index;
				//else
				//	sTemp = sTemp.substring(0,2)+index;
				int index = Integer.valueOf(sTemp.substring(2,4)).intValue()+1;
				if(index<100)
					sTemp = sTemp.substring(0,2)+index;
				//获得第一个DirID
				sSql = " select DocID,DirID,DirName from FORMATDOC_DEF " +
					 " where DocID = '"+sDocID+"' and CircleAttr = '13' order by DirID ";
				rsData = Sqlca.getResultSet(sSql);				
				if(rsData.next()){
					sDocID = rsData.getString(1);
					sFirstDirID = rsData.getString(2);
					
					//对保证人执行插入操作
					if(iFirstDir==0){ 
						sDirName = rsData.getString(3)+"-"+sZhiYaName[i];
						sFirstDirID = sTemp;
					}

					sReplaceNo = myFormatter.format(Integer.valueOf(sFirstDirID).intValue()+0).substring(20-sFirstDirID.length());
					sDirID = rsData.getString(2);
					sNo = sReplaceNo+sDirID.substring(sReplaceNo.length());						
					
					sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_DATA","SerialNo",Sqlca);
					sInsertsql = " insert into FORMATDOC_DATA(SerialNo,ObjectNo,ObjectType,DocID,DirID,DirName,TreeNo,GuarantyNo,ContentLength,"+
								 " OrgID,UserID,InputDate,UpdateDate) "+
								 " values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sDocID+"','"+sDirID+"','"+sDirName+"','"+sNo+"','"+sZhiYa[i]+"',0,"+
								 " '"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' )";
					Sqlca.executeSQL(sInsertsql);				
				}
				rsData.getStatement().close();	
			}
		}
	}//end if(iCount>0)
	String sDirID = "";
	String[] sTreeNo = null;
	String[] sDirName = null;
	sTemp = " ";
	sSql = " select DefaultValue from FORMATDOC_PARA where OrgID = '"+sOrgID+"' and DocID = '"+sDocID+"'"; 
	rsData = Sqlca.getASResultSet(sSql);
	if(rsData.next()) sTemp = rsData.getString(1);
	if((sTemp == null) || (sTemp.length() == 0)) sTemp = "   ";
	rsData.getStatement().close();
	
	st = new StringTokenizer(sTemp,",");
	while(st.hasMoreTokens()){
		sDirID += "'"+st.nextToken()+"',";
	}
	sDirID = sDirID.substring(0,sDirID.length()-1);
	
	sSql = " select FD.TreeNo,FD.DirName from FORMATDOC_DATA FD,FORMATDOC_DEF FF where FD.DirID = FF.DirID and FF.DocID = '"+sDocID+"' and FF.DirID IN ("+sDirID+") and FF.Attribute1 = '1' and FD.ObjectNo = '"+sObjectNo+"' ";
	rsData = Sqlca.getASResultSet(sSql);
	sTemp = "";
	while(rsData.next()){
		sTemp += rsData.getString(1)+"@";  
		sTemp += rsData.getString(2)+"@";  
	}
	rsData.getStatement().close();		
	
	st = new StringTokenizer(sTemp,"@");
	iCount = st.countTokens()/2;
	sTreeNo = new String[iCount];
	sDirName = new String[iCount];
	i = 0;
	while(st.hasMoreTokens()){
		sTreeNo[i] = st.nextToken();
		sDirName[i] = st.nextToken();
		i++;
	}
	String sUpdateSql = "";
	for(i=0;i<iCount;i++){
		if(!sDirName[i].substring(sDirName[i].length()-4,sDirName[i].length()).equals("(自动)")&&!sDirName[i].substring(sDirName[i].length()-4,sDirName[i].length()).equals("(必填)"))
		{
			sUpdateSql = " Update FORMATDOC_DATA Set DirName = '"+sDirName[i]+"(必填)' where DocID = '"+sDocID+"' and TreeNo = '"+sTreeNo[i]+"' and ObjectNo = '"+sObjectNo+"' ";
			Sqlca.executeSQL(sUpdateSql);
		}
	}	
	//给要转向的文件路径变量赋值
	sGoToUrl = "/FormatDoc/Report";	
%>

<script type="text/javascript">
	if("<%=sDocID%>"=="01" || "<%=sDocID%>"=="02" || "<%=sDocID%>"=="03" || "<%=sDocID%>"=="04" || "<%=sDocID%>"=="05" || "<%=sDocID%>"=="06" || "<%=sDocID%>"=="08" || "<%=sDocID%>"=="09")
	{
		self.returnValue="<%=sGoToUrl%>/InvestigateView.jsp?DocID=<%=sDocID%>&ObjectNo=<%=sObjectNo1%>&ObjectType=<%=sObjectType%>&CustomerID=<%=sCustomerID%>&rand="+randomNumber();
    	self.close();	
	}else if("<%=sDocID%>"=="11"){
		self.returnValue="<%=sGoToUrl%>/InvestigateView.jsp?DocID=<%=sDocID%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&rand="+randomNumber();
    	self.close();
	}else{
		alert("本类型授信调查报告还未实现！");
		self.close();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>