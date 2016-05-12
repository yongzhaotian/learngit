package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ������ͬ����������
 * @author zhuang
 * @since 2010/04/01
 */

public class CheckCountsOfGuarantyContract extends  AlarmBiz{
    
    public Object run(Transaction Sqlca) throws Exception {
        
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        SqlObject so = null;//��������
        so = new SqlObject("select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '020'");
        so.setParameter("SerialNo", sObjectNo);
        String addCount  = Sqlca.getString(so);
        so = new SqlObject("select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '030'");
        so.setParameter("SerialNo", sObjectNo);
        String delCount  = Sqlca.getString(so);
        int totalCount = Integer.parseInt(addCount)+Integer.parseInt(delCount);
        
        putMsg("������ͬ���:");
        putMsg("������������ͬ����  "+addCount+" �ʣ�");
        putMsg("����������ͬ����  "+delCount+" �ʣ�");
       
              
        /** ���ؽ������ **/
        if( totalCount <= 0){
            setPass(false);
        }else{
            setPass(true);
        }
        
        return null;
    }

}
