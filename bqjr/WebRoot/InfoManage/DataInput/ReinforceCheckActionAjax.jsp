<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: slliu  2005-02-23 
		Tester:
		Content: 补登完成校验
		Input Param:                                                           
    			   
		Output param:                                                          
			        
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%!
	//判断客户信息是否完整并作提示信息
	String getCustomerMesssage(String sMainTable,String sObjectNo,Transaction Sqlca) throws Exception {
	String sMesssage = "";
	SqlObject so = null;
	String sSql = "select CustomerID from "+sMainTable+" where SerialNo=:SerialNo";
	so = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);
	String sCustomerID=Sqlca.getString(so);
	if (sCustomerID==null) sCustomerID="";

	sSql = "select TempSaveFlag from ENT_INFO where CustomerID=:CustomerID";
	so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
	String sTempSaveFlag=Sqlca.getString(so);
	if (sTempSaveFlag==null) sTempSaveFlag="";
	if (sTempSaveFlag.equals("1"))
		sMesssage += "\\n\\客户信息为暂时保存状态！请先填写客户信息并点击保存按钮！";

	//客户国标行业分类 IndustryType
	sSql = "select IndustryType from ENT_INFO where CustomerID=:CustomerID";
	so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
	String sIndustryType = Sqlca.getString(so);
	if (sIndustryType==null) sIndustryType="";
	if (sIndustryType.equals(""))
		sMesssage += "\\n\\r客户信息的国标行业分类不能为空！请先在客户信息中选择行业分类并保存！";

	//客户信用等级评估模板名称 CreditBelong
	sSql = "select CreditBelong from ENT_INFO where CustomerID=:CustomerID";
	so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
	String sCreditBelong = Sqlca.getString(so);
	if (sCreditBelong==null) sCreditBelong="";
	if (sCreditBelong.equals(""))
		sMesssage += "\\n\\r客户信息的客户信用等级评估模板不能为空！请先在客户信息中选择信用等级评估模板并保存！";
	//财务报表类型FinanceBelong
	sSql = "select FinanceBelong from ENT_INFO where CustomerID=:CustomerID";
	so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
	String sFinanceBelong = Sqlca.getString(so);
	if (sFinanceBelong==null) sFinanceBelong="";
	if (sFinanceBelong.equals(""))
		sMesssage += "\\n\\r客户信息的财务报表类型不能为空！请先在客户信息中选择财务报表类型并保存！";
	return sMesssage;
	}

	//判断暂时标志并提示信息
	String getTempSaveMesssage(String sMainTable,String sObjectNo,Transaction Sqlca) throws Exception {
	String sMesssage = "";
	String sSql = "select TempSaveFlag from "+sMainTable+" where SerialNo=:SerialNo";
	SqlObject so = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);
	String sTempSaveFlag=Sqlca.getString(so);
	if (sTempSaveFlag==null) sTempSaveFlag="";
	if (sTempSaveFlag.equals("1"))
		sMesssage += "\\n\\r补登业务信息为暂时保存状态！请先填写补登业务信息并点击保存按钮！";
	return sMesssage;
	}
%>

<html>
<head>
<title>补登完成校验 </title>
</head>


