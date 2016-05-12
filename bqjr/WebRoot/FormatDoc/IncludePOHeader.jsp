<%!
	/*
	函数描述：通过相应的参数设置输入界面的展现形式
	参数说明：
		String sStyle         文本框类型 0：Input 1：textarea
        String sMethodInput   传入Method的值 1:display;2:save;3:preview;4:export
        String sControlName   文本框的名称和样式
        String sContent       文本内容
    */
	//根据出账流水号取得保证人名称
	public String getGuarantyNameByBP(String sSerailNo,Transaction Sqlca) throws Exception {
		String sSql = "select ContractSerialNo from BUSINESS_PUTOUT where SerialNo ='"+sSerailNo+"'";
		String sContractSerialNo = Sqlca.getString(sSql);
		return getGuarantyName(sContractSerialNo,Sqlca);
	}
	
	//根据合同流水号取得保证人名称
	String getGuarantyName(String sSerailNo,Transaction Sqlca) throws Exception {
		String sSql = " select GC.GuarantorID||','||GC.GuarantorName from Guaranty_Contract GC,Contract_Relative CR where CR.ObjectNo=GC.SerialNo "+
			   " and GC.Guarantytype like '0100%' and CR.ObjectType = 'GUARANTY_CONTRACT' and CR.SerialNo = '"+sSerailNo+"'  and GC.Guarantorid<>'' and GC.Guarantorid is not null "+
			   " order by GC.GuarantorID ";
		return DataConvert.toString(Sqlca.getString(sSql));
	}
%>

<%   
	//必须的参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sDocID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 
	
	//可选的参数
	String sMethod = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Method")); //1:display;2:save;3:preview;4:export
	String sFirstSection = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FirstSection")); //判断是否为报告的第一页,1:表示文件的第一段，0:否
	String sEndSection = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EndSection")); 
	if(sMethod==null) sMethod = "1";
	if(sFirstSection==null)  sFirstSection = "0"; //标记为空，则说明非首尾页
	if(sEndSection==null)  sEndSection = "0"; //标记为空，则说明非首尾页  added by yzheng

	String sReportData="";
	String sDelim = "　";
	//out.println(" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ");
	//获得输入内容

	String sDescribeCount = "";
	int ii = 1;
	String sUpdate0 = "";
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
			//{"true","","Button","保存","保存","my_save()",sResourcesPath},
			{"true","","Button","预览","预览","my_preview()",sResourcesPath}
			//,{"true","","Button","导出","导出","my_export()",sResourcesPath}  
		};

	%> 
<%/*~END~*/%>