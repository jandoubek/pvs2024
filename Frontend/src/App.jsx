import React, { useState } from 'react';
import { Autocomplete, TextField, Button, Box, Typography } from '@mui/material';
import './App.css';

const App = () => {
  const [from, setFrom] = useState(null);
  const [to, setTo] = useState(null);
  const [searchResult, setSearchResult] = useState('');

  // Prozatimní konstanty
  const locations = [
    { label: 'Praha' },
    { label: 'Děčín' },
    { label: 'Ostrava' }
  ];

  const handleSearch = () => {
    if (from && to) {
      setSearchResult(`Hledám spoj z: ${from.label} do: ${to.label}`);
    } else {
      setSearchResult('Prosím vyberte místo odjezdu i příjezdu.');
    }
  };

  return (
    <Box className="container">
      <Autocomplete
        options={locations}
        value={from}
        onChange={(event, newValue) => setFrom(newValue)}
        renderInput={(params) => <TextField {...params} label="Odkud" />}
        className="input-field"
      />

      <Autocomplete
        options={locations}
        value={to}
        onChange={(event, newValue) => setTo(newValue)}
        renderInput={(params) => <TextField {...params} label="Kam" />}
        className="input-field"
      />

      <Button
        variant="contained"
        color="primary"
        onClick={handleSearch}
        className="search-button"
      >
        Hledat
      </Button>

      {searchResult && (
        <Typography variant="body1" className="result-text">
          {searchResult}
        </Typography>
      )}
    </Box>
  );
};

export default App;
