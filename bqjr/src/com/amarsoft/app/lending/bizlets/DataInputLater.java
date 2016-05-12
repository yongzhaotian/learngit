package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 *  Description:   垫款补登时更新操作，即更新所选垫款合同关联的垫款借据的原借据号字段，并且填入更新标志. 
 *         Time:   2009/10/26    
 *       @author   PWang 
 *        @param   BCSerialNo,OriBDSerialNo            
 */
public class DataInputLater extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		//获取参数：合同流水号，原借据流水号。
		String sBCSerialNo = (String)this.getAttribute("BCSerialNo");	
		String sOriBDSerialNo = (String)this.getAttribute("OriBDSerialNo");	
		String sBDSerialNo = "";
		String sSql ="";
		ASResultSet rs = null;
		SqlObject so ;//声明对象
		
		try{
			//由批量产生垫款合同,一笔垫款借据对应一笔垫款合同
			//获取该垫款合同关联的垫款借据流水号
				sSql = "select SerialNo from Business_Duebill where RelativeSerialNo2 =:RelativeSerialNo2 ";
				so = new SqlObject(sSql).setParameter("RelativeSerialNo2", sBCSerialNo);
				rs = Sqlca.getASResultSet(so);
	
				if(rs.next()){
					sBDSerialNo = rs.getString("SerialNo");
				}else{
					//没有关联合同的借据流水号，返回执行信息标志“2”。
					return "2";
				}
			}
			catch(Exception e){
				ARE.getLog().error(e.getMessage(),e);
				throw e;
			}
			finally{
				rs.getStatement().close();
				rs = null;
			}

		try{
			//更新垫款借据中的原借据流水号字段。
				sSql="Update Business_Duebill set RelativeDuebillNo =:RelativeDuebillNo where SerialNo =:SerialNo";	
				so = new SqlObject(sSql).setParameter("RelativeDuebillNo", sOriBDSerialNo).setParameter("SerialNo", sBDSerialNo);
				Sqlca.executeSQL(so);
			//填入垫款借据的更新标志。
				sSql="Update Business_Contract set ReinforceFlag = '020' where SerialNo =:SerialNo ";
				so = new SqlObject(sSql).setParameter("SerialNo", sBCSerialNo);
				Sqlca.executeSQL(so);
			//返回执行成功信息标志“1”。
				return "1";				
			}
			catch(Exception e){
				throw new Exception(e);
			}
	
	}

}
