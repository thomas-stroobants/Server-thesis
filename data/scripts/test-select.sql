-- SPARQL SELECT * from <http://example.com/nmbs-rt> where {  ?s ?p ?o . FILTER(?s = <http://example.com/nmbs/stoptimes/88____%3A007%3A%3A8891702%3A8844628%3A41%3A1842%3A20230203-8892007>) } LIMIT 100;
-- SPARQL SELECT * from <http://example.com/nmbs> where {  ?s ?p ?o . FILTER(?s = <http://example.com/nmbs/stoptimes/88____%3A007%3A%3A8891702%3A8844628%3A41%3A1842%3A20230203-8892007>) } LIMIT 100;
SPARQL SELECT * from <http://example.com/nmbs> where { <http://example.com/nmbs/stoptimes/88____%3A046%3A%3A8896008%3A8892601%3A4%3A1614%3A20231208-8892601> ?p ?o . };
SPARQL SELECT * from <http://example.com/nmbs> where { <http://example.com/nmbs/stoptimes/88____%3A097%3A%3A8819406%3A8872009%3A27%3A1522%3A20231208-8814266> ?p ?o . };