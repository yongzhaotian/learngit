package com.amarsoft.app.accounting.web;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.are.util.ASValuePool;

/**
 * 用于实现显示模板一些个性化功能
 * @author ygwang
 *
 */
public class ProductReport {
	
	public static String genHTML(BusinessObject loan,String termType) throws Exception{
		StringBuffer sb=new StringBuffer();
		String termObjectType=ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
		if(termObjectType==null||termObjectType.length()==0||termObjectType.equals(loan.getObjectType())){
			
			
		}
		
		return sb.toString();
	}
	
	private static String genHTML(BusinessObject termObject,ASValuePool term) throws Exception{
		return "";
	}
}
