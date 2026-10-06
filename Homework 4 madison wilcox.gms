$title CEE 6410 - HW4: Hydropower and Irrigation Reservoir Optimization Problem
$ontext
CEE 6410 - Engineering Systems Analysis
HW4 - Reservoir Operation Problem

Student: Madison Wilcox
Fall 2026
$offtext

* 1. DEFINE SETS
SETS
    t Time periods (months) / m1*m6 / ;

* 2. DEFINE INPUT DATA
SCALARS
    S_init   Initial reservoir storage (units)       / 5.0 /
    S_max    Maximum reservoir storage capacity (units)/ 9.0 /
    Turb_cap Turbine flow capacity (units/month)    / 4.0 /
    Min_flow Minimum in-stream flow requirement at A / 1.0 / ;

PARAMETERS
    Inflow(t) Monthly inflow (units)
        / m1 2, m2 2, m3 3, m4 4, m5 3, m6 2 /

    B_hydro(t) Hydropower benefits per unit ($/unit)
        / m1 1.6, m2 1.7, m3 1.8, m4 1.9, m5 2.0, m6 2.0 /

    B_irrig(t) Irrigation benefits per unit ($/unit)
        / m1 1.0, m2 1.2, m3 1.9, m4 2.0, m5 2.2, m6 2.2 / ;

* 3. DEFINE VARIABLES
VARIABLES
    S(t)      
    R_turb(t) 
    R_bypass(t)
    D_irrig(t) 
    Flow_A(t)   ;

POSITIVE VARIABLES S, R_turb, R_bypass, D_irrig, Flow_A ;

* 4. DEFINE EQUATIONS
EQUATIONS
    ObjFunction    
    MassBalance(t)  
    CapBound(t)     
    TurbineCap(t)   
    FlowSplit(t)    
    InstreamFlow(t) 
    EndStorage       ;

ObjFunction ..
    Z =e= sum(t, B_hydro(t) * R_turb(t) + B_irrig(t) * D_irrig(t)) ;

* Mass Balance: S_t = S_{t-1} + Inflow_t - R_turb_t - R_bypass_t
MassBalance(t) ..
    S(t) =e= (S_init$SAMEAS(t,'m1') + S(t-1)$(NOT SAMEAS(t,'m1')))
             + Inflow(t) - R_turb(t) - R_bypass(t) ;

CapBound(t) ..
    S(t) =l= S_max ;

TurbineCap(t) ..
    R_turb(t) =l= Turb_cap ;

FlowSplit(t) ..
    R_turb(t) =e= D_irrig(t) + Flow_A(t) ;

InstreamFlow(t) ..
    Flow_A(t) =g= Min_flow ;

EndStorage ..
    S('m6') =g= S_init ;

* 5. MODEL & SOLVE
MODEL ReservoirHW4 / ALL / ;
SOLVE ReservoirHW4 USING LP MAXIMIZING Z ;

* 6. DISPLAY RESULTS
DISPLAY S.L, R_turb.L, R_bypass.L, D_irrig.L, Flow_A.L, Z.L ;
DISPLAY CapBound.M, TurbineCap.M, InstreamFlow.M, EndStorage.M ;