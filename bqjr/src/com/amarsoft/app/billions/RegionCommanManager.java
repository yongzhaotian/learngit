package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class RegionCommanManager {

	private String roleId;
	private String userId;
	private String rawUserId;
	private String areaNo;
	private String provinceNo;
	private String cityNo;
	private String areaUserId;
	private String provinceUserId;
	private String cityUserId;
	
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getRawUserId() {
		return rawUserId;
	}
	public void setRawUserId(String rawUserId) {
		this.rawUserId = rawUserId;
	}
	public String getAreaNo() {
		return areaNo;
	}
	public void setAreaNo(String areaNo) {
		this.areaNo = areaNo;
	}
	public String getProvinceNo() {
		return provinceNo;
	}
	public void setProvinceNo(String provinceNo) {
		this.provinceNo = provinceNo;
	}
	public String getCityNo() {
		return cityNo;
	}
	public void setCityNo(String cityNo) {
		this.cityNo = cityNo;
	}
	public String getAreaUserId() {
		return areaUserId;
	}
	public void setAreaUserId(String areaUserId) {
		this.areaUserId = areaUserId;
	}
	public String getProvinceUserId() {
		return provinceUserId;
	}
	public void setProvinceUserId(String provinceUserId) {
		this.provinceUserId = provinceUserId;
	}
	public String getCityUserId() {
		return cityUserId;
	}
	public void setCityUserId(String cityUserId) {
		this.cityUserId = cityUserId;
	}
	
	/**
	 * 省份管理记录删除
	 * @param Sqlca
	 * @return
	 */
	public String updateCitySuperDel(Transaction Sqlca) {
		
		try {
			
			String sProvinceSerialNo = Sqlca.getString(new SqlObject("select SerialNo from Basedataset_Info where TypeCode in ('ProvinceCode', 'AreaCode','CityCode') and Attr3=:CityUserId and (TypeCode='CityCode' and Attr2!=:CityNo)")
				.setParameter("CityUserId", cityUserId).setParameter("CityNo", cityNo));
			if (sProvinceSerialNo == null) {
				Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:CityUserId where UserId=:UserId and IsCar='02' and Status='1'")
					.setParameter("CityUserId", "").setParameter("UserId", cityUserId));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		
		return "Success";
	}
	
	/**
	 * 更新城市负责人上级
	 * @param Sqlca
	 * @return
	 */
	public String updateCitySuper(Transaction Sqlca) {
		
		try {
			
			Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:ProvinceUserId where UserId=:UserId and IsCar='02' and Status='1'")
					.setParameter("ProvinceUserId", provinceUserId).setParameter("UserId", cityUserId));
			
			if (rawUserId != null) {
				String sProvinceSerialNo = Sqlca.getString(new SqlObject("select SerialNo from Basedataset_Info where TypeCode in ('ProvinceCode', 'AreaCode','CityCode') and Attr3=:CityUserId and (TypeCode='CityCode' and Attr2!=:CityNo)")
					.setParameter("CityUserId", cityUserId).setParameter("CityNo", cityNo));
				if (sProvinceSerialNo == null) {
					if (!rawUserId.equals(cityUserId)) {
						Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:ProvinceUserId where UserId=:UserId and IsCar='02' and Status='1'")
							.setParameter("ProvinceUserId", "").setParameter("UserId", rawUserId));
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		return "Success";
	}
	
	/**
	 * 省份管理记录删除
	 * @param Sqlca
	 * @return
	 */
	public String updateProvinceSuperDel(Transaction Sqlca) {
		
		try {
			
			String sProvinceSerialNo = Sqlca.getString(new SqlObject("select SerialNo from Basedataset_Info where TypeCode in ('ProvinceCode', 'AreaCode') and Attr3=:ProvinceUserId and (TypeCode='ProvinceCode' and Attr1!=:ProvinceNo)")
				.setParameter("ProvinceNo", provinceNo).setParameter("ProvinceUserId", provinceUserId).setParameter("ProvinceNo", provinceNo));
			if (sProvinceSerialNo == null) {
				Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:AreaUserId where UserId=:UserId and IsCar='02' and Status='1'")
					.setParameter("AreaUserId", "").setParameter("UserId", provinceUserId));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		
		return "Success";
	}
	
	/**
	 * 更新省份负责人上级
	 * @param Sqlca
	 * @return
	 */
	public String updateProvinceSuper(Transaction Sqlca) {
		
		try {
			
			Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:AreaUserId where UserId=:UserId and IsCar='02' and Status='1'")
					.setParameter("AreaUserId", areaUserId).setParameter("UserId", provinceUserId));
			
			if (rawUserId != null) {
				
				if (!rawUserId.equals(provinceUserId)) {
					String sProvinceSerialNo = Sqlca.getString(new SqlObject("select SerialNo from Basedataset_Info where TypeCode in ('ProvinceCode', 'AreaCode') and Attr3=:ProvinceUserId and (TypeCode='ProvinceCode' and Attr1!=:ProvinceNo)")
						.setParameter("ProvinceNo", provinceNo).setParameter("ProvinceUserId", provinceUserId));
					if (sProvinceSerialNo == null) {
						Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:AreaUserId where UserId=:UserId and IsCar='02' and Status='1'")
							.setParameter("AreaUserId", "").setParameter("UserId", rawUserId));
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		return "Success";
	}
	
	/**
	 * 更新区域管理人员上级及修改后时原区域管理人员上级
	 * @param Sqlca
	 * @return
	 */
	public String updateAreaSuper(Transaction Sqlca) {
		
		try {
			
			if (userId.equals(rawUserId) || rawUserId==null) {	// 详情时
				Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=(select UserId from User_Role where RoleId=:RoleId and rownum=1) where UserId=:UserId and IsCar='02' and Status='1'").setParameter("RoleId", roleId).setParameter("UserId", userId));
			} else {	// 新增时
				
				if (rawUserId != null) {
					String sExitSerialNo = Sqlca.getString(new SqlObject("select SerialNo from Basedataset_Info where TypeCode='AreaCode' and Attr3=:UserId and Attr1!=:AreaNo")
						.setParameter("UserId", rawUserId).setParameter("AreaNo", areaNo));
					if (sExitSerialNo == null) {		// 原用户是没有管理其他区域
						Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:SuperId where UserId=:UserId and IsCar='02' and Status='1'")
								.setParameter("SuperId", "").setParameter("UserId", rawUserId));
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		return "Success";
	}
	
	/**
	 * 删除一条区域信息时，更新该区域管理者上级信息
	 * @param Sqlca
	 * @return
	 */
	public String updateAreaSuperDel(Transaction Sqlca) {
		
		try {
			
			String sExitSerialNo = Sqlca.getString(new SqlObject("select SerialNo from Basedataset_Info where TypeCode='AreaCode' and Attr3=:UserId and Attr1!=:AreaNo")
				.setParameter("UserId", userId).setParameter("AreaNo", areaNo));
			if (sExitSerialNo == null) {		// 原用户是没有管理其他区域
				Sqlca.executeSQL(new SqlObject("update User_Info set SuperId=:SuperId where UserId=:UserId and IsCar='02' and Status='1'")
						.setParameter("SuperId", "").setParameter("UserId", userId));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		return "Success";
	}
	
}
