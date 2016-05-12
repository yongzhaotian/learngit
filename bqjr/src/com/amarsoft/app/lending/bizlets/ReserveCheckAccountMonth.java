package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ��Bizlet��Ҫ�����ж�����Ļ���·����Ƿ��Ѿ����ڼ�ֵ׼����������������Ϣ��
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
     * ���ݿͻ����ͺ��ʲ�����Ϣ���ж�����Ļ���·����Ƿ��Ѿ����ڼ�ֵ׼����������������Ϣ��
     * @param AccountMonth ����·�
     * @param CustomerType �ͻ����ͣ�ʱ���˿ͻ����ǹ�˾�ͻ�
     * @param AssetsType �ʲ�������(��Ĭ�ϴ��ֶε�ֵ�Ϳͻ����͵�ֵ��ͬ���Ժ���ܻ��и���)
     * @return isExisted ������ڣ��򷵻�"Refuse"�����򷵻�"Pass"
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String isExisted = "";
        String sTableName = "";
        String sSql = "";
        ASResultSet rs = null;
        SqlObject so;//��������
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
        
        //����CustomerType��ȷ������һ�ű�ȡ����
        if(ENTERPRISE.equals(sCustomerType))
        {
            sTableName = RESERVE_ENT_TABLE;
        } else if (INDIVIDUAL.equals(sCustomerType)) {
            sTableName = RESERVE_IND_TABLE;
        } else {
            isExisted = REFUSE;
        }
        
        if (isExisted != REFUSE) {
            //ȡ���Ƿ��е��ڵĲ�����
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
