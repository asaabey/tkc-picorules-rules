CLEAR SCREEN;

DECLARE
    dts_in  varchar2(4000);
    vals_in varchar2(4000);
    
    FUNCTION ascii_graph_dv (
        dts VARCHAR2,
        vals VARCHAR2
    ) RETURN VARCHAR2 AS
    y pls_integer:=120;
    x pls_integer:=1;
    x_pixels pls_integer:=36;
    y_pixels pls_integer:=12;
    x_min pls_integer:=1;
    
    str varchar2(4000):='';
    dot char(1):=' ';
    dt_tbl  tbl_type;
    val_tbl tbl_type;
    dt_x    pls_integer;
    val_y   number;
    mspan   number;
    xscale  number;
    BEGIN
        dt_tbl:=rman_pckg.splitstr(dts,' ');
        val_tbl:=rman_pckg.splitstr(vals,' ');
    

        
        mspan :=(CEIL((SYSDATE-(TO_DATE(dt_tbl(dt_tbl.COUNT), 'dd/mm/yy')))/12))+2;
        
        xscale:=x_pixels/mspan;
        WHILE y>0
        LOOP
            str:=str || lpad(y,3,' ') || ' | ';
            WHILE x<x_pixels
            LOOP
                FOR i IN 1..dt_tbl.COUNT
                LOOP
                    dt_x:=round(x_pixels-(ceil((SYSDATE-TO_DATE(dt_tbl(i), 'dd/mm/yy'))/12)*xscale),0); 
                    
                    val_y:=to_number(val_tbl(i));
                    
                    
                    IF dt_x=x THEN
                        IF val_y<y and val_y>(y-10) THEN
                            dot:='O';
                        ELSE
                            dot:=' ';
                        END IF;

                    EXIT;
                    END IF;

                END LOOP;
                str:=str || dot;
                dot:=' ';
            
                x:=x+1;
            END LOOP;
            y:=y-10;
            str:=str || chr(10);
            x:=1;
        END LOOP;    
        str:=str || rpad('    |',x_pixels+2,'_') || chr(10);
        str:=str || dt_tbl(dt_tbl.count) || rpad(' ',x_pixels-12,' ') || sysdate || chr(10);
        
        return str;
    end ascii_graph_dv;
    
        
BEGIN
    vals_in:='5 5 6 7 7 7 8 8 8 9 8 12 11 17 16 18 17 19 23 17 14 21 20 30 36 32 41 42 42 48 52 57 65 45 42 66 64 61 70 70 77 79 73 91 74 97 88';
    dts_in := '06/MAY/19 05/MAY/19 23/APR/19 22/APR/19 11/APR/19 07/MAR/19 07/FEB/19 10/JAN/19 17/DEC/18 29/NOV/18 07/NOV/18 20/AUG/18 14/JUN/18 22/FEB/18 11/FEB/18 01/FEB/18 31/JAN/18 27/OCT/17 15/JUN/17 10/APR/17 08/APR/17 30/MAR/17 28/MAR/17 27/MAR/17 25/JAN/17 12/JAN/17 04/OCT/16 21/SEP/16 20/JUN/16 14/DEC/15 17/SEP/15 22/JUN/15 07/MAY/15 14/APR/15 19/MAR/15 25/SEP/14 14/AUG/14 30/DEC/13 23/JUL/13 03/JAN/13 01/MAY/12 09/FEB/12 15/SEP/11 17/MAR/11 06/JAN/11 19/AUG/10 19/NOV/09';
    dbms_output.put_line(ascii_graph_dv(dts_in,vals_in));
   
   
    
    
END;