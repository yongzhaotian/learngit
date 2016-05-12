package com.amarsoft.app.accounting.config.loader;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;


public class ProductConfig extends AbstractCache{
	
	private static ASValuePool productLibrary;
	private static ASValuePool termLibrary;
	private static ASValuePool termGroupLibrary;
	private static ASValuePool termTypeSet;
	private static ASValuePool parameterLibrary;
	public static final String ObjectType_PRODUCT="Product";
	public static final String ObjectType_TERM="Term";
	
	public static final String TERM_RELATIONSHIP_Mutex="Mutex";//����
	public static final String TERM_RELATIONSHIP_Bind="Bind";//��
	public static final String TERM_RELATIONSHIP_Inherit="Inherit";//�̳�
	public static final String TERM_RELATIONSHIP_Extends="Extends";//��չ
	public static final String TERM_RELATIONSHIP_SEG="SEG";//����
		
    public static ASValuePool getProductLibrary() {
		return productLibrary;
	}
    
    public static ASValuePool getTermTypeSet() {
		return termTypeSet;
	}
    
    public static ASValuePool getTermLibrary() {
		return termLibrary;
	}
    
    public static ASValuePool getTermGroupLibrary() {
		return termGroupLibrary;
	}
    
    public static ASValuePool getParameterLibrary() {
		return parameterLibrary;
	}
    
    public static String getParameterDefAttribute(String paraID,String attributeID) throws Exception {
    	ASValuePool parameterDef = (ASValuePool)parameterLibrary.getAttribute(paraID);
    	if(parameterDef==null) throw new Exception("��������δ�ҵ�����{"+paraID+"}");
		return parameterDef.getString(attributeID);
	}
    
    /**
   	 * �������ID���ӻ����л�ȡ�����Ϣ
   	 * @param termID
   	 * @param sqlca
   	 * @return
   	 * @throws Exception
   	 */
	public static ASValuePool getTerm(String objectType,String objectNo,String termID) throws Exception{
		ASValuePool term=null;
		if(objectType.equals(ProductConfig.ObjectType_TERM)){
			if(termLibrary==null||termLibrary.isEmpty()) throw new Exception("ҵ�������Ϊ�գ���ȷ���Ƿ���سɹ���");
	       	term = (ASValuePool) termLibrary.getAttribute(termID);
		}
		else{
			if(termGroupLibrary==null||termGroupLibrary.isEmpty()) throw new Exception("ҵ�������Ϊ�գ���ȷ���Ƿ���سɹ���");
			ASValuePool termGroupLibrary_Type = (ASValuePool) termGroupLibrary.getAttribute(objectType);
			if(termGroupLibrary_Type==null||termGroupLibrary_Type.isEmpty()) throw new Exception("�������ͣ�"+objectType+"����ҵ�������Ϊ�գ�");
			ASValuePool termGroupLibrary_No = (ASValuePool) termGroupLibrary_Type.getAttribute(objectNo);
			if(termGroupLibrary_No==null||termGroupLibrary_No.isEmpty()) throw new Exception("�����"+objectType+"   "+objectNo+"����ҵ�������Ϊ�գ�");
			term = (ASValuePool) termGroupLibrary_No.getAttribute(termID);
		}
		if(term==null||term.isEmpty()) {
       		ARE.getLog().error("�����"+objectType+"   "+objectNo+"����ҵ���������δ�ҵ����IDΪ{"+termID+"}�������");
       	}
       	return term;
	}
       
       
       /**
   	 * �������ID���ӻ����л�ȡ�����Ϣ
   	 * @param termID
   	 * @param sqlca
   	 * @return
   	 * @throws Exception
   	 */
	public static ASValuePool getTerm(String termID) throws Exception{
       	return getTerm(ProductConfig.ObjectType_TERM,termID,termID);
	}
       
