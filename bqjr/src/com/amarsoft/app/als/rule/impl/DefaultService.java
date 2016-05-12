package com.amarsoft.app.als.rule.impl;

import java.math.BigDecimal;
import java.sql.Time;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import org.apache.poi.hssf.record.chart.BeginRecord;

import com.amarsoft.app.als.rule.InsertRuleRunLog;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.core.object.ResultObject;
import com.amarsoft.core.util.CommonUtil;
import com.amarsoft.core.util.StringUtil;

/**
 * 
 * @author 
 * @version
 *   1.0.0 
 *    		
 * @since
 *      jli5    2015-4-21  下午5:48:48 重构代码增加调用规则引擎日志模块  
 */
public class DefaultService {
	
	private String ItemName = "";//前期数据准备名
	private String ItemDescribe = "";//前期数据准备中文名
	private String GetDataType = "";//前期数据准备取数类型
	private String GetFunction = "";//前期数据准备取数方法
	private String RuleenGineparaName = "";//前期数据准备对应字段
	private String TableName = "";//表名
	private String Fieldcode = "";//字段名
	private String ReturnValue = "";
	private ASResultSet RuleRs = null;
	private ASResultSet RuleRq = null;
	private HashMap map = null;
	private String sObjectNo = "";
	private String sObjectType = "";
	private String sAllCont = "";
	private String sAllValues = "";
	
	private ASResultSet RuleScene = null;//场景汇总信息
	private String sProductID = "";//产品类型
	private String sSceneID = "";//场景编号
	private String sRuleFlowID = "";//规则编号
	private String sRuleObjectID = "";//对象编号
	private String sResultTable = "";//规则返回信息记录表表名
	
	BizObject boBusinessType = null;
	BizObject boCustomer = null;
	BizObject boContract = null;
	
	public String getResultJs(Transaction Sqlca) throws Exception{
		getRuleSceneInfo(Sqlca,"01");
		String rs = getResult(Sqlca);
		return rs;
	}
	
	public String getResultHq(Transaction Sqlca) throws Exception{
		getRuleSceneInfo(Sqlca,"03");
		String rs = getAfteResult(Sqlca);
		return rs;
	}
	
	public void setObjectNo(String sObjectNo){
		this.sObjectNo = sObjectNo;
	}
	public void setObjectType(String sObjectType){
		this.sObjectType = sObjectType;
	}
	
