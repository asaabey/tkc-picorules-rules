CLEAR SCREEN;

SET SERVEROUTPUT ON;

DECLARE
    x_in   VARCHAR2(4000);
    y_in   VARCHAR2(4000);

    FUNCTION svg_graph_xy (
        xstr   VARCHAR2,
        ystr   VARCHAR2
    ) RETURN VARCHAR2 AS

        x_in_tbl   tbl_type;
        y_in_tbl   tbl_type;
        xy         VARCHAR2(4000);
        xscale     NUMBER;
        yscale     NUMBER;
        x          INTEGER;
        y          INTEGER;
        xmax       INTEGER := 600;
        ymax       INTEGER := 400;
        dt_fmt     varchar2(15):='DD/MM/YY';
    BEGIN
        x_in_tbl := rman_pckg.splitstr(x_in, ' ');
        y_in_tbl := rman_pckg.splitstr(y_in, ' ');
        xscale := xmax / round(to_date(x_in_tbl(x_in_tbl.first), dt_fmt) - to_date(x_in_tbl(x_in_tbl.last), dt_fmt));

        yscale := ymax / 150;
        FOR i IN 1..x_in_tbl.count LOOP
            x := round(to_date(x_in_tbl(i), dt_fmt) - to_date(x_in_tbl(x_in_tbl.last), dt_fmt)) * xscale;

            y := (150 - y_in_tbl(i)) * yscale;
            xy := xy
                  || x
                  || ','
                  || y
                  || ' ';
        END LOOP;

        RETURN trim(xy);
    END svg_graph_xy;

BEGIN
    x_in := '03/JUL/19 19/JUN/19 05/JUN/19 23/MAY/19 16/MAY/19 06/MAY/19 05/MAY/19 23/APR/19 22/APR/19 11/APR/19 07/MAR/19 07/FEB/19 10/JAN/19 17/DEC/18 29/NOV/18 07/NOV/18 20/AUG/18 14/JUN/18 22/FEB/18 11/FEB/18 01/FEB/18 31/JAN/18 27/OCT/17 15/JUN/17 10/APR/17 08/APR/17 30/MAR/17 28/MAR/17 27/MAR/17 25/JAN/17 12/JAN/17 04/OCT/16 21/SEP/16 20/JUN/16 14/DEC/15 17/SEP/15 22/JUN/15 07/MAY/15 14/APR/15 19/MAR/15 25/SEP/14 14/AUG/14 30/DEC/13 23/JUL/13 03/JAN/13 01/MAY/12 09/FEB/12 15/SEP/11 17/MAR/11 06/JAN/11 19/AUG/10 19/NOV/09'
    ;
    y_in := '7 4 5 5 5 5 5 6 7 7 7 8 8 7 9 8 12 11 17 15 16 17 19 23 17 14 21 20 30 36 31 40 42 41 47 52 56 65 44 41 66 64 61 69 69 77 78 72 90 74 96 88'
    ;
    dbms_output.put_line('-> xy ' || svg_graph_xy(x_in, y_in));
END;