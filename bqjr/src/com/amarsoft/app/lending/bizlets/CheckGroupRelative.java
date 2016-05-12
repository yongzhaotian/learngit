package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �����ѡ��ļ��ų�Ա�Ƿ��Ѿ��뼯�Ź�����
 * @author cbsu
 * @date 2009-10-26
 */
public class CheckGroupRelative extends Bizlet {

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    
    /**
     * ͨ������ļ��ſͻ���źͼ��ű�ţ���GROUP_RELATIVE���н��в��ң��Դ���ȷ��
     * ѡ��ļ��ų�Ա�Ƿ��Ѿ��뼯�Ź�����
     * @param CustomerID ���ſͻ����
     * @param RelativeID ���ű��
     * @return isRelated δ��������"Success"���Ѿ���������"Failed"
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String sSql = "";
        String isRelated = FAILED;
        int iCount = 0;
        ASResultSet rs = null;
        
        //���ſͻ����
        String sCustomerID = (String)this.getAttribute("CustomerID");
        //���ű��
        String sRelativeID = (String)this.getAttribute("RelativeID");
        if (sRelativeID == null) sRelativeID = "";
        if (sCustomerID == null) sCustomerID = "";
        
        //��GROUP_RELATIVE���н��в��ң��Դ�ȷ�����ų�Ա�뼯���Ƿ��Ѿ�����
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
