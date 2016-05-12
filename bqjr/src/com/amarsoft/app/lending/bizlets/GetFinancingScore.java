package com.amarsoft.app.lending.bizlets;

/**
 * @author pkyan 2010-04-02
 * 获取融资得分
 */
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetFinancingScore extends Bizlet{


	public Object run(Transaction Sqlca) throws Exception {

		String sSerialNo = (String)this.getAttribute("SerialNo");//获取该笔申请号
		String sModelNo = (String)this.getAttribute("ModelNo");//获取该笔申请的模板号，主要用来控制下面的ItemNo的取值
		if(sSerialNo == null) sSerialNo = "";
		if(sModelNo == null) sModelNo = "";
		
		//定义所需参数
		String sql = ""; //定义sql
		double dScore =0;//定义获取融资得分变量
		ASResultSet rs = null;
		
		if(sModelNo.equals("008")||sModelNo.equals("009")){//这两个模板分别是"投资管理企业信用等级评估表"和"城建开发与地产企业信用等级评估表"
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo = '"+sSerialNo+"' and ItemNo >='1.2.7.1' and ItemNo <'1.2.7.4'";
		}else if(sModelNo.equals("003")){//这个模板是商业企业信用等级评估表
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo ='"+sSerialNo+"' and ItemNo >='1.2.a.1' and ItemNo <'1.2.a.5'";
		}else if(sModelNo.equals("005")){//用于获得施工企业信用等级评估表的融资得分
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo ='"+sSerialNo+"' and ItemNo >='1.2.9.1' and ItemNo <='1.2.9.5'";
		}else{
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo ='"+sSerialNo+"' and ItemNo >='1.2.9.1' and ItemNo <'1.2.9.5'";
		}
		
		rs=Sqlca.getASResultSet(sql);
		if(rs.next()){
			dScore = rs.getDouble("Score");
		}else{
			throw new Exception("该评估模板没有融资得分指标！");
		}
		rs.getStatement().close();
		return Double.toString(dScore);
	}

}
