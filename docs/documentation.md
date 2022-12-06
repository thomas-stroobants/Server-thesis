# XSD date/time formats

# Structure vocabulary RT data


| Field | Type | Mapping/IRI | Needs formatting? |
| ---------- | ---------- | ---------- | ---------- |
| tripID | a gtfs:Trip | http://example.com/nmbs/trips/$(trip_id) | No? |
| trip.startDate | schema:startDate ^^xsd:date
| trip.startTime | 
| ---------- | ---------- | ---------- | ---------- |
| stopTimeUpdate.stopID |
| stopTimeUpdate.stopID.arrival |
| stopTimeUpdate.stopID.departure |