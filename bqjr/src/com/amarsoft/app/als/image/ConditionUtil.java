package com.amarsoft.app.als.image;

import java.sql.SQLException;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ConditionUtil {
private String startWithId ;
	
private String Filetype;

	public String GetNewTypeNo( Transaction sqlca ) throws SQLException{
		String sRes = "", sFilter = "";
		sFilter = "'"+ startWithId + "'";
		String sMax = sqlca.getString( new SqlObject( "Select Max(TypeNo) From CONDITION_TYPE Where fileType = "+sFilter ) );
		if( sMax != null && sMax.length() != 0 ){
			sRes = String.valueOf( Integer.parseInt( sMax ) + 1 );
		}else{
			return startWithId;
		}
		return sRes;
	}

	public void UpdateCondition(Transaction sqlca){
		System.out.println(Filetype);
		String sql ="update CONDITION_TYPE t set t.Filetype='"+Filetype+"'  where t.TypeNo='"+startWithId+"'";
		System.out.println("¸üÐÂSQL=========="+sql);
		try {
			sqlca.executeSQL(new SqlObject(sql));
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}

	
	public String getFiletype() {
		return Filetype;
	}

	public void setFiletype(String filetype) {
		Filetype = filetype;
	}

	public String getStartWithId() {
		return startWithId;
	}
	public void setStartWithId(String startWithId) {
		this.startWithId = startWithId;
	}
}
