package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 此Bizlet主要用于判断输入的会计月份下是否已经存在减值准备基础参数配置信息。
 * @author cbsu 2009-11-09
 */
public class ReserveCheckAccountMonth extends Bizlet {
    private static final String REFUSE = "Refuse";
    private static final String PASS = "Pass";
    private static final String RESERVE_ENT_TABLE = "RESERVE_ENTPARA";
    private static final String RESERVE_IND_TABLE = "RESERVE_INDPARA";
    private static final String ENTERPRISE = "01";
    private static final String INDIVIDUAL = "03";

    /**
     * 根据客户类型和资产组信息来判断输入的会计月份下是否已经存在减值准备基础参数配置信息。
     * @param AccountMonth 会计月份
     * @param CustomerType 客户类型，时个人客户还是公司客户
     * @param AssetsType 资产组类型(现默认此字段的值和客户类型的值相同，以后可能会有更改)
     * @return isExisted 如果存在，则返回"Refuse"，否则返回"Pass"
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String isExisted = "";
        String sTableName = "";
        String sSql = "";
        ASResultSet rs = null;
        SqlObject so;//声明对象
        String sAccountMonth = (String)this.getAttribute("AccountMonth");
        String sCustomerType = (String)this.getAttribute("CustomerType");
        String sAssertsType = (String)this.getAttribute("AssetsType");
        
        if (sAccountMonth == null) {
            sAccountMonth = "";
        }
        if (sCustomerType == null) {
            sCustomerType = "";
        }
        if (sAssertsType == null) {
            sAssertsType = "";
        }
        
        //根据CustomerType来确定从哪一张表取数据
        if(ENTERPRISE.equals(sCustomerType))
        {
            sTableName = RESERVE_ENT_TABLE;
        } else if (INDIVIDUAL.equals(sCustomerType)) {
            sTableName = RESERVE_IND_TABLE;
        } else {
            isExisted = REFUSE;
        }
        
        if (isExisted != REFUSE) {
            //取得是否有当期的参数表
        	 sSql =  " select AccountMonth from " + sTableName +
             " where AccountMonth =:AccountMonth "+           
             " and AssetsType =:AssetsType ";
        	 so = new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("AssetsType", sAssertsType);
        	 rs = Sqlca.getResultSet(so);
            if(rs.next())
            {
                isExisted = REFUSE;
            }else {
                isExisted = PASS;
            }
            rs.getStatement().close();
        }
        
        return isExisted;
    }

}
