-- Tests to confirm the concave hull area is <= convex hull and
-- covers the original geometry (can't use covers because always gives topo errors with 3.3
SELECT
    'ST_ConcaveHull MultiPolygon 0.95', ST_Area(ST_Intersection(geom,ST_ConcaveHull(
        geom, 0.95) )) = ST_Area(geom) As encloses_geom,
    (ST_Area(ST_ConvexHull(geom))
        - ST_Area(ST_ConcaveHull(geom, 0.95))) < (0.95 * ST_Area(ST_ConvexHull(geom) ) ) As reached_target
FROM ST_Union(ST_GeomFromText('POLYGON((175 150, 20 40,
			50 60, 125 100, 175 150))'),
		ST_Buffer(ST_GeomFromText('POINT(110 170)'), 20)
		) As geom;

SELECT
    'ST_ConcaveHull Lines 0.80', ST_Within(geom,ST_ConcaveHull(
        geom, 0.80) ) As encloses_geom,
    (ST_Area(ST_ConvexHull(geom))
        - ST_Area(ST_ConcaveHull(geom, 0.80))) < (0.80 * ST_Area(ST_ConvexHull(geom) ) ) As reached_target

FROM ST_GeomFromText('MULTILINESTRING((106 164,30 112,74 70,82 112,130 94,
	130 62,122 40,156 32,162 76,172 88),
(132 178,134 148,128 136,96 128,132 108,150 130,
170 142,174 110,156 96,158 90,158 88),
(22 64,66 28,94 38,94 68,114 76,112 30,
132 10,168 18,178 34,186 52,184 74,190 100,
190 122,182 148,178 170,176 184,156 164,146 178,
132 186,92 182,56 158,36 150,62 150,76 128,88 118))') As geom;

-- test holes vs. no holes - holes should still enclose but have smaller area than no holes --
SELECT
    'ST_ConcaveHull Lines 0.80 holes', ST_Within(geom,ST_ConcaveHull(
        geom, 0.80, true) ) As encloses_geom,
    ST_Area(ST_ConcaveHull(geom, 0.80, true)) < ST_Area(ST_ConcaveHull(geom, 0.80)) As reached_target

FROM ST_GeomFromText('MULTILINESTRING((106 164,30 112,74 70,82 112,130 94,
	130 62,122 40,156 32,162 76,172 88),
(132 178,134 148,128 136,96 128,132 108,150 130,
170 142,174 110,156 96,158 90,158 88),
(22 64,66 28,94 38,94 68,114 76,112 30,
132 10,168 18,178 34,186 52,184 74,190 100,
190 122,182 148,178 170,176 184,156 164,146 178,
132 186,92 182,56 158,36 150,62 150,76 128,88 118))') As geom;

SELECT '#3638', abs(ST_Area(ST_Intersection(geom, ST_ConcaveHull(geom, 0.999) )) - ST_Area(geom)) < 1 As encloses_geom,
       (ST_Area(ST_ConvexHull(geom)) - ST_Area(ST_ConcaveHull(geom, 0.999))) < (0.999 * ST_Area(ST_ConvexHull(geom) ) ) As reached_target
