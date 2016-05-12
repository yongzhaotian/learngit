package com.amarsoft.webclient;

import java.net.MalformedURLException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import cn.com.nciic.www.SimpleCheckByJson;
import cn.com.nciic.www.SimpleCheckByJsonResponse;
import cn.com.nciic.www.service.IdentifierServiceStub;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.ARE;
/**
 * 简项公民身份信息认证服务是全国公民身份信息认证服务的基础服务，
 * 是全国公民身份信息认证系统对被认证人授权用户提交的公民身份证号码
 * 和姓名进行“一致”或“不一致”比对。
 * @author quliangmao
 *
 */
public class RenZhengBao {
	private String userName;//用户名
	private String password;//密码
	private String realName;//客户姓名
	private String idCardNum;//身份证号
	private String optionUser;//审批人
	protected final static Log logger = ARE.getLog();
	public String runParserId(Transaction Sqlca) {
		this.logger.debug("简项认证 开始");
		return simpleCheckByJson(Sqlca,idCardNum,realName,userName,password,optionUser);
		
	}
	
	

	/**
	 * 简项认证 根据身份证号码与姓名  到认证宝查询 看是否一致
	 * @param info
	 * @param id5
	 * @return
	 * @throws SQLException 
	 * @throws MalformedURLException
	 */
	public static  String  simpleCheckByJson(Transaction Sqlca,String idCardNum, String realName, String userName, String password,String optionUser) {  
		 String obj="";
		final Transaction Sqlca1=Sqlca;
		final String idCardNum1=idCardNum;
		final String realName1=realName;
		final String userName1=userName; 
		final String password1=password;
		final String optionUser1=optionUser;
       ExecutorService exec = Executors.newFixedThreadPool(1);  
      Callable<String> call = new Callable<String>() { 
          public String call() throws Exception {  
          	String sss=getResultTimeOut(Sqlca1,idCardNum1,realName1,userName1,password1,optionUser1);
              return sss;  
          }  
      };  
        
      try {  
          Future<String> future = exec.submit(call);  
           obj = future.get(1000 * 10, TimeUnit.MILLISECONDS); //任务处理超时时间设为 10 秒  
          System.out.println("任务成功返回:" + obj);  
      } catch (TimeoutException ex) {  
    		logger.info("认证宝返回超时");
    		obj="";
      } catch (Exception e) {  
    	  logger.info("处理异常");
    	  obj="";
      }  
      // 关闭线程池  
      exec.shutdown();  
      return obj;
  }
	
