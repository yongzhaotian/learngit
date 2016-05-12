package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 检查所选择的集团成员是否已经与集团关联。
 * @author cbsu
 * @date 2009-10-26
 */
public class CheckGroupRelative extends Bizlet {

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    
    /**
     * 通过传入的集团客户编号和集团编号，从GROUP_RELATIVE表中进行查找，以此来确定
     * 选择的集团成员是否已经与集团关联。
     * @param CustomerID 集团客户编号
     * @param RelativeID 集团编号
     * @return isRelated 未关联返回"Success"，已经关联返回"Failed"
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String sSql = "";
        String isRelated = FAILED;
        int iCount = 0;
        ASResultSet rs = null;
        
        //集团客户编号
        String sCustomerID = (String)this.getAttribute("CustomerID");
        //集团编号
        String sRelativeID = (String)this.getAttribute("RelativeID");
        if (sRelativeID == null) sRelativeID = "";
        if (sCustomerID == null) sCustomerID = "";
        
        //从GROUP_RELATIVE表中进行查找，以此确定集团成员与集团是否已经关联
        sSql =  " select Count(*)" +
                " from GROUP_RELATIVE" +
                " Where RelativeID = :sRelativeID" +
                " and CustomerID = :sCustomerID";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID).setParameter("sRelativeID", sRelativeID));
        
        if (rs.next()) {
            iCount = rs.getInt(1);
        }
        rs.getStatement().close();
        if(iCount > 0)
        {
            isRelated = FAILED;
        } else {
            isRelated = SUCCESS;
        }
        return isRelated;
    }
}
