package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.lending.bizlets.CreateAccount;
import com.amarsoft.app.lending.bizlets.UpdateColValue;
import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.workflow.action.FlowAction;
import com.amarsoft.biz.workflow.action.InsertAutoRuleAction;

/**
 * Servlet implementation class SubmitContract
 */
public class SubmitContract extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:SubmitContract=========]:";

	private Transaction Sqlca;

	private String ReplaceAccount;// �ۿ��˺�
	private String ReplaceName;// �ۿ��˺�����

	private String SerialNo;
	private String customerId;
	private String AccountNo;
	private String AccountName;

	private String ObjectNo;// ��ͬ���
	private String ObjectType = "BusinessContract";

	private String AccountIdicator;// �ʻ�����

	private String RepaymentWay;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");
		ARE.getLog().debug(OUT_PUT_LOG + "do post begin");
		String appContractSerialno = request.getParameter("ContractSerialno");
		ARE.getLog().debug(
				OUT_PUT_LOG + "input parameter 1:" + appContractSerialno);
		String appCustomerID = request.getParameter("CustomerID");
		ARE.getLog().debug(OUT_PUT_LOG + "input parameter 2:" + appCustomerID);
		String sUserID = request.getParameter("UserID");
		ARE.getLog().debug(OUT_PUT_LOG + "input parameter 3:" + sUserID);
		Thread thread = new Thread(new MyRunnable(
				appContractSerialno,appCustomerID,sUserID));
		thread.start();
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("IsStatus", "1");
		jsonObject.put("CustomerID", appContractSerialno);
		jsonObject.put("ContractSerialno", appContractSerialno);
		
		ARE.getLog().debug(OUT_PUT_LOG + "output parameter :" + jsonObject.toString());
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}

	/**
	 * /*~[�����ַ����ַ��] function addPhoneInfo(obj){ //�ֻ����� var sMobileTelephone =
	 * getItemValue(0,0,"MobileTelephone"); //סլ�绰 var sFamilyTel =
	 * getItemValue(0,0,"FamilyTel"); //�칫/ѧУ/����绰 var sWorkTel =
	 * getItemValue(0,0,"WorkTel"); //��ż�绰���� var sSpouseTel =
	 * getItemValue(0,0,"SpouseTel"); //������ϵ�绰 var sKinshipTel =
	 * getItemValue(0,0,"KinshipTel"); //��ϵ�˵绰 var sContactTel =
	 * getItemValue(0,0,"ContactTel"); //�ͻ���� var sCustomerID =
	 * getItemValue(0,0,"CustomerID"); //��ȡ��ˮ�� var sSerialNo =
	 * getSerialNo("Phone_Info","SerialNo","");
	 * 
	 * if(obj=="01"){//�ֻ�����
	 * str=sSerialNo+","+sCustomerID+","+sMobileTelephone+",010"; }
	 * if(obj=="02"){//סլ�绰 str=sSerialNo+","+sCustomerID+","+sFamilyTel+",010";
	 * } if(obj=="03"){//�칫/ѧУ/����绰
	 * str=sSerialNo+","+sCustomerID+","+sWorkTel+",999"; }
	 * if(obj=="04"){//��ż�绰����
	 * str=sSerialNo+","+sCustomerID+","+sSpouseTel+",020"; }
	 * if(obj=="05"){//������ϵ�绰
	 * str=sSerialNo+","+sCustomerID+","+sKinshipTel+",060"; }
	 * if(obj=="06"){//��ϵ�˵绰
	 * str=sSerialNo+","+sCustomerID+","+sContactTel+",999"; }
	 * 
	 * //����绰���绰�ֿ� RunMethod("BusinessManage","UpdatePhoneInfo",str);
	 * 
	 * }
	 **/
	class MyRunnable implements Runnable {
		private static final String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:SubmitContract=========]:";

		private Transaction Sqlca;

		private String ReplaceAccount;// �ۿ��˺�
		private String ReplaceName;// �ۿ��˺�����

		private String SerialNo;
		private String customerId;
		private String AccountNo;
		private String AccountName;

		private String ObjectNo;// ��ͬ���
		private String ObjectType = "BusinessContract";

		private String AccountIdicator;// �ʻ�����

		private String RepaymentWay;
		private String appContractSerialno,appCustomerID,sUserID;
        public MyRunnable(String appContractSerialno,String appCustomerID,String sUserID)
        {
        	this.appContractSerialno=appContractSerialno;
        	this.appCustomerID=appCustomerID;
        	this.sUserID=sUserID;
        }
		@Override
		public void run() {
			Connection conn = null;
            System.out.println("********************************* start mythread************************************");
            
			Statement st = null;
			String sql = "";
			String serialNo = "";// �׶���ˮ��
			String objectType = "";
			String oldPhaseNos = "";// �׶α��
			String returnValue = "";// ���ù������淵��ֵ
			String orgID = "";// ��¼�˻���
			String flowNo = "";
			String record_sql = "";//�жϿͻ��Ƿ��Ѵ�����ind_info_record
			String record_update_sql = "";//����ind_info_record
			String record_insert_sql = "";//����ind_info_record
			String assist_delete_sql = "";//Э��ɾ��sql(��ɾ������룬��ֹͬһ��ͬ���ֶ���Э���¼)
			String assist_insert_sql = "";//Э�����sql
			try {
				conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
				st = conn.createStatement();
				
				sql="select contractstatus from business_contract  where serialno='"+ appContractSerialno + "'";
				ResultSet rss=st.executeQuery(sql);
				String contractstatus="";
				while(rss.next()){
					contractstatus=rss.getString("contractstatus");
					
				}
				rss.close();
				
				if("060".equals(contractstatus)){
					Sqlca = new Transaction(conn);
					JBOTransaction xt = JBOFactory.createJBOTransaction();
					xt.join(Sqlca);
					// ���app�к�ͬ�Ϳͻ����ٲ��뿪����ͬ���ͻ���Ϣ�����г�ʼ�������ù�������
	
					sql = "UPDATE ind_info set( "
							+ " WORKTELPLUS,WORKTELAREACODE,WORKTELMAIN,Cellno,Certid,Community,Countryside,Customername,Familyadd,Familyzip,Issueinstitution,Maturitydate,Nativeplace,Plot,Room,  "
							+ " Sex,Street,Villagecenter,Villagetown,Flag2,Balancesheet,Childrentotal,Flag10,House,Kinshipadd,Kinshipname,   "
							+ " Kinshiptel,Marriage,Relativetype,Spousename,Spousetel,Alimony,Cellproperty,Employrecord,Unitcountryside,          "
							+ " Unitkind,Unitno,Unitroom,Unitstreet,Workadd,Workcorp,Workzip,Headship,Flag3,   "
							+ " Flag8,Commadd,Emailcountryside,Emailstreet,Emailplot,Emailroom,Emailadd,Familytel,   "
							+ " Mobiletelephone,Phoneman,Qqno,Wechat,Worktel,Contactrelation,Eduexperience,Jobtime,Jobtotal,Othercontact,Contacttel,  "
							+ " Familymonthincome,Severaltimes,Falg4,Inputdate,Inputorgid,Inputuserid,Certtype,Customertype,Otherrevenue,SPOUSEWORKTEL,SPOUSEWORKCORP,selfmonthincome,COMMZIP,tempsaveflag,cellphoneverify,phonevalidate"
							+ " )=(select "
							+ " WORKTELPLUS,WORKTELAREACODE,WORKTELMAIN,Cellno,Certid,Community,Countryside,Customername,Familyadd,Familyzip,Issueinstitution,Maturitydate,Nativeplace,Plot,Room,  "
							+ " Sex,Street,Villagecenter,Villagetown,Flag2,Balancesheet,Childrentotal,Flag10,House,Kinshipadd,Kinshipname,   "
							+ " Kinshiptel,Marriage,Relativetype,Spousename,Spousetel,Alimony,Cellproperty,Employrecord,Unitcountryside,          "
							+ " Unitkind,Unitno,Unitroom,Unitstreet,Workadd,Workcorp,Workzip,Headship,Flag3,   "
							+ " Flag8,Commadd,Emailcountryside,Emailstreet,Emailplot,Emailroom,Emailadd,Familytel,   "
							+ " Mobiletelephone,Phoneman,Qqno,Wechat,Worktel,Contactrelation,Eduexperience,Jobtime,Jobtotal,Othercontact,Contacttel,  "
							+ " Familymonthincome,Severaltimes,Falg4,Inputdate,Inputorgid,Inputuserid,Certtype,Customertype,Otherrevenue,SPOUSEWORKTEL,SPOUSEWORKCORP,selfmonthincome,COMMZIP,'2',cellphoneverify,phonevalidate"
							+ " from  ind_info@APPLINK where customerID='"
							+ appCustomerID + "')  where customerID='" + appCustomerID
							+ "'";
					//IND_INFO_RECORD
					
					ARE.getLog().debug(OUT_PUT_LOG + "sql 1:" + sql);
					st.executeQuery(sql);
		            st.getConnection().commit();
		            //���¿ͻ���ʷ��
		            //���¿ͻ���ʷ��----begin
		            //add by daihuafeng,20150705
		            //�жϸÿͻ��Ƿ��Ѵ��ڣ������������»��ǲ���
		            record_sql = "select 1 from ind_info_record where SERIALNO='" + appContractSerialno + "' AND customerid='"+appCustomerID+"'";
		            ResultSet record_rs = st.executeQuery(record_sql);
		            if(record_rs.next()){
		            	record_update_sql = "UPDATE ind_info_record set( "
								+ " SERIALNO,WORKTELPLUS,WORKTELAREACODE,WORKTELMAIN,Cellno,Certid,Community,Countryside,Customername,Familyadd,Familyzip,Issueinstitution,Maturitydate,Nativeplace,Plot,Room,  "
								+ " Sex,Street,Villagecenter,Villagetown,Flag2,Balancesheet,Childrentotal,Flag10,House,Kinshipadd,Kinshipname,   "
								+ " Kinshiptel,Marriage,Relativetype,Spousename,Spousetel,Alimony,Cellproperty,Employrecord,Unitcountryside,          "
								+ " Unitkind,Unitno,Unitroom,Unitstreet,Workadd,Workcorp,Workzip,Headship,Flag3,   "
								+ " Flag8,Commadd,Emailcountryside,Emailstreet,Emailplot,Emailroom,Emailadd,Familytel,   "
								+ " Mobiletelephone,Phoneman,Qqno,Wechat,Worktel,Contactrelation,Eduexperience,Jobtime,Jobtotal,Othercontact,Contacttel,  "
								+ " Familymonthincome,Severaltimes,Falg4,Inputdate,Inputorgid,Inputuserid,Certtype,Customertype,Otherrevenue,SPOUSEWORKTEL,SPOUSEWORKCORP,selfmonthincome,COMMZIP,tempsaveflag"
								+ " )=(select "
								+ "'" + appContractSerialno + "',WORKTELPLUS,WORKTELAREACODE,WORKTELMAIN,Cellno,Certid,Community,Countryside,Customername,Familyadd,Familyzip,Issueinstitution,Maturitydate,Nativeplace,Plot,Room,  "
								+ " Sex,Street,Villagecenter,Villagetown,Flag2,Balancesheet,Childrentotal,Flag10,House,Kinshipadd,Kinshipname,   "
								+ " Kinshiptel,Marriage,Relativetype,Spousename,Spousetel,Alimony,Cellproperty,Employrecord,Unitcountryside,          "
								+ " Unitkind,Unitno,Unitroom,Unitstreet,Workadd,Workcorp,Workzip,Headship,Flag3,   "
								+ " Flag8,Commadd,Emailcountryside,Emailstreet,Emailplot,Emailroom,Emailadd,Familytel,   "
								+ " Mobiletelephone,Phoneman,Qqno,Wechat,Worktel,Contactrelation,Eduexperience,Jobtime,Jobtotal,Othercontact,Contacttel,  "
								+ " Familymonthincome,Severaltimes,Falg4,Inputdate,Inputorgid,Inputuserid,Certtype,Customertype,Otherrevenue,SPOUSEWORKTEL,SPOUSEWORKCORP,selfmonthincome,COMMZIP,'2'"
								+ " from ind_info@APPLINK where customerID='" + appCustomerID + "') " 
								+ " where SERIALNO='" + appContractSerialno + "' AND customerID='" + appCustomerID + "'";
						ARE.getLog().debug(OUT_PUT_LOG + "record_update_sql:" + record_update_sql);
						st.executeQuery(record_update_sql);
			            st.getConnection().commit();
		            }else{
		            	record_insert_sql = "insert into ind_info_record ( "
								+ " SERIALNO,customerID,WORKTELPLUS,WORKTELAREACODE,WORKTELMAIN,Cellno,Certid,Community,Countryside,Customername,Familyadd,Familyzip,Issueinstitution,Maturitydate,Nativeplace,Plot,Room,  "
								+ " Sex,Street,Villagecenter,Villagetown,Flag2,Balancesheet,Childrentotal,Flag10,House,Kinshipadd,Kinshipname,   "
								+ " Kinshiptel,Marriage,Relativetype,Spousename,Spousetel,Alimony,Cellproperty,Employrecord,Unitcountryside,          "
								+ " Unitkind,Unitno,Unitroom,Unitstreet,Workadd,Workcorp,Workzip,Headship,Flag3,   "
								+ " Flag8,Commadd,Emailcountryside,Emailstreet,Emailplot,Emailroom,Emailadd,Familytel,   "
								+ " Mobiletelephone,Phoneman,Qqno,Wechat,Worktel,Contactrelation,Eduexperience,Jobtime,Jobtotal,Othercontact,Contacttel,  "
								+ " Familymonthincome,Severaltimes,Falg4,Inputdate,Inputorgid,Inputuserid,Certtype,Customertype,Otherrevenue,SPOUSEWORKTEL,SPOUSEWORKCORP,selfmonthincome,COMMZIP,tempsaveflag"
								+ " )(select "
								+ "'" + appContractSerialno + "',customerID,WORKTELPLUS,WORKTELAREACODE,WORKTELMAIN,Cellno,Certid,Community,Countryside,Customername,Familyadd,Familyzip,Issueinstitution,Maturitydate,Nativeplace,Plot,Room,  "
								+ " Sex,Street,Villagecenter,Villagetown,Flag2,Balancesheet,Childrentotal,Flag10,House,Kinshipadd,Kinshipname,   "
								+ " Kinshiptel,Marriage,Relativetype,Spousename,Spousetel,Alimony,Cellproperty,Employrecord,Unitcountryside,          "
								+ " Unitkind,Unitno,Unitroom,Unitstreet,Workadd,Workcorp,Workzip,Headship,Flag3,   "
								+ " Flag8,Commadd,Emailcountryside,Emailstreet,Emailplot,Emailroom,Emailadd,Familytel,   "
								+ " Mobiletelephone,Phoneman,Qqno,Wechat,Worktel,Contactrelation,Eduexperience,Jobtime,Jobtotal,Othercontact,Contacttel,  "
								+ " Familymonthincome,Severaltimes,Falg4,Inputdate,Inputorgid,Inputuserid,Certtype,Customertype,Otherrevenue,SPOUSEWORKTEL,SPOUSEWORKCORP,selfmonthincome,COMMZIP,'2'"
								+ " from ind_info@APPLINK where customerID='" + appCustomerID + "')";
						ARE.getLog().debug(OUT_PUT_LOG + "record_insert_sql:" + record_insert_sql);
						st.executeQuery(record_insert_sql);
			            st.getConnection().commit();
		            }
		            if(record_rs != null){
		            	record_rs.close();
		            	record_rs = null;
		            }
		            //���¿ͻ���ʷ��----end
		          //ͬ��Э���assistinvestigate-----begin
		            //add by daihuafeng,20150705
		            //��ɾ����ǰ��ͬ�µ�Э��
		            assist_delete_sql = "delete from assistinvestigate where objectno='"+appContractSerialno+"'";
					ARE.getLog().debug(OUT_PUT_LOG + "Э��assist_delete_sql:" + assist_delete_sql);
					st.executeQuery(assist_delete_sql);
		            st.getConnection().commit();
		            //�����
		            assist_insert_sql = "insert into assistinvestigate("
		            		+ "SERIALNO,OBJECTNO,CHECKBANK,CHECKCONTENT,CHECKITEMS,CHECKPHONE,CHECKWORKTEL,"
		            		+ "CHECKCONTACTTEL,CHECKSINO,CHECKWORK,COMPANYWITH,CHECKPARTNER,PARTNERNAME,"
		            		+ "PHONEBRAND,PHONETYPE,PHONESTATUS,STORETOHOME,STORETOWORK,HOMETOWORK,REMARKS,"
		            		+ "PARTNERPHONE,TEMPSAVEFLAG,INPUTORG,INPUTUSER,INPUTDATE"
		            		+ ")(select "
		            		+ "SERIALNO,OBJECTNO,CHECKBANK,CHECKCONTENT,CHECKITEMS,CHECKPHONE,CHECKWORKTEL,"
		            		+ "CHECKCONTACTTEL,CHECKSINO,CHECKWORK,COMPANYWITH,CHECKPARTNER,PARTNERNAME,"
		            		+ "PHONEBRAND,PHONETYPE,PHONESTATUS,STORETOHOME,STORETOWORK,HOMETOWORK,REMARKS,"
		            		+ "PARTNERPHONE,TEMPSAVEFLAG,INPUTORG,INPUTUSER,INPUTDATE "
		            		+ "from assistinvestigate@applink where objectno='"+appContractSerialno+"')";
					ARE.getLog().debug(OUT_PUT_LOG + "Э��assist_insert_sql:" + assist_insert_sql);
					st.executeQuery(assist_insert_sql);
		            st.getConnection().commit();
		            //ͬ��Э���assistinvestigate-----end
					System.out.println("---���¿ͻ���Ϣ��sucess---");
		
					System.out.println("---����绰�ֿ�---");
					doPhoneInfoFromIndInfo(appCustomerID);
					System.out.println("---���º�ͬ��---");
		
					sql = "UPDATE business_contract set( "
							+ " Dsm,Suretype,Businessrange1,Businesstype,Businesstype1,Manufacturer1,Creditcycle,Annotation,Totalsum,Totalsum1,Businesscurrency,  "
							+ " Operateorgid,Operateuserid,Inputorgid,Inputdate,Inputuserid,Price1,Businesssum,Totalprice,Periods,Repaymentway,   "
							+ " Replaceaccount,Openbank,Replacename,Repaymentno,Repaymentbank,Repaymentname,Stores,Salesexecutive,Falg6,          "
							+ " Interiorcode,Productname,Paymentrate,Landmarkstatus,Productid,Customertype,Creditattribute,Certid,Certtype,city,SubProductType"
							+ " ,tempsaveflag)=(select "
							+ " Dsm,Suretype,Businessrange1,Businesstype,Businesstype1,Manufacturer1,Creditcycle,Annotation,Totalsum,Totalsum1,Businesscurrency,  "
							+ " Operateorgid,Operateuserid,Inputorgid,Inputdate,Inputuserid,Price1,Businesssum,Totalprice,Periods,Repaymentway,   "
							+ " Replaceaccount,Openbank,Replacename,Repaymentno,Repaymentbank,Repaymentname,Stores,Salesexecutive,Falg6,          "
							+ " Interiorcode,Productname,Paymentrate,Landmarkstatus,Productid,Customertype,Creditattribute,Certid,Certtype,city,'0','2'"
							+ " from  business_contract@APPLINK where serialno='"
							+ appContractSerialno + "')  where serialno='"
							+ appContractSerialno + "'";
					ARE.getLog().debug(OUT_PUT_LOG + "sql 2:" + sql);
					System.out.println("-------->" + sql);
	
					st.executeQuery(sql);
					
					st.executeQuery(sql);
					st.getConnection().commit();
					
					System.out.println("---�����ͬ�����---");
					// ����绰�ֿ�
		
					System.out
							.println("-----------------------����ͬ���ɹ�-----------------");
		
					sql = "select BelongOrg from user_info where userid='" + sUserID
							+ "'";
					ARE.getLog().debug(OUT_PUT_LOG + "sql 3:" + sql);
					ResultSet rs1 = st.executeQuery(sql);
					if (rs1.next()) {
						orgID = rs1.getString("BelongOrg");
					}
					accountDeposit();
					SetBusinessMaturity();
					// ��ʼ������
		
					// ��ȡflowtask��Ϣ
					sql = "select phaseno,serialno,objecttype,flowno from flow_task where serialno in(select max(serialno) from flow_task where objectno='"
							+ appContractSerialno + "')";
					ARE.getLog().debug(OUT_PUT_LOG + "sql 4:" + sql);
					ResultSet rs = st.executeQuery(sql);
					if (rs.next()) {
		
						serialNo = rs.getString("serialno");
						objectType = rs.getString("objectType");
						oldPhaseNos = rs.getString("phaseno");
						flowNo = rs.getString("flowno");
		
					}
					System.out.println("*************************serialno:" + serialNo);
					System.out.println("*************************objectType:"
							+ objectType);
					System.out.println("*************************objectType:"
							+ oldPhaseNos);
					System.out.println("*************************flowNo:" + flowNo);
					rs.close();
		
					 sql="update flow_task set flow_task.PhaseOpinion4=to_char(sysdate,'yyyy/MM/dd HH:mm:ss') where flow_task.serialNo='"+serialNo+"' AND flow_task.phaseno='0010' AND flow_task.objecttype='BusinessContract'";
	                 ARE.getLog().debug(OUT_PUT_LOG + "sql 5:" + sql);
	                 st.executeQuery(sql);
	                 
					//���ù�������
					/*FlowAction fa = new FlowAction();
					fa.setFlowNo(flowNo);
					fa.setSerialNo(serialNo);
					fa.setObjectType(objectType);
					fa.setOldPhaseNo(oldPhaseNos);
					fa.setObjectNo(appContractSerialno);
					fa.setUserID(sUserID);
		
					returnValue = fa.AutoCommitWithRule(Sqlca);*/
					
	                 //add by yongxu 20150714 ����������÷���
					InsertAutoRuleAction ruleAction = new InsertAutoRuleAction(); 
					ruleAction.setSerialNo(appContractSerialno);
					ruleAction.updateBusinssConByserialNo(Sqlca);
					//add end
					
					
					//update flow_task 
					//select flow_task.PhaseOpinion4 from xdgl.flow_task where objectno='20316883001' AND flow_task.phaseno='0010' AND flow_task.objecttype='BusinessContract' for update 
                   
                   /*if(returnValue.equals("RuleError"))
                   {
                	  //�ظ��ύ����
                	  returnValue = fa.AutoCommitWithRule(Sqlca); 
                   }
                   if(returnValue.equals("RuleError"))
                   {
                	  //�ظ��ύ����
                	  returnValue = fa.AutoCommitWithRule(Sqlca); 
                   }
					
					if (returnValue.equals("Success")) {
		
						sql = "update  business_contract set CONTRACTSTATUS='070'  where  SerialNo='"
								+ appContractSerialno + "'";
						ARE.getLog().debug(OUT_PUT_LOG + "sql 6:" + sql);
						st.executeQuery(sql);
						System.out
								.println("=====================================returnValue=>"
										+ returnValue);
					} else if (returnValue.equals("Working")) {
		
						sql = "update  business_contract set CONTRACTSTATUS='070'  where  SerialNo='"
								+ appContractSerialno + "'";
						ARE.getLog().debug(OUT_PUT_LOG + "sql 7:" + sql);
						st.executeQuery(sql);
						System.out
								.println("=====================================returnValue=>"
										+ returnValue);
					} else if (returnValue.equals("Failure9000")) {
		
						sql = "update  business_contract set CONTRACTSTATUS='100'  where  SerialNo='"
								+ appContractSerialno + "'";
						ARE.getLog().debug(OUT_PUT_LOG + "sql 8:" + sql);
						st.executeQuery(sql);
						System.out
								.println("=====================================returnValue=>"
										+ returnValue);
					} else {
						sql = "update  business_contract set CONTRACTSTATUS='010'  where  SerialNo='"
								+ appContractSerialno + "'";
						ARE.getLog().debug(OUT_PUT_LOG + "sql 9:" + sql);
						st.executeQuery(sql);
						System.out
								.println("=====================================returnValue=>"
										+ returnValue);
					}*/
					
				}else {
				}
				if(Sqlca!=null)
					Sqlca.commit();
				if(st!=null)
					st.close();
				if(conn!=null)
					conn.commit();
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				ARE.getLog().debug(OUT_PUT_LOG + "Exception e:" + e.getMessage());
				if (Sqlca != null)
					try {
						Sqlca.rollback();
					} catch (SQLException exc) {
						exc.printStackTrace();
					}
			} finally {
				if(Sqlca!=null)
					try {
						
						Sqlca.disConnect();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				if (conn != null)
					try {
						if(!conn.isClosed())
						{
							conn.close();	
						}
						
					} catch (SQLException e) {
						e.printStackTrace();
					}
				
				

			}
		}
		/**
		 * ��ͬ����Ϊ��ͬ��Ч
		 * 
		 * @throws Exception
		 */
		@SuppressWarnings("deprecation")
		private void SetBusinessMaturity() throws Exception {
			ARE.getLog().debug(OUT_PUT_LOG+"SetBusinessMaturity begin");
			// �״λ�����
			String sFirstDueDate = "";
			String sDefaultDueDay = "";
			String temDay = "";
			String sSpecialDay = "";// �Ƿ����ⷢ����
			int iDaytemp = 0;
			//String businessDate = SystemConfig.getBusinessDate();
			String businessDate = DateX.format(new java.util.Date(), "yyyy/MM/dd");
			
			temDay = businessDate.substring(8, 10);
			if (temDay.equals("29")) {
				temDay = "02";
				sDefaultDueDay = DateFunctions.getRelativeDate(businessDate,
						DateFunctions.TERM_UNIT_MONTH, 2);
				sFirstDueDate = sDefaultDueDay.substring(0, 8) + temDay;
				sSpecialDay = "1";
			} else if (temDay.equals("30")) {
				temDay = "03";
				sDefaultDueDay = DateFunctions.getRelativeDate(businessDate,
						DateFunctions.TERM_UNIT_MONTH, 2);
				sFirstDueDate = sDefaultDueDay.substring(0, 8) + temDay;
				sSpecialDay = "1";
			} else if (temDay.equals("31")) {
				temDay = "04";
				sDefaultDueDay = DateFunctions.getRelativeDate(businessDate,
						DateFunctions.TERM_UNIT_MONTH, 2);
				sFirstDueDate = sDefaultDueDay.substring(0, 8) + temDay;
				sSpecialDay = "1";
			} else {
				sFirstDueDate = DateFunctions.getRelativeDate(businessDate,
						DateFunctions.TERM_UNIT_MONTH, 1);
			}
			iDaytemp = DateFunctions.getDays(DateFunctions.getRelativeDate(
					businessDate, DateFunctions.TERM_UNIT_MONTH, 1), sFirstDueDate);

			// һ���ͻ������ͬ��������ж��״λ����գ�ȡ�ͻ�֮ǰ����ĺ�ͬ
			String sFirstNextDueDate = "";
			int sDays = 0;
			String minSerialNo = Sqlca
					.getString(new SqlObject(
							"SELECT min(serialno) FROM business_contract where finishdate is null and CONTRACTSTATUS = '050' and customerid = :CustomerID and serialno <> :serialno ")
							.setParameter("CustomerID", customerId).setParameter(
									"serialno", customerId));
			if (minSerialNo == null)
				minSerialNo = "";
			if (!minSerialNo.equals("")) {
				sFirstNextDueDate = Sqlca
						.getString(new SqlObject(
								"SELECT NEXTDUEDATE FROM acct_loan where loanstatus in ('0','1') and putoutno = :minSerialNo ")
								.setParameter("minSerialNo", minSerialNo));
				if (sFirstNextDueDate == null)
					sFirstNextDueDate = "";
				if (!sFirstNextDueDate.equals("")) {
					sDays = DateFunctions.getDays(businessDate, sFirstNextDueDate);
					if (sDays >= 14) {
						sFirstDueDate = sFirstNextDueDate;
					} else {
						sFirstDueDate = DateFunctions
								.getRelativeDate(sFirstNextDueDate,
										DateFunctions.TERM_UNIT_MONTH, 1);
					}
					temDay = sFirstDueDate.substring(8, 10);
				}
			}
			Sqlca.executeSQL("update acct_rpt_segment a set a.firstduedate='"
					+ sFirstDueDate + "' where objectno='" + SerialNo + "' ");
			ARE.getLog().debug(OUT_PUT_LOG+"SetBusinessMaturity sql"+"update acct_rpt_segment a set a.firstduedate='"
					+ sFirstDueDate + "' where objectno='" + SerialNo + "' ");
			Sqlca.commit();
			ARE.getLog().debug(OUT_PUT_LOG+"SetBusinessMaturity end");
		}

		/**
		 * �ʻ���Ϣ
		 * 
		 * @param RepaymentWay
		 * @param str
		 * @throws Exception
		 */
		@SuppressWarnings("deprecation")
		private void accountDeposit() throws Exception {
			ARE.getLog().debug(
					OUT_PUT_LOG + "accountDeposit begin");
			// �ۿ��˻���Ϣ
			if (RepaymentWay == "1") {
				String accountIndicator1 = "01";// �ۿ�
				// ��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
				Double sReturn1 = Sqlca.getDouble(new SqlObject(
						"select count(*) from ACCT_DEPOSIT_ACCOUNTS where ObjectNo='"
								+ ObjectNo + "' and ObjectType='"
								+ BUSINESSOBJECT_CONSTATNTS.business_contract
								+ "' and AccountIndicator = '" + accountIndicator1
								+ "' and status = '0'"));
				ARE.getLog().debug(
						OUT_PUT_LOG + "accountDeposit �Ƿ����:"+sReturn1);
				if (sReturn1 > 0.0) {
					UpdateColValue updateColvalue = new UpdateColValue();
					updateColvalue
							.setAttribute("ColName", "String@accountno@"
									+ ReplaceAccount + "@String@accountname@"
									+ ReplaceName);
					updateColvalue.setAttribute("TableName",
							"acct_deposit_accounts");
					updateColvalue
							.setAttribute(
									"WhereClause",
									"String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"
											+ ObjectNo);
					updateColvalue.run(Sqlca);

				} else {
					String sql = "insert into acct_deposit_accounts (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS)"
							+ "values ('"
							+ SerialNo
							+ "', '"
							+ ObjectNo
							+ "', 'jbo.app.BUSINESS_CONTRACT', '01', '"
							+ AccountName
							+ "', '01', '"
							+ AccountName
							+ "', '2', '1', '', '01', '0')";
					Sqlca.executeSQL(sql);

				}
			} else // �Ǵ���
			{
				String accountIndicator2 = "01";// �ۿ�
				// ��ѯ�ñʺ�ͬ�����Ŀۿ�Ƿ����
				Double sReturn2 = Sqlca.getDouble(new SqlObject(
						"select count(*) from ACCT_DEPOSIT_ACCOUNTS where ObjectNo='"
								+ ObjectNo + "' and ObjectType='"
								+ BUSINESSOBJECT_CONSTATNTS.business_contract
								+ "' and AccountIndicator = '" + accountIndicator2
								+ "' and status = '0'"));
				if (sReturn2 > 0.0) {
					UpdateColValue updateColvalue = new UpdateColValue();
					updateColvalue
							.setAttribute("ColName", "String@accountno@"
									+ ReplaceAccount + "@String@accountname@"
									+ ReplaceName);
					updateColvalue.setAttribute("TableName",
							"acct_deposit_accounts");
					updateColvalue
							.setAttribute(
									"WhereClause",
									"String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"
											+ ObjectNo);
					updateColvalue.run(Sqlca);
					// RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);

				} else {
					String paymentSerialNo = getSeriaNo("ACCT_DEPOSIT_ACCOUNTS",
							"SerialNo");
					String sql = "insert into acct_deposit_accounts (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS) "
							+ "values ('"
							+ SerialNo
							+ "', '"
							+ ObjectNo
							+ "', 'jbo.app.BUSINESS_CONTRACT', '01', '"
							+ AccountName
							+ "', '01', '"
							+ AccountName
							+ "', '2', '1', '', '01', '0')";
					Sqlca.executeSQL(sql);
				}
				// �ſ��ʻ�
				String accountIndicator = "00";// �ſ�
				// ��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
				Double sReturn3 = Sqlca.getDouble(new SqlObject(
						"select count(*) from ACCT_DEPOSIT_ACCOUNTS where ObjectNo='"
								+ ObjectNo + "' and ObjectType='" + ObjectType
								+ "' and AccountIndicator = '" + accountIndicator
								+ "' and status = '0'"));
				
				ReplaceName = "���Ѵ��ͻ�";// �ſ��ʺ���
				ReplaceAccount = "XFD" + ObjectNo;// �ۿ��˺�
				ARE.getLog().debug(
						OUT_PUT_LOG + "accountDeposit �ſ��ʺ�:"+sReturn3);
				if (sReturn3 > 0) {
					UpdateColValue updateColvalue = new UpdateColValue();
					updateColvalue.setAttribute("ColName", "String@OBJECTNO@"
							+ ObjectNo);
					updateColvalue.setAttribute("TableName",
							"acct_deposit_accounts");
					updateColvalue.setAttribute("WhereClause",
							"String@accountname@" + ReplaceAccount
									+ "@String@accountno@" + ReplaceName);
					updateColvalue.run(Sqlca);
					// RunMethod("PublicMethod",
					// RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+ReplaceAccount+"@String@accountno@"+ReplaceName);

				} else {
					String AccountSerialNo = getSeriaNo("ACCT_DEPOSIT_ACCOUNTS",
							"SerialNo");
					CreateAccount createAccount = new CreateAccount();
					createAccount.setAttribute("SerialNo", AccountSerialNo);
					createAccount.setAttribute("AccountIdicator", AccountIdicator);
					createAccount.setAttribute("AccountNo", AccountNo);
					createAccount.setAttribute("AccountName", AccountName);
					createAccount.setAttribute("ObjectNo", ObjectNo);
					createAccount.setAttribute("ObjectType", ObjectType);


					createAccount.run(Sqlca);
				}
				if(Sqlca.getTransaction()!=null)
				{
					Sqlca.getTransaction().commit();
				}
				
			}
			ARE.getLog().debug(
					OUT_PUT_LOG + "accountDeposit end");
		}

		private String getSeriaNo(String sTableName, String sColumnName)
				throws Exception {
			/*
			 * Content: ��ȡ��ˮ�� Input Param: ����: TableName ����: ColumnName ��ʽ��
			 * SerialNoFormate Output param: ��ˮ��: SerialNo
			 */
			// ��ȡ�����������͸�ʽ

			String sSerialNo = ""; // ��ˮ��

			sSerialNo = DBKeyHelp.getSerialNo(sTableName, sColumnName, Sqlca);
			return sSerialNo;
		}

		
		
		// �жϿ������Ƿ��к�ͬ��Ϣ��ͻ�
		public boolean toCustomerID(String customerid) {
			boolean flag = false;
			Connection conn = null;
			String sql = "";
			String temp = "";
			Statement st=null;
			try {
				conn = ARE.getDBConnection(FinalNum.DATASOUTCENEW);
				 st = conn.createStatement();
				sql = "select count(1) as count from customer_info where customerid='"
						+ customerid + "'";
				ResultSet rs = st.executeQuery(sql);
				if (rs.next()) {
					temp = rs.getString("count");
					if (temp.equals("1")) {
						flag = true;
					}
				}
				st.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (conn != null)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				if(st!=null){
					try {
						if(!st.isClosed()){
							st.close();
						}
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			return flag;
		}

		// �ж�app�ͻ����ͬ�Ƿ����
		public String getContract(String sContractSerialno) {
			Connection conn = null;
			String sql = "";
			String customerID = "null";
			Statement st=null;
			try {
				conn = ARE.getDBConnection(FinalNum.DATASOUTCENEW);
				st= conn.createStatement();
				sql = "select customerid  from business_contract bc where serialno='"
						+ sContractSerialno + "'";
				ResultSet rs = st.executeQuery(sql);
				while (rs.next()) {
					customerID = rs.getString("customerid");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (conn != null)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				
				if(st!=null){
					try {
						if(!st.isClosed()){
							st.close();
						}
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			return customerID;
		}

		// ƴ��ĳ���е��ֶ�
		public String appendColName1(String tableName, String dataSource) {
			StringBuffer sb = new StringBuffer();
			String colName = "";
			Connection conn = null;
			String sql = "";
			Statement st=null;
			try {
				conn = ARE.getDBConnection(dataSource);
				 st= conn.createStatement();
				sql = "SELECT  column_name  FROM   USER_TAB_COLS   WHERE   TABLE_NAME ='"
						+ tableName + "'";
				ResultSet rs = st.executeQuery(sql);
				while (rs.next()) {
					sb.append(rs.getString("column_name") + ",");
				}
				colName = sb.toString().substring(0, sb.toString().length() - 1);
				rs.close();
				st.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (conn != null)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				if(st!=null){
					try {
						if(!st.isClosed()){
							st.close();
						}
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}

			return colName;
		}

		// ƴ��ĳ�����ֶζ�Ӧֵ
		public String appendColValues1(String tableName, String pkName,
				String pkValue, String dataSource) {
			StringBuffer sb = new StringBuffer();
			Connection conn = null;
			String sql = "";
			String sql1 = "";
			String colName = appendColName1(tableName, dataSource);// ����
			String colValues = "";
			String colValueses = "";
			Statement st=null;
			try {
				conn = ARE.getDBConnection(dataSource);
				st = conn.createStatement();
				sql = "SELECT  " + colName + "  FROM " + tableName + " where "
						+ pkName + "='" + pkValue + "'";
				ResultSet rs = st.executeQuery(sql);

				if (rs.next()) {
					Statement st1 = conn.createStatement();
					sql1 = "SELECT  column_name  FROM   USER_TAB_COLS   WHERE   TABLE_NAME ='"
							+ tableName + "'";
					ResultSet rs1 = st1.executeQuery(sql1);
					while (rs1.next()) {
						String colNameValue = rs1.getString("column_name");
						colValueses = rs.getString(colNameValue);
						System.out.println(colValueses);
						sb.append(colValueses == null ? "''," : "'" + colValueses
								+ "',");
					}
					colValues = sb.toString().substring(0,
							sb.toString().length() - 1);
					rs1.close();
				} else {
					colValues = "null";
				}
				rs.close();
				st.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (conn != null)
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				
				if(st!=null){
					try {
						if(!st.isClosed()){
							st.close();
						}
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			return colValues;
		}

		/**
		 * 01�ֻ����� 02סլ�绰 03�칫/ѧУ/����绰 04��ż�绰���� 05������ϵ�绰 06��ϵ�˵绰
		 */
		public void doPhoneInfoFromIndInfo(String customerId) throws Exception {
			ARE.getLog().debug(OUT_PUT_LOG + "doPhoneInfoFromIndInfo begin");
			String sSql = "select Mobiletelephone,Familytel,Worktel,SpouseTel,KinshipTel,Contacttel from ind_info where customerID=:customerId";
			ARE.getLog().debug(OUT_PUT_LOG + "sql 1:"+sSql);
			
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter(
					"customerId", customerId));
			String mobiletelephone, familytel, worktel, spousetel, kinshiptel, contacttel;
			if (rs.next()) {

				mobiletelephone = rs.getString("Mobiletelephone");
				if (mobiletelephone != null && !mobiletelephone.equals("")) {
					addPhoneInfo(customerId, mobiletelephone, "010");
				}
				familytel = rs.getString("Familytel");
				if (familytel != null && !familytel.equals("")) {
					addPhoneInfo(customerId, familytel, "020");
				}
				worktel = rs.getString("Worktel");
				if (worktel != null && !worktel.equals("")) {
					addPhoneInfo(customerId, worktel, "030");
				}
				spousetel = rs.getString("SpouseTel");
				if (spousetel != null && !spousetel.equals("")) {
					addPhoneInfo(customerId, spousetel, "040");
				}
				kinshiptel = rs.getString("KinshipTel");
				if (kinshiptel != null && !kinshiptel.equals("")) {
					addPhoneInfo(customerId, kinshiptel, "050");
				}
				contacttel = rs.getString("Contacttel");
				if (contacttel != null && !contacttel.equals("")) {
					addPhoneInfo(customerId, contacttel, "060");
				}

			}
			if(rs != null){
				rs.close();
				rs = null; 
			}
	        Sqlca.commit();
	        Sqlca.getTransaction().commit();
	        ARE.getLog().debug(OUT_PUT_LOG + "doPhoneInfoFromIndInfo end");
		}

		@SuppressWarnings("deprecation")
		private void addPhoneInfo(String customerId, String phoneCode,
				String relation) throws Exception {
			ARE.getLog().debug(OUT_PUT_LOG + "addPhoneInfo begin");
			// ȡ����ˮ��
			/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
			String serialNo = getSeriaNo("Phone_Info", "SerialNo");*/
			String serialNo = DBKeyUtils.getSerialNo("PI");
			/** --end --*/
			// ����绰���绰�ֿ�
			String sSql = "insert into phone_info(serialno,customerid,phonecode,relation) values('"
					+ serialNo
					+ "','"
					+ customerId
					+ "','"
					+ phoneCode
					+ "','"
					+ relation + "')";
			ARE.getLog().debug(OUT_PUT_LOG + "addPhoneInfo sql:"+sSql);
			Sqlca.executeSQL(sSql);
			// Sqlca.getTransaction().commit();
		}
			

	}
}