	private static String  getResultTimeOut(Transaction Sqlca,String idCardNum, String realName, String userName, String password,String optionUser) {
//		logger.debug("简项认证 开始");
		String result="";
		String updatedate="";
		String sbInsert="";
		Date datefrom = null; 
		Date dateTo = null; 
//		userName="bqjr_admin";
//		password="baiqian123";
		java.util.Calendar rightNow = java.util.Calendar.getInstance(); 
		DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sim = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		 //得到当前时间，+30天 
		 rightNow.add(java.util.Calendar.DAY_OF_MONTH, -30);    
		 String date = sim.format(rightNow.getTime());  
		 String sCntExist = "SELECT STATUS,UPDATEDATE FROM BUSINESS_RENZHENGBAO_INFO where IDCARDNUM=:IDCARDNUM and CUSTOMERNAME=:CUSTOMERNAME";
			try {
					ASResultSet rs = Sqlca.getResultSet(new SqlObject(sCntExist).setParameter("IDCARDNUM", idCardNum).setParameter("customerName", realName));
					if ( rs.next() ) {   // 已经存在于数据库，直接从数据库中查询数据
						result = rs.getString(1)+"_1";
						updatedate=rs.getString(2);
						datefrom = format1.parse(date);   
						dateTo = format2.parse(updatedate); 
					}
					rs.getStatement().close();
			} catch (Exception e) {
				
				e.printStackTrace();
				result = "error";
			}
		if(dateTo==null||datefrom.getTime() >dateTo.getTime()||"error".equals(result)){//如果当天+30 大于最新更新时间 增重新查询，否则返回数据库指
		try {
			String req = String.format("{\"IDNumber\":\"%s\",\"Name\":\"%s\"}", idCardNum, realName);
			String cred = String.format("{\"UserName\":\"%s\",\"Password\":\"%s\"}", userName, password);
			
			IdentifierServiceStub client = new IdentifierServiceStub();
			 
			SimpleCheckByJson scbj = new SimpleCheckByJson();
			scbj.setCred(cred);
			scbj.setRequest(req);
			
			SimpleCheckByJsonResponse scbr = client.simpleCheckByJson(scbj);
			//{"Identifier":null,"RawXml":null,"ResponseCode":-60,"ResponseText":"传入参数错误，库中无此号，不一致，一致"}
			//String str="{\"Identifier\":{\"IDNumber\":\"433122198606129056\",\"Name\":\"瞿良茂\",\"FormerName\":null,\"Sex\":\"男性\",\"Nation\":null,\"Birthday\":\"1986-06-12\",\"Company\":null,\"Education\":null,\"MaritalStatus\":null,\"NativePlace\":null,\"BirthPlace\":null,\"Address\":null,\"Photo\":\"\",\"QueryTime\":null,\"IsQueryCitizen\":false,\"Result\":\"一致\"},\"RawXml\":null,\"ResponseCode\":100,\"ResponseText\":\"成功\"}";
			    String  retJson = scbr.getSimpleCheckByJsonResult();
			   String responsetext= parseJSON2Map(retJson).get("ResponseText")+"";
			    if("成功".equals(responsetext)){
			    	String strmap =parseJSON2Map(retJson).get("Identifier")+"";
			    	Map map =parseJSON2Map(strmap);
			    	result=map.get("Result")+"";
			    }else{
			    	result="error";
			    }
			    if(!"".equals(updatedate)){// 数据已经存在
			    	 sbInsert = "update business_renzhengbao_info  set STATUS='"+result+"', UPDATEDATE=to_char(sysdate,'yyyy-MM-dd'),CREATEBY='"+optionUser+"' where IDCARDNUM='"+idCardNum+"' and CUSTOMERNAME='"+realName+"'";	// 生成insert段字符串
			    }else{
			    	 sbInsert = "insert into business_renzhengbao_info (STATUS, IDCARDNUM, UPDATEBY, UPDATEDATE, CREATEBY, CREATEDATE,CUSTOMERNAME)values ('"+result+"', '"+idCardNum+"', '"+optionUser+"', to_char(sysdate,'yyyy-MM-dd'), '"+optionUser+"', to_char(sysdate,'yyyy-MM-dd'),'"+realName+"')";	// 生成insert段字符串
			    	
			    }
			    SqlObject asql = new SqlObject(sbInsert);
			    Sqlca.executeSQL(asql);
			    Sqlca.commit();
//				this.logger.info("简项认证 结果："+result);
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		}
		return result;
	}
	
	/**
	 * 解析json格式信息 转换为map格式
	 * @param jsonStr
	 * @return
	 */
	public static Map<String, Object> parseJSON2Map(String jsonStr){   
	       Map<String, Object> map = new HashMap<String, Object>();   
	       //最外层解析   
	       JSONObject json = JSONObject.fromObject(jsonStr);   
	       for(Object k : json.keySet()){   
	           Object v = json.get(k);    
	           //如果内层还是数组的话，继续解析   
	           if(v instanceof JSONArray){   
	               List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();   
	               Iterator<JSONObject> it = ((JSONArray)v).iterator();   
	               while(it.hasNext()){   
	                   JSONObject json2 = it.next();   
	                   list.add(parseJSON2Map(json2.toString()));   
	               }   
	               map.put(k.toString(), list);   
	           } else {   
	               map.put(k.toString(), v);   
	           }   
	       }   
//	       this.logger.info("简项认证 返回结果解析JSON："+map);
	       
	       return map;   
	   } 
	public RenZhengBao(String userName, String password, String realName, String idCardNum) {
		this.userName = userName;
		this.password = password;
		this.realName = realName;
		this.idCardNum = idCardNum;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public String getIdCardNum() {
		return idCardNum;
	}
	public void setIdCardNum(String idCardNum) {
		this.idCardNum = idCardNum;
	}



	public String getOptionUser() {
		return optionUser;
	}



	public void setOptionUser(String optionUser) {
		this.optionUser = optionUser;
	}
	
}
