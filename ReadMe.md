<h1><strong>Gemeindevergleich</strong></h1>
<h4>Erstellst Du eine Studie zu einer Gemeinde und Du brauchst noch Referenzgemeinden? Evtl. arbeitest Du bei einer Gemeinde und fragst dich, mit welchen anderen Gemeinden man sich austauschen kann. Du suchst für deine Partei nach Gemeinden, die soziodemografische &Auml;hnlichkeiten haben mit deinen Hochburgen? Oder Du hast, wie ich, einfach Spass am Entdecken von Daten und neuen Orten? Dieses Gemeindevergleich-Tool, das ich mit R Shiny erstellt habe, hilft Dir dabei.</h4>
<h4>W&auml;hle im Men&uuml;punkt <strong>Gemeindevergleich</strong> einfach deine Wunschgemeinde aus den 2172 Schweizer Gemeinden aus, setzte die Gewichtung f&uuml;r die 50 vergleichbaren Variablen und entdecke welche Gemeinden am &auml;hnlichsten sind.</h4>
<h4>Im Tab &laquo;Variablen&raquo; im Men&uuml;punkt <strong>Beschreibung</strong> findest du die 50 verschiedenen Variablen, die ich f&uuml;r den Gemeindevergleich benutzte.</h4>
<h4>Im Tab &laquo;Methode&raquo; im Men&uuml;punkt <strong>Beschreibung</strong> beschreibe ich, mit welcher Methode ich die Gemeinden vergleiche.</h4>
<h4>Im Men&uuml;punkt <strong>Daten</strong> findest Du unter dem Tab &laquo;Variablen Daten&raquo; die Daten, die ich f&uuml;r die Berechnungen der R&auml;nge benutzt habe und im Tab &laquo;Rang Daten&raquo; die Rangdaten aller 2172 Gemeinden.</h4>
<h4>Falls Du Anregungen, Verbesserungsvorschl&auml;ge und/oder Fragen hast, kannst Du mich gerne per <a href="mailto:%20flavio_von_rickenbach@hotmail.com">Mail</a> oder via <a href="http://www.linkedin.com/in/flavio-von-rickenbach-12103b">LinkedIn</a> kontaktieren.</h4>
<h4>Beachte, dass das Resultat dieses Vergleichs von verschiedenen Faktoren beeinflusst werden kann und keine absoluten Aussagen zul&auml;sst. Dieses Tool kann als einfaches Hilfsmittel in verschiedenen Situationen dienen, erfordert aber je nach Fragestellung noch weitere Recherchen.</h4>
<h4>Flavio von Rickenbach, <a href="https://creativecommons.org/licenses/by/4.0/">CC-BY 4.0</a></h4>
<h1><strong>Methoden</strong></h1>
<h4>Um die Gemeinden anhand den 51 verschiedenen Variablen zu vergleiche, bilde ich f&uuml;r jede Variable R&auml;nge. Die Gemeinde mit der gr&ouml;ssten Zahl bekommt den Rang 1 (z. B. Z&uuml;rich bei den Einwohnern). Haben zwei Gemeinden die gleiche Auspr&auml;gung bei einer Variable, bekommen Sie den gleichen Rang. Die darauffolgende Gemeinde erh&auml;lt dann den &uuml;bern&auml;chsten Rang z. B. haben die Gemeinden Mutrux und Rossa die gleiche Anzahl Scheidungen pro 1000 Einwohner und zusammen den Rang 4 (die viert h&ouml;chste Zahl von Scheidungen pro 1000 Einwohner). Die nachfolgende Gemeinde Siselen folgt mit Rang 6 (die sechst h&ouml;chste Zahl von Scheidungen pro 1000 Einwohner).</h4>
<h4>Wenn Du nun deine Wunschgemeinde mit den anderen Gemeinden vergleichst, wird der Rangunterschied zwischen den Gemeinden berechnet. Dabei wird jeweils der Wert der Vergleichsgemeinden minus dem Wert der Wunschgemeinde gerechnet. Z. B. hast Du die Wunschgemeinde Schwyz ausgew&auml;hlt. Diese hat den Rang 812 bei der Bev&ouml;lkerungsdichte (811 Gemeinden haben eine h&ouml;here Bev&ouml;lkerungsdichte als Schwyz). Einsiedeln hat zum Beispiel den Rang 1161 bei dieser Variable. Nun haben die beiden Gemeinden einen Rangunterschied von 350 (1161-811). Einsiedeln liegt also&nbsp;bei der Bev&ouml;lkerungsdichte 350 R&auml;nge h&ouml;her als Schwyz (Einsiedeln ist weniger dicht besiedelt). Ein positiver Rangunterschied bedeutet, dass die Vergleichsgemeinde eine tiefere Zahl als die Wunschgemeinde bei der jeweiligen Variablen hatte und darum einen h&ouml;heren Rang. Ein negativer Rangunterschied bedeutet, dass die Vergleichsgemeinde eine gr&ouml;ssere Zahl als die Wunschgemeinde bei der jeweiligen Variablen hatte und darum einen tieferen Rang.</h4>
<h4>Die Rangunterschiede werden mit dem Gewicht, die du den jeweiligen Variablen zuordnest, multipliziert.</h4>
<h4>Der totale Rangunterschied ist dann die Summe der absoluten (das Minus vor den Zahlen wird entfernt) gewichteten Rangunterschiede der verschiedenen Variablen. Umso tiefer der Rangunterschied, um so &auml;hnlicher sind sich die Gemeinden gegeben der 51 gewichteten Variablen.</h4>
<h4>&nbsp;</h4>
<h1><strong>Variablen </strong></h1>
<h4>Das Bundesamt f&uuml;r Statistik erstellt statistische Portr&auml;ts f&uuml;r alle Gemeinden der Schweiz (<a href="https://www.bfs.admin.ch/bfs/de/home/statistiken/regionalstatistik/regionale-portraets-kennzahlen/gemeinden.html">https://www.bfs.admin.ch/bfs/de/home/statistiken/regionalstatistik/regionale-portraets-kennzahlen/gemeinden.html</a>). An den Kennzahlen, die in diesen Portr&auml;ts aufgef&uuml;hrt werden, orientiere ich mich f&uuml;r diesen Vergleich. Die aktuellen Zahlen habe ich auf dem Statistischen Atlas der Schweiz gefunden (<a href="https://www.atlas.bfs.admin.ch/de/index.html">https://www.atlas.bfs.admin.ch/de/index.html</a>). Die Daten zu den Bau- und &Ouml;V-Zonen (welche nicht in den Portr&auml;ts enthalten sind) stammen von dem Bundesamt f&uuml;r Raumentwicklung (<a href="https://www.are.admin.ch/are/de/home/raumentwicklung-und-raumplanung/grundlagen-und-daten/bauzonenstatistik-schweiz.html">https://www.are.admin.ch/are/de/home/raumentwicklung-und-raumplanung/grundlagen-und-daten/bauzonenstatistik-schweiz.html</a>).</h4>
<h4>Die Daten stammen aus unterschiedlichen Zeitr&auml;umen. Durch Fusionen von Gemeinden ergibt sich die Herausforderung, dass &auml;ltere Datenreihen zuerst bearbeitet werden m&uuml;ssen, damit Sie f&uuml;r die angepasste Anzahl Gemeinden benutzt werden k&ouml;nnen. Bei absoluten Zahlen ist dies kein Problem, da einfach die Summen der fusionierenden Gemeinden zusammengerechnet werden. <br /> Bei den relativen Zahlen zur Parteist&auml;rke bei den Wahlen 2019 und der durchschnittlichen Haushaltsgr&ouml;sse habe ich bei den fusionierten Gemeinden die Parteist&auml;rke mit der Anzahl Einwohner vor der Fusion gewichtet.<br /> Bei den relativen Zahlen zur Fl&auml;chennutzung (Siedlung, Landwirtschaft, Wald und Geh&ouml;lz, unproduktive Fl&auml;che) habe ich bei den fusionierten Gemeinden die jeweiligen Werte mit der Gesamtfl&auml;che in km<suh4>2</suh4> vor der Fusion gewichtet. <br /> Relativen Variablen wie z. B. die Bev&ouml;lkerungsdichte, von welchen ich die absoluten Zahlen habe (St&auml;ndige Wohnbev&ouml;lkerung und Fl&auml;che), berechne ich. Mehr zu den einzelnen Berechnungen der Variablen k&ouml;nnen aus dem Script auf <a href="https://github.com/fvr1210/gemeinde_vergleich/blob/master/scripts/data_cwm.R">Github</a> entnommen werden.</h4>

<table>
<tbody>
<tr>
<td width="126">
<p><strong>Variable </strong></p>
</td>
<td width="107">
<p><strong>Beobachtungsjahr</strong></p>
</td>
<td width="209">
<p><strong>Abk&uuml;rzung</strong></p>
</td>
<td width="162">
<p><strong>Quelle</strong></p>
</td>
</tr>
<tr>
<td width="126">
<p>St&auml;ndige Wohnbev&ouml;lkerung</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>stae_wb_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Entwicklung st&auml;ndige Wohnbev&ouml;lkerung</p>
</td>
<td width="107">
<p>2010 bis 2019</p>
</td>
<td width="209">
<p>ent_wb_2010_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Bev&ouml;lkerungsdichte</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>bev_dichte_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Arealstatistik der Schweiz (AREA), Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Gesamtfl&auml;che in km<sup>2</sup></p>
</td>
<td width="107">
<p>Zwischen 2004 und 2009</p>
</td>
<td width="209">
<p>gf_km2_2004_09</p>
</td>
<td width="162">
<p>BFS &ndash; Arealstatistik der Schweiz (AREA)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Siedlungsfl&auml;che in %</p>
</td>
<td width="107">
<p>Zwischen 2004 und 2009</p>
</td>
<td width="209">
<p>ant_sf_0409</p>
</td>
<td width="162">
<p>BFS &ndash; Arealstatistik der Schweiz (AREA)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Landwirtschaftsfl&auml;che in %</p>
</td>
<td width="107">
<p>Zwischen 2004 und 2009</p>
</td>
<td width="209">
<p>ant_lf_0409</p>
</td>
<td width="162">
<p>BFS &ndash; Arealstatistik der Schweiz (AREA)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Wald und Geh&ouml;lze in %</p>
</td>
<td width="107">
<p>Zwischen 2004 und 2009</p>
</td>
<td width="209">
<p>ant_wg_0409</p>
</td>
<td width="162">
<p>BFS &ndash; Arealstatistik der Schweiz (AREA)</p>
</td>
</tr>
<tr>
<td width="126">
<p>unproduktive Fl&auml;che in %</p>
</td>
<td width="107">
<p>Zwischen 2004 und 2009</p>
</td>
<td width="209">
<p>ant_upf_0409</p>
</td>
<td width="162">
<p>BFS &ndash; Arealstatistik der Schweiz (AREA)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Leerwohnungsziffer</p>
</td>
<td width="107">
<p>2020</p>
</td>
<td width="209">
<p>anteil_lw_2020</p>
</td>
<td width="162">
<p>BFS &ndash; Leerwohnungsz&auml;hlung (LWZ</p>
</td>
</tr>
<tr>
<td width="126">
<p>Neu gebaute Wohnungen pro 1000 Einwohner</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>prok_ngw_18</p>
</td>
<td width="162">
<p>BFS &ndash; Bau- und Wohnbaustatistik (B&amp;Wbs)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Durchschnittliche Haushaltsgr&ouml;sse</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>dhhg_2018</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil Wohnzonen in Bauzonen in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_Wohnzonen_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil Mischzonen in Bauzonen in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_Mischzonen_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil Zentrumszonen in Bauzonen in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_Zentrumszonen_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil &ouml;ffentliche Nutzungszonen in Bauzonen in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_&ouml;ff_Nutzungzonen_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil eingeschr&auml;nkte Bauzonen in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_einge_Bauzonen_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil Tourismus und Freizeitzonen in Bauzonen in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_Tourismus_Freizeitzonen_2017_g</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil Verkehrszonen innerhalb der Bauzonen in Bauzonen %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_Verkehrszone_in_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Anteil weitere Bauzonen in Bauzonen in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_weitere_Bauzonen_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Bauzonenfl&auml;che in &Ouml;V-G&uuml;teklasse A in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_&Ouml;V_GK_A_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Bauzonenfl&auml;che in &Ouml;V-G&uuml;teklasse B in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_&Ouml;V_GK_B_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Bauzonenfl&auml;che in &Ouml;V-G&uuml;teklasse C in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_&Ouml;V_GK_C_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Bauzonenfl&auml;che in &Ouml;V-G&uuml;teklasse D in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_&Ouml;V_GK_D_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>Bauzonenfl&auml;che in keiner-G&uuml;teklasse in %</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>ant_&Ouml;V_GK_keine_2017</p>
</td>
<td width="162">
<p>ARE &ndash; Bauzonenstatistik Schweiz</p>
</td>
</tr>
<tr>
<td width="126">
<p>St&auml;ndige ausl&auml;ndische Wohnbev&ouml;lkerung in %</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>ant_aus_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Sozialhilfequote</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>ant_sozhi_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Sozialhilfeempf&auml;ngerstatistik (SHS)</p>
</td>
</tr>
<tr>
<td width="126">
<p>St&auml;ndige Wohnbev&ouml;lkerung unter 20 Jahren in %</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>ant_u20_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>00St&auml;ndige Wohnbev&ouml;lkerung im Alter von 20 bis 39 Jahren in %</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>ant_20bis39_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>St&auml;ndige Wohnbev&ouml;lkerung im Alter von 40 bis 64 Jahren in %</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>ant_40bis64_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>St&auml;ndige Wohnbev&ouml;lkerung im Alter ab 65 Jahren in %</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>ant_ab65_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Lebendgeburten pro 1000 Einwohner</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>prok_geb_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP), Statistik der nat&uuml;rlichen Bev&ouml;lkerungsbewegung (BEVNAT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Heiraten pro 1000 Einwohner</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>prok_hei_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP), Statistik der nat&uuml;rlichen Bev&ouml;lkerungsbewegung (BEVNAT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Scheidungen pro 1000 Einwohner</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>prok_scheid_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP), Statistik der nat&uuml;rlichen Bev&ouml;lkerungsbewegung (BEVNAT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Tote pro 1000 Einwohner</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>prok_hei_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Bev&ouml;lkerung und der Haushalte (STATPOP), Statistik der nat&uuml;rlichen Bev&ouml;lkerungsbewegung (BEVNAT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Reineinkommen pro Einwohner, in Franken</p>
</td>
<td width="107">
<p>2017</p>
</td>
<td width="209">
<p>dre_17</p>
</td>
<td width="162">
<p>ESTV</p>
</td>
</tr>
<tr>
<td width="126">
<p>Besch&auml;ftigte im 1. Sektor in %</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>ant_bes1_2018</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Unternehmensstruktur (STATENT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Besch&auml;ftigte im 2. Sektor in %</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>ant_bes2_2018</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Unternehmensstruktur (STATENT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Besch&auml;ftigte im 3. Sektor in %</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>ant_bes3_2018</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Unternehmensstruktur (STATENT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Arbeitsst&auml;tten im 1. Sektor in %</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>ant_ast1_2018</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Unternehmensstruktur (STATENT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Arbeitsst&auml;tten im 2. Sektor in %</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>ant_ast2_2018</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Unternehmensstruktur (STATENT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>Arbeitsst&auml;tten im 3. Sektor in %</p>
</td>
<td width="107">
<p>2018</p>
</td>
<td width="209">
<p>ant_ast3_2018</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Unternehmensstruktur (STATENT)</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil kleine linke Parteien</p>
</td>
<td width="107">
<p>2019</p>
</td>
<td width="209">
<p>k_l_P_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil GPS</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>GPS_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil SP</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>SP_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil kleine Mitteparteien</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>k_m_P_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil CVP</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>CVP_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil BDP</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>BDP_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil FDP</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>FDP_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil kleine rechts Parteien</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>k_r_P_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
<tr>
<td width="126">
<p>W&auml;hleranteil SVP</p>
</td>
<td width="107">
<p>&nbsp;</p>
</td>
<td width="209">
<p>SVP_2019</p>
</td>
<td width="162">
<p>BFS &ndash; Statistik der Wahlen und Abstimmungen</p>
</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
