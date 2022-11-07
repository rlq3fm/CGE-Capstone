*//file for static model test
*updated on 2018/01/16

*== policy shock for static model ==============================================

*== national emission cap
clim=2;
clim0 = 0.9;

CHEER.iterlim =100000;

$include CHEER.gen

*EXECUTE_LOADPOINT 'CHEER_p';
solve CHEER using mcp;
CHEER.Savepoint = 1;

display CHEER.modelstat, CHEER.solvestat;


