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
	
	//添加互斥组件
	public String addExclusiveRelative() throws Exception{
			String TermID = DataConvert.toString((String) this.getAttribute("TermID"));
			String returnValue = DataConvert.toString((String) this.getAttribute("RelativeTermID"));
			String RelativeType = DataConvert.toString((String) this.getAttribute("Method"));
			if("addExclusiveRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Mutex;//互斥
			if("addBindRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Bind;//绑定
			String ObjectNo = DataConvert.toString((String) this.getAttribute("ObjectNo"));
			String ObjectType = DataConvert.toString((String) this.getAttribute("ObjectType"));
			String[] relativeTermIDs = returnValue.split("@");
			for(String RelativeTermID:relativeTermIDs)
			{
			
				//插入组件
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
		//添加绑定组件
		public String addBindRelative() throws Exception{
			String TermID = DataConvert.toString((String) this.getAttribute("TermID"));
			String returnValue = DataConvert.toString((String) this.getAttribute("RelativeTermID"));
			String RelativeType = DataConvert.toString((String) this.getAttribute("Method"));
			if("addExclusiveRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Mutex;//互斥
			if("addBindRelative".equals(RelativeType))RelativeType=ProductConfig.TERM_RELATIONSHIP_Bind;//绑定
			String ObjectNo = DataConvert.toString((String) this.getAttribute("ObjectNo"));
			String ObjectType = DataConvert.toString((String) this.getAttribute("ObjectType"));
			String[] relativeTermIDs = returnValue.split("@");
			for(String RelativeTermID:relativeTermIDs)
			{
			
				//插入组件
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
		//删除关联组件
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
	 * 引入已经定义的组件到产品中
	 * @return
	 * @throws Exception
	 */
	public String importTermToProduct() throws Exception{
		String termID = DataConvert.toString((String) this.getAttribute("TermID"));
		String productID = DataConvert.toString((String) this.getAttribute("ProductID"));
		String versionID = DataConvert.toString((String) this.getAttribute("VersionID"));
		String parentTermID = DataConvert.toString((String) this.getAttribute("ParentTermID"));
		
		String ObjectNo = productID+"-"+versionID;
		
		this.deleteTermFromProduct();//删除原有关联

		//插入组件
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
		//删除之前的组件参数,以免无法引入
		String sql="delete from PRODUCT_TERM_PARA where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		
		//删除组件本身
		sql="delete from PRODUCT_TERM_LIBRARY where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		
		//删除组件关联
		sql="delete from PRODUCT_TERM_RELATIVE where TermID like :termID and ObjectType = 'Product' and  ObjectNo = :ObjectNo";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("termID", termID+"%").setParameter("ObjectNo", ObjectNo));
		return "success";
	}

	/**
	 * 将选中的参数定义复制到具体的组件中
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
		bomanager.getSqlca().executeSQL(new SqlObject(deleteSql).setParameter("termID", termID));//删除之前可能遗留的参数
		
		String insertSql="insert into PRODUCT_TERM_PARA(ObjectType,ObjectNo,TermID,ParaID,ParaName,DataType,Status,SortNo) " +
				" select 'Term',:termID, :termID,ItemNo,ItemName,BankNo,'1',SortNo "+
				" from Code_Library where CodeNo = 'TermAttribute' and ItemNo in  ("+parameters+")";
		bomanager.getSqlca().executeSQL(new SqlObject(insertSql).setParameter("termID", termID));
		return "success";
	}*/

	/**
	 * 将选中的参数定义复制到具体的组件中
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
		bomanager.getSqlca().executeSQL(new SqlObject(deleteSql).setParameter("termID", termID));//删除之前可能遗留的参数
		
		String insertSql="insert into PRODUCT_TERM_PARA(ObjectType,ObjectNo,TermID,ParaID,ParaName,DataType,Status,SortNo) " +
				" select 'Term','"+objectNo+"', '"+termID+"',ItemNo,ItemName,BankNo,'1',SortNo "+
				" from Code_Library where CodeNo = 'TermAttribute' and ItemNo in  ("+parameters+")";
		bomanager.getSqlca().executeSQL(new SqlObject(insertSql).setParameter("objectNo", objectNo).setParameter("termID", termID));
		return "success";
	}
	
	/**
	 * 创建一个产品
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String createProduct() throws Exception{
		String productID=(String)this.getAttribute("ProductID");//产品编号
		String versionID=(String)this.getAttribute("VersionID");//版本号
		String userID=(String)this.getAttribute("UserID");//用户编号
		
		String sql = "delete from PRODUCT_VERSION where ProductID=:productID and VersionID=:versionID";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("productID", productID).setParameter("versionID", versionID));
		
		sql = "insert into PRODUCT_VERSION (ProductID,VersionID,Status,InputUser,InputTime) " +
				"values(:productID,:versionID,'3',:userID,:InputTime)";
		bomanager.getSqlca().executeSQL(new SqlObject(sql).setParameter("productID", productID).setParameter("versionID", versionID).setParameter("userID", userID).setParameter("InputTime", SystemConfig.getSystemDate()));
		return "1";
	}
	
	/**
	 * 复制一个产品版本
	 * @return
	 * @throws Exception
	 */
	public String copyProduct() throws Exception{
		String productID=(String)this.getAttribute("ProductID");//产品编号
		String newProductID=(String)this.getAttribute("NewProductID");//产品编号
		String versionID=(String)this.getAttribute("VersionID");//版本编号
		String newVersionID=(String)this.getAttribute("NewVersionID");//版本编号
		String userID=(String)this.getAttribute("UserID");//用户编号
		
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
	 * 复制一个组件
	 * @return
	 * @throws Exception
	 */
	public String copyTerm() throws Exception{
		String termID=(String)this.getAttribute("TermID");//组件编号
		String newTermID=(String)this.getAttribute("NewTermID");//上级组件编号
		String newTermName=(String)this.getAttribute("NewTermName");//上级组件编号
		
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
			String methodName = (String)this.getAttribute("Method");//方法名称
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
	 * 已知产品编号、版本号和组件编号，将产品定义的参数更新至对应对象中
	 * 对于已在BA中存在的信息，不做更新处理
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
	 * 已知产品编号和版本号，将产品定义的参数更新至对应对象中
	 * 对于已在BA中存在的信息，不做更新处理
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
	 * 已知产品编号和版本号，将产品定义的参数更新至对应对象中
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的组件信息 
	 *  2.对每个组件项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 *  4.对于存在的进行update 业务对象
	 * @return
	 * @throws Exception
	 */
	public void initBusinessObject(BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		ASValuePool termLibrary =ProductConfig.getProductTermLibrary(productID, productVersion);//取得全部组件定义信息
		
		//自动引入必须的组件，同时对于已经选中的组件进行初始化
		Object[] keys=termLibrary.getKeys();
		for(int i=0;i<keys.length;i++){
			String termID=(String)keys[i];
			ASValuePool term = (ASValuePool)termLibrary.getAttribute(termID);
			this.initBusinessObject(term, businessObject);
		}
	}
	
	
	/**
	 * 已知产品编号、版本号和组件编号，将产品定义的参数更新至对应对象中
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的条款信息 
	 *  2.对每个条款项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 *  4.对于存在的进行update business_apply 
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
	 * 已知产品编号、版本号和组件编号，将产品定义的参数更新至对应对象中
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的条款信息 
	 *  2.对每个条款项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 *  4.对于存在的进行update business_apply 
	 * @return
	 * @throws Exception
	 */
	public void initBusinessObject(ASValuePool term,BusinessObject businessObject) throws Exception{
		String termType= term.getString("TermType");//得到组件类别
		String termID= term.getString("TermID");//得到组件编号
		String setFlag= term.getString("SetFlag");//得到组件类型
		String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
		//如果已经引入了此组件，则不处理，否则会出现多笔记录，如果组件ID发生了变动，则删除原来的组件，创建新的组件
		if(termID.equals(businessObject.getString(groupTermIDColName))) return;
		
		//引入新的组件记录
		if(setFlag.equals("SET")){//组合组件
			List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("未找到组合组件{"+termID+"}的子组件，请确认组件定义是否正确！");
			
			for(ASValuePool termRelationShip:termRelativeList){
				ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
				initBusinessObject(relativeTerm, businessObject);//此处递归调用
			}
		}
		else if(setFlag.equals("BAS")||setFlag.equals("SEG")){//单一组件
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
		
		
		ASValuePool paraSet = (ASValuePool)term.getAttribute("TermParameters");// 得到组件的参数表
		Object[] para_keys=paraSet.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para的ParaID
			ASValuePool paramter = (ASValuePool)paraSet.getAttribute(paraID);
			String defaultValue = paramter.getString("DefaultValue");//值
			String aPermission = paramter.getString("APermission");
			
			if((defaultValue == null || "".equals(defaultValue)) && ("Hide".equals(aPermission) || "ReadOnly".equals(aPermission)))
				defaultValue = paramter.getString("ValueList");
			if(defaultValue==null||defaultValue.length()==0) continue;
			
			String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//字段关联对象属性
			String[] ars = refAttributeID.split(",");
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) continue;
				if(ars[n].startsWith(termObject.getObjectType())){//这个属性是属于当前业务对象时
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
	 * 已知产品编号和版本号，将产品定义的参数更新至对应对象中
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的组件信息 
	 *  2.对每个组件项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 *  4.对于存在的进行update 业务对象
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
		//自动引入必须的组件，同时对于已经选中的组件进行初始化
		Object[] keys=termLibrary.getKeys();
		for(int i=0;i<keys.length;i++){
			String termID=(String)keys[i];
			ASValuePool term = (ASValuePool)termLibrary.getAttribute(termID);
			//自动引入必须的业务组件
			ASValuePool paraSet = (ASValuePool)term.getAttribute("TermParameters");// 得到组件的参数表
			//取组件对当前对象的权限要求,如果不是必须，则直接跳过
			boolean objectPermission=false;//默认此组件不是当前对象必须的
			ASValuePool accountPermissionPara = (ASValuePool)paraSet.getAttribute("APermission");//得到组件是否必须标识
			if(accountPermissionPara!=null){
				String s = accountPermissionPara.getString("DefaultValue");//值
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
		//然后初始化已经选中的组件
		this.initBusinessObject(businessObject);
		return list;
	}
	
	
	/**
	 * 已知产品编号、版本号和组件编号，将产品定义的参数更新至对应对象中
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的条款信息 
	 *  2.对每个条款项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 *  4.对于存在的进行update business_apply 
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> createTermObject(ASValuePool term,BusinessObject businessObject) throws Exception{
		String termType= term.getString("TermType");//得到组件类别
		String termID= term.getString("TermID");//得到组件编号
		String setFlag= term.getString("SetFlag");//得到组件类型
		String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
		String relativeAttributeID=ProductConfig.getTermTypeAttribute(termType, "RelativeAttributeID");
		String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
		if(termObjectType==null||termObjectType.length()==0)termObjectType=businessObject.getObjectType();
		//如果是单选组件
		if(groupTermIDColName!=null&&groupTermIDColName.length()>0&&(setFlag.equals("BAS")||setFlag.equals("SET"))){//引入分段的子组件时不能删除
			if(termID.equals(businessObject.getString(groupTermIDColName))) return null;//如果已经引入了此组件，则不处理
			//否则将使用新的组件覆盖原来的组件
			businessObject.setAttributeValue(groupTermIDColName, termID);
			bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, businessObject);//更新
			
			List<BusinessObject> relativeObjectList =this.getTermObjectList(businessObject, termType);
			if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
				for(BusinessObject n:relativeObjectList){
					//有问题，会无法删除同类组件，原因是分段时，组件ID，没有赋值，因此先注释掉，后期解决
					//if(termID.equals(n.getString(relativeAttributeID))){//同一组件的删除
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
		//引入新的组件记录
		if(setFlag.equals("SET")){//组合组件
			List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("未找到组合组件{"+termID+"}的子组件，请确认组件定义是否正确！");
			
			for(ASValuePool termRelationShip:termRelativeList){
				ASValuePool relativeTerm = ProductConfig.getTerm(term.getString("ObjectType"), term.getString("ObjectNo"), termRelationShip.getString("RelativeTermID"));
				List<BusinessObject> termObject = this.createTermObject(relativeTerm, businessObject);//此处递归调用
				list.addAll(termObject);
			}
		}
		else if(setFlag.equals("BAS")||setFlag.equals("SEG")){//单一组件
			BusinessObject termObject = null;
			if(termObjectType.indexOf(businessObject.getObjectType())>=0)
				termObject=businessObject;
			else{
				termObject=new BusinessObject(termObjectType,bomanager);
				termObject.setAttributeValue(relativeAttributeID, termID);
				termObject.setAttributeValue("Status", "0");
				termObject.setAttributeValue("ObjectType", businessObject.getObjectType());
				termObject.setAttributeValue("ObjectNo", businessObject.getObjectNo());
				bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, termObject);//插入
				list.add(termObject);
			}
			
			ASValuePool paraSet = (ASValuePool)term.getAttribute("TermParameters");// 得到组件的参数表
			Object[] para_keys=paraSet.getKeys();
			for(int k=0;k<para_keys.length;k++){
				String paraID = (String)para_keys[k];//term_para的ParaID
				ASValuePool paramter = (ASValuePool)paraSet.getAttribute(paraID);
				String defaultValue = paramter.getString("DefaultValue");//值
				String aPermission = paramter.getString("APermission");
				
				if((defaultValue == null || "".equals(defaultValue)) && ("Hide".equals(aPermission) || "ReadOnly".equals(aPermission)))
					defaultValue = paramter.getString("ValueList");
				if(defaultValue==null||defaultValue.length()==0) continue;

				String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//字段关联对象属性
				String[] ars = refAttributeID.split(",");
				for(int n=0;n<ars.length;n++){
					if(ars[n]==null || "".equals(ars[n])) continue;
					if(ars[n].startsWith(termObject.getObjectType())){//这个属性是属于当前业务对象时
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
	 * 已知产品编号、版本号和组件编号，将产品定义的参数更新至对应对象中
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的条款信息 
	 *  2.对每个条款项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 *  4.对于存在的进行update business_apply 
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
	 * 已知产品编号和版本号，根据产品定义的参数校验业务对象
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的条款信息 
	 *  2.对每个条款项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 * @return
	 * @throws Exception
	 */
	public ASValuePool checkBusinessObject(BusinessObject businessObject) throws Exception{
		String productID = businessObject.getString("BusinessType");
		String productVersion=businessObject.getString("ProductVersion");
		if(productVersion==null||productVersion.length()==0)
			productVersion=ProductConfig.getProductNewestVersionID(productID);
		
		ASValuePool result = new ASValuePool();
		ASValuePool termLibrary = ProductConfig.getProductTermLibrary(productID, productVersion);//取得全部组件定义信息

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
	 * 检查基本组件是否与定义匹配
	 * @param term
	 * @param businessObject
	 * @return
	 * @throws Exception
	 */
	private boolean matchBasicTerm(ASValuePool term,BusinessObject businessObject) throws Exception{
		String termType= term.getString("TermType");//得到组件类别
		String termID= term.getString("TermID");//得到组件编号
		String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
		if(groupTermIDColName!=null&&groupTermIDColName.length()>0){
			String termID_T=businessObject.getString(groupTermIDColName);
			if(termID.equals(termID_T)) return true;
		}
		
		
		ASValuePool termPara = (ASValuePool)term.getAttribute("TermParameters");//得到组件参数
		Object[] para_keys=termPara.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para的ParaID
			ASValuePool paramter = (ASValuePool)termPara.getAttribute(paraID);
			
			String valueList = paramter.getString("ValueList");
			String defaultValue = paramter.getString("DefaultValue");
			String matchFlag = paramter.getString("MatchFlag");//匹配标志
			if(!matchFlag.equals("1")) continue;
			
			String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//字段关联对象属性
			String[] ars = refAttributeID.split(",");
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) continue;
				
				if(!ars[n].startsWith(businessObject.getObjectType())) continue;//这个属性是属于主业务对象时
				
				String objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
				String objectAttributeValue = businessObject.getString(objectAttributeID);
				
				if(objectAttributeValue==null||objectAttributeValue.length()==0) continue;
				if(valueList.indexOf(objectAttributeValue)>=0||objectAttributeValue.equals(defaultValue)){
					continue;
				}
				else{
					return false;//如果有一个匹配不上，则退出
				}
			}
		}
		return true;
	}
	
	private ASValuePool checkBusinessObject(BusinessObject businessObject,ASValuePool term,BusinessObject termObject) throws Exception{
		ASValuePool compareStr = new ASValuePool();//保存不一致的结果
		String termName= term.getString("TermName");
		String sPutMesTitle = "申请信息中";
		if((BUSINESSOBJECT_CONSTATNTS.business_approve).equals(businessObject.getObjectType()))sPutMesTitle = "批复信息中";
		if((BUSINESSOBJECT_CONSTATNTS.business_contract).equals(businessObject.getObjectType()))sPutMesTitle = "合同信息中";
		ASValuePool termPara = (ASValuePool)term.getAttribute("TermParameters");//得到组件参数
		Object[] para_keys=termPara.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para的ParaID
			ASValuePool paramter = (ASValuePool)termPara.getAttribute(paraID);
			String paraName= paramter.getString("ParaName");
			String maxValue = paramter.getString("MaxValue");
			String minValue = paramter.getString("MinValue");
			String valueList = paramter.getString("ValueList");

			String refAttributeID = ProductConfig.getParameterDefAttribute(paraID, "DEF_RelativeObjectAttribute");//字段关联对象属性
			String[] ars = refAttributeID.split(",");//主要是因为BA、BAP、BC、BP的原因
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) continue;
				String objectAttributeID;
				String objectAttributeValue;
				
				if(ars[n].startsWith(businessObject.getObjectType())){//这个属性是属于主业务对象时
					objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
					objectAttributeValue = businessObject.getString(objectAttributeID);
				}
				else if(ars[n].startsWith(termObject.getObjectType())){//这个属性是属于附属业务对象时
					objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
					objectAttributeValue = termObject.getString(objectAttributeID);
				}
				else continue;//都不是时，则不再校验，应该不存在这种情况
				
				//处理ValueList
				if(valueList!=null&&valueList.length()>0){
					if(objectAttributeValue == null || "".equals(objectAttributeValue))
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"【"+paraName+"】的值不在产品组件【"+termName+"】的参数限定范围内！");//【"+objectAttributeValue+"】
					else if(valueList.indexOf(objectAttributeValue)<0){
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"【"+paraName+"】的值不在产品组件【"+termName+"】的参数限定范围内！");//【"+objectAttributeValue+"】
					}
				}
				
				if(objectAttributeValue==null||objectAttributeValue.length()==0) continue;
				if(maxValue!=null&&maxValue.length()>0){
					if(DataConvert.toDouble(objectAttributeValue)>DataConvert.toDouble(maxValue)){
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"【"+paraName+"】-【"+objectAttributeValue+"】大于产品组件【"+termName+"】中定义最大值【"+DataConvert.toDouble(maxValue)+"】！");
					}
				}
				//若产品组件定义要素为空即未定义，则不校验
				if(minValue!=null&&minValue.length()>0){
					if(DataConvert.toDouble(objectAttributeValue)<DataConvert.toDouble(minValue)){
						compareStr.setAttribute(termName+"-"+objectAttributeID,sPutMesTitle+"【"+paraName+"】-【"+objectAttributeValue+"】小于产品组件【"+termName+"】中定义最小值【"+DataConvert.toDouble(minValue)+"】！");
					}
				}
			}
		}
		return compareStr;
	}
	
	/**
	 * 已知产品编号和版本号，根据产品定义的参数校验业务对象
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的条款信息 
	 *  2.对每个条款项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
	 * @return
	 * @throws Exception
	 */
	public ASValuePool checkBusinessObject(BusinessObject businessObject,ASValuePool term) throws Exception{
		String setFlag= term.getString("SetFlag");//得到组件类型
		String termName= term.getString("TermName");
		String termID= term.getString("TermID");
		String termType = term.getString("TermType");
		//此处少了必须的校验逻辑？？？？？？？？？？？？？？？？？？
		ASValuePool checkResult = new ASValuePool();//保存不一致的结果
		
		String termObjectType = ProductConfig.getTermTypeAttribute(termType,"RelativeObjectType");//组件对象类型
		if(termObjectType==null||termObjectType.length()==0) 
			termObjectType=businessObject.getObjectType();
		String termIDAttributeName = ProductConfig.getTermTypeAttribute(termType,"RelativeAttributeID");//组件对象类型

		if(setFlag.equals("SET")){//组合组件
			List<BusinessObject> termObjectList = this.getTermObjectList(businessObject, termType);
			if(termObjectList==null||termObjectList.isEmpty())//此处需要校验分段数是否一致，是否可修改等规则，目前没有实现
				return null;
			List<ASValuePool> termRelativeList = ProductConfig.getTermRelativeList(term, ProductConfig.TERM_RELATIONSHIP_SEG);
			if(termRelativeList==null||termRelativeList.isEmpty())
				throw new Exception("未找到组合组件{"+termName+"}的子组件，请确认组件定义是否正确！");
			
			for(BusinessObject termObject:termObjectList){
				String termID_T = termObject.getString(termIDAttributeName);
				if(!termID.equals(termID_T)) continue;//可能不是当前组件ID的，则忽略
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
		else if(setFlag.equals("BAS") || setFlag.equals("SEG")){//单一组件
			if(termObjectType.indexOf(businessObject.getObjectType())>=0) {
				checkResult.uniteFromValuePool(checkBusinessObject(businessObject,term,businessObject));
			}
			else{
				List<BusinessObject> termObjectList = this.getTermObjectList(businessObject, termType);
				if(termObjectList==null||termObjectList.isEmpty())//此处需要校验分段数是否一致，是否可修改等规则，目前没有实现
					return null;
				
				for(BusinessObject a:termObjectList){
					if(termID.equals(a.getString(termIDAttributeName)))
						checkResult.uniteFromValuePool(checkBusinessObject(businessObject,term,a));
				}
			}
		}
		else throw new Exception("无效的组件类型，只有类型为BAS或SET或SEG的组件可被引入！");
		return checkResult;
	}
	
	/**
	 * 已知产品编号、版本号和组件编号，根据产品定义的参数校验业务对象
	 * 对于已在BusinessObject中存在的信息
	 *  1.找到对应产品相关的条款信息 
	 *  2.对每个条款项下的字段进行校验，是否存在于codeno='TermAttribute' and attribute3 like '%ObjectType%'中 
	 *  3.每个typeno对应多个term_library,每个term_library对应多个term_para,每个term_para去检查是否需在codeno=termattribute中合规 
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
		String termObjectType = ProductConfig.getTermTypeAttribute(termType,"RelativeObjectType");//组件对象类型
		String termIDAttribute = ProductConfig.getTermTypeAttribute(termType,"RelativeAttributeID");//组件对象类型
		List<BusinessObject> termObjectList = businessObject.getRelativeObjects(termObjectType);
		
		if(termObjectType==null||termObjectType.length()==0||termObjectType.indexOf(businessObject.getObjectType())>=0)
			return null;
		if(termObjectList==null||termObjectList.isEmpty()){//如果为空，则尝试从数据库中加载，此做法是为了保证咨询与实际贷款录入时使用统一方法，为临时解决方案
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", businessObject.getObjectNo());
			as.setAttribute("ObjectType",businessObject.getObjectType());
			termObjectList = bomanager.loadBusinessObjects(termObjectType, " ObjectNo = :ObjectNo and ObjectType = :ObjectType",as);//利率定义
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
		String termObjectType = ProductConfig.getTermTypeAttribute(termType,"RelativeObjectType");//组件对象类型
		String termIDAttribute = ProductConfig.getTermTypeAttribute(termType,"RelativeAttributeID");//组件对象类型
		List<BusinessObject> termObjectList = businessObject.getRelativeObjects(termObjectType);

		if(termObjectType==null||termObjectType.length()==0||termObjectType.indexOf(businessObject.getObjectType())>=0)
			return null;
		if(termObjectList==null||termObjectList.isEmpty()){//如果为空，则尝试从数据库中加载，此做法是为了保证咨询与实际贷款录入时使用统一方法，为临时解决方案
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", businessObject.getObjectNo());
			as.setAttribute("ObjectType",businessObject.getObjectType());
			termObjectList = bomanager.loadBusinessObjects(termObjectType, " ObjectNo = :ObjectNo and ObjectType = :ObjectType",as);//利率定义
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
	 * 计算分段的起止日期
	 * @param fromdate：从哪天开始
	 * @param todate：到哪天截至，当为空时说明没有截至日期
	 * @param periodUnit:执行期次的周期期限单位：年月日
	 * @param period:执行期次的周期期限
	 * @param termObjectList:已经排好序的组件列表
	 * @throws Exception 
	 */
	public void initSegTermDate(String fromDate,String toDate,String periodUnit,int period,List<BusinessObject> termObjectList) throws Exception{
		if(termObjectList==null||termObjectList.isEmpty()) return;
		int sumStage = 0;
		int cnt = 0;
		for(BusinessObject termObject:termObjectList){
			cnt++;
			String segFromDate=termObject.getString("SegFromDate");//区段起始日期
			int segFromStage = termObject.getInt("SEGFromStage");//区段起始期次
			int segStages = termObject.getInt("SEGStages");
			String segToDate=termObject.getString("SegToDate");//区段起始日期
			int segToStage = termObject.getInt("SEGToStage");//区段起始期次
			if(segStages >0 && segFromStage==0 && segToStage == 0)
			{
				segFromStage = sumStage+1;
				segToStage = sumStage+segStages;
				sumStage += segStages;
			}
			
			String fromDate_T="",toDate_T="";
			if(segFromDate != null &&!segFromDate.equals("")){//指定了开始日期，则以此日期为准
				fromDate_T = segFromDate;
			}
			else if(segFromStage>=1){//有起始月数的话，那么累加
				fromDate_T=DateFunctions.getRelativeDate(fromDate,
						periodUnit,(segFromStage-1)*period);//此处需要减一，因为录入时用户习惯从1开始
			}
			else{//如果为没有录入开始日期或者开始期次，则默认为传入的开始日期
				fromDate_T=fromDate;
			}
			
			if(segToDate != null &&!segToDate.equals("")){
				toDate_T = segToDate;
			}
			else if(segToStage>0 && cnt != termObjectList.size()){//有截至月数的话，那么累加
				toDate_T=DateFunctions.getRelativeDate(fromDate,
						periodUnit,segToStage*period);//此处不需要减一
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
