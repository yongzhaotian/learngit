package com.amarsoft.app.lending.bizlets;

import java.util.regex.Pattern;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 在五级分类流程最后一步提交时，将最终的认定结果更新到CLASSIFY_RECORD、BUSINESS_DUEBILL和BUSINESS_CONTRACT三张表中。
 * 在做五级分类时分为两种：对借据做五级分类，对合同做五级分类。
 * 1. 对借据做五级分类：此时需要更新BUSINESS_DUEBILL表的ClassifyResult字段，并且将此借据所关联的合同记录中的的五级分类
 *    结果更新为此合同下所有借据中最坏的五级分类结果；
 * 2. 对合同做五级分类：此时需要更新BUSINESS_CONTRACT表的ClassifyResult字段，并且将此合同所关联的所有借据的的五级分类
 *    结果更新为当前的合同结果。
 * @author cbsu
 * @date 2009-10-15
 */
public class FinishClassify extends Bizlet {
    
    private static final String BUSINESS_DUEBILL = "BusinessDueBill";
    private static final String BUSINESS_CONTRACT = "BusinessContract";
    protected Log logger = ARE.getLog();

    public Object run(Transaction Sqlca) throws Exception {
        
        //Flow_Opinion表中的ObjectNo
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        //Flow_Opinion表中的ObjectType
        String sObjectType = (String)this.getAttribute("ObjectType");
        //审批最后阶段的意见流水编号
        String sFOSerialNo ="";
        //人工认定结果
        String sPhaseOpinion = "";
        //人工认定原因
        String sPhaseOpinionReason = "";
        //结束时间
        String sInputTime = "";
        String sSql = "";
        ASResultSet rs=null;
        SqlObject so;
        //将空值转化为空字符串
        if(sObjectNo == null) sObjectNo = "";
        if(sObjectType == null) sObjectNo = "";
        
        //查询最终认定人的审批流程任务编号
        sSql = " select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
        " where ObjectType=:ObjectType" +
        " and ObjectNo=:ObjectNo";
        so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
        rs = Sqlca.getASResultSet(so);
        if(rs.next()){
            sFOSerialNo=rs.getString("OpinionNo");
        }
        if(sFOSerialNo==null)sFOSerialNo="";
        rs.getStatement().close();
        logger.debug("Executed SQL: " + sSql);

        //从FLOW_OPINION表中取 "最终认定结果","人工认定日期","认定理由"
        sSql = " select PhaseOpinion," +
        " InputTime," +
        " PhaseOpinion2" +
        " from Flow_Opinion" +
        " where OpinionNo=:OpinionNo ";
        so = new SqlObject(sSql).setParameter("OpinionNo", sFOSerialNo);
        rs = Sqlca.getASResultSet(so);
        if(rs.next()){
            sPhaseOpinion=rs.getString("PhaseOpinion");
            sPhaseOpinionReason=rs.getString("PhaseOpinion2");
            sInputTime =rs.getString("InputTime");
        }        
        if(sPhaseOpinion==null) sPhaseOpinion = "";
        if(sPhaseOpinionReason==null) sPhaseOpinionReason =  "";
        if(sInputTime==null) sInputTime = "";
        rs.getStatement().close();
        logger.debug("Executed SQL: " + sSql);
        
        //当前会计月份
        String sCurrentAccontMonth = "";
        //借据号或合同号
        String sDueBillNo = "";
        //余额
        double dBalance = 0.0;        
        //五级分类是借据或合同
        String sResultType = "";
        //上个会计月份
        String sLastAccountMonth = "";
        //将余额更新到CLASSIFY_RECORD表的字段名
        String balanceColumn = "";
        
        //从CLASSIFY_RECORD表中取得当期的会计月份,借据或合同号,借据或合同余额
        sSql = " select AccountMonth,ObjectNo,BusinessBalance,ObjectType from CLASSIFY_RECORD where SerialNo=:SerialNo";
        so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
        rs = Sqlca.getASResultSet(so);
        if(rs.next()){
            sCurrentAccontMonth = rs.getString("AccountMonth");
            sDueBillNo = rs.getString("ObjectNo");
            dBalance = rs.getDouble("BusinessBalance");
            sResultType = rs.getString("ObjectType");
        }
        if ( sCurrentAccontMonth == null ) sCurrentAccontMonth = "";
        if ( sDueBillNo == null ) sDueBillNo = "";
        if ( sResultType == null ) sResultType = "";
        rs.getStatement().close();
        
        //根据得到的当前会计月份算出上一个会计月份
        try {
            sLastAccountMonth = getLastAccountMonth(sCurrentAccontMonth);
        } catch (Exception e) {
            throw new Exception("不正确的会计月份格式，请检查记录并更正！"); 
        }
        
        //得到上一个会计月份的五级分类结果
        String lastClassifyResult = "";
        sSql = " select FinallyResult" +
        " from CLASSIFY_RECORD" +
        " where ObjectNo=:ObjectNo and AccountMonth=:AccountMonth and ObjectType =:ObjectType " ;
        so = new SqlObject(sSql).setParameter("ObjectNo", sDueBillNo).setParameter("AccountMonth", sLastAccountMonth).setParameter("ObjectType", sResultType);
        lastClassifyResult = Sqlca.getString(so);
        if (lastClassifyResult == null) lastClassifyResult = "";
        
        //确定将余额放在CLASSIFY_RECORD表的字段名
        try {
            balanceColumn = getBalanceColumn(sPhaseOpinion);
        } catch (Exception e) {
            throw new Exception("不正确的最后认定结果格式，请检查记录并更正！"); 
        }
        if (balanceColumn == null) balanceColumn = "";
        
        //更新CLASSIFY_RECORD表的余额，最终人工认定结果，最终认定时间，上一个会计月份的认定结果
        sSql= " UPDATE CLASSIFY_RECORD SET " + balanceColumn + "=:dBalance," +
        " FinallyResult=:FinallyResult,FinishDate=:FinishDate," +
        " LastResult=:LastResult" +
        " WHERE SerialNo=:SerialNo";
        so = new SqlObject(sSql);
        so.setParameter("dBalance", dBalance).setParameter("FinallyResult", sPhaseOpinion)
        .setParameter("FinishDate", sInputTime).setParameter("LastResult", lastClassifyResult).setParameter("SerialNo", sObjectNo);
        Sqlca.executeSQL(so);
        
        //根据sResultType来确定是对借据还是对合同进行五级分类,由此来进行不同的更新操作
        if (BUSINESS_DUEBILL.equals(sResultType)) {
            updateDueBill(sPhaseOpinion, sDueBillNo, Sqlca);
        }
        if (BUSINESS_CONTRACT.equals(sResultType)) {
            updateContract(sPhaseOpinion, sDueBillNo, Sqlca);
        }
        
        return "1";
    }
    
    
    /**
     * 如果对合同做五级分类，需要将最终五级分类结果更新到合同表中.
     * @param sContractNo 合同号
     * @param sClassifyReult 最终五级分类结果
     * @return
     */
    private void updateContract (String sClassifyResult, String sContractNo, Transaction Sqlca) throws Exception {
        
        //更新合同表
    	String sSql = " update BUSINESS_CONTRACT set ClassifyResult =:ClassifyResult " +
        " where SerialNo =:SerialNo";
    	SqlObject so = new SqlObject(sSql).setParameter("ClassifyResult", sClassifyResult).setParameter("SerialNo", sContractNo);
    	Sqlca.executeSQL(so);
        //更新此合同属下的借据记录
        setResultToBatchDueBill(sContractNo, sClassifyResult, Sqlca);
    }
    
    
    /**
     * 如果对借据做五级分类，需要将最终五级分类结果更新到借据表中.
     * @param sDueBillNo 借据号
     * @param sDueBillNo sClassifyReult 最终五级分类结果
     * @return
     */
    private void updateDueBill (String sClassifyResult, String sDueBillNo, Transaction Sqlca) throws Exception {
        
        //更新借据表
    	 String sSql = " update BUSINESS_DUEBILL set ClassifyResult =:ClassifyResult " +
         " where SerialNo =:SerialNo ";
    	 SqlObject so = new SqlObject(sSql).setParameter("ClassifyResult", sClassifyResult).setParameter("SerialNo", sDueBillNo);
    	 Sqlca.executeSQL(so);
        //将此借据所属的合同记录中的五级分类认定结果更改为最坏结果
        setWorstResultToContract(sDueBillNo, Sqlca);
    }
    
    
    /**
     * 如果是对合同做五级分类，则需要将此合同所关联的所有借据的的五级分类结果更新为当前的合同结果.
     * @param sContractNo 合同号
     * @param sClassifyReult最终五级分类结果
     * @return
     */
    private void setResultToBatchDueBill(String sContractNo, String sClassifyResult, Transaction Sqlca) throws Exception {
        
        String sSql = "";
        
        //将合同的五级分类结果更新到借据表中
        
        sSql = " update BUSINESS_DUEBILl set ClassifyResult =:ClassifyResult" +
        " where RelativeSerialNo2 =:RelativeSerialNo2";
       SqlObject so = new SqlObject(sSql).setParameter("ClassifyResult", sClassifyResult).setParameter("RelativeSerialNo2", sContractNo);
        Sqlca.executeSQL(so);
        
    }    
    
    
    /**
     * 如果是对借据做五级分类，则需要将此借据所关联的合同记录中的的五级分类结果更新为此合同下所有借据中最坏的五级分类结果.
     * @param sDueBillNo: 借据号
     * @return 
     */
    private void setWorstResultToContract(String sDueBillNo, Transaction Sqlca) throws Exception {
        
        String sContractSerialNo = "";
        String sWorstResult = "";
        String sSql = "";
        SqlObject so=null;
        //得到借据所属的合同号
        sSql = " select RelativeSerialNo2" +
        " from BUSINESS_DUEBILL" +
        " where SerialNo =:SerialNo";
        so = new SqlObject(sSql).setParameter("SerialNo", sDueBillNo);
        sContractSerialNo = Sqlca.getString(so);
        
        //得到此合同所属下的借据的五级分类最坏结果
        sSql = " select MAX(ClassifyResult)" +
        " from BUSINESS_DUEBILL" +
        " where RelativeSerialNo2 =:RelativeSerialNo2";
        so = new SqlObject(sSql).setParameter("RelativeSerialNo2", sContractSerialNo);
        sWorstResult = Sqlca.getString(so);
        
        //将最坏结果更新到合同表中
        sSql = " update BUSINESS_CONTRACT set ClassifyResult =:ClassifyResult" +
        " where SerialNo =:SerialNo";
        so = new SqlObject(sSql).setParameter("ClassifyResult", sWorstResult).setParameter("SerialNo", sContractSerialNo);
        Sqlca.executeSQL(so);
    }
    
    
     /**
     * 由本期的会计月份得到上期的会计月份值.
     * @param sCurrentAccountMonth 本期五级分类的会计月份
     * @return 上期五级分类的会计月份
     */
    private String getLastAccountMonth(String sCurrentAccountMonth) throws Exception{
        
        String sLastAccountMonth = "";
        int lastYear=0, lastMonth=0;
        
        try {
            if (!"".equals(sCurrentAccountMonth) && sCurrentAccountMonth != null) {
            	//对输入字符串进行分割
                String[] currentDate = sCurrentAccountMonth.split("/");
                
                if (currentDate.length > 1) {
                    String year = currentDate[0];
                    String month = currentDate[1];
                    
                    //利用正则表达式来判断年份和月份是否正确
                    boolean isYear, isMonth;
                    isYear = Pattern.matches("^[1-9]{1}[0-9]{3}", year);
                    isMonth = Pattern.matches("^[0-1]{1}[0-9]{1}", month);
                    
                    //得到上个会计月份
                    if (isYear && isMonth) {
                    	int iYear = DataConvert.toInt(year);
                        int iMonth = DataConvert.toInt(month);
                        if (iMonth == 1) {
                            lastMonth = 12;
                            lastYear = iYear - 1;
                        } else {
                            lastMonth = iMonth - 1;
                            lastYear = iYear;
                        }
                    } else {
                        throw new Exception();
                    }
                    
                    //合成为最终的字符串
                    if (lastMonth < 10) {
                        sLastAccountMonth = String.valueOf(lastYear) + "/0" + String.valueOf(lastMonth);
                    } else {
                        sLastAccountMonth = String.valueOf(lastYear) + "/" + String.valueOf(lastMonth);
                    }
                } else {
                	//如果分割后的字符串数组个数小于1，则抛异常
                    throw new Exception();
                }
            } else {
            	//如果字符串为null或空，则抛异常
                throw new Exception();
            }
            return sLastAccountMonth;
        } catch (Exception e) {
        	//得到任何异常，直接向上一层抛出
            throw e;
        }
    }
    
    
    /**
     * 根据最终人工认定意见来确定使用Classify_Record表中的SUM1-SUM5哪个字段来保存余额.
     * 人工认定结果与SUM1-SUM5对应关系如下：
     * 人工认定结果:字段名
     *    "01":SUM1, "02":SUM2, "03":SUM3, "04":SUM4, "05":SUM5
     * @param sPhaseOpinion 最终人工认定意见
     * @return Classify_Record表中字段名
     */
    private String getBalanceColumn(String sPhaseOpinion) throws Exception {
        
        String balanceColumn = "";
        boolean isCorrectReuslt = false;
        
        try {
            if (!"".equals(sPhaseOpinion) && sPhaseOpinion != null) {
                
                //用正则表达式判断sPhaseOpinion是否为正确的格式
            	//第一位为0，第二位为1到5之间的一个数
                isCorrectReuslt = Pattern.matches("^0[1-5]{1}$", sPhaseOpinion); 
                
                if (isCorrectReuslt) {
                	//如果字符串符合正则表达式，则进行配对
                    int iPhaseOpinion = DataConvert.toInt(sPhaseOpinion);
                    balanceColumn = "SUM" + String.valueOf(iPhaseOpinion);
                } else {
                	//如果字符串不符合格式，则抛异常
                    throw new Exception();
                }
            } else {
            	//如果字符串为null或空，则抛异常
                throw new Exception();
            }
        } catch (Exception e) {
            throw e;
        }
        return balanceColumn;
    }
}
