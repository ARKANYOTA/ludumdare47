pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
bdebug = true

--velocite
vx = 0
vy = 0
cx = 0
cy = 0
--pos
x = 0
y = 0
rot=0
sprt=1
anims={
	afk={1,7,4,9},
}

safearea=1
menu=true
-->8
--update
function _update60() 
	--movement
	if menu and not bdebug then
		if mid(1,btnp(),63)==btnp()then
			menu=false
		end
	else
	 if btn(⬅️) 										and 
	 			not (icol(x,y))			and 
	 			not (icol(x,y+7))	then 
	 	x-=1
	 	rot=3
	 end
	 if btn(➡️)  									and 
	 			not (icol(x+7,y))			and 
	 			not (icol(x+7,y+7))	then
	  x+=1
	 	rot=1
	 end
	 if btn(⬆️) 										and 
	 			not (icol(x+1,y-1))	and 
	 			not (icol(x+6,y-1))	then
	  y-=1
	  rot=0
	 end
	 if btn(⬇️)  										and 
	 			not (icol(x+1,y+8))	and 
	 			not (icol(x+6,y+8))	then
	  y+=1
	  rot=2
	 end
	
		x+=vx
		y-=vy
		vx=0
		vy=0
		if (x*16)>120 then
			cx =1
		else
			cx = 0
		end
		--camera
	end
end
-->8
--draw
function _draw()
	cls()
	if menu and not bdebug  then
		print("main menu",64,64,7)
	else
		map(0,0)
		--sprite
		spr(anims.afk[rot+1],x,y,1,1)
		if(bdebug)debug()
	end
end
-->8
function debug()
		print("x: "..x,10,16)
		print("y: "..y,10,22)
		print("cx: "..cx,10,28)
		print("cy: "..cy,10,34)
end
-->8
--functions
function icol(px,py)
  px/=8
  py/=8
	 return fget(
	 	mget(px,py))==0x1
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e88eee88eeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e888e888eeeeeeeeee8e8eee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee88e88eeeeeeeeeee8e8e8e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeee888ee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeee8eee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee33311eeeeeeeeeeeeeeeeeee1111eeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e3333311eddd1eeeeddd1eeee100001eeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e3311e31dd1ddd1edd998d1e10000001eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e331ee31d1dddd11d998dd1100000000eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3331eee1dddd1d11d88d198100000000eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3311eeeeddd11d11ddd1998100000000eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3311eeeeddddd111dddd9811e000000eeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e31eeeeee111111ee111111eee0000eeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4141414141414141414041414141414142424141414141414141414141404141414141414141414041414141414141414141414140414141414141414141414141414040414141414141414141414141414141414141414142414141414141414141404141414141414141414142414140414141414141414141414141414041
4141414140414150404141414141404141414141414041414141404141404141414141404141414141414141414041414141414141414141424141414141414140404141414141424141414141414141414141414040414141414141414141414141414141414041414140404141414141414140414141414140414141414141
4140414142414142504140414141414141414141414141414141414141415141404041414140414241414141414141404141414141414141414041414141414141414141414141414141404141414141424141404041414141404141414141404141404141414141414141404141424242414141414140414140404240414141
4141414141404141414141414141414141414141414141414141414141414242414041414141414141414141414142414141414041414141414141414141414141404141414140414141414040414141414141414141414041414140414140424141414141414141414141414140414141414141414141414141414141414140
4141414141414141414041514140414141414140514141404141414141414041414141414141414140404141414142414141414141414140404041414140414141404141414141414141414241414141414141414141414141414141414141414141414141414141414141414141414141414041414141414141414142414140
4041414041504141414141415140414140414141414141404141414141414142414141414141414041414140414141414141414141414141414141424140414141424241414141414141414141414141414142414141414141414141414141414141414140424141404141414141414141404140404141424140404141414141
4141424141414141414140414141414141414141414141414141414141414141414141414241414141414141414041414141414141404141414141414041414141414141414141414141414141414141404141414141414141414141414241414141414141414141414141404141414141414141414041414141414141414141
4141414141414041414141414141414141414141404141414141414141414141414141424141414141414040414141414141414141404141414141424141414141414141414141414141424141404141414141414041414041414141414041414140414141414141414141404241404141414141414041414141414140404141
4141414141414141424241414241414141424241414141414141414141414141414041414141414140414140414141414140414141414141414141424141414141414141414141414140414141414141414141414141414141414141414041414141414141414141414141404142414141414141414041414141414141404141
4140414141414141504141414141405141414141414151414141414141414140414141414041414141414141414241414141414141414141414141414141414141414041424141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414140414141404141
4141414141415141414141404041414141404141414141414141414140414141414141414141414241414141414140414141414141414141414141414141414141414141414140404141414141414141414142414140414141414041414242424141414141414141404141414141404141414141414141414141414041414241
4141414140424141414141414141414141414141404141404141414141414141414141414141414141404141414141414141414140414140414141414241414141414140414141414241414141414141414141414241414141414141414141414141414041414141414141414041414141414241414140414141404141414140
4041414141414141414141414141414141414141424141404141414141414141414141414141414140404141414141414141414141414141414141404041414141414140414141414141414141414141414141414141414141414141414141414041414141424141404141414141414140404141414141414141424241414141
4141414141414140414141414140414141414141414141414141414141414151414141414141414141414141414141414141414040414141414141414141414141414241414141404141404041414140414141414141414141414141414141414041414141414141414141414141414041414141414141414141414141404141
4141414141414041414141414141414141414041414141414141414241414141414041414140414141414141414141414141414141414140414141414141404141414141414141414141414141414141414141414140414141414141414141414141414140424141414141414141414141414141414141414141414041414141
4140414141414141504141414041414141414141414140414141414041414141414141414141414141414141414042414141414141414141414040414141414141414141414141414141414141414141414141414141414141414140414141414141414141414141414141414041414141414141404041414141414041414140
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100001100034000310002d000290002c1002c1001f0002a1001c0001a000170001600028100140001300012000120002410023100221002210011000120001200014000170001c00021000280002f00031000
__music__
00 41434344

