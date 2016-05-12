package com.amarsoft.app.lending.bizlets;

import com.amarsoft.amarscript.Expression;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ���������������õȼ��������϶�����ת��Ϊ��Ӧ��������������Ϊ���õȼ������ж���ģ�壬
 * ����ͬ��ģ�������ı�׼���ܲ�ͬ�������Ҫʹ�ô��������н��ת����
 * @author cbsu 2009/11/18
 */
public class GetEvaluateResult extends Bizlet {

    //�����滻AmarScript�еĲ����б�
    private String ConstantList[][] = {
                                  {"#TotalScore", ""},
                              };
    /**
     * @param ObjectType ���õȼ���������
     * @param ObjectNo ���õȼ�����������
     * @param SerialNo ���õȼ�����������ˮ��
     * @param EvaluateScore ���õȼ�����
     * @return ��������Ӧ����������
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String sObjectType = (String)this.getAttribute("ObjectType");
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        String sSerialNo = (String)this.getAttribute("SerialNo");
        String sEvaluateScore = (String)this.getAttribute("EvaluateScore");
        
        if (sObjectType == null) sObjectType = "";
        if (sObjectNo == null) sObjectNo = "";
        if (sSerialNo == null) sSerialNo = "";
        //����õ���sEvaluateScoreΪ�ջ���Ϊnullֵ������Ϊ����Ϊ0
        if (sEvaluateScore == null || "".equals(sEvaluateScore)) sEvaluateScore = "0";
        
        String sModelNo = "";
        String sSql = "";
        SqlObject so=null;
        ConstantList[0][1] = sEvaluateScore;
        
        //��ȡ�˴����õȼ��������õ�ģ����
        sSql = " Select ModelNo from EVALUATE_RECORD " +
 	   " where ObjectType =:ObjectType" +
 	   " and ObjectNo =:ObjectNo " +
 	   " and SerialNo =:SerialNo ";
        so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("SerialNo", sSerialNo);
        sModelNo = Sqlca.getString(so);
        if (sModelNo == null) sModelNo = "";
        
        //����ģ��������������Ӧ�������ȼ����
        return transformScoreToResult(sModelNo, Sqlca);
    }
    
    //����ֵת��Ϊ�������
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
    
    //�Ա��ʽ����Ԥ����
    private String pretreatExpression(String sCondition) throws Exception
    {
        //�滻����
        sCondition = Expression.pretreatConstant(sCondition,ConstantList);
        return sCondition;
    }
}
