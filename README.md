# PRAC2 Visualització de dades: Trucades al servei d'atenció de violència de gènere de Catalunya
* Sergio Costa Planells

## Resum 

En aquesta pràctica s'ha elaborat una visualització de tipus panell de control que permet analitzar les dades relatives a les trucades al servei d'atenció de violència de gènere. El conjunt de dades original es pot descarregar del portal de dades obertes de la Generalitat de Catalunya. La resta de dades utilitzades per a la visualització provenen d'extraccions de dades de l'IDESCAT i del repositori de dades geogràfiques de Gloria Macia (https://t.co/ABQVSjo0fz)

## Arxius disponibles

**L_nia_d_atenci__contra_la_viol_ncia_masclista_900_900_120.csv.zip** -> Dades de trucades al servei d'atenció de violència de gènere. S'ha de descomprimir.

**Atencions_dels_Serveis_i_oficines_d_informaci__i_atenci__a_les_dones_i_Oficines_de_l_Institut_Catal__de_les_Dones.csv.zip** -> Joc de dades d'atencions dels Serveis i oficines d'informació i oficines de l'Institut Català de la dona. No utilitzat en la visualització però carregat i netejat en R per a ús futur. S'ha de descomprimir.

**comarques.csv** -> Llistat de comarques de Catalunya

**comarques_cat.geojson** -> Límits de comarques en format geojson (inclou Moianès), modificat del repositori de Gloria Macia (https://t.co/ABQVSjo0fz) eliminant elements innecessaris per a la visualització.

**data_cleanup.R** -> Script d'R per a netejar i arranjar els diferents conjunts de dades abans de carregar-los a Tableau.

**trucades.csv.zip** -> Dades de trucades netejades i arrenjades amb R. S'ha de descomprimir.

**Violència_genere_PRAC2.twbx** -> Workbook de Tableau amb la visualització.

**Fitxers t*.csv** Taules extretes de l'IDESCAT amb diferents dades socioeconòmiques de les comarques de Catalunya: Població, PIBC, Risc de pobresa i exclusió social, Estudis de la població, Índex socioeconòmic territorial, Demandants d’ocupació de l’atur.



