import { Autocomplete, TextField } from '@mui/material';

const StationSelect = ({ label, value, onChange, options }) => {

  return (
    <Autocomplete
      options={options || []}
      value={value}
      onChange={onChange}
      renderInput={(params) => <TextField {...params} label={label} />}
      ListboxProps={{
        sx: { maxHeight: '200px' }
      }}
      filterOptions={(options, state) => {
        if (state.inputValue.length < 2) {
          return [];
        }
        
        const filtered = options.filter(option => 
          option.label.toLowerCase().includes(state.inputValue.toLowerCase())
        );
        return filtered.slice(0, 5); //omezení počtu navrhovaných zastávek
      }}
      sx={{ width: '100%' }}
      loadingText="Vyhledávám..."
    />
  );
};

export default StationSelect;