       /**
   	 * �������ID���ӻ����л�ȡ�����Ϣ
   	 * @param termID
   	 * @param sqlca
   	 * @return
   	 * @throws Exception
   	 */
       public static ASValuePool getTermParameter(String termID,String parameterID) throws Exception{
       	ASValuePool term = getTerm(termID);
       	if(term==null||term.isEmpty()) {
       		throw new Exception("δ�ҵ����{"+termID+"}��");
       	}
       	return getTermParameter(term,parameterID);
       }
       
       /**
   	 * �������ID���ӻ����л�ȡ�����Ϣ
   	 * @param termID
   	 * @param sqlca
   	 * @return
   	 * @throws Exception
   	 */
       public static ASValuePool getTermParameter(ASValuePool term,String parameterID) throws Exception{
       	return (ASValuePool)((ASValuePool) term.getAttribute("TermParameters")).getAttribute(parameterID);
       }
       
       /**
   	 * �������ID���ӻ����л�ȡ�����Ϣ
   	 * @param termID
   	 * @param sqlca
   	 * @return
   	 * @throws Exception
   	 */
     public static String getTermParameterAttribute(ASValuePool term,String parameterID,String parameterAttribute) throws Exception{
	       	ASValuePool parameterDef = (ASValuePool) ProductConfig.parameterLibrary.getAttribute(parameterID);
	   		if(parameterDef==null) throw new DataException("��������δ�ҵ�����{"+parameterID+"}!");
	       	ASValuePool parameter = getTermParameter(term,parameterID);
	       	if(parameter==null) return "";
	       	String value=parameter.getString(parameterAttribute);
	       	if(value==null||value.equals("")){
	       		value = parameterDef.getString(parameterAttribute);
	       	}
	       	return value;
     }
     
     /**
    	 * �������ID���ӻ����л�ȡ�����Ϣ
    	 * @param termID
    	 * @param sqlca
    	 * @return
    	 * @throws Exception
    	 */
      public static String getTermParameterAttribute(String termID,String parameterID,String parameterAttribute) throws Exception{
 	       	return ProductConfig.getTermParameterAttribute(ProductConfig.getTerm(termID),parameterID,parameterAttribute);
      }
       
       /**
   	 * �������ID���ӻ����л�ȡ�����Ϣ
   	 * @param termID
   	 * @param sqlca
   	 * @return
   	 * @throws Exception
   	 */
    public static String getTermAttribute(String termID,String attributeID) throws Exception{
       	ASValuePool term = getTerm(termID);
       	if(term==null||term.isEmpty()) {
       		throw new Exception("δ�ҵ����{"+termID+"}��");
       	}
       	return term.getString(attributeID);
    }
       
    /**
   	 * ����������ͣ��ӻ����л�������Ѷ��������б�
   	 * @param termType
   	 * @return
   	 * @throws Exception
   	 */
   	public static ArrayList<ASValuePool> getTermList(String termType) throws Exception{
   		ArrayList<ASValuePool> termList =new ArrayList<ASValuePool>();
   		ASValuePool termLibrary = ProductConfig.getTermLibrary();
   		if(termLibrary==null) new Exception("δ����ϵͳ������TermSet��������������");
   		ArrayList<String> a = ExtendedFunctions.sortASValuePool(termLibrary, "TermID");
   		for(int i=0;i<a.size();i++){
   			String termID = (String)a.get(i);
   			ASValuePool term = (ASValuePool)termLibrary.getAttribute(termID);
   			String termType_Temp = term.getString("TermType");
   			if(termType.equals(termType_Temp)){
   				termList.add(term);
   			}
   		}
   		return termList;
   	}
   	
