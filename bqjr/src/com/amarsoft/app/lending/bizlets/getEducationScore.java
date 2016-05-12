package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class getEducationScore extends Bizlet {
    /**
     * 此类用于计算在各信用等级评分模板中对学历得分项目值的计算
     * 计算方法：学历得分 = (∑各学历层次人数×权重/人数×2) + 总经理是否博士得分   
     * @param SerialNo 信用等级评估申请流水号
     * @return 学历得分(项目值)
     * @author zhuang
     * @date 2010-03-24
     */
    public Object run(Transaction Sqlca) throws Exception { 
        String sSerialNo = (String)this.getAttribute("SerialNo");
        if (sSerialNo == null) sSerialNo = "";
       
        String sSqlGra = "";
        String sSqlUnGra = "";
        String sSqlJunior = "";
        String sSqlTec = ""; 
        String sSqlDoc = "";
        ASResultSet rs=null;
        
        double dItemValueGra = 0.0;//研究生人数
        double dItemValueUnGra = 0.0;//本科生人数
        double dItemValueJunior = 0.0;//大专生人数
        double dItemValueTec = 0.0;//中专生人数
        double dItemValue = 0.0;//总人数
        
        double dCoefficient_Gra = 1.2;//研究生信用等级评估权值
        double dCoefficient_UnGra = 1.0;//本科生信用等级评估权值
        double dCoefficient_Junior = 0.8;//大专生信用等级评估权值
        double dCoefficient_Tec = 0.5;//中专生信用等级评估权值
        
        double dScore_Gra = 0.0;//研究生信用等级评估得分
        double dScore_UnGra = 0.0;//本科生信用等级评估得分
        double dScore_Junior = 0.0;//大专生信用等级评估得分
        double dScore_Tec = 0.0;//中专生信用等级评估得分
        double dScore_Doc = 0.0;//总经理是否博士得分
        double dScore_Edu = 0.0;//学历得分：等于以上四项之和   
        
        SqlObject so,so1,so2,so3,so4 ;
        sSqlGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
        "where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.1'";
        so = new SqlObject(sSqlGra).setParameter("SerialNo", sSerialNo);
        dItemValueGra = DataConvert.toDouble(Sqlca.getString(so));
        
        sSqlUnGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
        "where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.2'";
        so1 = new SqlObject(sSqlUnGra).setParameter("SerialNo", sSerialNo);
        dItemValueUnGra = DataConvert.toDouble(Sqlca.getString(so1));
        
        sSqlJunior = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
        "where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.3'"; 
        so2 = new SqlObject(sSqlJunior).setParameter("SerialNo", sSerialNo);
        dItemValueJunior = DataConvert.toDouble(Sqlca.getString(so2));
        
        sSqlTec = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
		"where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.4'";
        so3 = new SqlObject(sSqlTec).setParameter("SerialNo",sSerialNo);
        dItemValueTec = DataConvert.toDouble(Sqlca.getString(so3));
        dItemValue = dItemValueGra + dItemValueUnGra + dItemValueJunior + dItemValueTec;
        
        //取得总经理是否博士的分值
        sSqlDoc = "select EvaluateScore from EVALUATE_DATA where SerialNo=:SerialNo  and ItemNo = '1.1.1.5'";
        so4 = new SqlObject(sSqlDoc).setParameter("SerialNo", sSerialNo);
        dScore_Doc = DataConvert.toDouble(Sqlca.getString(so4));
                
        //计算各个学历层次的评估分数        
        if( dItemValueGra==0 && dItemValueUnGra==0 && dItemValueJunior==0 && dItemValueTec==0 ){
            return Double.toString(dScore_Doc);           
        }        
        if(dItemValueGra != 0){
            dScore_Gra =  dItemValueGra * dCoefficient_Gra / dItemValue * 2;     
        }
        if(dItemValueUnGra != 0){
            dScore_UnGra =  dItemValueUnGra * dCoefficient_UnGra / dItemValue * 2;     
        }
        if(dItemValueJunior != 0){
            dScore_Junior =  dItemValueJunior * dCoefficient_Junior / dItemValue * 2;     
        }
        if(dItemValueTec != 0){
            dScore_Tec =  dItemValueTec * dCoefficient_Tec / dItemValue * 2;     
        }

        dScore_Edu = dScore_Gra + dScore_UnGra + dScore_Junior + dScore_Tec + dScore_Doc;
        return Double.toString(dScore_Edu);
    }
}
