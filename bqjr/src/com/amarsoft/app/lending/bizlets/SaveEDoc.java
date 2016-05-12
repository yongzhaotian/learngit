package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 保存电子合同所关联的业务品种
 * @author ljzhong
 *
 */

public class SaveEDoc extends Bizlet {

	/**
	 * 运行方法主体
	 */
	public Object run(Transaction Sqlca) throws Exception {
		//自动获得传入的参数值
		String sTypeNo = (String)this.getAttribute("TypeNo");
		String sEDocNo = (String)this.getAttribute("EDocNo");
		
		//定义变量：返回值、SQL执行语句
		String sReturn = "true";
		String sTypeName = "";
		String sSql = null;
		SqlObject so ;//声明对象
		ASResultSet rs = null;
		
		//将传入的业务品种编号进行区分为数组
		String sTypeNos[] = sTypeNo.split("@");
		
		//删除原电子合同与业务品种关系
		sSql = "Delete From EDOC_RELATIVE Where EDocNo =:EDocNo ";
		so = new SqlObject(sSql).setParameter("EDocNo", sEDocNo);
		Sqlca.executeSQL(so);
		
		//插入新的电子合同与业务品种关系
		for(int i = 0; i < sTypeNos.length; i ++){
			//判断业务品种是否为空
			if(!"".equals(sTypeNos[i])){
				//获取业务品种名称
				sSql = " Select TypeName from BUSINESS_TYPE where TypeNo = :TypeNo";
				so = new SqlObject(sSql).setParameter("TypeNo", sTypeNos[i]);
				rs = Sqlca.getASResultSet(so);
				while(rs.next()){
					sTypeName = rs.getString(1);
				}
				rs.getStatement().close();
				//执行插入
				sSql = " Insert Into EDOC_RELATIVE(TypeNo,TypeName,EDocNo) Values(:TypeNo,:TypeName,:EDocNo) ";
				so = new SqlObject(sSql).setParameter("TypeNo", sTypeNos[i]).setParameter("TypeName", sTypeName).setParameter("EDocNo", sEDocNo);
				Sqlca.executeSQL(so);
			}
			
		}
		
		return sReturn;
	}
	
	

}
