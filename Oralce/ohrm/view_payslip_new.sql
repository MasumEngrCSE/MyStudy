create or replace view v_payslip_info
as
SELECT va.SAL_PERIOD,
             e.emp_no,
             e.emp_id,
             e.sec_no,
             e.desig_no,
             e.grade,
             w.w_day,
             p_day Payble_day,
             va.deduct_hollyday,
             va.total_leave,
             va.payble_leave,
             NVL (w.w_day, 0)- (NVL (va.p_day, 0)+NVL (va.payble_leave, 0)-NVL (va.holyday_leave, 0-NVL (TRUNC (va.late_pre / 3), 0))) absent_day,
             decode(e.ot_status,'Y',va.T_OT,0) total_OT_hour,
             decode(e.ot_status,'Y',va.E_OT,0) Extra_OT_hour,
             ROUND ((salary - 200) / 1.3) basic_sal,
             200 medical,ROUND (salary - 200 - (salary - 200) / 1.3) h_rent,
             e.salary total_salary,
             ROUND (  ROUND (NVL (ROUND ((salary - 200) / 1.3), 0) / 30, 2)* (  NVL (w.w_day, 0)- (  NVL (va.p_day, 0)+ NVL (va.payble_leave, 0)- NVL (va.holyday_leave, 0) - NVL (va.deduct_hollyday, 0)- NVL (TRUNC (va.late_pre / 3), 0)))) deduc_absent,
            
            (case 
                when NVL (adv_amt, 0) - NVL (e.monthly_deduc_adv, 0) >= 0  THEN
                    NVL (monthly_deduc_adv, 0)
                when NVL (e.adv_amt, 0) > 0 THEN
                    NVL (e.adv_amt, 0)
           end) deduc_advance,
           
           sdps_amt DEDUC_SDPS,
           d_h_abs,
         ROUND (  NVL (d_abs, 0) + NVL (sdps_amt, 0) + NVL (d_h_abs, 0)+ (case 
                                                                            when NVL (adv_amt, 0) - NVL (e.monthly_deduc_adv, 0) >= 0  THEN
                                                                                    NVL (monthly_deduc_adv, 0)
                                                                            when NVL (e.adv_amt, 0) > 0 THEN
                                                                                    NVL (e.adv_amt, 0)
                                                                           end)
                +ROUND (ROUND ((salary - 200) / 1.3) / 30, 2)* (  NVL (w.w_day, 0)- (  NVL (va.p_day, 0) + NVL (va.payble_leave, 0)- NVL (va.holyday_leave, 0)- NVL (va.deduct_hollyday, 0)- NVL (TRUNC (va.late_pre / 3), 0)))) total_deduc,
        decode(e.ot_status,'Y',round(va.T_OT*ROUND (ROUND ((salary - 200) / 1.3) / 104, 2)),0) total_ot_amt,
              
        (case  
            when va.on_day + NVL (va.late_pre, 0) =(SELECT w_day 
                                                        FROM v_working_day 
                                                        WHERE sal_period=va.SAL_PERIOD 
                                                                and unit_dept_no = e.unit_dept_no
                                                                AND work_grp = d.work_grp)  AND NVL (va.late_pre, 0) < 3 THEN
                    d.attn_bonus_amt
             else
                    0
         end) as attn_bonus_amt,
         ROUND (e.salary
                + (ROUND (ROUND ((salary - 200) / 1.3) / 104, 2) * (NVL (va.t_ot, 0)))
                - NVL (  NVL (d_abs, 0) + NVL (sdps_amt, 0) + NVL (d_h_abs, 0)
                       + (case 
                            when NVL (adv_amt, 0) - NVL (e.monthly_deduc_adv, 0) >= 0  THEN
                                NVL (monthly_deduc_adv, 0)
                            when NVL (e.adv_amt, 0) > 0 THEN
                                NVL (e.adv_amt, 0)
                            end)
                       +   ROUND ((salary - 200) / 1.3)
                                  / 30,2)
                         * (NVL (w.w_day, 0)- (  NVL (va.p_day, 0)+ NVL (va.payble_leave, 0)- NVL (va.holyday_leave, 0)- NVL (va.deduct_hollyday, 0)- NVL (TRUNC (va.late_pre / 3), 0))),0)
                +(case  
                        when va.on_day + NVL (va.late_pre, 0) =(SELECT w_day 
                                                        FROM v_working_day 
                                                        WHERE sal_period=va.SAL_PERIOD 
                                                                and unit_dept_no = e.unit_dept_no
                                                                AND work_grp = d.work_grp)  AND NVL (va.late_pre, 0) < 3 THEN
                            d.attn_bonus_amt
                        else
                            0
                   end) total_net_pay, 
         '1' Created_Method,
         TO_DATE (SYSDATE, 'dd/mm/yyyy') Entry_Dt,
         va.holyday_leave,w.work_grp,
         va.c_l,
         va.e_l,
         va.m_l,
         e.unit_dept_no,
         0 ATTN_FINE_AMT
             
FROM emp_tbl e, v_attn va, v_working_day w, desig_tbl d
WHERE e.emp_no = va.emp_no
         AND e.unit_dept_no = va.unit_dept_no
         AND va.sal_period = w.sal_period
         AND va.unit_dept_no = w.unit_dept_no
         AND e.desig_no = d.desig_no
         AND d.work_grp = w.work_grp
         AND e.present_status <> 'T'
/


