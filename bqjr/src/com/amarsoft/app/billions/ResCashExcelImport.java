package com.amarsoft.app.billions;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.app.als.rating.model.ResCustomerExcelVO;
import com.amarsoft.are.ARE;

/**
 * 车主现金贷款客户导入名单处理类
 * @author fangxiaoqing
 *
 */
public class ResCashExcelImport {
	private String filePath; // 文件路径
	private String userid; //导入人
	private String orgid; //导入部门
	private String inputdate; //导入时间

	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
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
	public String getInputdate() {
		return inputdate;
	}
	public void setInputdate(String inputdate) {
		this.inputdate = inputdate;
	}
	
	/**
	 * 车主现金贷款客户导入名单
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String dataImportResCash(Transaction sqlca)
			throws Exception{
		ARE.getLog().info("车主现金贷款客户导入名单开始");
		
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
		
		// 参数初始化区域 BEGIN
		String[][] allData = dataExcelCommon.getAllData12();
		
		List<ResCustomerExcelVO> list = new ArrayList<ResCustomerExcelVO>();
		
		if(allData.length == 0){
			ARE.getLog().info("车主现金贷客户导入失败,xls文件数据为空");
			
			return "车主现金贷客户导入失败,xls文件数据为空";
		}
		
		String flag = ""; //校验结构标示
		for(int i = 0; i < allData.length; i++){
			String[] arow = allData[i];//读取一行数据
			
			if(StringUtils.isBlank(arow[11])){
				ARE.getLog().info("导入失败,xls第" + (i + 2) + "行,[活动开始时间]不能为空，请检查");
				
				return "导入失败,xls第" + (i + 2) + "行,[活动开始时间]不能为空，请检查";
			}
			
			flag =checkDate(arow[11]);
			if(flag.equals("0")){
				ARE.getLog().info("导入失败,xls第" + (i + 2) + "行,[活动开始时间]格式有误，请检查");
				
				return "导入失败,xls第" + (i + 2) + "行,[活动开始时间]格式有误，请检查";
			}
			
			// 活动结束时间 不为空,验证时间格式,为空默认为"9999/12/31"
			if(StringUtils.isNotBlank(arow[12])){
				flag =checkDate(arow[12]);
				if(flag.equals("0")){
					ARE.getLog().info("导入失败,xls第" + (i + 2) + "行,[活动结束时间]格式有误，请检查");
					
					return "导入失败,xls第" + (i + 2) + "行,[活动结束时间]格式有误，请检查";
				}
			} else {
				arow[12] = "9999/12/31";
			}
			
			String beginTime="";
			String endTime="";
			
			if (arow[11] != null && !arow[11].equals("")) {
				if (arow[11].split("/").length > 1) {
					beginTime=arow[11].replaceAll("[/\\s:]","-");//开始时间 
				}else{
					beginTime=arow[11];
				}
			}
			
			
			if (arow[12] != null && !arow[12].equals("")) {
				if (arow[12].split("/").length > 1) {
					endTime = arow[12].replaceAll("[/\\s:]","-");//结束时间 
				}else {
					endTime = arow[12];
				}
			}
			
			java.text.DateFormat df = new java.text.SimpleDateFormat( "yyyy-MM-dd");
			java.util.Calendar c1 = java.util.Calendar.getInstance();
			java.util.Calendar c2 = java.util.Calendar.getInstance();
			c1.setTime(df.parse(beginTime));//开始时间 
			c2.setTime(df.parse(endTime));//结束时间 
			
			int result = c1.compareTo(c2);
			if (result == 0){
				ARE.getLog().info("导入失败,xls第" + (i + 2) + "行,活动开始时间与活动结束时间不能一致，请检查");
				
				return "导入失败,xls第" + (i + 2) + "行,活动开始时间与活动结束时间不能一致，请检查";
			}else if (result > 0){
				ARE.getLog().info("导入失败,xls第" + (i + 2) + "行,活动开始时间在活动结束时间之后，请检查");
				
				return "导入失败,xls第" + (i + 2) + "行,活动开始时间在活动结束时间之后，请检查";
			}

			//赋值客户信息VO
			ResCustomerExcelVO rcvo = setResCustomerExcelVO(arow);
			
			list.add(rcvo);
		}
		
		//查询历史客户编号
		String sql = "SELECT CUSTOMERID FROM CUSTOMER_CENTER WHERE CUSTOMERNAME=:customername AND CERTID=:certid";
		
		/*//查询RESCASHACCESSCUSTOMER表中是否存在重复数据
		String resSql = "SELECT CUSTOMERID FROM RESCASHACCESSCUSTOMER WHERE CUSTOMERNAME=:customername AND CERTID=:certid";*/

