	//var sMenuResourcesPath = "/amarbank6/Resources/1";
	var sMenuResourcesPath = sResourcesPath;

    function over_change(index,src,clrOver)
    {
        if (!src.contains(event.fromElement)) 
        { 
            src.style.cursor = 'pointer';
            src.background = clrOver;
        }
    }

    function out_change(index,src,clrIn)
    {
        if (!src.contains(event.toElement))
        {
            src.style.cursor = 'default';
            src.background = clrIn;
        }
    }

    function MM_swapImgRestore() 
    { 
        var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
    }

    function MM_preloadImages() 
    {     
        var d=document; 
        if(d.images)
        { 
            if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; 
            for(i=0; i<a.length; i++)
                if (a[i].indexOf("#")!=0)
                { 
                    d.MM_p[j]=new Image; 
                    d.MM_p[j++].src=a[i];
                }
        }
    }

    function MM_findObj(n, d) 
    { 
        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
        if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
        if(!x && document.getElementById) x=document.getElementById(n); return x;
    }

    function MM_swapImage() 
    { 
        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
        if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
    }

    
    function GotoURL(url,str1,str2)
    {               
        //self.open(url + "&rand=" + randomNumber(),"_top","");
        //OpenComp(sCompID,sParameter,sTargetWindow,sStyle)
        OpenComp(str1,url,"ComponentName="+str2+"&ComponentType=MainWindow","_self","");
    }
    function GotoURL_1(url,str1,str2,str3)
    {
        
        OpenComp(str1,url,"InfoType="+str3+"&ComponentName="+str2+"&ComponentType=MainWindow","_self","");
    }

    function sessionOut()
    {
        if (confirm("退出本信贷系统，确认吗？"))
        self.open("/Frame/page/sys/SessionOut.jsp?rand="+randomNumber(),"_top","");
    }                         
        
    function Role()
    {
        self.open("<%=sWebRootPath%>/UserManage/QueryUserRole.jsp?rand="+randomNumber(),"","width=510,height=300,top=150,left=350,toolbar=no,scrollbars=no,resizable=no,status=no,menubar=no");
    }
    
    function toMain() 
    {   
        self.open("<%=sWebRootPath%>/Main.jsp?rand="+randomNumber(),"_top",""); 
    }
 
    //reloads the window if Nav4 resized
    function MM_reloadPage(init) 
    {  
        if (init==true) with (navigator) 
        {
            if ((appName=="Netscape")&&(parseInt(appVersion)==4)) 
            {
                document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; 
            }
        }
        else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) 
            location.reload();
    }
    MM_reloadPage(true);
    
	var amarMenu = new Array();	
	var amarMenuR = new Array();	
 	
    function showlayer(id,e)
    {  
		igetRealLeft = getRealLeft(e);
		igetRealTop  = getRealTop(e);
		offsetHeight = e.offsetHeight;
		offsetWidth  = e.offsetWidth;

		//加入超时控制，防止闪屏
		setTimeout(function showlayerIn(){
		document.all('subMenu'+id).style.left=igetRealLeft;
        document.all('subMenu'+id).style.top=igetRealTop+offsetHeight;
        document.all('subMenu'+id).style.width=offsetWidth;

	    if(igetRealLeft + document.all('subMenu'+id).offsetWidth >document.body.offsetWidth)
	    	document.all('subMenu'+id).style.left = document.body.offsetWidth - document.all('subMenu'+id).offsetWidth;
	    if(igetRealTop +offsetHeight+ document.all('subMenu'+id).offsetHeight >document.body.offsetHeight)
	    	document.all('subMenu'+id).style.top = document.body.offsetHeight - document.all('subMenu'+id).offsetHeight-5;
	        document.all('subMenu'+id).style.visibility="visible";
			for(var i=0;i<=amarMenuR.length2;i++)
			{
		 		if(i!=id)
		 			try {
		   			document.all('subMenu'+i).style.visibility="hidden";
		   			}catch(e) {var a = 1; }	   			
			}
			//设定当显示主菜菜单时展现Ifrme覆盖 select 元素，防止主菜单被 select 覆盖 add by jbye 2009/03/17
			if(id>0){
				document.all("coverselect").innerHTML = "<IFRAME id=iframeSelect name=iframeSelect src=\"\" scroll=\"none\" style=\"width:"+document.all('subMenu'+id).offsetWidth+";height:"+document.all('subMenu'+id).offsetHeight+";position:absolute;left:"+document.all('subMenu'+id).style.left+";top:24;z-index:5;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)'\"></iframe>";
			}else document.all("coverselect").innerHTML = ""; 
		}, 1); 
		
    }

    function getRealTop(imgElem) 
    {
        yPos = eval(imgElem).offsetTop;
        tempEl = eval(imgElem).offsetParent;
        while (tempEl != null) 
        {
            yPos += tempEl.offsetTop;
            tempEl = tempEl.offsetParent;
        }
        return yPos;
    }
 
    function getRealLeft(imgElem) 
    {
        xPos = eval(imgElem).offsetLeft;
        tempEl = eval(imgElem).offsetParent;
        while (tempEl != null) 
        {
            xPos += tempEl.offsetLeft;
            tempEl = tempEl.offsetParent;
        }
        return xPos;
    }
    
	function setClassNew(e)
	{
		e.className='subMenu_down';
		for(i=amarMenuR.length+1;i<=amarMenuR.length2;i++)
		{
			try {
			document.all('subMenu'+i).style.visibility="hidden";
			}catch(e) {var a = 1; }
		}
			
	}
			
	function showsublayer(id,e)
	{
		//加入超时控制，防止闪屏
		setTimeout(function showlayerIn(){
			setClassNew(e);
			document.all('subMenu'+id).style.left=getRealLeft(e)+e.offsetWidth;
			document.all('subMenu'+id).style.top=getRealTop(e);
			document.all('subMenu'+id).style.width=e.offsetWidth;
			document.all('subMenu'+id).style.visibility="visible";
			//document.all('subMenu'+id).style.border="1px solid #FF0000";
			
			//add by syang 2009/11/05设置三级菜单的辅助Iframe宽高和Table一样
			//subMenuTable为三级菜单的容器Table
			document.all('subMenuTable'+id).style.border="1px solid #CCCCCC";
			tableWidth = document.all('subMenuTable'+id).clientWidth;
			tableHeight = document.all('subMenuTable'+id).clientHeight;
			document.all('subMenuIframe'+id).style.width=tableWidth+1;
			document.all('subMenuIframe'+id).style.height=tableHeight+1;
		}, 1); 

	}
	
	function hidesublayer(id,e)
	{
		//加入超时控制，防止闪屏
		setTimeout(function showlayerIn(){
			e.className='SubMenuTd2';		
			if ( document.all('subMenu'+id).style.visibility=="visible")
				return;
			else
			{
				document.all('subMenu'+id).style.visibility="hidden";
			}
		}, 1); 
	}    
	
	function genMenu(sRCPath)
	{
		
		//first convert amarMenu to amarMenuR
		//id,modelname,bSelect,onClick,haveSubCount
		var iLength = new Array(2,6,10);
		var i1=0,i2=0,i3=0;
		var i,j,k,ii,jj,kk,j0,j1;
		var iCount1=0,iCount2=0;
		for(i=0;i<amarMenu.length;i++)
		{
			if(amarMenu[i][0].length==iLength[0])
			{
				iCount1 = 0;
				for(j=i+1;j<amarMenu.length;j++)
				{
					if(amarMenu[j][0].length==iLength[0]) break;
					if(amarMenu[j][0].length==iLength[1]&&amarMenu[j][0].substr(0,iLength[0])==amarMenu[i][0]) iCount1++;
				}
		
				amarMenuR[i1]=new Array(amarMenu[i][0],amarMenu[i][1],amarMenu[i][2],amarMenu[i][3],iCount1);	
				if(iCount1>0)
				{
					amarMenuR[i1][5]=new Array();
					j0=0;
					for(jj=i+1;jj<j;jj++)
					{
						if(amarMenu[jj][0].length==iLength[1]&&amarMenu[jj][0].substr(0,iLength[0])==amarMenu[i][0])
						{
							//level3
							iCount2 = 0;
							for(k=jj+1;k<j;k++)
							{
								if(amarMenu[k][0].length==iLength[1]) break;
								if(amarMenu[k][0].length==iLength[2]&&amarMenu[k][0].substr(0,iLength[1])==amarMenu[jj][0]) iCount2++;
							}
							amarMenuR[i1][5][j0]=new Array(amarMenu[jj][0],amarMenu[jj][1],amarMenu[jj][2],amarMenu[jj][3],iCount2);							
							if(iCount2>0)
							{
								amarMenuR[i1][5][j0][5]=new Array();
								j1 = 0;
								for(kk=jj+1;kk<j;kk++)
								{
									if(amarMenu[kk][0].length!=iLength[2]) break;
									if(amarMenu[kk][0].substr(0,iLength[1])==amarMenu[jj][0])
										amarMenuR[i1][5][j0][5][j1++]=new Array(amarMenu[kk][0],amarMenu[kk][1],amarMenu[kk][2],amarMenu[kk][3],0);
								}	
							}
							
							j0++;
							
						}
					}
				}
		
				i1++;
				i = j-1;
			}
		}	
		
		//then genMenu		
		var sss=new Array(),jjj=0;
		var mycursor=new Array('pointer','default');
		var sMenuLevel3 = "";
		var ssPath="";
		
		if(arguments.length==0)
			ssPath = sMenuResourcesPath;
		else
			ssPath = sRCPath;
			
		sss[jjj++] = " <table border=0 cellpadding=0 cellspacing=0 class='menu1' >";
		sss[jjj++] = "  <tr > ";
		sss[jjj++] = "   <td class=Menu0 ></td> ";
		
		for(i=0;i<amarMenuR.length;i++)
		{
			if(amarMenuR[i][2]==1)
				sss[jjj++] = "   <td id=MainMenu"+(i+1)+" nowrap align=center class='menu2_selected' onMouseOver='showlayer("+(i+1)+",this)' "; 
			else
				sss[jjj++] = "   <td id=MainMenu"+(i+1)+" nowrap align=center class='menu2' onMouseOver='showlayer("+(i+1)+",this)' ";
				
			if(amarMenuR[i][3]!="") 	
				sss[jjj++] = " onClick="+amarMenuR[i][3]+" ";
			sss[jjj++] = " style='cursor:"+mycursor[amarMenuR[i][4]>=1?1:0]+"' > &nbsp;&nbsp;"+amarMenuR[i][1]+"&nbsp;</td> <td></td>";	
			sss[jjj++] = "<td></td>";	
				
			sss[jjj++] = "   ";
			sss[jjj++] = "   ";
			
			
			//每8个menu，换一行
			/*
			if(i==8 || i==16 || i==24 || i==32)
			{
				sss[jjj++] = "   <td>&nbsp;</td> ";
				sss[jjj++] = "  <tr> ";
				//sss[jjj++] = "  <tr> ";
				//sss[jjj++] = "  <td colspan=10>&nbsp;</span> ";
				//sss[jjj++] = "  </tr > ";
				sss[jjj++] = "  <tr > ";
				sss[jjj++] = "   <td class=Menu0 ></td> ";
			}
			*/
		}
		sss[jjj++] = "   <td>&nbsp;</td> ";
		sss[jjj++] = "  <tr> ";
		sss[jjj++] = " </table> ";	              	              
			                
		sss[jjj++] = " <div id=subMenu0 style='z-index:-1;position:absolute; left:0px; top:0px;width:1px;height:1px; visibility:hidden'> ";	      
		sss[jjj++] = " </div> ";
		
		amarMenuR.length2 = amarMenuR.length;
		for(i=0;i<amarMenuR.length;i++)
		{
			sMenuLevel3 = "";
			if(amarMenuR[i][4]>=1)
			{
				sss[jjj++] = " <div id=subMenu"+(i+1)+" style='z-index:1000;position:absolute; left:0px; top:0px; width:0px;height:0px;  visibility:hidden' class=SubMenuDiv > ";
				sss[jjj++] = "  <table  class='SubMenuTable' cellpadding=4 cellspacing=0 >";
				for(j=0;j<amarMenuR[i][5].length;j++)
				{
					sss[jjj++] = "   <tr> ";
					sss[jjj++] = "    <td class=SubMenuTd1 nowrap align=center> ";
					sss[jjj++] = "    	&nbsp; ";
					sss[jjj++] = "    </td> ";
					
					if(amarMenuR[i][5][j][4]==0)
						sss[jjj++] = "    <td class=SubMenuTd2 nowrap onMouseOver='setClassNew(this);' onMouseOut='this.className=\"SubMenuTd2\";' ";
					else
					{
						amarMenuR.length2 ++ ;
						sss[jjj++] = "    <td class=SubMenuTd2 nowrap onMouseOver='showsublayer("+amarMenuR.length2+",this);' onMouseOut='hidesublayer("+amarMenuR.length2+",this);' style='cursor:pointer' ";
						//生成第三层菜单
						sMenuLevel3 += "<div id=subMenu"+amarMenuR.length2+" style='z-index:1000;position:absolute; left:0px; top:0px; width:0px;height:0px;visibility:hidden;' class=SubMenuDiv > ";
						sMenuLevel3 += " <table id='subMenuTable"+amarMenuR.length2+"' class='SubMenuTable' cellpadding=4 cellspacing=0 style='z-index:1;position:absolute;left:0px;top:0px;'> ";    
						for(k=0;k<amarMenuR[i][5][j][5].length;k++)
						{
							sMenuLevel3 += " <tr>";
							sMenuLevel3 += "   <td class=SubMenuTd1 nowrap align=center></td> ";
							sMenuLevel3 += "   <td class=SubMenuTd2 nowrap onMouseOver=\"this.className='subMenu_down';\" onMouseOut=\"this.className='SubMenuTd2';\"  ";
							if(amarMenuR[i][5][j][5][k][3]!="")
								sMenuLevel3 += " onClick="+amarMenuR[i][5][j][5][k][3]; 
							sMenuLevel3 += " > "+amarMenuR[i][5][j][5][k][1]+"</td>";
							sMenuLevel3 += " </tr>";
						}			
						sMenuLevel3 += " </table> "; 
						//add by syang 2009/11/06 解决页面下拉框出现在菜单以前的问题
						//使用Iframe来遮住页面中可能出现的select,再使用菜单层遮住这个Iframe
						sMenuLevel3 += " <iframe id='subMenuIframe"+amarMenuR.length2+"' style='z-index:0;position:absolute;left:0px;top:0px;'></iframe>"
						sMenuLevel3 += " </div> "; 
					}
					
					if(amarMenuR[i][5][j][3]!="") 
						sss[jjj++] = " onClick="+amarMenuR[i][5][j][3]; 
					sss[jjj++] = "    >	"+amarMenuR[i][5][j][1];
					sss[jjj++] = "    </td> ";
					sss[jjj++] = "    <td class=SubMenuTd2 nowrap > ";
					if(amarMenuR[i][5][j][4]!=0)
						sss[jjj++] = "     <img src='"+ssPath+"/arrow.gif' > ";
					else
						sss[jjj++] = "     &nbsp; ";
					sss[jjj++] = "    </td> ";
					sss[jjj++] = "  </tr> ";
							
				}
				sss[jjj++] = "  </table>";
			}
			else
				sss[jjj++] = " <div id=subMenu"+(i+1)+" style='z-index:1000;position:absolute; left:0px; top:0px; width:0px;height:0px;  visibility:hidden' ";
				
			sss[jjj++] = " </div>";
			
			sss[jjj++] = sMenuLevel3;
		}
		//alert(sss.join(''));
		document.writeln(sss.join(''));		
		document.close();		
	}	
