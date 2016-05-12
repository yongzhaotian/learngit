/**
 * <p>===========================================================</p>
 * <p>版权所有 2010-2020 佰仟金融服务有限公司，并保留所有权利</p>
 * <p>-----------------------------------------------------------</p>
 * <p>这不是一个自由软件！您不能在未经允许的前提下对程序代码进行修改和使用；</p> 
 * <p>不允许对程序代码以任何形式任何目的的再发布</p>
 * <p>===========================================================</p>
 * @ClassName: BaibaobagManageInfo 
 * @Description: 佰保袋业务处理类 
 * @author tangyb
 * @date 2016年2月20日 下午3:39:45
 */

package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 佰保袋业务处理类
 * @ClassName: BaibaobagManageInfo 
 * @Description: 佰保袋业务处理类 
 * @author tangyb
 * @date 2016年2月20日 下午3:39:45
 */
public class BaibaobagManageInfo {
	
	/** 合同编码 **/
	private String serialno;

	/** 操作用户 **/
	private String userid;

	/** 商品类型2 **/
	private String typename2;
	
	/**手机串号**/
	private String mobnumber;
	
	/**供应商ID**/
	private String providerid;
	
	/**延保期限**/
	private String serveyear;
	
	/**百宝袋机型编码**/
	private String modelno;
	
	/**百宝袋售价**/
	private String price;
	
	/**销售提成**/
	private String deduct;
	
	/**商品范畴1**/
	private String businessrange1;
	
	/**
	 * 佰保袋产品范围校验
	 * @Title bbdBusinessCheck
	 * @Description 佰保袋产品范围校验 CCS-1255 tangyb
	 * @return void
	 * @param Sqlca
	 * @throws Exception
	 */
	public String bbdBusinessCheck(Transaction Sqlca) throws Exception{
		ARE.getLog().info("佰保袋产品范围校验：商品范畴1[businessrange1]=" + businessrange1);
		
		Boolean isExist = false; //是否存在配置
		String names = ""; //已配置的商品范畴名称集
		String msginfo = "" ; // 提示信息
		
		if(businessrange1 == null || "".equals(businessrange1)){
			msginfo = "选择佰保袋服务“商品范畴1”不能为空";
		} else{
			String sql = "select businessrange, businessrangename from bbd_treasurebag_business where status = '1'";
			ASResultSet rs  = Sqlca.getASResultSet(new SqlObject(sql));
			
			while (rs.next()) {
				String businessrange = rs.getString("businessrange"); //商品范畴编码
				if("".equals(names))
					names = rs.getString("businessrangename"); //商品范畴名称集
				else 
					names = names + "," + rs.getString("businessrangename"); //商品范畴名称集
				
				//校验商品范畴1是否配置
				if(businessrange1.equals(businessrange)) {
					isExist = true;
					break;
				}
			}
			
			if(!isExist){
				msginfo = "选择佰保袋服务“商品范畴1”必须为["+names+"]之中其一";
			}
		}
		return msginfo;
	}
	
	/**
	 * 手机串号重复验证
	 * @Title bbdBusinessCheck
	 * @Description 手机串号重复验证 CCS-1255 tangyb
	 * @return void
	 * @param Sqlca
	 * @throws Exception
	 */
	public String mobnumberCheck(Transaction Sqlca) throws Exception{
		ARE.getLog().info("手机串号重复验证：合同编号[serialno]=" + serialno + ",商品范畴1[mobnumber]=" + mobnumber);
		
		String msginfo = "" ; // 提示信息
		
		if(mobnumber == null || "".equals(mobnumber)){
			msginfo = "选择佰保袋服务“手机串号”不能为空";
		} else{
			String sql = "SELECT COUNT(1) isapply FROM bbd_treasurebag_info bb, business_contract bc "
						+ "WHERE bb.serialno = bc.serialno AND bb.serialno <> '" + serialno + "' "
						+ "AND bb.mobile_serial_number = '" + mobnumber + "' "
						+ "AND bc.contractstatus not in ('010', '030', '040', '100', '120', '170', '200', '210', '240') ";
			String isapply = Sqlca.getString(new SqlObject(sql));
			
			if (Integer.parseInt(isapply) > 0) {
				msginfo = "手机串号[" + mobnumber + "]已购买过佰保袋，不能重复购买 ";
			}
		}
		
		ARE.getLog().info("手机串号重复验证msginfo=" + msginfo);
		return msginfo;
	}

