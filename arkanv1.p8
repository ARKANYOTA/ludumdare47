pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--chaser of dawn
--by arkanyota
--theobosse
--yolwoocle
--and elza
sp = 0 --0=blanc; 1=jaune; 2=rouge
bdebug = true
clock=0
--camera
cx = 1000
cy = 0
--pos
cux=0
cuy=0
x = 64
y = 66
rot=0
sprt=1
mt=0
dead=false
walking=false
anims={
	afk=  {1,7,4,9},
	walk1={2,7,5,9},
	walk2={3,8,6,10},
}

movezone=true
safex=-1
safelen=128
--inventory

safearea=1
menu=true

--de 1 a 3
--pioche(pixaxe)
p=1
--hache(axe)
a=1
f=1
pmax = 3
amax = 3
fmax = 4
inv={w=16,s=0,i=0,c=0,m=0}
open=false
mine=0
--requied item
req={
	p={
		w={8,16,32},
		s={0,2,10},
		i={0,0,5}
	},
	a={
		w={8,16,32},
		s={0,2,4},
		i={0,0,5}
	},
	f={
		w={60,99,99,99},
		s={20,50,80,99},
		i={20,35,70,99},
		c={30,50,75,99},
		m={0,2,5,10}
	}
}
sobj = 0

debugvar = 0
-->8
--init update
function _init()
 poke(0x5f2d,1)
end

function _update60() 
	--movement
	if menu and notbdebug then
		upmenu() 
	else
		clock+=1
	 cpos()
	 if open then
	 	invup()
	 else
	 	movement()
		end
		
  --hot and cold zones
		if clock%10==0 then 
			safex+=1
		end
		
		if(clock%6==0 and
		(safex\1)%8==0) then
		  for i=1,17 do
		    mat=mget(safex\8+1,i)
		    if mat==80 then
		      mset(safex\8+1,i,83)
		    elseif mat==83 then
		      mset(safex\8+1,i,81)
		    elseif mat==81 then
		      mset(safex\8+1,i,82)
		    elseif mat==82 then
		      mset(safex\8+1,i,84)
		    end
		  end
		  
		  for i=1,17 do
		    mat=mget(safex\8+15,i)
		    if rnd(100)<4 and not
		    (mat==81 or
		    mat==82 or
		    mat==83 or
		    mat==84) then
		      mset(safex\8+15,i,80)
		    end
		  end
		end
		
  --mine
	 m=mget(cux/8, cuy/8)
	 if mt>=gettime(m) then
	   mining(cux/8, cuy/8)
	 end
	 
	 --death
	 if x+4<safex or x+4>safex+safelen then
	  death()
	 end

		vx=0
		vy=0
		if (x*16)>120 then
			cx =1
		else
			cx = 0
		end
		
--tp map borders
		if x>1024 then
			x =1
			cx = 0
			if movezone then
				safex-=1024
				movezone=false
			end
		elseif x<0 then
		 x = 1023
		 cx = 895 
			if movezone then
				safex+=1024
				movezone=false
			end
		else
			movezone=true
		end
		if y<-7 then
			y=128
		end
		if y>128 then
			y=-7
		end
		
		--camera
		cx=x-64+4
		cy=0
		camera(cx,cy)
		
	end
end
-->8
--draw
function _draw()
	cls()
	--debug

	if menu and notbdebug then
		drmenu()
	else
		map(0,0)
		map(0,0,1024,0, 8, 16)
		map(120,0,-64,0, 8, 16)
		--death zone
		fillp(░)
		rectfill(safex+8,0,safex+16,127,9)
		fillp()
		rectfill(-128,0,safex+8,127,10)
		rectfill(-128,0,safex,127,7)
		fillp(░)
		rectfill(safex+safelen-16,0,safex+safelen-8,127,2)
		fillp()
		rectfill(safex+safelen-8,0,1124,127,1)
		rectfill(safex+safelen,0,1124,127,0)
		
		--sprite
		spr(anims.afk[rot+1]+(sp*16),x,y,1,1)
		spr(16,cux,cuy)
		
		--mining
		mat=mget(cux/8,cuy/8)
		t=gettime(mat)
		if mt>0 and
		canmine(mat) then
		  color(1)
		  if t==nil then
		    pe=0
		  else
		    pe=((mt/t)*100)\1
		  end
		    
		  lx=cux
		  ly=cuy
		  
		  if rot==0 then
		    ly-=8
		  elseif rot==1 then
		    lx+=8
		  elseif rot==2 then
		    ly+=8
		  elseif rot==3 then
		    lx-=8
		  end
		  
		  z=0
		  t=0
		  for t=-1,1 do
					for z=-1,1 do
						print(pe.."%",t+lx,z+ly,1)
		  	end
				end
		  		print(pe.."%",lx,ly,7)
		end
		
		--inventory
		--func invsee page 6
		if open then invsee() end
		
		--func debug page 3
		if(bdebug) then debug() end
		
		drawhotbar()
	end

