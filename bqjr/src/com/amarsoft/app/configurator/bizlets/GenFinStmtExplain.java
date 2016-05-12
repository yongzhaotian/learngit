package com.amarsoft.app.configurator.bizlets;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.finance.Report;

/**
 * @author William
 * 将财务报表公式的中文解释生成并更新到formulaexp1、formulaexp2字段中。
 */
public class GenFinStmtExplain extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sModelNo = (String)this.getAttribute("ModelNo");
		
		String sSql = "select MODELNO,ROWNO,COL1DEF,COL2DEF,FormulaExp1,FormulaExp2 from REPORT_MODEL where ModelNo=:ModelNo "; 
		SqlObject so = new SqlObject(sSql);
		so.setParameter("ModelNo",sModelNo);
		String[][] sModelTmlt = Sqlca.getStringMatrix(so);
		
		
		try{
			//翻译公式,放入2维数组
			for(int i=0;i<sModelTmlt.length;i++){
				if(sModelTmlt[i][2]!=null) sModelTmlt[i][4] = Report.transExpression(0,sModelTmlt[i][2].trim(),Sqlca);
				if(sModelTmlt[i][3]!=null) sModelTmlt[i][5] = Report.transExpression(0,sModelTmlt[i][3].trim(),Sqlca);
			}
		}catch(Exception ex){
			throw new Exception("翻译公式失败："+ex);
		}
		
		//将2维数组更新到数据库
		sSql = "update REPORT_MODEL set FormulaExp1=?,FormulaExp2=? where MODELNO=? and ROWNO=?";
		PreparedStatement pstm = Sqlca.getConnection().prepareStatement(sSql);

		for(int i=0;i<sModelTmlt.length;i++){
			pstm.setString(1, sModelTmlt[i][4]);
			pstm.setString(2, sModelTmlt[i][5]);
			pstm.setString(3, sModelTmlt[i][0]);
			pstm.setString(4, sModelTmlt[i][1]);
			pstm.addBatch();
		}
		try{
			pstm.executeBatch();
		}catch(Exception ex){
			throw new Exception("更新数据库失败："+ex);
		}
		
		// 关闭数据库资源
		if (pstm != null) {
			try{
				pstm.close();
				pstm = null;
			}catch(SQLException e){System.out.println("pstm.close()"+e);}
		}
		
		return "succeeded";
	}

}
