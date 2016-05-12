package com.amarsoft.gzip;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.are.ARE;

public class CompressionFilter implements Filter{
    
	@SuppressWarnings("unchecked")                                                                           
	public void doFilter(ServletRequest request, ServletResponse response,                                   
	        FilterChain chain) throws IOException, ServletException {                                             
	    boolean compress = false;                                                                            
	    if (request instanceof HttpServletRequest){                                                          
	        HttpServletRequest httpRequest = (HttpServletRequest) request;                                   
	        Enumeration headers = httpRequest.getHeaders("Accept-Encoding");                                 
	        while (headers.hasMoreElements()){                                                               
	            String value = (String) headers.nextElement();                                               
	            if (value.indexOf("gzip") != -1){                                                            
	                compress = true;                                                                         
	            }                                                                                            
	        }                                                                                                
	    }                                                                                                    
	                                                                                                         
	    if (compress){//��������֧����ѹ��        
	    	//System.out.println("�����֧��ѹ��  ");
	    	ARE.getLog().info("�����֧��ѹ��  ");
	        HttpServletResponse httpResponse = (HttpServletResponse) response;                               
	        httpResponse.addHeader("Content-Encoding", "gzip");                                              
	        CompressionResponse compressionResponse= new CompressionResponse(httpResponse);                  
	        chain.doFilter(request, compressionResponse);                                                    
	        compressionResponse.close();                                                                     
	    }                                                                                                    
	    else{//����������֧����ѹ��          
	    	//System.out.println("�������֧����ѹ��  ");
	    	ARE.getLog().info("�������֧����ѹ��  ");
	        chain.doFilter(request, response);                                                               
	    }                                                                                                    
	}                                                                                                        
	                                                                                                         
	                                                                                                         
	public void init(FilterConfig config) throws ServletException {                                          
	                                                                                                         
	}                                                                                                        
	                                                                                                         
	public void destroy(){                                                                                   
	                                                                                                         
	}                                                                                                        

}
