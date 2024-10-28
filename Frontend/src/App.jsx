import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { 
  Autocomplete, 
  TextField, 
  Button, 
  Box, 
  Typography 
} from '@mui/material';
import './App.css';

const API_BASE_URL = 'http://localhost:52773/csp/user';

const App = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [fromStation, setFromStation] = useState(null);
  const [toStation, setToStation] = useState(null);
  const [searchResult, setSearchResult] = useState('');

  React.useEffect(() => {
    loadStations();
  }, [])

  const loadStations = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.get(`${API_BASE_URL}/data`);
      setData(response.data);
    } catch (err) {
      setError(err.response?.data?.error || 'Error fetching data from the API');
      console.error('API Error:', err.response?.data || err.message);
    } finally {
      setLoading(false);
    }
  }

  // Prozatimní konstanty
  const locations = [
    { label: 'Praha' },
    { label: 'Děčín' },
    { label: 'Ostrava' }
  ];

  const handleSearch = () => {
    if (fromStation && toStation) {
      setSearchResult(`Hledám spoj z: ${fromStation.label} do: ${toStation.label}`);
    } else {
      setSearchResult('Prosím vyberte místo odjezdu i příjezdu.');
    }
  };

  return (
    <Box className="container">
      <Autocomplete
        // options={locations}
        options={data?.stations || []}
        value={fromStation}
        onChange={(event, newValue) => setFromStation(newValue)}
        renderInput={(params) => <TextField {...params} label="Odkud" />}
        className="input-field"
      />

      <Autocomplete
        // options={locations}
        options={data?.stations || []}
        value={toStation}
        onChange={(event, newValue) => setToStation(newValue)}
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