end
-->8
--debug
function debug()
--[[
		color(7)
		rectfill(-60+x,14,x-25,90,0)
		color(7)
		printui("x: "..x,1,16)
		printui("y: "..y,1,22)
		printui("cx: "..cx,1,28)
		printui("cy: "..cy,1,34)
		printui("a: "..a,1,100)
		printui("p: "..p,1,108)
		
		printui("mt: "..mt,1,52)
		printui("safe: "..safex,1,70)
		printui("dead: "..tostr(dead),1,76)
		printui("😐spr: "..mget(cux/8, cuy/8),1,46)
		printui("curs tag: "..fget(mget(cux/8, cuy/8)),1,82)
		
		]]
		moux=82+cx
		mouy=1
		rectfill(cx+80,1,cx+126,mouy+40,0)
		circ(stat(32)+cx,stat(33),1,1)
		pset(stat(32)+cx,stat(33),7)	
		print(stat(32)+cx..";"..stat(33),
								stat(32)+cx+3,stat(33))
		color(7)
		print("",moux,mouy+2)
		print("x "..x)
		print("y "..y)
		print("safe "..safex)
end
-->8
--functions

function death()
	dead=true
end

function icol(px,py)
  px/=8
  py/=8
	 return fget(mget(px,py))==0x1
	 or fget(mget(px,py))==0x3
end

function printui(txt,txtx,txty,col)
	if col==nil then col = 7 end 
 print(txt,txtx+cx,txty, col)
end

function cpos()
  cux=((x+4)\8)*8
  cuy=((y+4)\8)*8
  if rot==0 then
    cuy-=8
  elseif rot==1 then
    cux+=8
  elseif rot==2 then
    cuy+=8
  elseif rot==3 then
    cux-=8
  end
end

function canmine(material)
  if material==80 then
    return true
  elseif material==81 then
    return p>0
  elseif material==82 then
    return p>2
  elseif material==83 then
    return p>1
  elseif material==84 then
    return p>3
  end
end

function gettime(material)
  if material==80 then
    if a==1 then
      return 120
    elseif a==2 then
      return 90
    elseif a==3 then
      return 70
    elseif a==4 then
      return 40
    else 
      return 120
    end
  elseif material==81 then
    if p==2 then
      return 120
    elseif p==3 then
      return 90
    elseif p==4 then
      return 70
    else
      return 50
    end
  elseif material==82 then
    if p==2 then
      return 160
    elseif p==3 then
      return 160
    elseif p==4 then
      return 140
    else
      return 140
    end
  elseif material==83 then
    if p==2 then
      return 100
    elseif p==3 then
      return 75
    elseif p==4 then
      return 50
    else
      return 50
    end
  elseif material==84 then
    if p==2 then
      return 220
    elseif p==3 then
      return 220
    elseif p==4 then
      return 220
    else
      return 220
    end
  else
    return 9999
  end
end

-->8
-- menu
intmenu = 0
tuto = false
function upmenu()
	--btn control

 if btnp(⬇️) then intmenu +=1 end
 if btnp(⬆️) then intmenu -=1 end
 if btnp(❎) or btnp(🅾️) then
  if intmenu%3==0 then
 		menu=false
 	end
 	if intmenu%3==1 then
 		tuto=not tuto
 	end
 	if intmenu%3==2 then

 	end
 end
 if intmenu%3==2 then
  if btnp(⬅️) then sp =(sp+1)%3 end
  if btnp(➡️) then sp =(sp-1)%3 end
