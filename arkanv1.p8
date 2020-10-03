pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--by arkanyota,
--theobosse and 
--yolwoocle
bdebug = true
clock=0
--camera
cx = 0
cy = 0
--pos
cux=0
cuy=0
x = 64
y = 0
rot=0
sprt=1
mt=0
anims={
	afk={1,7,4,9},
}

safex=1
safelen=128
--inventory
inv={w=0,s=0,i=0}
open=false

-->8
--update
function _update60() 
	--movement
	if menu then
		upmenu()
	else
		clock+=1
	 cpos()
	 
	 movement()

--hot and cold zones
		if(clock%6==0)safex+=0.75
		if(safex>1024)safex=0
	 
	 
	 if mt == 120 then
	   mining(cux/8, cuy/8)
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
	if menu then
		drmenu()
	else
		map(0,0)
		map(0,0,1024,0, 8, 16)
		map(120,0,-64,0, 8, 16)
		--hot zone
		rectfill(0,0,safex,127,9)
		rectfill(safex+safelen,0,1024,127,12)
		
		--sprite
		spr(anims.afk[rot+1],x,y,1,1)
		spr(16,cux,cuy)
		
		--slots
		spr(96,cx+20,cy+110,1,1)
		spr(97,cx+35,cy+110,1,1)
		spr(98,cx+50,cy+110,1,1)
		color(7)
		printui(inv.w,22,119)
		printui(inv.s,37,119)
		printui(inv.i,52,119)
		
		--inventory
		if open then
		  rectfill(cx+25,cy+25,cx+100,cy+100,2)
		  rect(cx+23,cy+23,cx+102,cy+102,1)
		  
		  rectfill(cx+35,cy+30,cx+55,cy+40,1)
		end
		
		if(bdebug)debug()
	end
end
-->8
--debug
function debug()
		color(7)
		printui("x: "..x,10,16)
		printui("y: "..y,10,22)
		printui("cx: "..cx,10,28)
		printui("cy: "..cy,10,34)
		
		printui("mt: "..mt,10,52)
		printui("wood: "..inv.w,10,58)
		printui("stone: "..inv.s,10,64)
		printui("😐: "..mget(cux/8, cuy/8),10,46)
		printui("◆: "..fget(mget(cux/8, cuy/8)),10,80)
		printui("safe: "..safex,10,70)
		
end
-->8
--functions
function icol(px,py)
  px/=8
  py/=8
	 return fget(mget(px,py))==0x1
	 or fget(mget(px,py))==0x3
end

function printui(txt,txtx,txty,col)
 print(txt,txtx+cx,txty)
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


bdebug = true

--velocite
--camera
cx = 0
cy = 0
--pos
x = 64
y = 46
rot=0
sprt=1
mine=0
anims={
	afk={1,7,4,9},
}

safearea=1
menu=true
mine = 0
-->8
intmenu = 0
tuto = false
function upmenu()
	--btn control

 if btnp(⬇️) then intmenu -=1 end
 if btnp(⬆️) then intmenu +=1 end
 if btnp(❎) or btnp(🅾️) then
  if intmenu%2==0 then
 		menu=false
 	end
 	if intmenu%2==1 then
 		tuto=not tuto
 	end
 end
 
 
 
 
end

function drmenu()
	--print("arkan theodore yolwoocle elza")
	--print(tuto,0,6,7)
	--affiche
	if intmenu%2==0 then
 	spr(130,56,40, 2,1)
 else
 	spr(128,56,40, 2,1)
 end
 if intmenu%2==1 then
 	spr(146,56,50, 2,1)
 	spr(4,46,50, 1,1)
 else
 	spr(144,56,50, 2,1)
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
end


function movement()
mf=0x3
if btn(⬅️) and 
	 not open then 
	 	 if not (icol(x,y))			and 
	 			  not (icol(x,y+7))	then 
	 	 x-=1
	 	 end
	 	rot=3
	 end
	 if btn(➡️) and 
	 not open then
	   if not (icol(x+7,y))			and 
	 			  not (icol(x+7,y+7))	then
	   x+=1
	   end
	 	rot=1
	 end
	 if btn(⬆️) and 
	 not open then
	   if not (icol(x+1,y-1))	and 
	 			  not (icol(x+6,y-1))	then
	   y-=1
	   end
	  rot=0
	 end
	 if btn(⬇️) and 
	 not open then
	   if not (icol(x+1,y+8))	and 
	 			  not (icol(x+6,y+8))	then
	   y+=1
	   end
	  rot=2
	 end
	 
	 if btn(🅾️) and 
	 not open then
   if rot==0 and
     fget(mget(cux/8, cuy/8))==mf
    	then
       mt+=1
   elseif rot==1 and
     fget(mget(cux/8, cuy/8))==mf
     then
       mt+=1
   elseif rot==2 and
     fget(mget(cux/8, cuy/8))==mf
     then
       mt+=1
   elseif rot==3 and
     fget(mget(cux/8, cuy/8))==mf
     then
       mt+=1
   else
     mt=0
   end
 else
   mt=0
 end
 
 if btnp(❎) then
   if open then
     open=false
   else
     open=true
   end
 end
end