	public String getResult(Transaction Sqlca) throws Exception {
			ARE.init();
		JSONObject jObject = null;
		String sSql = "";
		String sDate = DateX.format(new Date()); 
		
		//定义变量：最大合同流水号
//		ARE.getLog().info("规则引擎数据准备开始，ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		Calendar rightNow = Calendar.getInstance();
		String BEGINTIME1 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
		//前期数据准备
		sSql = "select distinct TableName as TableName "+
				" from PREPAREDATE_INFO where GetDataType = 'default' and Inputoroutput = 'Input' and (TableName <> '' or TableName is not null) and SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			TableName = RuleRs.getString("TableName");
			if(TableName.equals("BUSINESS_TYPE")){
				Fieldcode = "";
				boBusinessType=JBOFactory.getFactory().getManager("jbo.rule.BUSINESS_TYPE").createQuery("TypeNo=:TypeNo")
						.setParameter("TypeNo",Sqlca.getString("select BusinessType from Business_Contract where serialno = '"+sObjectNo+"'")).getSingleResult(false);
				sSql = "select Fieldcode,RuleenGineparaName "
						+ " from PREPAREDATE_INFO where GetDataType = 'default' and TableName =:TableName and SceneID =:SceneID ";
				RuleRq = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TableName", TableName).setParameter("SceneID", sSceneID));
				while(RuleRq.next()){
					Fieldcode = boBusinessType.getAttribute(RuleRq.getString("Fieldcode")).toString();
					RuleenGineparaName = RuleRq.getString("RuleenGineparaName");
					if(Fieldcode == null || Fieldcode == "" || Fieldcode.startsWith(" ")) Fieldcode = "null";
					Fieldcode = Fieldcode.replace("/", "");
					Fieldcode = Fieldcode.replace(":", "");
					Fieldcode = Fieldcode.replace(",", "");
					jObject = setNodeValue(jObject, RuleenGineparaName,Fieldcode);
				}
				RuleRq.getStatement().close();
			}
			if(TableName.equals("BUSINESS_CONTRACT")){
				Fieldcode = "";
				boContract=JBOFactory.getFactory().getManager("jbo.rule.BUSINESS_CONTRACT").createQuery("SerialNo=:SerialNo")
						.setParameter("SerialNo",sObjectNo).getSingleResult(false);
				sSql = "select Fieldcode,RuleenGineparaName "
						+ " from PREPAREDATE_INFO where GetDataType = 'default' and TableName =:TableName and SceneID =:SceneID ";
				RuleRq = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TableName", TableName).setParameter("SceneID", sSceneID));
				while(RuleRq.next()){
					Fieldcode = boContract.getAttribute(RuleRq.getString("Fieldcode")).toString();
					RuleenGineparaName = RuleRq.getString("RuleenGineparaName");
					if(Fieldcode == null || Fieldcode == "" || Fieldcode.startsWith(" ")) Fieldcode = "null";
					Fieldcode = Fieldcode.replace("/", "");
					Fieldcode = Fieldcode.replace(":", "");
					Fieldcode = Fieldcode.replace(",", "");
					jObject = setNodeValue(jObject, RuleenGineparaName,Fieldcode);
				}
				RuleRq.getStatement().close();
			}
			if(TableName.equals("IND_INFO")){
				Fieldcode = "";
				boCustomer=JBOFactory.getFactory().getManager("jbo.rule.IND_INFO").createQuery("CustomerID=:CustomerID")
						.setParameter("CustomerID",Sqlca.getString("select CustomerID from Business_Contract where serialno = '"+sObjectNo+"'")).getSingleResult(false);
				sSql = "select Fieldcode,RuleenGineparaName "
						+ " from PREPAREDATE_INFO where GetDataType = 'default' and TableName =:TableName and SceneID =:SceneID";
				RuleRq = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TableName", TableName).setParameter("SceneID", sSceneID));
				while(RuleRq.next()){
					Fieldcode = boCustomer.getAttribute(RuleRq.getString("Fieldcode")).toString();
					RuleenGineparaName = RuleRq.getString("RuleenGineparaName");
					if(Fieldcode == null || Fieldcode == "" || Fieldcode.startsWith(" ")) Fieldcode = "null";
					Fieldcode = Fieldcode.replace("/", "");
					Fieldcode = Fieldcode.replace(":", "");
					Fieldcode = Fieldcode.replace(",", "");
					jObject = setNodeValue(jObject, RuleenGineparaName,Fieldcode);
					
					RuleenGineparaName = RuleenGineparaName.split("\\.")[2];
					if(RuleenGineparaName.equals("exradp") || RuleenGineparaName.equals("interCode") || RuleenGineparaName.equals("sex") || RuleenGineparaName.equals("AGE")
							 || RuleenGineparaName.equals("IS_Weekend") || RuleenGineparaName.equals("education") || RuleenGineparaName.equals("familyState") || RuleenGineparaName.equals("employmentcompanyType")
							 || RuleenGineparaName.equals("employmentposition") || RuleenGineparaName.equals("fieldExperience") || RuleenGineparaName.equals("IsNewApplicant") || RuleenGineparaName.equals("havefixline")
							 || RuleenGineparaName.equals("SSI")){
					}
				}
				RuleRq.getStatement().close();
			}
			
			
		}
		RuleRs.getStatement().close();
		sSql = "select GetDataType,GetFunction,Fieldcode,TableName,RuleenGineparaName "+
				" from PREPAREDATE_INFO where GetDataType <> 'default' and Inputoroutput = 'Input' and SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			ReturnValue = "";
			GetDataType = RuleRs.getString("GetDataType");
			GetFunction = RuleRs.getString("GetFunction");
			RuleenGineparaName = RuleRs.getString("RuleenGineparaName");
			TableName = RuleRs.getString("TableName");
			Fieldcode = RuleRs.getString("Fieldcode");
			if(TableName == null) TableName = "";
			if(Fieldcode == null) Fieldcode = "";
			if(GetFunction == null) GetFunction = "";
			ARE.getLog().info("用SQL取数的方法："+GetFunction);
			if(GetDataType.equals("Sql")){
				if(!"".equals(TableName) && !"".equals(Fieldcode)){
					String sTableName[] = TableName.split(",");
					String sCondName[] = Fieldcode.split(",");
					for(int i = 0; i < sTableName.length; i++){
						if(sTableName[i].equals("BUSINESS_TYPE")){
							String cond = boBusinessType.getAttribute(sCondName[i]).toString();
							cond = cond.replace("'", "''");
							GetFunction = StringFunction.replace(GetFunction ,"#"+sCondName[i] , cond);
						}
						if(sTableName[i].equals("BUSINESS_CONTRACT")){
							String cond = boContract.getAttribute(sCondName[i]).toString();
							cond = cond.replace("'", "''");
							GetFunction = StringFunction.replace(GetFunction ,"#"+sCondName[i] , cond);
						}
						if(sTableName[i].equals("IND_INFO")){
							String cond = boCustomer.getAttribute(sCondName[i]).toString();
							cond = cond.replace("'", "''");
							GetFunction = StringFunction.replace(GetFunction ,"#"+sCondName[i] , cond);
						}
					}
					if(!"".equals(RuleenGineparaName)){
						RuleRq = Sqlca.getASResultSet(GetFunction);
						if(RuleRq.next()){
							ReturnValue = RuleRq.getString(1);
						}
						ARE.getLog().info("SQL执行结果："+ReturnValue);
						RuleRq.getStatement().close();
					}else{
						
					}
				}else if(!"".equals(GetFunction)){
					RuleRq = Sqlca.getASResultSet(GetFunction);
					if(RuleRq.next()){
						ReturnValue = RuleRq.getString(1);
					}
					RuleRq.getStatement().close();
				}else{
					ReturnValue = "null";
				}
				
				if(RuleenGineparaName.equals("exradp") || RuleenGineparaName.equals("interCode") || RuleenGineparaName.equals("sex") || RuleenGineparaName.equals("AGE")
						 || RuleenGineparaName.equals("IS_Weekend") || RuleenGineparaName.equals("education") || RuleenGineparaName.equals("familyState") || RuleenGineparaName.equals("employmentcompanyType")
						 || RuleenGineparaName.equals("employmentposition") || RuleenGineparaName.equals("fieldExperience") || RuleenGineparaName.equals("IsNewApplicant") || RuleenGineparaName.equals("havefixline")
						 || RuleenGineparaName.equals("SSI")){
				}
				
				
				if(ReturnValue == null || ReturnValue == "") ReturnValue = "null";
				ReturnValue = ReturnValue.replace("/", "");
				ReturnValue = ReturnValue.replace(":", "");
				ReturnValue = ReturnValue.replace(" ", "");
				ReturnValue = ReturnValue.replace(",", "");
				ARE.getLog().info("解析后的SQL执行结果："+ReturnValue);
				jObject = setNodeValue(jObject, RuleenGineparaName,ReturnValue);
			}
			
		}
		RuleRs.getStatement().close();
		jObject = setNodeValue(jObject, sSceneID+"."+sRuleObjectID+".Kind", "InOut");
