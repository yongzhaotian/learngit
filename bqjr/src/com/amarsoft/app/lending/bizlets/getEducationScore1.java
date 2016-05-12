package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class getEducationScore1 extends Bizlet {
    /**
     * 此类用于计算投资管理信用等级评分模板中对学历得分项目值的计算
     * 计算方法：学历得分 = (∑各学历层次人数×权重/人数×5) 
     * @param SerialNo 信用等级评估申请流水号
     * @return 投资管理学历得分(项目值)
     * @author yxzhang
     * @date 2010-04-07
     */
    public Object run(Transaction Sqlca) throws Exception { 
        String sSerialNo = (String)this.getAttribute("SerialNo");
        if (sSerialNo == null) sSerialNo = "";
       
        String sSqlGra = "";
        String sSqlUnGra = "";
        String sSqlJunior = "";
        ASResultSet rs=null;
        
        double dItemValueGra = 0.0;//研究生人数
        double dItemValueUnGra = 0.0;//本科生人数
        double dItemValueJunior = 0.0;//大专生人数
        double dItemValue = 0.0;//总人数
        
        double dCoefficient_Gra = 1.2;//研究生信用等级评估权值
        double dCoefficient_UnGra = 1.0;//本科生信用等级评估权值
        double dCoefficient_Junior = 0.8;//大专生信用等级评估权值
        
        double dScore_Gra = 0.0;//研究生信用等级评估得分
        double dScore_UnGra = 0.0;//本科生信用等级评估得分
        double dScore_Junior = 0.0;//大专生信用等级评估得分
        double dScore_Edu = 0.0;//学历得分：等于以上三项之和   
        
        sSqlGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
                   "where ER.SerialNo='"+ sSerialNo +"'  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.3.1'";          
        dItemValueGra = (Sqlca.getDouble(sSqlGra)).doubleValue();
        
        sSqlUnGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
                  "where ER.SerialNo='"+ sSerialNo +"'  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.3.2'";
        dItemValueUnGra = Sqlca.getDouble(sSqlUnGra).doubleValue();
        
        sSqlJunior = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
              "where ER.SerialNo='"+ sSerialNo +"'  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.3.3'";       
        dItemValueJunior = Sqlca.getDouble(sSqlJunior).doubleValue();
      
        
        dItemValue = dItemValueGra + dItemValueUnGra + dItemValueJunior;
            
        if(dItemValueGra != 0){
            dScore_Gra =  dItemValueGra * dCoefficient_Gra / dItemValue * 5;   
        }
        if(dItemValueUnGra != 0){
            dScore_UnGra =  dItemValueUnGra * dCoefficient_UnGra / dItemValue * 5;    
        }
        if(dItemValueJunior != 0){
            dScore_Junior =  dItemValueJunior * dCoefficient_Junior / dItemValue * 5; 
        }

        dScore_Edu = dScore_Gra + dScore_UnGra + dScore_Junior;
        return Double.toString(dScore_Edu);
    }
}