function mining(x, y)
  if mget(x,y)==80 then
    inv.w+=1
  elseif mget(x,y)==81 then
    inv.s+=1
  elseif mget(x,y)==82 then
    inv.i+=1
  end
  mset(x,y,67)
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeee88eeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeee88e8e8e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e88eee88eeeeeeeeeeeeeeeee8e888ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e888e888eeeeeeeeee8e8eee8e888e88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee88e88eeeeeeeeeee8e8e8ee88e888e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeee888ee88e888e8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeee8eeee8888e8e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeee88e8ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee44422eeeeeeeeeeeeeeeee22222222bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e4444422eddd1eeeeddd1eee22222222bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44422e42dd1ddd1edd998d1e22222222bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4442ee33d1dddd11d998dd11bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4442e333dddd1d11d88d1981bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4422e333ddd11d11ddd19981bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4422ee31ddddd111dddd9811bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e42eeeeee111111ee111111ebbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000400000000000099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000044400066560009aa999800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00044442066666509aa9999800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444420666665509a99998800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04444200666666509999998000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44442000665665509999880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04420000055555008998800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200000000000000888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003b00000088000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007777770083bbb0008888880
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777718a8bbb0080000808
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000771110831b10080800808
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007710000eebe0080008088
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077100003bbb0080808088
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000771000444444008888880
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000022220000088000
05555000000000500888800000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555000000000508888800000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05500555505000550880088880800088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00550550555005550088088088800888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050055005555550008008800888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05550055550005000888008888000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55000000000000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000500000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00500000505500000080000080880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00505000505555000080800080888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055005550505500008800888080880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050505050505500008080808080880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050555000555000008088800088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055500000000000008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030303010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4141414141414141414041414141414142424141414141414141414141404141415252414141414041414141414141414141414140414141414141414141414141414040414141414141414141414141414141414141414142414141414141414141404141414141414141414142414140414141414141414141414141414041
4141414140414150404141414141404141414141414041414141404141404141414141404141414141414141414041414141414141414141424141415151514140404141414141424141414141414141414141414040414141414141414141414141414141414041415252404141414141414140414141414140414141414141
4140414142414142504140414141414141414141414141414141414141415141404041414140414241515141414141404141414141414141414041414141414151414141414141414141404141414141424141404041414141404141415141404141404141414141414141525241424242414141514140414140405040414141
4141414141404141414141414141414141414141414141414141414141414242505041414141414141414141414142414141414041414141414141514141414141404152414140414141414040414141414141414141414041414140414151515151515151514141414141414140414141414141414141414141414141414151
4141414141414141414041514152414141414140514141404141414141414041505041414141414140404141414142414141414141414140505050515050505050505050505050505050505050505041414141414151414141414141414141415141505041514141414141414141414141414041414141505041414142414140
4041414041504141414141415140414140414141414141404141414141414142414141414141414041414140414141414141414141414141414141425140414141424241414141414141414151514141414142414141414141414141414141415151515151514141404141414141414141404140404141424140404141414141
4141424141414141414140414141414141414141414141414141414141414141414141414241414141414141414041414141414141404141414141415141414141414141414141414141414141414141404141414141414141414141414241414141414141414141414141404141414141414141414041414152414141414141
4141415041414041414141414141414141414141404141414141414141414141414150424141414141414040414141414151514141404141414141424141414141414141415141414141424141404141414141414041414041414141414041414140414152414141415051405141404141414141414041414141414140404141
4141414141414141424241414241414141424241414141415353535341414141414041414141414140515140414141414140414141504141414141424141414141414141415141414140414141414150414141414141414141414141414041414141414152414141415050404151514141414141415141414141414141404141
4140524141414141504141414141405141414141414151415454545441414140414141414041414141414151514241414141414141414141414141414141414141414041425151414141414141414140414141414141414141414141414141414141414141414141415050414141414141414141414141414140415041404141
4141414141415141414141404041414141404141414141415454545440414141414141505041414241414141414140414141414141414141414141414141414141414141414140404141414141414141414142414140415051505051414242424141414141414141404141414141405141414141414141414141414041414241
4141414140424141414141414141414141414141404141404141414141414141414141414141414141404141414141414141414140414140414141414250504141414140414141414241504141414141414141414241415051505041414141414141414041414141415241414041415151414241414140414141404141414140
4041414141414141414141414141414141414141424141404141414141414141414141414141414140404141414141414141414141414141414141404041414141414140414141414141414141414141414141414141415151414141414141414041414141424141404141414141414140404141414141414141424241414141
4141504141414140414141414140414141414141414141414141414141415151414141414141414141414141414141414141414040414141414141414141414141414241414141404141404041414140414141414141414141414141415141414041414141414141414141414141414041414141414141414141514141404141
4141414141414041414141414141414141414041414141414141414241414141414041414140414141524141414141414151414141414140414141414141404141414141414141414141414141414141515141414140414141414141414141414141414140424141414141414141414141414141414141414141414041414141
4140414141414141504141414041414141414141414140414141414041414141414141414141414141414141414042414141414141414141414040414141414141414141414141414141414141415151414141414141414141414140414141414141414141414141414141414041414141414141404041414141414041414140
__sfx__
010100001100034000310002d000290002c1002c1001f0002a1001c0001a000170001600028100140001300012000120002410023100221002210011000120001200014000170001c00021000280002f00031000
010100001100034000310002d000290002c1002c1001f0002a1001c0001a000170001600028100140001300012000120002410023100221002210011000120001200014000170001c00021000280002f00031000
__music__
00 41434344
00 41424344
00 41424344
00 41424344
00 41424344
00 41434344