-- 	if btnp(⬅️) then sp =sp+1 end
-- 	if btnp(➡️) then sp =sp-1 end
	end
 
 
 
 
end

function drmenu()
	--print("arkan theodore yolwoocle elza")
	--affiche
	if intmenu%4==0 then
 	spr(131,56,40, 3,1)
 else
 	spr(128,56,40, 3,1)
 end
 if intmenu%4==1 then
 	spr(147,56,50, 3,1)
 else
 	spr(144,56,50, 3,1)
 end

 if intmenu%4==2 then
 	spr(163,56,60, 3,1)
 	spr(4+(sp*16),46,60, 1,1)
 else
 	spr(160,56,60, 3,1)
 end
 if intmenu%4==3 then
 	spr(179,56,70, 3,1)
 else
 	spr(176,56,70, 3,1)
 end
 --tuto
 if tuto then
  local zx = 5
  local zy = 110
  --rect(zx,zy,zx+50,zy+76)
  print("  ⬆️"     ,zx+0, zy+0 )
 	print("⬅️⬇️➡️"   ,zx+0, zy+6 )
 	print(" move",zx+0, zy+12)
 	--print("",zx+10, zy+20)
 	
 	print("🅾️ break",zx+40, zy+2)
 	print("❎ invntory",zx+40, zy+10)
 end
 
 color(7)
 print("mADE BY:",3,81)
 line(3,87,32,87)
 for i=0,3 do
 	spr(i+124,3,90+i*9)
 end
 print("theobosse - code",14,92)
 print("arkanyota - code",14,101)
 print("yolwoocle - code and art",14,110)
 print("elza - sound",14,119)
end


function movement()
mf=0x3
if btn(⬅️) then 
	 	 if not (icol(x,y))			and 
	 			  not (icol(x,y+7))	then 
	 	 x-=1
	 	 end
	 	rot=3
	 end
	 if btn(➡️) then
	   if not (icol(x+7,y))			and 
	 			  not (icol(x+7,y+7))	then
	   x+=1
	   end
	 	rot=1
	 end
	 if btn(⬆️) then
	   if not (icol(x+1,y-1))	and 
	 			  not (icol(x+6,y-1))	then
	   y-=1
	   end
	  rot=0
	 end
	 if btn(⬇️) then
	   if not (icol(x+1,y+8))	and 
	 			  not (icol(x+6,y+8))	then
	   y+=1
	   end
	  rot=2
	 end
	 
	 m=mget(cux/8, cuy/8)
	 if btn(🅾️) and
	    canmine(m) and
     (mine==0 or 
     mine==m) then
   mine=m
   if rot==0 and
     fget(m)==mf then
       mt+=1
   elseif rot==1 and
     fget(m)==mf
     then
       mt+=1
   elseif rot==2 and
     fget(m)==mf
     then
       mt+=1
   elseif rot==3 and
     fget(m)==mf
     then
       mt+=1
   else
     mine=0
     mt=0
   end
 else
   mine=0
   mt=0
 end
 
 if btnp(❎) then
		sobj = 0 --objet selectionne
  open=true
 end
end

function mining(x,y)
  if mget(x,y)==80 then
    inv.w+=1
  elseif mget(x,y)==81 then
    inv.s+=1
  elseif mget(x,y)==82 then
    inv.i+=1
  elseif mget(x,y)==83 then
    inv.c+=1
  elseif mget(x,y)==84 then
    inv.m+=1
  end
  mset(x,y,67)
end



-->8
function drawhotbar()
 spr(96 ,cx+5,36)
	spr(97 ,cx+5,48)
	spr(98 ,cx+5,60)
	spr(99 ,cx+5,72)
	spr(100,cx+5,84)
	color(7)
	z=0
	t=0
	o=15
	for t=-1,1 do
		for z=-1,1 do
			printui(inv.w,t+o,z+38,1)
			printui(inv.s,t+o,z+50,1)
			printui(inv.i,t+o,z+62,1)
			printui(inv.c,t+o,z+74,1)
			printui(inv.m,t+o,z+86,1)
		end
	end
		printui(inv.w,t+o,z+38)
		printui(inv.s,t+o,z+50)
		printui(inv.i,t+o,z+62)
		printui(inv.c,t+o,z+74)
		printui(inv.m,t+o,z+86)
