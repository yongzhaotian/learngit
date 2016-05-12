<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: slliu  2005-02-23 
		Tester:
		Content: �������У��
		Input Param:                                                           
    			   
		Output param:                                                          
			        
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%!
	//�жϿͻ���Ϣ�Ƿ�����������ʾ��Ϣ
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
		sMesssage += "\\n\\�ͻ���ϢΪ��ʱ����״̬��������д�ͻ���Ϣ��������水ť��";

	//�ͻ�������ҵ���� IndustryType
	sSql = "select IndustryType from ENT_INFO where CustomerID=:CustomerID";
	so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
	String sIndustryType = Sqlca.getString(so);
	if (sIndustryType==null) sIndustryType="";
	if (sIndustryType.equals(""))
		sMesssage += "\\n\\r�ͻ���Ϣ�Ĺ�����ҵ���಻��Ϊ�գ������ڿͻ���Ϣ��ѡ����ҵ���ಢ���棡";

	//�ͻ����õȼ�����ģ������ CreditBelong
	sSql = "select CreditBelong from ENT_INFO where CustomerID=:CustomerID";
	so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
	String sCreditBelong = Sqlca.getString(so);
	if (sCreditBelong==null) sCreditBelong="";
	if (sCreditBelong.equals(""))
		sMesssage += "\\n\\r�ͻ���Ϣ�Ŀͻ����õȼ�����ģ�岻��Ϊ�գ������ڿͻ���Ϣ��ѡ�����õȼ�����ģ�岢���棡";
	//���񱨱�����FinanceBelong
	sSql = "select FinanceBelong from ENT_INFO where CustomerID=:CustomerID";
	so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
	String sFinanceBelong = Sqlca.getString(so);
	if (sFinanceBelong==null) sFinanceBelong="";
	if (sFinanceBelong.equals(""))
		sMesssage += "\\n\\r�ͻ���Ϣ�Ĳ��񱨱����Ͳ���Ϊ�գ������ڿͻ���Ϣ��ѡ����񱨱����Ͳ����棡";
	return sMesssage;
	}

	//�ж���ʱ��־����ʾ��Ϣ
	String getTempSaveMesssage(String sMainTable,String sObjectNo,Transaction Sqlca) throws Exception {
	String sMesssage = "";
	String sSql = "select TempSaveFlag from "+sMainTable+" where SerialNo=:SerialNo";
	SqlObject so = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);
	String sTempSaveFlag=Sqlca.getString(so);
	if (sTempSaveFlag==null) sTempSaveFlag="";
	if (sTempSaveFlag.equals("1"))
		sMesssage += "\\n\\r����ҵ����ϢΪ��ʱ����״̬��������д����ҵ����Ϣ��������水ť��";
	return sMesssage;
	}
%>

<html>
<head>
<title>�������У�� </title>
</head>


<%
	//�������
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
	
	
	//��ͬ��ˮ�š��ͻ���š�ҵ��Ʒ��
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sCustomerID =    DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
   
	//------------------------У���ͬҵ�������Ϣ�Ƿ���������-----------------------------------------
	//�õ�ҵ�������Ϣ
        
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
			       
			       
	if(sBusinessType.equals("5"))	//���Ϊ���Ŷ�ȣ�����У�鵣����ʽ
	{
		sVouchType = "";
	}else if(sBusinessType.equals("1"))	//���Ϊ����ҵ��У�鵣����ʽ
	{
		sVouchType1 = sVouchType;
		if(sVouchType !=null && !sVouchType.equals(""))
	    {
			sVouchType = sVouchType.substring(0,3);
		}else
		{
			sVouchType = "";
		}
	}else if(sBusinessType.equals("2"))	//���Ϊ����ҵ��У�鵣����ʽ
	{    	
       if(sVouchType !=null && !sVouchType.equals(""))
       	{
       		if(!sVouchType.equals("04005"))  //��Ϊ��Ѻ����֤��
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
	       
	   
	//----------------------------�����ͬ�ĵ�����ʽΪ����Ѻ��У���Ƿ��е���Ѻ��ͬ----------------------------------------
	if(sVouchType1.equals("04005"))  //���Ϊ��Ѻ����֤��Ҫ�����������Ѻ��֤���ͬ
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
	
	//---------------------------�����ͬ�ĵ�����ʽΪ����Ѻ��У���Ƿ��е���Ѻ����Ϣ-----------------------------------------
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
	
	//---------------------------�����ͬ�ķ�����ʽΪծ�����飬У���Ƿ���������鷽��-----------------------------------------
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
 	
  	//---------------------------�ж��Ƿ����ҵ��-----------------------------------------
 	sSql="select FinishType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
 	so = new SqlObject(sSql).setParameter("SerialNo",sContractNo);
	sFinishType=Sqlca.getString(so);
	if(sFinishType==null)sFinishType="000";
	if(sFinishType.equals(""))sFinishType="000";
	sFinishType=sFinishType.substring(0,3);
	
 	//---------------------------�ж������Ϣ�Ƿ���ڸ�����Ӧ����Ϣ��ʾ-----------------------------------------
	 
	//�жϿͻ���Ϣ�Ƿ�����������ʾ��Ϣ
	String sCustomerFlag = getCustomerMesssage("BUSINESS_CONTRACT",sContractNo,Sqlca);
	//�ж���ʱ��־����ʾ��Ϣ
	String sTempSaveMesssage = getTempSaveMesssage("BUSINESS_CONTRACT",sContractNo,Sqlca);
    	
    	
	if(!sCustomerFlag.equals("") && !sFinishType.equals("060"))
	{
    	sExistFlag = sCustomerFlag;
	}else if(!sTempSaveMesssage.equals(""))
    {
        sExistFlag = sTempSaveMesssage;
    }else if(sPutOutOrgID == null || sPutOutOrgID.equals(""))
    {
        sExistFlag = "ҵ�������Ϣ��д��������";
    }else if(iCount6 == 0)
    {
       	sExistFlag = "������ʽΪ��Ѻ-��֤�������뱣֤�𵣱���ͬ��Ϣ��"; 
    }else if(iCount7 == 0)
    {
   		sExistFlag = "������ʽΪ����Ѻ����û�ж�Ӧ�ĵ�����Ϣ��"; 
    }else if(iCount8 == 0)
    {
        sExistFlag = "������ʽΪ����Ѻ����û�ж�Ӧ�ĵ���Ѻ��Ϣ��";  
    }else if(iCount9 == 0)
    {
        sExistFlag = "������ʽΪծ�����飬��û�ж�Ӧ�����鷽����Ϣ��";  
    }else
    {
       	sExistFlag = "true";   
    }   	
%>

</html>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sExistFlag);
	sExistFlag = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sExistFlag);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>