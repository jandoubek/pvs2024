import React from 'react';
import {
  Box,
  Typography,
  Stack,
} from '@mui/material';
import TripResult from './TripResult';

const TripResults = ({ trips }) => {
  return (
    <Box sx={{ p: 2 }}>
      <Typography variant="h5" gutterBottom sx={{ mb: 2 }}>
        Seznam spojů
      </Typography>
      <Stack spacing={1} sx={{ width: '100%' }}>
        {trips.trips && trips.trips.length > 0 ? (
          trips.trips.map((trip, index) => (
            <TripResult 
              key={index}
              line={trip.LinkaID}
              trip={trip.SpojID}
              placeFrom={trip.ZeStanice}
              placeTo={trip.DoStanice}
              timeFrom={trip.Odjezd}
              timeTo={trip.Prijezd}
              distance={trip.Vzdalenost}
              duration={trip.DobaJizdy}
              routePoints={trip.Trasa}
              stops={trip.PocetZastavek}
            />
          ))
        ) : (
          <Typography variant="body1">Žádné spoje.</Typography>
        )}
      </Stack>
    </Box>
  );
};

export default TripResults;
