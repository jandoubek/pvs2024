import { Box, IconButton } from '@mui/material';
import SwapVertIcon from '@mui/icons-material/SwapVert';
import StationSelect from './StationSelect';

const StationSelector = ({ 
  fromStation, 
  toStation, 
  onFromStationChange, 
  onToStationChange, 
  onSwapStations, 
  stations 
}) => {
  return (
    <Box 
      sx={{ 
        display: 'flex', 
        flexDirection: 'column', 
        alignItems: 'center', 
        gap: 1,
        width: '100%'
      }}
    >
      <StationSelect
        label="Odkud"
        value={fromStation}
        onChange={onFromStationChange}
        options={stations}
        sx={{ width: '100%' }}
      />
      <IconButton
        onClick={onSwapStations}
        color="primary"
        aria-label="swap stations"
        sx={{
          border: '1px solid rgba(0, 0, 0, 0.2)',
          backgroundColor: '#fff',
          my: 1,
          '&:hover': {
            backgroundColor: 'rgba(0, 0, 0, 0.04)'
          }
        }}
      >
        <SwapVertIcon />
      </IconButton>
      <StationSelect
        label="Kam"
        value={toStation}
        onChange={onToStationChange}
        options={stations}
        sx={{ width: '100%' }}
      />
    </Box>
  );
};

export default StationSelector;