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
 *      jli5    2015-4-21  ����5:48:48 �ع��������ӵ��ù���������־ģ��  
 */
public class DefaultService {
	
	private String ItemName = "";//ǰ������׼����
	private String ItemDescribe = "";//ǰ������׼��������
	private String GetDataType = "";//ǰ������׼��ȡ������
	private String GetFunction = "";//ǰ������׼��ȡ������
	private String RuleenGineparaName = "";//ǰ������׼����Ӧ�ֶ�
	private String TableName = "";//����
	private String Fieldcode = "";//�ֶ���
	private String ReturnValue = "";
	private ASResultSet RuleRs = null;
	private ASResultSet RuleRq = null;
	private HashMap map = null;
	private String sObjectNo = "";
	private String sObjectType = "";
	private String sAllCont = "";
	private String sAllValues = "";
	
	private ASResultSet RuleScene = null;//����������Ϣ
	private String sProductID = "";//��Ʒ����
	private String sSceneID = "";//�������
	private String sRuleFlowID = "";//������
	private String sRuleObjectID = "";//������
	private String sResultTable = "";//���򷵻���Ϣ��¼�����
	
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
		
		//�������������ͬ��ˮ��
//		ARE.getLog().info("������������׼����ʼ��ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		Calendar rightNow = Calendar.getInstance();
		String BEGINTIME1 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
		//ǰ������׼��
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
			ARE.getLog().info("��SQLȡ���ķ�����"+GetFunction);
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
						ARE.getLog().info("SQLִ�н����"+ReturnValue);
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
				ARE.getLog().info("�������SQLִ�н����"+ReturnValue);
				jObject = setNodeValue(jObject, RuleenGineparaName,ReturnValue);
			}
			
		}
		RuleRs.getStatement().close();
		jObject = setNodeValue(jObject, sSceneID+"."+sRuleObjectID+".Kind", "InOut");
//		ARE.getLog().info("������������׼��������ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		rightNow = Calendar.getInstance();
	    String ENDTIME1 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
		
	    rightNow = Calendar.getInstance();
        String BEGINTIME2 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
        
//		ARE.getLog().info("����������ÿ�ʼ��ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		String calcResult = RuleConnectionService.callRule(sSceneID, "RuleFlow", sRuleFlowID, jObject.toString(), "{}");
//		ARE.getLog().info("����������ý�����ObjectNo="+sObjectNo+",ObjectType="+sObjectType);
		rightNow = Calendar.getInstance();
	    String ENDTIME2 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 
	        
		InsertRuleRunLog.insertLog(BEGINTIME1, ENDTIME1, BEGINTIME2, ENDTIME2, Sqlca, sObjectNo, "First");
		
		
		ResultObject resultObject = new ResultObject(calcResult);
