package com.amarsoft.app.als.rule;

import java.sql.SQLException;
import java.sql.Time;
import java.util.Calendar;
import java.util.Date;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 插入规则引擎运行时点日志
 * @author jli5
 * @version
 *   1.0.0 
 *    		2015-4-20  下午5:01:30
 * @since
 *
 */
public class InsertRuleRunLog {
    public static String sCreditLogSql  = "INSERT INTO RULE_RUN_LOG (SERIALNO,BCSERIALNO) VALUES(:SERIALNO,:BCSERIALNO)";
    public static String sSelectLogSql = "SELECT 1 FROM RULE_RUN_LOG WHERE BCSERIALNO=:BCSERIALNO";//判断是否存在记录
    public static String sFirstUpdateSql = "UPDATE RULE_RUN_LOG SET BEGINTIME1=:BEGINTIME1 ,ENDTIME1=:ENDTIME1, BEGINTIME2=:BEGINTIME2,ENDTIME2=:ENDTIME2 WHERE BCSERIALNO=:BCSERIALNO";
    public static String sThirdUpdateSql = "UPDATE RULE_RUN_LOG SET BEGINTIME3=:BEGINTIME1 ,ENDTIME3=:ENDTIME1, BEGINTIME4=:BEGINTIME2,ENDTIME4=:ENDTIME2 WHERE BCSERIALNO=:BCSERIALNO";
    
    
    public String SerialNo="";//合同流水号
    
    /**
     * 插入日志
     * @param Time1  准备开始日期
     * @param Time2  准备结束日期 
     * @param Time3  调用开始日期
     * @param Time4  调用结束日期
     * @param Sqlca   事务连接
     * @param bcSerialNo 合同流水号
     * @param Type    First，第一次，Third，第三次
     * @throws Exception
     */
    public  static void insertLog(String Time1,String Time2,String Time3,String Time4,Transaction Sqlca,String bcSerialNo,String Type) throws Exception{
        isInsert(Sqlca, bcSerialNo);
        String sSql = sFirstUpdateSql;
        if("Third".equalsIgnoreCase(Type)){
            sSql = sThirdUpdateSql;
        }
//        System.out.println("Time1="+Time1+"Time2="+Time2+"Time3="+Time3+"Time4="+Time4);
        Sqlca.executeSQL(new SqlObject(sSql).setParameter("BEGINTIME1", Time1)
                .setParameter("ENDTIME1", Time2)
                .setParameter("BEGINTIME2", Time3)
                .setParameter("ENDTIME2", Time4)
                .setParameter("BCSERIALNO", bcSerialNo));
    }

    /**
     * 插入销售提交时间
     * @param Sqlca
     * @throws SQLException
     * @throws Exception
     */
    public  void  insertSubTime(Transaction Sqlca) throws SQLException, Exception{
        isInsert(Sqlca, SerialNo);
        String sDate = DateX.format(new Date()); 
        Calendar rightNow = Calendar.getInstance();
        String SUBMITTIME = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND));
//        System.out.println("SUBMITTIME="+SUBMITTIME);
        Sqlca.executeSQL(new SqlObject("UPDATE RULE_RUN_LOG SET SUBMITTIME=:SUBMITTIME  WHERE BCSERIALNO=:BCSERIALNO").setParameter("SUBMITTIME", SUBMITTIME).setParameter("BCSERIALNO", SerialNo));
    }
    
    /**
     * 判断是否存在  不存在则新增
     * @param Sqlca
     * @param bcSerialNo
     * @throws Exception
     */
    private   static void isInsert(Transaction Sqlca,String bcSerialNo) throws Exception{
        boolean bIsinsert = true;
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSelectLogSql).setParameter("BCSERIALNO", bcSerialNo));
        if(rs.next()){
            bIsinsert = false;
        }
        if(bIsinsert){
            String sSerialNo = DBKeyHelp.getSerialNo("RULE_RUN_LOG", "SERIALNO", "L");
            Sqlca.executeSQL(new SqlObject(sCreditLogSql).setParameter("BCSERIALNO", bcSerialNo).setParameter("SERIALNO", sSerialNo));
        }
        
    }
    
    
    public String getSerialNo() {
        return SerialNo;
    }

    public void setSerialNo(String serialNo) {
        SerialNo = serialNo;
    }
    
}
