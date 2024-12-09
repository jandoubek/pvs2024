import React, { useState } from 'react';
import { Stack, Typography, Box } from '@mui/material';

import TripResult from './TripResult'

const TripResults = ({ trips }) => {
  return (
    <Box sx={{ p: 2 }}>
      <Typography variant="h5" gutterBottom sx={{ mb: 2 }}>
        Nalezená spojení
      </Typography>
      <Stack spacing={2} sx={{ width: '100%' }}>
        {trips.trips && trips.trips.length > 0 ? (
          trips.trips.map((trip, index) => (
            <TripResult key={index} route={trip} />
          ))
        ) : (
          <Typography variant="body1">Žádné spoje nenalezeny.</Typography>
        )}
      </Stack>
    </Box>
  );
};

export default TripResults;