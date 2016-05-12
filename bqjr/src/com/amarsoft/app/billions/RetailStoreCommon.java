package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class RetailStoreCommon {

	private String serialNo;
	private String opinionNo;
	private String objectNo;
	private String retailNo;
	private String startDate;
	private String endDate;
	private String citys;
	private String citynames;
	private String userId;
	private String tableName;
	private String colName;
	private String sNo;// 门店编号   add by ybpan  at 20150408 CCS-588 系统中增加中域ALDI模式的客户主管
	private String ProductType;//add CCS-159-现金贷中多贷款问题
	//add by phe 2015/06/02
	private String sLoaner;
	private String orgid; //登录机构 tangyb add 
	
	public String getOrgid() {
		return orgid;
	}
	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}
	public String getSLoaner() {
		return sLoaner;
	}
	public void setSLoaner(String sLoaner) {
		this.sLoaner = sLoaner;
	}
	//end by phe
	//CCS-344 贷款人操作中无法添加所有城市
	private String AreaCodes;
	
	
	public String getSNo() {
		return sNo;
	}
	public void setSNo(String sNo) {
		this.sNo = sNo;
	}
	public String getAreaCodes() {
		return AreaCodes;
	}
	public void setAreaCodes(String areaCodes) {
		AreaCodes = areaCodes;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getRetailNo() {
		return retailNo;
	}
	public void setRetailNo(String retailNo) {
		this.retailNo = retailNo;
	}
	public String getOpinionNo() {
		return opinionNo;
	}
	public void setOpinionNo(String opinionNo) {
		this.opinionNo = opinionNo;
	}
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getCitys() {
		return citys;
	}
	public void setCitys(String citys) {
		this.citys = citys;
	}
	public String getCitynames() {
		return citynames;
	}
	public void setCitynames(String citynames) {
		this.citynames = citynames;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getTableName() {
		return tableName;
	}
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	public String getColName() {
		return colName;
	}
	public void setColName(String colName) {
		this.colName = colName;
	}
	public String getProductType() {
		return ProductType;
	}
	public void setProductType(String productType) {
		ProductType = productType;
	}
	/**
	 * 产品范畴和门店多选
	 * @param Sqlca
	 * @return
	 */
	public String getStoreRelativeProductMulti(Transaction Sqlca) {
		
		try {
			
			String sUserId = retailNo;
			String sOrgId = Sqlca.getString(new SqlObject("Select BelongOrg from User_Info where UserId=:UserId").setParameter("UserId", sUserId));
			String sInputDate =  DateX.format(new java.util.Date(),"yyyy/MM/dd");
			
			String[] pcNos = serialNo.split("@");
			String[] sNos = objectNo.split("@");
			for (int i=0; i<pcNos.length; i++) {
				String sPcName = Sqlca.getString(new SqlObject("Select ProductName from Product_Types where ProductID=:ProductID")
						.setParameter("ProductID", pcNos[i]));
				
				for (int j=0; j<sNos.length; j++) {
					ASResultSet rs = Sqlca.getResultSet(new SqlObject("Select SNo,SName from Store_Info where SerialNo=:SerialNo").setParameter("SerialNo", sNos[j]));
					String sSNo = "";
					String sSName = "";
					if (rs.next()) {
						sSNo = rs.getString("SNo");
						sSName = rs.getString("SName");
					}
					rs.close();
					// 检查该商品范畴与门店是否已经关联
					String tSerialNo = Sqlca.getString(new SqlObject("select SerialNo from StoreRelativeProduct where SNo= :SNo and PNo= :PNo")
							.setParameter("SNo", sSNo).setParameter("PNo", pcNos[i]));
					if (tSerialNo == null) {
						String insertSql = "insert into StoreRelativeProduct(SerialNo,SNo,SSerialNo,SName,PNo,PName,InputOrg,InputUser,InputDate,UpdateOrg,UpdateUser,UpdateDate)"+
								" values(:SerialNo,:SNo,:SSerialNo,:SName,:PNo,:PName,:InputOrg,:InputUser,:InputDate,:UpdateOrg,:UpdateUser,:UpdateDate)";
						SqlObject asql = new SqlObject(insertSql);
						String sSerialNo = DBKeyHelp.getSerialNo("StoreRelativeProduct", "SerialNo");
						asql.setParameter("SerialNo", sSerialNo).setParameter("SNo", sSNo).setParameter("SSerialNo", sNos[j])
							.setParameter("SName", sSName).setParameter("PNo", pcNos[i]).setParameter("PName", sPcName)
							.setParameter("InputOrg", sOrgId).setParameter("InputUser", sUserId)
							.setParameter("InputDate", sInputDate).setParameter("UpdateOrg", sOrgId)
							.setParameter("UpdateUser", sUserId).setParameter("UpdateDate", sInputDate);
						Sqlca.executeSQL(asql); 
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "FAIL";
		}
		
		return "SUCCESS";
	}
	
	/**
	 * 门店关联邮寄门店
	 * @param Sqlca
	 * @return
	 */
	public String getStoreRelativePostStore(Transaction Sqlca) {
		
		try {
			
			String sql = "select SNo,SName,RelativeSNo,RelativeSName,InputOrg,InputUser,InputDate,UpdateOrg,UpdateUser,UpdateDate from StoreRelativePoststore where SerialNo=:SerialNo";
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("SerialNo", serialNo));
			if (rs.next()) {
				String SNo = rs.getString("SNo");
				String SName = Sqlca.getString(new SqlObject("Select SName from Store_Info where SNo=:SNo").setParameter("SNo", SNo));
				String RelativeSNo = rs.getString("RelativeSNo");
				String RelativeSName = rs.getString("RelativeSName");
				String inputOrg = rs.getString("InputOrg");
				String inputUser = rs.getString("InputUser");
				String inputDate = rs.getString("InputDate");
				String updateOrg = rs.getString("UpdateOrg");
				String updateUser = rs.getString("UpdateUser");
				String updateDate = rs.getString("UpdateDate");
				String[] relativeSNoArray = RelativeSNo.split("@");
				String[] relativeSNoNameArray = RelativeSName.split("@");
				
				if (relativeSNoArray.length>0) {
					
					Sqlca.executeSQL(new SqlObject("delete from StoreRelativePoststore where SerialNo=:SerialNo").setParameter("SerialNo", serialNo));
					for (int i=0; i<relativeSNoArray.length; i++) {
						
						// 生产门店与关联门店关系的记录				
						String tSerialNo = Sqlca.getString(new SqlObject("select SerialNo from StoreRelativePoststore where SNo= :SNo and RelativeSNo= :RelativeSNo")
								.setParameter("SNo", SNo).setParameter("RelativeSNo", relativeSNoArray[i]));
						if (tSerialNo == null) {
							
							String insertSql = "insert into StoreRelativePoststore(SerialNo,SNo,SName,RelativeSNo,RelativeSName,InputOrg,InputUser,InputDate,UpdateOrg,UpdateUser,UpdateDate)"+
									" values(:SerialNo,:SNo,:SName,:RelativeSNo,:RelativeSName,:InputOrg,:InputUser,:InputDate,:UpdateOrg,:UpdateUser,:UpdateDate)";

							SqlObject asql = new SqlObject(insertSql).setParameter("SerialNo", DBKeyHelp.getSerialNo("Storerelativepoststore", "SerialNo"))
										.setParameter("SNo", SNo).setParameter("SName", SName)
										.setParameter("RelativeSNo", relativeSNoArray[i])
										.setParameter("RelativeSName", relativeSNoNameArray[i])
										.setParameter("InputOrg", inputOrg).setParameter("InputUser", inputUser)
										.setParameter("InputDate", inputDate).setParameter("UpdateOrg", updateOrg)
										.setParameter("UpdateUser", updateUser).setParameter("UpdateDate", updateDate);
							Sqlca.executeSQL(asql); 
						}
					}
				}
			}
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
			try { Sqlca.rollback();	} catch (SQLException e1) { e1.printStackTrace(); }
			return "FAIL";
		}
		
		return "SUCCESS";
	}
	
	/**
	 * 门店关联销售人员
	 * @param Sqlca
	 * @return
	 */
	public String getStoreRelativeSalesman(Transaction Sqlca) {
		
		StringBuffer sbNoSameManager = new StringBuffer();
		
		try {
			
			String sql = "select SNo,SalesmanNo,InputOrg,InputUser,InputDate,UpdateOrg,UpdateUser,UpdateDate from StoreRelativeSalesman where SerialNo= :SerialNo";
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("SerialNo", serialNo));
			if (rs.next()) {
				String SNo = rs.getString("SNo");
				String SName = Sqlca.getString(new SqlObject("Select SName from Store_Info where SNo=:SNo").setParameter("SNo", SNo));
				String salesmanNo = rs.getString("SalesmanNo");
				String inputOrg = rs.getString("InputOrg");
				String inputUser = rs.getString("InputUser");
				String inputDate = rs.getString("InputDate");
				String updateOrg = rs.getString("UpdateOrg");
				String updateUser = rs.getString("UpdateUser");
				String updateDate = rs.getString("UpdateDate");
				String[] salesmanNos = salesmanNo.split("@");
				
				// 添加门店的门店销售经理
				String sSaleManager = Sqlca.getString(new SqlObject("select Salesmanager from Store_Info where SNo=:SNo").setParameter("SNo", SNo));
				
				if (salesmanNos.length>0) {
					
					Sqlca.executeSQL(new SqlObject("delete from StoreRelativeSalesman where SerialNo= :SerialNo").setParameter("SerialNo", serialNo));
					for (int i=0; i<salesmanNos.length; i++) {
						
						// 生产门店与销售人员关联关系的记录				
						String sSerialNo = Sqlca.getString(new SqlObject("select SerialNo from StoreRelativeSalesman where SNo= :SNo and SalesmanNo= :SalesmanNo")
								.setParameter("SNo", SNo).setParameter("SalesmanNo", salesmanNos[i]));
						if (sSerialNo == null) {
							// 判断该销售人员的是否属于同一销售经理
							String sCurSalesmanager = "fuck you man!"; //Sqlca.getString(new SqlObject("select Salesmanager from Store_Info where SNo=(select SNo from StoreRelativeSalesman where SalesmanNo=:SalesmanNo)").setParameter("SalesmanNo", salesmanNos[i]));
							
							if (sCurSalesmanager!=null && !sCurSalesmanager.equals(sSaleManager) && "fuck you".equals(sCurSalesmanager)) {
								sbNoSameManager.append(salesmanNos[i]).append("@");
							}
							
							if (sSaleManager.equals(sCurSalesmanager) || sCurSalesmanager==null || true) {
								
								// 插入记录
								String insertSql = "insert into StoreRelativeSalesman(SerialNo,SNo,SName,SalesmanNo,SalesmanName,InputOrg,InputUser,InputDate,UpdateOrg,UpdateUser,UpdateDate)"+
										" values(:SerialNo,:SNo,:SName,:SalesmanNo,:SalesmanName,:InputOrg,:InputUser,:InputDate,:UpdateOrg,:UpdateUser,:UpdateDate)";
								SqlObject asql = new SqlObject(insertSql);
								String sSerialNo1 = "";
								if (i <= 0 && !"".equals(serialNo)) sSerialNo1 = serialNo;
								if (i > 0) sSerialNo1 = DBKeyHelp.getSerialNo("StoreRelativeSalesman", "SerialNo");
								asql.setParameter("SerialNo", sSerialNo1).setParameter("SNo", SNo).setParameter("SalesmanNo", salesmanNos[i]).setParameter("SName", SName)
									.setParameter("SalesmanName", Sqlca.getString(new SqlObject("Select UserName from User_Info where UserId=:UserId").setParameter("UserId", salesmanNos[i])))
									.setParameter("InputOrg", inputOrg).setParameter("InputUser", inputUser)
									.setParameter("InputDate", inputDate).setParameter("UpdateOrg", updateOrg)
									.setParameter("UpdateUser", updateUser).setParameter("UpdateDate", updateDate);
								Sqlca.executeSQL(asql); 
								// 更新当前销售人员上级为门店销售经理
								//Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:SuperId where UserId=:UserId and Status='1' and IsCar='02'")
										//.setParameter("SuperId", sSaleManager).setParameter("UserId", salesmanNos[i]));
							}
						}
					}
				}
			}
			
			if (rs != null) 
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
			try { Sqlca.rollback();	} catch (SQLException e1) { e1.printStackTrace(); }
			return "FAIL";
		}
		
		String sNoSameManager = "";
		if (sbNoSameManager.length()>0) sNoSameManager = sbNoSameManager.deleteCharAt(sbNoSameManager.length()-1).toString();
		return "SUCCESS~"+ sNoSameManager;
	}
	
	/*
	 * 当门店管理销售发生错误是，修复数据一致性
	 */
	public String checkStoreRelativeSalesman(Transaction Sqlca) {
		
		String sRetVal = "SUCCESS";
		
		// 查询当前门店下销售人员或门店名称为空记录
		String sql = "SELECT SERIALNO  FROM STORERELATIVESALESMAN where SNO=:SNO and (SNAME is null or SALESMANNAME is null)";
		try {
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("SNO", serialNo));
			while (rs.next()) {
				String uSql = "UPDATE STORERELATIVESALESMAN SS SET SS.SNAME=(SELECT SI.SNAME FROM STORE_INFO SI WHERE SI.SNO=SS.SNO),"
						+ " SALESMANNAME=(SELECT UI.USERNAME FROM USER_INFO UI WHERE UI.USERID=SS.SALESMANNO) WHERE SS.SERIALNO=:SERIALNO";
				Sqlca.executeSQL(new SqlObject(uSql).setParameter("SERIALNO", rs.getString("SERIALNO")));
			}
			
			// 更新当前销售人员上级为门店销售经理
			String storeManager = Sqlca.getString(new SqlObject("SELECT SALESMANAGER FROM STORE_INFO WHERE SNO=:SNO").setParameter("SNO", serialNo));
			ASResultSet rs1 = Sqlca.getASResultSet(new SqlObject("SELECT SALESMANNO  FROM STORERELATIVESALESMAN WHERE SNO=:SNO").setParameter("SNO", serialNo));
			
			if (storeManager!=null && storeManager.trim().length()>0) {
				while (rs1.next()) {
					Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:SuperId where UserId=:UserId and Status='1' and IsCar='02'")
							.setParameter("SuperId", storeManager).setParameter("UserId", rs1.getString("SALESMANNO")));
				}
			}
			
			if (rs != null) rs.getStatement().close();
			if (rs1 != null) rs1.getStatement().close();
		} catch (SQLException e) {
			sRetVal = "FAIL";
			e.printStackTrace();
		} catch (Exception e) {
			sRetVal = "FAIL";
			e.printStackTrace();
		}
		
		return sRetVal;
	}
	
	/**
	 * 门店关联产品范畴
	 * @param Sqlca
	 * @return
	 */
	public String getStoreRelativeProductCategory(Transaction Sqlca) {
		
		String sRet = "Success";
		try {
			
			String sql = "select SNo,SSerialNo,PNo,PName,spStartDate,spEndDate,InputOrg,InputUser,InputDate,UpdateOrg,UpdateUser,UpdateDate from StoreRelativeProduct where SerialNo= :SerialNo";
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("SerialNo", serialNo));
			if (rs.next()) {
				String SNo = rs.getString("SNo");
				String SSerialNo = rs.getString("SSerialNo");
				String PNo = rs.getString("PNo");
				String PName = rs.getString("PName");
				String spStartDate = rs.getString("spStartDate");
				String spEndDate = rs.getString("spEndDate");
				String inputOrg = rs.getString("InputOrg");
				String inputUser = rs.getString("InputUser");
				String inputDate = rs.getString("InputDate");
				String updateOrg = rs.getString("UpdateOrg");
				String updateUser = rs.getString("UpdateUser");
				String updateDate = rs.getString("UpdateDate");
				String[] productCategoryIDS = PNo.split("@");
				String[] productCategoryNameS = PName.split("@"); 
				
				if (productCategoryIDS.length>0) {
					
					Sqlca.executeSQL(new SqlObject("delete from StoreRelativeProduct where SerialNo= :SerialNo").setParameter("SerialNo", serialNo));
					for (int i=0; i<productCategoryIDS.length; i++) {
						
						// 检查该商品范畴与门店是否已经关联
						String tSerialNo = Sqlca.getString(new SqlObject("select SerialNo from StoreRelativeProduct where SNo= :SNo and PNo= :PNo")
								.setParameter("SNo", SNo).setParameter("PNo", productCategoryIDS[i]));
						if (tSerialNo == null) {
							String insertSql = "insert into StoreRelativeProduct(SerialNo,SNo,SSerialNo,SName,PNo,PName,spStartDate,spEndDate,InputOrg,InputUser,InputDate,UpdateOrg,UpdateUser,UpdateDate)"+
									" values(:SerialNo,:SNo,:SSerialNo,:SName,:PNo,:PName,:spStartDate,:spEndDate,:InputOrg,:InputUser,:InputDate,:UpdateOrg,:UpdateUser,:UpdateDate)";
							SqlObject asql = new SqlObject(insertSql);
							String sSerialNo = "";
							if (i <= 0 && !"".equals(serialNo)) sSerialNo = serialNo;
							if (i > 0) sSerialNo = DBKeyHelp.getSerialNo("StoreRelativeProduct", "SerialNo");
							asql.setParameter("SerialNo", sSerialNo).setParameter("SNo", SNo).setParameter("SSerialNo", SSerialNo)
								.setParameter("SName", Sqlca.getString(new SqlObject("Select SName from Store_Info where SNo=:SNo").setParameter("SNo", SNo)))
								.setParameter("PNo", productCategoryIDS[i]).setParameter("PName", productCategoryNameS[i])
								.setParameter("spStartDate", spStartDate).setParameter("spEndDate", spEndDate)
								.setParameter("InputOrg", inputOrg).setParameter("InputUser", inputUser)
								.setParameter("InputDate", inputDate).setParameter("UpdateOrg", updateOrg)
								.setParameter("UpdateUser", updateUser).setParameter("UpdateDate", updateDate);
							Sqlca.executeSQL(asql); 
						}
					}
				}
			}
			if (rs != null) 
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
			sRet = "Fail";
		}
		
		return sRet;
	}
	
	/**
	 * 检查该笔申请下的所有门店是否已经签署意见
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String signAllStoreOpinion(Transaction sqlca) throws Exception {
		
		StringBuffer sb = new StringBuffer("");
		ASResultSet rs = sqlca.getASResultSet(new SqlObject("select SerialNo,SNo,SName from Store_Info where RSSerialNo=:RSSerialNo")
							.setParameter("RSSerialNo", objectNo));
		while (rs.next()) {
			String sSerialNo = rs.getString("SerialNo");
			String sSNo = rs.getString("SNo");
			double dOpinionCnt = sqlca.getDouble(new SqlObject("select count(SerialNo) from flow_opinion where SerialNo=:SerialNo and OpinionNo=:OpinionNo")
									.setParameter("SerialNo", sSerialNo).setParameter("OpinionNo", objectNo));
			if (dOpinionCnt<=0.0) {
				sb.append(sSNo).append(",").append(rs.getString("SName")).append("\n");
			}
		}
		
		if (rs != null)
		rs.getStatement().close();
		String sRetVal = sb.toString();
		if (sb.length()>0) sRetVal = sb.substring(0, sb.length()-1);
		
		return sRetVal;
	}
	
	/**
	 * 通过门店的状态判断零售商申请准入或者拒绝的状态
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String retailApplyResult(Transaction sqlca) throws Exception {
		
		double dPassRetailCnt = sqlca.getDouble(new SqlObject("select count(SerialNo) from Store_Info where RSSerialNo=:RSSerialNo and status='03'")
									.setParameter("RSSerialNo", objectNo));
		
		SqlObject asql = new SqlObject("update Retail_Info set RNo=:RNo,Status='03' where SerialNo=:SerialNo")
							.setParameter("SerialNo", retailNo).setParameter("RNo", getRetailNo(sqlca));
		
		if (dPassRetailCnt <= 0.0) {
			asql = new SqlObject("update Retail_Info set Status='04' where SerialNo=:SerialNo")
					.setParameter("SerialNo", retailNo);
		}
		
		return ""+sqlca.executeSQL(asql);
	}
	
	
	/**
	 * 获取大商户编号：城市代码+4位流水号	example：11A+0001
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String getRetailNo(Transaction sqlca) throws Exception{
		
		String sRetailNo = "";
		String cityCode = sqlca.getString(new SqlObject("select City from Retail_Info where SerialNo=:SerialNo").setParameter("SerialNo", retailNo));
		String sRNo = sqlca.getString(new SqlObject("select RNo from Retail_Info where RNo is not null and City=:cityCode order by SerialNo DESC").setParameter("cityCode", cityCode));
		sRetailNo = cityCode + "0001"; 
		if (sRNo != null) {
			int iSerialNo = Integer.valueOf(sRNo.substring(cityCode.length()));
			sRetailNo = cityCode + paddingChar(String.valueOf(++iSerialNo),4,"0");
		}
		
		return sRetailNo;
	}
	
	/**
	 * 传入字符串不足位补特定字符
	 * @param str 传入字符串
	 * @param len 输出字符串长度
	 * @param padChar 补充字符串
	 * @return
	 */
	private String paddingChar(String str, int len, String padChar) {
		String targetStr = str;
		
		if (targetStr == null) targetStr = "";
		if (targetStr.length()>=len) return targetStr.substring(0, len);
		
		String tempStr = "";
		for (int i=0; i<len-targetStr.length(); i++) {
			tempStr += padChar;
		}
		
		return tempStr+targetStr;
	}
	
	/**
	 * 暂时关闭零售商下，级联关闭该零售商下所有门店
	 * @param sqlca
	 * @return
	 */
	public String temporayCloseRetail(Transaction sqlca) {
		
		String sRet = "Success";
		try {
			sqlca.executeSQL(new SqlObject("Update Retail_Info set Status='07' where SerialNo=:SerialNo")
				.setParameter("SerialNo", serialNo));
			sqlca.executeSQL(new SqlObject("Update Store_Info set Status='07' where RSerialNo=:RSerialNo")
				.setParameter("RSerialNo", serialNo));
		} catch (Exception e) {
			e.printStackTrace();
			sRet = "Fail";
		}
		
		return sRet;
	}
	
	/**
	 * 关闭零售商下，级联关闭该零售商下所有门店
	 * @param sqlca
	 * @return
	 */
	public String closeRetail(Transaction sqlca) {
		
		String sRet = "Success";
		try {
			sqlca.executeSQL(new SqlObject("Update Retail_Info set Status='06' where SerialNo=:SerialNo")
				.setParameter("SerialNo", serialNo));
			sqlca.executeSQL(new SqlObject("Update Store_Info set Status='06' where RSerialNo=:RSerialNo")
				.setParameter("RSerialNo", serialNo));
		} catch (Exception e) {
			e.printStackTrace();
			sRet = "Fail";
		}
		
		return sRet;
	}
	
	/**
	 * 关闭门店，如果关联零售商下所有门店未关闭或拒绝状态，则关闭零售商
	 * @param sqlca
	 * @return
	 */
	public String closeStore(Transaction sqlca) {
		String sRet = "Success";
		ASResultSet rs = null;
		try {
			sqlca.executeSQL(new SqlObject("Update Store_Info set Status='06' where SerialNo=:SerialNo")
				.setParameter("SerialNo", serialNo));
			/*double dStoreCnt = sqlca.getDouble(new SqlObject("select count(SerialNo) from Store_Info where RSerialNo=:RSerialNo and Status not in ('04','06')")
				.setParameter("RSerialNo", retailNo));
			if (dStoreCnt <= 0.0) sqlca.executeSQL(new SqlObject("Update Retail_Info set Status='06' where SerialNo=:SerialNo").setParameter("SerialNo", retailNo));
			*/
			//-- add CCS-884：门店管理功能优化 tangyb 20150721 start --//
			System.out.println("修改人="+userId);
			System.out.println("门店序列号="+serialNo);
			System.out.println("机构编号="+orgid);
			
			String sql = ""; //sql脚本
			
			//-- 解除销售代表与门店经理关系 --//
			sql = "SELECT a.salesmanager, b.salesmanno FROM store_info a, storerelativesalesman b "
					+ "WHERE a.sno = b.sno AND b.saletype = '01' AND b.stype IS NULL AND a.serialno = :serialno"; 
			//查询当前门店所有有效的销售代表
			rs = sqlca.getASResultSet(new SqlObject(sql).setParameter("serialno", serialNo));
			while(rs.next()){
				String salesmanager = DataConvert.toString(rs.getString("SALESMANAGER")); //销售经理
				String salesmanno = DataConvert.toString(rs.getString("SALESMANNO")); //销售人员
				
				sql = "SELECT COUNT(1) FROM store_info a, storerelativesalesman b "
						+ "WHERE a.sno = b.sno AND b.stype IS NULL AND a.salesmanager = :salesmanager "
						+ "AND a.serialno <> :serialno AND b.salesmanno = :salesmanno";
				//查询销售人员与销售经理其他门店是否还存在关系（count大于0表示还存在关系）
				String count = sqlca.getString(new SqlObject(sql)
								.setParameter("salesmanager", salesmanager)
								.setParameter("serialno", serialNo)
								.setParameter("salesmanno", salesmanno)); 
				
				//如果不存在关系解除关系
				if(count != null && Integer.parseInt(count) == 0){
					sql = "UPDATE user_info SET superid = '' WHERE iscar='02' AND status='1' AND userid = :userid";
					sqlca.executeSQL(new SqlObject(sql).setParameter("userid", salesmanno));
				}
			}
			rs.getStatement().close();
			
			String updateDate = DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss"); //更新时间
			//解除绑定销售代表与门店关系
			sql = "UPDATE storerelativesalesman s SET s.updateorg = :updateorg, s.updateuser = :userid, s.updatedate = :updatedate, s.stype = '02'"
					+ " WHERE s.stype IS NULL AND EXISTS (SELECT 1 FROM store_info t WHERE t.sno = s.sno AND t.serialno = :serialno)"; 
			sqlca.executeSQL(new SqlObject(sql).setParameter("updateorg", orgid)
					.setParameter("userid", userId)
					.setParameter("updatedate", updateDate)
					.setParameter("serialno", serialNo));
			//-- end --//
		} catch (Exception e) {
			e.printStackTrace();
			sRet = "Fail";
		}
		
		return sRet;
	}
	
	/**
	 * 同一城市同一时间只能有一个还款帐号名
	 * @param Sqlca
	 * @return
	 */
	/*public String loanAccountCity(Transaction Sqlca) throws Exception {
		
		StringBuffer sSBNoCityNo = new StringBuffer();
		StringBuffer sSBNoCityName= new StringBuffer();
		StringBuffer sSBExistCityNo = new StringBuffer();
		StringBuffer sSBExistCityName= new StringBuffer();
		
		String[] cityArray = citys.split("@");
		String[] citynameArray = citynames.split("@");
				
		for (int i=0; i<cityArray.length;i++) {
			String aCity = cityArray[i];
			String sql = "Select SerialNo,City from Service_Providers where customerType1='06'  and CreditAttribute='0002'  and " +
					"((startDate>='"+startDate+"' and startDate<='"+endDate+"') or " +
					"(endDate>='"+startDate+"' and endDate<='"+endDate+"') or  " +
					"('"+startDate+"'>=startDate and '"+startDate+"'<=endDate) or " +
					"('"+endDate+"'>=startDate and '"+endDate+"'<=endDate) ) and SerialNo!='"+serialNo+"' and ProductType = '"+ProductType+"' ";//update CCS-159-现金贷中多贷款问题
			ASResultSet rs = Sqlca.getASResultSet(sql);
			int j=0,x=0;
			while (rs.next()) {
				j++;
				String cityNoFrom = rs.getString("City");
				if (cityNoFrom.indexOf(aCity)>=0) {
					if (sSBExistCityNo.indexOf(aCity) ==-1 ) { 
						sSBExistCityNo.append(cityArray[i]).append("#");
						sSBExistCityName.append(citynameArray[i]).append("#");
						break;
					}
				} 
				x++;
//				if (sSBNoCityNo.indexOf(aCity) == -1) {
//					sSBNoCityNo.append(cityArray[i]).append("#");
//					sSBNoCityName.append(citynameArray[i]).append("#");
//				}
			}
			if(j==x){
				sSBNoCityNo.append(cityArray[i]).append("#");
				sSBNoCityName.append(citynameArray[i]).append("#");
			}
			
			if ( rs != null) {rs.getStatement().close();}
			
		}
		
		String sbExtNos = "";
		String sbExtNames = "";
		String sbNoNos = "";
		String sbNoNames = "";
		if (sSBExistCityNo.length()>0) sbExtNos = sSBExistCityNo.substring(0,sSBExistCityNo.length()-1);
		if (sSBExistCityName.length()>0) sbExtNames = sSBExistCityName.substring(0,sSBExistCityName.length()-1);
		if (sSBNoCityNo.length()>0) sbNoNos = sSBNoCityNo.substring(0,sSBNoCityNo.length()-1);
		if (sSBNoCityName.length()>0) sbNoNames = sSBNoCityName.substring(0,sSBNoCityName.length()-1);
		
		
		
		return sbExtNos+"@"+sbExtNames+"~"+sbNoNos+"@"+sbNoNames;
	}*/
	
	/**
	 * 同一城市同一时间只能有一个还款帐号名(引入城市贷款人关联表providerscity之后)
	 * @param Sqlca
	 * @return
	 */
    /* public String loanProviderCity(Transaction Sqlca) throws Exception {
		
		StringBuffer sSBNoCityNo = new StringBuffer();
		StringBuffer sSBNoCityName= new StringBuffer();
		StringBuffer sSBExistCityNo = new StringBuffer();
		StringBuffer sSBExistCityName= new StringBuffer();
		
		String[] cityArray = citys.split("@");
		String[] citynameArray = citynames.split("@");
				
		for (int i=0; i<cityArray.length;i++) {
			String aCity = cityArray[i];
			//CCS-344 贷款人操作中无法添加所有城市   取城市的逻辑变更   edit by awang 2015/03/11
			String sql = "Select SerialNo,AreaCode from ProvidersCity where " +
					" SerialNo!='"+serialNo+"' and productType = '"+ProductType+"' ";
			ASResultSet rs = Sqlca.getASResultSet(sql);
			int j=0,x=0;
			while (rs.next()) {
				j++;
				String cityNoFrom = rs.getString("AreaCode");
				if (cityNoFrom.indexOf(aCity)>=0) {
					if (sSBExistCityNo.indexOf(aCity) ==-1 ) { 
						sSBExistCityNo.append(cityArray[i]).append("#");
						sSBExistCityName.append(citynameArray[i]).append("#");
						break;
					}
				} 
				x++;
//				if (sSBNoCityNo.indexOf(aCity) == -1) {
//					sSBNoCityNo.append(cityArray[i]).append("#");
//					sSBNoCityName.append(citynameArray[i]).append("#");
//				}
			}
			if(j==x){
				sSBNoCityNo.append(cityArray[i]).append("#");
				sSBNoCityName.append(citynameArray[i]).append("#");
			}
			
			if ( rs != null) {rs.getStatement().close();}
			
		}
		
		String sbExtNos = "";
		String sbExtNames = "";
		String sbNoNos = "";
		String sbNoNames = "";
		if (sSBExistCityNo.length()>0) sbExtNos = sSBExistCityNo.substring(0,sSBExistCityNo.length()-1);
		if (sSBExistCityName.length()>0) sbExtNames = sSBExistCityName.substring(0,sSBExistCityName.length()-1);
		if (sSBNoCityNo.length()>0) sbNoNos = sSBNoCityNo.substring(0,sSBNoCityNo.length()-1);
		if (sSBNoCityName.length()>0) sbNoNames = sSBNoCityName.substring(0,sSBNoCityName.length()-1);
		
		
		
		return sbExtNos+"@"+sbExtNames+"~"+sbNoNos+"@"+sbNoNames;
	}*/
     
     
     /**
      * 保存时更新城市，贷款人，产品类型关系表
      * @param Sqlca
      * @return
     * @throws Exception 
     * @throws SQLException 
      */
     //CCS-344 贷款人操作中无法添加所有城市   edit by awang 2015/03/11
     public String updateProviderScity(Transaction Sqlca) throws  Exception{
    	 String[] productTypeArr = ProductType.split("@");
    	 for(int i =0; i<productTypeArr.length;i++){
         Sqlca.executeSQL(new SqlObject("Update ProviderScity  set PRODUCTTYPE='"+productTypeArr[i]+"'  where SerialNo='"+serialNo+"' and PRODUCTTYPE='Temp"+productTypeArr[i]+"' "));
    	 }
         return "Success";
     }
     /**
      * 保存时更新城市，贷款人，产品类型关系表
      * @param Sqlca
      * @return
     * @throws Exception 
     * @throws SQLException 
      */
     //CCS-344 贷款人操作中无法添加所有城市   edit by awang 2015/03/11
     public String addProviderscity(Transaction Sqlca) throws  Exception{
    	 String[] sAreaCode=AreaCodes.split("@");
    	 String getbegintime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
    	 
    	 for(int i=0;i<sAreaCode.length;i++){
    	 Sqlca.executeSQL(new SqlObject("insert into ProviderScity(serialNo,AreaCode,ProductType,Begintime) "
    	 		+ "values (:serialNo,:AreaCode,:ProductType,:Begintime)")
    			 .setParameter("serialNo", serialNo)
    			 .setParameter("AreaCode", sAreaCode[i])
    			 .setParameter("ProductType", ProductType)
    			 .setParameter("Begintime", getbegintime));
    		 }
    	 
        return "Success";
     }
	/**
	 * 级联更新管理门店下的联系方式
	 * @param Sqlca
	 * @return
	 */
	public String updateSaleManagerLinkInfo(Transaction Sqlca) {
		
		try {
			
			Sqlca.executeSQL(new SqlObject("update Store_Info set (SalesmanPhone,SalesmanEmail)=(select MobileTel,Email from User_Info where UserId=:UserId) where SalesManager=:UserId")
					.setParameter("UserId", userId));
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		
		return "Success";
	}
	
	public String copyStoreInfo(Transaction Sqlca) {
		
		try {
			
			CommonUtils.copyRecord(Sqlca, tableName, colName, serialNo);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "Success";
	}
	
	public String getCreditID(Transaction Sqlca){
		ASResultSet rs=null;
		try {
			//CCS-344 贷款人操作中无法添加所有城市   取城市的逻辑变更   edit by awang 2015/03/11
			/*rs = Sqlca.getASResultSet(new SqlObject("select sp.serialno from Service_Providers sp where sp.serialno=(select serialno from providerscity where ProductType='"+ProductType+"' and AreaCode='"+citys+"')"));*/
			String sSql = "select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName "+
	          "from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '"+ProductType+"' "+
		      "and pc.serialno=sp.serialno and sp.loaner = '010' and pc.areacode='"+citys+"'";
			rs = Sqlca.getASResultSet(new SqlObject(sSql));
			if(rs.next()){
				return "true";
			}
			rs.getStatement().close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "false";
	}
	/**
	 * 门店只能关联一个客户主管
	 * @param Sqlca
	 * @return
	 * add by ybpan at 20150408
	 */
	public String checkSaleManager(Transaction Sqlca){
		ASResultSet rs=null;
		String flag="false";
		String sql = "select count(1) as cnt from STORERELATIVESALESMAN where sno=:SNO and SALETYPE='02'";
		
		      try {
		    	  rs =  Sqlca.getASResultSet(new SqlObject(sql).setParameter("SNO", sNo));
		    	  while(rs.next()){
		    		int count = rs.getInt(1);
		    		  if(count>0) flag="true";
		    	  }
		    	rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	       return flag;
		
	}
}
