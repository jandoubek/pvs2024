import React, { useState } from 'react';
import { 
  Paper, 
  Stack, 
  Typography, 
  Box, 
  IconButton, 
  Collapse,
  Dialog,
  DialogTitle,
  DialogContent,
  Button,
  Grid,
  Chip
} from '@mui/material';
import DirectionsBusIcon from '@mui/icons-material/DirectionsBus';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import KeyboardArrowUpIcon from '@mui/icons-material/KeyboardArrowUp';
import CloseIcon from '@mui/icons-material/Close';
import PrintIcon from '@mui/icons-material/Print';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import Timeline from '@mui/lab/Timeline';
import TimelineItem from '@mui/lab/TimelineItem';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineDot from '@mui/lab/TimelineDot';
import TimelineConnector from '@mui/lab/TimelineConnector';

const TimelineDialog = ({ open, onClose, routeData }) => {
  if (!routeData?.Trasa) return null;

  return (
    <Dialog 
      open={open} 
      onClose={onClose}
      maxWidth="sm"
      fullWidth
      disablePortal={false}
      aria-labelledby="timeline-dialog-title"
      PaperProps={{
        sx: { 
          minHeight: '60vh',
          maxHeight: '90vh'
        }
      }}
    >
      <DialogTitle 
        id="timeline-dialog-title"
        sx={{ 
          borderBottom: '1px solid',
          borderColor: 'divider',
          pb: 2
        }}
      >
        <Box sx={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'flex-start'
        }}>
          <Stack spacing={1}>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
              <DirectionsBusIcon color="primary" />
              <Typography variant="h6">
                {`Linka ${routeData.LinkaID}/${routeData.SpojID}`}
              </Typography>
            </Box>
            <Stack direction="row" spacing={1}>
              <Chip 
                label={`Odjezd: ${routeData.Odjezd}`} 
                size="small" 
                variant="outlined"
              />
              <Chip 
                label={`Příjezd: ${routeData.Prijezd}`} 
                size="small" 
                variant="outlined"
              />
            </Stack>
          </Stack>
          <Stack direction="row" spacing={1}>
            <IconButton 
              size="small" 
              title="Zobrazit na mapě"
              aria-label="Zobrazit na mapě"
              sx={{ 
                color: 'primary.main',
                '&:hover': { bgcolor: 'primary.50' }
              }}
            >
              <LocationOnIcon fontSize="small" />
            </IconButton>
            <IconButton 
              size="small"
              title="Vytisknout jízdní řád"
              aria-label="Vytisknout jízdní řád"
              sx={{ 
                color: 'primary.main',
                '&:hover': { bgcolor: 'primary.50' }
              }}
            >
              <PrintIcon fontSize="small" />
            </IconButton>
            <IconButton 
              onClick={onClose} 
              size="small"
              aria-label="Zavřít"
              sx={{ ml: 1 }}
            >
              <CloseIcon fontSize="small" />
            </IconButton>
          </Stack>
        </Box>
      </DialogTitle>
      <DialogContent sx={{ pt: 2 }}>
        <Timeline sx={{ 
          padding: 0,
          [`& .MuiTimelineItem-root`]: {
            minHeight: 'auto',
            '&:before': {
              display: 'none'
            }
          }
        }}>
          {routeData.Trasa.map((point, index) => (
            <TimelineItem 
              key={index}
              sx={{
                '& .MuiTimelineContent-root': {
                  pt: 0,
                  pb: 1.5
                },
                '& .MuiTimelineSeparator-root': {
                  mr: 2,
                  transform: 'translateY(6px)' // Move entire separator down
                }
              }}
            >
              <TimelineSeparator>
                <TimelineDot 
                  color={point.isActive ? "primary" : "grey"}
                  sx={{ 
                    width: '12px',
                    height: '12px',
                    my: 0,
                    opacity: point.isActive ? 1 : 0.5
                  }}
                />
              </TimelineSeparator>
              <TimelineContent>
                <Stack 
                  direction="row" 
                  spacing={2} 
                  alignItems="center"
                  sx={{ 
                    opacity: point.isActive ? 1 : 0.6,
                    minHeight: '24px'
                  }}
                >
                  <Typography 
                    variant="body2" 
                    sx={{ 
                      minWidth: '45px',
                      fontSize: '0.875rem',
                      lineHeight: 1.5
                    }}
                  >
                    {point.time}
                  </Typography>
                  <Typography 
                    sx={{ 
                      flex: 1,
                      fontSize: '0.875rem',
                      lineHeight: 1.5
                    }}
                  >
                    {point.place}
                  </Typography>
                  <Typography 
                    variant="caption" 
                    color="text.secondary"
                    sx={{ 
                      minWidth: '40px', 
                      textAlign: 'right',
                      lineHeight: 1.5
                    }}
                  >
                    {point.km} km
                  </Typography>
                </Stack>
              </TimelineContent>
            </TimelineItem>
          ))}
        </Timeline>
      </DialogContent>
    </Dialog>
  );
};

