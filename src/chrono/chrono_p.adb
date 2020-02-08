with Ada.Text_IO;

package body Chrono_P
   with Spark_Mode => Off
is

   ---------------------------------------------------------------------------
   procedure Affichage_Temps
      (
         Debut : in Ada.Real_Time.Time;
         Fin   : in Ada.Real_Time.Time
      )
   is
      use type Ada.Real_Time.Time;

      type Temps_T is new Natural;

      Duree_Exact : constant Duration  :=
         Ada.Real_Time.To_Duration (TS => Fin - Debut);
      Duree       : constant Temps_T   := Temps_T (Duree_Exact);
      Minuttes    : constant Temps_T   := 60;
      Indentation : constant String    := "         ";

      package Duree_IO is new Ada.Text_IO.Fixed_IO   (Duration);
      package Temps_IO is new Ada.Text_IO.Integer_IO (Temps_T);
   begin
      Ada.Text_IO.Put      (Item => Indentation);
      Duree_IO.Put         (Item => Duree_Exact, Fore => 0, Aft => 4);
      Ada.Text_IO.Put_Line (Item => " s");

      --  Affichage en minutes.
      if Duree_Exact > 60.0 then
         Ada.Text_IO.Put      (Item => Indentation);
         Temps_IO.Put         (Item => Duree / Minuttes,   Width => 0);
         Ada.Text_IO.Put      (Item => " min et ");
         Temps_IO.Put         (Item => Duree mod Minuttes, Width => 0);
         Ada.Text_IO.Put_Line (Item => " s");
      end if;

      --  Affichage en heures.
      if Duree_Exact > 3600.0 then
         Decoupage_En_Heures :
         declare
            Heures : constant Temps_T := 3600;
         begin
            Ada.Text_IO.Put (Item => Indentation);
            Temps_IO.Put    (Item => Duree / Heures,   Width => 0);
            Ada.Text_IO.Put (Item => " h et ");
            Temps_IO.Put
               (Item => (Duree mod Heures) / Minuttes, Width => 0);
            Ada.Text_IO.Put_Line (Item => " m");
         end Decoupage_En_Heures;
      end if;
   end Affichage_Temps;
   ---------------------------------------------------------------------------

end Chrono_P;