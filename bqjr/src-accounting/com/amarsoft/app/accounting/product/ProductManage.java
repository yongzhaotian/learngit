package com.amarsoft.app.accounting.product;

import java.lang.reflect.Method;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.BusinessObjectComparator;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class ProductManage extends Bizlet {
	private AbstractBusinessObjectManager bomanager ;
	
	public ProductManage(){
		
	}
	
	public ProductManage(Transaction sqlca) throws JBOException, SQLException{
		bomanager=new DefaultBusinessObjectManager(sqlca);
	}
	
	public ProductManage(AbstractBusinessObjectManager bomanager){
		this.bomanager=bomanager;
	}
	
	public AbstractBusinessObjectManager getBomanager() {
		return bomanager;
	}
	
	//��ӻ������
	public String addExclusiveRelative() throws Exception{
			String TermID = DataConvert.toString((String) this.getAttribute("TermID"));
			String returnValue = DataConvert.toString((String) this.getAttribute("RelativeTermID"));
			String RelativeType = DataConvert.toString((String) this.getAttribute("Method"));
			if("addExclusiveRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Mutex;//����
			if("addBindRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Bind;//��
			String ObjectNo = DataConvert.toString((String) this.getAttribute("ObjectNo"));
			String ObjectType = DataConvert.toString((String) this.getAttribute("ObjectType"));
			String[] relativeTermIDs = returnValue.split("@");
			for(String RelativeTermID:relativeTermIDs)
			{
			
				//�������
				String sql1 = "insert into PRODUCT_TERM_RELATIVE " +
							"(TermID,RELATIVETERMID,RELATIVETYPE,ObjectNo,ObjectType) values(" +
							":TermID,:RelativeTermID,:RelativeType,:ObjectNo,:ObjectType)";
				bomanager.getSqlca().executeSQL(new SqlObject(sql1).setParameter("TermID", TermID).setParameter("RelativeTermID", RelativeTermID).setParameter("RelativeType", RelativeType).setParameter("ObjectNo", ObjectNo).setParameter("ObjectType", ObjectType));
				
				String sql2 = "insert into PRODUCT_TERM_RELATIVE " +
							"(TermID,RELATIVETERMID,RELATIVETYPE,ObjectNo,ObjectType) values(" +
							":RelativeTermID,:TermID,:RelativeType,:ObjectNo,:ObjectType)";
				bomanager.getSqlca().executeSQL(new SqlObject(sql2).setParameter("RelativeTermID", RelativeTermID).setParameter("TermID", TermID).setParameter("RelativeType", RelativeType).setParameter("ObjectNo", RelativeTermID).setParameter("ObjectType", ObjectType));
			}
			return "success";
		}
		//��Ӱ����
		public String addBindRelative() throws Exception{
			String TermID = DataConvert.toString((String) this.getAttribute("TermID"));
			String returnValue = DataConvert.toString((String) this.getAttribute("RelativeTermID"));
			String RelativeType = DataConvert.toString((String) this.getAttribute("Method"));
			if("addExclusiveRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Mutex;//����
			if("addBindRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Bind;//��
			String ObjectNo = DataConvert.toString((String) this.getAttribute("ObjectNo"));
			String ObjectType = DataConvert.toString((String) this.getAttribute("ObjectType"));
			String[] relativeTermIDs = returnValue.split("@");
			for(String RelativeTermID:relativeTermIDs)
			{
			
				//�������
				String sql1 = "insert into PRODUCT_TERM_RELATIVE " +
							"(TermID,RELATIVETERMID,RELATIVETYPE,ObjectNo,ObjectType) values(" +
							":TermID,:RelativeTermID,:RelativeType,:ObjectNo,:ObjectType)";
				bomanager.getSqlca().executeSQL(new SqlObject(sql1).setParameter("TermID", TermID).setParameter("RelativeTermID", RelativeTermID).setParameter("RelativeType", RelativeType).setParameter("ObjectNo", ObjectNo).setParameter("ObjectType", ObjectType));
				
				String sql2 = "insert into PRODUCT_TERM_RELATIVE " +
							"(TermID,RELATIVETERMID,RELATIVETYPE,ObjectNo,ObjectType) values(" +
							":RelativeTermID,:TermID,:RelativeType,:ObjectNo,:ObjectType)";
				bomanager.getSqlca().executeSQL(new SqlObject(sql2).setParameter("RelativeTermID", RelativeTermID).setParameter("TermID", TermID).setParameter("RelativeType", RelativeType).setParameter("ObjectNo", RelativeTermID).setParameter("ObjectType", ObjectType));
			}
			return "success";
		}
		//ɾ���������
		public String deleteRelative() throws Exception{
			String TermID = DataConvert.toString((String) this.getAttribute("TermID"));
			String RelativeTermID = DataConvert.toString((String) this.getAttribute("RelativeTermID"));	
			
			String sql1 = "delete from  PRODUCT_TERM_RELATIVE " +
						"where termID=:TermID and RelativeTermID=:RelativeTermID"; 
			bomanager.getSqlca().executeSQL(new SqlObject(sql1).setParameter("TermID", TermID).setParameter("RelativeTermID", RelativeTermID));
			
			String sql2 = "delete from  PRODUCT_TERM_RELATIVE " +
						"where termID=:RelativeTermID and RelativeTermID=:TermID"; 
			bomanager.getSqlca().executeSQL(new SqlObject(sql2).setParameter("RelativeTermID", RelativeTermID).setParameter("TermID", TermID));
			
			return "success";
		}
	
	/**
	 * �����Ѿ�������������Ʒ��
	 * @return
	 * @throws Exception
	 */
	public String importTermToProduct() throws Exception{
		String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		String productID = DataConvert.toString((String) this.getAttribute("ProductID"));
		String versionID = DataConvert.toString((String) this.getAttribute("VersionID"));
		String parentTermID = DataConvert.toString((String) this.getAttribute("ParentTermID"));
		
		String ObjectNo = productID+"-"+versionID;
		
		this.deleteTermFromProduct();//ɾ��ԭ�й���

		//�������
		String sql = "insert into PRODUCT_TERM_PARA " +
				"( ObjectType,ObjectNo,TERMID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE,PARANAME,STATUS," +
				"INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG) " +
				"select 'Product','"+ObjectNo+"',TermID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE," +
				" PARANAME,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG from PRODUCT_TERM_PARA " +
				" where ObjectType='Term' and ObjectNo = :termID and TermID like :termID1";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID).setParameter("termID1", termID+"%"));
		
		sql = "insert into PRODUCT_TERM_LIBRARY " +
				"(OBJECTTYPE,OBJECTNO,TERMID,TERMNAME,TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO,BASETERMID) " +
				" select 'Product','"+ObjectNo+"',TermID,TermName,TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO,BASETERMID" +
				" from PRODUCT_TERM_LIBRARY " +
				" where ObjectType='Term' and ObjectNo = :termID and TermID like :termID1";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID).setParameter("termID1", termID+"%"));
		
		ASValuePool parameter = new ASValuePool();
		parameter.setAttribute("ObjectType", "Term");
		parameter.setAttribute("ObjectNo", termID);
		parameter.setAttribute("TermID", termID);
		
		String binding = "";
		String mutex = "";
		List<BusinessObject> ptr = bomanager.loadBusinessObjects("jbo.app.PRODUCT_TERM_RELATIVE", "ObjectType=:ObjectType and ObjectNo = :ObjectNo and TermID = :TermID", parameter);
		for(BusinessObject p:ptr)
		{
			String relativeType = p.getString("RelativeType");
			if(ProductConfig.TERM_RELATIONSHIP_Bind.equals(relativeType))
			{
				String relativeTermID = p.getString("RelativeTermID");
				if(relativeTermID.equals(parentTermID)) continue;
				ProductManage pm = new ProductManage(bomanager.getSqlca());
				pm.setAttribute("Method", "importTermToProduct");
				pm.setAttribute("ProductID", productID);
				pm.setAttribute("VersionID", versionID);
				pm.setAttribute("TermID", relativeTermID);
				pm.setAttribute("ParentTermID", termID);
				String s = (String)pm.run(bomanager.getSqlca());
				if(s != null && !"@".equals(s))
				{
					binding += s.split("@")[0];
					mutex += s.split("@")[1];
				}
				binding += relativeTermID+"#";
			}
			else if(ProductConfig.TERM_RELATIONSHIP_Mutex.equals(relativeType))
			{
				String relativeTermID = p.getString("RelativeTermID");
				ProductManage pm = new ProductManage(bomanager.getSqlca());
				pm.setAttribute("Method", "deleteTermFromProduct");
				pm.setAttribute("ProductID", productID);
				pm.setAttribute("VersionID", versionID);
				pm.setAttribute("TermID", relativeTermID);
				pm.run(bomanager.getSqlca());
				mutex += relativeTermID+"#";
			}
		}
		
		sql = "insert into PRODUCT_TERM_RELATIVE " +
		"( ObjectType,ObjectNo,TERMID,RELATIVETERMID,RELATIVETYPE) " +
		" select 'Product','"+ObjectNo+"',TermID,RELATIVETERMID,RELATIVETYPE" +
		" from PRODUCT_TERM_RELATIVE " +
		" where ObjectType='Term' and ObjectNo = :termID and TermID=:termID";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID).setParameter("ObjectNo", ObjectNo));
		
		return binding+"@"+mutex;
	}
	
	public String deleteTermFromProduct() throws Exception{
		String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		String productID = DataConvert.toString((String) this.getAttribute("ProductID"));
		String versionID = DataConvert.toString((String) this.getAttribute("VersionID"));
		String ObjectNo = productID+"-"+versionID;
		//ɾ��֮ǰ���������,�����޷�����
		String sql="delete from PRODUCT_TERM_PARA where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		
		//ɾ���������
		sql="delete from PRODUCT_TERM_LIBRARY where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		
		//ɾ���������
		sql="delete from PRODUCT_TERM_RELATIVE where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		return "success";
	}

	/**
	 * ��ѡ�еĲ������帴�Ƶ�����������
	 * @return
	 * @throws Exception
	 */
	/*public String importTermParameters() throws Exception{
		String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		//String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		String parameters = DataConvert.toString((String) this.getAttribute("ParameterID"));
		parameters = StringFunction.replace(parameters, "@", "','");
		parameters="'"+parameters+"'";
		
		
		String deleteSql="delete from PRODUCT_TERM_PARA where TermID = :termID and ParaID in  ("+parameters+")";
		bomanager.getSqlca().executeSQL(new SqlObject(deleteSql).setParameter("termID", termID));//ɾ��֮ǰ���������Ĳ���
		
		String insertSql="insert into PRODUCT_TERM_PARA(ObjectType,ObjectNo,TermID,ParaID,ParaName,DataType,Status,SortNo) " +
				" select 'Term',:termID, :termID,ItemNo,ItemName,BankNo,'1',SortNo "+
				" from Code_Library where CodeNo = 'TermAttribute' and ItemNo in  ("+parameters+")";
		bomanager.getSqlca().executeSQL(new SqlObject(insertSql).setParameter("termID", termID));
		return "success";
	}*/

	/**
	 * ��ѡ�еĲ������帴�Ƶ�����������
	 * @return
	 * @throws Exception
	 */
	public String importTermParameters2() throws Exception{
		String objectNo = DataConvert.toString((String) this.getAttribute("ObjectNo"));
		String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		String parameters = DataConvert.toString((String) this.getAttribute("ParameterID"));
		parameters = StringFunction.replace(parameters, "@", "','");
		parameters="'"+parameters+"'";
		
		String deleteSql="delete from PRODUCT_TERM_PARA where TermID = :termID and ParaID in  ("+parameters+")";
		bomanager.getSqlca().executeSQL(new SqlObject(deleteSql).setParameter("termID", termID));//ɾ��֮ǰ���������Ĳ���
		
		String insertSql="insert into PRODUCT_TERM_PARA(ObjectType,ObjectNo,TermID,ParaID,ParaName,DataType,Status,SortNo) " +
				" select 'Term','"+objectNo+"', '"+termID+"',ItemNo,ItemName,BankNo,'1',SortNo "+
				" from Code_Library where CodeNo = 'TermAttribute' and ItemNo in  ("+parameters+")";
		bomanager.getSqlca().executeSQL(new SqlObject(insertSql).setParameter("objectNo", objectNo).setParameter("termID", termID));
		return "success";
	}
	
	/**
	 * ����һ����Ʒ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String createProduct() throws Exception{
		String productID=(String)this.getAttribute("ProductID");//��Ʒ���
		String versionID=(String)this.getAttribute("VersionID");//�汾��
		String userID=(String)this.getAttribute("UserID");//�û����
		
		String sql = "delete from PRODUCT_VERSION where ProductID=:productID and VersionID=:versionID";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("productID", productID).setParameter("versionID", versionID));
		
		sql = "insert into PRODUCT_VERSION (ProductID,VersionID,Status,InputUser,InputTime) " +
				"values(:productID,:versionID,'3',:userID,:InputTime)";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("productID", productID).setParameter("versionID", versionID).setParameter("userID", userID).setParameter("InputTime", SystemConfig.getSystemDate()));
		return "1";
	}
	
	/**
	 * ����һ����Ʒ�汾
	 * @return
	 * @throws Exception
	 */
	public String copyProduct() throws Exception{
		String productID=(String)this.getAttribute("ProductID");//��Ʒ���
		String newProductID=(String)this.getAttribute("NewProductID");//��Ʒ���
		String versionID=(String)this.getAttribute("VersionID");//�汾���
		String newVersionID=(String)this.getAttribute("NewVersionID");//�汾���
		String userID=(String)this.getAttribute("UserID");//�û����
		
		String newObjectNo = newProductID+"-"+newVersionID;
		String ObjectNo = productID+"-"+versionID;
		
		String sql = "insert into PRODUCT_TERM_PARA " +
				"( ObjectType,ObjectNo,TERMID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE,PARANAME,STATUS," +
				"INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG) " +
				"select ObjectType,'"+newObjectNo+"',TERMID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE," +
				" PARANAME,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG from PRODUCT_TERM_PARA " +
				" where ObjectNo=:ObjectNo and ObjectType='Product'";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("newObjectNo", newObjectNo).setParameter("ObjectNo", ObjectNo));
		sql = "insert into PRODUCT_TERM_LIBRARY " +
				"(OBJECTTYPE,OBJECTNO,TERMID,TERMNAME,TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO) " +
				"select 'Product','"+newObjectNo+"',TERMID,TERMNAME,TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO" +
				" from PRODUCT_TERM_LIBRARY  " +
				" where ObjectNo=:ObjectNo and ObjectType='Product'";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("newObjectNo", newObjectNo).setParameter("ObjectNo", ObjectNo));

		sql = "insert into PRODUCT_TERM_RELATIVE " +
				"( ObjectType,ObjectNo,TERMID,RELATIVETERMID,RELATIVETYPE) " +
				"select 'Product','"+newObjectNo+"',TERMID,RELATIVETERMID,RELATIVETYPE " +
				" from PRODUCT_TERM_RELATIVE  " +
				" where ObjectNo=:ObjectNo and ObjectType='Product'";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("newObjectNo", newObjectNo).setParameter("ObjectNo", ObjectNo));
		
		if(productID.equals(newProductID)){
			sql = "insert into PRODUCT_VERSION (ProductID,VersionID,Status,InputUser,InputTime) " +
					"values(:productID,:newVersionID,'3',:userID,:InputTime)";
			bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("productID", productID).setParameter("newVersionID", newVersionID).setParameter("userID", userID).setParameter("InputTime", SystemConfig.getSystemDate()));
		}else{
			sql = "insert into PRODUCT_VERSION " +
					"(PRODUCTID,VERSIONID,ISNEW,STATUS,INPUTUSER,INPUTORG,INPUTTIME) " +
					"values(:newProductID,:newVersionID,'1','2',:userID,'',:INPUTTIME)";
			bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("newProductID", newProductID).setParameter("newVersionID", newVersionID).setParameter("userID", userID).setParameter("INPUTTIME",  SystemConfig.getSystemDate()));
		}	
		return "1";
	}
	
	/**
	 * ����һ�����
	 * @return
	 * @throws Exception
	 */
	public String copyTerm() throws Exception{
		String termID=(String)this.getAttribute("TermID");//������
		String newTermID=(String)this.getAttribute("NewTermID");//�ϼ�������
		String newTermName=(String)this.getAttribute("NewTermName");//�ϼ�������
		
		String sql = "insert into PRODUCT_TERM_PARA " +
				"( ObjectType,ObjectNo,TERMID,PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE,PARANAME,STATUS," +
				"INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG) " +
				"select ObjectType,'"+newTermID+"','"+newTermID+"',PARAID,DATATYPE,VALUELIST,REFTABLENAME,REFCOLUMNNAME,DEFAULTVALUE,MAXVALUE,MINVALUE,APERMISSION,VALUECODE," +
				" PARANAME,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PPERMISSION,SORTNO,VALUELISTNAME,MATCHFLAG from PRODUCT_TERM_PARA " +
				" where TermID=:termID and ObjectType='Term'";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("newTermID", newTermID).setParameter("termID", termID));
		sql = "insert into PRODUCT_TERM_LIBRARY " +
				"(OBJECTTYPE,OBJECTNO,TERMID,TERMNAME,TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO) " +
				"select 'Term','"+newTermID+"','"+newTermID+"','"+newTermName+"',TERMTYPE,SETFLAG,PPERMISSION,APERMISSION,TERMTXT,STATUS,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,REMARK,SORTNO" +
				" from PRODUCT_TERM_LIBRARY  where TermID=:termID and ObjectType='Term'";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("newTermID", newTermID).setParameter("newTermName", newTermName).setParameter("termID", termID));

		return "1";
	}

	public Object run(Transaction Sqlca) throws Exception {
		try
		{
			bomanager = new DefaultBusinessObjectManager(Sqlca);
			String methodName = (String)this.getAttribute("Method");//��������
			Method method = this.getClass().getMethod(methodName, new Class[]{});
			
			Object result = method.invoke(this, new Object[]{});
			this.bomanager.updateDB();
		return result;
		}catch (Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
	
	/**
	 * ��֪��Ʒ��š��汾�ź������ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BA�д��ڵ���Ϣ���������´���
	 * @return
	 * @throws Exception
	 */
	public void checkObjectWithProduct() throws Exception{
		String termID = (String) this.getAttribute("TermID");
		String objectType = (String) this.getAttribute("ObjectType");
		String objectNo = (String) this.getAttribute("ObjectNo");
		BusinessObject businessObject = bomanager.loadObjectWithKey(objectType, objectNo);
		if(termID==null||termID.length()==0){
			this.checkBusinessObject(businessObject);
		}
		else{
			this.checkBusinessObject(termID,businessObject);
		}
	}
	
	/**
	 * ��֪��Ʒ��źͰ汾�ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BA�д��ڵ���Ϣ���������´���
	 * @return
	 * @throws Exception
	 */
	public void initObjectWithProduct() throws Exception{
		String termID = (String) this.getAttribute("TermID");
		String objectType = (String) this.getAttribute("ObjectType");
		String objectNo = (String) this.getAttribute("ObjectNo");
		BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(objectType, objectNo, this.bomanager.getSqlca());
		if(termID==null||termID.length()==0){
			this.createTermObject(businessObject);
		}
		else{
			this.createTermObject(termID,businessObject);
		}
		this.bomanager.updateDB();
	}
		
	/**
	 * ��֪��Ʒ��źͰ汾�ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص������Ϣ 
	 *  2.��ÿ��������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 *  4.���ڴ��ڵĽ���update ҵ�����
	 * @return
	 * @throws Exception
	 */
	public void initBusinessObject(BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		ASValuePool termLibrary =ProductConfig.getProductTermLibrary(productID, productVersion);//ȡ��ȫ�����������Ϣ
		
		//�Զ��������������ͬʱ�����Ѿ�ѡ�е�������г�ʼ��
		Object[] keys=termLibrary.getKeys();
		for(int i=0;i<keys.length;i++){
			String termID=(String)keys[i];
			ASValuePool term = (ASValuePool)termLibrary.getAttribute(termID);
			this.initBusinessObject(term, businessObject);
		}
	}
	
	
	/**
	 * ��֪��Ʒ��š��汾�ź������ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص�������Ϣ 
	 *  2.��ÿ���������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 *  4.���ڴ��ڵĽ���update business_apply 
	 * @return
	 * @throws Exception
	 */
	public void initBusinessObject(String termID,BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, termID);
		if(term==null) term = ProductConfig.getTerm(termID);
		this.initBusinessObject(term, businessObject);
	}
	

	/**
	 * ��֪��Ʒ��š��汾�ź������ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص�������Ϣ 
	 *  2.��ÿ���������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 *  4.���ڴ��ڵĽ���update business_apply 
	 * @return
	 * @throws Exception
	 */
	public void initBusinessObject(ASValuePool term,BusinessObject businessObject) throws Exception{
		String termType= term.getString("TermType");//�õ�������
		String termID= term.getString("TermID");//�õ�������
		String setFlag= term.getString("SetFlag");//�õ��������
		String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
		//����Ѿ������˴�������򲻴����������ֶ�ʼ�¼��������ID�����˱䶯����ɾ��ԭ��������������µ����
		if(termID.equals(businessObject.getString(groupTermIDColName))) return;
		
		//�����µ������¼
		if(setFlag.equals("SET")){//������
			List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("δ�ҵ�������{"+termID+"}�����������ȷ����������Ƿ���ȷ��");
			
			for(ASValuePool termRelationShip:termRelativeList){
				ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
				initBusinessObject(relativeTerm, businessObject);//�˴��ݹ����
			}
		}
		else if(setFlag.equals("BAS")||setFlag.equals("SEG")){//��һ���
			String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
			if(termObjectType.indexOf(businessObject.getObjectType())>=0){
				this.initTermObject(businessObject, term);
			}
			else{
				List<BusinessObject> list = this.getTermObjectList2(businessObject, termID);
				if(list==null||list.isEmpty()) return;
				for(BusinessObject a:list){
					if(setFlag.equals("SEG")){
						String segNo=term.getString("SEGNo");
						int segNo_T = a.getInt("SEGNo");
						try{
							if(segNo_T==Integer.parseInt(segNo)){
								this.initTermObject(a, term);
							}
							else continue;
						}
						catch(Exception e){
							continue;
						}
					}
					else{
						this.initTermObject(a, term);
					}
				}
			}
		}
	}
	
	public void initTermObject(BusinessObject termObject,ASValuePool term) throws Exception{
		
		
		ASValuePool paraSet = (ASValuePool)term.getAttribute("TermParameters");// �õ�����Ĳ�����
		Object[] para_keys=paraSet.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para��ParaID
			ASValuePool paramter = (ASValuePool)paraSet.getAttribute(paraID);
			String defaultValue = paramter.getString("DefaultValue");//ֵ
			String aPermission = paramter.getString("APermission");
			
			if((defaultValue == null || "".equals(defaultValue)) && ("Hide".equals(aPermission) || "ReadOnly".equals(aPermission)))
				defaultValue = paramter.getString("ValueList");
			if(defaultValue==null||defaultValue.length()==0) continue;
			
			String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//�ֶι�����������
			String[] ars = refAttributeID.split(",");
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) continue;
				if(ars[n].startsWith(termObject.getObjectType())){//������������ڵ�ǰҵ�����ʱ
					String objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
					String objectAttributeValue = DataConvert.toString(termObject.getString(objectAttributeID));
					if(objectAttributeValue==null||"".equals(objectAttributeValue)){
						termObject.setAttributeValue(objectAttributeID, defaultValue);
						break;
					}
				}
			}
		}
	}
	
	/**
	 * ��֪��Ʒ��źͰ汾�ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص������Ϣ 
	 *  2.��ÿ��������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 *  4.���ڴ��ڵĽ���update ҵ�����
	 * @return
	 * @throws Exception
	 */
 	public List<BusinessObject> createTermObject(BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		ASValuePool termLibrary =ProductConfig.getProductTermLibrary(productID, productVersion);
		
		ArrayList<BusinessObject> list=new ArrayList<BusinessObject>();
		//�Զ��������������ͬʱ�����Ѿ�ѡ�е�������г�ʼ��
		Object[] keys=termLibrary.getKeys();
		for(int i=0;i<keys.length;i++){
			String termID=(String)keys[i];
			ASValuePool term = (ASValuePool)termLibrary.getAttribute(termID);
			//�Զ���������ҵ�����
			ASValuePool paraSet = (ASValuePool)term.getAttribute("TermParameters");// �õ�����Ĳ�����
			//ȡ����Ե�ǰ�����Ȩ��Ҫ��,������Ǳ��룬��ֱ������
			boolean objectPermission=false;//Ĭ�ϴ�������ǵ�ǰ��������
			ASValuePool accountPermissionPara = (ASValuePool)paraSet.getAttribute("APermission");//�õ�����Ƿ�����ʶ
			if(accountPermissionPara!=null){
				String s = accountPermissionPara.getString("DefaultValue");//ֵ
				if(s==null||s.length()==0||!s.equals("1")) objectPermission=false;
				else objectPermission=true;
			}
			if(!objectPermission) continue;
			
			if(matchBasicTerm(term,businessObject)){
				List<BusinessObject> termObjectList = createTermObject(termID, businessObject);
				if(termObjectList!=null)
					list.addAll(termObjectList);
			}
		}
		//Ȼ���ʼ���Ѿ�ѡ�е����
		this.initBusinessObject(businessObject);
		return list;
	}
	
	
	/**
	 * ��֪��Ʒ��š��汾�ź������ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص�������Ϣ 
	 *  2.��ÿ���������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 *  4.���ڴ��ڵĽ���update business_apply 
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> createTermObject(ASValuePool term,BusinessObject businessObject) throws Exception{
		String termType= term.getString("TermType");//�õ�������
		String termID= term.getString("TermID");//�õ�������
		String setFlag= term.getString("SetFlag");//�õ��������
		String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
		String relativeAttributeID=ProductConfig.getTermTypeAttribute(termType, "RelativeAttributeID");
		String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
		if(termObjectType==null||termObjectType.length()==0)termObjectType=businessObject.getObjectType();
		//����ǵ�ѡ���
		if(groupTermIDColName!=null&&groupTermIDColName.length()>0&&(setFlag.equals("BAS")||setFlag.equals("SET"))){//����ֶε������ʱ����ɾ��
			if(termID.equals(businessObject.getString(groupTermIDColName))) return null;//����Ѿ������˴�������򲻴���
			//����ʹ���µ��������ԭ�������
			businessObject.setAttributeValue(groupTermIDColName, termID);
			bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, businessObject);//����
			
			List<BusinessObject> relativeObjectList =this.getTermObjectList(businessObject, termType);
			if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
				for(BusinessObject n:relativeObjectList){
					//�����⣬���޷�ɾ��ͬ�������ԭ���Ƿֶ�ʱ�����ID��û�и�ֵ�������ע�͵������ڽ��
					//if(termID.equals(n.getString(relativeAttributeID))){//ͬһ�����ɾ��
					if("0".equals(n.getString("Status")))
					{
						businessObject.removeRelativeObject(n);
						bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete, n);
					}
					//}
				}
			}
		}
		
		List<BusinessObject> list=new ArrayList<BusinessObject>();
		//�����µ������¼
		if(setFlag.equals("SET")){//������
			List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("δ�ҵ�������{"+termID+"}�����������ȷ����������Ƿ���ȷ��");
			
			for(ASValuePool termRelationShip:termRelativeList){
				ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
				List<BusinessObject> termObject = this.createTermObject(relativeTerm, businessObject);//�˴��ݹ����
				list.addAll(termObject);
			}
		}
		else if(setFlag.equals("BAS")||setFlag.equals("SEG")){//��һ���
			BusinessObject termObject = null;
			if(termObjectType.indexOf(businessObject.getObjectType())>=0)
				termObject=businessObject;
			else{
				termObject=new BusinessObject(termObjectType,bomanager);
				termObject.setAttributeValue(relativeAttributeID, termID);
				termObject.setAttributeValue("Status", "0");
				termObject.setAttributeValue("ObjectType", businessObject.getObjectType());
				termObject.setAttributeValue("ObjectNo", businessObject.getObjectNo());
				bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, termObject);//����
				list.add(termObject);
			}
			
			ASValuePool paraSet = (ASValuePool)term.getAttribute("TermParameters");// �õ�����Ĳ�����
			Object[] para_keys=paraSet.getKeys();
			for(int k=0;k<para_keys.length;k++){
				String paraID = (String)para_keys[k];//term_para��ParaID
				ASValuePool paramter = (ASValuePool)paraSet.getAttribute(paraID);
				String defaultValue = paramter.getString("DefaultValue");//ֵ
				String aPermission = paramter.getString("APermission");
				
				if((defaultValue == null || "".equals(defaultValue)) && ("Hide".equals(aPermission) || "ReadOnly".equals(aPermission)))
					defaultValue = paramter.getString("ValueList");
				if(defaultValue==null||defaultValue.length()==0) continue;

				String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//�ֶι�����������
				String[] ars = refAttributeID.split(",");
				for(int n=0;n<ars.length;n++){
					if(ars[n]==null || "".equals(ars[n])) continue;
					if(ars[n].startsWith(termObject.getObjectType())){//������������ڵ�ǰҵ�����ʱ
						String objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
						String objectAttributeValue = termObject.getString(objectAttributeID);
						
						if(objectAttributeValue==null||"".equals(objectAttributeValue)){
							termObject.setAttributeValue(objectAttributeID, defaultValue);
							break;
						}
					}
				}
			}
		}
		if(list!=null) businessObject.setRelativeObjects(list);
		return list;
	}

	/**
	 * ��֪��Ʒ��š��汾�ź������ţ�����Ʒ����Ĳ�����������Ӧ������
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص�������Ϣ 
	 *  2.��ÿ���������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 *  4.���ڴ��ڵĽ���update business_apply 
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> createTermObject(String termID,BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, termID);
		if(term==null) term = ProductConfig.getTerm(termID);
		return this.createTermObject(term, businessObject);
	}
	
	/**
	 * ��֪��Ʒ��źͰ汾�ţ����ݲ�Ʒ����Ĳ���У��ҵ�����
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص�������Ϣ 
	 *  2.��ÿ���������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 * @return
	 * @throws Exception
	 */
	public ASValuePool checkBusinessObject(BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		
		ASValuePool result = new ASValuePool();
		ASValuePool termLibrary = ProductConfig.getProductTermLibrary(productID, productVersion);//ȡ��ȫ�����������Ϣ

		for(Object key:termLibrary.getKeys()){
			String termID=(String)key;
			ASValuePool term = (ASValuePool)termLibrary.getAttribute(termID);
			if(term==null) continue;
			
			if(matchBasicTerm(term,businessObject)){
				ASValuePool resultTemp = this.checkBusinessObject(businessObject, term);
				if(resultTemp != null)
					result.uniteFromValuePool(resultTemp);
			}
		}
		return result;
	}
	/**
	 * ����������Ƿ��붨��ƥ��
	 * @param term
	 * @param businessObject
	 * @return
	 * @throws Exception
	 */
	private boolean matchBasicTerm(ASValuePool term,BusinessObject businessObject) throws Exception{
		String termType= term.getString("TermType");//�õ�������
		String termID= term.getString("TermID");//�õ�������
		String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
		if(groupTermIDColName!=null&&groupTermIDColName.length()>0){
			String termID_T=businessObject.getString(groupTermIDColName);
			if(termID.equals(termID_T)) return true;
		}
		
		
		ASValuePool termPara = (ASValuePool)term.getAttribute("TermParameters");//�õ��������
		Object[] para_keys=termPara.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para��ParaID
			ASValuePool paramter = (ASValuePool)termPara.getAttribute(paraID);
			
			String valueList = paramter.getString("ValueList");
			String defaultValue = paramter.getString("DefaultValue");
			String matchFlag = paramter.getString("MatchFlag");//ƥ���־
			if(!matchFlag.equals("1")) continue;
			
			String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//�ֶι�����������
			String[] ars = refAttributeID.split(",");
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) continue;
				
				if(!ars[n].startsWith(businessObject.getObjectType())) continue;//���������������ҵ�����ʱ
				
				String objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
				String objectAttributeValue = businessObject.getString(objectAttributeID);
				
				if(objectAttributeValue==null||objectAttributeValue.length()==0) continue;
				if(valueList.indexOf(objectAttributeValue)>=0||objectAttributeValue.equals(defaultValue)){
					continue;
				}
				else{
					return false;//�����һ��ƥ�䲻�ϣ����˳�
				}
			}
		}
		return true;
	}
	
	private ASValuePool checkBusinessObject(BusinessObject businessObject,ASValuePool term,BusinessObject termObject) throws Exception{
		ASValuePool compareStr = new ASValuePool();//���治һ�µĽ��
		String termName= term.getString("TermName");
		String sPutMesTitle = "������Ϣ��";
		if((BUSINESSOBJECT_CONSTATNTS.business_approve).equals(businessObject.getObjectType()))sPutMesTitle = "������Ϣ��";
		if((BUSINESSOBJECT_CONSTATNTS.business_contract).equals(businessObject.getObjectType()))sPutMesTitle = "��ͬ��Ϣ��";
		ASValuePool termPara = (ASValuePool)term.getAttribute("TermParameters");//�õ��������
		Object[] para_keys=termPara.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para��ParaID
			ASValuePool paramter = (ASValuePool)termPara.getAttribute(paraID);
			String paraName= paramter.getString("ParaName");
			String maxValue = paramter.getString("MaxValue");
			String minValue = paramter.getString("MinValue");
			String valueList = paramter.getString("ValueList");

			String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//�ֶι�����������
			String[] ars = refAttributeID.split(",");//��Ҫ����ΪBA��BAP��BC��BP��ԭ��
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) continue;
				String objectAttributeID;
				String objectAttributeValue;
				
				if(ars[n].startsWith(businessObject.getObjectType())){//���������������ҵ�����ʱ
					objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
					objectAttributeValue = businessObject.getString(objectAttributeID);
				}
				else if(ars[n].startsWith(termObject.getObjectType())){//������������ڸ���ҵ�����ʱ
					objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
					objectAttributeValue = termObject.getString(objectAttributeID);
				}
				else continue;//������ʱ������У�飬Ӧ�ò������������
				
				//����ValueList
				if(valueList!=null&&valueList.length()>0){
					if(objectAttributeValue == null || "".equals(objectAttributeValue))
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"��"+paraName+"����ֵ���ڲ�Ʒ�����"+termName+"���Ĳ����޶���Χ�ڣ�");//��"+objectAttributeValue+"��
					else if(valueList.indexOf(objectAttributeValue)<0){
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"��"+paraName+"����ֵ���ڲ�Ʒ�����"+termName+"���Ĳ����޶���Χ�ڣ�");//��"+objectAttributeValue+"��
					}
				}
				
				if(objectAttributeValue==null||objectAttributeValue.length()==0) continue;
				if(maxValue!=null&&maxValue.length()>0){
					if(DataConvert.toDouble(objectAttributeValue)>DataConvert.toDouble(maxValue)){
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"��"+paraName+"��-��"+objectAttributeValue+"�����ڲ�Ʒ�����"+termName+"���ж������ֵ��"+DataConvert.toDouble(maxValue)+"����");
					}
				}
				//����Ʒ�������Ҫ��Ϊ�ռ�δ���壬��У��
				if(minValue!=null&&minValue.length()>0){
					if(DataConvert.toDouble(objectAttributeValue)<DataConvert.toDouble(minValue)){
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"��"+paraName+"��-��"+objectAttributeValue+"��С�ڲ�Ʒ�����"+termName+"���ж�����Сֵ��"+DataConvert.toDouble(minValue)+"����");
					}
				}
			}
		}
		return compareStr;
	}
	
	/**
	 * ��֪��Ʒ��źͰ汾�ţ����ݲ�Ʒ����Ĳ���У��ҵ�����
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص�������Ϣ 
	 *  2.��ÿ���������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 * @return
	 * @throws Exception
	 */
	public ASValuePool checkBusinessObject(BusinessObject businessObject,ASValuePool term) throws Exception{
		String setFlag= term.getString("SetFlag");//�õ��������
		String termName= term.getString("TermName");
		String termID= term.getString("TermID");
		String termType = term.getString("TermType");
		//�˴����˱����У���߼�������������������������������������
		ASValuePool checkResult = new ASValuePool();//���治һ�µĽ��
		
		String termObjectType = ProductConfig.getTermTypeAttribute(termType,"RelativeObjectType");//�����������
		if(termObjectType==null||termObjectType.length()==0) 
			termObjectType=businessObject.getObjectType();
		String termIDAttributeName = ProductConfig.getTermTypeAttribute(termType,"RelativeAttributeID");//�����������

		if(setFlag.equals("SET")){//������
			List<BusinessObject> termObjectList = this.getTermObjectList(businessObject, termType);
			if(termObjectList==null||termObjectList.isEmpty())//�˴���ҪУ��ֶ����Ƿ�һ�£��Ƿ���޸ĵȹ���Ŀǰû��ʵ��
				return null;
			List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("δ�ҵ�������{"+termName+"}�����������ȷ����������Ƿ���ȷ��");
			
			for(BusinessObject termObject:termObjectList){
				String termID_T = termObject.getString(termIDAttributeName);
				if(!termID.equals(termID_T)) continue;//���ܲ��ǵ�ǰ���ID�ģ������
				int segNo = termObject.getInt("SegNo");
				for(ASValuePool termRelationShip:termRelativeList){
					ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
					int termSegNo = 0;
					try{
						termSegNo = Integer.valueOf(relativeTerm.getString("SEGNo"));
					}
					catch(Exception e){
						continue;
					}
					if(segNo==termSegNo){
						checkResult.uniteFromValuePool(checkBusinessObject(businessObject,relativeTerm,termObject));
					}
				}
			}
		}
		else if(setFlag.equals("BAS") || setFlag.equals("SEG")){//��һ���
			if(termObjectType.indexOf(businessObject.getObjectType())>=0) {
				checkResult.uniteFromValuePool(checkBusinessObject(businessObject,term,businessObject));
			}
			else{
				List<BusinessObject> termObjectList = this.getTermObjectList(businessObject, termType);
				if(termObjectList==null||termObjectList.isEmpty())//�˴���ҪУ��ֶ����Ƿ�һ�£��Ƿ���޸ĵȹ���Ŀǰû��ʵ��
					return null;
				
				for(BusinessObject a:termObjectList){
					if(termID.equals(a.getString(termIDAttributeName)))
						checkResult.uniteFromValuePool(checkBusinessObject(businessObject,term,a));
				}
			}
		}
		else throw new Exception("��Ч��������ͣ�ֻ������ΪBAS��SET��SEG������ɱ����룡");
		return checkResult;
	}
	
	/**
	 * ��֪��Ʒ��š��汾�ź������ţ����ݲ�Ʒ����Ĳ���У��ҵ�����
	 * ��������BusinessObject�д��ڵ���Ϣ
	 *  1.�ҵ���Ӧ��Ʒ��ص�������Ϣ 
	 *  2.��ÿ���������µ��ֶν���У�飬�Ƿ������codeno='TermAttribute' and attribute3 like '%ObjectType%'�� 
	 *  3.ÿ��typeno��Ӧ���term_library,ÿ��term_library��Ӧ���term_para,ÿ��term_paraȥ����Ƿ�����codeno=termattribute�кϹ� 
	 * @return
	 * @throws Exception
	 */
	public ASValuePool checkBusinessObject(String termID,BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, termID);
		return checkBusinessObject(businessObject, term);
	}
	
	
	
	public List<BusinessObject> getTermObjectList(BusinessObject businessObject,String termType) throws Exception{
		String termObjectType = ProductConfig.getTermTypeAttribute(termType,"RelativeObjectType");//�����������
		String termIDAttribute = ProductConfig.getTermTypeAttribute(termType,"RelativeAttributeID");//�����������
		List<BusinessObject> termObjectList = businessObject.getRelativeObjects(termObjectType);
		
		if(termObjectType==null||termObjectType.length()==0||termObjectType.indexOf(businessObject.getObjectType())>=0)
			return null;
		if(termObjectList==null||termObjectList.isEmpty()){//���Ϊ�գ����Դ����ݿ��м��أ���������Ϊ�˱�֤��ѯ��ʵ�ʴ���¼��ʱʹ��ͳһ������Ϊ��ʱ�������
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", businessObject.getObjectNo());
			as.setAttribute("ObjectType",businessObject.getObjectType());
			termObjectList = bomanager.loadBusinessObjects(termObjectType, " ObjectNo = :ObjectNo and ObjectType = :ObjectType",as);//���ʶ���
		}

		ArrayList<BusinessObject> list=new ArrayList<BusinessObject>();
		for(BusinessObject termObject:termObjectList){
			String termID_T=termObject.getString(termIDAttribute);
			if(termID_T==null||termID_T.length()==0) continue;
			
			if(termType.equals(ProductConfig.getTermAttribute(termID_T, "TermType"))){
				list.add(termObject);
			}
		}
		return list;
	}
	
	public List<BusinessObject> getTermObjectList2(BusinessObject businessObject,String termID) throws Exception{
		String termType = ProductConfig.getTermAttribute(termID, "TermType");
		String termObjectType = ProductConfig.getTermTypeAttribute(termType,"RelativeObjectType");//�����������
		String termIDAttribute = ProductConfig.getTermTypeAttribute(termType,"RelativeAttributeID");//�����������
		List<BusinessObject> termObjectList = businessObject.getRelativeObjects(termObjectType);

		if(termObjectType==null||termObjectType.length()==0||termObjectType.indexOf(businessObject.getObjectType())>=0)
			return null;
		if(termObjectList==null||termObjectList.isEmpty()){//���Ϊ�գ����Դ����ݿ��м��أ���������Ϊ�˱�֤��ѯ��ʵ�ʴ���¼��ʱʹ��ͳһ������Ϊ��ʱ�������
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", businessObject.getObjectNo());
			as.setAttribute("ObjectType",businessObject.getObjectType());
			termObjectList = bomanager.loadBusinessObjects(termObjectType, " ObjectNo = :ObjectNo and ObjectType = :ObjectType",as);//���ʶ���
		}

		ArrayList<BusinessObject> list=new ArrayList<BusinessObject>();
		for(BusinessObject termObject:termObjectList){
			String termID_T=termObject.getString(termIDAttribute);
			if(termID_T==null||termID_T.length()==0) continue;
			
			if(termID_T.equals(termID)){
				list.add(termObject);
			}
		}
		return list;
	}
	
	
	
	/**
	 * ����ֶε���ֹ����
	 * @param fromdate�������쿪ʼ
	 * @param todate���������������Ϊ��ʱ˵��û�н�������
	 * @param periodUnit:ִ���ڴε��������޵�λ��������
	 * @param period:ִ���ڴε���������
	 * @param termObjectList:�Ѿ��ź��������б�
	 * @throws Exception 
	 */
	public void initSegTermDate(String fromDate,String toDate,String periodUnit,int period,List<BusinessObject> termObjectList) throws Exception{
		if(termObjectList==null||termObjectList.isEmpty()) return;
		int sumStage = 0;
		int cnt = 0;
		for(BusinessObject termObject:termObjectList){
			cnt++;
			String segFromDate=termObject.getString("SegFromDate");//������ʼ����
			int segFromStage = termObject.getInt("SEGFromStage");//������ʼ�ڴ�
			int segStages = termObject.getInt("SEGStages");
			String segToDate=termObject.getString("SegToDate");//������ʼ����
			int segToStage = termObject.getInt("SEGToStage");//������ʼ�ڴ�
			if(segStages >0 && segFromStage==0 && segToStage == 0)
			{
				segFromStage = sumStage+1;
				segToStage = sumStage+segStages;
				sumStage += segStages;
			}
			
			String fromDate_T="",toDate_T="";
			if(segFromDate != null &&!segFromDate.equals("")){//ָ���˿�ʼ���ڣ����Դ�����Ϊ׼
				fromDate_T = segFromDate;
			}
			else if(segFromStage>=1){//����ʼ�����Ļ�����ô�ۼ�
				fromDate_T=DateFunctions.getRelativeDate(fromDate,
						periodUnit,(segFromStage-1)*period);//�˴���Ҫ��һ����Ϊ¼��ʱ�û�ϰ�ߴ�1��ʼ
			}
			else{//���Ϊû��¼�뿪ʼ���ڻ��߿�ʼ�ڴΣ���Ĭ��Ϊ����Ŀ�ʼ����
				fromDate_T=fromDate;
			}
			
			if(segToDate != null &&!segToDate.equals("")){
				toDate_T = segToDate;
			}
			else if(segToStage>0 && cnt != termObjectList.size()){//�н��������Ļ�����ô�ۼ�
				toDate_T=DateFunctions.getRelativeDate(fromDate,
						periodUnit,segToStage*period);//�˴�����Ҫ��һ
			}
			else{
				toDate_T=toDate;
			}
			
			termObject.setAttributeValue("SegFromDate", fromDate_T);
			termObject.setAttributeValue("SegToDate", toDate_T);
			this.bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, termObject);
		}
	}
}
