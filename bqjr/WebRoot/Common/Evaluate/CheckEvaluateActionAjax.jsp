<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:      ndeng 2005.02.01
 * Tester:
 *
 * Content: 	检查信用等级的级别确定更新的值
 * Input Param:
 *			        sCognResult:选定信用等级级别
 *                  sCognLevel：认定人级别
 * Output param:
 * History Log:   
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<% 
    //定义变量
    //之前的值
    String sCurResult = "";
    String sCurLevel = "";  
    String sCurSortNo = ""; 
    //确定的值
    String sResult = "";
    String sLevel = ""; 
    //是否需要更新
    boolean isUpdate = true;
    String sCognSortNo = "";
    SqlObject so = null;
    String sNewSql = "";	
    
    //获取页面参数
    String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
    String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sAccountMonth  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    //认定的值
    String sCognResult   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognResult"));
    String sCognLevel  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognLevel"));
            
    //得到用户当前信用等级
    sNewSql = "select CreditLevel,EvaluateLevel from ENT_INFO where CustomerID=:CustomerID";
    so = new SqlObject(sNewSql);
    so.setParameter("CustomerID",sObjectNo);
    ASResultSet rs = Sqlca.getResultSet(so);
    if(rs.next())
    {
        sCurResult = rs.getString("CreditLevel");
        sCurLevel = rs.getString("EvaluateLevel");
    }
    rs.getStatement().close();
    
    //如果当前用户还没有评定信用等级直接更新
    if(sCurResult==null || sCurLevel==null) 
    {
        sResult=sCognResult;
        sLevel=sCognLevel;
    }else
    {
        //通过客户信用等级找到相应的sortno
        sNewSql = "select SortNo from CODE_LIBRARY where CodeNo = 'CreditLevel' and ItemName = :ItemName";
        so = new SqlObject(sNewSql);
        so.setParameter("ItemName",sCognResult);
        ASResultSet rs0 = Sqlca.getResultSet(so);
        if(rs0.next())
        {
            sCognSortNo = rs0.getString("sortno");
        }
        rs0.getStatement().close();
        
        //通过得到的客户当前信用等级得到相应的sortno
        sNewSql = "select sortno from code_library where codeno = 'CreditLevel' and itemname = :itemname";
        so = new SqlObject(sNewSql);
        so.setParameter("itemname",sCurResult);
        ASResultSet rs2 = Sqlca.getResultSet(so);
        if(rs2.next())
        {
            sCurSortNo = rs2.getString("sortno");
        }
        rs2.getStatement().close();
        
        //比较得到的sortno和认定人的级别
        //认定的级别比以前低则更新，级别比以前高要判断认定人的级别，级别高则更新
        if(sCognSortNo.compareTo(sCurSortNo)<=0) 
        {
            if(sCognLevel.compareTo(sCurLevel)<=0)
            {
                sResult=sCognResult;
                sLevel=sCognLevel;
            }else
            {
                isUpdate = false;//不用执行Update语句
            }
        }else
        {
            sResult=sCognResult;
            sLevel=sCognLevel;
        }
    }
    if(isUpdate)
    {
        sNewSql = "select UR.UserID from USER_ROLE UR,USER_INFO UI where UR.UserID = UI.UserID and UR.RoleID = '442' and UI.BelongOrg = :BelongOrg";
        so = new SqlObject(sNewSql);
        so.setParameter("BelongOrg",CurOrg.getOrgID());
        ASResultSet rs3 = Sqlca.getResultSet(so);
        if(!rs3.next())
        {	
        	sNewSql = "update EVALUATE_RECORD set FinishDate4=:FinishDate4 where SerialNo=:SerialNo";
        	so = new SqlObject(sNewSql);
        	so.setParameter("FinishDate4",StringFunction.getToday());
        	so.setParameter("SerialNo",sSerialNo);
            Sqlca.executeSQL(so);
        }
        rs3.getStatement().close();
        
        sNewSql = "update ENT_INFO set CreditLevel = :CreditLevel,EvaluateLevel=:EvaluateLevel"+
        	",EvaluateDate = :EvaluateDate where CustomerID = :CustomerID";
        so = new SqlObject(sNewSql);
        so.setParameter("CreditLevel",sResult);
        so.setParameter("EvaluateLevel",sLevel);
        so.setParameter("EvaluateDate",sAccountMonth);
        so.setParameter("CustomerID",sObjectNo);
        Sqlca.executeSQL(so);
    }
%>		
<%@ include file="/IncludeEndAJAX.jsp"%>