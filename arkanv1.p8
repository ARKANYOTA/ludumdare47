pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--chaser of dawn
--by arkanyota
--theobosse
--yolwoocle
--and elza
sp = 0 --0=blanc; 1=jaune; 2=rouge
bdebug = false
clock=0
--camera
cx = 0
cy = 0
--pos
cux=0
cuy=0
x = 64
y = 46
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

safex=1
safelen=128
--inventory

safearea=1
menu=true

--de 1 a 3
--pioche(pixaxe)
p=1
--hache(axe)

a=1
pmax = 3
amax = 3
inv={w=16,s=0,i=0,c=0,m=0}

open=false
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
		w={64,64,64,64},
		s={64,64,64,64},
		i={64,64,64,64},
		c={64,64,64,64},
		m={64,64,64,64}
	}
}
sobj = 0

debugvar = 0
-->8
--init update
function _init()
 poke(0x5f2d, 1)
end

function _update60() 
	--movement
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
--hot and cold zones
		if(clock%6==0)safex+=0.75
		if(safex>1024)safex=0
	 
	 m=mget(cux/8, cuy/8)
	 if mt==gettime(m) then
	   mining(cux/8, cuy/8)
	 end
	 
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
		
			--tp haut-bas g-d
		if x>1016 then
			x =1
			cx = 0
		end
		if x<0 then
		 x = 1015
		 cx = 895
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
		canmine(m) then
		  color(1)
		  pe=((mt/t)*100)\1
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
		  
		  print(pe.."%",lx,ly)
		  color(0)
		end
		
		--inventory
		--func invsee page 6
		if open then invsee() end
		
		--func debug page 3
		if(bdebug) then debug() end
		
		drawhotbar()
	end

		moux=stat(32)
		mouy=stat(33)
		pset(moux+cx,mouy,3)	 
		color(7)
		print("",moux+cx,mouy+2)
		print("x "..moux+cx)
		print("y "..mouy)
		print("px "..x)
		print("py "..y)
end
-->8
--debug
function debug()
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
      return 90
    elseif a==2 then
      return 70
    elseif a==3 then
      return 40
    else 
      return 120
    end
  elseif material==81 then
    if p==1 then
      return 120
    elseif p==2 then
      return 90
    elseif p==3 then
      return 70
    end
  elseif material==82 then
    if p==1 then
      return 160
    elseif p==2 then
      return 130
    elseif p==3 then
      return 100
    end
  elseif material==83 then
    if p==2 then
      return 100
    elseif p==3 then
      return 75
    elseif p==4 then
      return 50
    end
  elseif material==84 then
    if p==2 then
      return 220
    elseif p==3 then
      return 220
    elseif p==4 then
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
info = true
function upmenu()
	--btn control

 if btnp(⬇️) then intmenu +=1 end
 if btnp(⬆️) then intmenu -=1 end
 if btnp(❎) or btnp(🅾️) then
  if intmenu%4==0 then
 		menu=false
 	end
 	if intmenu%4==1 then
 		tuto=not tuto
 	end
 	if intmenu%4==2 then

 	end
 	if intmenu%4==3 then
			info=not info
 	end
 end
 if intmenu%4==2 then
  if btnp(⬅️) then sp =(sp+1)%3 end
  if btnp(➡️) then sp =(sp-1)%3 end
-- 	if btnp(⬅️) then sp =sp+1 end
-- 	if btnp(➡️) then sp =sp-1 end
	end
 
 
 
 
end

function drmenu()
	--affiche
	if intmenu%4==0 then
 	spr(130,56,40, 2,1)
 else
 	spr(128,56,40, 4,1)
 end
 if intmenu%4==1 then
 	spr(146,56,50, 2,1)
 else
 	spr(144,56,50, 4,1)
 end

 if intmenu%4==2 then
 	spr(162,56,60, 2,1)

 	spr(4+(sp*16),46,60, 1,1)
 else
 	spr(160,56,60, 4,1)
 end
 if intmenu%4==3 then
 	spr(178,56,70, 2,1)
 else
 	spr(176,56,70, 2,1)
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

	if info then
 	 color(7)
     print("mADE BY:",3,81)
     line(3,87,32,87)
     for i=0,3 do
	 spr(i+124,3,90+i*9)
     print("theobosse - code",14,92)
     print("arkanyota - code",14,101)
     print("yolwoocle - code and art",14,110)
     print("elza - sound",14,119)
    end
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
	 canmine(m) then
   if rot==0 and
     fget(m)==mf
    	then
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
     mt=0
   end
 else
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
 spr(96,cx+25,cy+28)
	spr(97,cx+35,cy+28)
	spr(98,cx+45,cy+28)
	color(7)
	printui(inv.w,27,38)
	printui(inv.s,37,38)
	printui(inv.i,47,38)
end

