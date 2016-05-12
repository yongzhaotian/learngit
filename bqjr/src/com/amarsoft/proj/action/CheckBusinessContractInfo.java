package com.amarsoft.proj.action;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * @author pli2
 * @检查合同信息完整性
 * historyLog: copy from car to customer by Dahl 2015-4-4
 */
public class CheckBusinessContractInfo {
	private String serialNo;//合同流水号
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	/**
	 * 检查合同中的销售经理或城市经理是否为空。如果为空，则根据合同号的门店查其销售经理和城市经理，保存到合同表中。
	 * @author Dahl
	 * @date 2015年5月20日
	 */
	public void checkBCManager(Transaction Sqlca,String serialno) throws Exception{
		String sStores = "";		//门店号
		String sSalesManager = "";	//销售经理ID
		String sCityManager = "";	//城市经理ID
		int iFlag = 0;	//标志，0-销售经理与城市经理不为空，1-销售经理为空，2-城市经理为空，3-销售经理与城市经理为空
		String sSql = "SELECT bc.serialno,bc.stores,bc.salesmanager,bc.citymanager FROM BUSINESS_CONTRACT BC where bc.serialno=:serialno";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno", serialno));
		if(rs.next()){
			sStores = DataConvert.toString(rs.getString("stores"));
			sSalesManager = DataConvert.toString(rs.getString("salesmanager"));
			sCityManager = DataConvert.toString(rs.getString("citymanager"));
		}
		
		//销售经理与城市经理都不为空，返回,以下代码不执行。
		if( !"".equals(sSalesManager) && !"".equals(sCityManager) ) return;
		
		if( "".equals(sSalesManager) && !"".equals(sCityManager) )	iFlag = 1;//销售经理为空
		if( !"".equals(sSalesManager) && "".equals(sCityManager) )	iFlag = 2;//城市经理为空
		if( "".equals(sSalesManager) && "".equals(sCityManager) )	iFlag = 3;//销售经理和城市经理都为空
		
		ARE.getLog().info("salesCityNull:"+iFlag+"-------合同号："+serialno+"-------门店："+sStores+"-------销售经理："+sSalesManager+"-------城市经理："+sCityManager);
		
		String sno = "";
		String sSalesManager2 = "";	//销售经理ID
		String sCityManager2 = "";	//城市经理ID
		sSql = "select si.sno, si.SALESMANAGER, ui.superId as CITYMANAGER from store_info si ,user_info ui where si.salesmanager=ui.userid and sno = :sno and  identtype = '01'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno", sStores));
		if(rs.next()){
			sno = DataConvert.toString(rs.getString("sno"));
			sSalesManager2 = DataConvert.toString(rs.getString("SALESMANAGER"));
			sCityManager2 = DataConvert.toString(rs.getString("CITYMANAGER"));
		}
		if(rs !=null) rs.close();
		ARE.getLog().info("门店："+sno+"-------销售经理："+sSalesManager2+"-------城市经理："+sCityManager2);
		
		if( 1 == iFlag ){//销售经理为空，更新销售经理
			sSql = "update BUSINESS_CONTRACT set salesmanager = :salesmanager where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("salesmanager", sSalesManager2).setParameter("serialno", serialno));
		}else if( 2 == iFlag ){//城市经理为空，更新城市经理
			sSql = "update BUSINESS_CONTRACT set citymanager = :citymanager where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("citymanager", sCityManager2).setParameter("serialno", serialno));
		}else if( 3 == iFlag){//销售经理和城市经理都为空，更新销售经理和城市经理
			sSql = "update BUSINESS_CONTRACT set salesmanager = :salesmanager,citymanager = :citymanager where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("salesmanager", sSalesManager2).setParameter("citymanager", sCityManager2).setParameter("serialno", serialno));
		}
		
	}
	
}