end

function invsee()
	
	rectfill(
		cx+25,cy+25,
		cx+100,cy+100,12)
	rect(
		cx+23,cy+23,
		cx+102,cy+102,1)

	
	
	 --fusee
	--upgrade fusee
	--pioche fusee
	rectfill(cx+25, 58, cx+25+9, 58+9, 1)
	spr(100+f, cx+26, 59)
	
	if fmax>=f then
		--fusee vers upgrade
	    rectfill(cx+44, 58, cx+44+9, 58+9, 1)
	    rect(cx+44, 58, cx+44+9, 58+9, 0)
		spr(101+f, cx+45, 59)
		--fleche entre 2
		printui("->",36,60)
	
		--couleur du chiffre avant
		if inv.w < req.f.w[f] then
			wcolor = 8 else wcolor = 11
		end
		
		if inv.s < req.f.s[f] then
			scolor = 8 else scolor = 11
		end
		
		if inv.i < req.f.i[f] then
			icolor = 8 else icolor = 11
		end
		
		if inv.c < req.f.c[f] then
			ccolor = 8 else ccolor = 11
		end
		
		if inv.m < req.f.m[f] then
			mcolor = 8 else mcolor = 11
		end
	
		--chiffre et sprite de ce que
		--on a besoin pour craft
		spr(96,cx+60,59)
		printui(req.f.w[f],56,60, wcolor)
		
		spr(97,cx+75,59)
		printui(req.f.s[f],71,60, scolor)
	
		spr(98,cx+89,59)
		printui(req.f.i[f],85,60, icolor)
		
		spr(99,cx+65,70)
		printui(req.f.c[f],61,71, ccolor)
		
		spr(100,cx+87,70)
		printui(req.f.m[f],79,71, mcolor)
	else
		printui("max lvl reached",37,59, 11)
	end
	
	--pioche
	--upgrade pioche
	--pioche actuelle
	rectfill(cx+25, 80, cx+25+9, 80+9, 1)
	spr(68+p, cx+26, 81)
		
	if pmax>=p then
		--pioche vers upgrade
	    rectfill(cx+44, 80, cx+44+9, 80+9, 1)
	    rect(cx+44, 80, cx+44+9, 80+9, 0)
		spr(69+p, cx+45, 81)
		--fleche entre 2
		printui("->",36,82)
	
		--couleur du chiffre avant
		if inv.w < req.p.w[p] then
			wcolor = 8 else wcolor = 11
		end
		
		if inv.s < req.p.s[p] then
			scolor = 8 else scolor = 11
		end
		
		if inv.i < req.p.i[p] then
			icolor = 8 else icolor = 11
		end
	
		--chiffre et sprite de ce que
		--on a besoin pour craft
		spr(96,cx+60,81)
		printui(req.p.w[p],56,82, wcolor)
		
		spr(97,cx+75,81)
		printui(req.p.s[p],71,82, scolor)
	
		spr(98,cx+89,81)
		printui(req.p.i[p],85,82, icolor)
	else
		printui("max lvl reached",37,81, 11)
	end
	

	--hache
	--upgrade hache
	--hache actuelle
	rectfill(cx+25, 91, cx+25+9, 91+9, 1)
	spr(84+a, cx+26, 92)
	
	
	if amax>=a then
		--hache vers upgrade
	    rectfill(cx+44, 91, cx+44+9, 91+9, 1)
	    rect(cx+44, 91, cx+44+9, 91+9, 0)
		spr(85+a, cx+45, 92)
		--fleche entre 2
		printui("->",36,93)
		
		--couleur du chiffre avant
		if inv.w < req.a.w[a] then
			wcolor = 8 else	wcolor = 11
		end
		
		if inv.s < req.a.s[a] then
			scolor = 8 else scolor = 11
		end
		
		if inv.i < req.a.i[a] then
			icolor = 8 else icolor = 11
		end
	
		--chiffre et sprite de ce que
		--on a besoin pour craft
		spr(96,cx+60,92)
		printui(req.f.w[f],56,93, wcolor)
		
		spr(97,cx+75,92)
		printui(req.f.s[f],71,93, scolor)
	
		spr(98,cx+89,92)
		printui(req.f.i[f],85,93, icolor)
	
	else
		printui("max lvl reached",37,92, 11)
	end
	
	--selected object
	--contour
	if sobj==0 then --fusee
		rect(cx+25, 58, cx+25+9, 58+9, 7)
	else
		rect(cx+25, 58, cx+25+9, 58+9, 0)
	end
	
	if sobj==1 then --pioche
		rect(cx+25, 80, cx+25+9, 80+9, 7)
	else
		rect(cx+25, 80, cx+25+9, 80+9, 0)
	end
	
	if sobj==2 then --hache
		rect(cx+25, 91, cx+25+9, 91+9, 7)
	else
		rect(cx+25, 91, cx+25+9, 91+9, 0)
	end
	
	printui(debugvar,0,0,11)