//		ARE.getLog().info("规则引擎数据准备结束，ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		rightNow = Calendar.getInstance();
	    String ENDTIME1 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
		
	    rightNow = Calendar.getInstance();
        String BEGINTIME2 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
        
//		ARE.getLog().info("规则引擎调用开始，ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		String calcResult = RuleConnectionService.callRule(sSceneID, "RuleFlow", sRuleFlowID, jObject.toString(), "{}");
//		ARE.getLog().info("规则引擎调用结束，ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		rightNow = Calendar.getInstance();
	    String ENDTIME2 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
	        
		InsertRuleRunLog.insertLog(BEGINTIME1, ENDTIME1, BEGINTIME2, ENDTIME2, Sqlca, sObjectNo, "First");
		
		
		ResultObject resultObject = new ResultObject(calcResult);
//		System.out.println("流程选择:" + resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".workflowCode", ""));
		
		sSql = "select Ruleengineparaname from PREPAREDATE_INFO where SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			String sName = RuleRs.getString("Ruleengineparaname");
            if("".equals(sName)  ||  sName.split("\\.").length<3){
                throw new Exception("数据准备错误Ruleengineparaname不符合标准");
            }
            RuleenGineparaName = sName.split("\\.")[2];
			String value = resultObject.getResult("OBJECTS."+sName, "");
			if(value!=null && value.contains("E")){
				try{
					BigDecimal bd = new BigDecimal(value);
					value = bd.toPlainString();
				}catch(Exception e){
				}
			}
			sAllValues = sAllValues + "'" + value + "',";
			if(RuleenGineparaName.equals("extradp") || RuleenGineparaName.equals("interCode") || RuleenGineparaName.equals("sex") || RuleenGineparaName.equals("AGE")
					 || RuleenGineparaName.equals("IS_Weekend") || RuleenGineparaName.equals("education") || RuleenGineparaName.equals("familyState") || RuleenGineparaName.equals("employmentcompanyType")
					 || RuleenGineparaName.equals("employmentposition") || RuleenGineparaName.equals("fieldExperience") || RuleenGineparaName.equals("IsNewApplicant") || RuleenGineparaName.equals("havefixline")
					 || RuleenGineparaName.equals("SSI") || RuleenGineparaName.equals("default_value") || RuleenGineparaName.equals("creditAmount") || RuleenGineparaName.equals("goodsCategoryExpensiveItem")){
				System.out.println(RuleenGineparaName+"======"+resultObject.getResult("OBJECTS.pospre.pospredata."+RuleenGineparaName, ""));
			}
			sAllCont = sAllCont + RuleenGineparaName + ",";
		}
		RuleRs.getStatement().close();
		sAllCont = sAllCont.substring(0, sAllCont.length()-1);
		sAllCont = "SerialNo,"+sAllCont;
		sAllValues = sAllValues.substring(0, sAllValues.length()-1);
		//update CCS-761 消费贷销售提交时调用规则引擎失败的处理(一、对于A/B机器的程序作如下更改1、任何一个合同调用（无论是现金贷还是消费贷)时，如果返回结果为空则需要将合同号、更新时间保存至Pre_DATA表中，分别存储在PRE_Data表idcredit、updatetime两字段中。)
		String TableSerialNo = DBKeyHelp.getSerialNo(sResultTable,"SerialNo",Sqlca);
		sAllValues = "'"+TableSerialNo+"',"+sAllValues;
		ARE.getLog().info("字段名："+sAllCont+"\r\n值："+sAllValues);
		
		//产品类型（020-现金贷、030-消费贷）
		String sProductID = Sqlca.getString(new SqlObject("select ProductID from Business_Contract where SerialNo = :SerialNo").setParameter("SerialNo", sObjectNo));
		if(null == sProductID) sProductID = "";
		ARE.getLog().info("产品类型:"+sProductID);
		
		//规则引擎返回结果
		String sWorkFlowCode = resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".workflowCode", "");
		if("030".equals(sProductID) && (null == sWorkFlowCode || "".equals(sWorkFlowCode) || sWorkFlowCode.trim().length()<=0))
		{
			sSql = "INSERT INTO "+sResultTable+"(SERIALNO,IDCREDIT,UPDATETIME) "+
					" VALUES('"+TableSerialNo+"','"+sObjectNo+"',to_char(sysdate,'YYYY-MM-DD-HH24-MI-SS'))";
		}else
		{
			sSql = "INSERT INTO "+sResultTable+"("+sAllCont+") "+
					" VALUES("+sAllValues+")";
		}
		//end
