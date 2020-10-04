pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--chaser of dawn
--by arkanyota
--theobosse
--yolwoocle
--and elza
sp = 0 --0=blanc; 1=jaune; 2=rouge
bdebug=true
clock=0
--camera
cx = 0
cy = 0
--pos
cux=0
cuy=0
x = 64
y = 63
rot=2
sprt=1
mt=0
dead=false
walking=false
anims={
	afk=  {1,7,4,9},
	walk1={2,7,5,9},
	walk2={3,8,6,10},
}
sfxtime=1

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
	sfxtime-=1
	
	if menu then
		upmenu() 
	else
		clock+=1
	 cpos()
	 if open then
	 	invup()
	 else
	 	movement()
		end
		
		--mining sfx
		block=mget(cux\8,cuy\8)
		if mt>0 then
		 if clock%10==0 then
		 	if(block==80)sfx(8)
		 	if(block==81)sfx(8)
		 	if(block==82)sfx(8)
		 	if(block==83)sfx(8)
		 	if(block==84)sfx(8)
		 end
		end
		
		--animate ship
		ship=mget(12,4)
		if clock%5==0 then
			if ship==74 or ship==76 then
				for ix=12,13 do
					for iy=4,5 do
						local tile=mget(ix,iy)
						mset(ix,iy,tile+2)
					end
				end
			elseif ship==78 then
				for ix=12,13 do
					for iy=4,5 do
						local tile=mget(ix,iy)
						mset(ix,iy,tile-4)
					end
				end
			end
		end
	
  --hot and cold zones
		if clock%10==0 then 
			safex+=1
		end
		for i=1,17 do
		  mget()
		end
		
		--sun cooking
		if(clock%6==0 and
		(safex\1)%8==0) then
		  for i=1,17 do
		    mat=mget(safex\8+1,i)
		    if mat==80 then
		      mset((safex+7)\8+1,i,83)
		    elseif mat==83 then
		      mset((safex+7)\8+1,i,81)
		    elseif mat==81 then
		      mset((safex+7)\8+1,i,82)
		    elseif mat==82 then
		      mset((safex+7)\8+1,i,84)
		    end
		  end
		  
		  for i=1,17 do
		    mat=mget(safex\8+15,i)
		    if rnd(100)<3 and 
		       fget(mat)==0x0 then
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

	if menu then
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
		
		color(7)
		textc="mine"
		for ix=-1,1 do
			for iy=-1,1 do
				color(1)
				printui("[c] mine  [x] crafting",7+ix,118+iy,1)
			end
		end
		printui("[c] mine  [x] crafting",7,118)
		--inventory
		--func invsee page 6
		rect(4+cx,4,15+cx,15,1)
		rectfill(5+cx,5,14+cx,14,7)
		spr(68+p,6+cx,6)
		
		rect(22+cx,4,33+cx,15,1)
		rectfill(23+cx,5,32+cx,14,7)
		spr(84+a,24+cx,6)
		
		if open then invsee() end
		
		--func debug page 3
		if(bdebug) then debug() end
		
		drawhotbar()
	end
 debug()
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
		circ(stat(32)+cx,stat(33),1,1)
		pset(stat(32)+cx,stat(33),7)	
		color(7)
		for ix=-1,1 do
			for iy=-1,1 do
				printcoor(ix,iy,1)
			end
		end
		printcoor(0,0,7)
end

