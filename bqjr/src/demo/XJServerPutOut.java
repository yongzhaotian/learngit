package demo;

import java.net.*;

import java.io.*;

/**
 * 
 * @author jlwu
 *
 */
public class XJServerPutOut{

	private ServerSocket ss;
	private Socket socket;
	private BufferedReader in;
	private PrintWriter out;
	
	public XJServerPutOut(){
		System.out.println("服务正在侦听...");
	}

	public void putOut(){
		try{
			//创建绑定到特定端口的服务器套接字。
			ss = new ServerSocket(10000);
			while (true){
				//侦听并接受到此套接字的连接。
				socket = ss.accept();
				//方法获得网络连接输入，同时返回一个IutputStream对象实例
				in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
				//方法连接的另一端将得到输入，同时返回一个OutputStream对象实例
				out = new PrintWriter(socket.getOutputStream(), true);
				String line = in.readLine();
				System.out.println("从客户端传来的信息："+line);
				String tradeno = line.substring(24, 28);
				System.out.println("tradeno="+tradeno);
				//给客户端做出回应
				if(tradeno.equals("UP01")){
				out.write("2009-06-2411062312345678901234567890000000chenggong                                                   ab");
				}else if(tradeno.equals("UP03")){
					out.write("2009-06-2413462312345678901234567890000000chenggong                                                   ab");
					out.flush();
					out.write("20061017000014       89122015201020000918            60200     01 三盛电子  0000005000000.012007-01-012008-12-120000007000000.00");
					out.flush();
					out.write("20061017000015       89161018251010800368            60200     01 弘兆汽车  0000003200000.562007-01-022008-12-110000009000000.00");
					out.flush();
				}
				out.flush();
				out.close();
				in.close();
				socket.close();
			}
		}catch (IOException e){
			e.printStackTrace();
		}
	}

	public static void main(String[] args){
		new XJServerPutOut().putOut();
	}
}


