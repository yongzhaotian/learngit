package com.amarsoft.app.billions;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * 无预约现金贷款外部名单客户提交合同检验
 * 
 * @author tangyb
 * @date 2015-05-22
 */
public class StoreInfo {
	
	private String serialno; // 流水号
	private String sno; //门店编号
	private String salesmanno; //销售人员

	public String getSerialno() {
		return serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}

	public String getSno() {
		return sno;
	}

	public void setSno(String sno) {
		this.sno = sno;
	}

	public String getSalesmanno() {
		return salesmanno;
	}

	public void setSalesmanno(String salesmanno) {
		this.salesmanno = salesmanno;
	}

	/**
	 * 查询门店关键信息为空的信息
	 * @param Sqlca
	 * @return errorMes
	 * @throws Exception
	 */
	public String queryStoreKeyInfoIsNull(Transaction Sqlca) throws Exception{
		System.out.println("--------------serialno:"+serialno); //流水号（参数）
		String errorMes = ""; //错误信息
		
		StringBuffer sql = new StringBuffer();
		ASResultSet rs = null;
		try {
			sql.append("SELECT a.sname, ");
			sql.append("a.operatemode, ");
			sql.append("a.storetype, ");
			sql.append("a.city, ");
			sql.append("a.salesmanager, ");
			sql.append("d.superid, ");
			sql.append("d.mobiletel, ");
			sql.append("a.productcategoryname, ");
			sql.append("a.address, ");
			sql.append("a.shophours, ");
			sql.append("a.account, ");
			sql.append("a.accountname, ");
			sql.append("a.accountbank, ");
			sql.append("a.mainbusinesstype, ");
			sql.append("a.predictloanamount, ");
			sql.append("d.email, ");
			sql.append("a.reponsibleman, ");
			sql.append("a.reponsiblemanphone, ");
			sql.append("a.accountbankcity, ");
			sql.append("a.isnetbank, ");
			sql.append("b.bankname, ");
			sql.append("c.rname ");
			sql.append("FROM store_info a, ");
			sql.append("bankput_info b, ");
			sql.append("retail_info c, ");
			sql.append("user_info d ");
			sql.append("WHERE a.branchcode = b.bankno ");
			sql.append("AND a.accountbankcity = b.city ");
			sql.append("AND a.rserialno = c.serialno ");
			sql.append("AND a.salesmanager = d.userid(+) ");
			sql.append("AND a.serialno = :serialno");
			
			//根据保单号获取保单信息
			rs= Sqlca.getASResultSet(new SqlObject(sql.toString()).setParameter("serialno", serialno));
			while(rs.next()){
				String sname = DataConvert.toString(rs.getString("SNAME")); //门店名称 
				String rname = DataConvert.toString(rs.getString("RNAME")); //零售商名称
				String operatemode = DataConvert.toString(rs.getString("OPERATEMODE")); //运作模式 
				String storetype = DataConvert.toString(rs.getString("STORETYPE")); //门店类型 
				String shophours = DataConvert.toString(rs.getString("SHOPHOURS")); //门店营业时间(24时制) 
				String reponsibleman = DataConvert.toString(rs.getString("REPONSIBLEMAN")); //负责人姓名
				String reponsiblemanphone = DataConvert.toString(rs.getString("REPONSIBLEMANPHONE")); //负责人联系电话
				String isnetbank = DataConvert.toString(rs.getString("ISNETBANK")); //是否采用商户网银 
				String accountbank = DataConvert.toString(rs.getString("ACCOUNTBANK")); //门店结算账号开户行
				String accountbankcity = DataConvert.toString(rs.getString("ACCOUNTBANKCITY")); //门店结算账号开户行所在省市
				String accountname = DataConvert.toString(rs.getString("ACCOUNTNAME")); //门店结算账号户名 
				String productcategoryname = DataConvert.toString(rs.getString("PRODUCTCATEGORYNAME")); //门店的商品范畴
				String account = DataConvert.toString(rs.getString("ACCOUNT")); //门店结算账号 
				String bankname = DataConvert.toString(rs.getString("BANKNAME")); //门店结算账号开户支行 
				String mainbusinesstype = DataConvert.toString(rs.getString("MAINBUSINESSTYPE")); //主推品牌 
				String predictloanamount = DataConvert.toString(rs.getString("PREDICTLOANAMOUNT")); //预计每月分期贷款单量 
				String city = DataConvert.toString(rs.getString("CITY")); //门店所在城市 
				String superid = DataConvert.toString(rs.getString("SUPERID")); //城市经理 
				//String seniorSalesmanager = DataConvert.toString(rs.getString("SENIOR_SALESMANAGER")); //高级销售经理 
				String address = DataConvert.toString(rs.getString("ADDRESS")); //门店地址具体 
				String salesmanager = DataConvert.toString(rs.getString("salesmanager")); //销售经理 
				String email = DataConvert.toString(rs.getString("EMAIL")); //销售经理邮箱 
				String mobiletel = DataConvert.toString(rs.getString("MOBILETEL")); //销售经理联系方式 
				
				if(sname == null || "".equals(sname)){ errorMes = errorMes + "\n门店名称不能为空";}
				if(rname == null || "".equals(rname)){ errorMes = errorMes + "\n零售商名称不能为空";}
				if(operatemode == null || "".equals(operatemode)){ errorMes = errorMes + "\n运作模式不能为空";}
				if(storetype == null || "".equals(storetype)){ errorMes = errorMes + "\n门店类型不能为空";}
				if(shophours == null || "".equals(shophours)){ errorMes = errorMes + "\n门店营业时间(24时制)不能为空";}
				if(reponsibleman == null || "".equals(reponsibleman)){ errorMes = errorMes + "\n负责人姓名不能为空";}
				if(reponsiblemanphone == null || "".equals(reponsiblemanphone)){ errorMes = errorMes + "\n负责人联系电话不能为空";}
				if(isnetbank == null || "".equals(isnetbank)){ errorMes = errorMes + "\n是否采用商户网银不能为空";}
				if(accountbank == null || "".equals(accountbank)){ errorMes = errorMes + "\n门店结算账号开户行不能为空";}
				if(accountbankcity == null || "".equals(accountbankcity)){ errorMes = errorMes + "\n门店结算账号开户行所在省市不能为空";}
				if(accountname == null || "".equals(accountname)){ errorMes = errorMes + "\n门店结算账号户名不能为空";}
				if(productcategoryname == null || "".equals(productcategoryname)){ errorMes = errorMes + "\n门店的商品范畴不能为空";}
				if(account == null || "".equals(account)){ errorMes = errorMes + "\n门店结算账号不能为空";}
				if(bankname == null || "".equals(bankname)){ errorMes = errorMes + "\n门店结算账号开户支行不能为空";}
				if(mainbusinesstype == null || "".equals(mainbusinesstype)){ errorMes = errorMes + "\n主推品牌不能为空";}
				if(predictloanamount == null || "".equals(predictloanamount)){ errorMes = errorMes + "\n预计每月分期贷款单量不能为空";}
				if(city == null || "".equals(city)){ errorMes = errorMes + "\n门店所在城市不能为空";}
				if(superid == null || "".equals(superid)){ errorMes = errorMes + "\n城市经理不能为空";}
				if(address == null || "".equals(address)){ errorMes = errorMes + "\n门店地址具体不能为空";}
				if(salesmanager == null || "".equals(salesmanager)){ errorMes = errorMes + "\n销售经理不能为空";}
				if(email == null || "".equals(email)){ errorMes = errorMes + "\n销售经理邮箱不能为空";}
				if(mobiletel == null || "".equals(mobiletel)){ errorMes = errorMes + "\n销售经理联系方式不能为空";}
			}
		} catch (Exception e) { 
			e.printStackTrace(); 
			throw new RuntimeException("查询数据失败");
		} finally {
			if (rs != null) {
				rs.getStatement().close();
			}
		}
		return errorMes;
	}
	

	/**
	 * 查询销售人员与门店经理其他门店是否还存在关系
	 * @param Sqlca
	 * @return isThere (0:否,1:是)
	 * @throws Exception
	 */
	public String querySalesManagerRelation(Transaction Sqlca) throws Exception{
		System.out.println("门店编号=" +sno); 
		System.out.println("销售人员=" +salesmanno); 
		
		String isThere = "0";
		String sql = "SELECT COUNT(1) FROM store_info a, storerelativesalesman b, store_info c "
				+ "WHERE a.sno = b.sno AND a.salesmanager = c.salesmanager AND b.stype IS NULL "
				+ "AND a.sno <> :snoOne AND c.sno = :snoTwo AND b.salesmanno = :salesmanno";
		String count = Sqlca.getString(new SqlObject(sql)
								.setParameter("snoOne", sno)
								.setParameter("snoTwo", sno)
								.setParameter("salesmanno", salesmanno));
		if(count != null && Integer.parseInt(count) > 0){
			isThere = "1";
		}
		
		return isThere;
	}
	
}