//		System.out.println("执行的SQL："+sSql);
		Sqlca.executeSQL(new SqlObject(sSql));
//		System.out.println(calcResult);

		return resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".workflowCode", "");
	}
	
	/**
	 * 后去数据准备
	 */
	public String getAfteResult(Transaction Sqlca) throws Exception{
	    String sDate = DateX.format(new Date()); 
		JSONObject jObject = null;
		String sSql = "";
		//定义变量：最大合同流水号
		String sMaxContractNo = "";
		Calendar rightNow = Calendar.getInstance();
	    String BEGINTIME1 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 

		//前期数据准备
		sSql = "select distinct TableName as TableName "+
				" from AFTERDATA_INFO where GetDataType = 'default' and Inputoroutput = 'Input' and (TableName <> '' or TableName is not null) and SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			TableName = RuleRs.getString("TableName");
			if(TableName.equals("BUSINESS_TYPE")){
				Fieldcode = "";
				boBusinessType=JBOFactory.getFactory().getManager("jbo.rule.BUSINESS_TYPE").createQuery("TypeNo=:TypeNo")
						.setParameter("TypeNo",Sqlca.getString("select BusinessType from Business_Contract where serialno = '"+sObjectNo+"'")).getSingleResult(false);
				sSql = "select Fieldcode,RuleenGineparaName "
						+ " from AFTERDATA_INFO where GetDataType = 'default' and TableName =:TableName and SceneID =:SceneID ";
				RuleRq = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TableName", TableName).setParameter("SceneID", sSceneID));
				while(RuleRq.next()){
					Fieldcode = "";
					Fieldcode = boBusinessType.getAttribute(RuleRq.getString("Fieldcode")).toString();
					RuleenGineparaName = RuleRq.getString("RuleenGineparaName");
					if(Fieldcode == null || Fieldcode == "" || Fieldcode.startsWith(" ")) Fieldcode = "null";
					Fieldcode = Fieldcode.replace("/", "");
					Fieldcode = Fieldcode.replace(":", "");
					Fieldcode = Fieldcode.replace(",", "");
					jObject = setNodeValue(jObject, RuleenGineparaName,Fieldcode);
					System.out.println(RuleenGineparaName+"字段结果："+Fieldcode);
				}
				RuleRq.getStatement().close();
			}
			if(TableName.equals("BUSINESS_CONTRACT")){
				Fieldcode = "";
				boContract=JBOFactory.getFactory().getManager("jbo.rule.BUSINESS_CONTRACT").createQuery("SerialNo=:SerialNo")
						.setParameter("SerialNo",sObjectNo).getSingleResult(false);
				sSql = "select Fieldcode,RuleenGineparaName "
						+ " from AFTERDATA_INFO where GetDataType = 'default' and TableName =:TableName and SceneID =:SceneID ";
				RuleRq = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TableName", TableName).setParameter("SceneID", sSceneID));
				while(RuleRq.next()){
					Fieldcode = boContract.getAttribute(RuleRq.getString("Fieldcode")).toString();
					RuleenGineparaName = RuleRq.getString("RuleenGineparaName");
					if(Fieldcode == null || Fieldcode == "" || Fieldcode.startsWith(" ")) Fieldcode = "null";
					Fieldcode = Fieldcode.replace("/", "");
					Fieldcode = Fieldcode.replace(":", "");
					Fieldcode = Fieldcode.replace(",", "");
					jObject = setNodeValue(jObject, RuleenGineparaName,Fieldcode);
					System.out.println(RuleenGineparaName+"字段结果："+Fieldcode);
				}
				RuleRq.getStatement().close();
			}
			if(TableName.equals("IND_INFO")){
				Fieldcode = "";
				boCustomer=JBOFactory.getFactory().getManager("jbo.rule.IND_INFO").createQuery("CustomerID=:CustomerID")
						.setParameter("CustomerID",Sqlca.getString("select CustomerID from Business_Contract where serialno = '"+sObjectNo+"'")).getSingleResult(false);
				sSql = "select Fieldcode,RuleenGineparaName "
						+ " from AFTERDATA_INFO where GetDataType = 'default' and TableName =:TableName and SceneID =:SceneID ";
				RuleRq = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TableName", TableName).setParameter("SceneID", sSceneID));
				while(RuleRq.next()){
					Fieldcode = boCustomer.getAttribute(RuleRq.getString("Fieldcode")).toString();
					RuleenGineparaName = RuleRq.getString("RuleenGineparaName");
					if(Fieldcode == null || Fieldcode == "" || Fieldcode.startsWith(" ")) Fieldcode = "null";
					Fieldcode = Fieldcode.replace("/", "");
					Fieldcode = Fieldcode.replace(":", "");
					Fieldcode = Fieldcode.replace(",", "");
					jObject = setNodeValue(jObject, RuleenGineparaName,Fieldcode);
					System.out.println(RuleenGineparaName+"字段结果："+Fieldcode);
				}
				RuleRq.getStatement().close();
			}
		}
		RuleRs.getStatement().close();
		sSql = "select GetDataType,GetFunction,Fieldcode,TableName,RuleenGineparaName "+
				" from AFTERDATA_INFO where GetDataType <> 'default' and Inputoroutput = 'Input' and SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			GetDataType = RuleRs.getString("GetDataType");
			GetFunction = RuleRs.getString("GetFunction");
			RuleenGineparaName = RuleRs.getString("RuleenGineparaName");
			TableName = RuleRs.getString("TableName");
			Fieldcode = RuleRs.getString("Fieldcode");
			if(TableName == null) TableName = "";
			if(Fieldcode == null) Fieldcode = "";
			if(GetFunction == null) GetFunction = "";
			
			if(GetDataType.equals("Sql")){
				System.out.println("用SQL取数的方法："+GetFunction);
				ReturnValue = "";
				if(!"".equals(TableName) && !"".equals(Fieldcode)){
					String sTableName[] = TableName.split(",");
					String sCondName[] = Fieldcode.split(",");
					for(int i = 0; i < sTableName.length; i++){
						if(sTableName[i].equals("BUSINESS_TYPE")){
							String cond = boBusinessType.getAttribute(sCondName[i]).toString();
							GetFunction = StringFunction.replace(GetFunction ,"#"+sCondName[i] , cond);
						}
						if(sTableName[i].equals("BUSINESS_CONTRACT")){
							String cond = boContract.getAttribute(sCondName[i]).toString();
							GetFunction = StringFunction.replace(GetFunction ,"#"+sCondName[i] , cond);
						}
						if(sTableName[i].equals("IND_INFO")){
							String cond = boCustomer.getAttribute(sCondName[i]).toString();
							GetFunction = StringFunction.replace(GetFunction ,"#"+sCondName[i] , cond);
						}
					}
					if(!"".equals(RuleenGineparaName)){
						RuleRq = Sqlca.getASResultSet(GetFunction);
						if(RuleRq.next()){
							ReturnValue = RuleRq.getString(1);
						}
						RuleRq.getStatement().close();
					}else{
						ReturnValue = "null";
					}
				}else if(!"".equals(GetFunction)){
					RuleRq = Sqlca.getASResultSet(GetFunction);
					if(RuleRq.next()){
						ReturnValue = RuleRq.getString(1);
					}
					RuleRq.getStatement().close();
				}else{
					ReturnValue = "null";
				}
				if(ReturnValue == null || ReturnValue == "") ReturnValue = "null";
				ReturnValue = ReturnValue.replace("/", "");
				ReturnValue = ReturnValue.replace(":", "");
				ReturnValue = ReturnValue.replace(" ", "");
				ReturnValue = ReturnValue.replace(",", "");
				System.out.println("解析后的SQL执行结果："+ReturnValue);
				jObject = setNodeValue(jObject, RuleenGineparaName,ReturnValue);
			}
			
		}
		RuleRs.getStatement().close();
		rightNow = Calendar.getInstance();
	    String ENDTIME1 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 

	    rightNow = Calendar.getInstance();
        String BEGINTIME2 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
		jObject = setNodeValue(jObject, sSceneID+"."+sRuleObjectID+".Kind", "InOut");
		String calcResult = RuleConnectionService.callRule(sSceneID, "RuleFlow", sRuleFlowID, jObject.toString(), "{}");
		rightNow = Calendar.getInstance();
	    String ENDTIME2 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 

		InsertRuleRunLog.insertLog(BEGINTIME1, ENDTIME1, BEGINTIME2, ENDTIME2, Sqlca, sObjectNo, "Third");
		
		ResultObject resultObject = new ResultObject(calcResult);
