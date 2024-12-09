import React, { useState } from 'react';
import { Paper, Stack, Chip, Typography, Box, IconButton, Collapse, Grid } from '@mui/material';
import DirectionsBusIcon from '@mui/icons-material/DirectionsBus';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import KeyboardArrowUpIcon from '@mui/icons-material/KeyboardArrowUp';
import { CompareArrows } from '@mui/icons-material';
import Timeline from '@mui/lab/Timeline';
import TimelineItem from '@mui/lab/TimelineItem';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineDot from '@mui/lab/TimelineDot';
import TimelineConnector from '@mui/lab/TimelineConnector';

// const RouteSegment = ({ segment, color }) => {
//   if (!segment?.Trasa) return null;

//   return (
//     <Timeline sx={{ 
//       padding: 0,
//       [`& .MuiTimelineItem-root`]: {
//         minHeight: 'auto',
//         '&:before': {
//           display: 'none'
//         }
//       }
//     }}>
//       {segment.Trasa.map((point, index) => (
//         <TimelineItem key={index}>
//           <TimelineSeparator>
//             <TimelineDot 
//               color={point.isActive ? color : "grey"} 
//               sx={{ 
//                 width: '12px', 
//                 height: '12px', 
//                 my: 0,
//                 opacity: point.isActive ? 1 : 0.5
//               }}
//             />
//             {index < segment.Trasa.length - 1 && (
//               <TimelineConnector sx={{ 
//                 opacity: point.isActive ? 1 : 0.3
//               }} />
//             )}
//           </TimelineSeparator>
//           <TimelineContent>
//             <Stack 
//               direction="row" 
//               spacing={2} 
//               alignItems="baseline"
//               sx={{ opacity: point.isActive ? 1 : 0.6 }}
//             >
//               <Typography variant="body2" sx={{ minWidth: '50px' }}>
//                 {point.time}
//               </Typography>
//               <Typography>{point.place}</Typography>
//               <Typography variant="caption" color="text.secondary">
//                 {point.km} km
//               </Typography>
//             </Stack>
//           </TimelineContent>
//         </TimelineItem>
//       ))}
//     </Timeline>
//   );
// };

