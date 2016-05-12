package com.amarsoft.awe.util;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.LocalTransaction;
import com.amarsoft.are.jbo.ShareTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.security.AppContext;
import com.amarsoft.are.util.SpecialTools;
import java.io.PrintStream;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Transaction
  implements ShareTransaction, Serializable
{
  private static final long serialVersionUID = 1L;
  private String dbname = "als";
  private JBOTransaction tx = null;

  private Connection conn = null;

  public static int iChange = 0;
  public static int iDebugMode = 1;
  public static int iStatementMode = 1;

  public static int iResultSetType = 1004;
  public static int iResultSetConcurrency = 1007;
  public static final int FETCH_FORWARD = 1000;
  public static final int FETCH_REVERSE = 1001;
  public static final int FETCH_UNKNOWN = 1002;
  public static final int TYPE_FORWARD_ONLY = 1003;
  public static final int TYPE_SCROLL_INSENSITIVE = 1004;
  public static final int TYPE_SCROLL_SENSITIVE = 1005;
  public static final int CONCUR_READ_ONLY = 1007;
  public static final int CONCUR_UPDATABLE = 1008;
  private static double WARNING_TIME = 0.4D;

  private boolean LOG_EXECUTE = false;
  private boolean LOG_SELECT = false;

  private Date dBeginTime = new Date();
  private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
  private static DecimalFormat df = new DecimalFormat("#0.000#");
  private static DecimalFormat df_num = new DecimalFormat("#000");

  public static Transaction createTransaction(JBOTransaction tx)
    throws JBOException
  {
    Transaction trans = null;
    if ((tx instanceof JBOTransaction)) {
      String db = ((LocalTransaction)tx).getDatabase();
      if (db == null) throw new JBOException("活动的JBO事务才能获取数据库连接！");
      trans = new Transaction(db);
      tx.join(trans);
    } else {
      throw new JBOException("LocalTransaction类型的JBOTransaction才能获取数据库连接！");
    }
    return trans;
  }

  public Transaction(String dbname)
  {
    this.dbname = dbname;
  }

  /** @deprecated */
  public Transaction(Connection connection)
    throws Exception
  {
    this.conn = connection;
    if (this.conn.getAutoCommit()) this.conn.setAutoCommit(false); 
  }

  public ASResultSet getResultSet(String s) throws Exception {
    return getASResultSet(s);
  }

  public ASResultSet getResultSet(SqlObject asql) throws Exception {
    return getASResultSet(asql);
  }

  public ASResultSet getASResultSet(String s) throws Exception {
    if (iStatementMode == 1) {
      return getASResultSetPrepare(s, true);
    }
    return getASResultSetStatic(s, true);
  }

  public ASResultSet getASResultSet(SqlObject asql)
    throws SQLException
  {
    PreparedStatement pst = null;
    ResultSet rs = null;
    try
    {
      setDebugTime();
      pst = getConnectionIn().prepareStatement(asql.getRunSql());
      asql.bindParameter(pst);
      rs = pst.executeQuery();
      return new ASResultSet(iChange, rs);
    } catch (SQLException e) {
      ARE.getLog().error(e.getMessage(), e);
      if (rs != null)
        rs.close();
      if (pst != null)
        pst.close();
      throw e;
    } finally {
      DebugSQL(asql);
    }
  }

  public ASResultSet getASResultSetStatic(String s, boolean bConvert)
    throws Exception
  {
    if (bConvert) {
      if ((iChange == 1) && (s != null))
        s = new String(s.getBytes("GBK"), "ISO8859_1");
      if ((iChange == 3) && (s != null))
        s = new String(s.getBytes("ISO8859_1"), "GBK");
      s = SpecialTools.amarsoft2DB(s);
    }

    Statement statement = null;
    ResultSet rs = null;
    try {
      setDebugTime();
      statement = getConnectionIn().createStatement(iResultSetType, iResultSetConcurrency);
      rs = statement.executeQuery(s);
      if (this.LOG_SELECT) log(s, "SELECT");
      return new ASResultSet(iChange, rs);
    } catch (Exception e) {
      ARE.getLog().error(e.getMessage(), e);
      if (rs != null)
        rs.close();
      if (statement != null)
        statement.close();
      throw e;
    } finally {
      DebugSQL(s);
    }
  }

  private ASResultSet getASResultSetPrepare(String s, boolean bConvert)
    throws Exception
  {
    int ipos = s.toLowerCase().lastIndexOf(" from ");
    if (ipos == -1) {
      return getASResultSetStatic(s, bConvert);
    }

    if (bConvert) {
      if ((iChange == 1) && (s != null))
        s = new String(s.getBytes("GBK"), "ISO8859_1");
      if ((iChange == 3) && (s != null))
        s = new String(s.getBytes("ISO8859_1"), "GBK");
      s = SpecialTools.amarsoft2DB(s);
    }

    PreparedStatement statement = null;
    ResultSet rs = null;
    StringBuffer sql = new StringBuffer(s.substring(0, ipos + 4));
    try
    {
      int iCont = 0;
      setDebugTime();
      String[] r = s.substring(ipos + 4).split("'", -1);
      for (int i = 0; i < r.length; i += 2)
        if (i <= r.length - 2) {
          sql.append(r[i]);
          sql.append("? ");
          iCont++;
        } else {
          sql.append(r[i]);
        }
      statement = getConnectionIn().prepareStatement(sql.toString(), iResultSetType, iResultSetConcurrency);
      for (int iC = 1; iC <= iCont; iC++) {
        statement.setString(iC, r[(2 * iC - 1)]);
      }
      rs = statement.executeQuery();
      if (this.LOG_SELECT)
        log(s, "SELECT");
      return new ASResultSet(iChange, rs);
    }
    catch (Exception ex)
    {
      int iC;
      Statement statement1 = null;
      try {
        ARE.getLog().warn(ex.getMessage(), ex);
        ARE.getLog().warn("PrepareSql ERR[" + sql + "]");
        if (rs != null)
          rs.close();
        setDebugTime();
        statement1 = getConnection().createStatement(iResultSetType, iResultSetConcurrency);
        rs = statement1.executeQuery(s);
        if (this.LOG_SELECT)
          log(s, "SELECT");
        return new ASResultSet(iChange, rs);
      } catch (Exception e) {
        System.out.println(e.getMessage());
        if (rs != null)
          rs.close();
        if (statement != null)
          statement.close();
        if (statement1 != null)
          statement1.close();
        throw e;
      }
    } finally {
      DebugSQL(sql + "]AUTOPRE[" + s);
    }
  }

  /** @deprecated */
  public int executeSQL(String s)
    throws Exception
  {
    s = convertAmarStr2DBStr(s);

    Statement statement = null;
    try {
      setDebugTime();
      statement = getConnectionUpd().createStatement(iResultSetType, iResultSetConcurrency);
      int i = statement.executeUpdate(s);
      if (this.LOG_EXECUTE) log(s, "EXECUTE");
      statement.close();
      return i;
    } catch (Exception e) {
      ARE.getLog().error(e.getMessage(), e);
      if (statement != null)
        statement.close();
      throw e;
    } finally {
      DebugSQL(s);
    }
  }

  public int executeSQL(SqlObject asql)
    throws Exception
  {
    PreparedStatement pst = null;
    try {
      setDebugTime();
      pst = getConnectionUpd().prepareStatement(asql.getRunSql());
      asql.bindParameter(pst);
      int i = pst.executeUpdate();
      return i;
    } catch (Exception e) {
      ARE.getLog().error(e.getMessage(), e);
      throw e;
    } finally {
      if (pst != null) pst.close();
      DebugSQL(asql);
    }
  }

  public ASResultSet getResultSet2(String s) throws Exception {
    return getASResultSet(s);
  }

  public ASResultSet getASResultSet2(String s) throws Exception {
    if ((iChange == 1) && (s != null))
      s = new String(s.getBytes("GBK"), "ISO8859_1");
    if ((iChange == 3) && (s != null))
      s = new String(s.getBytes("ISO8859_1"), "GBK");
    s = SpecialTools.amarsoft2DB(s);
    Statement statement = null;
    ResultSet rs = null;
    try {
      setDebugTime();
      statement = getConnectionIn().createStatement(1003, 1007);
      rs = statement.executeQuery(s);
      if (this.LOG_SELECT) log(s, "SELECT");
      return new ASResultSet(iChange, rs);
    } catch (Exception e) {
      ARE.getLog().error(e.getMessage(), e);
      if (rs != null)
        rs.close();
      if (statement != null)
        statement.close();
      throw e;
    } finally {
      DebugSQL(s);
    }
  }

  public ASResultSet getASResultSetForUpdate(String s) throws Exception {
    s = convertAmarStr2DBStr(s);
    Statement statement = null;
    ResultSet rs = null;
    try {
      setDebugTime();
      statement = getConnectionUpd().createStatement(1003, 1008);
      rs = statement.executeQuery(s);
      if (this.LOG_SELECT) log(s, "SELECT");
      return new ASResultSet(iChange, rs);
    } catch (Exception e) {
      ARE.getLog().error(e.getMessage(), e);
      if (rs != null)
        rs.close();
      if (statement != null)
        statement.close();
      throw e;
    } finally {
      DebugSQL(s);
    }
  }

  public String getString(String sSql)
    throws Exception
  {
    String sReturn = null;
    ASResultSet rs = getASResultSet(sSql);
    if (rs.next()) {
      sReturn = rs.getString(1);
    }
    rs.getStatement().close();
    return sReturn;
  }

  public String getString(SqlObject asql)
    throws SQLException
  {
    String sReturn = null;
    ASResultSet rs = getASResultSet(asql);
    if (rs.next()) {
      sReturn = rs.getString(1);
    }
    rs.getStatement().close();
    return sReturn;
  }

  public String[] getStringArray(String sSql)
    throws Exception
  {
    return getStringArray(sSql, 2000);
  }

  public String[] getStringArray(SqlObject asql)
    throws Exception
  {
    return getStringArray(asql, 2000);
  }

  public String[] getStringArray(String sSql, int iMaxRow)
    throws Exception
  {
    String[][] sTemp = getStringMatrix(sSql, iMaxRow, 1);
    String[] sReturn = new String[sTemp.length];
    for (int i = 0; i < sTemp.length; i++) sReturn[i] = sTemp[i][0];
    return sReturn;
  }

  public String[] getStringArray(SqlObject asql, int iMaxRow)
    throws Exception
  {
    String[][] sTemp = getStringMatrix(asql, iMaxRow, 1);
    String[] sReturn = new String[sTemp.length];
    for (int i = 0; i < sTemp.length; i++) sReturn[i] = sTemp[i][0];
    return sReturn;
  }

  public String[][] getStringMatrix(String sSql)
    throws Exception
  {
    return getStringMatrix(sSql, 2000, 100);
  }

  public String[][] getStringMatrix(SqlObject asql)
    throws Exception
  {
    return getStringMatrix(asql, 2000, 100);
  }

  public String[][] getStringMatrix(String sSql, int iMaxRow, int iMaxColumn) throws Exception
  {
    String[][] sTemp = new String[iMaxRow][iMaxColumn];

    int iCountRow = 0; int iCountColumn = 0;

    ASResultSet rs = getASResultSet2(sSql);
    iCountColumn = rs.getColumnCount();
    while (rs.next()) {
      iCountRow++;
      if (iCountRow >= iMaxRow) break;
      for (int i = 0; i < iCountColumn; i++) {
        if (i >= iMaxColumn) {
          iCountColumn = iMaxColumn;
          break;
        }
        sTemp[(iCountRow - 1)][i] = rs.getString(i + 1);
      }
    }
    rs.getStatement().close();

    String[][] sReturn = new String[iCountRow][iCountColumn];
    for (int i = 0; i < iCountRow; i++) for (int j = 0; j < iCountColumn; j++) sReturn[i][j] = sTemp[i][j];

    return sReturn;
  }

  public String[][] getStringMatrix(SqlObject asql, int iMaxRow, int iMaxColumn)
    throws Exception
  {
    String[][] sTemp = new String[iMaxRow][iMaxColumn];

    int iCountRow = 0; int iCountColumn = 0;

    ASResultSet rs = getASResultSet(asql);
    iCountColumn = rs.getColumnCount();
    while (rs.next()) {
      iCountRow++;
      if (iCountRow >= iMaxRow) break;
      for (int i = 0; i < iCountColumn; i++) {
        if (i >= iMaxColumn) {
          iCountColumn = iMaxColumn;
          break;
        }
        sTemp[(iCountRow - 1)][i] = rs.getString(i + 1);
      }
    }
    rs.getStatement().close();

    String[][] sReturn = new String[iCountRow][iCountColumn];
    for (int i = 0; i < iCountRow; i++) for (int j = 0; j < iCountColumn; j++) sReturn[i][j] = sTemp[i][j];

    return sReturn;
  }

  public void disConnect() throws SQLException {
    if (this.conn != null) {
      try {
        commit();
        this.conn.close();
      } catch (SQLException e) {
        ARE.getLog().debug(e.getMessage(), e);
      }
      this.conn = null;
    }
  }

  public void finalize() throws SQLException {
    disConnect();
  }

  public String convertAmarStr2DBStr(String src)
    throws Exception
  {
    if ((iChange == 1) && (src != null))
      src = new String(src.getBytes("GBK"), "ISO8859_1");
    if ((iChange == 3) && (src != null)) {
      src = new String(src.getBytes("ISO8859_1"), "GBK");
    }

    src = SpecialTools.amarsoft2DB(src);

    String sDatabaseProductName = getConnection().getMetaData().getDatabaseProductName();
    if ((sDatabaseProductName != null) && (sDatabaseProductName.equalsIgnoreCase("Informix Dynamic Server")))
      src = SpecialTools.db2Informix(src);
    return src;
  }

  public Double getDouble(String sSql) throws Exception
  {
    Double dReturn = null;
    ASResultSet rs = getASResultSet(sSql);
    if (rs.next()) {
      dReturn = new Double(rs.getDouble(1));
    }
    rs.getStatement().close();
    return dReturn;
  }

  public Double getDouble(SqlObject asql)
    throws SQLException
  {
    Double sReturn = null;
    ASResultSet rs = getASResultSet(asql);
    if (rs.next()) {
      sReturn = new Double(rs.getDouble(1));
    }
    rs.getStatement().close();
    return sReturn;
  }

  private void setDebugTime()
  {
    if (iDebugMode == 1)
      this.dBeginTime = new Date();
  }

  private void DebugSQL(String s)
  {
    if (iDebugMode == 1) {
      Date dEndTime = new Date();
      double iTimeConsuming = dEndTime.getTime() - this.dBeginTime.getTime() / 1000.0D;
      int iStep = (int)iTimeConsuming * 100;
      StringBuffer sbf = new StringBuffer("[SQL");
      if (iTimeConsuming > WARNING_TIME) sbf.append(df_num.format(iStep));
      sbf.append("]");
      sbf.append("{");
      sbf.append(df.format(iTimeConsuming));
      sbf.append("}");
      sbf.append("{BeginTime=");
      sbf.append(sdf.format(this.dBeginTime));
      sbf.append(",EndTime=");
      sbf.append(sdf.format(dEndTime));
      sbf.append("}");
      sbf.append("{Type=SQL}");
      sbf.append("{");
      sbf.append(s);
      sbf.append("}");

      if (iTimeConsuming > WARNING_TIME) {
        ARE.getLog().warn(sbf.toString());
      }
      else
        ARE.getLog().debug(sbf.toString());
    }
  }

  private void DebugSQL(SqlObject asql)
  {
    if (iDebugMode == 1) {
      Date dEndTime = new Date();
      double iTimeConsuming = dEndTime.getTime() - this.dBeginTime.getTime() / 1000.0D;
      int iStep = (int)iTimeConsuming * 100;
      StringBuffer sbf = new StringBuffer("[SQL");
      if (iTimeConsuming > WARNING_TIME) sbf.append(df_num.format(iStep));
      sbf.append("]");
      sbf.append("{");
      sbf.append(df.format(iTimeConsuming));
      sbf.append("}");
      sbf.append("{BeginTime=");
      sbf.append(sdf.format(this.dBeginTime));
      sbf.append(",EndTime=");
      sbf.append(sdf.format(dEndTime));
      sbf.append("}");
      sbf.append("{Type=SQLOBJ}");
      sbf.append("{");
      sbf.append(asql.getDebugSql());
      sbf.append("}");
      sbf.append("{");
      sbf.append(asql.getOriginalSql());
      sbf.append("}");

      if (iTimeConsuming > WARNING_TIME) {
        ARE.getLog().warn(sbf.toString());
      }
      else
        ARE.getLog().debug(sbf.toString());
    }
  }

  private void log(String s, String sType)
    throws Exception
  {
    PreparedStatement statement = null;
  }

  public void setLogExecute(boolean b)
  {
    this.LOG_EXECUTE = b;
  }
  public void setLogSelect(boolean b) {
    this.LOG_SELECT = b;
  }

  public static double getWarningSqlTime()
  {
    return WARNING_TIME;
  }

  public static void setWarningSqlTime(double time)
  {
    WARNING_TIME = time;
  }

  public String getDatabase() {
    return this.dbname;
  }

  public JBOTransaction getTransaction() {
    return this.tx == null ? null : this.tx;
  }

  public void registerTransaction(JBOTransaction transaction) {
    this.tx = transaction;
  }

  public void transactionComplete() {
    this.tx = null;
  }

  public DatabaseMetaData getMetaData() throws SQLException {
    return getConnectionIn().getMetaData();
  }

  public boolean getAutoCommit() throws SQLException {
    return getConnectionIn().getAutoCommit();
  }

  public int getTransactionIsolation() throws SQLException {
    return getConnectionIn().getTransactionIsolation();
  }

  /** @deprecated */
  public Connection getConnection()
    throws SQLException
  {
    return getConnectionIn();
  }

  private Connection getConnectionIn()
    throws SQLException
  {
    if (this.tx == null) {
      if (this.conn == null) {
        this.conn = ARE.getDBConnection(getDatabase());
      }
      setAutoCommit(false);
      return this.conn;
    }
    try {
      return this.tx.getConnection(this);
    } catch (JBOException e) {
      throw new SQLException(e.getMessage());
    }
  }

  private Connection getConnectionUpd() throws SQLException
  {
    return getConnectionIn();
  }

  private void setAutoCommit(boolean autoCommit) throws SQLException {
    if ((this.conn != null) && (this.tx == null)) {
      boolean curAutoCommit = this.conn.getAutoCommit();
      if (curAutoCommit != autoCommit) {
        if ((!curAutoCommit) && (autoCommit == true)) {
          this.conn.commit();
        }
        this.conn.setAutoCommit(autoCommit);
      }
    }
  }

  public void commit()
    throws SQLException
  {
    if ((this.conn != null) && (!this.conn.isClosed()) && (!this.conn.getAutoCommit()))
      this.conn.commit();
  }

  public void rollback()
    throws SQLException
  {
    if ((this.conn != null) && (!this.conn.isClosed()) && (!this.conn.getAutoCommit())) {
      ARE.getLog().trace("transaction rollback start");
      this.conn.rollback();
    }
  }

  public void setAppContext(AppContext arg0)
  {
  }
}