end


function invup()
  if btnp(❎) then
    open=false
  end
  if btnp(⬆️) then
    sobj= (sobj-1)%3
  end
  if btnp(⬇️) then
    sobj= (sobj+1)%3
  end
  
  if btnp(🅾️) then
 	if sobj==0 then --fusee
 	debugvar = (req.f.w[f] == nil)
 	 if not (req.f.w[f] == nil)and 
 	 		 not (inv.w < req.f.w[f]) and
	 	 	 not (inv.s < req.f.s[f]) and
 	  	 not (inv.i < req.f.i[f]) then
 			inv.w -= req.f.w[f]
 			inv.s -= req.f.s[f]
 			inv.i -= req.f.i[f]
 			f+=1
 			
 		end
 	end
	
 	if sobj==1 then --pioche
 	 if not (req.p.w[p] == nil )and 
 	 		 not (inv.w < req.p.w[p]) and
	 	 	 not (inv.s < req.p.s[p]) and
 	  	 not (inv.i < req.p.i[p]) then
 			inv.w -= req.p.w[p]
 			inv.s -= req.p.s[p]
 			inv.i -= req.p.i[p]
 			p+=1
 		end
 	end
	
 	if sobj==2 then --hache
 	     if not (req.a.w[a] == nil  ) and 
 	 		 not (inv.w < req.a.w[a]) and
	 	 	 not (inv.s < req.a.s[a]) and
 	  	 not (inv.i < req.a.i[a]) then
 			inv.w -= req.a.w[a]
 			inv.s -= req.a.s[a]
 			inv.i -= req.a.i[a]
 			a+=1
 		end
 	end
	
  end
end
-->8

--circle effect demonstration
--by discord user sashaaa#8920
function circneg(circle_x,
	circle_y,
	circle_r)
	--we round all of our maths so
	--that the circle isn't biased
	--toward the right side of the
	--screen
	local round = function(num)
		return flr(num+.5)
	end
	
	--this is just the radius
	--squared. pythagorian theorem
	--incoming
	local c2=circle_r*circle_r
	
	--the top of the circle
	local y1=max(round(circle_y-circle_r),-1)
	--the bottom of the circle
	local y2=min(round(circle_y+circle_r),128)
	
	--for each y location...
	for yy=y1,y2 do
		--here we use a^2+b^2=c^2
		--we already know what a is,
		--which is the y distance
		--from the y origin. and we
		--know what the radius is

		--so using pythagorean theorem
		--we can treat this y point,
		--the center, and the edge of
		--the circle as a triangle,
		--and then find the distance
		--to the edge based off that
		local a=round(sqrt(c2-(yy-circle_y)^2))
		
		--then we use the distance to
		--figure out where the edges
		--are on that y position
		local x1,x2=circle_x-a,circle_x+a

		--then draw a line from left
		--side of screen to left edge
		--of circle, and right edge
		--of screen to right edge of
		--circle
		line( -1,yy, x1,yy,0)
		line(x2,yy,128,yy,0)
	end
	
	--then draw a rectangle above
	--and below all of that to
	--close it out
	rectfill(0,-1,127,y1-1,0)
	rectfill(0,y2,127,128,0)