	/**
	 * 
	 * 保存合同关联佰保袋信息
	 * @Title saveBbdInfo
	 * @Description CCS-1255 保存合同关联佰保袋信息 tangyb
	 * @return String
	 * @param Sqlca
	 */
	public String saveBbdInfo(Transaction Sqlca){
		try {
			ARE.getLog().info("保存合同关联佰保袋信息：" + toString());
			
			String selectSql = "select count(1) from bbd_treasurebag_info t where t.serialno = :serialno";
			
			String insertSql = "INSERT INTO bbd_treasurebag_info (serialno, mobile_serial_number, provider_id, modelno, price, deduct, serveyear, inputuser, inputtime) "
					+ "VALUES (:serialno, :mobnumber, :providerid, :modelno, :price, :deduct, :serveyear, :userid, :time)";
			
			String updateSql = "update bbd_treasurebag_info set mobile_serial_number=:mobnumber,provider_id=:providerid,modelno=:modelno,"
					+ "price=:price,deduct=:deduct,serveyear=:serveyear,updateuser=:userid,updatetime=:time,lastdealdate=sysdate where serialno=:serialno";
			
			String deleteSql = "delete bbd_treasurebag_info where serialno = :serialno";
			
			String time = getTime(); //获取当前时间
			
			//查询该笔合同是否存在佰保袋信息
			String num = Sqlca.getString(new SqlObject(selectSql).setParameter("serialno", serialno));
			if("0".equals(num)){ //不存在
				if("2015061500000017".equals(typename2)){ //用户选择佰保袋服务2015061500000017[佰保袋]
					Sqlca.executeSQL(new SqlObject(insertSql).setParameter("serialno", serialno)
							.setParameter("mobnumber", mobnumber)
							.setParameter("providerid", providerid)
							.setParameter("modelno", modelno)
							.setParameter("price", price)
							.setParameter("deduct", deduct)
							.setParameter("serveyear", serveyear)
							.setParameter("userid", userid)
							.setParameter("time", time)); //新增佰保袋信息
				}
			}else{ //存在
				if("2015061500000017".equals(typename2)){ //用户选择佰保袋服务2015061500000017[佰保袋]
					Sqlca.executeSQL(new SqlObject(updateSql)
							.setParameter("mobnumber", mobnumber)
							.setParameter("providerid", providerid)
							.setParameter("modelno", modelno)
							.setParameter("price", price)
							.setParameter("deduct", deduct)
							.setParameter("serveyear", serveyear)
							.setParameter("userid", userid)
							.setParameter("time", time)
							.setParameter("serialno", serialno)); //修改佰保袋信息
				} else {  //用户未选择佰保袋服务
					Sqlca.executeSQL(new SqlObject(deleteSql).setParameter("serialno", serialno)); //删除佰保袋信息
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return "Error";
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		}
		return "";
	}
	
	/**
	 * 获取当前时间字符串
	 * @Title getTime
	 * @Description 获取当前时间字符串
	 * @return String "yyyy/MM/dd HH:mm:ss"格式的日期字符串
	 */
	private String getTime() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		return formatter.format(new Date());
	}

	public String getSerialno() {
		return serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getTypename2() {
		return typename2;
	}

	public void setTypename2(String typename2) {
		this.typename2 = typename2;
	}

	public String getMobnumber() {
		return mobnumber;
	}

	public void setMobnumber(String mobnumber) {
		this.mobnumber = mobnumber;
	}

	public String getProviderid() {
		return providerid;
	}

	public void setProviderid(String providerid) {
		this.providerid = providerid;
	}

	public String getServeyear() {
		return serveyear;
	}

	public void setServeyear(String serveyear) {
		this.serveyear = serveyear;
	}

	public String getModelno() {
		return modelno;
	}

	public void setModelno(String modelno) {
		this.modelno = modelno;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getDeduct() {
		return deduct;
	}

	public void setDeduct(String deduct) {
		this.deduct = deduct;
	}

	public String getBusinessrange1() {
		return businessrange1;
	}

	public void setBusinessrange1(String businessrange1) {
		this.businessrange1 = businessrange1;
	}
	
	public String toString() {
		return "BaibaobagManageInfo [serialno=" + serialno + ", userid="
				+ userid + ", typename2=" + typename2 + ", mobnumber="
				+ mobnumber + ", providerid=" + providerid + ", serveyear="
				+ serveyear + ", modelno=" + modelno + ", price=" + price
				+ ", deduct=" + deduct + ", businessrange1=" + businessrange1
				+ "]";
	}
}
