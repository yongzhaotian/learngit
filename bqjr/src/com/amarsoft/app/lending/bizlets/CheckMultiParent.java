package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * һ�����������ļ��ų�Ա�У�ֻ����һ��Ϊĸ��˾����Bizlet����鼯�����Ƿ��Ѿ�����ĸ��˾��
 * @author cbsu
 * @date 2009-11-02
 */
public class CheckMultiParent extends Bizlet {

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    
    /**
     * ͨ������ļ��ű�ţ���GROUP_RELATIVE���н��в��ң��Դ���ȷ���Ƿ��м��ų�ԱΪĸ��˾��
     * @param RelativeID ���ű��
     * @return  �������һ�����ų�ԱΪĸ��˾���򷵻�"Failed",���򷵻�"Success"
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String sSql = "";
        String addParent = FAILED;
        int iCount = 0;
        ASResultSet rs = null;
        
        //���ű��
        String sRelativeID = (String)this.getAttribute("RelativeID");
        if (sRelativeID == null) sRelativeID = "";
        
        //��GROUP_RELATIVE���н��в��ң��Դ�ȷ���Ƿ��Ѿ�����ĸ��˾
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