   	/**
   	 * ����������ͣ��ӻ����л�������Ѷ��������б�
   	 * @param termType
   	 * @return
   	 * @throws Exception
   	 */
   	public static ArrayList<ASValuePool> getTermList(String objectType,String objectNo,String termType) throws Exception{
   		ArrayList<ASValuePool> termList =new ArrayList<ASValuePool>();
   		ASValuePool termLibrary = null;
   		if(objectType.equals(ProductConfig.ObjectType_TERM)){
			if(ProductConfig.termLibrary==null||ProductConfig.termLibrary.isEmpty()) throw new Exception("ҵ�������Ϊ�գ���ȷ���Ƿ���سɹ���");
			termLibrary = ProductConfig.termLibrary;
		}
		else{
			if(termGroupLibrary==null||termGroupLibrary.isEmpty()) throw new Exception("ҵ�������Ϊ�գ���ȷ���Ƿ���سɹ���");
			ASValuePool termGroupLibrary_Type = (ASValuePool) termGroupLibrary.getAttribute(objectType);
			if(termGroupLibrary_Type==null||termGroupLibrary_Type.isEmpty()) throw new Exception("�������ͣ�"+objectType+"����ҵ�������Ϊ�գ�");
			termLibrary = (ASValuePool) termGroupLibrary_Type.getAttribute(objectNo);
		}
   		
   		if(termLibrary==null||termLibrary.isEmpty()) throw new Exception("�����"+objectType+"   "+objectNo+"����ҵ�������Ϊ�գ�");
   		ArrayList<String> a = ExtendedFunctions.sortASValuePool(termLibrary, "TermID");
   		for(int i=0;i<a.size();i++){
   			String termID = (String)a.get(i);
   			ASValuePool term = (ASValuePool)termLibrary.getAttribute(termID);
   			String termType_Temp = term.getString("TermType");
   			if(termType.equals(termType_Temp)){
   				termList.add(term);
   			}
   		}
   		return termList;
   	}
   	
   	/**
   	 * ����������ͣ��ӻ����л�������Ѷ��������б�
   	 * @param termType
   	 * @return
   	 * @throws Exception
   	 */
   	public static ASValuePool getTermLibrary(String objectType,String objectNo) throws Exception{
   		if(objectType.equals(ProductConfig.ObjectType_TERM)){
			return ProductConfig.termLibrary;
		}
		else{
			if(termGroupLibrary==null||termGroupLibrary.isEmpty()) 
			{
				ARE.getLog().info("ҵ�������Ϊ�գ���ȷ���Ƿ���سɹ���");
				return null;
			}
			else
			{
				ASValuePool termGroupLibrary_Type = (ASValuePool) termGroupLibrary.getAttribute(objectType);
				if(termGroupLibrary_Type==null||termGroupLibrary_Type.isEmpty())
				{
					ARE.getLog().info("�������ͣ�"+objectType+"����ҵ�������Ϊ�գ�");
					return null;
				}
				else
					return (ASValuePool) termGroupLibrary_Type.getAttribute(objectNo);
			}
		}
   	}
   	
   	
   	/**
   	 * ����������ͣ��ӻ����л�������Ѷ��������б�
   	 * @param termType
   	 * @return
   	 * @throws Exception
   	 */
   	public static ASValuePool getProductTermLibrary(String productID,String productVersion) throws Exception{
			return ProductConfig.getTermLibrary(ProductConfig.ObjectType_PRODUCT, productID+"-"+productVersion);
   	}
    
    
    /**
     * ���ز�Ʒ����
     * @param productID
     * @return
     * @throws Exception 
     */
    public static ASValuePool getProductDefinition(String productID) throws Exception {
    	ASValuePool p = (ASValuePool)productLibrary.getAttribute(productID);
    	if(p==null) throw new DataException("δ�ҵ���Ʒ���{"+productID+"}�Ķ�����Ϣ��");
    	return p;
	}
    
