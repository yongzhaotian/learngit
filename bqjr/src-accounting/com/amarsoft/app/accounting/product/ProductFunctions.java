package com.amarsoft.app.accounting.product;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.exception.DataException;

public class ProductFunctions {
	
	public static String getObjectExAttributeValue(BusinessObject businessObject,BusinessObject termObject,String termID,String attributeID) throws Exception{
		String value=termObject.getString(attributeID);
		if(value!=null&&value.length()>0) return value;
		
		value=businessObject.getString(attributeID);
		if(value!=null&&value.length()>0) return value;
		try{
			String productID = businessObject.getString("BusinessType");
			if(productID!=null&&productID.length()>0) {
				String productVersion=businessObject.getString("ProductVersion");
				if(productVersion==null||productVersion.length()==0)
					productVersion=ProductConfig.getProductNewestVersionID(productID);
				
				value = ProductConfig.getProductTermParameterAttribute(productID, productVersion, termID, attributeID, "DefaultValue");
				if(value!=null&&value.length()>0) return value;
				
				value = ProductConfig.getProductTermParameterAttribute(productID, productVersion, termID, attributeID, "ValueList");
				if(value!=null&&value.length()>0) return value;
			}
			
			value = ProductConfig.getTermParameterAttribute(termID, attributeID, "DefaultValue");
			if(value!=null&&value.length()>0) return value;
			
			value = ProductConfig.getTermParameterAttribute(termID, attributeID, "ValueList");
			return value;
		}
		catch(DataException e){
			return "";
		}
		catch(Exception e){
			throw e;
		}
	}
}
