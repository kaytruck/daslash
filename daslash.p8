pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- daslash
-- by kaytruck

#include main.lua
#include common.lua
#include map.lua
#include player.lua
#include enemies.lua

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccc00000ccc00000ccc00000ccc00000ccc00000ccc00000ccc0000cccc0000cccc00000000000000000000000000000000000000000000000000
00700700000c7500000c7500000c7500000c7500000c7500000c7500040c754000cccc0440cccc00000000000000000000000000000000000000000000000000
00077000000ccc00000ccc00000ccc00000ccc00000ccc00000ccc000c0ccc0000cccc0000cccc00000000000000000000000000000000000000000000000000
00077000000c0000004c0000000c0000000c0000000c0000004c000000cc00c0040c00000000c040000000000000000000000000000000000000000000000000
007007000040c0400000c0400040c4000004c4000040c0400000c4000000c000000cc000000cc000000000000000000000000000000000000000000000000000
00000000000cc00000cc00000000c000000d0c00000cd000000c0000000d0c0000c0000000000c00000000000000000000000000000000000000000000000000
0000000000c00c0000000d00000cd00000d00c0000c0000000000d00000d0c0000000c0000c00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000040dd0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000ccc060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006000000c75676000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000600000006ccc607600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000060000046c0d417600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000670000c600776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660cc6077660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000099c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0099c000009cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009cc000009990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000009555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09956550090560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00059000009990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09000900009090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002800000028000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20002220200022200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02222000022220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02222200222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
ffffffe20000000000000000222222220d0000d00000000000000000003333000000000000000000000000000000000000000000000000000000000000000000
f22222e20000000000000000ffffffff0dddddd0000000000000000003bbbb300000000000000000000000000000000000000000000000000000000000000000
f22222e20000000000000000ddddd66d0d0000d0000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
f22222e20000000000000000222222220dddddd0000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
f22222e20000000000000000222222220d0000d0000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
f22222e20000000000000000222222220dddddd0000000000000000003a33b300000000000000000000000000000000000000000000000000000000000000000
eeeeee220000000000000000444444440d0000d0000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
222222220000000000000000222222220dddddd0000000000000000003333b300000000000000000000000000000000000000000000000000000000000000000
00000777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077666666666666667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00766dddddddddddddd6670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
076dddddddddddddddddd67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
076dd66666666666666dd67000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6555555555555556dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6742444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6742444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6722222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6744444424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6744444424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6722222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6744424444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6722222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76dd6500000000000056dd6700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66dd6500000000000056dd6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddd6500000000000056dddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd655000000000000556ddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66655000000000000005566600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55550000000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000999c000000cccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000099cc00900000cc750006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000800099cc09000000cccc0066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000808999900500400cc000667760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080eeee00005500044c6cc00470776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000998080e500000000c1c0400076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000089990550e000000ccc66060076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009000500e00000c17606600076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008e0e888809900060cc06770000766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000888990009000060c67760007660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00008899090099900007076000077600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099000000000066760000776600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000090000090077606000077766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00009900700066700600607776660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00079070006676060007077666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007d00600000070766600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000070000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000001140000000000000000000000010101000000000000000000000000000100010f0000000000000000000000000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a3a30084a3a3a3a3a3a3a38400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000084000000000000008400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000084000000000000008400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000084000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000a3a3a3a3a384000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a300000000000084000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a300000000000084000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a3a3a3a3a3a3a384a30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000840000000000a300a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000840000008400a3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a3a3a3a3a3a3a3a3a3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
