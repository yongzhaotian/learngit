package com.amarsoft.app.configurator.bizlets;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.finance.Report;

/**
 * @author William
 * �����񱨱�ʽ�����Ľ������ɲ����µ�formulaexp1��formulaexp2�ֶ��С�
 */
public class GenFinStmtExplain extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sModelNo = (String)this.getAttribute("ModelNo");
		
		String sSql = "select MODELNO,ROWNO,COL1DEF,COL2DEF,FormulaExp1,FormulaExp2 from REPORT_MODEL where ModelNo=:ModelNo "; 
		SqlObject so = new SqlObject(sSql);
		so.setParameter("ModelNo",sModelNo);
		String[][] sModelTmlt = Sqlca.getStringMatrix(so);
		
		
		try{
			//���빫ʽ,����2ά����
			for(int i=0;i<sModelTmlt.length;i++){
				if(sModelTmlt[i][2]!=null) sModelTmlt[i][4] = Report.transExpression(0,sModelTmlt[i][2].trim(),Sqlca);
				if(sModelTmlt[i][3]!=null) sModelTmlt[i][5] = Report.transExpression(0,sModelTmlt[i][3].trim(),Sqlca);
			}
		}catch(Exception ex){
			throw new Exception("���빫ʽʧ�ܣ�"+ex);
		}
		
		//��2ά������µ����ݿ�
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
			throw new Exception("�������ݿ�ʧ�ܣ�"+ex);
		}
		
		// �ر����ݿ���Դ
		if (pstm != null) {
			try{
				pstm.close();
				pstm = null;
			}catch(SQLException e){System.out.println("pstm.close()"+e);}
		}
		
		return "succeeded";
	}

}
