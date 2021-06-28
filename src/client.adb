------------------------------------------------------------------------------
--                                                                          --
--                          Auteur : PIVARD Julien                          --
--           Dernière modification : Lundi 28 juin[06] 2021
--                                                                          --
------------------------------------------------------------------------------
with Ada.Text_IO;

with GNAT.Source_Info;

with Executeur_G;

procedure Client is

   package Executeur_P is new Executeur_G
      (
         Nombre_D_Arguments_Min => 0,
         Nombre_D_Arguments_Max => 0
      );

begin

   Ada.Text_IO.Put      (Item => "+---------------------+");
   Ada.Text_IO.Put_Line (Item => " - - - - - - - - - - - ");
   Ada.Text_IO.Put      (Item => "| Date de compilation :");
   Ada.Text_IO.Put      (Item => "  ");
   Ada.Text_IO.Put      (Item => GNAT.Source_Info.Compilation_ISO_Date);
   Ada.Text_IO.Put      (Item => " ");
   Ada.Text_IO.Put_Line (Item => GNAT.Source_Info.Compilation_Time);
   Ada.Text_IO.Put      (Item => "+---------------------+");
   Ada.Text_IO.Put_Line (Item => " - - - - - - - - - - - ");

   Ada.Text_IO.New_Line (Spacing => 1);

   Executeur_P.Verifier_Nombre_D_Arguments;
   Executeur_P.Executer;

exception
   when Executeur_P.Trop_D_Arguments_E =>
      null;
   when Executeur_P.Pas_Assez_D_Arguments_E =>
      null;
   when Executeur_P.Option_Incorrect_E =>
      null;
   when Executeur_P.Valeur_Option_Incorrect_E =>
      null;

end Client;
