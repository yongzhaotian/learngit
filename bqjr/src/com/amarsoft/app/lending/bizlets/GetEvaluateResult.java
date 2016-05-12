package com.amarsoft.app.lending.bizlets;

import com.amarsoft.amarscript.Expression;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 此类是用来将信用等级评估的认定分数转化为相应的信用评级。因为信用等级评估有多种模板，
 * 而不同的模板评级的标准可能不同。因此需要使用此类来进行结果转化。
 * @author cbsu 2009/11/18
 */
public class GetEvaluateResult extends Bizlet {

    //用于替换AmarScript中的参数列表
    private String ConstantList[][] = {
                                  {"#TotalScore", ""},
                              };
    /**
     * @param ObjectType 信用等级评估对象
     * @param ObjectNo 信用等级评估对象编号
     * @param SerialNo 信用等级评估申请流水号
     * @param EvaluateScore 信用等级评分
     * @return 评分所对应的信用评级
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String sObjectType = (String)this.getAttribute("ObjectType");
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        String sSerialNo = (String)this.getAttribute("SerialNo");
        String sEvaluateScore = (String)this.getAttribute("EvaluateScore");
        
        if (sObjectType == null) sObjectType = "";
        if (sObjectNo == null) sObjectNo = "";
        if (sSerialNo == null) sSerialNo = "";
        //如果得到的sEvaluateScore为空或者为null值，则认为分数为0
        if (sEvaluateScore == null || "".equals(sEvaluateScore)) sEvaluateScore = "0";
        
        String sModelNo = "";
        String sSql = "";
        SqlObject so=null;
        ConstantList[0][1] = sEvaluateScore;
        
        //获取此次信用等级评估所用的模板编号
        sSql = " Select ModelNo from EVALUATE_RECORD " +
 	   " where ObjectType =:ObjectType" +
 	   " and ObjectNo =:ObjectNo " +
 	   " and SerialNo =:SerialNo ";
        so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("SerialNo", sSerialNo);
        sModelNo = Sqlca.getString(so);
        if (sModelNo == null) sModelNo = "";
        
        //计算模板下评级分数对应的评级等级结果
        return transformScoreToResult(sModelNo, Sqlca);
    }
    
    //将分值转换为评估结果
    private String transformScoreToResult(String sModelNo, Transaction Sqlca)
        throws Exception
    {
        String sTransformMethod,sResult = "";
        String sSql = "select TransformMethod from EVALUATE_CATALOG where ModelNo =:ModelNo ";
        SqlObject so = new SqlObject(sSql).setParameter("ModelNo", sModelNo);
        ASResultSet rsTemp = Sqlca.getResultSet(so);
        if (rsTemp.next())
        {
            sTransformMethod = rsTemp.getString("TransformMethod");
            if (sTransformMethod != null && sTransformMethod.trim().length() > 0)
            {
                sResult = Expression.getExpressionValue(pretreatExpression(sTransformMethod.trim()),Sqlca).stringValue();
            }   
        }
        rsTemp.getStatement().close();
        return sResult;
    }
    
    //对表达式进行预处理
    private String pretreatExpression(String sCondition) throws Exception
    {
        //替换常量
        sCondition = Expression.pretreatConstant(sCondition,ConstantList);
        return sCondition;
    }
}