function invsee()
	
	rectfill(
		cx+25,cy+25,
		cx+100,cy+100,12)
	rect(
		cx+23,cy+23,
		cx+102,cy+102,1)

	
	
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
		printui("max lvl reached",37,82, 11)
	end

	--hache
	--upgrade hache
	--hache actuelle
	rectfill(cx+25, 91, cx+25+9, 91+9, 1)
	spr(84+a, cx+26, 92)
	if amax>=a then
		--pioche vers upgrade
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
		rect(cx+25, 69, cx+25+9, 69+9, 7)
	else
		rect(cx+25, 69, cx+25+9, 69+9, 0)
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
 	 --[[if not (req.f[p] == nil )and 
 	 		 not (inv.w < req.p.w[p]) and
	 	 	 not (inv.s < req.p.s[p]) and
 	  	 not (inv.i < req.p.i[p]) then
 			inv.w -= req.p.w[p]
 			inv.s -= req.p.s[p]
 			inv.i -= req.p.i[p]
 			p+=1
 			
 		end]]
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
 	 if not (req.a.w[a] == nil )and 
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
__gfx__
00000000066666600666666006666660077777700777777007777770077777700777777007777770077777700000000000000000000000000000000000000000
00000000677775566777755667777556765555677655556776555567777655557776555555556777555567770000000000000000000000000000000000000000
00700700777775577777755777777557751111577511115775111157776511117765111111115677111156770000000000000000000000000000000000000000
00077000777775777777757777777577717111177171111771711117776171117761711111171677111716770000000000000000000000000000000000000000
00077000677775766777757667777576711111177111111771111117777111117771111111111777111117770000000000000000000000000000000000000000
00700700076666600766666007666660077777700777777007777770077777700777777007777770077777700000000000000000000000000000000000000000
00000000067777606077770606777760067c8760607c8706067c87600677c8606077c806068c7760608c77060000000000000000000000000000000000000000
00000000006006000060000000000600006006000000060000600000006006000600006000600600060000600000000000000000000000000000000000000000
77000077055555500555555005555550099999900999999009999990099999900999999009999990099999900000000000000000000000000000000000000000
70000007599995555999955559999555995555999955559999555599999555559995555555555999555559990000000000000000000000000000000000000000
00000000999995599999955999999559951111599511115995111159995511119955111111115599111155990000000000000000000000000000000000000000
00000000999995999999959999999599919111199191111991911119995191119951911111191599111915990000000000000000000000000000000000000000
00000000599995955999959559999595911111199111111991111119999111119991111111111999111119990000000000000000000000000000000000000000
00000000095555500955555009555550099999900999999009999990099999900999999009999990099999900000000000000000000000000000000000000000
70000007059999505099990505999950059c8950509c8905059c89500599c8505099c805058c9950508c99050000000000000000000000000000000000000000
77000077005005000050000000000500005005000000050000500000005005000500005000500500050000500000000000000000000000000000000000000000
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
eeeeeeeeeeeeeeeeeeeeeeeeee88eeeeeeeceeee0044430000555f000099990000cccc00000000000000000000000000000000000000000000000eeeee100000
eeeeeeeeeeeeeeeeeeeeeeeee88e8e8eeeeeeeee0222432001115f10099999900cccccc00000000000000000000000000000000000000000000eeeeeeee11000
e88eee88eeeeeeeeeeeeeeeee8e888eeeeceecce000033330000ffff090044990c0044cc000000000000000000000000000000000000000000eeeeeeeeee1100
e888e888eeeeeeeeee8e8eee8e888e88ecc8e88e0004434200044f5100044499000444cc00000000000000000000000000000000000000000eeeeeeeeeee1110
ee88e88eeeeeeeeeee8e8e8ee88e888eee88e8ee004420420044205100444099004440cc00000000000000000000000000000000000000000eeeeeeeeeeee110
eeeeeeeeeeeeeeeeeee888ee88e888e8e88eeece044200220442001104440099044400cc0000000000000000000000000000000000000000eeeeeeeeeeeee111
eeeeeeeeeeeeeeeeeeee8eeee8888e8eecceeccc44200020442000104440099044400cc00000000000000000000000000000000000000000eeeeeeeeeeeee111
eeeeeeeeeeeeeeeeeeeeeeeeee88e8eeeceeecee420000004200000004000000040000000000000000000000000000000000000000000000eeeeeeeeeeeee111
ee44422eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeee111
e4444422eddd1eeeeddd1eeeeedd11eeeddd1eee00000220000005500000099000000cc00000000000000000000000000000000000000000eeeeeeeeeeee1111
44422e42dd1ddd1edd998d1eed110d1eddee281e000044220000445500004499000044cc0000000000000000000000000000000000000000eeeeeeeeeeee1111
4442ee33d1dddd11d998dd11d110dd11dee28811000444220004445500044499000444cc00000000000000000000000000000000000000000eeeeeeeeee11110
4442e333dddd1d11d98d1981d00d1101d228ee2100444222004445550044499900444ccc00000000000000000000000000000000000000000eeeeeeee1111110
4422e333ddd11d11ddd19981ddd11101d882ee210444222204445555044499990444cccc0000000000000000000000000000000000000000001eee1111111100
4422ee31ddddd111dddd9811dddd1011dddd121144400220444005504440099044400cc000000000000000000000000000000000000000000001111111111000
e42eeeeee111111ee111111ee111111ee111111e0400000004000000040000000400000000000000000000000000000000000000000000000000011111100000
0000040000000000009999900001100000888800000220000006600000099000000cc00000000000000000000000000000000000000000000000000000000000
000044400066560009aa99980011111008222280000220000006600000099000000cc00000000000000000000000000000000000000000000000000000000000
00044442066666509aa9999801111111822ee22800255200006556000095590000c55c0000000000000000000000000000000000000000000000000000000000
00444420666665509a9999880111111182eeee2800255200006556000095590000c55c0000000000000000000000000000000000000000000000000000000000
0444420066666650999999800111111182eeee2800255200006556000095590000c55c0000000000000000000000000000000000000000000000000000000000
44442000665665509999880001111110822ee2280255552006555560095555900c5555c000000000000000000000000000000000000000000000000000000000
04420000055555008998800000111110082222800255552006555560095555900c5555c000000000000000000000000000000000000000000000000000000000
00200000000000000888000000011100008888000255552006555560095555900c5555c000000000000000000000000000000000000000000000000000000000
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
4141414141414141414041414141414142424141414141414141414141404141415252414141414041414141414141414141414140414141414141414141414141414040414141414141414141414141414141414141414142414141414141414141404141414141414141414142414140414141414141414141414141414041
4141414140414150404141414141404141414141414041414141404141404141414141404141414141414141414041414141414141414141424141415141514140404141414141424141414141414141414141414040414141414141414141414141414141414041415252404141414141414140414141414140414141414141
4140414142414142504140414141414141414141414141414141414141415141404041414140414241515141414141404141414141414141414041414141414151414141414141414141404141414141424141404041414141404141415141404141404141414141414141525241424242414141514140414140405040414141
4141414141404141414141414141414141414141414141414141414141414242505041414141414141414141414142414141414041414141414141414141414141404152414140414141404040414141414141414141414041414140414151515151515151514141414141414140414141414141414141414141414141414151
4141444141414141414041514152414141414140514141404141414141414041505041414141414140404141414142414141414141414140504041414141414150504150405040504140405041504041414141414151414141414141414141415141505041514141414141414141414141414041414141505041414142414140
4041414041504144414141415140414140414141414141404141414141414142414141414141414041414140414141414141414141414141414141425140414141424141414141414141404051514141414142414141414141414141414141415151515151514141404141414141414141404140404141424140404141414141
4141424141414141444140414141414141414141414141414141414141414141414141414241414141414141414041414141414141404141414141415141414141414141414141414141414141414141404141414141414141414141414241414141414141414141414141404141414141414141414041414152414141414141
4141415041414041414141414141414141414141404141414141414141414141414150424141414141414040414141414151514141404141414141424141414141414141415141414141424141404141414141414041414041414141414041414140414152414141415051405141404141414141414041414141414140404141
4141414141414441424241414241414141424241414141415353535341414141414041414141414140515140414141414140414141504141414141424141414141415041415141414140414141414150414141414141414141414141414041414141414152414141415050404151514141414141415141414141414141404141
4140524141414141504141414141405141414141414151415454545441414140414141414041414141414151514241414141414141414141414141414141414141414041425151414141414141414140414141414141414141414141414141414141414141414141415050414141414141414141414141414140415041404141
4141414141415141414141404041414141404141414141415454545440414141414141505041414241414141414140414141414141414141414141414141414141414141414140404141414141414141414142414140415051505051414242424141414141414141404141414141405141414141414141414141414041414241
4141444140424141444141414141414141414141404141404141414141414141414141414141414141404141414141414141414140414140414141414250504141414140414141414241504141414141414141414241415051505041414141414141414041414141415241414041415151414241414140414141404141414140
4041414141414141444141414141414141414141424141404141414141414141414141414141414140404141414141414141414141414141414141404041414141414140414141414141414141414141414141414141415151414141414141414041414141424141404141414141414140404141414141414141424241414141
4141504144414140414141414140414141414141414141414141414141415151414141414141414141414141414141414141414040414141414141504141414141414241414141404141404041414140414141414141414141414141415141414041414141414141414141414141414041414141414141414141514141404141
4141414141414041414141414141414141414041414141414141414241414141414041414140414141524141414141414151414141414140414141414141404141414141414141414141414141414141515141414140414141414141414141414141414140424141414141414141414141414141414141414141414041414141
4140414141414141504141414041414141414141414140414141414041414141414141414141414141414141414042414141414141414141414040414141414141414141414141414141414141415151414141414141414141414140414141414141414141414141414141414041414141414141404041414141414041414140
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

