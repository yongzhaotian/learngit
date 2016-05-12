<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Tester:
 *
 <%
 /*
 Author:   cbsu  2009.10.13
 Tester:
 Content: ��ҳ����Ҫ���弶��������̽��г�ʼ��������
 Input Param:
 Output param:
 History Log:        
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.classify.*,com.amarsoft.app.lending.bizlets.InitializeFlow" %>
<% 
	//�������
	int iTCount = 0;
    ASResultSet rs = null; //��Ų�ѯ�����
    SqlObject so = null;
    String sCustomerID = "";
    String sSerialNo = "";
    double dBalance = 0.0;
    String sSql = "";
    String sReturnValue="";
	
	//��ȡҳ�����
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); //"Classify"
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); //��ݻ��ͬ��
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	String sModelNo      = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	String sResultType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ResultType")); //�弶�����ݻ��ͬ add by cbsu 2009-10-12	
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));	
	
	//����ֵת��Ϊ���ַ���	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sResultType == null) sResultType = "";
	if(sType == null) sType = "";
	
	//���ݶ����������������
    String sTableName = "";
    if(sResultType.equals("BusinessContract")){
        sTableName = "BUSINESS_CONTRACT";
    }
    if(sResultType.equals("BusinessDueBill")){
        sTableName = "BUSINESS_DUEBILL";
    }
    
    try{
        //�������������,�򲻳�ʼ������
        if(sType.equals("Batch")){
        	//Ŀǰ��������弶��������ֻ��Ԥ����������������ʵ���弶�����������롣
            sSql =  " select SerialNo,nvl(Balance,0) as Balance,CustomerID "+
                    " from "+sTableName+" "+
                    " where not exists (select 1 "+
                    " from CLASSIFY_RECORD "+
                    " where ObjectType =:ObjectType "+
                    " and AccountMonth =:AccountMonth and ObjectNo="+sTableName+".SerialNo) "+
                    " and Balance > 0 ";
            so = new SqlObject(sSql);
            so.setParameter("ObjectType",sResultType).setParameter("AccountMonth",sAccountMonth);
            rs = Sqlca.getASResultSet(so);
            while(rs.next()){
                sObjectNo = rs.getString("SerialNo");
                dBalance = rs.getDouble("Balance");
                sCustomerID = rs.getString("CustomerID");
                //��CLASSIFY_RECORD����������¼
                sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca);
                sSql = " update CLASSIFY_RECORD set CustomerID =:CustomerID, " +
                       " BusinessBalance =:BusinessBalance, " +
                       " InputDate =:InputDate, "+
                       " UpdateDate =:UpdateDate "+
                       " where SerialNo =:SerialNo ";
                so = new SqlObject(sSql);
                so.setParameter("CustomerID",sCustomerID).setParameter("BusinessBalance",dBalance)
                .setParameter("InputDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday())
                .setParameter("SerialNo",sSerialNo);
                Sqlca.executeSQL(so);
            }
            rs.getStatement().close();          
        }else{
            //��ѯ��ͬ/��ݵ�����ʼ������
            sSql =  " select count(SerialNo) from CLASSIFY_RECORD "+
                    " where ObjectType =:ObjectType "+
                    " and ObjectNo =:ObjectNo "+
                    " and AccountMonth =:AccountMonth ";
            so = new SqlObject(sSql);
            so.setParameter("ObjectType",sResultType).setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth);
            rs = Sqlca.getASResultSet(so);
            if (rs.next())
            	iTCount = rs.getInt(1);
            //�رս����
            rs.getStatement().close();        
            if(iTCount > 0){
            	sReturnValue = "IsExist";
            }else{
	            //�����߼����AmarGCI4.0�汾�Ѿ���BUSINESS_DUEBILL���е�CUSTOMERID�ֶθ�ֵ�������BUSINESS_DUEBILL���п���ȡ��CUSTOMERID
	            //������������°汾��AmarGCI��ȡCUSTOMERID�ķ������Լ���� add by cbsu 2009-10-14
	            sSql =  " select Balance,CustomerID "+
	                    " from "+sTableName+" "+
	                    " where SerialNo =:SerialNo ";
	            rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	            if(rs.next()){
	                dBalance = rs.getDouble("Balance");
	                sCustomerID = rs.getString("CustomerID");
	            }    
	            rs.getStatement().close();
	            //��CLASSIFY_RECORD����������¼
	            sSql = "select SerialNo from classify_record where ObjectType=:ObjectType and ObjectNo=:ObjectNo and AccountMonth=:AccountMonth";
	            so = new SqlObject(sSql);
	            so.setParameter("ObjectType",sResultType).setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth);
	            sSerialNo = Sqlca.getString(so);
	            if(sSerialNo == null || sSerialNo.length() == 0){
	            	sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca);
	            }else{
	            	//�����ѽ������ݲ��뵽CLASSIFY_RECORD,��˲����ٲ����ˡ�
	            	//����CLASSIFY_DATA���������������ݣ������Ҫ����
		        		sSql = "insert into CLASSIFY_DATA ( ObjectType,ObjectNo,SerialNo,ItemNo) " 
		    							+" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"',"
		            			+" ItemNo from EVALUATE_MODEL where ModelNo =:ModelNo";
		        		so = new SqlObject(sSql);
		        		so.setParameter("ModelNo",sModelNo);
	            	Sqlca.executeSQL(so);
	            }
	            sSql = " update CLASSIFY_RECORD set CustomerID =:CustomerID, " +
	                   " BusinessBalance =:BusinessBalance, " +
	                   " InputDate =:InputDate, "+
	                   " UpdateDate =:UpdateDate "+
	                   " where SerialNo =:SerialNo ";
	           	so = new SqlObject(sSql);
	           	so.setParameter("CustomerID",sCustomerID).setParameter("BusinessBalance",dBalance)
	           	.setParameter("InputDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday())
	           	.setParameter("SerialNo",sSerialNo);
	            Sqlca.executeSQL(so);
	            //��ʼ���弶��������
	            InitializeFlow InitializeFlow_Classify = new InitializeFlow();
	            InitializeFlow_Classify.setAttribute("ObjectType",sObjectType);
	            InitializeFlow_Classify.setAttribute("ObjectNo",sSerialNo); 
	            InitializeFlow_Classify.setAttribute("ApplyType","ClassifyApply");
	            InitializeFlow_Classify.setAttribute("FlowNo","ClassifyFlow");
	            InitializeFlow_Classify.setAttribute("PhaseNo","0010");
	            InitializeFlow_Classify.setAttribute("UserID",CurUser.getUserID());
	            InitializeFlow_Classify.setAttribute("OrgID",CurUser.getOrgID());
	            InitializeFlow_Classify.run(Sqlca);
	            
	            sReturnValue = sSerialNo;
            }
        }
    }catch(Exception e){
        throw new Exception("������ʧ�ܣ�"+e.getMessage());
    }       
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>