		//新增客户关键信息表
		String ccSql = "INSERT INTO CUSTOMER_CENTER(CUSTOMERID,CUSTOMERNAME,CERTID,CERTTYPE) VALUES (:CUSTOMERID,:CUSTOMERNAME,:CERTID,:CERTTYPE)";
		
		//新增客户基本信息表
		String customerSql = "INSERT INTO CUSTOMER_INFO (CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,CUSTOMERTYPE,CUSTOMERNAME,CERTID) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:CUSTOMERTYPE,:CUSTOMERNAME,:CERTID)";
		
		//新增客户详细信息表
		String indSql = "INSERT INTO IND_INFO(CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,FAMILYADD,SEX,CUSTOMERNAME,CERTID,MOBILETELEPHONE,COUNTRYSIDE,VILLAGECENTER,PLOT,ROOM) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:UPDATEDATE,:FAMILYADD,:SEX,:CUSTOMERNAME,:CERTID,:MOBILETELEPHONE,:COUNTRYSIDE,:VILLAGECENTER,:PLOT,:ROOM)";

		//新增车主现金贷款Excel导入表数据
		String resCustomersql = "INSERT INTO RESCASHACCESSCUSTOMER (SERIALNO,CUSTOMERID,CUSTOMERNAME,SEX,TELEPHONE,CERTID,PROVINCE,CITY,WORKADDRESS,ADDRESS,PRODUCTTYPE,PRODUCTFEATURE,EVENTNAME,EVENTDATE,EVENTENDDATE,EVENTPHASE,AMOUNTLIMIT,TOPMONTHPAYMENT,TERM,BATCHNO,INPUTDATE) "
				+ "values (:SERIALNO,:CUSTOMERID,:CUSTOMERNAME,:SEX,:TELEPHONE,:CERTID,:PROVINCE,:CITY,:WORKADDRESS,:ADDRESS,:PRODUCTTYPE,:PRODUCTFEATURE,:EVENTNAME,:EVENTDATE,:EVENTENDDATE,:EVENTPHASE,:AMOUNTLIMIT,:TOPMONTHPAYMENT,:TERM,:BATCHNO,:INPUTDATE)";
		
		//插入客户信息前先删除RESCASHACCESSCUSTOMER表中的所有数据
		sqlca.executeSQL(new SqlObject("DELETE FROM RESCASHACCESSCUSTOMER"));

		//存储性别,城市字典集
		Map<String, String> codeMap = new HashMap<String, String>();

		//查询字典表数据[性别,城市]
		String codeSql = "SELECT ITEMNO, ITEMNAME FROM CODE_LIBRARY CL WHERE CL.CODENO in ('AreaCode', 'Sex') order by CODENO desc";
		
		//查询字典表数据[性别,城市]
		ASResultSet rs = sqlca.getASResultSet(codeSql);
		while (rs.next()) {
			codeMap.put(rs.getString("ITEMNAME"), rs.getString("ITEMNO")); 
		}
		rs.getStatement().close();
		
		int i = 1; //新增数
		