const RouteSegment = ({ segment, color, isExpanded }) => {
  if (!segment?.Trasa) return null;

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
                color={color}
                sx={{ 
                  width: '12px', 
                  height: '12px', 
                  my: 0
                }}
              />
              {index < displayPoints.length - 1 && (
                <>
                  <TimelineConnector />
                  {!isExpanded && displayPoints.length > 2 && index === 0 && (
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
  const routeData = route.PrestupStanice ? route : route.PrvniUsek;
  const [timelineOpen, setTimelineOpen] = useState(false);

  return (
    <Paper 
    elevation={1} 
    sx={{ 
      width: '100%', 
      maxWidth: '800px', 
      mx: 'auto', 
      bgcolor: '#fff',
      '&:hover': {
        bgcolor: 'rgba(0, 0, 0, 0.01)'
      }
    }}
  >
    {/* Compact header */}
    <Box sx={{ 
      p: 2,
      display: 'flex',
      justifyContent: 'space-between',
      borderBottom: '1px solid',
      borderColor: 'divider',
      bgcolor: 'rgba(25, 118, 210, 0.03)'
    }}>
      <Stack direction="row" spacing={2} alignItems="center">
        <Typography variant="h6" sx={{ width: '60px', fontWeight: 500 }}>
          {routeData.Odjezd}
        </Typography>
        <Typography sx={{ color: 'text.secondary', mr: 1 }}>
          {route.Datum}
        </Typography>
        <Button
          startIcon={<DirectionsBusIcon sx={{ fontSize: '1.2rem' }} />}
          onClick={() => setTimelineOpen(true)}
          sx={{ 
            textTransform: 'none',
            '&:hover': {
              backgroundColor: 'rgba(25, 118, 210, 0.08)'
            }
          }}
        >
          {`${routeData.LinkaID}/${routeData.SpojID}`}
        </Button>
      </Stack>
      <Typography 
        variant="body2" 
        sx={{ 
          bgcolor: 'primary.50',
          color: 'primary.main',
          px: 1.5,
          py: 0.5,
          borderRadius: 1,
          fontSize: '0.875rem'
        }}
      >
        {`${route.CelkovaDobaJizdy} min`}
      </Typography>
    </Box>

      {/* Stations */}
      <Box sx={{ p: 2 }}>
        <Stack direction="row" spacing={3} alignItems="center">
          <Box>
            <Typography variant="body2" color="text.secondary">
              {routeData.ZeStanice}
            </Typography>
            <Typography variant="h6">
              {routeData.Odjezd}
            </Typography>
          </Box>
          <Box sx={{ flex: 1 }}>
            <Typography variant="body2" color="text.secondary">
              {routeData.DoStanice}
            </Typography>
            <Typography variant="h6">
              {routeData.Prijezd}
            </Typography>
          </Box>
        </Stack>

        {/* Details button */}
        <Box 
          onClick={() => setExpanded(!expanded)}
          sx={{ 
            mt: 2,
            display: 'flex',
            alignItems: 'center',
            cursor: 'pointer',
            color: 'primary.main'
          }}
        >
          <Typography variant="body2" sx={{ mr: 1 }}>
            Detaily spojení
          </Typography>
          <IconButton size="small">
            {expanded ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
          </IconButton>
        </Box>

        {/* Expandable content */}
        <Collapse in={expanded}>
          <Box sx={{ mt: 2, p: 2, bgcolor: 'grey.50', borderRadius: 1 }}>
            <Grid container spacing={2} sx={{ mb: 3 }}>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">Vzdálenost</Typography>
                <Typography variant="body1">{route.CelkovaVzdalenost} km</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="caption" color="text.secondary">Doba jízdy</Typography>
                <Typography variant="body1">{route.CelkovaDobaJizdy} min</Typography>
              </Grid>
            </Grid>

            {hasTransfer ? (
              <>
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
                  segment={routeData}
                  color="primary" 
                  isExpanded={expandedSegments.first}
                />
              </Box>
            )}
          </Box>
          </Collapse>
      </Box>
      <TimelineDialog 
        open={timelineOpen}
        onClose={() => setTimelineOpen(false)}
        routeData={routeData}
      />
    </Paper>
  );
};

export default TripResult;

