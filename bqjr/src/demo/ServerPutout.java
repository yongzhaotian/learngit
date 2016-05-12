package demo;

import java.net.*;

import java.io.*;

/**
 * 服务器端 此服务端可以作为操作型交易的服务端。可作为88011、9613交易的服务端
 * 这个程序建立了一个服务器，它一直监听10000端口，等待用户连接。在建立连接后给客户端返回一段信息，然后结束会话。这个程序一次只能接受一个客户连接。
 * @author jlwu
 *
 */
public class ServerPutout{

	private ServerSocket ss;
	private Socket socket;
	private BufferedReader in;
	private PrintWriter out;
	public ServerPutout(){
		
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
				//给客户端做出回应
				out.write("   0");
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
		new ServerPutout().putOut();
	}
}

