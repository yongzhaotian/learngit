package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 一个集团所属的集团成员中，只能有一个为母公司。此Bizlet即检查集团中是否已经存在母公司。
 * @author cbsu
 * @date 2009-11-02
 */
public class CheckMultiParent extends Bizlet {

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    
    /**
     * 通过传入的集团编号，从GROUP_RELATIVE表中进行查找，以此来确定是否有集团成员为母公司。
     * @param RelativeID 集团编号
     * @return  如果存在一个集团成员为母公司，则返回"Failed",否则返回"Success"
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String sSql = "";
        String addParent = FAILED;
        int iCount = 0;
        ASResultSet rs = null;
        
        //集团编号
        String sRelativeID = (String)this.getAttribute("RelativeID");
        if (sRelativeID == null) sRelativeID = "";
        
        //从GROUP_RELATIVE表中进行查找，以此确定是否已经存在母公司
        sSql =  " select Count(*)" +
                " from GROUP_RELATIVE" +
                " Where RelativeID = :sRelativeID" +
                " and RelationShip = '1010'";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sRelativeID", sRelativeID));
        
        if (rs.next()) {
            iCount = rs.getInt(1);
        }
        rs.getStatement().close();
        if(iCount > 0)
        {
        	addParent = FAILED;
        } else {
        	addParent = SUCCESS;
        }
        return addParent;
    }
}
