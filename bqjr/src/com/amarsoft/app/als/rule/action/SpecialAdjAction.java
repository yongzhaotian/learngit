package com.amarsoft.app.als.rule.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.rule.data.CRScale;
import com.amarsoft.app.als.rule.data.RuleItem;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * 公司客户评级特殊调整项相关操作
 * @author yzhan
 * @since 2011-10-19
 *
 */
public class SpecialAdjAction {
	String ratingAppID = "";
	String itemValues = "";
	String customerID = "";
	String itemNo = "";
	/**
	 * 装载调整项指标
	 */
	public static  List<RuleItem> initRuleItem() throws JBOException{
		List<RuleItem> ruleItems = new ArrayList<RuleItem>();
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		BizObjectQuery bq = bm.createQuery("codeNo='CRSpecialAdjust' order by ItemNo desc");
		List<BizObject> list = bq.getResultList();
 		BizObject bo = null;
		for(int i = 0; i < list.size();i++){
			bo = list.get(i);
			RuleItem ruleItem = new RuleItem();
			ruleItem.setItemID(bo.getAttribute("ItemNo").getString());
			ruleItem.setItemName(bo.getAttribute("ItemName").getString());
			ruleItem.setItemValue(bo.getAttribute("ItemAttribute").getString());
			ruleItems.add(ruleItem);
		}
		return ruleItems;
	}
	
	/**
	 * 测算并保存结果。
	 * @return  评级最终等级
	 */
	public String rating(JBOTransaction tx)throws Exception{
		String finalGrade= this.getBeforeGrade();
		String sMinusItem = "";
		String sLimitItem = "";
		String[] subItemValues=null;
		String upperLimitGrade = "";
		String[] scale = this.getCRScale(customerID);
		String[] sItemValues = this.itemValues.split("@");
		//对该评级指标做保存操作。
		this.saveItemValues(tx);
		//做降级处理
		for(int i =0 ;i<sItemValues.length;i++){
			subItemValues = sItemValues[i].split(":");
			if(sItemValues[i].startsWith("Minus_")){
				if("Y".equals(subItemValues[1])){
					finalGrade = this.scoreSubstract(scale,finalGrade);
					sMinusItem=subItemValues[0];
					break;
				}
			}
		}

		//判断该客户评级的上限等级
		for(int i =0 ;i<sItemValues.length;i++){
			subItemValues = sItemValues[i].split(":");
			if(sItemValues[i].startsWith("Limit_")){
				if(!"N".equals(subItemValues[1])){
					sLimitItem = subItemValues[0];
					upperLimitGrade = subItemValues[1];
					break;
				}
			}
		}
		//根据上限调整该客户的等级。
		finalGrade = this.adjustGrade(scale,finalGrade,upperLimitGrade);
		//保存最终结果。
		this.updateTranResult(tx,finalGrade);
		finalGrade = finalGrade.replace("-","b");
		finalGrade = finalGrade.replace("+", "a");
		return finalGrade+"@"+sMinusItem+"@"+sLimitItem;
	}
	
	public String getBeforeGrade()throws JBOException{
		String grade = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq =  bm.createQuery("ratingAppID=:RatingAppID");
		BizObject bo = bq.setParameter("RatingAppID",this.ratingAppID).getSingleResult();
		if(bo != null){
			grade = bo.getAttribute("Att04").getString();
		}
		return grade;
	}
	
	
	
	
	/**
	 * 将评级结果相应其等级降一个等级
	 * @param scale
	 * @param score
	 * @return
	 */
	private  String scoreSubstract(String[] scale,String grade){
		for(int i = 0 ; i < scale.length;i++ ){
			if(grade.equals(scale[i])){
				if(i < scale.length-1){
					grade = scale[i+1];
					break;
				}
			}
		}
		return grade;
	}
	
	/**
	 * 根据客户评级上限等级和现等级测算最终等级
	 * @param scale 客户所属评级等级标尺
	 * @param finalGrade                             
	 * @param upperLimitGrade 客户等级上限
	 * @return
	 */
	private String adjustGrade(String[] scale,String grade,String upperLimitGrade){
		String[] scaleStandard={"AAA","AA+","AA","AA-","A+","A","A-","BBB+","BBB","BBB-","BB","B"};//标准分类
		int upperLimitGradeIndex = 0;
		int gradeIndex = 0;
		for(int i = 0 ; i < scaleStandard.length ;i++){
			if(grade.equals(scaleStandard[i])){
				gradeIndex = i;
			}
			if(upperLimitGrade.equals(scaleStandard[i])){
				upperLimitGradeIndex = i;
			}
		}
		while(upperLimitGradeIndex > gradeIndex){
			grade = scaleStandard[++gradeIndex];
		}
		return grade;
	}
	/**
	 * 根据CustomerID 获得客户应该选择的评级范围
	 * @return 
	 * 新建企业评级模型标尺：
	 */
	public String[] getCRScale(String customerID)throws JBOException{
		String[] scale = null;
		String setupDate = "";
		String orgNature = "";
		
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID = :CustomerID").setParameter("CustomerID",customerID);
		BizObject bo = bq.getSingleResult();
		if(bo != null){
			setupDate = bo.getAttribute("setupdate").getString();
			orgNature = bo.getAttribute("orgNature").getString();
		}
	
		String today = StringFunction.getToday();
		String setupFlag = "";//企业是否是上年度一月份之前成立，是:Y 否 :N
		today = today.substring(0,4);
		today = (Integer.parseInt(today)-1)+"/01/01";//当前日期前一年
		if(today.compareTo(setupDate)>0)setupFlag="Y";
		else setupFlag = "N";
		if("0101".equals(orgNature)||"0102".equals(orgNature)){
			if("Y".equals(setupFlag))
				scale = CRScale.SCALE_01;
			else 
				scale = CRScale.SCALE_02;
		}else 
			scale=CRScale.SCALE_03;
		
		return scale;
	}
	
