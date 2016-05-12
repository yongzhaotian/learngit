package com.amarsoft.app.als.rule.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;


/**
 * 获得应用系统中与规则引擎相关对象的对应值
 * @author zszhang
 *
 */
public class GetCorrelativeValue {

	private String serialNo;
	private String modelID;
	
	public String getValue() throws JBOException{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		List boList = null;
		String itemName = null;
		String tableName = null;
		String keyWord = null;
		String selectWord = null;
		String itemValue = null;
		String returnValue = "";
		String customerID = null;
		
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		bq = bm.createQuery("RatingAppID = :serialNo");
		bq.setParameter("serialNo", serialNo);
		bo = bq.getSingleResult();
		if (bo != null) {
			customerID = bo.getAttribute("CustomerID").getString();
		}else{
			bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
			bq = bm.createQuery("RatingAppID = :serialNo");
			bq.setParameter("serialNo", serialNo.substring(2));
			bo = bq.getSingleResult();
			customerID = bo.getAttribute("CustomerID").getString();
		}
		
		bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		bq = bm.createQuery("CodeNo = :modelID");
		bq.setParameter("modelID", modelID);
		boList = bq.getResultList();
		if(boList.size()!=0){
			for(int i=0;i<boList.size();i++){
				itemName = modelID+"."+((BizObject)boList.get(i)).getAttribute("ItemNo").getString();
				tableName = ((BizObject)boList.get(i)).getAttribute("ItemAttribute").getString();
				selectWord = ((BizObject)boList.get(i)).getAttribute("Attribute1").getString();
				keyWord = ((BizObject)boList.get(i)).getAttribute("Attribute2").getString();
				
				bm = JBOFactory.getFactory().getManager(tableName);
				bq = bm.createQuery(keyWord+" =:keyWord");
				bq.setParameter("keyWord", customerID);
				bo = bq.getSingleResult();
				if(bo!=null)itemValue = bo.getAttribute(selectWord).getString().substring(0,4);
				returnValue = returnValue+";"+itemName+"="+itemValue;
			}
		}
		if(!"".equals(returnValue))returnValue=returnValue.substring(1);
		//System.out.println("----CorrelativeValue----"+returnValue);
		return returnValue;
	}
	
	public String getAppointedValue(String customerID,String itemID) throws JBOException{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String tableName = null;
		String keyWord = null;
		String selectWord = null;
		String itemValue = null;
		String modelID = null;
		String bomID = null;
		String returnValue = "";
		
		modelID = itemID.split("\\.")[0];
		bomID = itemID.split("\\.")[1]+"."+itemID.split("\\.")[2];
		
		bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		bq = bm.createQuery("CodeNo = :modelID and itemNo = :bomID");
		bq.setParameter("modelID", modelID);
		bq.setParameter("bomID", bomID);
		bo = bq.getSingleResult();
		if(bo!=null){
				tableName = bo.getAttribute("ItemAttribute").getString();
				selectWord = bo.getAttribute("Attribute1").getString();
				keyWord = bo.getAttribute("Attribute2").getString();
				
				bm = JBOFactory.getFactory().getManager(tableName);
				bq = bm.createQuery(keyWord+" =:keyWord");
				bq.setParameter("keyWord", customerID);
				bo = bq.getSingleResult();
				if(bo!=null)itemValue = bo.getAttribute(selectWord).getString();
				returnValue = itemValue;
		}
		//System.out.println("----CorrelativeValue----"+returnValue);
		return returnValue;
	}
	
	public String getRatingInfo() throws JBOException{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		List boList = null;
		String itemName = null;
		String tableName = null;
		String keyWord = null;
		String selectWord = null;
		String itemValue = null;
		String returnValue = "";
		String customerID = null;
		String order = null;
		
		bm = JBOFactory.getFactory().getManager("jbo.app.CLASSIFY_APPLY");
		bq = bm.createQuery("ClassifyAppID = :serialNo");
		bq.setParameter("serialNo", serialNo);
		bo = bq.getSingleResult();
		if(bo!=null)customerID = bo.getAttribute("CustomerID").getString();
		
		bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		bq = bm.createQuery("CodeNo = :modelID");
		bq.setParameter("modelID", modelID);
		boList = bq.getResultList();
		if(boList.size()!=0){
			for(int i=0;i<boList.size();i++){
				itemName = modelID+"."+((BizObject)boList.get(i)).getAttribute("ItemNo").getString();
				tableName = ((BizObject)boList.get(i)).getAttribute("ItemAttribute").getString();
				selectWord = ((BizObject)boList.get(i)).getAttribute("Attribute1").getString();
				keyWord = ((BizObject)boList.get(i)).getAttribute("Attribute2").getString();
				order = ((BizObject)boList.get(i)).getAttribute("Attribute3").getString();
				
				bm = JBOFactory.getFactory().getManager(tableName);
				bq = bm.createQuery(keyWord+" =:keyWord "+order);
				bq.setParameter("keyWord", customerID);
				bo = bq.getSingleResult();
				if(bo!=null)itemValue = bo.getAttribute(selectWord).getString();
				returnValue = returnValue+";"+itemName+"="+itemValue;
			}
		}
		if(!"".equals(returnValue))returnValue=returnValue.substring(1);
		//System.out.println("----CorrelativeValue----"+returnValue);
		return returnValue;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public void setModelID(String modelID) {
		this.modelID = modelID;
	}
}
