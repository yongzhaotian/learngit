package com.amarsoft.app.billions;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import  com.amarsoft.app.billions.UpdateMinanUtilXML;
import com.amarsoft.are.util.DataConvert;


/**
 * 
 * @author qulianmao
 *
 */
public class SelectMangeReceiveNo {
	
	public static final String INIT_CUSTOMERID = "10000000";

	private String serialNo;//合同号
	
	private String expressno;//快递号
	
	private String updateBy;//更新人
	
	private String serialnoconurl;//传入的数据
	
	private String receivestauts;// 是否接收
	
	public String getReceivestauts() {
		return receivestauts;
	}
	public void setReceivestauts(String receivestauts) {
		this.receivestauts = receivestauts;
	}
	public String getSerialnoconurl() {
		return serialnoconurl;
	}
	public void setSerialnoconurl(String serialnoconurl) {
		this.serialnoconurl = serialnoconurl;
	}
	public String getUpdateBy() {
		return updateBy;
	}
	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}

	public String getExpressno() {
		return expressno;
	}
	public void setExpressno(String expressno) {
		this.expressno = expressno;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	/**
	 * 根据快递单号查询是否有合同
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String selctReceiveNo(Transaction sqlca) throws Exception {
		
		if (expressno == null) {
			throw new RuntimeException("请传入快递号！");
		}
		System.out.println("根据快递单号查询是否有合同");
		String serialno = sqlca.getString(new SqlObject("select wm_concat(sc.contractno) from package_info pi ,Shop_Contract sc where pi.packno=sc.packno and pi.postbillno=:expressno").setParameter("expressno", expressno));
		if(serialno ==null||"".equals(serialno)){
			return "F";
		}
		return serialno;
	}
	/**
	 * 更新民安保险状态(申请状态)
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String updateReceive(Transaction sqlca) throws Exception {
		
		if (expressno == null ||serialnoconurl==null) {
			throw new RuntimeException("请传入快递单号！");
		}
		String createdate =new SimpleDateFormat("yyyy/MM/dd").format(new Date());
		try {
			sqlca.executeSQL(new SqlObject("delete business_mange_receive  where EXPRESSNO='"+expressno+"'"));
			
			String[] arrayUrl=serialnoconurl.split("_");
			if(arrayUrl !=null &&arrayUrl.length>0){
				for (int i = 0; i < arrayUrl.length; i++) {
					String[] array=arrayUrl[i].split("@");
					if(array!= null){
						if(array.length >1){
							String type=array[0];
							String isexist=array[1];
							String serialnocon=array[2];
							if("有".equals(isexist)){
								isexist="1";
							}else{
								isexist="0";
							}
							sqlca.executeSQL(new SqlObject("insert into business_mange_receive (SERIALNO, EXPRESSNO, ISEXIST, RECEIVESTAUTS, FILETYPE, RECEIVEBY, CREATEBY, CREATEDATE, UPDATEBY, UPDATEDATE)"
									+"values ('"+serialnocon+"', '"+expressno+"', '"+isexist+"', '"+receivestauts+"', '"+type+"', '"+updateBy+"', '"+updateBy+"', '"+createdate+"', '"+updateBy+"', '"+createdate+"')"));
						}
					}
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "S";
	}
	

	
}
