package com.amarsoft.app.accounting.businessobject;


public interface IBusinessObjectLoader {
	public BusinessObject loadBusinessObject(String objectType,String objectNo,AbstractBusinessObjectManager bom)throws Exception;
}