FROM ST_GeomFromText('MULTIPOLYGON(((2224400 6861690,2226160 6865040,2226430 6867030,2225110 6867930,2224550 6868140,2222860 6868290,2224200 6870520,2224140 6871610,2224400 6871920,2224100 6872050,2223140 6873060,2223190 6873150,2222810 6873290,2222400 6873900,2221890 6875900,2222910 6876200,2223970 6876510,2224210 6875470,2225600 6872970,2226880 6872060,2227360 6871910,2228120 6870830,2228190 6870260,2229210 6869450,2229980 6869320,2233190 6870260,2233940 6870200,2236570 6869190,2238080 6869450,2239770 6870300,2240580 6870450,2242530 6870230,2243570 6869480,2244190 6869320,2246720 6869460,2248040 6869250,2249830 6869940,2250120 6869640,2251060 6869630,2253500 6870910,2254340 6870800,2258060 6871250,2259470 6871140,2260580 6871370,2263080 6871040,2263880 6871220,2265420 6870890,2266880 6870990,2267830 6870880,2268480 6870640,2269680 6869860,2270470 6869570,2270700 6869880,2271370 6870100,2271250 6870020,2271340 6868300,2270340 6867850,2270750 6867310,2271670 6867510,2272200 6867270,2272860 6867290,2272900 6867140,2272770 6866040,2273190 6865860,2273380 6861740,2272880 6861660,2272770 6861350,2272850 6860930,2273060 6860960,2273120 6860390,2272990 6860380,2272180 6859940,2271690 6860140,2271190 6859990,2270050 6859210,2269380 6859250,2269140 6858320,2268520 6858490,2268260 6857030,2268370 6855880,2269980 6855600,2270020 6855910,2270200 6855880,2270540 6855400,2270560 6855400,2270330 6854840,2269130 6855330,2269040 6854000,2268770 6854040,2268800 6853770,2267050 6853410,2264990 6853780,2264820 6852290,2263930 6852640,2263870 6852490,2262620 6852580,2262270 6851950,2261370 6851900,2260840 6850950,2262280 6850740,2263030 6850540,2263460 6850900,2263950 6850880,2263470 6846320,2263940 6846290,2264470 6845790,2264080 6844800,2263350 6845130,2262920 6844190,2263890 6843570,2263900 6843290,2264390 6843280,2264750 6843050,2267580 6843130,2267770 6841660,2268520 6841380,2269290 6843720,2270390 6843200,2270740 6844460,2272070 6844140,2272570 6843850,2271910 6841700,2272310 6841620,2271920 6839660,2274110 6839550,2273830 6840050,2273930 6840710,2273780 6841680,2273880 6842480,2274700 6842440,2274710 6842470,2274860 6842360,2275820 6843640,2277060 6843170,2277560 6843180,2278450 6842340,2280650 6843010,2280460 6841890,2280720 6841910,2280630 6841380,2280660 6841300,2280350 6841280,2279800 6840940,2279400 6840910,2278970 6840290,2279390 6839440,2279840 6839590,2280640 6839550,2280580 6838610,2280420 6838460,2280440 6837540,2280780 6835350,2279600 6835380,2280130 6833540,2280100 6833530,2280180 6833360,2280240 6833150,2280280 6833170,2280340 6833020,2280280 6832200,2279750 6832550,2278910 6833410,2277720 6834160,2275760 6834770,2273730 6834900,2273700 6834600,2273090 6834760,2272900 6835060,2273030 6835640,2272360 6835700,2271630 6834440,2271300 6832800,2270770 6831480,2270430 6831170,2270060 6829650,2272180 6829220,2271960 6825760,2270980 6825900,2271120 6825460,2269680 6825130,2269960 6824210,2268800 6823880,2268490 6824880,2265240 6824150,2265060 6825050,2265230 6828090,2264720 6827640,2262680 6827420,2262460 6829170,2261680 6827390,2261300 6827330,2261630 6826400,2261380 6826380,2261300 6825770,2260880 6825470,2260890 6825200,2258820 6826220,2256110 6826820,2256000 6826170,2256240 6824400,2256110 6823070,2255600 6822830,2255020 6821780,2254200 6821510,2254290 6821180,2254090 6821140,2250160 6821360,2249430 6820740,2248860 6820690,2247300 6821910,2246100 6823920,2244620 6825100,2244150 6825940,2244360 6826540,2244120 6827280,2242860 6826970,2241510 6826250,2239300 6825950,2238920 6826090,2239140 6826530,2236380 6827620,2235840 6828780,2235820 6829940,2236020 6830230,2235940 6830520,2235320 6831610,2234070 6832950,2233720 6833920,2233090 6834050,2233220 6836220,2235120 6842320,2234390 6843060,2233600 6843480,2230340 6844740,2230830 6846700,2229830 6846880,2228380 6847430,2225950 6847340,2224770 6847510,2222350 6848640,2222130 6849400,2221570 6850340,2221630 6851510,2221280 6851290,2219450 6852470,2219120 6854260,2219460 6854340,2219570 6855400,2220210 6856120,2220350 6856590,2220420 6856570,2224880 6860850,2224840 6861280,2224400 6861690)),((2270830 6855440,2272020 6855640,2271620 6854660,2270830 6855440)))') as geom;

\set QUIET on
SET client_min_messages TO WARNING;
drop table if exists big_polygon;
create table big_polygon(geom geometry);
alter table big_polygon alter column geom set storage main;
\copy big_polygon from 'ticket_3697.wkt'
\set QUIET off
SET client_min_messages TO NOTICE;

WITH intermediate AS
(
    SELECT ST_ConcaveHull(geom, 0.8)    as concave,
           ST_Area(ST_ConvexHull(geom)) as convex_area,
           geom                         as geom
    FROM big_polygon
)
SELECT '#3697',
        ST_Area(ST_Intersection(geom,concave)) = ST_Area(geom) As encloses_geom,
        (convex_area - ST_Area(concave) < (0.8 * convex_area)) As reached_target
FROM intermediate;

drop table big_polygon;