	/**
	 * 更新最终评级结果
	 * @return
	 */
	public String  updateTranResult(JBOTransaction jx,String grade)throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		jx.join(bm);
		BizObjectQuery bq = bm.createQuery("RatingAppID=:RatingAppID");
		bq.setParameter("RatingAppID",ratingAppID);
		BizObject bo = bq.getSingleResult();
		if(bo != null){
			String score = bo.getAttribute("att03").getString();
			bo.getAttribute("RATINGGRADE01").setValue(grade);
			bo.getAttribute("RATINGSCORE01").setValue(score);
			bo.getAttribute("UPDATEDATE").setValue(StringFunction.getToday());
			bm.saveObject(bo);
			return "SUCCESS";
		}
		return "FAILURE";
	}
	
	/**
	 * 获得指标信息
	 * @return
	 * @throws JBOException
	 */
	public String getItemAttribute()throws JBOException{
		BizObjectManager bm =JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		BizObjectQuery bq  = bm.createQuery("codeNo='CRSpecialAdjust' and ItemNo=:ItemNo");
		BizObject bo = bq.setParameter("ItemNo",itemNo).getSingleResult();
		if(bo!=null){
			return bo.getAttribute("ItemName").getString()+"@"+bo.getAttribute("ItemAttribute").getString();
		}
		return "";
	}
	
	/**
	 * 判断是否测算调整过。
	 * @return
	 * @throws JBOException
	 */
	public String checkIsSpecialAdjAction()throws JBOException{
		String  modelGrade = null;
		String checkFlag = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq = bm.createQuery("ratingAppID=:ratingAppID");
		BizObject bo = bq.setParameter("ratingAppID",ratingAppID).getSingleResult();
		if(bo != null){
			modelGrade = bo.getAttribute("RatingGrade01").getString();
			if(modelGrade != null && !"".equals(modelGrade))
				return "Yes";
			else
				return "No";
		}
		return "No";
	}
	
	/**
	 *保存指标结果
	 * @throws Exception
	 */
	public void saveItemValues(JBOTransaction tx)throws Exception{
		String modRecordID = "";
		String newItem = this.itemValues;
		newItem = newItem.replace(":","=");
		newItem = newItem.replace("@", ";");
		BizObjectManager  bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq = bm.createQuery("RatingAppID=:RatingAppID");
		BizObject bo = bq.setParameter("RatingAppID",this.ratingAppID).getSingleResult();
		if(bo != null){
			modRecordID = bo.getAttribute("RATINGMODRECORDID").getString();
			BizObjectManager bm1 = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
			tx.join(bm1);
			BizObjectQuery bq1 = bm1.createQuery("RULEMODRECORDID=:modRecordID").setParameter("modRecordID",modRecordID);
			BizObject bo1 = bq1.getSingleResult();
			if(bo1 != null){
				bo1.setAttributeValue("BomTextIN03",newItem);
				bm1.saveObject(bo1);
			}
		}
	}
	
	
	/**
	 * 评级调整页面完成按钮
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public String complete(JBOTransaction tx)throws JBOException{
		String sReturn = "";
		String[] scale = this.getCRScale(customerID);
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("RatingAppID=:RatingAppID");
		bq.setParameter("RatingAppID",ratingAppID);
		BizObject bo = bq.getSingleResult();
		if(bo != null){
			String score = bo.getAttribute("att03").getString();
			String grade  = bo.getAttribute("att04").getString();
			String customerID = bo.getAttribute("CustomerID").getString();
			boolean  registerCapitalFlag =SpecialAdjData.getRegisterCapitalFlag(customerID);
			boolean  totalAssetFlag = SpecialAdjData.getTotalAssetsFlag(customerID);
			if(registerCapitalFlag){
				grade = this.adjustGrade(scale,grade,"A+");
				sReturn ="Limit_04@"+grade;
				//对返回值做格式验证
				sReturn = sReturn.replace("+","a");
				sReturn = sReturn.replace("-","b");
			}else if(totalAssetFlag){
				grade = this.adjustGrade(scale,grade,"AA+");
				sReturn ="Limit_01@"+grade;
				//对返回值做格式验证
				sReturn = sReturn.replace("+","a");
				sReturn = sReturn.replace("-","b");
			}
			bo.getAttribute("RATINGGRADE01").setValue(grade);
			bo.getAttribute("RATINGSCORE01").setValue(score);
			bo.getAttribute("UPDATEDATE").setValue(StringFunction.getToday());
			bm.saveObject(bo);
			if(!"".equals(sReturn))
				return sReturn;
			else
				return "SUCCESS@"+grade;
		}
		return "FAILURE";
	}
	
	public static String itemValues(String ratingAppID)throws JBOException{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObjectQuery bq = bm.createQuery("RatingAppID='"+ratingAppID+"'");
		BizObject bo = bq.getSingleResult();
		String modRecordID = bo.getAttribute("ratingModRecordID").getString();
		BizObjectManager bm1 = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
		BizObjectQuery bq1 = bm1.createQuery("ruleModRecordID='"+modRecordID+"'");
		BizObject bo2 = bq1.getSingleResult();
		return bo2.getAttribute("BomTextIn03").getString();
	}

	public String getRatingAppID() {
		return ratingAppID;
	}

	public void setRatingAppID(String ratingAppID) {
		this.ratingAppID = ratingAppID;
	}

	public String getItemValues() {
		return itemValues;
	}

	public void setItemValues(String itemValues) {
		itemValues=itemValues.replaceAll("a","+");
		itemValues=itemValues.replaceAll("b", "-");
		this.itemValues = itemValues;
	}
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}
}
