import React, { useState } from 'react';
import { Paper, Stack, Chip, Typography, Box, IconButton, Collapse, Grid } from '@mui/material';
import DirectionsBusIcon from '@mui/icons-material/DirectionsBus';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import KeyboardArrowUpIcon from '@mui/icons-material/KeyboardArrowUp';
import Timeline from '@mui/lab/Timeline';
import TimelineItem from '@mui/lab/TimelineItem';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineDot from '@mui/lab/TimelineDot';
import TimelineConnector from '@mui/lab/TimelineConnector';

const TripDisplay = ({
  line,
  trip,
  placeFrom,
  placeTo,
  timeFrom,
  timeTo,
  distance,
  stops,
  duration,
  price,
  routePoints = [
    { time: '14:30', place: 'Praha hl.n.', km: 0 },
    { time: '14:45', place: 'Praha-Libeň', km: 4 },
    { time: '15:15', place: 'Kolín', km: 62 },
    { time: '15:45', place: 'Pardubice hl.n.', km: 104 }
  ]
}) => {
  const [expanded, setExpanded] = useState(false);

  return (
    <Paper
      elevation={1}
      sx={{
        p: 3,
        width: '100%',
        maxWidth: '800px',
        mx: 'auto',
        backgroundColor: '#fff',
      }}
    >
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

      <Box sx={{ display: 'grid', gridTemplateColumns: 'auto 1fr', gap: 3 }}>
        <Box>
          <Typography variant="caption" color="text.secondary">
            Odjezd
          </Typography>
          <Typography variant="h6" sx={{ mt: 0.5 }}>
            {timeFrom}
          </Typography>
          <Typography variant="body1" sx={{ mt: 0.5 }}>
            {placeFrom}
          </Typography>
        </Box>

        <Box>
          <Typography variant="caption" color="text.secondary">
            Příjezd
          </Typography>
          <Typography variant="h6" sx={{ mt: 0.5 }}>
            {timeTo}
          </Typography>
          <Typography variant="body1" sx={{ mt: 0.5 }}>
            {placeTo}
          </Typography>
        </Box>
      </Box>

      <Box sx={{ mt: 3 }}>
        <Stack
          direction="row"
          spacing={1}
          alignItems="center"
          onClick={() => setExpanded(!expanded)}
          sx={{ cursor: 'pointer' }}
        >
          <Typography color="primary">Detail spoje</Typography>
          <IconButton size="small">
            {expanded ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
          </IconButton>
        </Stack>

        <Collapse in={expanded}>
          <Box sx={{ mt: 2, p: 2, bgcolor: 'grey.50', borderRadius: 1 }}>
            <Grid container spacing={2}>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">
                  Vzdálenost
                </Typography>
                <Typography variant="body1">
                  {distance} km
                </Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">
                  Doba jízdy
                </Typography>
                <Typography variant="body1">
                  {duration} min
                </Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">
                  Cena
                </Typography>
                <Typography variant="body1">
                  {price} TODO Kč
                </Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">
                  Počet zastávek
                </Typography>
                <Typography variant="body1">
                  {stops}
                </Typography>
              </Grid>
            </Grid>

            <Box sx={{ mt: 3 }}>
              <Typography variant="subtitle2" sx={{ mb: 2 }}>Trasa:</Typography>
              <Timeline sx={{ 
                padding: 0,
                [`& .MuiTimelineItem-root`]: {
                  minHeight: 'auto',
                  '&:before': {
                    display: 'none'
                  }
                }
              }}>
                {routePoints.map((point, index) => (
                  <TimelineItem key={index}>
                    <TimelineSeparator>
                      {/* <TimelineDot color={index === 0 ? "primary" : index === routePoints.length - 1 ? "secondary" : "grey"} /> */}
                      <TimelineDot color={point.inRoute === 1 ? "primary" : "grey"} />
                      {index < routePoints.length - 1 && <TimelineConnector />}
                    </TimelineSeparator>
                    <TimelineContent>
                      <Stack direction="row" spacing={2} alignItems="baseline">
                        <Typography variant="body2" sx={{ minWidth: '50px' }}>
                          {point.time}
                        </Typography>
                        <Typography>{point.place}</Typography>
                        <Typography variant="caption" color="text.secondary">
                          {point.km} km
                        </Typography>
                      </Stack>
                    </TimelineContent>
                  </TimelineItem>
                ))}
              </Timeline>
            </Box>
          </Box>
        </Collapse>
      </Box>
    </Paper>
  );
};


export default TripDisplay;