CREATE TABLE IF NOT EXISTS Result_Table as 
SELECT F2.ou_num,
           o3.row_id,
           O3.x_holding_number,
           F3.FIO,
           F3.job_title
      FROM ORGANIZATIONS O3
           INNER JOIN
           (
               SELECT o2.row_id,
                      o2.par_ou_id,
                      F1.ou_num
                 FROM ORGANIZATIONS O2
                      INNER JOIN
                      (
                          SELECT O1.row_id,
                                 O1.par_ou_id,
                                 C.ou_num
                            FROM ORGANIZATIONS O1
                                 LEFT JOIN
                                 CONTRACTS C ON C.par_ou_id = O1.ROW_ID
                           WHERE O1.OU_TYPE_CD = "Юридическое лицо" AND 
                                 O1.cust_stat_cd = "Открыт"
                      )
                      F1 ON O2.ROW_ID = F1.PAR_OU_ID
                WHERE O2.OU_TYPE_CD = "Национальный Контракт"
           )
           F2 ON F2.PAR_OU_ID = O3.ROW_ID
           LEFT JOIN
           (
               SELECT row_id,
                      (last_name || '  ' || Fst_name || '  ' || mid_name) AS FIO,
                      job_title
                 FROM users
                GROUP BY row_id
               HAVING last_upd_orig = max(last_upd_orig) 
           )
           F3 ON O3.x_mts_national_manager_id = F3.row_id
     WHERE O3.OU_TYPE_CD = "Национальный Холдинг"
     GROUP BY O3.row_id