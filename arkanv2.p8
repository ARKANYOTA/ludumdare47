pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
bdebug = true

--velocite
cx = 0
cy = 0

--pos
x = 64
y = 46
rot=0
sprt=1
anims={
	{1,4},
}

-->8
function _update60() 
	--movement
	if btn(➡️) then
		x+=1
	end
	if btn(⬅️) then
		x-=1
	end
	if btn(⬆️) then
		y-=1
	end
	if btn(⬇️) then
		y+=1
	end
	
	--camera pos
	if (x)-cx>120 then
		cx +=1
	end
	if (x)-cx<10 then
		cx -=1
	end
	if (y)-cy>120 then
		cy +=1
	end
	if (y)-cy<10 then
		cy -=1
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
	if y>248 then
		y =1
		cy = 0
	end
	if y<0 then
	 y = 247
	 cy = 120
	end 
	
	--camera
	camera(cx,cy)
end
-->8
function _draw()
	cls()
	map(0,0)
	--sprite
	spr(1, x,y,1,1)
	if(bdebug) then debug() end
end
-->8
function debug()
		print("x: "..x,10+cx,16+cy,3)
		print("y: "..y,10+cx,22+cy,3)
		print("cx: "..cx,10+cx,28+cy,3)
		print("cy: "..cy,10+cx,34+cy,3)
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
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e88eee88eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e888e888eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee88e88eeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000040000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400040400
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000004000000000400
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000400000000040400
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000004000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000004000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000040400000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000004000000000000
14141414141414141414141414141414141414141414141414141414141414141414141414141400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000400000004000000
14000000000000000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000004040000000000000000000000040000000000000404
14000000000000000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000004
14000000000000000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404040004040400000000
14141414141414141414141414141414141414141414141414141414141414000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404000000
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040400
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040404000000
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141404040404141414
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000014
14000000000000000000000000000000000000000000000000000000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404040404000014
14141414141414141414141414141414141414141414141414140000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400040000000014
14000000000000000000000000000000000000000000000000140000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000014
14000000000000000000000000000000000000000000000000140000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404040400000014
14000000000000000000000000000000000000000000000000140000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000014
14000000000000000000000000000000000000000000000000140000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000014
14000000000000000000000000000000000000000000000000140000000014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040400000014
14000000000000000000001414141414141414141414141414141414140014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040404000000000014
14000000000000000000001400000000000000000000000000140000140014000000000000001400000000000000000000000000000000000000000000000000
00000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000014
14141414141414141414141414141414141414141414141414141414141414141414141414141400000000000000000000000000000000000000000000000000
00000000000000000000141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414040414141414
__map__
4141414141414141414041414141414141414141414141414141414141404141414141414141414041414141414141414141414140414141414141414141414141414040414141414141414141414141414141414141414141414141414141414141414141414141414141414141414140414141414141414141414141414141
4141414141414141404141414141404141414141414041414141404141404141414141404141414141414141414041414141414141414141414141414141414140404141414141414141414141414141414141414040414141414141414141414141414141414041414140404141414141414141414141414140414141414141
4140414141414141414140414141414141414141414141414141414141414141404041414140414141414141414141404141414141414141414041414141414141414141414141414141404141414141414141404041414141414141414141404141404141414141414141404141414141414141414140414140404141414141
4141414141404141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414041414141414141414141414141404141414140414141414040414141414141414141414041414140404140404140414141414141414141414141414141414141414141414141414141414140
4141414141414141414041414140414141414141414141404141414141414041414141414141414140404141414141414141414141414140404041414140414141404141414141414141414041414141414141414141414041414141414141414141414140414141414141414141414141414041414141414141414141414140
4141414041414141414141414140414140414141414141404141414141414141414141414141414041414140414141414141414141414141414141404140414141414141414141414141414141414141414141414141414041414141414141414141414140414141414141414141414141414140404141414140404141414141
4141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414041414141414141404141414141414041414141414141414141414141414141414141404141414141414041414141414141414141414141414141414141404141414141414141414041414141414141414141
4141414141414041414141414141414141414141404141414141414141414141414141414141414141414040414141414141414141404141414141414141414141414141414141414141414141404141414141414041414041414141414041414140414141414141414141404141404141414141414041414141414140404141
4141414141414141414141414141414141414141414141414141414141414141414041414141414140414140414141414140414141414141414141414141414141414141414141414140414141414141414141414141414141414141414041414141414141414141414141404141414141414141414041414141414141404141
4140414141414141414141414141404141414141414141414141414141414140414141414041414141414141414141414141414141414141414141414141414141414041414141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414140414141404141
4141414141414141414141404041414141404141414141414141414140414141414141414141414141414141414140414141414141414141414141414141414141414141414140404141414141414141414141414140414141414041414141414141414141414141404141414141404141414141414141414141414041414141
4141414140414141414141414141414141414141404141404141414141414141414141414141414141404141414141414141414140414140414141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141404141414140
4141414141414141414141414141414141414141414141404141414141414141414141414141414140404141414141414141414141414141414141404041414141414140414141414141414141414141414141414141414141414141414141414041414141414141404141414141414140404141414141414141414141414141
4141414141414140414141414140414141414141414141414141414141414141414141414141414141414141414141414141414040414141414141414141414141414141414141414141404041414140414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141404141
4141414141414041414141414141414141414041414141414141414141414141414041414140414141414141414141414141414141414140414141414141404141414141414141414141414141414141414141414140414141414141414141414141414140414141414141414141414141414141414141414141414041414141
4140414141414141414141414141414141414141414141414141414041414141414141414141414141414141414041414141414141414141414040414141414141414141414141414141414141414141414141414141414141414140414141414141414141414141414141414041414141414141404041414141414041414141
__sfx__
000100001100034000310002d0002900025000230001f0001d0001c0001a000170001600000000140001300012000120001100010000100001000011000120001200014000170001c00021000280002f00031000
