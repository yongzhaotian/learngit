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
 Content: 该页面主要对五级分类的流程进行初始化操作。
 Input Param:
 Output param:
 History Log:        
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.classify.*,com.amarsoft.app.lending.bizlets.InitializeFlow" %>
<% 
	//定义变量
	int iTCount = 0;
    ASResultSet rs = null; //存放查询结果集
    SqlObject so = null;
    String sCustomerID = "";
    String sSerialNo = "";
    double dBalance = 0.0;
    String sSql = "";
    String sReturnValue="";
	
	//获取页面参数
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); //"Classify"
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); //借据或合同号
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	String sModelNo      = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	String sResultType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ResultType")); //五级分类借据或合同 add by cbsu 2009-10-12	
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));	
	
	//将空值转化为空字符串	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sResultType == null) sResultType = "";
	if(sType == null) sType = "";
	
	//根据对象类型设置其表名
    String sTableName = "";
    if(sResultType.equals("BusinessContract")){
        sTableName = "BUSINESS_CONTRACT";
    }
    if(sResultType.equals("BusinessDueBill")){
        sTableName = "BUSINESS_DUEBILL";
    }
    
    try{
        //如果是批量分类,则不初始化流程
        if(sType.equals("Batch")){
        	//目前针对批量五级分类新增只是预留，不能用流程来实现五级分类批量申请。
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
                //在CLASSIFY_RECORD表中新增记录
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
            //查询合同/借据的余额，初始化流程
            sSql =  " select count(SerialNo) from CLASSIFY_RECORD "+
                    " where ObjectType =:ObjectType "+
                    " and ObjectNo =:ObjectNo "+
                    " and AccountMonth =:AccountMonth ";
            so = new SqlObject(sSql);
            so.setParameter("ObjectType",sResultType).setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth);
            rs = Sqlca.getASResultSet(so);
            if (rs.next())
            	iTCount = rs.getInt(1);
            //关闭结果集
            rs.getStatement().close();        
            if(iTCount > 0){
            	sReturnValue = "IsExist";
            }else{
	            //如下逻辑针对AmarGCI4.0版本已经把BUSINESS_DUEBILL表中的CUSTOMERID字段赋值，因此在BUSINESS_DUEBILL表中可以取到CUSTOMERID
	            //如果不是用最新版本的AmarGCI，取CUSTOMERID的方法请自己添加 add by cbsu 2009-10-14
	            sSql =  " select Balance,CustomerID "+
	                    " from "+sTableName+" "+
	                    " where SerialNo =:SerialNo ";
	            rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	            if(rs.next()){
	                dBalance = rs.getDouble("Balance");
	                sCustomerID = rs.getString("CustomerID");
	            }    
	            rs.getStatement().close();
	            //在CLASSIFY_RECORD表中新增记录
	            sSql = "select SerialNo from classify_record where ObjectType=:ObjectType and ObjectNo=:ObjectNo and AccountMonth=:AccountMonth";
	            so = new SqlObject(sSql);
	            so.setParameter("ObjectType",sResultType).setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth);
	            sSerialNo = Sqlca.getString(so);
	            if(sSerialNo == null || sSerialNo.length() == 0){
	            	sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca);
	            }else{
	            	//批量已将此数据插入到CLASSIFY_RECORD,因此不用再插入了。
	            	//但是CLASSIFY_DATA批量不会插入此数据，因此需要插入
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
	            //初始化五级分类流程
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
        throw new Exception("事务处理失败！"+e.getMessage());
    }       
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>