//		System.out.println("����ѡ��:" + resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".workflowCode", ""));
		
		sSql = "select Ruleengineparaname from PREPAREDATE_INFO where SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			String sName = RuleRs.getString("Ruleengineparaname");
            if("".equals(sName)  ||  sName.split("\\.").length<3){
                throw new Exception("����׼������Ruleengineparaname�����ϱ�׼");
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
		//update CCS-761 ���Ѵ������ύʱ���ù�������ʧ�ܵĴ���(һ������A/B�����ĳ��������¸���1���κ�һ����ͬ���ã��������ֽ���������Ѵ�)ʱ��������ؽ��Ϊ������Ҫ����ͬ�š�����ʱ�䱣����Pre_DATA���У��ֱ�洢��PRE_Data��idcredit��updatetime���ֶ��С�)
		String TableSerialNo = DBKeyHelp.getSerialNo(sResultTable,"SerialNo",Sqlca);
		sAllValues = "'"+TableSerialNo+"',"+sAllValues;
		ARE.getLog().info("�ֶ�����"+sAllCont+"\r\nֵ��"+sAllValues);
		
		//��Ʒ���ͣ�020-�ֽ����030-���Ѵ���
		String sProductID = Sqlca.getString(new SqlObject("select ProductID from Business_Contract where SerialNo = :SerialNo").setParameter("SerialNo", sObjectNo));
		if(null == sProductID) sProductID = "";
		ARE.getLog().info("��Ʒ����:"+sProductID);
		
		//�������淵�ؽ��
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
//		System.out.println("ִ�е�SQL��"+sSql);
		Sqlca.executeSQL(new SqlObject(sSql));
//		System.out.println(calcResult);

		return resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".workflowCode", "");
	}
	
	/**
	 * ��ȥ����׼��
	 */
	public String getAfteResult(Transaction Sqlca) throws Exception{
	    String sDate = DateX.format(new Date()); 
		JSONObject jObject = null;
		String sSql = "";
		//�������������ͬ��ˮ��
		String sMaxContractNo = "";
		Calendar rightNow = Calendar.getInstance();
	    String BEGINTIME1 = sDate +" "+Time.valueOf(String.valueOf(rightNow.get(Calendar.HOUR)) + ":" + String.valueOf(rightNow.get(Calendar.MINUTE)) + ":" + String.valueOf(rightNow.get(Calendar.SECOND)))+":"+String.valueOf(rightNow.get(Calendar.MILLISECOND)); 

		//ǰ������׼��
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
					System.out.println(RuleenGineparaName+"�ֶν����"+Fieldcode);
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
					System.out.println(RuleenGineparaName+"�ֶν����"+Fieldcode);
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
					System.out.println(RuleenGineparaName+"�ֶν����"+Fieldcode);
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
				System.out.println("��SQLȡ���ķ�����"+GetFunction);
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
				System.out.println("�������SQLִ�н����"+ReturnValue);
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
//		System.out.println("����ѡ��:" + resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".PostWorkflowCode", ""));
		
		sSql = "select Ruleengineparaname from AFTERDATA_INFO where SceneID =:SceneID ";
		RuleRs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SceneID", sSceneID));
		while(RuleRs.next()){
			String sName = RuleRs.getString("Ruleengineparaname");
            if("".equals(sName)  ||  sName.split("\\.").length<3){
                throw new Exception("����׼������Ruleengineparaname�����ϱ�׼");
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
//		System.out.println("�ֶ�����"+sAllCont+"\r\nֵ��"+sAllValues);
		sSql = "INSERT INTO "+sResultTable+"("+sAllCont+") "+
				" VALUES("+sAllValues+")";
//		System.out.println("ִ�е�SQL��"+sSql);
		Sqlca.executeSQL(new SqlObject(sSql));
//		System.out.println(calcResult);
		return resultObject.getResult("OBJECTS."+sSceneID+"."+sRuleObjectID+".PostWorkflowCode", "");
	}
	
	
    /**
     * �ѽڵ����ƺ�ֵƴװ��JSON����
     *
     * @param   jObject  ԭJSON����
     * @param   ID       �ڵ�����
     * @param   value    �ڵ�ֵ
     * @return  ��JSON����
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
     * ��ȡJSON������ĳ���ڵ��ֵ
     *
     * @param   jObject  JSON����
     * @param   ID       �ڵ�����
     * @param   defaultvalue Ĭ��ֵ
     * @return  �ڵ�ֵ
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
     * ��ȡ��Ʒ���Ͷ�Ӧ�ĳ�����š�����ģ�ͱ�š��������Լ����򷵻ؽ���ļ�¼�����
     *
     * @param   ProductID  ������Ϣ�еĲ�Ʒ����
     * @param   APPTYPE    ����������Ϣά����ѡ���Ӧ�ò�Ʒ����
     * @param   DATATYPE   ����׼�����ͣ�01:ǰ������׼��;02:��������׼��;03:��������׼����
     * @param   SCENEID    �������
     * @param   RULEFLOWID ����ģ�ͱ��
     */
	public void getRuleSceneInfo(Transaction Sqlca,String DataType) throws Exception{
		String sColumn = "Attribute1";//���򷵻ؽ����¼�����洢�ֶΣ�Ĭ�����Ѵ���
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
		
		//�ֽ��
		if("020".equals(sProductID))
		{
			sColumn = "Attribute2";//���򷵻ؽ����¼�����洢�ֶΣ��ֽ����
		}
		sResultTable = Sqlca.getString(new SqlObject("select "+sColumn+" from Code_Library where CodeNo = 'RuleDataType' and ItemNo =:DATATYPE").setParameter("DATATYPE", DataType));
		
		if("".equals(sSceneID) || "".equals(sRuleFlowID) || "".equals(sRuleObjectID))
			throw new Exception("�������/���������/�����Ų�����,���������������");
	}
}
