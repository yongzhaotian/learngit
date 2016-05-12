package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

/**
 * 修改集团客户概况的后续操作
 * @author 
 */

public class UpdateGroupCustomerAction extends Bizlet {
	
	private Transaction Sqlca = null;
	
	public Object run(Transaction Sqlca) throws Exception{
        this.Sqlca=Sqlca;
		/**
		 * 获取参数
		 */   
		String sMgtOrgID = (String)this.getAttribute("MgtOrgID");
		String sKeyMemberCustomerID = (String)this.getAttribute("KeyMemberCustomerID");
		String sMgtUserID = (String)this.getAttribute("MgtUserID");
		String sGroupType2 = (String)this.getAttribute("GroupType2");
		String sOldGroupType2 = (String)this.getAttribute("oldGroupType2");
		String sOldMgtOrgID = (String)this.getAttribute("oldMgtOrgID");
		String sOldMgtUserID = (String)this.getAttribute("oldMgtUserID");
		String sOldKeyMemberCustomerID = (String)this.getAttribute("oldKeyMemberCustomerID");
		String sGroupID = (String)this.getAttribute("GroupID");
		String sUserID = (String)this.getAttribute("UserID");
		String sIsGroupMember = (String)this.getAttribute("IsGroupMember");
		
		//将空值转化为空字符串
		if(sMgtOrgID == null) sMgtOrgID = "";
		if(sKeyMemberCustomerID == null) sKeyMemberCustomerID = "";
		if(sMgtUserID == null) sMgtUserID = "";
		if(sGroupType2 == null) sGroupType2 = "";	
		if(sOldGroupType2 == null) sOldGroupType2 = "";
		if(sOldMgtOrgID == null) sOldMgtOrgID = "";
		if(sOldMgtUserID == null) sOldMgtUserID = "";
		if(sOldKeyMemberCustomerID == null) sOldKeyMemberCustomerID = "";
		if(sGroupID == null) sGroupID = "";
		if(sUserID == null) sUserID = "";
		if(sIsGroupMember == null) sIsGroupMember = "";
	
		/**
		 * 定义变量
		 */
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		ASResultSet rs = null;						//查询结果集
		String sReturn = "0";
		ASUser CurUser1 = ASUser.getUser(sOldMgtUserID,Sqlca);
		String sOldMgtOrgName=CurUser1.getOrgName();
		ASUser CurUser2 = ASUser.getUser(sMgtUserID,Sqlca);
		String sMgtOrgName=CurUser2.getOrgName();
		
		//业务主办行变更
		if(!(sOldMgtOrgID.equals(sMgtOrgID))){
			//记录集团类型变化事件，插入记录至GROUP_EVENT
			String sChangeContext="业务主办行由 "+sOldMgtOrgName+" 变更为 "+sMgtOrgName;
			
			String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID",Sqlca);
			StringBuffer sbSql = new StringBuffer();
			SqlObject so ;								
			sbSql.append(" insert into GROUP_EVENT(") 	
				.append(" EventID,")					
				.append(" GroupID,")				
				.append(" EventType, ")		         
				.append(" OccurDate, ")	
				.append(" RefMemberID, ")	
				.append(" EventValue, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate, ")
				.append(" OldEventValue, ")	
				.append(" RefMemberName, ")	
				.append(" ChangeContext ")	
				.append(" )values(:EventID, :GroupID, :EventType, :OccurDate, :RefMemberID, :EventValue, :InputOrgID, :InputUserID, :InputDate," +
						" :UpdateDate, :OldEventValue, :RefMemberName, :ChangeContext )");
			so = new SqlObject(sbSql.toString());
			so.setParameter("EventID", sEventID).setParameter("GroupID", sGroupID).setParameter("EventType", "02").setParameter("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("RefMemberID", "").setParameter("EventValue", "").setParameter("InputOrgID",CurUser.getOrgID() ).setParameter("InputUserID", CurUser.getUserID());
			so.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("OldEventValue", sOldMgtOrgID).setParameter("RefMemberName", "").setParameter("ChangeContext",sChangeContext );
			Sqlca.executeSQL(so);	
			
			
			//判断原主办客户经理是否为成员的客户经理
		    String sSql1="select *  from CUSTOMER_BELONG where CustomerID in " +
									"(select MemberCustomerID from GROUP_FAMILY_MEMBER  where VersionSeq = (select max(VersionSeq) from " +
									"  GROUP_FAMILY_MEMBER where GroupID = :GroupID) and GroupID = :GroupID " +
									") and BelongAttribute = '1' and UserID = :UserID ";
			boolean bExists=false;
	        rs = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("CustomerID", sGroupID).
	        		setParameter("GroupID",sGroupID).setParameter("UserID",sOldMgtUserID));
	    	if(rs.next()){
				bExists = true;
			}
			rs.getStatement().close();
			rs = null;
			
	  		if(bExists == true){
	  			Sqlca.executeSQL(new SqlObject("update CUSTOMER_BELONG set BELONGATTRIBUTE= :BELONGATTRIBUTE,BELONGATTRIBUTE1= :BELONGATTRIBUTE1," +
		        " BELONGATTRIBUTE2= :BELONGATTRIBUTE2,BELONGATTRIBUTE3= :BELONGATTRIBUTE3 where CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID ").
				setParameter("CustomerID",sGroupID).
				setParameter("OrgID",sOldMgtOrgID).
				setParameter("UserID",sOldMgtUserID).
				setParameter("BELONGATTRIBUTE","2").
				setParameter("BELONGATTRIBUTE1","1").
				setParameter("BELONGATTRIBUTE2","2").
				setParameter("BELONGATTRIBUTE3","2"));
	  		}else{
				//删除原主办客户经理的权限  
	  			Sqlca.executeSQL(new SqlObject("delete from CUSTOMER_BELONG where CustomerID=:CustomerID").setParameter("CustomerID", sGroupID));
	  			
	  			//插入新记录至customer_belong表	
		  		String sSql = "insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3," +
					" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)"+
					" values (:CustomerID,:OrgID,:UserID,:BelongAttribute,:BelongAttribute1,:BelongAttribute2,:BelongAttribute3," +
					" :BelongAttribute4,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", sGroupID).setParameter("OrgID", sMgtOrgID).setParameter("UserID", sMgtUserID).setParameter("BelongAttribute", "1")
				.setParameter("BelongAttribute1", "1").setParameter("BelongAttribute2", "1").setParameter("BelongAttribute3", "1")
				.setParameter("BelongAttribute4", "1").setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
				.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
				Sqlca.executeSQL(so);	
	  		}
			
		}
		