const RouteSegment = ({ segment, color, isExpanded }) => {
  if (!segment?.Trasa) return null;

  // Filter active points and always get first and last active points
  const activePoints = segment.Trasa.filter(point => point.isActive);
  const displayPoints = isExpanded 
    ? segment.Trasa 
    : [activePoints[0], activePoints[activePoints.length - 1]].filter(Boolean);

  return (
    <Timeline sx={{ 
      padding: 0,
      [`& .MuiTimelineItem-root`]: {
        minHeight: 'auto',
        '&:before': {
          display: 'none'
        }
      }
    }}>
      {displayPoints.map((point, index) => (
        <TimelineItem key={index}>
          <TimelineSeparator>
            <TimelineDot 
              color={point.isActive ? color : "grey"} 
              sx={{ 
                width: '12px', 
                height: '12px', 
                my: 0,
                opacity: point.isActive ? 1 : 0.5
              }}
            />
            {index < displayPoints.length - 1 && (
              <>
                <TimelineConnector sx={{ 
                  opacity: point.isActive ? 1 : 0.3
                }} />
                {!isExpanded && activePoints.length > 2 && index === 0 && (
                  <Typography variant="caption" sx={{ 
                    position: 'absolute',
                    left: '50%',
                    transform: 'translateX(-50%)',
                    color: 'text.secondary'
                  }}>
                    ...
                  </Typography>
                )}
              </>
            )}
          </TimelineSeparator>
          <TimelineContent>
            <Stack 
              direction="row" 
              spacing={2} 
              alignItems="baseline"
              sx={{ opacity: point.isActive ? 1 : 0.6 }}
            >
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
  );
};

const TripResult = ({ route }) => {
  const [expanded, setExpanded] = useState(false);
  const [expandedSegments, setExpandedSegments] = useState({
    first: false,
    second: false
  });

  const hasTransfer = !!route.PrestupStanice;

  return (
    <Paper elevation={1} sx={{ p: 3, width: '100%', maxWidth: '800px', mx: 'auto', bgcolor: '#fff' }}>
      {/* Header and main info remain the same */}
      <Stack direction="row" spacing={2} alignItems="center" sx={{ mb: 3 }}>
        <DirectionsBusIcon color="primary" />
        {hasTransfer ? (
          <>
            <Chip label={`Linka ${route.PrvniUsek.LinkaID}`} color="primary" variant="outlined" />
            <CompareArrows sx={{ fontSize: '1rem' }} />
            <Chip label={`Linka ${route.DruhyUsek.LinkaID}`} color="secondary" variant="outlined" />
          </>
        ) : (
          <Chip label={`Linka ${route.LinkaID}`} color="primary" variant="outlined" />
        )}
      </Stack>

      <Box sx={{ display: 'grid', gridTemplateColumns: 'auto 1fr', gap: 3 }}>
        {/* Main times and stations section remains the same */}
        <Box>
          <Typography variant="caption" color="text.secondary">Odjezd</Typography>
          <Typography variant="h6" sx={{ mt: 0.5 }}>
            {route.Odjezd || route.PrvniUsek?.Odjezd}
          </Typography>
          <Typography variant="body1" sx={{ mt: 0.5 }}>
            {route.ZeStanice || route.PrvniUsek?.ZeStanice}
          </Typography>
        </Box>
        <Box>
          <Typography variant="caption" color="text.secondary">Příjezd</Typography>
          <Typography variant="h6" sx={{ mt: 0.5 }}>
            {route.Prijezd || route.DruhyUsek?.Prijezd}
          </Typography>
          <Typography variant="body1" sx={{ mt: 0.5 }}>
            {route.DoStanice}
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
          <Typography color="primary">Detaily</Typography>
          <IconButton size="small">
            {expanded ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
          </IconButton>
        </Stack>

        <Collapse in={expanded}>
          <Box sx={{ mt: 2, p: 2, bgcolor: 'grey.50', borderRadius: 1 }}>
            <Grid container spacing={2} sx={{ mb: 3 }}>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">Vzdálenost</Typography>
                <Typography variant="body1">{route.CelkovaVzdalenost || 0} km</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">Doba jízdy</Typography>
                <Typography variant="body1">{route.CelkovaDobaJizdy || 0} min</Typography>
              </Grid>
            </Grid>

            {hasTransfer ? (
              <>
                {/* First segment with its own expand/collapse */}
                <Box>
                  <Stack
                    direction="row"
                    spacing={1}
                    alignItems="center"
                    onClick={() => setExpandedSegments(prev => ({ ...prev, first: !prev.first }))}
                    sx={{ cursor: 'pointer', mb: 1 }}
                  >
                    <Typography variant="body2" color="primary">
                      {expandedSegments.first ? 'Méně zastávek' : 'Více zastávek'}
                    </Typography>
                    <IconButton size="small" color="primary">
                      {expandedSegments.first ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
                    </IconButton>
                  </Stack>
                  <RouteSegment 
                    segment={route.PrvniUsek} 
                    color="primary" 
                    isExpanded={expandedSegments.first}
                  />
                </Box>

                {/* Second segment with its own expand/collapse */}
                <Box>
                  <Stack
                    direction="row"
                    spacing={1}
                    alignItems="center"
                    onClick={() => setExpandedSegments(prev => ({ ...prev, second: !prev.second }))}
                    sx={{ cursor: 'pointer', mb: 1 }}
                  >
                    <Typography variant="body2" color="secondary">
                      {expandedSegments.second ? 'Méně zastávek' : 'Více zastávek'}
                    </Typography>
                    <IconButton size="small" color="secondary">
                      {expandedSegments.second ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
                    </IconButton>
                  </Stack>
                  <RouteSegment 
                    segment={route.DruhyUsek} 
                    color="secondary" 
                    isExpanded={expandedSegments.second}
                  />
                </Box>
              </>
            ) : (
              <Box>
                <Stack
                  direction="row"
                  spacing={1}
                  alignItems="center"
                  onClick={() => setExpandedSegments(prev => ({ ...prev, first: !prev.first }))}
                  sx={{ cursor: 'pointer', mb: 1 }}
                >
                  <Typography variant="body2" color="primary">
                    {expandedSegments.first ? 'Méně zastávek' : 'Více zastávek'}
                  </Typography>
                  <IconButton size="small" color="primary">
                    {expandedSegments.first ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
                  </IconButton>
                </Stack>
                <RouteSegment 
                  segment={route} 
                  color="primary" 
                  isExpanded={expandedSegments.first}
                />
              </Box>
            )}
          </Box>
        </Collapse>
      </Box>
    </Paper>
  );
};

export default TripResult;