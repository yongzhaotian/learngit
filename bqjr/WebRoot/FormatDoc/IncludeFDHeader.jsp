
<%!
	/*
	函数描述：通过相应的参数设置输入界面的展现形式
	参数说明：
		String sStyle         文本框类型 0：Input 1：textarea
        String sMethodInput   传入Method的值 1:display;2:save;3:preview;4:export
        String sControlName   文本框的名称和样式
        String sContent       文本内容
    */
	public String myOutPut(String sStyle,String sMethodInput,String sControlName,String sContent){
		if(sMethodInput.equals("1")||sMethodInput.equals("2")){ 	//1:display;2:save
			if(sStyle.equals("1")) 	//need htmledit(textarea)
				return "<textarea "+sControlName+">"+sContent+"</textarea>";
			else 					//else input
				return "<input type=text "+sControlName+" value='"+sContent+"' >";
		}else													//3:preview;4:export
			return sContent;
	}
	
	public String getUnitData(String unitname,String[][] data){
		for(int i=0;i<data.length;i++){
			if(data[i][0].equals(unitname)){
				return data[i][1];
			}
		}
		return "";
	}
	
	/*
	函数描述：通过相应的参数设置是否显示提示信息项
	参数说明：
        String sMethodInput   传入Method的值 1:display;2:save;3:preview;4:export
    */
	public String myShowTips(String sMethodInput){
		if(sMethodInput.equals("1")) 	//1:display
			return " style='display:block' ";
		else													
			return " style='display:none' ";
	}	
%>

<%   

	//必须的参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); 
	String sDocID = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo")); 
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
	String sAttribute = DataConvert.toRealString(iPostChange,(String)request.getParameter("Attribute"));
	if(sAttribute == null) sAttribute = " ";
	//可选的参数
	String sMethod = DataConvert.toRealString(iPostChange,(String)request.getParameter("Method")); //1:display;2:save;3:preview;4:export
	String sFirstSection = DataConvert.toRealString(iPostChange,(String)request.getParameter("FirstSection")); //判断是否为报告的第一页,1:表示文件的第一段，0:否
	if(sMethod==null) sMethod = "1";
	if(sFirstSection==null)  sFirstSection = "0"; //标记为空，则说明非首尾页

	String sReportData="";
	String sDelim = "　";
	
	//获得输入内容

	String sDescribeCount = "";
	String sUpdate0 = "";
	if(sMethod.equals("2")||sMethod.equals("5")){  //save,autosave
		sReportData="";
		for(Enumeration enumeration = request.getParameterNames(); enumeration.hasMoreElements();){
			String sParaName = (String)enumeration.nextElement();
			if(sParaName.startsWith("describe")){
				String sParaValue = DataConvert.toRealString(iPostChange,(String)request.getParameter(sParaName));
				if(sParaValue==null) sParaValue="";
				if(sParaValue.trim().equals("")) {
					sParaValue = "none";
				}else{
					sReportData += sParaName+"@"+sParaValue.replaceAll(sDelim, " ")+sDelim;
				}
			}	
		}
			
		byte abyte0[] = sReportData.getBytes("GBK");
		
		sUpdate0 = " update FORMATDOC_DATA set HtmlData=?,ContentLength=?,UPDATEDATE='"+StringFunction.getToday()+"' "+
							" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ";
			
		PreparedStatement pre0 = Sqlca.getConnection().prepareStatement(sUpdate0);
		pre0.clearParameters();
		pre0.setBinaryStream(1, new ByteArrayInputStream(abyte0,0,abyte0.length), abyte0.length);
		pre0.setInt(2, abyte0.length);
		pre0.executeUpdate();
		pre0.close();	   				
	}else{					//1:display,or 3:preview,or 4:export
		String tempSql = "select ContentLength from FORMATDOC_DATA where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType ";
		ASResultSet rs1 = Sqlca.getResultSet(new SqlObject(tempSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType));
		if(rs1.next()){
			int iContentLength=rs1.getInt("ContentLength");
			if (iContentLength>0){
				byte bb[] = new byte[iContentLength];
				int iByte = 0;		
				sReportData = "";
				java.io.InputStream inStream = null;
				
				tempSql = "select HtmlData from FORMATDOC_DATA where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType ";
				ASResultSet rs2 = Sqlca.getResultSet(new SqlObject(tempSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType));
				if(rs2.next())
					inStream = rs2.getBinaryStream("HtmlData");
				while(true){
					iByte = inStream.read(bb);
					if(iByte<=0)
						break;
					sReportData = sReportData + new String(bb, "GBK");
				}
				rs2.getStatement().close();	
			}
		}
		rs1.getStatement().close();			
	}
	
	
	//分解数据库中保存的内容到各个输入框中
	String[][] sData = new String[iDescribeCount][2];
	for (int ii=0;ii<iDescribeCount;ii++) {
		sData[ii][0] = "";
		sData[ii][1] = "";
	}
	StringTokenizer st = new StringTokenizer(sReportData,sDelim);
	for (int ii=0;st.hasMoreTokens()&&ii<iDescribeCount;ii++) {
		String stemp=st.nextToken(sDelim);if(stemp==null) stemp="";
		if(stemp.indexOf("@")>=0){
			sData[ii][0]=stemp.substring(0,stemp.indexOf("@"));
			sData[ii][1]=stemp.substring(stemp.indexOf("@")+1);
			if (sData[ii][1].equals("none")) sData[ii][1]="";
		}
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
			{"true","","Button","保存","保存","my_save()",sResourcesPath},
			//{"true","","Button","预览","预览","my_preview()",sResourcesPath}
			//,{"true","","Button","导出","导出","my_export()",sResourcesPath}  
		};
	%> 
<%/*~END~*/%>
