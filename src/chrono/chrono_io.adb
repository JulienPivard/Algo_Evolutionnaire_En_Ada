package body Chrono_IO
   with Spark_Mode => On
is

   ---------------------------------------------------------------------------
   procedure Affichage_Temps
      (
         Debut : in Ada.Real_Time.Time;
         Fin   : in Ada.Real_Time.Time
      )
   is
      type Temps_Ecoule_T is range 0 .. Long_Integer'Last;

      Indentation : constant String         := "         ";
      Duree_Exact : constant Duration       :=
         Ada.Real_Time.To_Duration (TS => Fin - Debut);
      Duree       : constant Temps_Ecoule_T :=
         (if Duree_Exact > 0.0 then Temps_Ecoule_T (Duree_Exact) else 0);

      pragma Warnings
         (
            GNATprove, Off, "initialization of * has no effect",
            Reason => "La valeur par defaut des arguments n'est pas utilise"
         );
      package Duree_IO is new Ada.Text_IO.Fixed_IO   (Num => Duration);
      package Temps_IO is new Ada.Text_IO.Integer_IO (Num => Temps_Ecoule_T);
      pragma Warnings (GNATprove, On, "initialization of * has no effect");
   begin
      Ada.Text_IO.Put      (Item => Indentation);
      Duree_IO.Put         (Item => Duree_Exact, Fore => 0, Aft => 4);
      Ada.Text_IO.Put_Line (Item => " s");

      --  Affichage en minutes.
      if Duree > Une_Minutte then
         Ada.Text_IO.Put      (Item => Indentation);
         Temps_IO.Put         (Item => Duree / Une_Minutte,   Width => 0);
         Ada.Text_IO.Put      (Item => " min et ");
         Temps_IO.Put         (Item => Duree mod Une_Minutte, Width => 0);
         Ada.Text_IO.Put_Line (Item => " s");
      end if;

      --  Affichage en heures.
      if Duree > Une_Heure then
         Ada.Text_IO.Put      (Item => Indentation);
         Temps_IO.Put         (Item => Duree / Une_Heure, Width => 0);
         Ada.Text_IO.Put      (Item => " h et ");
         Temps_IO.Put
            (Item => (Duree mod Une_Heure) / Une_Minutte, Width => 0);
         Ada.Text_IO.Put_Line (Item => " m");
      end if;
   end Affichage_Temps;
   ---------------------------------------------------------------------------

end Chrono_IO;
