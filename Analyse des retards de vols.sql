/*
Le projet utilise un fichier de données (DelayedFlights.csv) pour étudier les causes des retards, identifier les compagnies et aéroports les plus affectés, suivre l’évolution des retards dans le temps, et établir un classement des compagnies aériennes selon leur ponctualité. 
L’analyse s’appuie sur des requêtes SQL pour extraire des indicateurs clés et faciliter la prise de décision dans le secteur aérien.
Source : [https://www.kaggle.com/datasets/giovamata/airlinedelaycauses)](https://www.kaggle.com/datasets/giovamata/airlinedelaycauses
*/

--Q1. Quelles compagnies aériennes ont causé le plus de retards ?
SELECT 
    Airline, 
    SUM(CarrierDelay + WeatherDelay + NASDelay + SecurityDelay + LateAircraftDelay) AS total_retard
FROM flights
GROUP BY Airline
ORDER BY total_retard DESC;

Ces données permettent à un gestionnaire d’aéroport ou une compagnie partenaire de décider s’il faut éviter certains créneaux ou alliances.

--Q2. Quels aéroports d’origine ont les plus mauvais scores météo ?
SELECT Origin,
       COUNT(*) AS nb_vols,
       SUM(WeatherDelay) AS total_meteo_delay
FROM flights
GROUP BY Origin
ORDER BY total_meteo_delay DESC
LIMIT 5;

Ces données permettent de prévoir les reports ou retards potentiels lors de tempêtes ou hivers neigeux.

--Q3. Classer les compagnies selon leur retard
SELECT 
    Airline,
    SUM(CarrierDelay) AS retard_carrier,
    RANK() OVER (ORDER BY SUM(CarrierDelay) DESC) AS rang_retard
FROM flights
GROUP BY Airline;

En calculant le total de retard pour chaque compagnie, je peux réaliser un classement qui sera intégré dans un rapport qualité fournisseur.

--Q4. Comment évoluent les retards au fil du temps ?
WITH retards_par_mois AS (
    SELECT 
        Year,
        Month,
        ROUND(AVG(CarrierDelay), 2) AS avg_delay
    FROM flights
    GROUP BY Year, Month
)

SELECT *,
       LAG(avg_delay) OVER (ORDER BY Year, Month) AS mois_prec,
       avg_delay - LAG(avg_delay) OVER (ORDER BY Year, Month) AS diff
FROM retards_par_mois;

Cette requete complexe permet de détecter les mois ou années problématiques pour la ponctualité, utile pour les dashboards.
