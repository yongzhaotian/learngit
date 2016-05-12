package com.amarsoft.app.billions;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.amarsoft.are.ARE;
import oracle.net.aso.d;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class StoreManagerRelativeCommon {

	public static final String SUCCESS_FLAG = "SUCCESS";
	public static final String FAIL_FLAG = "FAIL";
	
	boolean flag=true;
	private String sNo;
	private String saleType;//��������   add by ybpan CCS-588
	private String VIWEFlag;//��������־λ�����ֵΪ2˵���ǵ����������ҳ��   add by ybpan CCS-588


	private String ewNo;
	public String getEwNo() {
		return ewNo;
	}
	public void setEwNo(String ewNo) {
		this.ewNo = ewNo;
	}
	private String moveDate;
	
	public String getMoveDate() {
		return moveDate;
	}
	public void setMoveDate(String moveDate) {
		this.moveDate = moveDate;
	}
	private String salesmanNos;
	private String userid;
	private String orgid;
	private String serialNos;
	public String getSalesManager() {
		return salesManager;
	}
	public void setSalesManager(String salesManager) {
		this.salesManager = salesManager;
	}

	private String salesManager;
    public String getNewSalesManager() {
		return newSalesManager;
	}
	public void setNewSalesManager(String newSalesManager) {
		this.newSalesManager = newSalesManager;
	}

	private String newSalesManager;

	private String type;
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getSNo() {
		return sNo;
	}
	public void setSNo(String sNo) {
		this.sNo = sNo;
	}
	public String getSalesmanNos() {
		return salesmanNos;
	}
	public void setSalesmanNos(String salesmanNos) {
		this.salesmanNos = salesmanNos==null ? "": salesmanNos;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getOrgid() {
		return orgid;
	}
	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}
	public String getSerialNos() {
		return serialNos;
	}
	public void setSerialNos(String serialNos) {
		this.serialNos = serialNos;
	}
	
	public String getSaleType() {
		return saleType;
	}
	public void setSaleType(String saleType) {
		this.saleType = saleType;
	}
	
	public String getVIWEFlag() {
		return VIWEFlag;
	}
	public void setVIWEFlag(String vIWEFlag) {
		VIWEFlag = vIWEFlag;
	}
	
	
	/**
	 * �ŵ����������Ա
	 * @param Sqlca
	 * @return
	 */
	public String storeRelativeSalesman(Transaction Sqlca) {
		
		String sRetVal = null;
		List<String> hasStoreList = new ArrayList<String>();
		try {
			// �������
			String sql0 = "INSERT INTO STORERELATIVESALESMAN(SERIALNO,SNO,SALESMANNO,INPUTORG,INPUTUSER,INPUTDATE,UPDATEORG,UPDATEUSER,UPDATEDATE,SaleManagerNO,saleType) VALUES(:SERIALNO,:SNO,:SALESMANNO,:INPUTORG,:INPUTUSER,:INPUTDATE,:UPDATEORG,:UPDATEUSER,:UPDATEDATE,:SaleManagerNO,:saleType)";
			// ���ŵ�����۾���
			String sSM = Sqlca.getString(new SqlObject("SELECT SALESMANAGER FROM STORE_INFO WHERE SNO=:SNO").setParameter("SNO", sNo));	// ��ǰ�ŵ꾭��
			salesmanNos = salesmanNos==null ? "": salesmanNos;
			String[] salesNoArry = salesmanNos.split("@");
		
			for (String salesno: salesNoArry) {
				// ��ǰ���۴�������۾���
				String sCurSM = Sqlca.getString(new SqlObject("SELECT DISTINCT SI.SALESMANAGER FROM STORE_INFO SI LEFT JOIN STORERELATIVESALESMAN SS ON  SI.SNO=SS.SNO WHERE SS.SALESMANNO=:SALESMANNO and SType is null")
						.setParameter("SALESMANNO", salesno));
				if (sCurSM!=null && !sCurSM.equals(sSM)) {
					// �Ѿ������������ŵ�
					hasStoreList.add(salesno);
				} else {
					String smSerialNo = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM STORERELATIVESALESMAN WHERE SNO=:SNO AND SALESMANNO=:SALESMANNO and SType is null ")
							.setParameter("SNO", sNo).setParameter("SALESMANNO", salesno));
					
					if (smSerialNo == null&&VIWEFlag!="2") {
						
						String sSerialNo = DBKeyHelp.getSerialNo("StoreRelativeSalesman", "SerialNo");
						Sqlca.executeSQL(new SqlObject(sql0).setParameter("SERIALNO", sSerialNo)
								.setParameter("SNO", sNo).setParameter("SALESMANNO", salesno)
								.setParameter("INPUTORG", orgid).setParameter("INPUTUSER", userid)
								.setParameter("INPUTDATE", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss"))
								.setParameter("UPDATEORG", orgid).setParameter("UPDATEUSER", userid)
								.setParameter("UPDATEDATE", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss"))
								.setParameter("SaleManagerNO", sSM)
								.setParameter("saleType", saleType));
						Sqlca.executeSQL(new SqlObject("update user_info set superid=:SUPERID where userid=:USERID")
								.setParameter("SUPERID", sSM).setParameter("USERID", salesno));
						salesManager=sSM;
						salesmanNos=salesno;
						this.insertHistory(Sqlca);
					}
					
				}
			}
			
			sRetVal = StoreManagerRelativeCommon.SUCCESS_FLAG+"@"+hasStoreList.toString().substring(1, hasStoreList.toString().length()-1);
		} catch (Exception e) {
			e.printStackTrace();
			try { Sqlca.rollback();	} catch (SQLException e1) { e1.printStackTrace(); }
			sRetVal = StoreManagerRelativeCommon.FAIL_FLAG+"@"+e.getMessage();
		} finally {
			
			if (hasStoreList.size()>0) hasStoreList.clear();
		}
		
		return sRetVal;
	}
	
	/**
	 * ���������ѡ�ŵ�
	 * @param Sqlca
	 * @return
	 */
	public String unbindStores(Transaction Sqlca) {
		
		String sRetVal = null;
		try {
			String[] serialNoArray = serialNos.split("@");
			for (int idx=0; idx<serialNoArray.length; idx++) {
				
				String serialNo = serialNoArray[idx];
				
				String sUserId = Sqlca.getString(new SqlObject("select salesmanno from storerelativesalesman where serialno=:SERIALNO")
					.setParameter("SERIALNO", serialNo));//������Ա���
				salesManager= Sqlca.getString(new SqlObject("select SaleManagerNO from storerelativesalesman where serialno=:SERIALNO")
				.setParameter("SERIALNO", serialNo));//���۾�����
				sNo= Sqlca.getString(new SqlObject("select sNo from storerelativesalesman where serialno=:SERIALNO")
				.setParameter("SERIALNO", serialNo));//�ŵ���
				type="02";
				salesmanNos=sUserId;
				this.insertHistory(Sqlca);
			}
			Sqlca.commit();
            for (int idx=0; idx<serialNoArray.length; idx++) {
				
				String serialNo = serialNoArray[idx];
				
				String sUserId = Sqlca.getString(new SqlObject("select salesmanno from storerelativesalesman where serialno=:SERIALNO")
					.setParameter("SERIALNO", serialNo));//������Ա���
				Sqlca.executeSQL(new SqlObject("delete from storerelativesalesman where serialno=:SERIALNO")
					.setParameter("SERIALNO", serialNo));
				Sqlca.executeSQL(new SqlObject("update user_info set superid=:SUPERID where userid=:USERID")
					.setParameter("SUPERID", "").setParameter("USERID", sUserId));
			}
			
			sRetVal = StoreManagerRelativeCommon.SUCCESS_FLAG;
		} catch (Exception e) {
			try { Sqlca.rollback();  } catch (SQLException e1) { e1.printStackTrace(); }
			e.printStackTrace();
			sRetVal = StoreManagerRelativeCommon.FAIL_FLAG;
		} 
		
		return sRetVal; 
	}
	
	
	//�����¼
	public void insertHistory(Transaction Sqlca){
		if(flag){
			salesManager=this.getManager(Sqlca);
		}
		
		String sql = "INSERT INTO STORERELATIVESALESMAN(SERIALNO,SNO,SALESMANNO,INPUTORG,INPUTUSER,INPUTDATE,UPDATEORG,UPDATEUSER,UPDATEDATE,SaleManagerNO,SType) VALUES(:SERIALNO,:SNO,:SALESMANNO,:INPUTORG,:INPUTUSER,:INPUTDATE,:UPDATEORG,:UPDATEUSER,:UPDATEDATE,:SaleManagerNO,:SType)";
		try {
			String sSerialNo = DBKeyHelp.getSerialNo("StoreRelativeSalesman", "SerialNo");
			Sqlca.executeSQL(new SqlObject(sql).setParameter("SERIALNO", sSerialNo)
					.setParameter("SNO", sNo).setParameter("SALESMANNO",salesmanNos)
					.setParameter("INPUTORG", orgid).setParameter("INPUTUSER", userid)
					.setParameter("INPUTDATE", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss"))
					.setParameter("UPDATEORG", orgid).setParameter("UPDATEUSER", userid)
					.setParameter("UPDATEDATE", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss"))
					.setParameter("SaleManagerNO", salesManager)
					.setParameter("SType", type));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	//���������ŵ�����۾���
	public String updateAllManager(Transaction Sqlca){
		try {
			String oldManager=Sqlca.getString(new SqlObject("select salesmanager from store_info where sno=:sno").setParameter("sno", sNo));//��ѯ��ԭ���ŵ�����۾���
			salesManager = oldManager;
			ASResultSet rs=Sqlca.getASResultSet(new SqlObject("select si.sno from store_info si where si.salesmanager=:salesmanager").setParameter("salesmanager", oldManager));//��ѯ��ԭ�����۾������������ŵ�

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			Date dMoveDate = sdf.parse(moveDate);
			Date now = sdf.parse(sdf.format(new Date()));
			
			while(rs.next()){
				String SNO=rs.getString("sno");
				sNo=SNO;
				this.insertResourceMove(Sqlca);	//�����resource_move
				//��Ч�����ǽ���
				if( dMoveDate.equals(now) ){
					//�������۾���
					Sqlca.executeSQL(new SqlObject("update store_info set salesmanager=:salesmanager where sno=:sno")
										.setParameter("salesmanager", newSalesManager).setParameter("sno", SNO));
				}
			}
			rs.close();
			return "SUCESS";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "ERROR";
		}
	}
	
	//���ָ����ŵ�����۾���
	public String updateAllManager1(Transaction Sqlca){
		try {
			//String salesmanPhone="",salesmaneMail="";
			String oldSalesManager=salesManager;
			//��ѯ�����۾�����ֻ�������
			/*ASResultSet rs2=Sqlca.getASResultSet(new SqlObject("select UI.mobiletel,UI.email from user_info UI where UI.userId=:userId").setParameter("userId", newSalesManager));
			if(rs2.next()){
				salesmanPhone=rs2.getString("mobiletel");
				salesmaneMail=rs2.getString("email");
			}
			rs2.close();
			*/
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			Date dMoveDate = sdf.parse(moveDate);
			Date now = sdf.parse(sdf.format(new Date()));
			
			String[] SNO=ewNo.split("@");
			for (String no : SNO) {
				sNo=no;
				this.insertResourceMove(Sqlca);	//�����resource_move
				
				//��Ч�����ǽ���
				if( dMoveDate.equals(now) ){
					//�������۾���
					Sqlca.executeSQL(new SqlObject("update store_info set salesmanager=:salesmanager where sno=:sno")
										.setParameter("salesmanager", newSalesManager).setParameter("sno", no));
					/*
					//���������ŵ�������е����۾���
					Sqlca.executeSQL(new SqlObject("update storerelativesalesman set SALEMANAGERNO=:SALEMANAGERNO where sno=:sno").setParameter("SALEMANAGERNO", newSalesManager).setParameter("sno", no));

					//����user_info����������Ա���ϼ�
					Sqlca.executeSQL(new SqlObject("update user_info UI set UI.Superid=:superId where UI.userId = (select SR.Salesmanno from storerelativesalesman SR where SR.sno=:sno and SType is null and rownum < 2)").setParameter("sno", no).setParameter("superId", newSalesManager));
					
					ASResultSet rs1=Sqlca.getASResultSet(new SqlObject("select ss.salesmanno from storerelativesalesman ss where ss.sno=:sno and SType is null").setParameter("sno", no));
					while(rs1.next()){
						//���ԭ�ŵ��µ����۴��� ��ԭ���۾��������¼
						String oldSalesNo=rs1.getString("salesmanno");
						flag=false;
						type="02";
						sNo=no;
						salesmanNos=oldSalesNo;
						salesManager=oldSalesManager;
						this.insertHistory(Sqlca);
						
				    	Sqlca.executeSQL(new SqlObject("delete from storerelativesalesman where SALESMANNO=:SALESMANNO and sno=:sno and SType is null").setParameter("SALESMANNO", oldSalesNo).setParameter("sno", no));

//						//��ԭ�ŵ��µ����۴��������۾��������¼
				    	type="01";
				    	salesManager=newSalesManager;
				    	this.insertHistory(Sqlca);
				    	
					}
					rs1.close();
					*/
				}
			}
			return "SUCESS";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "ERROR";
		}
	}
	
	//һ�����۾����µ�һ�����۴����������ŵ�������
	//��������ŵ��µ����۴�����������ʷ��¼
	public  void updateAllManager2(Transaction Sqlca){
		try {
			String[] SNO=ewNo.split("@");
			String retrunValue=this.appendSNO(SNO);
			if(!retrunValue.equals("error")){
				for (String no : SNO) {
					//��ѯ��ԭ���۾������ŵ��µ����۴���
					ASResultSet rs3=Sqlca.getASResultSet(new SqlObject("select ss.salesmanno from storerelativesalesman ss where ss.sno=:sno and SType is null").setParameter("sno", no));
					while(rs3.next()){
						String soldSalesNo=rs3.getString("salesmanno");
						ASResultSet rs4=Sqlca.getASResultSet(new SqlObject("select sno, SALESMANNO,SALEMANAGERNO from storerelativesalesman where SALESMANNO=:SALESMANNO and sno not in("+retrunValue+") and SType is null").setParameter("SALESMANNO", soldSalesNo));
					    while(rs4.next()){
					    	String sNos=rs4.getString("sno");
					    	String salesmanNoss=rs4.getString("SALESMANNO");
					    	String salesManagers=rs4.getString("SALEMANAGERNO");
					    	Sqlca.executeSQL(new SqlObject("delete from storerelativesalesman where SALESMANNO=:SALESMANNO and sno=:sno and SType is null")
					    	.setParameter("SALESMANNO", salesmanNoss).setParameter("sno", sNos));
					    	type="02";
					    	sNo=sNos;
					    	salesmanNos=salesmanNoss;
					    	salesManager=salesManagers;
					    	this.insertHistory(Sqlca);
					    }
					    rs4.getStatement().close();
						
					}
				     rs3.getStatement().close();
				}	
				Sqlca.commit();
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}
	
	//���ָ������۴���
	public String updateUserInfo(Transaction Sqlca){
		String[] salesmanArray=salesmanNos.split("@");
		String no=sNo;
		String managerno=salesManager;
		try {
			for(String salesman: salesmanArray){
				//ɾ��ԭ���۴�����ŵ��ϵ���ٲ�����ʷ��¼��
				Sqlca.executeSQL(new SqlObject("delete from storerelativesalesman where SALESMANNO=:SALESMANNO and SType is null").setParameter("SALESMANNO", salesman));
				salesmanNos=salesman;
				salesManager=managerno;
				sNo=no;
				type="02";
				this.insertHistory(Sqlca);
				Sqlca.commit();
				//ת�������������۾����¡��ٲ�����ʷ��¼��
				String sql0 = "INSERT INTO STORERELATIVESALESMAN(SERIALNO,SNO,SALESMANNO,INPUTORG,INPUTUSER,INPUTDATE,UPDATEORG,UPDATEUSER,UPDATEDATE,SaleManagerNO) VALUES(:SERIALNO,:SNO,:SALESMANNO,:INPUTORG,:INPUTUSER,:INPUTDATE,:UPDATEORG,:UPDATEUSER,:UPDATEDATE,:SaleManagerNO)";
				String sSerialNo = DBKeyHelp.getSerialNo("StoreRelativeSalesman", "SerialNo");
				Sqlca.executeSQL(new SqlObject(sql0).setParameter("SERIALNO", sSerialNo)
						.setParameter("SNO", ewNo).setParameter("SALESMANNO", salesman)
						.setParameter("INPUTORG", orgid).setParameter("INPUTUSER", userid)
						.setParameter("INPUTDATE", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss"))
						.setParameter("UPDATEORG", orgid).setParameter("UPDATEUSER", userid)
						.setParameter("UPDATEDATE", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss"))
						.setParameter("SaleManagerNO", newSalesManager));
				salesManager=newSalesManager;
				sNo=ewNo;
				type="01";
				this.insertHistory(Sqlca);
			}
			return "SUCESS";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "ERROR";
		}
	} 
	
	public String getManager(Transaction Sqlca){
		try {
			salesManager=Sqlca.getString(new SqlObject("select si.salesmanager from store_info si where si.sno=:sno").setParameter("sno", sNo));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return salesManager;
	}
	
	public String appendSNO(String[] SNO){
		StringBuffer sb=new StringBuffer();
		if(SNO!=null && SNO.length!=0){
			for (String nos : SNO) {
				sb.append("'"+nos+"',");
			}
			String noos=sb.toString().substring(0, sb.toString().length()-1);
			return noos;
		}else{
			return "error";
		}
		
	}
	
	public String checkCityManager(Transaction Sqlca){
		try {
//			String i=Sqlca.getString(new SqlObject(" select count(serialno) from store_info si where si.salesmanager=:salesmanager").setParameter("salesmanager", salesManager));
//			if(Integer.parseInt(i)>0){
//				return "true";
//			}else{
//				return "false";
//			}
            //true �����Ѿ�����һ�����о�����
            //false ����Ϊһ����û��������ͬһ�����о���
			ASResultSet rs=Sqlca.getASResultSet(new SqlObject("select SALESMANNO from STORERELATIVESALESMAN  st where st.sno=:sno and st.stype is null").setParameter("sno",sNo));
			while(rs.next()){
				String saleName=rs.getString("SALESMANNO");
				ASResultSet rs1=Sqlca.getASResultSet(new SqlObject("select si.citymanager from store_info si where exists(select 1 from STORERELATIVESALESMAN ss where ss.sno=si.sno and ss.salesmanno=:salesmanno and ss.stype is null) and si.citymanager is not null")
				.setParameter("salesmanno", saleName));
				while(rs1.next()){
					String i=rs1.getString("citymanager");
					if(i==null){i="";};
					if(i!="" && !i.equals(salesManager)){
						return "true";
					}
				}
				rs1.close();
			}
			rs.close();
			return "false";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}
	
	public void insertResourceMove(Transaction Sqlca){
		String sql = "insert into resource_move(from_id,to_id,store_id,move_date,add_by,add_date) values(:formId,:toId,:storeId,:moveDate,:addBy,:addDate)";
		try {
			Sqlca.executeSQL(new SqlObject(sql).setParameter("formId", salesManager)
					.setParameter("toId", newSalesManager)
					.setParameter("storeId", sNo)
					.setParameter("moveDate", moveDate)
					.setParameter("addBy", userid)
					.setParameter("addDate", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss")));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void insertResourceMoveForCityManChange(Transaction Sqlca){
		String sql = "insert into resource_move(from_id,to_id,salesManager,move_date,add_by,add_date) values(:formId,:toId,:salesManager,:moveDate,:addBy,:addDate)";
		try {
			Sqlca.executeSQL(new SqlObject(sql).setParameter("formId", salesManager)
					.setParameter("toId", newSalesManager)
					.setParameter("salesManager", sNo)
					.setParameter("moveDate", moveDate)
					.setParameter("addBy", userid)
					.setParameter("addDate", DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss")));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public String updateCityManager(Transaction Sqlca){
		String[] SNO = ewNo.split("@");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		try {
			Date dMoveDate = sdf.parse(moveDate);
			Date now = sdf.parse(sdf.format(new Date()));
			
			for( String no : SNO ){
				sNo=no;
				insertResourceMoveForCityManChange(Sqlca);
				
				if( now.equals(dMoveDate) ){
					String sql = "update user_info set superId=:superId where userId=:userId";
					Sqlca.executeSQL(new SqlObject(sql).setParameter("superId", newSalesManager)
							.setParameter("userId", sNo) );
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR";
		}
		
		
		return "1";
	}
	
	
	/**
	 * �ͷ�ռ����Դ
	 * @param pstmt
	 * @param rs
	 */
	public void closeAll(PreparedStatement pstmt, ResultSet rs) {
		
		if (rs != null) { try {	rs.close(); } catch (SQLException e) { e.printStackTrace();	} }
		if (pstmt != null) { try {	pstmt.close(); } catch (SQLException e) { e.printStackTrace();	} }
	}
}
