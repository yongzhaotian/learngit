/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.app.als.sadre.widget;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.misc.DescElement;
import com.amarsoft.sadre.app.misc.impl.DimensionDescribe;
import com.amarsoft.sadre.app.misc.impl.FlowDescribe;
import com.amarsoft.sadre.app.misc.impl.ImplementDescribe;
import com.amarsoft.sadre.app.misc.impl.NullDescribe;
import com.amarsoft.sadre.app.misc.impl.OrgDescribe;
import com.amarsoft.sadre.app.misc.impl.RefRuleDescribe;
import com.amarsoft.sadre.app.misc.impl.RoleDescribe;
import com.amarsoft.sadre.app.misc.impl.RuleConfDescribe;
import com.amarsoft.sadre.app.misc.impl.SceneDimensionDescribe;
import com.amarsoft.sadre.app.misc.impl.UserDescribe;

 /**
 * <p>Title: Describes.java </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 ÏÂÎç1:47:47
 *
 * logs: 1. 
 */
public class Describes {
	public static DescElement getElement(String type, Transaction to){
		DescElement de = null;
		if(type==null||type.trim().length()==0){
			de = new NullDescribe();
		}else if(type.equalsIgnoreCase("ROLE")){
			de = new RoleDescribe(to);
		}else if(type.equalsIgnoreCase("USER")){
			de = new UserDescribe(to);
		}else if(type.equalsIgnoreCase("ORG")){
			de = new OrgDescribe(to);
		}else if(type.equalsIgnoreCase("DIMENSION")){
			de = new DimensionDescribe(to);
		}else if(type.equalsIgnoreCase("FLOW")){
			de = new FlowDescribe(to);
		}else if(type.equalsIgnoreCase("RULECONF")){
			de = new RuleConfDescribe(to);
		}else if(type.equalsIgnoreCase("REFRULE")){
			de = new RefRuleDescribe(to);
		}else if(type.equalsIgnoreCase("IMPL")){
			de = new ImplementDescribe(to);
		}else if(type.equalsIgnoreCase("SCENEDIMENSION")){
			de = new SceneDimensionDescribe(to);
		}else if(type.equalsIgnoreCase("DYNAMICUSER")){
			de = new DynamicUserDescribe(to);
		}else if(type.equalsIgnoreCase("DYNAMICROLE")){
			de = new DynamicRoleDescribe(to);
		}
		
		return de;
	}
	
	public static String getDescribe(String type,String ids, Transaction to){
		return getElement(type, to).getDescribe(ids);
	}
	
	public static String getOutline(String type,String ids, Transaction to){
		return getElement(type, to).getOutline(ids);
	}
}
