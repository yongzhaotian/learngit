<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:      ndeng 2005.02.02
 * Tester:
 *
 * Content: ����ۺ�����Э���Ƿ���ɾ��
 * Input Param:
 *			ObjectNo:��ͬ��ˮ��
                
 * Output param:
 * History Log: zywei 2006/08/12  
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<% 
    //�������
    String sRight = "",sReturnValue = "",sSql = "",sFinishDate = "";
    String sPigeonholeDate = "",sBusinessType = "";
    String sReinforceFlag = "";
    int iCount = 0;
    ASResultSet rs = null;
    SqlObject so = null;
    
    //��ȡ�������    
    
    //��ȡҳ���������ͬ��ˮ��
    String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//��ȡ��ͬ���ս����ڡ��鵵���ڡ�ҵ��Ʒ����Ϣ
	/*sSql = 	" select FinishDate,PigeonholeDate,BusinessType,ReinforceFlag "+
			" from BUSINESS_CONTRACT "+
			" where SerialNo = '"+sObjectNo+"' ";*/
	sSql = 	" select FinishDate,PigeonholeDate,BusinessType,ReinforceFlag "+
			" from BUSINESS_CONTRACT "+
			" where SerialNo =:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);	
	rs = Sqlca.getResultSet(so);
    if(rs.next())
    {
        sFinishDate = rs.getString("FinishDate");
        sPigeonholeDate = rs.getString("PigeonholeDate");       
        sBusinessType = rs.getString("BusinessType");
        sReinforceFlag = rs.getString("ReinforceFlag");
        //����ֵת��Ϊ���ַ���
        if(sFinishDate == null) sFinishDate = "";
        if(sPigeonholeDate == null) sPigeonholeDate = "";        
        if(sBusinessType == null) sBusinessType = "";
        if(sReinforceFlag == null) sReinforceFlag = "";
    }
    rs.getStatement().close();
    
    if(sReinforceFlag.equals("000")) //�����ĺ�ͬ
    {
	    if(sFinishDate.equals("")) //δ�ս�
	    {
	    	if(sPigeonholeDate.equals("")) //δ��ɷŴ�
	    	{
	    		if(!sBusinessType.equals("") && sBusinessType.substring(0,1).equals("3")) //���Ŷ��
	    		{
	    			//�������Ŷ���Ƿ�����ҵ��ռ�ù�
	    			/*sSql = 	" select count(SerialNo) "+
	    					" from BUSINESS_APPLY where "+
	    					" CreditAggreement = '"+sObjectNo+"' ";*/
	    			sSql = 	" select count(SerialNo) "+
	    					" from BUSINESS_APPLY where "+
	    					" CreditAggreement =:CreditAggreement ";
	    			so = new SqlObject(sSql).setParameter("CreditAggreement",sObjectNo);		
	    			rs = Sqlca.getASResultSet(so);
		    		if(rs.next())
		    			iCount = rs.getInt(1);
		    		rs.getStatement().close();
		    		
		    		if(iCount > 0) //���Ŷ���ѱ�ռ��
		    		{
		    			 sReturnValue = "Use";
		    		}
	    		}
	    	}else //����ɷŴ�
	    	{
	    		sReturnValue = "Pigeonhole";
	    	}
	    }else //���ս�
	    {
	    	sReturnValue = "Finish";
	    }
	}else //�����ǻ���ɲ���
	{
		sReturnValue = "Reinforce";
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>		
<%@ include file="/IncludeEndAJAX.jsp"%>