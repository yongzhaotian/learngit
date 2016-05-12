package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 担保合同变更笔数情况
 * @author zhuang
 * @since 2010/04/01
 */

public class CheckCountsOfGuarantyContract extends  AlarmBiz{
    
    public Object run(Transaction Sqlca) throws Exception {
        
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        SqlObject so = null;//声明对象
        so = new SqlObject("select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '020'");
        so.setParameter("SerialNo", sObjectNo);
        String addCount  = Sqlca.getString(so);
        so = new SqlObject("select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '030'");
        so.setParameter("SerialNo", sObjectNo);
        String delCount  = Sqlca.getString(so);
        int totalCount = Integer.parseInt(addCount)+Integer.parseInt(delCount);
        
        putMsg("担保合同变更:");
        putMsg("拟新增担保合同共计  "+addCount+" 笔！");
        putMsg("拟解除担保合同共计  "+delCount+" 笔！");
       
              
        /** 返回结果处理 **/
        if( totalCount <= 0){
            setPass(false);
        }else{
            setPass(true);
        }
        
        return null;
    }

}