end
__gfx__
00000000066666600666666006666660077777700777777007777770077777700777777007777770077777700787997000878000000800000000000000000000
00000000677775566777755667777556765555677655556776555567777655557776555555556777555567777685599700898980008080000008890000000000
00700700777775577777755777777557751111577511115775111157776511117765111111115677111156777881199908881988008899000088908000000000
00077000777775777777757777777577717111177171111771711117776171117761711111171677111716777881191908911898089999000089898000000000
00077000677775766777757667777576711111177111111771111117777111117771111111111777111117778881111988881198898aa980089aa98000080000
00700700076666600766666007666660077777700777777007777770077777700777777007777770077777708788979089888798899aa980089aa98000880000
00000000067777606077770606777760067c8760607c8706067c87600677c8606077c806068c7760608c77060888896008999988089aa980089a980000898000
000000000060060000600000000006000060060000000600006000000060060006000060006006000600006000800900008888000088880000898800008a8000
77000077055555500555555005555550099999900999999009999990099999900999999009999990099999900cc777700ccc7cc00cccccc0c1cc771ccccc77cc
7000000759999555599995555999955599555599995555999955559999955555999555555555599955555999ccc55567cccc5567cccc75c71cc77cc1ccc77ccc
0000000099999559999995599999955995111159951111599511115999551111995511111111559911115599cc11115ccccc11ccc117111c1c77ccc1cc77cccc
0000000099999599999995999999959991911119919111199191111999519111995191111119159911191599717111ccccc11ccccccc1ccc1cccccc1cccccccc
000000005999959559999595599995959111111991111119911111199991111199911111111119991111199971111ccc7111cccc777ccc777777777777777777
0000000009555550095555500955555009999990099999900999999009999990099999900999999009999990cc777cc0ccccccccccccccccc1cccc1ccccccccc
70000007059999505099990505999950059c8950509c8905059c89500599c8505099c805058c9950508c99050ccc8760cccccc60ccc7ccccc117711cccc77ccc
770000770050050000500000000005000050050000000500005000000050050005000050005005000500005000c006000ccc06000c7c06c0cc77c1cccc77cccc
00000000055555500555555005555550088888800888888008888880088888800888888008888880088888800000000000000000000000000000000000000000
00000000588885555888855558888555885555888855558888555588888555558885555555555888555558880000000000000000000000000000000000000000
00000000888885588888855888888558851111588511115885111158885511118855111111115588111155880000000000000000000000000000000000000000
00000000888885888888858888888588818111188181111881811118885181118851811111181588111815880000000000000000000000000000000000000000
00000000588885855888858558888585811111188111111881111118888111118881111111111888111118880000000000000000000000000000000000000000
00000000085555500855555008555550088888800888888008888880088888800888888008888880088888800000000000000000000000000000000000000000
00000000058888505088880505888850058c2850508c2805052c88500588c2505088c205052c8850508c28050000000000000000000000000000000000000000
00000000005005000050000000000500005005000000050000500000005005000500005000500500050000500000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeee88eeeeeeeceeee0044430000555f0000999f0000ccc900007000000000000000000000000000000000000000000eeeee100000
eeeeeeeeeeeeeeeeeeeeeeeee88e8e8eeeeeeeee0222432001115f1008889f800111c8100010000000000000000000000000000000000000000eeeeeeee11000
e88eee88eeeeeeeeeeeeeeeee8e888eeeeceecce000033330000ffff0000ffff00009888717170000000000000000000000000000000000000eeeeeeeeee1100
e888e888eeeeeeeeee8e8eee8e888e88ecc8e88e00044342000ddf5100055f98000558c100100000000000000000000000000000000000000eeeeeeeeeee1110
ee88e88eeeeeeeeeee8e8e8ee88e888eee88e8ee0044204200dd505100551098005510c100700000000000000000000000000000000000000eeeeeeeeeeee110
eeeeeeeeeeeeeeeeeee888ee88e888e8e88eeece044200420dd5005105510098055100c10000000000000000000000000000000000000000eeeeeeeeeeeee111
eeeeeeeeeeeeeeeeeeee8eeee8888e8eecceeccc44200020dd50001055100080551000100000000000000000000000000000000000000000eeeeeeeeeeeee111
eeeeeeeeeeeeeeeeeeeeeeeeee88e8eeeceeecee42000000d500000051000000510000000000000000000000000000000000000000000000eeeeeeeeeeeee111
ee44422eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000440000005500000099000000cc000000000000000000000000000000000000000000eeeeeeeeeeeee111
e4444422eddd1eeeeddd1eeeeedd11eeeddd1eee000444400005555000099990000cccc00000000000000000000000000000000000000000eeeeeeeeeeee1111
44422e42dddddd1edd998d1eed110d1eddee281e000034420000f5510000f9980000fcc10000000000000000000000000000000000000000eeeeeeeeeeee1111
4442ee33dddddd11d998dd11d110dd11dee2881100033333000fffff000fffff000fffff00000000000000000000000000000000000000000eeeeeeeeee11110
4442e333dddd1d11d98d1981d00d1101d228ee210044342200ddf51100ddf9880099fc1100000000000000000000000000000000000000000eeeeeeee1111110
4422e333ddd1dd11ddd19981ddd11101d882ee21044202200dd501100dd50880099801100000000000000000000000000000000000000000001eee1111111100
4422ee31ddddd111dddd9811dddd1011dddd121144200000dd500000dd5000009980000000000000000000000000000000000000000000000001111111111000
e42eeeeee111111ee111111ee111111ee111111e42000000d5000000d50000009800000000000000000000000000000000000000000000000000011111100000
0000040000000000009999900001100000082000000220000006600000099000000cc00000000000000000000000000000000000000000000000000000000000
0000444000dd5d0009aa99980011211008882200000220000006600000099000000cc00000000000000000000000000000000000000000000000000000000000
000444420ddddd509aa99998011221118888222800255200006556000095590000c55c0000000000000000000000000000000000000000000000000000000000
00444420ddddd5509a999988112211128888228100255200006556000095590000c55c0000000000000000000000000000000000000000000000000000000000
04444200dddddd5099999980212111212288212100255200006556000095590000c55c0000000000000000000000000000000000000000000000000000000000
44442000dd5dd5509999880022111211022211200255552006555560095555900c5555c000000000000000000000000000000000000000000000000000000000
04420000055555008998800002211110882211000255552006555560095555900c5555c000000000000000000000000000000000000000000000000000000000
00200000000000000888000000221100011210000255552006555560095555900c5555c000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888000003b00000cff100
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777008888880083bbb000ccfff10
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007777771800008088a8bbb00ddccdddd
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077111808008080831b100dddcfdfd
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000771008000808800eebe002ddfffff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007710080808088003bbb00222fffff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007710008888880044444400222fff0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100008888000022220000222f00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55500550000550055050000088800880000880088080000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55050550005505055050000088080880008808088080000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55500550005555005500000088800880008888008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55000555505505005500000088000888808808008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000088888888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
550505555055000555000000cc0c0cccc0cc000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555505500055000550500000cccc0cc000cc000cc0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555505550055000555000000cccc0ccc00cc000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
550505555055550550000000cc0c0cccc0cccc0cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000ccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55550550505555055050000099990990909999099090000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55000555500550055050000099000999900990099090000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00550555000550050550000000990999000990090990000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55550550505555050550000099990990909999090990000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000099999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555505505055550555500000bbbb0bb0b0bbbb0bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0550055050550005505000000bb00bb0b0bb000bb0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0550050550555005505000000bb00b0bb0bbb00bb0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555505055055000555500000bbbb0b0bb0bb000bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000bbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
4141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
__sfx__
000100001100034000310002d000290002c1002c1001f0002a1001c0001a000170001600028100140001300012000120002410023100221002210011000120001200014000170001c00021000280002f00031000
000100001100034000310002d000290002c1002c1001f0002a1001c0001a000170001600028100140001300012000120002410023100221002210011000120001200014000170001c00021000280002f00031000
__music__
00 41434344
00 41424344
00 41424344
00 41424344
00 41424344
00 41434344

