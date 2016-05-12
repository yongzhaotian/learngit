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
 * 对于从任务池获取，但未审核过的业务，过X小时自动返回任务池:
 * 即  把 与已获取任务的记录相同阶段的所有记录的flowState设置为null
 * @author Administrator
 *
 */
public class WithdrawTaskServlet extends HttpServlet {
	
	String dbname ;
	// 获取到任务, 但一直未审核的任务
	String sql = "select * from flow_task where flowNo = 'CarFlow' and endTime is null and taskState='1' ";
	//返回任务池的sql, 即把taskState的状态设置为null
	String updateSql = "update FLOW_TASK set taskState =null where serialNo =:serialNo ";
	
	@Override
	public void init() throws ServletException {
		super.init();
		// 数据库连接名( als7c.xml中DataSource)
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
