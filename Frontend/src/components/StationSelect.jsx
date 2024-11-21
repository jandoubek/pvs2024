import { Autocomplete, TextField } from '@mui/material';

const StationSelect = ({ label, value, onChange, options }) => {
  return (
    <Autocomplete
      options={options || []}
      value={value}
      onChange={onChange}
      renderInput={(params) => <TextField {...params} label={label} />}
      sx={{ flexGrow: 1, width: '200px' }}
    />
  );
};

export default StationSelect;