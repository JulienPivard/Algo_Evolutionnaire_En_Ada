with A_E_P.Intervalle_P;
with A_E_P.Population_G;

pragma Elaborate_All (A_E_P.Population_G);

package A_E_P.Population_P is new A_E_P.Population_G
   (Indice_Population_T => A_E_P.Intervalle_P.Indice_T);
