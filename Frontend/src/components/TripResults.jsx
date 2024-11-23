import React from 'react';
import {
  Box,
  Paper,
  Typography,
  Stack,
  Chip,
} from '@mui/material';
import DirectionsBusIcon from '@mui/icons-material/DirectionsBus';

const TripDisplay = ({ 
  line,
  trip,
  placeFrom,
  placeTo,
  timeFrom,
  timeTo 
}) => {
  const formatTime = (timeStr) => {
    return new Date(timeStr).toLocaleTimeString('cs-CZ', {
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <Paper 
      elevation={1}
      sx={{ 
        p: 3,
        maxWidth: 600,
        mx: 'auto',
        backgroundColor: '#fff',
      }}
    >
      {/* Header with line and trip number */}
      <Stack 
        direction="row" 
        spacing={2} 
        alignItems="center" 
        sx={{ mb: 3 }}
      >
        <DirectionsBusIcon color="primary" />
        <Chip 
          label={`Linka ${line}`} 
          color="primary" 
          variant="outlined"
        />
        <Typography variant="subtitle1" color="text.secondary">
          Spoj {trip}
        </Typography>
      </Stack>

      {/* Main content */}
      <Box sx={{ display: 'grid', gridTemplateColumns: 'auto 1fr', gap: 3 }}>
        {/* Departure */}
        <Box>
          <Typography variant="caption" color="text.secondary">
            Odjezd
          </Typography>
          <Typography variant="h6" sx={{ mt: 0.5 }}>
            {formatTime(timeFrom)}
          </Typography>
          <Typography variant="body1" sx={{ mt: 0.5 }}>
            {placeFrom}
          </Typography>
        </Box>

        {/* Arrival */}
        <Box>
          <Typography variant="caption" color="text.secondary">
            Příjezd
          </Typography>
          <Typography variant="h6" sx={{ mt: 0.5 }}>
            {formatTime(timeTo)}
          </Typography>
          <Typography variant="body1" sx={{ mt: 0.5 }}>
            {placeTo}
          </Typography>
        </Box>
      </Box>
    </Paper>
  );
};

const TripResults = ({ data }) => {
  const mockData = {
    line: "R41",
    trip: "5521",
    placeFrom: "Praha hl.n.",
    placeTo: "Pardubice hl.n.",
    timeFrom: "2024-11-23T10:30:00",
    timeTo: "2024-11-23T11:45:00"
  };

  return (
    <Box sx={{ p: 2 }}>
      <Typography variant="h5" gutterBottom sx={{ mb: 3 }}>
        Detail spoje
      </Typography>
      <TripDisplay {...mockData} />
    </Box>
  );
};

export default TripResults;