function printcoor(ox,oy,c)
	print(stat(32)+cx..";"..stat(33),
								stat(32)+cx+3+ox,
								stat(33)+oy,c)
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
 
 --credits
  color(7)
 print("mADE BY:",3,72)
 line(3,80-1,32,80-1)
 for i=0,3 do
 	spr(i+124,3,90+i*9)
 end
 print("raphael - logo",14,83)
 print("theobosse - code",14,92)
 print("arkanyota - code",14,101)
 print("yolwoocle - code and art",14,110)
 print("elza - sound",14,119)
 
 --tuto
 if tuto then
  local zx = 5
  local zy = 5
  rectfill(0,0,127,127,0)
  color(7)
  print("  ⬆️"     ,zx+0, zy+0 )
 	print("⬅️⬇️➡️"   ,zx+0, zy+6 )
 	print(" move",zx+0, zy+12)
 	--print("",zx+10, zy+20)
 	
 	print("[c] mine",zx+40, zy+2)
 	print("[x] creating",zx+40, zy+10)
 	print("your spaceship just crashed on",6,28)
 	print("")
 	print("a tiny alien planet... ")
 	print("repair your rocket and excape! ")
 	print(" ")
 	color(8)
 	print("but be careful, day and night")
 	print("kills you.")
 	color(7)
 	print(" ")
 	print("you can do a rotation around")
 	print("the planet. some items will")
 	print("turn into others in the sunlight")
 	print("")
 	print("❎ continue")
 	print("  ")
 	print("")
 end
 

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
--hotbar
function drawhotbar()
 for i=1,5 do
 	spr(95+i,cx+5,25+(i-1)*19)
	end
	color(7)
	z=0
	t=0
	o=15
 tsp=19		--txt spacing
 tx=25
 local sp=27
	--print vals
	for t=-1,1 do
		for z=-1,1 do
			printui(inv.w,t+o,z+sp+tsp*0,1)
			printui(inv.s,t+o,z+sp+tsp*1,1)
			printui(inv.i,t+o,z+sp+tsp*2,1)
			printui(inv.c,t+o,z+sp+tsp*3,1)
			printui(inv.m,t+o,z+sp+tsp*4,1)
		end
	end
		
		printui(inv.w,t+o,sp+tsp*0,7)
		printui(inv.s,t+o,sp+tsp*1,7)
		printui(inv.i,t+o,sp+tsp*2,7)
		printui(inv.c,t+o,sp+tsp*3,7)
		printui(inv.m,t+o,sp+tsp*4,7)
		
	text={"WOOD","STON",
	"COPP","COAL","AMETH"}
	tx=5
	ty=1
	color(1)
	for i=1,5 do
		printui(text[i],tx+t,i*tsp+(ty-1)+z,1)
	end
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
			wcolor = 8 else wcolor = 3
		end
		
		if inv.s < req.f.s[f] then
			scolor = 8 else scolor = 3
		end
		
		if inv.i < req.f.i[f] then
			icolor = 8 else icolor = 3
		end
		
		if inv.c < req.f.c[f] then
			ccolor = 8 else ccolor = 3
		end
		
		if inv.m < req.f.m[f] then
			mcolor = 8 else mcolor = 3
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
			wcolor = 8 else wcolor = 3
		end
		
		if inv.s < req.p.s[p] then
			scolor = 8 else scolor = 3
		end
		
		if inv.i < req.p.i[p] then
			icolor = 8 else icolor = 3
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
			wcolor = 8 else	wcolor = 3
		end
		
		if inv.s < req.a.s[a] then
			scolor = 8 else scolor = 3
		end
		
		if inv.i < req.a.i[a] then
			icolor = 8 else icolor = 3
		end
	
		--chiffre et sprite de ce que
		--on a besoin pour craft
		spr(96,cx+60,92)
		printui(req.a.w[a],56,93, wcolor)
		
		spr(97,cx+75,92)
		printui(req.a.s[a],71,93, scolor)
	
		spr(98,cx+89,92)
		printui(req.a.i[a],85,93, icolor)
	
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
	
	printui(req.p.w[p],0,0,11)
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
 	     if not (req.a.w[a] == nil) and 
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
eeeeeeeeeeeeeeeeeeeeeeeeee88eeeeeeeceeee0044430000555f0000999f000088890000000000e1eeeee8eeeeeeeee1eeeee8eeeeeeeee1eeeee8eeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeee88e8e8eeeeeeeee0222432001115f1008889f800111291000000000e11eeee88eeeeeeee11eee898eeeeeeee11eee898eeeeeee
e88eee88eeeeeeeeeeeeeeeee8e888eeeeceecce000033330000ffff0000ffff0000999900000000e118ee898eeeeeeee118ee998eeeeeeee118ee998eeeeeee
e888e888eeeeeeeeee8e8eee8e888e88ecc8e88e00044342000ddf5100055f980005592100000000ed88ee898eeeeeeeed18e89aeeeeeeeeed18ee8a98eeeeee
ee88e88eeeeeeeeeee8e8e8ee88e888eee88e8ee0044204200dd5051005510980055102100000000ed89dd9a8eeeeeeeedd9d8999eeeeeeeedd9dd8999eeeeee
eeeeeeeeeeeeeeeeeee888ee88e888e8e88eeece044200420dd50051055100980551002100000000dd89ddd9ddd5eeeedd89dd998dd5eeeedd898dd99dd5eeee
eeeeeeeeeeeeeeeeeeee8eeee8888e8eecceeccc44200020dd500010551000805510001000000000d589dd111dd55eeed5899d111dd55eeed5998d188dd55eee
eeeeeeeeeeeeeeeeeeeeeeeeee88e8eeeceeecee42000000d5000000510000005100000000000000d8898dd11188ddeed89a9dd11185ddeed89a8dd11185ddee
ee44422eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000440000005500000099000000880000000000589981dd5898d555589a91dd589dd55558aa81dd5dadd555
e4444422eddd1eeeeddd1eeeeedd11eeeddd1eee00044440000555500009999000082220000000005899812559a855ee55898125589955ee55995125589555ee
44422e42dddddd1edd998d1eed110d1eddee281e000034420000f5510000f9980000f221000000005558511558a552225555511559a952225588511558855222
4442ee33dddddd11d998dd11d110dd11dee2881100033333000fffff000fffff000fffff0000000011555512555222ee1155551259a822ee11555512555222ee
4442e333dddd1d11d98d1981d00d1101d228ee210044342200ddf51100ddf9880099f211000000001111222222222eee1111222222222eee1111222222222eee
4422e333ddd1dd11ddd19981ddd11101d882ee21044202200dd501100dd508800998011000000000111222222222eeee111222222222eeee111222222222eeee
4422ee31ddddd111dddd9811dddd1011dddd121144200000dd500000dd50000099800000000000001222eeeeeeeeeeee1222eeeeeeeeeeee1222eeeeeeeeeeee
e42eeeeee111111ee111111ee111111ee111111e42000000d5000000d50000009800000000000000222eeeeeeeeeeeee222eeeeeeeeeeeee222eeeeeeeeeeeee
000002000000000000999990000110000008200000044000000dd000000aa0000008800000000000000000000000000000000000000000000000000000000000
0000444000dd1d0009aa999800112110088822000044420000ddd50000aa99000088220000000000000000000000000000000000000000000000000000000000
000424420ddddd109aa99998011221118888222800424200005ddd0000a999000088220000000000000000000000000000000000000000000000000000000000
00424420ddddd1109a99998811221112888822810342443005dd5d50089999800122221000000000000000000000000000000000000000000000000000000000
04444200d1ddd1109999998021211121228821212234432255d5dd5588a999881188221100000000000000000000000000000000000000000000000000000000
44242000dd1d11109999880022111211022211202234432255ddd555889999881122221100000000000000000000000000000000000000000000000000000000
02420000011111008998800002211110882211002024440250dd5d05809999081022220100000000000000000000000000000000000000000000000000000000
00200000000000000888000000221100011210002000000250000005800000081000000100000000000000000000000000000000000000000000000000000000
22222222bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888000003b00000cff100
22222222bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000777777008888880083bbb000ccfff10
33333333bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000007777771800008088a8bbb00ddccdddd
bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000077111808008080831b100dddcfdfd
bbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000771008000808800eebe002ddfffff
bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000007710080808088003bbb00222fffff
bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000007710008888880044444400222fff0
bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000001100008888000022220000222f00
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101030303030300000000000101010101010000000000000000000000000000000001010000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4141414141414141414140414141414141414141414141414141414141414141414141414141404141414141414140414141414141404042414141414141414041414141414142414141414141414141414141414141414141414141414141414040414071714141414141414141414141414040414141414141414140404141
4141414141414141424250414141404141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414140414141414040404241414141414141414040414141404040404141414141414141414171714140414141414141414141414141404141414141414141414141
4141414241414141414141414141424242424141414140414141424242414141414141414141414141414141414141414141414141414141414141404141414141414141414141414141404141414141414141404141404141414141414140414141414171714141424241414140414141414141414041414141414141414141
4141424241414141424141414141424141414141414141414142424141414141414141414141414141404141707070707070704141414141414142414141414141404141414141414141414141414141414141414141414140404041414141414141414171717040404141414141414141414141424041414141414041414141
4141414042424141424141414a4b424141414141414141414141414141414140414041414140414141404141717171717171714041414141404241414141414141404140414141414141414140404040414141414141414141404141414141404141414141717141414141414141414041414141427070704170707041414140
4141414142504141414141415a5b414141414141414141414141404141414141414141414141414141404141717141414171714141414142424141414141414141404140404141414141414141414141414141414141414040404141414141414140414141717141414141414141414141414141427141717071417141414141
4141414140414141414141414141414141417070704140414141414140414141414141414141414141404141717141414171714141414142414141414141414170707041414141414041414141414141707070704141414141414141414241414141414141717141414141414141414141414141427170714071707141404141
4141414140414141414041414141414141417171717070414141414141414041414141414141414141404141717170707071714141414142414141414140424171717141414141414041414141417070717171714141414141414141414142414141404141717141414141414141414141414141414141414141414141404142
4141414142404141414141414143414141414171717171414141414141414140404141414141414141424241717171717171714141404041414141414141424141414141424141414141414141707171717171714141414041414141414141404141414141417141414040414141414141414142414141414141414141414142
4141414142414141414141504141414141414171717171414141414141414142414141414141404242414140414241404141414141424141414141414141414241414141414141414141414141717171717141414141414041414141414141414141414141417141414141414141414141414141424141414141404041414142
4141414142414141414141414241414150414041414141414041414141414141414241414141414141414141414140414041414142424141414141414141414240414141414141414141414141717171717140404141414041414141414141414141414141414141414141414141404141414141414241414141414140404141
4141415041414040404041424241414141414040414141414041414141414241414141414141404141414141414141414141414241414141414141414141414141404141414141414141414141717171717141414141414141414141414140414141414041414141414140414040414141414141414141424041414141414141
4141414141414041414141415041414141414141414141414041414141414241414141414141414041414141414141414141414141404141414141414141404040414141404141414141414141424141414141414141414141414141414041414141414041414141404041414141414141414141414140414142414141414041
4141414141404141424141414141414140414141414141414141414141414141414141414141414041414141414141414141414141414141414141414140404141414141414141414141414141404141414141414141414141414141404041414141414141414141414141414141414141424141414041414141414141414141
4141414140414141424240414140414141414141414141414141414141414141414141404141414141414141414140414141414141414141414141404141414141414141414141414141414141414041414141414141414141414141404141414141414141414141414141414141414141414141404141414141414141414141
4141414141415041414141414141414141414141414141414141414141414141414142424141414141414141414141414141414141414141414141404141414141414141414141414141414141414040414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141
__sfx__
000400003c0001e0502d0603a03025050280002b0002f00030000340003a0003e00000000280002b0002a0002c0002f00033000372002c20001200042000020000200012003d20038200312002a200272002b700
000400000d52012530065000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002a0502a0102a000230001c7001c70025000370002a0022470228702237023500239002370023c0023b002390023c0023b0021d7022770234002320023400231002330023100200000000000000000000
000200002e030350502c070243501c0001c000190001500017000170001700013000180001700016000120000e0001b0001d0001c0021b0000b0021a0001a0001800018002170001600018000130001000000000
00010000196531965311633116130805205050020500004000040111002a000000002720022300000000000020400207000000000000000000000000000000000000000000000000000000000000000000000000
0001000019653196533e5631165311652080400501002010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002962329623050532161321612000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001322600106027002c00024300326002010006600010001a1001d10021100212002520022200232002c2002620028200272002b2002d2002a2002f2002010006600010001a1002f2002b2002f2002e200
000100000663009010050002160021600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000662001050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100000660001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41434344
00 41424344
00 41424344
00 41424344
00 41424344
00 41434344

