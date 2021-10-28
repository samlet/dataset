## Description of the dataset

One file per month is provided as a csv file with the following features:

    callsign: the identifier of the flight displayed on ATC screens (usually the first three letters are reserved for an airline: AFR for Air France, DLH for Lufthansa, etc.)
    number: the commercial number of the flight, when available (the matching with the callsign comes from public open API)
    icao24: the transponder unique identification number;
    registration: the aircraft tail number (when available);
    typecode: the aircraft model type (when available);
    origin: a four letter code for the origin airport of the flight (when available);
    destination: a four letter code for the destination airport of the flight (when available);
    firstseen: the UTC timestamp of the first message received by the OpenSky Network;
    lastseen: the UTC timestamp of the last message received by the OpenSky Network;
    day: the UTC day of the last message received by the OpenSky Network;
    latitude_1, longitude_1, altitude_1: the first detected position of the aircraft;
    latitude_2, longitude_2, altitude_2: the last detected position of the aircraft.

* ⊕ [Crowdsourced air traffic data from The OpenSky Network 2020 | Zenodo](https://zenodo.org/record/5092942#.YXgV-tZByuW)