		//核心企业变更
		if(!(sOldKeyMemberCustomerID.equals(sKeyMemberCustomerID))){
			
			/** 根据核心企业客户编号，查询对应的客户名称*/
		    String 	sSql2 = " select CustomerName from CUSTOMER_INFO WHERE CustomerID=:CustomerID ";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("CustomerID", sOldKeyMemberCustomerID));
	        String sOldKeyMemberCustomerName="";
			if(rs.next()){
				sOldKeyMemberCustomerName = rs.getString("CustomerName");
			}
			rs.getStatement().close();
			rs = null;
			if(sOldKeyMemberCustomerName == null) sOldKeyMemberCustomerName = "";
			
			/** 根据核心企业客户编号，查询对应的客户名称*/
		    String 	sSql3 = " select CustomerName,CertType,CertID from CUSTOMER_INFO WHERE CustomerID=:CustomerID ";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql3).setParameter("CustomerID", sKeyMemberCustomerID));
	        String sKeyMemberCustomerName="";
	        String sMemberCertType="";
	        String sMemberCertID="";
			if(rs.next()){
				sKeyMemberCustomerName = rs.getString("CustomerName");
				sMemberCertType=rs.getString("CertType");
				sMemberCertID=rs.getString("CertID");
			}
			rs.getStatement().close();
			rs = null;
			if(sKeyMemberCustomerName == null) sKeyMemberCustomerName = "";
			if(sMemberCertType == null) sMemberCertType = "";
			if(sMemberCertID == null) sMemberCertID = "";
			
			//记录集团类型变化事件，插入记录至GROUP_EVENT
			String sChangeContext="核心公司由 "+sOldKeyMemberCustomerName+" 变更为 "+sKeyMemberCustomerName;
			
			String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID",Sqlca);
			StringBuffer sbSql1 = new StringBuffer();
			SqlObject so ;								
			sbSql1.append(" insert into GROUP_EVENT(") 	
				.append(" EventID,")					
				.append(" GroupID,")				
				.append(" EventType, ")		         
				.append(" OccurDate, ")	
				.append(" RefMemberID, ")	
				.append(" EventValue, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate, ")
				.append(" OldEventValue, ")	
				.append(" RefMemberName, ")	
				.append(" ChangeContext ")	
				.append(" )values(:EventID, :GroupID, :EventType, :OccurDate, :RefMemberID, :EventValue, :InputOrgID, :InputUserID, :InputDate," +
						" :UpdateDate, :OldEventValue, :RefMemberName, :ChangeContext )");
			so = new SqlObject(sbSql1.toString());
			so.setParameter("EventID", sEventID).setParameter("GroupID", sGroupID).setParameter("EventType", "04").setParameter("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("RefMemberID", sGroupID).setParameter("EventValue", "").setParameter("InputOrgID",CurUser.getOrgID() ).setParameter("InputUserID", CurUser.getUserID());
			so.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("OldEventValue", sOldKeyMemberCustomerID).setParameter("RefMemberName","").setParameter("ChangeContext",sChangeContext);
			Sqlca.executeSQL(so);	
			
			//判断集团客户是否有已复核通过的家谱版本
		    String sSql4="select * from GROUP_MEMBER_RELATIVE where GroupID=:GroupID";
			String isGroupMember="false";
			rs = Sqlca.getASResultSet(new SqlObject(sSql4).setParameter("GroupID", sGroupID));
			if(rs.next()){
				isGroupMember = "true";
			}
			rs.getStatement().close();
			rs = null;
			
			//获取最新的集团家谱版本编号
			String 	sSql5 = " select RefVersionSeq,FamilyMapStatus from GROUP_INFO WHERE GroupID=:GroupID ";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql5).setParameter("GroupID", sGroupID));
	        String newVersionSeq="";
	        String newFamilyMapStatus="";
			if(rs.next()){
				newVersionSeq = rs.getString("RefVersionSeq");
				newFamilyMapStatus=rs.getString("FamilyMapStatus");
			}
			rs.getStatement().close();
			rs = null;
			if(newVersionSeq == null) newVersionSeq = "";
			if(newFamilyMapStatus == null) newFamilyMapStatus = "";

			if(isGroupMember.equals("true")){//当前集团有已复核通过的家谱版本
				//1.更改集团成员表中新的核心企业的信息
				Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
						setParameter("GroupID", sGroupID).
						setParameter("MemberCustomerID",sKeyMemberCustomerID).
						setParameter("ParentMemberID","None").
						setParameter("ParentRelationType","").
						setParameter("MemberType","01").
						setParameter("VersionSeq",newVersionSeq)
						);
				//2.更改集团成员表中原有核心企业的信息
				Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
						setParameter("GroupID", sGroupID).
						setParameter("MemberCustomerID",sOldKeyMemberCustomerID).
						setParameter("ParentMemberID",sKeyMemberCustomerID).
						setParameter("ParentRelationType","01").
						setParameter("MemberType","02").
						setParameter("VersionSeq",newVersionSeq)
						);
				}else{//当前集团无已复核通过的家谱版本					
					//查询当前集团是否既有核心企业成员，又有一般成员
			        String haveMember="false";
					String 	sSql8 = " select count(*) A from GROUP_FAMILY_MEMBER WHERE GroupID=:GroupID and ParentMemberID<>:ParentMemberID";
			        rs = Sqlca.getASResultSet(new SqlObject(sSql8).setParameter("GroupID", sGroupID).setParameter("ParentMemberID","None"));
					if(rs.next()){
						if(Integer.parseInt(rs.getString("A")) > 0)
							haveMember="true";//有一般成员
					}
					rs.getStatement().close();
					rs = null;
					
					if(sIsGroupMember.equals("true")){//1.新的核心企业已是集团成员
						//1.1更改集团成员表中新的核心企业的信息
						Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
								setParameter("GroupID", sGroupID).
								setParameter("MemberCustomerID",sKeyMemberCustomerID).
								setParameter("ParentMemberID","None").
								setParameter("ParentRelationType","").
								setParameter("MemberType","01").
								setParameter("VersionSeq",newVersionSeq)
								);
						//1.2更改集团成员表中原有核心企业的信息
						Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
								setParameter("GroupID", sGroupID).
								setParameter("MemberCustomerID",sOldKeyMemberCustomerID).
								setParameter("ParentMemberID",sKeyMemberCustomerID).
								setParameter("ParentRelationType","01").
								setParameter("MemberType","02").
								setParameter("VersionSeq",newVersionSeq)
								);
					}else if((sIsGroupMember.equals("false"))&&(haveMember.equals("false"))){//2.新核心企业不是集团成员，当前集团家谱只有一个核心企业，无一般成员存在												
						//2.1.删除旧的核心成员
						Sqlca.executeSQL(new SqlObject("delete from GROUP_FAMILY_MEMBER where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID").setParameter("GroupID", sGroupID).setParameter("MemberCustomerID", sOldKeyMemberCustomerID));			  			
						//2.2.插入新记录至GROUP_FAMILY_MEMBER
						String sMemberID=DBKeyHelp.getSerialNo("GROUP_FAMILY_MEMBER","MemberID",Sqlca);		
						StringBuffer sbSql = new StringBuffer();
						SqlObject so1 ;
						sbSql.append(" insert into GROUP_FAMILY_MEMBER(") 
							.append(" MemberID,")	
							.append(" GroupID,")					
							.append(" VersionSeq,")				
							.append(" MemberName, ")		         
							.append(" MemberCustomerID, ")	
							.append(" MemberType, ")	
							.append(" MemberCertType, ")	
							.append(" MemberCertID, ")	
							.append(" MemberCorpID,")					
							.append(" ParentMemberID,")						         
							.append(" ReviseFlag, ")	
							.append(" InfoSource, ")	
							.append(" InputOrgID, ")	
							.append(" InputUserID, ")	
							.append(" InputDate, ")	
							.append(" UpdateDate ")	
							.append(" )values(:MemberID, :GroupID, :VersionSeq, :MemberName, :MemberCustomerID, :MemberType, " +
									         ":MemberCertType,:MemberCertID, :MemberCorpID, :ParentMemberID, :ReviseFlag,:InfoSource, " +
											 ":InputOrgID, :InputUserID, :InputDate, :UpdateDate )");
						so1 = new SqlObject(sbSql.toString());
						so1.setParameter("MemberID", sMemberID).setParameter("GroupID", sGroupID).setParameter("VersionSeq", newVersionSeq);
						so1.setParameter("MemberName", sKeyMemberCustomerName).setParameter("MemberCustomerID", sKeyMemberCustomerID);
						so1.setParameter("MemberType", "01").setParameter("MemberCertType", sMemberCertType).setParameter("MemberCertID", sMemberCertID).setParameter("MemberCorpID", "");
						so1.setParameter("ParentMemberID", "None").setParameter("ReviseFlag", "").setParameter("InfoSource", "").setParameter("InputOrgID", CurUser.getOrgID());
						so1.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
						Sqlca.executeSQL(so1);		
						
					}else if((sIsGroupMember.equals("false"))&&(haveMember.equals("true"))){//3.新核心企业不是集团成员，但当前集团家谱有核心成员和一般成员存在	
						//1.插入新记录至GROUP_FAMILY_MEMBER
						String sMemberID=DBKeyHelp.getSerialNo("GROUP_FAMILY_MEMBER","MemberID",Sqlca);		
						StringBuffer sbSql = new StringBuffer();
						SqlObject so1 ;
						sbSql.append(" insert into GROUP_FAMILY_MEMBER(") 
							.append(" MemberID,")	
							.append(" GroupID,")					
							.append(" VersionSeq,")				
							.append(" MemberName, ")		         
							.append(" MemberCustomerID, ")	
							.append(" MemberType, ")	
							.append(" MemberCertType, ")	
							.append(" MemberCertID, ")	
							.append(" MemberCorpID,")					
							.append(" ParentMemberID,")						         
							.append(" ReviseFlag, ")	
							.append(" InfoSource, ")	
							.append(" InputOrgID, ")	
							.append(" InputUserID, ")	
							.append(" InputDate, ")	
							.append(" UpdateDate ")	
							.append(" )values(:MemberID, :GroupID, :VersionSeq, :MemberName, :MemberCustomerID, :MemberType, " +
									         ":MemberCertType,:MemberCertID, :MemberCorpID, :ParentMemberID, :ReviseFlag,:InfoSource, " +
											 ":InputOrgID, :InputUserID, :InputDate, :UpdateDate )");
						so1 = new SqlObject(sbSql.toString());
						so1.setParameter("MemberID", sMemberID).setParameter("GroupID", sGroupID).setParameter("VersionSeq", newVersionSeq);
						so1.setParameter("MemberName", sKeyMemberCustomerName).setParameter("MemberCustomerID", sKeyMemberCustomerID);
						so1.setParameter("MemberType", "01").setParameter("MemberCertType", sMemberCertType).setParameter("MemberCertID", sMemberCertID).setParameter("MemberCorpID", "");
						so1.setParameter("ParentMemberID", "None").setParameter("ReviseFlag", "").setParameter("InfoSource", "").setParameter("InputOrgID", CurUser.getOrgID());
						so1.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
						Sqlca.executeSQL(so1);		
						//2.将旧的核心成员连同下挂子成员跟新的核心企业关联
						Sqlca.executeSQL(new SqlObject("update GROUP_FAMILY_MEMBER set MemberType=:MemberType,ParentMemberID=:ParentMemberID,ParentRelationType=:ParentRelationType where GroupID=:GroupID and MemberCustomerID=:MemberCustomerID and VersionSeq=:VersionSeq").
								setParameter("GroupID", sGroupID).
								setParameter("MemberCustomerID",sOldKeyMemberCustomerID).
								setParameter("ParentMemberID",sKeyMemberCustomerID).
								setParameter("ParentRelationType","01").
								setParameter("MemberType","02").
								setParameter("VersionSeq",newVersionSeq)
								);						
					}
					
			}
		}	
		
		//总行管理名单变更
		if(!(sOldGroupType2.equals(sGroupType2))){		
			System.out.println(sOldGroupType2);
			System.out.println(sGroupType2);
			if(sOldGroupType2.equals("1")){
				sOldGroupType2="是总行管理名单";
			}else{
				sOldGroupType2="非总行管理名单";
				}
			
			if(sGroupType2.equals("1")){
				sGroupType2="是总行管理名单";
			}else{
				sGroupType2="非总行管理名单";
				}

			//记录集团类型变化事件，插入记录至GROUP_EVENT
			String sChangeContext="由 "+sOldGroupType2+" 变更为 "+sGroupType2;
			
			String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID",Sqlca);
			StringBuffer sbSql2 = new StringBuffer();
			SqlObject so ;								
			sbSql2.append(" insert into GROUP_EVENT(") 	
				.append(" EventID,")					
				.append(" GroupID,")				
				.append(" EventType, ")		         
				.append(" OccurDate, ")	
				.append(" RefMemberID, ")	
				.append(" EventValue, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate, ")
				.append(" OldEventValue, ")	
				.append(" RefMemberName, ")	
				.append(" ChangeContext ")	
				.append(" )values(:EventID, :GroupID, :EventType, :OccurDate, :RefMemberID, :EventValue, :InputOrgID, :InputUserID, :InputDate," +
						" :UpdateDate, :OldEventValue, :RefMemberName, :ChangeContext )");
			so = new SqlObject(sbSql2.toString());
			so.setParameter("EventID", sEventID).setParameter("GroupID", sGroupID).setParameter("EventType", "05").setParameter("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("RefMemberID", sGroupID).setParameter("EventValue", "").setParameter("InputOrgID",CurUser.getOrgID() ).setParameter("InputUserID", CurUser.getUserID());
			so.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("OldEventValue", sOldKeyMemberCustomerID).setParameter("RefMemberName","").setParameter("ChangeContext",sChangeContext);
			Sqlca.executeSQL(so);	
		}	
		return sReturn;	
	}	
}
