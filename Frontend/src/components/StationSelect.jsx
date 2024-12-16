import { Autocomplete, TextField } from '@mui/material';

const removeDiacritics = (str) => {
  return str.normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase();
};

const StationSelect = ({ label, value, onChange, options }) => {
  const getNoOptionsMessage = (inputValue) => {
    if (!inputValue || inputValue.length < 2) return "Zadejte alespoň 2 znaky";
    if (options == [] || options == null) return "Žádné zastávky nenalezeny";
    return "Žádné zastávky nenalezeny";
  };

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
        
        const searchTerm = removeDiacritics(state.inputValue);
        
        const filtered = options.filter(option => {
          const normalizedLabel = removeDiacritics(option.label);
          return normalizedLabel.includes(searchTerm);
        });
        
        return filtered.slice(0, 5);
      }}
      noOptionsText={getNoOptionsMessage(value?.inputValue || "")}
      sx={{ width: '100%' }}
      loadingText="Vyhledávám..."
    />
  );
};

export default StationSelect;