		//插入客户信息
		for (Iterator<ResCustomerExcelVO> iterator = list.iterator(); iterator.hasNext();) {
			ResCustomerExcelVO resCustomerExcelVO = iterator.next();
			resCustomerExcelVO.setSerialno(DBKeyUtils.getSerialNo("RC")); // 获取准入客户序列号

			// 校验数据库中是否已经有该客户数据
			String customerID = sqlca.getString(new SqlObject(sql)
					.setParameter("customername", resCustomerExcelVO.getCustomername())
					.setParameter("certid", resCustomerExcelVO.getCertid()));
			
			//新客户
			if (StringUtils.isBlank(customerID)) {
				//获取新客户编号
				GenerateSerialNo generateSerialNo = new GenerateSerialNo();
				generateSerialNo.setTableName("IND_INFO");
				generateSerialNo.setColName("CUSTOMERID");
				customerID = generateSerialNo.getCustomerId(sqlca);//客户ID
				
				String sex = codeMap.get(resCustomerExcelVO.getSex()); //省份城市[客户现住地址]
				String familyadd = codeMap.get(resCustomerExcelVO.getFamilyadd()); //省份城市[客户现住地址]

				//新增客户关键信息表customer_center
				sqlca.executeSQL(new SqlObject(ccSql)
					.setParameter("CUSTOMERID", customerID)
					.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
					.setParameter("CERTID", resCustomerExcelVO.getCertid())
					.setParameter("CERTTYPE", resCustomerExcelVO.getCerttype()));
				
				//新增客户基本信息表customer_info
				sqlca.executeSQL(new SqlObject(customerSql)
					.setParameter("CUSTOMERID", customerID)
					.setParameter("CERTTYPE", resCustomerExcelVO.getCerttype())
					.setParameter("INPUTORGID", resCustomerExcelVO.getInputorgid())
					.setParameter("INPUTUSERID", resCustomerExcelVO.getInputuserid())
					.setParameter("INPUTDATE", resCustomerExcelVO.getInputdate())
					.setParameter("CUSTOMERTYPE", resCustomerExcelVO.getCustomertype())
					.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
					.setParameter("CERTID", resCustomerExcelVO.getCertid())); 
				
				//新增客户详细信息表ind_info
				sqlca.executeSQL(new SqlObject(indSql)
					.setParameter("SERIALNO", resCustomerExcelVO.getSerialno())
					.setParameter("CUSTOMERID", customerID)
					.setParameter("CERTTYPE", resCustomerExcelVO.getCerttype())
					.setParameter("INPUTORGID", resCustomerExcelVO.getInputorgid())
					.setParameter("INPUTUSERID", resCustomerExcelVO.getInputuserid())
					.setParameter("INPUTDATE", resCustomerExcelVO.getInputdate())
					.setParameter("UPDATEDATE", resCustomerExcelVO.getUpdatedate())
					.setParameter("FAMILYADD", familyadd == null ? "" :familyadd)
					.setParameter("SEX", sex == null ? "0" : sex)
					.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
					.setParameter("CERTID", resCustomerExcelVO.getCertid())
					.setParameter("MOBILETELEPHONE", resCustomerExcelVO.getMobiletelephone())
					.setParameter("COUNTRYSIDE", resCustomerExcelVO.getCountryside())
					.setParameter("VILLAGECENTER", resCustomerExcelVO.getVillagecenter())
					.setParameter("PLOT", resCustomerExcelVO.getPlot())
					.setParameter("ROOM", resCustomerExcelVO.getRoom()));

			}
			
			/*// 校验rescashaccesscustomer库中是否已经有该客户数据
			String customerID_res = sqlca.getString(new SqlObject(resSql)
						.setParameter("customername", resCustomerExcelVO.getCustomername())
						.setParameter("certid", resCustomerExcelVO.getCertid()));
			
			//判断新导入的excel表中是否存在重复行，存在则只新增前面的那条数据
			if (StringUtils.isBlank(customerID_res)) {*/
			//新增车主现金贷款Excel导入表数据rescashaccesscustomer
			sqlca.executeSQL(new SqlObject(resCustomersql)
				.setParameter("SERIALNO", resCustomerExcelVO.getSerialno())
				.setParameter("CUSTOMERID", customerID)
				.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
				.setParameter("SEX", resCustomerExcelVO.getSex())
				.setParameter("TELEPHONE", resCustomerExcelVO.getTelephone())
				.setParameter("CERTID", resCustomerExcelVO.getCertid())
				.setParameter("PROVINCE", resCustomerExcelVO.getProvince())
				.setParameter("CITY", resCustomerExcelVO.getCity())
				.setParameter("WORKADDRESS", resCustomerExcelVO.getWorkaddress())
				.setParameter("ADDRESS", resCustomerExcelVO.getAddress())
				.setParameter("PRODUCTTYPE", resCustomerExcelVO.getProducttype())
				.setParameter("PRODUCTFEATURE", resCustomerExcelVO.getProductfeature())
				.setParameter("EVENTNAME", resCustomerExcelVO.getEventname())
				.setParameter("EVENTDATE", resCustomerExcelVO.getEventdate())
				.setParameter("EVENTENDDATE", resCustomerExcelVO.getEventenddate())
				.setParameter("EVENTPHASE", resCustomerExcelVO.getEventphase())
				.setParameter("AMOUNTLIMIT", resCustomerExcelVO.getAmountlimit())
				.setParameter("TOPMONTHPAYMENT", resCustomerExcelVO.getTopmonthpayment())
				.setParameter("TERM", resCustomerExcelVO.getTerm())
				.setParameter("BATCHNO", resCustomerExcelVO.getBatchno())
				.setParameter("INPUTDATE", resCustomerExcelVO.getInputdate()));
			//}
			
			/*if(i % 1000 == 0){
				sqlca.commit();// 提交事物
			}
			
			i++;*/
			
			// 删除长传文件路径
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
					tmpFile.delete();
			}
			
		}
		
		sqlca.commit(); // 提交事物
		
		ARE.getLog().info("车主现金贷款客户导入名单结束");
		
		return "导入成功";
	}
	/*********检查字段类型为日期性的合法性方法 huzp ***************/
	public static String checkDate(String checkValue) throws Exception {
		String flag = "0";
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date d = null;
		if (checkValue != null && !checkValue.equals("")) {
			if (checkValue.split("/").length > 1) {
				dateFormat = new SimpleDateFormat("yyyy/MM/dd");
			}
			if (checkValue.split("-").length > 1) {
				dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			}
		} else {
			return flag;
		}
		try {
			d = dateFormat.parse(checkValue);
		} catch (Exception e) {
			return flag;
		}
		String eL = "^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-9]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
		Pattern p = Pattern.compile(eL);
		Matcher m = p.matcher(checkValue);
		boolean b = m.matches();
		if (b) {
			flag="1";
			return flag;

		} else {
			flag="0";
			return flag;
		}
	}
	
	/**
	 * 赋值客户信息VO
	 * @param arow
	 * @return
	 */
	private ResCustomerExcelVO setResCustomerExcelVO(String[] arow){
		ResCustomerExcelVO resCustomerExcelVO = new ResCustomerExcelVO();
		// 客户姓名
		resCustomerExcelVO.setCustomername(arow[0]);
		// 性别
		resCustomerExcelVO.setSex(arow[1]);
		// 联系电话
		resCustomerExcelVO.setTelephone(arow[2]);
		// 身份证号
		resCustomerExcelVO.setCertid(arow[3]);
		// 省份
		resCustomerExcelVO.setProvince(arow[4]);
		// 城市
		resCustomerExcelVO.setCity(arow[5]);
		// 工作地址
		resCustomerExcelVO.setWorkaddress(arow[6]);
		// 联系地址
		resCustomerExcelVO.setAddress(arow[7]);
		// 产品类型
		resCustomerExcelVO.setProducttype(arow[8]);
		// 产品特征
		resCustomerExcelVO.setProductfeature(arow[9]);
		// 活动名称
		resCustomerExcelVO.setEventname(arow[10]);
		// 活动开始时间
		resCustomerExcelVO.setEventdate(arow[11]);
		// 活动结束时间
		resCustomerExcelVO.setEventenddate(arow[12]);
		// 活动客户所属阶段
		resCustomerExcelVO.setEventphase(arow[13]);
		// 现金贷最大贷款金额
		resCustomerExcelVO.setAmountlimit(arow[14]);
		// 最高月还款额
		resCustomerExcelVO.setTopmonthpayment(arow[15]);
		// 现金贷最长期限
		resCustomerExcelVO.setTerm(arow[16]);
		// 批次号
		resCustomerExcelVO.setBatchno(arow[17]);
		// 区县镇
		resCustomerExcelVO.setCountryside(arow[18]);
		// 街道村
		resCustomerExcelVO.setVillagecenter(arow[19]);
		// 小区楼盘
		resCustomerExcelVO.setPlot(arow[20]);
		// 栋\单元\房间号
		resCustomerExcelVO.setRoom(arow[21]);
		// 省份城市[客户现住地址]
		resCustomerExcelVO.setFamilyadd(arow[22]);

		//证件类型
		resCustomerExcelVO.setCerttype("Ind01");
		//客户类型
		resCustomerExcelVO.setCustomertype("0310");
		// 机构id
		resCustomerExcelVO.setInputorgid(orgid);
		// 用户编号
		resCustomerExcelVO.setInputuserid(userid);
		// 导入时间
		resCustomerExcelVO.setInputdate(inputdate);
		// 更新时间
		resCustomerExcelVO.setUpdatedate("");
		// 文件路径
		resCustomerExcelVO.setFilePath(filePath);
		
		ARE.getLog().info(resCustomerExcelVO.toString());
		
		return resCustomerExcelVO;
	}
}
