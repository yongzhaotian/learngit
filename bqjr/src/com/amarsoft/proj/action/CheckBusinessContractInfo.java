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
 * @����ͬ��Ϣ������
 * historyLog: copy from car to customer by Dahl 2015-4-4
 */
public class CheckBusinessContractInfo {
	private String serialNo;//��ͬ��ˮ��
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	/**
	 * ����ͬ�е����۾������о����Ƿ�Ϊ�ա����Ϊ�գ�����ݺ�ͬ�ŵ��ŵ�������۾���ͳ��о������浽��ͬ���С�
	 * @author Dahl
	 * @date 2015��5��20��
	 */
	public void checkBCManager(Transaction Sqlca,String serialno) throws Exception{
		String sStores = "";		//�ŵ��
		String sSalesManager = "";	//���۾���ID
		String sCityManager = "";	//���о���ID
		int iFlag = 0;	//��־��0-���۾�������о���Ϊ�գ�1-���۾���Ϊ�գ�2-���о���Ϊ�գ�3-���۾�������о���Ϊ��
		String sSql = "SELECT bc.serialno,bc.stores,bc.salesmanager,bc.citymanager FROM BUSINESS_CONTRACT BC where bc.serialno=:serialno";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno", serialno));
		if(rs.next()){
			sStores = DataConvert.toString(rs.getString("stores"));
			sSalesManager = DataConvert.toString(rs.getString("salesmanager"));
			sCityManager = DataConvert.toString(rs.getString("citymanager"));
		}
		
		//���۾�������о�����Ϊ�գ�����,���´��벻ִ�С�
		if( !"".equals(sSalesManager) && !"".equals(sCityManager) ) return;
		
		if( "".equals(sSalesManager) && !"".equals(sCityManager) )	iFlag = 1;//���۾���Ϊ��
		if( !"".equals(sSalesManager) && "".equals(sCityManager) )	iFlag = 2;//���о���Ϊ��
		if( "".equals(sSalesManager) && "".equals(sCityManager) )	iFlag = 3;//���۾���ͳ��о���Ϊ��
		
		ARE.getLog().info("salesCityNull:"+iFlag+"-------��ͬ�ţ�"+serialno+"-------�ŵ꣺"+sStores+"-------���۾���"+sSalesManager+"-------���о���"+sCityManager);
		
		String sno = "";
		String sSalesManager2 = "";	//���۾���ID
		String sCityManager2 = "";	//���о���ID
		sSql = "select si.sno, si.SALESMANAGER, ui.superId as CITYMANAGER from store_info si ,user_info ui where si.salesmanager=ui.userid and sno = :sno and  identtype = '01'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno", sStores));
		if(rs.next()){
			sno = DataConvert.toString(rs.getString("sno"));
			sSalesManager2 = DataConvert.toString(rs.getString("SALESMANAGER"));
			sCityManager2 = DataConvert.toString(rs.getString("CITYMANAGER"));
		}
		if(rs !=null) rs.close();
		ARE.getLog().info("�ŵ꣺"+sno+"-------���۾���"+sSalesManager2+"-------���о���"+sCityManager2);
		
		if( 1 == iFlag ){//���۾���Ϊ�գ��������۾���
			sSql = "update BUSINESS_CONTRACT set salesmanager = :salesmanager where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("salesmanager", sSalesManager2).setParameter("serialno", serialno));
		}else if( 2 == iFlag ){//���о���Ϊ�գ����³��о���
			sSql = "update BUSINESS_CONTRACT set citymanager = :citymanager where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("citymanager", sCityManager2).setParameter("serialno", serialno));
		}else if( 3 == iFlag){//���۾���ͳ��о���Ϊ�գ��������۾���ͳ��о���
			sSql = "update BUSINESS_CONTRACT set salesmanager = :salesmanager,citymanager = :citymanager where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("salesmanager", sSalesManager2).setParameter("citymanager", sCityManager2).setParameter("serialno", serialno));
		}
		
	}
	
}
