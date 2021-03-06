\pset tuples_only on
\set degs 90.45
\set rads 1.57865030842887
\set epsilon 0.0000000000001
\set uniedge '\'1180326b885fffff\'::h3index'

--
-- TEST h3_point_dist
--

\set lyon POINT(4.8422, 45.7597)
\set paris POINT(2.3508, 48.8567)
SELECT h3_point_dist(:lyon, :paris, 'rads') - 0.0615628186794217 < :epsilon;
SELECT h3_point_dist(:lyon, :paris, 'm') - 392217.1598841777 < :epsilon;
SELECT h3_point_dist(:lyon, :paris, 'km') - 392.21715988417765 < :epsilon;

-- test that 'km' is the default unit
SELECT h3_point_dist(:lyon, :paris, 'km') = h3_point_dist(:lyon, :paris);

--
-- TEST h3_hex_area
--

SELECT h3_hex_area(10, 'm') = 15047.5;
SELECT h3_hex_area(10, 'km') = 0.0150475;
SELECT h3_hex_area(10, 'km') = h3_hex_area(10);

--
-- TEST h3_cell_area
--

\set expected_km2 0.01119834221989390
SELECT abs((h3_cell_area(h3_geo_to_h3(POINT(0, 0), 10), 'm^2') / 1000000) - :expected_km2) < :epsilon;
SELECT abs(h3_cell_area(h3_geo_to_h3(POINT(0, 0), 10), 'km^2') - :expected_km2) < :epsilon;
SELECT h3_cell_area(h3_geo_to_h3(POINT(0, 0), 10), 'rads^2') > 0;

-- default is km^2
SELECT h3_cell_area(h3_geo_to_h3(POINT(0, 0), 10), 'km^2') = h3_cell_area(h3_geo_to_h3(POINT(0, 0), 10));

--
-- TEST h3_edge_length
--

SELECT h3_edge_length(10, 'm') = 65.90780749;
SELECT h3_edge_length(10, 'km') = 0.065907807;
SELECT h3_edge_length(10, 'km') = h3_edge_length(10);

--
-- TEST h3_exact_edge_length
--

SELECT h3_exact_edge_length(:uniedge, 'rads') > 0;
SELECT h3_exact_edge_length(:uniedge, 'km') > h3_exact_edge_length(:uniedge, 'rads');
SELECT h3_exact_edge_length(:uniedge, 'm') > h3_exact_edge_length(:uniedge, 'km');

SELECT h3_exact_edge_length(:uniedge) = h3_exact_edge_length(:uniedge, 'km');


--
-- TEST h3_num_hexagons
--

SELECT h3_num_hexagons(0) = 122;
SELECT h3_num_hexagons(15) = 569707381193162;

--
-- TEST h3_get_res_0_indexes
--

SELECT COUNT(*) = 122 FROM (SELECT h3_get_res_0_indexes()) q;

--
-- TEST h3_get_pentagon_indexes
--

SELECT COUNT(*) = 12 FROM (SELECT h3_get_pentagon_indexes(6)) q; 