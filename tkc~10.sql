DECLARE
   TYPE color_typ IS TABLE OF VARCHAR2(32);
   colors color_typ;
   i INTEGER;
BEGIN
   colors := color_typ('red','orange','yellow','green','blue','indigo','violet');

-- Using NEXT is the most reliable way to loop through all elements.
   i := colors.FIRST;  -- get subscript of first element
   WHILE i IS NOT NULL LOOP
      colors(i) := INITCAP(colors(i));
      dbms_output.put_line('COLORS(' || i || ') = ' || colors(i));
      i := colors.NEXT(i);  -- get subscript of next element
   END LOOP;

   dbms_output.put_line('Deleting yellow...');

   colors.DELETE(3); -- Remove item 3. Now the subscripts are 1,2,4,5,6,7.

-- Loop goes from 1 to 7, even though item 3 has been deleted.
   FOR i IN colors.FIRST..colors.LAST
   LOOP
      IF colors.EXISTS(i) THEN
         dbms_output.put_line('COLORS(' || i || ') still exists.');
      ELSE
         dbms_output.put_line('COLORS(' || i || ') no longer exists.');
      END IF;
   END LOOP;

   dbms_output.put_line('Deleting blue, indigo, violet...');
   colors.DELETE(5,7); -- Delete items 5 through 7.

-- Loop now goes from 1 to 4, because 4 is the highest ("last") subscript.
   FOR i IN colors.FIRST..colors.LAST LOOP
      IF colors.EXISTS(i) THEN
         dbms_output.put_line('COLORS(' || i || ') still exists.');
      ELSE
         dbms_output.put_line('COLORS(' || i || ') no longer exists.');
      END IF;
   END LOOP;
END;
/