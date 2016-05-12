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
 * ��˾�ͻ����������������ز���
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
	 * װ�ص�����ָ��
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
	 * ���㲢��������
	 * @return  �������յȼ�
	 */
	public String rating(JBOTransaction tx)throws Exception{
		String finalGrade= this.getBeforeGrade();
		String sMinusItem = "";
		String sLimitItem = "";
		String[] subItemValues=null;
		String upperLimitGrade = "";
		String[] scale = this.getCRScale(customerID);
		String[] sItemValues = this.itemValues.split("@");
		//�Ը�����ָ�������������
		this.saveItemValues(tx);
		//����������
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

		//�жϸÿͻ����������޵ȼ�
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
		//�������޵����ÿͻ��ĵȼ���
		finalGrade = this.adjustGrade(scale,finalGrade,upperLimitGrade);
		//�������ս����
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
	 * �����������Ӧ��ȼ���һ���ȼ�
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
	 * ���ݿͻ��������޵ȼ����ֵȼ��������յȼ�
	 * @param scale �ͻ����������ȼ����
	 * @param finalGrade                             
	 * @param upperLimitGrade �ͻ��ȼ�����
	 * @return
	 */
	private String adjustGrade(String[] scale,String grade,String upperLimitGrade){
		String[] scaleStandard={"AAA","AA+","AA","AA-","A+","A","A-","BBB+","BBB","BBB-","BB","B"};//��׼����
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
	 * ����CustomerID ��ÿͻ�Ӧ��ѡ���������Χ
	 * @return 
	 * �½���ҵ����ģ�ͱ�ߣ�
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
		String setupFlag = "";//��ҵ�Ƿ��������һ�·�֮ǰ��������:Y �� :N
		today = today.substring(0,4);
		today = (Integer.parseInt(today)-1)+"/01/01";//��ǰ����ǰһ��
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
	 * ���������������
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
	 * ���ָ����Ϣ
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
	 * �ж��Ƿ�����������
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
	 *����ָ����
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
	 * ��������ҳ����ɰ�ť
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
				//�Է���ֵ����ʽ��֤
				sReturn = sReturn.replace("+","a");
				sReturn = sReturn.replace("-","b");
			}else if(totalAssetFlag){
				grade = this.adjustGrade(scale,grade,"AA+");
				sReturn ="Limit_01@"+grade;
				//�Է���ֵ����ʽ��֤
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
