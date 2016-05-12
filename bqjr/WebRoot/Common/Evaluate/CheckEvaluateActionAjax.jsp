<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:      ndeng 2005.02.01
 * Tester:
 *
 * Content: 	������õȼ��ļ���ȷ�����µ�ֵ
 * Input Param:
 *			        sCognResult:ѡ�����õȼ�����
 *                  sCognLevel���϶��˼���
 * Output param:
 * History Log:   
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<% 
    //�������
    //֮ǰ��ֵ
    String sCurResult = "";
    String sCurLevel = "";  
    String sCurSortNo = ""; 
    //ȷ����ֵ
    String sResult = "";
    String sLevel = ""; 
    //�Ƿ���Ҫ����
    boolean isUpdate = true;
    String sCognSortNo = "";
    SqlObject so = null;
    String sNewSql = "";	
    
    //��ȡҳ�����
    String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
    String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sAccountMonth  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    //�϶���ֵ
    String sCognResult   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognResult"));
    String sCognLevel  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognLevel"));
            
    //�õ��û���ǰ���õȼ�
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
    
    //�����ǰ�û���û���������õȼ�ֱ�Ӹ���
    if(sCurResult==null || sCurLevel==null) 
    {
        sResult=sCognResult;
        sLevel=sCognLevel;
    }else
    {
        //ͨ���ͻ����õȼ��ҵ���Ӧ��sortno
        sNewSql = "select SortNo from CODE_LIBRARY where CodeNo = 'CreditLevel' and ItemName = :ItemName";
        so = new SqlObject(sNewSql);
        so.setParameter("ItemName",sCognResult);
        ASResultSet rs0 = Sqlca.getResultSet(so);
        if(rs0.next())
        {
            sCognSortNo = rs0.getString("sortno");
        }
        rs0.getStatement().close();
        
        //ͨ���õ��Ŀͻ���ǰ���õȼ��õ���Ӧ��sortno
        sNewSql = "select sortno from code_library where codeno = 'CreditLevel' and itemname = :itemname";
        so = new SqlObject(sNewSql);
        so.setParameter("itemname",sCurResult);
        ASResultSet rs2 = Sqlca.getResultSet(so);
        if(rs2.next())
        {
            sCurSortNo = rs2.getString("sortno");
        }
        rs2.getStatement().close();
        
        //�Ƚϵõ���sortno���϶��˵ļ���
        //�϶��ļ������ǰ������£��������ǰ��Ҫ�ж��϶��˵ļ��𣬼���������
        if(sCognSortNo.compareTo(sCurSortNo)<=0) 
        {
            if(sCognLevel.compareTo(sCurLevel)<=0)
            {
                sResult=sCognResult;
                sLevel=sCognLevel;
            }else
            {
                isUpdate = false;//����ִ��Update���
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