<%
	//定义变量
	ASResultSet rs = null;
	SqlObject so = null;
	String sPutOutOrgID="";
	String sVouchType="";
	String sVouchType1="";
	String sBusinessType="";
	String sFinishType ="";
	String sOccurType ="";
	
	int iCount1=0;
	int iCount6=0;
	int iCount7=0;
	int iCount8=0;
	int iCount9=0;
	
	String sSql="";
	String sExistFlag="";
	
	
	//合同流水号、客户编号、业务品种
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sCustomerID =    DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
   
	//------------------------校验合同业务基本信息是否输入完整-----------------------------------------
	//得到业务相关信息
        
	sSql = " select PutOutOrgID,VouchType,BusinessType,OccurType "+
               " from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sContractNo);
	rs = Sqlca.getASResultSet(so);
	if(rs.next())
	{
		sPutOutOrgID =  DataConvert.toString(rs.getString("PutOutOrgID"));
        sVouchType = DataConvert.toString(rs.getString("VouchType"));
        sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
        sOccurType = DataConvert.toString(rs.getString("OccurType"));
	}
	rs.getStatement().close();
	
	sBusinessType = sBusinessType.substring(0,1);
			       
			       
	if(sBusinessType.equals("5"))	//如果为授信额度，不用校验担保方式
	{
		sVouchType = "";
	}else if(sBusinessType.equals("1"))	//如果为表内业务，校验担保方式
	{
		sVouchType1 = sVouchType;
		if(sVouchType !=null && !sVouchType.equals(""))
	    {
			sVouchType = sVouchType.substring(0,3);
		}else
		{
			sVouchType = "";
		}
	}else if(sBusinessType.equals("2"))	//如果为表外业务，校验担保方式
	{    	
       if(sVouchType !=null && !sVouchType.equals(""))
       	{
       		if(!sVouchType.equals("04005"))  //不为质押—保证金
       		{
       			sVouchType = sVouchType.substring(0,3);
       		}else
       		{
       			sVouchType = "";
       		}
       	}
	}else
	{
		sVouchType = "";
	}
	       
	   
	//----------------------------如果合同的担保方式为抵质押，校验是否有抵质押合同----------------------------------------
	if(sVouchType1.equals("04005"))  //如果为质押—保证金，要求必须输入质押保证金合同
    {
      	sSql = 	" select Count(*) from CONTRACT_RELATIVE CR,GUARANTY_CONTRACT GC "+
          		" where CR.SerialNo=:CR.SerialNo "+
               	" and CR.ObjectType = 'GUARANTY_CONTRACT' "+
               	" and CR.ObjectNo = GC.SerialNo "+
               	" and GC.GuarantyType='010040' ";
        so = new SqlObject(sSql).setParameter("CR.SerialNo",sContractNo);              	
        rs = Sqlca.getASResultSet(so);
    	if(rs.next())
    	{
        	iCount6=rs.getInt(1);
    	}
    	rs.getStatement().close();
	} else
	{
		 iCount6=1;	       
	}
		
		
   	if(sVouchType !=null && !sVouchType.equals("") && (sVouchType.equals("020") || sVouchType.equals("040")))
   	{	             
       	sSql = 	" select Count(*) from CONTRACT_RELATIVE where SerialNo=:SerialNo "+
           		" and ObjectType = 'GUARANTY_CONTRACT' ";
       	so = new SqlObject(sSql).setParameter("SerialNo",sContractNo);
     	rs = Sqlca.getASResultSet(so);
    	if(rs.next())
    	{
        	iCount7=rs.getInt(1);	
    	}
    	rs.getStatement().close();	               
 	}else
 	{
 		iCount7=1;
 	}
	
	//---------------------------如果合同的担保方式为抵质押，校验是否有抵质押物信息-----------------------------------------
   	if(sVouchType !=null && !sVouchType.equals("") && !sVouchType1.equals("04005")&& (sVouchType.equals("020") || sVouchType.equals("040")))
   	{	                
        	sSql = 	" select Count(*) from GUARANTY_INFO "+
               		" where ObjectNo in (select ObjectNo from CONTRACT_RELATIVE where ObjectType = 'GUARANTY_CONTRACT' "+
               		" and SerialNo =:SerialNo) ";
        	so = new SqlObject(sSql).setParameter("SerialNo",sContractNo);
        	rs = Sqlca.getASResultSet(so);
        	if(rs.next())
        	{
            	iCount8 = rs.getInt(1);	
        	}
        	rs.getStatement().close();	              
 	}else
 	{
 		iCount8=1;
 	}
	
	//---------------------------如果合同的发生方式为债务重组，校验是否有相关重组方案-----------------------------------------
   	if(sOccurType == null)sOccurType="";
   	if(sOccurType.equals("030"))
   	{	                
        	sSql = 	" select Count(*) from CONTRACT_RELATIVE "+
               		" where SerialNo =:SerialNo and ObjectType='NPAReformApply'";
        	so = new SqlObject(sSql).setParameter("SerialNo",sContractNo);
        	rs = Sqlca.getASResultSet(so);
        	if(rs.next())
        	{
            	iCount9 = rs.getInt(1);	
        	}
        	rs.getStatement().close();	              
 	}else
 	{
 		iCount9=1;
 	}
 	
  	//---------------------------判断是否核销业务-----------------------------------------
 	sSql="select FinishType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
 	so = new SqlObject(sSql).setParameter("SerialNo",sContractNo);
	sFinishType=Sqlca.getString(so);
	if(sFinishType==null)sFinishType="000";
	if(sFinishType.equals(""))sFinishType="000";
	sFinishType=sFinishType.substring(0,3);
	
 	//---------------------------判断相关信息是否存在给予相应的信息提示-----------------------------------------
	 
	//判断客户信息是否完整并作提示信息
	String sCustomerFlag = getCustomerMesssage("BUSINESS_CONTRACT",sContractNo,Sqlca);
	//判断暂时标志并提示信息
	String sTempSaveMesssage = getTempSaveMesssage("BUSINESS_CONTRACT",sContractNo,Sqlca);
    	
    	
	if(!sCustomerFlag.equals("") && !sFinishType.equals("060"))
	{
    	sExistFlag = sCustomerFlag;
	}else if(!sTempSaveMesssage.equals(""))
    {
        sExistFlag = sTempSaveMesssage;
    }else if(sPutOutOrgID == null || sPutOutOrgID.equals(""))
    {
        sExistFlag = "业务基本信息填写不完整！";
    }else if(iCount6 == 0)
    {
       	sExistFlag = "担保方式为质押-保证金，请输入保证金担保合同信息！"; 
    }else if(iCount7 == 0)
    {
   		sExistFlag = "担保方式为抵质押，但没有对应的担保信息！"; 
    }else if(iCount8 == 0)
    {
        sExistFlag = "担保方式为抵质押，但没有对应的抵质押信息！";  
    }else if(iCount9 == 0)
    {
        sExistFlag = "发生方式为债务重组，但没有对应的重组方案信息！";  
    }else
    {
       	sExistFlag = "true";   
    }   	
%>

</html>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sExistFlag);
	sExistFlag = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sExistFlag);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>