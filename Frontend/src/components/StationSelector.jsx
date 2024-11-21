import { Box, IconButton } from '@mui/material';
import SwapHorizIcon from '@mui/icons-material/SwapHoriz';
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
    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
      <StationSelect
        label="Odkud"
        value={fromStation}
        onChange={onFromStationChange}
        options={stations}
      />
      <IconButton
        onClick={onSwapStations}
        color="primary"
        aria-label="swap stations"
        sx={{
          border: '1px solid rgba(0, 0, 0, 0.2)',
          backgroundColor: '#fff',
        }}
      >
        <SwapHorizIcon />
      </IconButton>
      <StationSelect
        label="Kam"
        value={toStation}
        onChange={onToStationChange}
        options={stations}
      />
    </Box>
  );
};

export default StationSelector;