    public static String getProductNewestVersionID(String productID) throws Exception {
    	ASValuePool v= (ASValuePool)(ASValuePool)getProductDefinition(productID).getAttribute("VersionSet");
    	if(!v.isEmpty()){
    		ArrayList<String> a = ExtendedFunctions.sortASValuePool(v, "EffDate");
    		for(String versionID:a){
    			if("1".equals(((ASValuePool)v.getAttribute(versionID)).getString("Status")))
    				return versionID;
    		}
    		throw new DataException("δ�ҵ���Ʒ���{"+productID+"}�����°汾��Ϣ��");
    	}
    	else throw new DataException("δ�ҵ���Ʒ���{"+productID+"}�����°汾��Ϣ��");
	}
    
    public static String getProductName(String productID) throws Exception {
    	return (String)getProductDefinition(productID).getAttribute("TypeName");
	}
    
    public static String getTermTypeAttribute(String termType,String attributeID) throws Exception {
    	return ((ASValuePool)termTypeSet.getAttribute(termType)).getString(attributeID);
	}
    /**
     * ���ز�Ʒ����
     * @param productID
     * @param productVersion
     * @return
     * @throws Exception
     */
    public static ASValuePool getProductVersion(String productID,String productVersion) throws Exception {
    	ASValuePool v=(ASValuePool)((ASValuePool)getProductDefinition(productID).getAttribute("VersionSet")).getAttribute(productVersion);
    	if(v==null) throw new DataException("δ�ҵ���Ʒ���Ϊ{"+productID+"}�汾��Ϊ{"+productVersion+"}�Ķ�����Ϣ��");
    	return v;
	}
    
    /**
	 * �������ID����ƷID����汾�ţ���ȡ��Ӧ�������Ϣ
	 * @param productID
	 * @param versionID
	 * @param termID
	 * @return
	 * @throws Exception
	 */
	public static ASValuePool getProductTerm(String productID,String productVersion,String termID) throws Exception{
		return getTerm(ProductConfig.ObjectType_PRODUCT,productID+"-"+productVersion,termID);
	}
	
	/**
	 * �������ID����ƷID����汾�ţ���ȡ��Ӧ�������Ϣ
	 * @param productID
	 * @param versionID
	 * @param termID
	 * @return
	 * @throws Exception
	 */
	public static String getProductTermParameterAttribute(String productID,String productVersion,String termID,String parameterID,String parameterAttribute) throws Exception{
		ASValuePool term=ProductConfig.getProductTerm(productID, productVersion, termID);
		return ProductConfig.getTermParameterAttribute(term, parameterID, parameterAttribute);
	}
	
	/**
	 * �������ID����ƷID����汾�ţ���ȡ��Ӧ���������ֵ
	 * @param productID
	 * @param versionID
	 * @param termID
	 * @param paraID
	 * @return
	 * @throws Exception
	 */
	public static ASValuePool getProductTermParameter(String productID,String versionID,String termID,String paraID) throws Exception{
		ASValuePool term = ProductConfig.getProductTerm(productID, versionID, termID);
		ASValuePool parameterSet = (ASValuePool)term.getAttribute("TermParameters");
		ASValuePool parameter = (ASValuePool)parameterSet.getAttribute(paraID);
		if(parameter==null){
			parameter = ProductConfig.getTermParameter(termID,paraID);
		}
		return parameter;
	}
	
	/**
	 * ����������ͣ��ӻ����л�������Ѷ��������б�
	 * @param termType
	 * @return
	 * @throws Exception
	 */
	public static ArrayList<ASValuePool> getProductTermList(String productID,String productVersion,String termType) throws Exception{
		return ProductConfig.getTermList(ProductConfig.ObjectType_PRODUCT, productID+"-"+productVersion, termType);
	}
	
	/**
	 * ����������ͣ��ӻ����л�������Ѷ��������б�
	 * @param termType
	 * @return
	 * @throws Exception
	 */
	public static List<ASValuePool> getProductTermRelativeList(String productID,String productVersion,String termID,String termRelativeType) throws Exception{
		return ProductConfig.getTermRelativeList(ProductConfig.getProductTerm(productID, productVersion, termID),termRelativeType);
	}
	
