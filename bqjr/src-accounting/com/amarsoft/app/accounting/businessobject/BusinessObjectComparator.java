package com.amarsoft.app.accounting.businessobject;

import java.util.Comparator;


public class BusinessObjectComparator implements Comparator<BusinessObject> {

	public String attributeID;
	public String dataType;
	public int sortIndicator;
	public static final int  sortIndicator_asc = 1;
	public static final int  sortIndicator_desc = 2;
	
	public int compare(BusinessObject bo1,BusinessObject bo2){
		
		try {
			if(dataType.equals(BUSINESSOBJECT_CONSTATNTS.TYPE_STRING)){
				if(!bo1.getString(attributeID).equals(bo2.getString(attributeID))){
					if(sortIndicator==sortIndicator_desc)
						return -bo1.getString(attributeID).compareTo(bo2.getString(attributeID));
					else 
						return bo1.getString(attributeID).compareTo(bo2.getString(attributeID));
				}
			}else if(dataType.equals(BUSINESSOBJECT_CONSTATNTS.TYPE_INTGER)){
				if(bo1.getInt(attributeID) <= bo2.getInt(attributeID)){
					if(sortIndicator==sortIndicator_desc)
						return -(bo1.getInt(attributeID) - bo2.getInt(attributeID));
					else 
						return (bo1.getInt(attributeID) - bo2.getInt(attributeID));
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
			/*if(!bo1.getAttribute(attributeID).equals(bo2.getString(attributeID))){
				if(sortIndicator==sortIndicator_desc)
					return -bo1.getString(attributeID).compareTo(bo2.getString(attributeID));
				else 
					return bo1.getString(attributeID).compareTo(bo2.getString(attributeID));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;*/
	}
	
}
