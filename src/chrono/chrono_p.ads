with Ada.Real_Time;

--  @summary
--  Facilité lié au temps.
--  @description
--  Regroupe des facilité lié au temps.
--  @group Temps
package Chrono_P
   with
      Pure           => False,
      Preelaborate   => False,
      Elaborate_Body => True,
      Spark_Mode     => Off
is

   procedure Affichage_Temps
      (
         Debut : in Ada.Real_Time.Time;
         Fin   : in Ada.Real_Time.Time
      );
   --  Affichage formaté du temps écoulé.
   --  @param Debut
   --  Le temps de début.
   --  @param Fin
   --  Le temps de fin.

end Chrono_P;