//		System.out.println("流程选择:" + resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".PostWorkflowCode", ""));
		
		sSql = "select Ruleengineparaname from AFTERDATA_INFO where SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			String sName = RuleRs.getString("Ruleengineparaname");
            if("".equals(sName)  ||  sName.split("\\.").length<3){
                throw new Exception("数据准备错误Ruleengineparaname不符合标准");
            }
            RuleenGineparaName = sName.split("\\.")[2];
			sAllValues = sAllValues + "'" + resultObject.getResult("OBJECTS."+sName, "") + "',";
			sAllCont = sAllCont + RuleenGineparaName + ",";
		}
		RuleRs.getStatement().close();
		sAllCont = sAllCont.substring(0, sAllCont.length()-1);
		sAllCont = "SerialNo,"+sAllCont;
		sAllValues = sAllValues.substring(0, sAllValues.length()-1);
		sAllValues = "'"+DBKeyHelp.getSerialNo(sResultTable,"SerialNo",Sqlca)+"',"+sAllValues;
//		System.out.println("字段名："+sAllCont+"\r\n值："+sAllValues);
		sSql = "INSERT INTO "+sResultTable+"("+sAllCont+") "+
				" VALUES("+sAllValues+")";
//		System.out.println("执行的SQL："+sSql);
		Sqlca.executeSQL(new SqlObject(sSql));