	/**
	 * ����������ͣ��ӻ����л�������Ѷ��������б�
	 * @param termType
	 * @return
	 * @throws Exception
	 */
	public static List<ASValuePool> getTermRelativeList(ASValuePool term,String termRelativeType) throws Exception{
		List<ASValuePool> relationShipList = (List<ASValuePool>)term.getAttribute("RelationShipList");
		if(relationShipList==null||relationShipList.isEmpty()) return null;
		
		ArrayList<ASValuePool> r=new ArrayList<ASValuePool>();
		for(ASValuePool a:relationShipList){
			String relativeType_T = a.getString("RelativeType");
			if(termRelativeType.equals(relativeType_T)){
				r.add(a);
			}
		}
		return r;
	}

    
    private void loadTermType(Transaction sqlca) throws Exception{
    	ASValuePool termTypeSet = new ASValuePool();
		String sql = "select * from CODE_LIBRARY where CodeNo='TermType' and IsInUse in ('1')";
		ASResultSet rs = sqlca.getASResultSet2(sql);
		while (rs.next()){
			ASValuePool termType =new ASValuePool();
			String termTypeID=rs.getString("ItemNo");
			termType.setAttribute("TermTypeName", rs.getString("ItemName"));
			termType.setAttribute("MultiFlag", rs.getString("RelativeCode"));
			termType.setAttribute("RelativeObjectType", rs.getString("Attribute2"));
			termType.setAttribute("RelativeAttributeID", rs.getString("Attribute3"));
			termType.setAttribute("GroupTermAttributeID", rs.getString("Attribute4"));
			termType.setAttribute("ListTempletNo", rs.getString("Attribute5"));
			termType.setAttribute("InfoTempletNo", rs.getString("Attribute6"));
			termType.setAttribute("JSFile", rs.getString("ItemAttribute"));

			termTypeSet.setAttribute(termTypeID,termType);
			
		}
		rs.getStatement().close();
		ProductConfig.termTypeSet= termTypeSet;
    }
    
    private void loadParameterLibrary(Transaction sqlca) throws Exception{
    	ASValuePool parameterLibrary = new ASValuePool();
		String sql = "select * from CODE_LIBRARY where CodeNo='TermAttribute' and IsInUse in ('0','1')";
		ASResultSet rs = sqlca.getASResultSet2(sql);
		while (rs.next()){
			ASValuePool parameter =new ASValuePool();
			String parameterID=rs.getString("ItemNo");
			parameter.setAttribute("DEF_ParameterName", rs.getString("ItemName"));
			parameter.setAttribute("DEF_TermType", rs.getString("ItemAttribute"));
			parameter.setAttribute("DEF_TermSetFlag", rs.getString("ItemDescribe"));//�����Ƿ�������������
			parameter.setAttribute("DEF_ValueCode", rs.getString("RelativeCode"));//����Ǵ��룬����ѡ���
			
			parameter.setAttribute("DEF_DataType", rs.getString("BankNo"));//����ͬdatawindow chechformat
			parameter.setAttribute("DEF_HtmlStyle", rs.getString("Attribute2"));//չʾ����ʱ����ʽ����
			
			parameter.setAttribute("DEF_DisplayColumns", rs.getString("Attribute1"));//�������ֵ��ѡ��
			parameter.setAttribute("DEF_RelativeObjectAttribute", rs.getString("Attribute3"));//��������ҵ�����

			parameterLibrary.setAttribute(parameterID,parameter);
			
		}
		rs.getStatement().close();
		ProductConfig.parameterLibrary= parameterLibrary;
    }
    
