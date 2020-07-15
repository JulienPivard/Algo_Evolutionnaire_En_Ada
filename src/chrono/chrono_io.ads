with Ada.Text_IO;
with Ada.Real_Time;

--  @summary
--  Facilité lié au temps.
--  @description
--  Regroupe des facilité lié au temps.
--  @group Temps
package Chrono_IO
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => On
is

   use type Ada.Real_Time.Time;

   procedure Affichage_Temps
      (
         Debut : in Ada.Real_Time.Time;
         Fin   : in Ada.Real_Time.Time
      )
      with
         Global  => (In_Out => Ada.Text_IO.File_System),
         Pre     => Debut <= Fin;
   --  Affichage formaté du temps écoulé.
   --  @param Debut
   --  Le temps de début.
   --  @param Fin
   --  Le temps de fin.

private

   Une_Minutte : constant := 60;
   Une_Heure   : constant := 3600;

end Chrono_IO;