//		System.out.println(calcResult);
		return resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".PostWorkflowCode", "");
	}
	
	
    /**
     * 把节点名称和值拼装进JSON对象
     *
     * @param   jObject  原JSON对象
     * @param   ID       节点名称
     * @param   value    节点值
     * @return  新JSON对象
     * @throws  Exception 
     */
	public static JSONObject setNodeValue(JSONObject jObject, String ID, String value) throws Exception {
		String[] aID = StringUtil.split(ID,".");
		if (value==null) {value = "";};
		String sObject = "";
		for (int i = aID.length - 1; i >= 0; i--) {
			if (i == aID.length - 1) {
				if (value.length() > 1
						&& (value.substring(0, 1).equals("0") && !value
								.substring(1, 2).equals("."))) {
					sObject = "{" + aID[i] + ":\"" + value + "\"}";
				} else {
					if (value.contains("E") || value.contains("e")) {
						sObject = "{" + aID[i] + ":\"" + value + "\"}";
					} else {
						try {
							sObject = "{" + aID[i] + ":" + value + "}";
						} catch (Exception e) {
							sObject = "{" + aID[i] + ":\"" + value + "\"}";
						}
					}
				}
			} else {
				sObject = "{" + aID[i] + ":" + sObject + "}";
			}
		}
		JSONObject jObject1 = new JSONObject(sObject);

		return CommonUtil.updateJSONObject(jObject,jObject1);
	}
	
	   /**
     * 获取JSON对象中某个节点的值
     *
     * @param   jObject  JSON对象
     * @param   ID       节点名称
     * @param   defaultvalue 默认值
     * @return  节点值
     * @throws  Exception 
     */
	public static String getNodeValue(JSONObject jObject,String ID, String defaultvalue) throws Exception {
		try {
			Object oValue = null;
			String s = null;
			JSONObject oj = jObject;
			String[] aName = StringUtil.split(ID, ".");
			for (int i = 0; i < aName.length; i++) {
				oValue = oj.get(aName[i]);
				if (oValue == null) {
					s = defaultvalue;
					break;
				}
				if (i == aName.length - 1) {
					s = oValue.toString();
				} else {
					oj = (JSONObject) oValue;
				}
			}
			if (s == null || s.equals("") || s.equals("null")) {
				s = defaultvalue;
			}
			return s;
		} catch (Exception e) {
			return defaultvalue;
		}
	}
	
	 /**
     * 获取产品类型对应的场景编号、规则模型编号、对象编号以及规则返回结果的记录表表名
     *
     * @param   ProductID  贷款信息中的产品类型
     * @param   APPTYPE    场景汇总信息维护中选择的应用产品类型
     * @param   DATATYPE   数据准备类型（01:前期数据准备;02:中期数据准备;03:后期数据准备）
     * @param   SCENEID    场景编号
     * @param   RULEFLOWID 规则模型编号
     */
	public void getRuleSceneInfo(Transaction Sqlca,String DataType) throws Exception{
		String sColumn = "Attribute1";//规则返回结果记录表名存储字段（默认消费贷）
		sProductID = Sqlca.getString("select ProductID from Business_Contract where SerialNo = '"+sObjectNo+"'");
		if(null == sProductID) sProductID = "";
		String SQL = "SELECT SCENEID,RULEFLOWID,RULEOBJECTID FROM RULESCENE_INFO WHERE APPTYPE =:APPTYPE AND DATATYPE =:DATATYPE AND ISINUSE = '1'";
		RuleScene = Sqlca.getASResultSet(new SqlObject(SQL).setParameter("APPTYPE", sProductID).setParameter("DATATYPE", DataType));
		if(RuleScene.next())
		{
			sSceneID = RuleScene.getString("SCENEID");
			if(null == sSceneID) sSceneID = "";
			sRuleFlowID = RuleScene.getString("RULEFLOWID");
			if(null == sRuleFlowID) sRuleFlowID = "";
			sRuleObjectID = RuleScene.getString("RULEOBJECTID");
			if(null == sRuleObjectID) sRuleObjectID = "";
		}
		RuleScene.close();
		
		//现金贷
		if("020".equals(sProductID))
		{
			sColumn = "Attribute2";//规则返回结果记录表名存储字段（现金贷）
		}
		sResultTable = Sqlca.getString(new SqlObject("select "+sColumn+" from Code_Library where CodeNo = 'RuleDataType' and ItemNo =:DATATYPE").setParameter("DATATYPE", DataType));
		
		if("".equals(sSceneID) || "".equals(sRuleFlowID) || "".equals(sRuleObjectID))
			throw new Exception("场景编号/规则流编号/对象编号不存在,请检查规则引擎配置");
	}
}