    /**
     * �����������������
     * @param sqlca
     * @return
     *  ���ؽṹ
     *  1 Term�����������
     *  	1.1 TermID ÿ�����ID�Ĳ���
     *  		1.1.1 ParaID ÿ������ľ���ı���������Ϣ���б�
     * 
     *  2 Product��Ʒ�������
     *  	2.1 ObjectNo=ProductID-Version ÿ����Ʒ�Ͳ�Ʒ�汾����
     *  		2.1.1 TermID ÿ�����ID�Ĳ���
     *  			2.1.1.1 ParaID ÿ������ľ���ı���������Ϣ���б�
     * @throws Exception
     */
    private void loadTerm(Transaction sqlca) throws Exception{
    	
    	ASValuePool termLibrary = new ASValuePool();
    	ASValuePool termGroupLibrary = new ASValuePool();
    	ASValuePool termLibrary_ALL = new ASValuePool();
    	
    	
    	//�������������Ϣ
		String[] termAttributes = { "TermID", "TermName", "TermType","Status", "SetFlag",
				"APermission","PPermission","TermTxt","ObjectType","ObjectNo","BaseTermID","SortNo"};
		
		
		String sql = "select * from PRODUCT_TERM_LIBRARY where Status in ('0','1')";
		ASResultSet rs = sqlca.getASResultSet2(sql);
		while (rs.next()){
			ASValuePool term =new ASValuePool();
			term.setAttribute("TermParameters", new ASValuePool());
			term.setAttribute("RelationShipList", new ArrayList<ASValuePool>());
			String termID=rs.getString("TermID");
			String objectType=rs.getString("ObjectType");
			String objectNo = rs.getString("ObjectNo");
			if(objectType == null) objectType = "";
			if(objectNo == null) objectNo = "";
			for (int i = 0; i < termAttributes.length; i++) {
				String value = rs.getString(termAttributes[i]);
				term.setAttribute(termAttributes[i], value);
			}
			
			termLibrary_ALL.setAttribute(termID+"-"+objectType+"-"+objectNo, term);
			if("Term".equals(objectType)){//�ײ����
				termLibrary.setAttribute(termID, term);
			}
			else{
				ASValuePool termGroup_Type = (ASValuePool)termGroupLibrary.getAttribute(objectType);
				if(termGroup_Type == null){
					termGroup_Type = new ASValuePool();
					termGroupLibrary.setAttribute(objectType, termGroup_Type);
				}
				ASValuePool terGroup_No = (ASValuePool)termGroup_Type.getAttribute(objectNo);
				if(terGroup_No == null){
					terGroup_No = new ASValuePool();
					termGroup_Type.setAttribute(objectNo, terGroup_No);
				}
				terGroup_No.setAttribute(termID, term);
			}
		}
		rs.getStatement().close();
		
		
		//�������
		try{
			String[] parameterAttributes = { "TermID","ParaID", "DataType",
					"ValueList","DefaultValue","MaxValue","MinValue","APermission","PPermission","ParaName","MatchFlag",
					"RefTableName","RefColumnName","ValueCode","SortNo","Status",};
	
			sql = "select * from PRODUCT_TERM_PARA TP where exists(select 1 from PRODUCT_TERM_LIBRARY TL where TP.TermID=TL.TermID and TP.ObjectType=TL.ObjectType and TP.ObjectNo=TL.ObjectNo)";
			rs = sqlca.getASResultSet2(sql); 
			while (rs.next()){
				String termID=rs.getString("TermID");
				String paraID=rs.getString("ParaID");
				String objectType = rs.getString("ObjectType");
				String objectNo = rs.getString("ObjectNo");
				if(objectNo == null) objectNo = "";
				if(objectType == null) objectType = "";
				
				ASValuePool term = (ASValuePool)termLibrary_ALL.getAttribute(termID+"-"+objectType+"-"+objectNo);
				if(term==null) continue;
				ASValuePool parameterSet = (ASValuePool)term.getAttribute("TermParameters");
				ASValuePool parameter =new ASValuePool();
				parameterSet.setAttribute(paraID, parameter);
				for (int i = 0; i < parameterAttributes.length; i++){
					String value = rs.getString(parameterAttributes[i]);
					parameter.setAttribute(parameterAttributes[i], value);
				}
			}
			rs.getStatement().close();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		
		
		//�������
		String[] termRelativeAttributes = {"TermID","RelativeTermID", "RelativeType"};

		sql = "select * from PRODUCT_TERM_RELATIVE where 1=1 order by TermID,RelativeType,RelativeTermID";
		rs = sqlca.getASResultSet2(sql);
		while (rs.next()){
			String termID=rs.getString("TermID");
			String relativeTermID=rs.getString("RelativeTermID");
			String objectNo = rs.getString("ObjectNo");
			String objectType = rs.getString("ObjectType");
			if(objectNo == null) objectNo = "";
			if(objectType == null) objectType = "";
			
			ASValuePool term = (ASValuePool)termLibrary_ALL.getAttribute(termID+"-"+objectType+"-"+objectNo);
			ASValuePool relativeTerm = (ASValuePool)termLibrary_ALL.getAttribute(relativeTermID+"-"+objectType+"-"+objectNo);
			if(term==null) continue;
			if(relativeTerm==null) continue;
			List<ASValuePool> relationShipList = (List<ASValuePool>)term.getAttribute("RelationShipList");
			ASValuePool termRelativeInfo =new ASValuePool();
			for (int i = 0; i < termRelativeAttributes.length; i++){
				String value = rs.getString(termRelativeAttributes[i]);
				termRelativeInfo.setAttribute(termRelativeAttributes[i], value);
			}
			relationShipList.add(termRelativeInfo);
		}
		rs.getStatement().close();
		
		ProductConfig.termLibrary=termLibrary;
		ProductConfig.termGroupLibrary=termGroupLibrary;
    }
    
    private void cleanTerm(Transaction sqlca) throws Exception{
    	String sql="delete from product_term_library tp "+
    			"where (objecttype is null or objecttype<>'Term') and termid not in (select termid from product_term_library tl where tl.objectType='Term')";
    	SqlObject sqlobject = new SqlObject(sql);
    	sqlca.executeSQL(sqlobject);
    	
    	sql="delete from product_term_para tp  "+
    				"where not exists(select 1 from product_term_library tl where tp.termid=tl.termid and tp.objectno=tl.objectno and tp.objecttype=tl.objecttype)";
    	sqlobject = new SqlObject(sql);
    	sqlca.executeSQL(sqlobject);
    	
    	sql="delete from product_term_relative where relativetermid not in (select termid from product_term_library where objecttype='Term')";
		sqlobject = new SqlObject(sql);
		sqlca.executeSQL(sqlobject);
		
		sql="delete from product_term_relative where termid not in (select termid from product_term_library where objecttype='Term')";
		sqlobject = new SqlObject(sql);
		sqlca.executeSQL(sqlobject);
		
		//���ӻ�����������д��ڵ��ǲ�Ʒ����в����ڵĲ���
		sql="insert into product_term_para "
				+ "(TERMID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE,PARANAME,STATUS,"
				+ "MEMO,PPERMISSION,SORTNO,VALUELISTNAME,OBJECTTYPE,OBJECTNO,DISPLAYNAME,MATCHFLAG) "
				+ "select p1.TERMID,p1.PARAID,p1.DATATYPE,p1.VALUELIST,p1.REFTABLENAME,p1.REFCOLUMNNAME,p1.DEFAULTVALUE,p1.MAXVALUE,p1.MINVALUE,"
				+" p1.APERMISSION,p1.VALUECODE,p1.PARANAME,p1.STATUS,p1.MEMO,p1.PPERMISSION,p1.SORTNO,p1.VALUELISTNAME,'Product',l.objectno,p1.DISPLAYNAME,p1.MATCHFLAG "
				+" from product_term_para p1,product_term_library l where p1.termid=l.termid and l.objecttype='Product' and p1.objecttype='Term' "
				+" and p1.paraid not in (select paraid from product_term_para where objecttype='Product' and termid=l.termid and objectno=l.objectno)";
		sqlobject = new SqlObject(sql);
		sqlca.executeSQL(sqlobject);
		//���ݻ��������ʼ����Ʒ����Ĳ���
		sql="update product_term_para ptp set (APERMISSION,PPERMISSION,PARANAME)=(select p.APERMISSION,p.PPERMISSION,p.PARANAME from product_term_para p where p.termid=ptp.termid and p.paraid=ptp.paraid and p.objecttype='Term') "
				+ "where objecttype='Product'";
		sqlobject = new SqlObject(sql);
		sqlca.executeSQL(sqlobject);
		//���ݻ��������ʼ����Ʒ����Ĳ���
		sql="update product_term_para ptp set (VALUELIST,DEFAULTVALUE,MAXVALUE,MINVALUE) "
				+"=(select p.VALUELIST,p.DEFAULTVALUE,p.MAXVALUE,p.MINVALUE from product_term_para p where p.termid=ptp.termid and p.paraid=ptp.paraid and p.objecttype='Term')"
				+" where objecttype='Product' and PPERMISSION in ('ReadOnly','Hide')";
		sqlobject = new SqlObject(sql);
		sqlca.executeSQL(sqlobject);
    }

    /*
	 * ��ջ������
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}

	/*
	 * ���ز�Ʒ����������Ϣ
	 * @see com.amarsoft.dict.als.cache.AbstractCache#load(com.amarsoft.awe.util.Transaction)
	 */
	public synchronized boolean load(Transaction transaction) throws Exception {
		try
		{
			cleanTerm(transaction);
	    	loadTermType(transaction);
	    	loadParameterLibrary(transaction);
	    	loadTerm(transaction);
	    	
	        String attributes[] = {"TypeNo","SortNo","TypeName","IsInUse"};
	        ASValuePool productLibrary = new ASValuePool();
			//��Ʒ�Ļ�����Ϣ
			String sql = "select * from BUSINESS_TYPE where isinuse in ('0','1')";//��������Ч
			ASResultSet rs = transaction.getASResultSet2(sql);
			while (rs.next()) {
				ASValuePool product = new ASValuePool();
				String productID=rs.getString("TypeNo");
				product.setAttribute("VersionSet", new ASValuePool());//���ð汾����
				for (int i = 0; i < attributes.length; i++) {
					String value = rs.getString(attributes[i]);
					product.setAttribute(attributes[i], value);
				}
				productLibrary.setAttribute(productID, product);
			}
			rs.getStatement().close();
			
			//��Ʒ�İ汾��Ϣ
			String[] versionAttributes = {"ProductID", "VersionID", "Status", "EffDate",
					"InvalidationDate","RelativeVersion","ApproveUser"};

			sql = "select * from PRODUCT_VERSION where Status in ('0','1') and ProductID in (select TypeNo from BUSINESS_TYPE where isinuse in ('0','1'))";
			rs = transaction.getASResultSet2(sql);
			while (rs.next()){
				ASValuePool version =new ASValuePool();
				
				String productVersion=rs.getString("VersionID");
				String productID=rs.getString("ProductID");
				
				ASValuePool product = (ASValuePool)productLibrary.getAttribute(productID);
				if(product==null) continue;
				ASValuePool versionSet = (ASValuePool)product.getAttribute("VersionSet");
				versionSet.setAttribute(productVersion, version);
				for (int i = 0; i < versionAttributes.length; i++) {
					String value = rs.getString(versionAttributes[i]);
					version.setAttribute(versionAttributes[i], value);
				}
				
				version.setAttribute("TermSet",ProductConfig.getTermLibrary(ProductConfig.ObjectType_PRODUCT, productID+"-"+productVersion));
			}
			rs.getStatement().close();
			ProductConfig.productLibrary = productLibrary;
	        return true;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
}
