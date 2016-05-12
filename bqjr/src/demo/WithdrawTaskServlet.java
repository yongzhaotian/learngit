package demo;

import java.sql.SQLException;
import java.util.Date;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
/**
 * ���ڴ�����ػ�ȡ����δ��˹���ҵ�񣬹�XСʱ�Զ����������:
 * ��  �� ���ѻ�ȡ����ļ�¼��ͬ�׶ε����м�¼��flowState����Ϊnull
 * @author Administrator
 *
 */
public class WithdrawTaskServlet extends HttpServlet {
	
	String dbname ;
	// ��ȡ������, ��һֱδ��˵�����
	String sql = "select * from flow_task where flowNo = 'CarFlow' and endTime is null and taskState='1' ";
	//��������ص�sql, ����taskState��״̬����Ϊnull
	String updateSql = "update FLOW_TASK set taskState =null where serialNo =:serialNo ";
	
	@Override
	public void init() throws ServletException {
		super.init();
		// ���ݿ�������( als7c.xml��DataSource)
		try {
			dbname = Configure.getInstance(this.getServletContext()).getConfigure("DataSource");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Executors.newScheduledThreadPool(1).scheduleWithFixedDelay(new Runnable() {
			
			@Override
			public void run() {
				
				Transaction sqlca = new Transaction(dbname);
				//TODO 
				/*try{
					sqlca.getASResultSet(new SqlObject(sql));
					sqlca.commit();
				}catch(Exception e){
					try {
						sqlca.rollback();
					} catch (SQLException e1) {
						e1.printStackTrace();
					}
				}finally{
					
				}*/
				ARE.getLog().trace("*****"+DateX.format(new Date(),"yyyy/MM/dd HH:mm:ss"));
			}
		},
		1, 6, TimeUnit.MINUTES);
	}
}
